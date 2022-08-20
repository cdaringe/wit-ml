@react.component
let make = () => {
  open React
  let editBodyEl = React.useRef(Js.Nullable.null)
  let url = RescriptReactRouter.useUrl()
  let (articleData, articleFetching) = CQuery.useQuery(
    ~queryFn=WitClient.Posts.get(~slug=url.path->Belt_List.getExn(1)),
    ~fatalErr=WitErr.Failed_request,
  )
  React.useEffect2(() => {
    switch (editBodyEl.current->Js.Nullable.toOption, articleData) {
    | (Some(el), CQuery.Data(post)) => {
        %raw(`self.MonacoEnvironment = { getWorkerUrl: function (moduleId, label) { if (label === 'json') {return '/vendor/monaco/vs/language/json/json.worker.js'} if (label === 'css' || label === 'scss' || label === 'less') {return '/vendor/monaco/vs/language/css/css.worker.js'} if (label === 'html') {return '/vendor/monaco/vs/language/html/html.worker.js'} if (label === 'typescript' || label === 'javascript') {return '/vendor/monaco/vs/language/typescript/ts.worker.js'} return '/vendor/monaco/vs/editor/editor.worker.js' }}`)->ignore
        Editor.Monaco.create(
          Editor.Monaco.editor,
          el,
          {
            value: Some(post.body),
            language: "markdown",
            automaticLayout: Some(true),
          },
        )
        ->Editor.Monaco.layout({height: 400, width: 400})
        ->ignore
      }
    | _ => ()
    }
    None
  }, (editBodyEl.current, articleData))
  switch (articleData, articleFetching) {
  | (CQuery.Error(err), _) => err->WitErr.toString->React.string
  | (CQuery.Data(post), _) => <>
      <h1 className="text-2xl"> {string(post.title)} </h1>
      <div className="min-h-full relative"> <div ref={ReactDOM.Ref.domRef(editBodyEl)} /> </div>
    </>
  | (CQuery.Empty, _) => <SkeletonList />
  }
}
