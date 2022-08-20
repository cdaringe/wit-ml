@react.component
let make = () => {
  open React
  let editBodyEl = React.useRef(Js.Nullable.null)
  React.useEffect1(() => {
    switch editBodyEl.current->Js.Nullable.toOption {
    | Some(el) =>
      Editor.Monaco.editor.create(
        el,
        {
          value: None,
          language: "markdown",
        },
      )->ignore
    | None => ()
    }
    None
  }, [editBodyEl.current])
  let url = RescriptReactRouter.useUrl()
  let (articleData, articleFetching) = CQuery.useQuery(
    ~queryFn=WitClient.Posts.get(~slug=url.path->Belt_List.getExn(1)),
    ~fatalErr=WitErr.Failed_request,
  )
  switch (articleData, articleFetching) {
  | (CQuery.Error(err), _) => err->WitErr.toString->React.string
  | (CQuery.Data(post), _) => <>
      <h1 className="text-2xl"> {string(post.title)} </h1>
      <textbox ref={ReactDOM.Ref.domRef(editBodyEl)} value=post.body />
    </>
  | (CQuery.Empty, _) => <SkeletonList />
  }
}
