open React

@react.component
let make = () => {
  <form>
    <Html.H1 className="mb-2"> {"Login"->string} </Html.H1>
    <FormField input={<Html.Input />} label="Username" />
    <FormField input={<Html.Input type_="password" />} label="Password" />
    <Button className="mt-2"> {"Submit"->string} </Button>
  </form>
}
