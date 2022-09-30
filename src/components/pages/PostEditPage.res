let {string, null} = module(React)
let submit = (~id, ~body, ~title, ~changeDescription, ~onError, ~onOk) =>
  WitClient.Posts.patch(
    ~id,
    ~json=PostEdit.t_encode({
      id: id,
      body: body,
      title: title,
      change_description: changeDescription,
    }),
  )
  ->Promise.tapError(e => onError(e))
  ->Promise.tapOk(v => onOk(v))

@react.component
let make = () => {
  let editor = React.useRef(None)
  let titleEl = React.useRef(None)
  let changeDescriptionEl = React.useRef(None)
  let initTitleElRef = WitDom.React.withRefInputEl(titleEl)
  let initChangeDescriptionElRef = WitDom.React.withRefInputEl(changeDescriptionEl)
  let url = RescriptReactRouter.useUrl()
  let {data: articleData, isLoading, error: articleError} = RRQuery.useQueryR(~queryFn=_ =>
    WitClient.Posts.get(~slug=url.path->Belt_List.getExn(1), ())
  )
  let {add} = WitCtxNotifications.useContext()
  React.useEffect2(() => {
    let _ = switch (articleData, titleEl.current) {
    | (Some({title}), Some(el)) => Webapi.Dom.HtmlInputElement.setValue(el, title)
    | _ => ()
    }
    None
  }, (articleData, titleEl.current))
  let onSubmit = React.useCallback1(_ =>
    switch (articleData, editor.current, titleEl.current, changeDescriptionEl.current) {
    | (Some({id}), Some(e'), Some(titleEl'), Some(changeDescriptionEl')) =>
      let body = e'->TinyMCEReact.Editor.getContent
      let title = titleEl'->Webapi.Dom.HtmlInputElement.value
      let changeDescription = changeDescriptionEl'->Webapi.Dom.HtmlInputElement.value
      submit(
        ~id,
        ~body,
        ~title,
        ~changeDescription,
        ~onError=e => {
          open WitCtxNotifications
          add(
            make(~kind=Fail, ~duration=0, ~title="Update failure", ~msg=WitErr.toString(e), ()),
          )->ignore
        },
        ~onOk=_ => {
          open WitCtxNotifications
          add(make(~kind=Success, ~duration=0, ~msg="Update successful", ()))->ignore
          RescriptReactRouter.push(url.path->Path.popStr)
        },
      )->ignore
    | _ => ()
    }
  , [articleData])
  switch (isLoading, articleError, articleData) {
  | (true, _, _) | (_, None, None) => <SkeletonList />
  | (_, Some(err), _) => RRQuery.eToString(WitErr.toString, err)->React.string
  | (_, _, Some(post)) => <>
      <div className="flex items-center">
        <label className="inline mr-2 grow-0 text"> {"Title:"->string} </label>
        <input
          ref={ReactDOM.Ref.callbackDomRef(initTitleElRef)}
          className="p-1 inline flex-grow"
          type_="text"
        />
      </div>
      <div className="mt-2 min-h-full relative">
        <TinyMCEReact.Editor
          onInit={(_, e) => editor.current = Some(e)}
          initialValue=post.body
          init={TinyMCEReact.initConfig(
            // ~height=500,
            ~plugins=["lists"],
            ~menubar=false,
            ~branding=false,
            // ~statusbar=false,
            ~toolbar="undo redo | blocks | bold italic | bullist numlist outdent indent | removeformat",
            ~content_style="body { font-family:Helvetica,Arial,sans-serif; font-size:14px }",
            (),
          )}
          tinymceScriptSrc="/tinymce/tinymce.min.js"
        />
        <div className="mt-2 flex">
          <input
            className="p-2 mr-2 inline flex-grow"
            type_="text"
            placeholder="(Optional) Describe the change"
            ref={ReactDOM.Ref.callbackDomRef(initChangeDescriptionElRef)}
          />
          <Button className="grow-0" kind=Button.Primary onClick=onSubmit>
            {"Submit"->React.string}
          </Button>
        </div>
      </div>
    </>
  }
}
