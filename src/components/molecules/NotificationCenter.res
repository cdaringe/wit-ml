open React

@react.component
let make = () => {
  // @todo add react-transition-group
  let {notifications} = WitCtxNotifications.useContext()
  <div id="notification-container" className="absolute top-0 right-0 p-2">
    {notifications
    |> Js.Array.mapi((notification, i) =>
      <NotificationMsg key={j`_${Js.Int.toString(i)}`} notification />
    )
    |> array}
  </div>
}
