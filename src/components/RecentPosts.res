let {string, array} = module(React)
let onNavLinkClick = evt => {
  open ReactEvent.Mouse
  let href = target(evt)["href"]
  preventDefault(evt)
  RescriptReactRouter.push(href)
}
@react.component
let make = (~className: option<string>=?, ~title: string) => {
  let recentPosts = CQuery.useQuery(
    ~queryFn=WitClient.Posts.getRecent(~limit=10, ~offset=0),
    ~fatalErr=WitErr.Failed_request,
  )
  <div className={Belt_Option.getWithDefault(className, "")}>
    <Html.H2> {string(title)} </Html.H2>
    {switch recentPosts {
    | (CQuery.Empty, _)
    | (CQuery.Error(_), CQuery.Fetching(_)) =>
      <SkeletonList />
    | (CQuery.Error(err), CQuery.Idle) => err->WitErr.toString->string
    | (CQuery.Data(data), _) =>
      <ol className="list-decimal list-inside">
        {Belt.Array.map(data.values, it =>
          <li key=it.slug>
            <a href={Link.slugToPath(it.slug)} onClick={onNavLinkClick}> {it.title->string} </a>
          </li>
        )->array}
      </ol>
    }}
  </div>
}
