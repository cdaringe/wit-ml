let {string} = module(React)
let {toString} = module(Belt.Int)

module Item = {
  let onNavLinkClick = evt => {
    open ReactEvent.Mouse
    let href = target(evt)["href"]
    preventDefault(evt)
    RescriptReactRouter.push(href)
  }
  @react.component
  let make = (~href, ~text) => {
    <li className="inline-block" key={href}>
      <div onClick=onNavLinkClick className="hover:bg-slate-500 cursor-pointer">
        <a className="p-8 block" href={href}> {string(text)} </a>
      </div>
    </li>
  }
}

module Group = {
  open Belt.Array
  @react.component
  let make = (~links) => {
    <ul className="list-none inline-flex">
      {map(links, ((href, text)) => <Item href text />) |> React.array}
    </ul>
  }
}

module Bar = {
  @react.component
  let make = (~className=?, ~isLoggedIn=?) => {
    <nav className={j`nav-m w-full text-white ${Belt.Option.getWithDefault(className, "")}`}>
      <Group links={[("/", "Home"), ("/about", "About")]} />
      <ul />
      <Group links={[Opt.ifSomeElse(isLoggedIn, ("/logout", "Logout"), ("/login", "Login"))]} />
    </nav>
  }
}
