open Belt.Map.String
open React

let labels = {
  "un": "Username",
  "pw": "Password",
}

@react.component
let make = () => {
  let (localErrors, setLocalErrs) = React.useState(_ => empty)
  let (password, setPw) = React.useState(_ => "")
  let onPwChange = WitDom.React.useSetOnChange(setPw)
  let (username, setUn) = React.useState(_ => "")
  let onUnChange = WitDom.React.useSetOnChange(setUn)
  let onSubmit = useCallback0(evt => {
    open ReactEvent.Form
    preventDefault(evt)
    switch (username, password) {
    | ("", _) => setLocalErrs(_ => set(localErrors, labels["un"], "Missing username"))
    | (_, "") => setLocalErrs(_ => set(localErrors, labels["pw"], "Missing password"))
    | _ =>
      WitClient.Auth.login(~username, ~password)
      |> WitJs.Promise.tap(v => {
        v->ignore
      })
      |> Js.Promise.catch(_err => {
        raise(Exn.Unimplemented)
      })
      |> ignore
    }
  })
  <form onSubmit>
    <Html.H1 className="mb-2"> {"Login"->string} </Html.H1>
    {
      let label = labels["un"]
      let err = get(localErrors, label)
      <FormField input={<Html.Input onChange={onUnChange} />} label ?err />
    }
    {
      let label = labels["pw"]
      let err = get(localErrors, label)
      <FormField input={<Html.Input type_="password" onChange={onPwChange} />} label ?err />
    }
    <Button type_="submit" disabled={size(localErrors) > 0} className="mt-2">
      {"Submit"->string}
    </Button>
  </form>
}
