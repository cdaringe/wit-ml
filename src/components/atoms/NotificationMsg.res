let classNameOfKind = (k: WitCtxNotifications.kind) =>
  switch k {
  | Info => ("bg-blue-600", "border-blue-500")
  | Success => ("bg-green-500", "border-green-400")
  | Warning => ("bg-yellow-500", "border-yellow-400")
  | Error => ("bg-red-600", "border-red-500")
  }

@react.component
let make = (~notification: WitCtxNotifications.t) => {
  let {kind, title, msg} = notification
  let (bgColor, borderColor) = classNameOfKind(kind)
  let {remove} = WitCtxNotifications.useContext()
  <div className="flex flex-col justify-center">
    <div
      className={`block max-w-full mx-auto mb-3 text-sm ${bgColor} rounded-lg shadow-lg pointer-events-auto w-96 bg-clip-padding`}
      role="alert"
      ariaAtomic=true>
      <div
        className={`flex items-center justify-between px-3 py-2 ${bgColor} border-b ${borderColor} rounded-t-lg bg-clip-padding`}>
        <p className="flex items-center font-bold text-white">
          <svg
            ariaHidden=true
            focusable="false"
            className="w-4 h-4 mr-2 fill-current"
            role="img"
            xmlns="http://www.w3.org/2000/svg"
            viewBox="0 0 512 512">
            <path
              fill="currentColor"
              d="M256 8C119.043 8 8 119.083 8 256c0 136.997 111.043 248 248 248s248-111.003 248-248C504 119.083 392.957 8 256 8zm0 110c23.196 0 42 18.804 42 42s-18.804 42-42 42-42-18.804-42-42 18.804-42 42-42zm56 254c0 6.627-5.373 12-12 12h-88c-6.627 0-12-5.373-12-12v-24c0-6.627 5.373-12 12-12h12v-64h-12c-6.627 0-12-5.373-12-12v-24c0-6.627 5.373-12 12-12h64c6.627 0 12 5.373 12 12v100h12c6.627 0 12 5.373 12 12v24z"
            />
          </svg>
          {title->React.string}
        </p>
        <div className="flex items-center">
          // <p className="text-xs text-white opacity-90"> {"11 mins ago"->React.string} </p>
          <button
            onClick={_ => remove(notification)}
            type_="button"
            className="box-content w-4 h-4 ml-2 text-white border-none rounded-none opacity-50 btn-close btn-close-white focus:shadow-none focus:outline-none focus:opacity-100 hover:text-white hover:opacity-75 hover:no-underline"
            ariaLabel="Close">
            <Icons.Close />
          </button>
        </div>
      </div>
      <div className={`p-3 text-white break-words ${bgColor} rounded-b-lg`}>
        {msg->React.string}
      </div>
    </div>
  </div>
}
