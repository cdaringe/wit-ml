@react.component
let make = () => {
  let {user} = WitCtxUser.useContext()
  let userName = Belt.Option.map(user, u => u.username)
  <div className="header">
    <Nav.Bar className="flex-grow-0" ?userName />
    <div className="search flex">
      <Html.Input className="flex-grow" />
      <Button className="p-2 ml-1 bg-blue-800"> {React.string("Search")} </Button>
    </div>
  </div>
}
