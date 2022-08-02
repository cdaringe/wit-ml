@react.component
let make = () => {
  open React
  let (postOpt, setPostOpt) = React.useState(_ => None)
  let (bodyOpt, setBody) = React.useState(_ => None)
  let url = RescriptReactRouter.useUrl()
  useEffect0(() => {
    open WitClient
    open Js.Promise
    let slug = url.path->Belt_List.getExn(1)
    let _ = Posts.get(~slug)->then_((res: ApiResponse.t<Post.t>) => {
      setPostOpt(_ => Some(Belt_Array.getUnsafe(res.values, 0)))
      resolve(res)
    }, _)
    None
  })
  MdHk.useSetMdOpt(setBody, postOpt, p => p.body)
  switch (postOpt, bodyOpt) {
  | (Some(post), Some(body)) => <>
      <link rel="stylesheet" href="/css/github-markdown.dark-dimmed.min.css" />
      <h1 className="text-2xl"> {string(post.title)} </h1>
      <p className="markdown-body" dangerouslySetInnerHTML={{"__html": body}} />
    </>
  | _ => null
  }
}
