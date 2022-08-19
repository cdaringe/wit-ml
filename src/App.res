let {render, querySelector} = module(ReactDOM)

let initialUser = WitCtxUser.UserStorage.read()->Opt.fromResult
let client = ReactQuery.Provider.createClient()

module App = {
  @react.component
  let make = () => {
    open React
    let url = RescriptReactRouter.useUrl()
    let (title, mainContent) = switch url.path {
    | list{} => ("home", <Home />)
    | list{"w", _slug} => ("Post", <PostPage />)
    | list{"login"} => ("Login", <Login />)
    | _ => ("404", <p> {string("not found")} </p>)
    }
    useEffect1(() => WitDom.setTitle(title), [title])
    <ReactQuery.Provider client>
      <WitCtxUser.Provider ?initialUser>
        <div id="app" className="flex flex-col h-screen container m-auto">
          <Header /> <main className="w-full bg-slate-700 flex-grow p-8 mt-2"> {mainContent} </main>
        </div>
      </WitCtxUser.Provider>
    </ReactQuery.Provider>
  }
}

switch querySelector("#root") {
| None => ()
| Some(el) => render(<App />, el)
}
