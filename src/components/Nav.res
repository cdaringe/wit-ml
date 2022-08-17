let {string, null} = module(React)
let {toString} = module(Belt.Int)

module Item = {
  let onNavLinkClick = evt => {
    open ReactEvent.Mouse
    let href = target(evt)["href"]
    preventDefault(evt)
    RescriptReactRouter.push(href)
  }
  @react.component
  let make = (~className="", ~href, ~children) => {
    <li className={Cx.cx(["inline-block", className])} key={href}>
      <div onClick=onNavLinkClick className="hover:bg-slate-500 cursor-pointer">
        <a className="p-8 block" href={href}> {children} </a>
      </div>
    </li>
  }
}

module Group = {
  open Belt.Array
  @react.component
  let make = (~links) => {
    <ul className="list-none inline-flex">
      {map(links, ((href, children)) =>
        <Item className="max-h-24" key={href} href> {children} </Item>
      ) |> React.array}
    </ul>
  }
}

module Bar = {
  @react.component
  let make = (~className=?, ~userName=?) => {
    <nav className={j`nav-m w-full text-white ${Belt.Option.getWithDefault(className, "")}`}>
      <Group links={[("/", string("Home")), ("/about", string("About"))]} />
      <ul />
      <Group
        links={[
          Opt.ifSomeElse(
            userName,
            (
              "/logout",
              <>
                <p className="font-bold"> {Belt.Option.mapWithDefault(userName, null, string)} </p>
                <span className="text-sm"> {string("Logout")} </span>
              </>,
            ),
            ("/login", string("Login")),
          ),
        ]}
      />
    </nav>
  }
}
