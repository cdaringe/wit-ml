let onNavLinkClick = evt => {
  open ReactEvent.Mouse
  let href = target(evt)["href"]
  preventDefault(evt)
  RescriptReactRouter.push(href)
}
@react.component
let make = (~className: option<string>=?, ~title: string) => {
  open React
  let (s, setRecentPosts) = useState(_ => None)
  // @todo https://github.com/rescriptbr/react-query
  useEffect0(() => {
    WitClient.Posts.getRecent(~limit=10, ~offset=0)
    ->Promise.tapError(Js.Console.error)
    ->Promise.tapOk(v => {
      setRecentPosts(_ => Some(v))
    })
    ->ignore
    None
  })
  <div className={Belt_Option.getWithDefault(className, "")}>
    <Html.H2> {string(title)} </Html.H2>
    {switch s {
    | None => React.null
    | Some(data) =>
      <ol className="list-decimal list-inside">
        {Belt.Array.map(data.values, v =>
          <li>
            <a href={Link.slugToPath(v.slug)} onClick={onNavLinkClick}> {v.title->string} </a>
          </li>
        )->React.array}
      </ol>
    }}
  </div>
}
