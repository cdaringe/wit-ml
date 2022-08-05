@react.component
let make = () =>
  <div className="header">
    <Nav.Bar className="flex-grow-0" />
    <div className="search flex">
      <Html.Input className="flex-grow" />
      <Button className="p-2 ml-1 bg-blue-800"> {React.string("Search")} </Button>
    </div>
  </div>
