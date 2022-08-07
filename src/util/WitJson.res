let parse = (text, exn) =>
  try Js.Json.parseExn(text) catch {
  | _ => raise(exn)
  }
