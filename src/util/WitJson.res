let parse = text =>
  try {
    Ok(Js.Json.parseExn(text))
  } catch {
  | _ => Error(WitErr.Invalid_json)
  }
