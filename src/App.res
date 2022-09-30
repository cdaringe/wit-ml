let {render, querySelector} = module(ReactDOM)

let initialUser = WitCtxUser.UserStorage.read()->Opt.fromResult
let client = ReactQuery.Provider.createClient()

module AppOptions = {
  type t = {@optional isSearchEnabled: bool, title: string}
}
module App = {
  @react.component
  let make = () => {
    open React
    let url = RescriptReactRouter.useUrl()
    open AppOptions
    let ({title, isSearchEnabled}, mainContent) = switch url.path {
    | list{} => ({title: "home", isSearchEnabled: true}, <Home />)
    | list{"w", _slug} => ({title: "Post", isSearchEnabled: true}, <PostPage />)
    | list{"w", _slug, "edit"} => ({title: "Post", isSearchEnabled: false}, <PostEditPage />)
    | list{"login"} => ({title: "Login", isSearchEnabled: false}, <Login />)
    | _ => ({title: "404", isSearchEnabled: true}, <p> {string("not found")} </p>)
    }
    useEffect1(() => WitDom.setTitle(title), [title])
    <WitCtxNotifications.Provider>
      <ReactQuery.Provider client>
        <WitCtxUser.Provider ?initialUser>
          <div id="app" className="flex flex-col h-screen container m-auto">
            <NotificationCenter />
            <Header isSearchEnabled />
            <main className="w-full bg-slate-700 flex-grow p-8 mt-2"> {mainContent} </main>
          </div>
        </WitCtxUser.Provider>
      </ReactQuery.Provider>
    </WitCtxNotifications.Provider>
  }
}

switch querySelector("#root") {
| None => ()
| Some(el) => render(<App />, el)
}
