open React
type kind = Info | Success | Warning | Fail
type t = {msg: string, duration: int, kind: kind, date: Js.Date.t, title: string}

let kindToString = k =>
  switch k {
  | Info => "Info"
  | Warning => "Warning"
  | Fail => "Error"
  | Success => "Success"
  }

let noop = _ => ()

type notification_ctx = {notifications: Js.Array.t<t>, add: t => unit, remove: t => unit}

let context = createContext({
  notifications: [],
  add: noop,
  remove: noop,
})

let remove = (setter, notification) => {
  setter(last => {
    {
      ...last,
      notifications: last.notifications |> Js.Array.filter(n => n !== notification),
    }
  })
}
let removeOnTimeout = (setter, notification) => {
  if notification.duration > 0 {
    Js.Global.setTimeout(() => {
      remove(setter, notification)
    }, notification.duration)->ignore
  }
}
module Provider = {
  let provider = Context.provider(context)

  @react.component
  let make = (~children) => {
    let (value, setValue) = useState(_ => {
      notifications: [],
      add: noop,
      remove: noop,
    })
    let addNotification = useCallback1(notification => {
      removeOnTimeout(setValue, notification)
      setValue(last => {
        {
          ...last,
          notifications: Js.Array.concat([notification], last.notifications),
        }
      })
    }, [setValue])
    let removeNotification = useCallback1(n => {
      remove(setValue, n)
    }, [setValue])
    React.createElement(
      provider,
      {"value": {...value, add: addNotification, remove: removeNotification}, "children": children},
    )
  }
}

let useContext = () => React.useContext(context)
let make = (~duration=?, ~kind=?, ~title=?, ~msg, ()) => {
  open Belt.Option
  let knd = getWithDefault(kind, Info)
  let not: t = {
    title: getWithDefault(title, kindToString(knd)),
    date: Js.Date.make(),
    msg: msg,
    kind: knd,
    duration: getWithDefault(duration, 5_000),
  }
  not
}
