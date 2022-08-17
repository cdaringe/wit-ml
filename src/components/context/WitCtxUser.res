type t = {user: option<User.t>, setUser: User.t => unit}

let emptySetUser = _ => ()

let context = React.createContext({
  user: None,
  setUser: emptySetUser,
})

module UserStorage = {
  let key = "user"

  let read = () =>
    Dom.Storage.getItem(key, Dom.Storage.localStorage)
    ->Opt.toResult(Error(WitErr.Missing_value))
    ->Belt.Result.flatMap(WitJson.decodeText(User.t_decode))

  let write = (t: User.t) => {
    Dom.Storage.setItem(key, User.t_encode(t)->Js.Json.stringify, Dom.Storage.localStorage)
    ()
  }
}

module Provider = {
  let provider = React.Context.provider(context)

  @react.component
  let make = (~initialUser=?, ~children) => {
    let (value, setValue) = React.useState(_ => {
      user: initialUser,
      setUser: emptySetUser,
    })
    let setUser = React.useCallback1(user => {
      setValue(last => {
        ...last,
        user: Some(user),
      })
      UserStorage.write(user)
    }, [value.user])
    React.createElement(provider, {"value": {...value, setUser: setUser}, "children": children})
  }
}

let useContext = () => React.useContext(context)
