@react.component
let make = () => {
  open React
  let {add} = WitCtxNotifications.useContext()
  useEffect0(() => {
    open WitCtxNotifications
    add(make(~msg="sup", ()))
    add(make(~kind=Warning, ~duration=1000000000, ~msg="sup", ()))
    None
  })
  let (bodyOpt, setBody) = React.useState(_ => None)
  let {user} = WitCtxUser.useContext()
  let url = RescriptReactRouter.useUrl()
  let (articleData, articleFetching) = CQuery.useQuery(
    ~queryFn=WitClient.Posts.get(~slug=url.path->Belt_List.getExn(1)),
    ~fatalErr=WitErr.Failed_request,
  )
  switch (bodyOpt, articleData, articleFetching) {
  | (_, CQuery.Error(err), _) => err->WitErr.toString->React.string
  | (None, CQuery.Data(data), _) => {
      setBody(_ => Some(Md.toHtml(data.body)))
      <SkeletonList />
    }
  | (_, CQuery.Empty, _) => <SkeletonList />
  | (Some(body), CQuery.Data(post), _) => <>
      {switch user {
      | Some(_) =>
        let onClick = _ => {
          let nextPath = Belt.List.toArray(url.path)
          nextPath->Js.Array2.push("edit")->ignore
          RescriptReactRouter.push(`/${nextPath->Str.join("/")}`)
          ()
        }
        <div className="w-full p-2 bg-slate-500 mb-2 rounded-sm">
          <Button size=Button.Small onClick> {"Edit"->string} </Button>
        </div>
      | _ => null
      }}
      <link rel="stylesheet" href="/css/github-markdown.dark-dimmed.min.css" />
      <h1 className="text-2xl"> {string(post.title)} </h1>
      <p className="markdown-body" dangerouslySetInnerHTML={{"__html": body}} />
    </>
  }
}
