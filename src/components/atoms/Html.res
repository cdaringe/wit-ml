open Opt

let getOrEmpty = v => getOr(v, "")

module H1 = {
  @react.component
  let make = (~children, ~className=?) => {
    <h1 className={Cx.cx(["text-3xl", getOrEmpty(className)])}> {children} </h1>
  }
}

module H2 = {
  @react.component
  let make = (~children, ~className=?) => {
    <h2 className={Cx.cx(["text-2xl", getOrEmpty(className)])}> {children} </h2>
  }
}

module H3 = {
  @react.component
  let make = (~children, ~className=?) => {
    <h3 className={Cx.cx(["text-xl", getOrEmpty(className)])}> {children} </h3>
  }
}

module H4 = {
  @react.component
  let make = (~children, ~className=?) => {
    <h4 className={Cx.cx(["text-lg", getOrEmpty(className)])}> {children} </h4>
  }
}
module Input = {
  @react.component
  let make = (~className=?, ~type_=?, ~children=?) =>
    <input className={Cx.cx(["p-2", getOr(className, "")])} type_={getOr(type_, "text")}>
      {getOr(children, React.null)}
    </input>
}
