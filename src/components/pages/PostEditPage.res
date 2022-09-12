@react.component
let make = () => {
  open React
  let editor = React.useRef(None)
  let url = RescriptReactRouter.useUrl()
  let {data: articleData, isLoading, error: articleError} = RRQuery.useQueryR(~queryFn=_ =>
    WitClient.Posts.get(~slug=url.path->Belt_List.getExn(1), ())
  )
  switch (isLoading, articleError, articleData) {
  | (true, _, _) | (_, None, None) => <SkeletonList />
  | (_, Some(err), _) => RRQuery.eToString(WitErr.toString, err)->React.string
  | (_, _, Some(post)) => <>
      <h1 className="text-2xl"> {string(post.title)} </h1>
      <div className="min-h-full relative">
        <TinyMCEReact.Editor
          onInit={(_, e) => editor.current = Some(e)}
          initialValue=post.body
          init={TinyMCEReact.initConfig(
            // ~height=500,
            ~menubar=false,
            ~toolbar="undo redo | blocks | bold italic | alignleft aligncenter alignright alignjustify | bullist numlist outdent indent | removeformat | help",
            ~content_style="body { font-family:Helvetica,Arial,sans-serif; font-size:14px }",
            (),
          )}
          tinymceScriptSrc="/tinymce/tinymce.min.js"
        />
      </div>
    </>
  }
}
