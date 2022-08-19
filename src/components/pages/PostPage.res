@react.component
let make = () => {
  open React
  let (postOpt, setPostOpt) = React.useState(_ => None)
  let (bodyOpt, setBody) = React.useState(_ => None)
  let {user} = WitCtxUser.useContext()
  let url = RescriptReactRouter.useUrl()
  useEffect0(() => {
    open WitClient
    let slug = url.path->Belt_List.getExn(1)
    let _ = Posts.get(~slug)->Promise.getOk((res: ApiResponse.t<Post.t>) => {
      setPostOpt(_ => Some(Belt_Array.getUnsafe(res.values, 0)))
    })
    None
  })
  MdHk.useSetMarkdownOpt(setBody, postOpt, p => p.body)
  switch (postOpt, bodyOpt) {
  | (Some(post), Some(body)) => <>
      {switch user {
      | Some(_) =>
        <div className="w-full p-2 bg-slate-500 mb-2 rounded-sm">
          <Button size=Button.Small> {"Edit"->string} </Button>
        </div>
      | _ => null
      }}
      <link rel="stylesheet" href="/css/github-markdown.dark-dimmed.min.css" />
      <h1 className="text-2xl"> {string(post.title)} </h1>
      <p className="markdown-body" dangerouslySetInnerHTML={{"__html": body}} />
    </>
  | _ => null
  }
}
