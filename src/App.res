let {render, querySelector} = module(ReactDOM)

module App = {
  @react.component
  let make = () => {
    open React
    let url = RescriptReactRouter.useUrl()
    let mainContent = switch url.path {
    | list{} => <RecentPosts title="Recent posts" />
    | list{"w", _slug} => <PostPage />
    | _ => <p> {string("not found")} </p>
    }
    <div id="app" className="flex flex-col h-screen container m-auto">
      <Nav.Bar className="flex-grow-0" />
      <main className="w-full bg-slate-700 flex-grow p-8"> {mainContent} </main>
    </div>
  }
}

switch querySelector("#app") {
| None => ()
| Some(el) => render(<App />, el)
}
