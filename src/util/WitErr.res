type t = Missing_value | Failed_request | Invalid_json | Invalid_model_decode(Decco.decodeError)

let toString = (e: t) =>
  switch e {
  | Failed_request => "failed request"
  | Invalid_json => "invalid json"
  | Missing_value => "missing value"
  | Invalid_model_decode(err) => j`${err.path}: ${err.message}`
  }
