let {render, querySelector} = module(ReactDOM)
module App = {
  @react.component
  let make = () => {
    open React
    let url = RescriptReactRouter.useUrl()
    let (title, mainContent) = switch url.path {
    | list{} => ("home", <> <Logo.Banner /> <RecentPosts title="Recent posts" /> </>)
    | list{"w", _slug} => ("Post", <PostPage />)
    | list{"login"} => ("Login", <Login />)
    | _ => ("404", <p> {string("not found")} </p>)
    }
    useEffect1(() => WitDom.setTitle(title), [title])
    <div id="app" className="flex flex-col h-screen container m-auto">
      <Header /> <main className="w-full bg-slate-700 flex-grow p-8 mt-2"> {mainContent} </main>
    </div>
  }
}

switch querySelector("#root") {
| None => ()
| Some(el) => render(<App />, el)
}
