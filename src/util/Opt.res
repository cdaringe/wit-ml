let getOr = (vOpt, fallback) =>
  switch vOpt {
  | Some(v) => v
  | None => fallback
  }

let ifSomeElse = (vOpt, t, f) =>
  switch vOpt {
  | Some(_) => t
  | None => f
  }

let effect = (vOpt, fn) =>
  switch vOpt {
  | Some(v) => fn(v)->ignore
  | None => ()
  }
