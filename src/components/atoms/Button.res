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
let make = (~id=?, ~size=?, ~kind=?, ~type_=?, ~className=?, ~children) => {
  <button
    id={getWithDefault(id, "")}
    type_={getWithDefault(type_, "button")}
    className={Cx.cx([
      switch getWithDefault(size, Medium) {
      | Medium => "p-2"
      | _ => ""
      },
      switch getWithDefault(kind, Primary) {
      | Primary => "bg-blue-600"
      | _ => ""
      },
      getWithDefault(className, ""),
    ])}>
    {children}
  </button>
}
