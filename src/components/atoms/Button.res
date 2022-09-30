open Belt.Option

type size =
  | Small
  | Medium
  | Large

type kind =
  | Primary
  | Secondary
  | Other

@react.component
let make = (
  ~id=?,
  ~onClick=?,
  ~size=?,
  ~kind=?,
  ~type_=?,
  ~className=?,
  ~disabled=false,
  ~children,
) => {
  <button
    ?onClick
    disabled={disabled}
    id={getWithDefault(id, "")}
    type_={getWithDefault(type_, "button")}
    className={Cx.cx([
      switch getWithDefault(size, Medium) {
      | Medium => "p-2"
      | _ => ""
      },
      switch (disabled, getWithDefault(kind, Primary)) {
      | (true, _) => "bg-gray-600"
      | (false, Primary) => "bg-blue-600"
      | _ => ""
      },
      getWithDefault(className, ""),
    ])}>
    {children}
  </button>
}

let default = make
