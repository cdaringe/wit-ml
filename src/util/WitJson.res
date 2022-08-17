let parse = text =>
  try {
    Ok(Js.Json.parseExn(text))
  } catch {
  | _ => Error(WitErr.Invalid_json)
  }

let decode = (decoder, v) =>
  switch decoder(v) {
  | Ok(v) => Ok(v)
  | _ => Error(WitErr.Invalid_json)
  }

let decodeText = (decoder: Js.Json.t => result<'a, 'b>, text) =>
  switch parse(text) {
  | Ok(json) => decode(decoder, json)
  | _ => Error(WitErr.Invalid_json)
  }
