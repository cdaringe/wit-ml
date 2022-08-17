open Belt.Map.String
open React

let labels = {
  "un": "Username",
  "pw": "Password",
}

@react.component
let make = () => {
  let (localErrors, setLocalErrs) = React.useState(_ => empty)
  let (remoteErr, setRemoteError) = React.useState(_ => None)
  let (password, setPw) = React.useState(_ => "")
  let onPwChange = WitDom.React.useSetOnChange(v => {
    setLocalErrs(prev => remove(prev, labels["pw"]))
    setPw(v)
  })
  let (username, setUn) = React.useState(_ => "")
  let onUnChange = WitDom.React.useSetOnChange(v => {
    setLocalErrs(prev => remove(prev, labels["un"]))
    setUn(v)
  })
  let onSubmit = evt => {
    open ReactEvent.Form
    preventDefault(evt)
    switch (username, password) {
    | ("", _pw) => setLocalErrs(_ => set(localErrors, labels["un"], "Missing username"))
    | (_un, "") => setLocalErrs(_ => set(localErrors, labels["pw"], "Missing password"))
    | _ =>
      WitClient.Auth.login(~username, ~password)
      ->Promise.tap(_v => setRemoteError(_ => None))
      ->Promise.tapError(err => {
        setRemoteError(_ => Some(j` ${Obj.magic(err)}`))
      }) |> ignore
    }
  }
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
    <br />
    <Button type_="submit" disabled={size(localErrors) > 0} className="mt-2">
      {"Submit"->string}
    </Button>
    {switch remoteErr {
    | Some(msg) => <p className="text-red-500"> {msg->string} </p>
    | _ => null
    }}
  </form>
}
