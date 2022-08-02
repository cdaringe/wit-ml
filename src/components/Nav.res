let {string} = module(React)
let {toString} = module(Belt.Int)

module Bar = {
  let onNavLinkClick = evt => {
    open ReactEvent.Mouse
    let href = target(evt)["href"]
    preventDefault(evt)
    RescriptReactRouter.push(href)
  }

  @react.component
  let make = (~className: option<string>=?) => {
    <nav className={j`header w-full text-white ${Belt.Option.getWithDefault(className, "")}`}>
      <ul className="w-full list-none inline-block">
        {Belt.Array.map([("/", "Home"), ("/about", "About")], ((href, txt)) =>
          <li className="inline-block" key={href}>
            <div onClick=onNavLinkClick className="hover:bg-slate-500 cursor-pointer">
              <a className="p-8 block" href={href}> {string(txt)} </a>
            </div>
          </li>
        ) |> React.array}
      </ul>
    </nav>
  }
}
