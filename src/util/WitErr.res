type witErr = Missing_value | Failed_request | Invalid_json | Invalid_model_decode(string)

let errMsg = (e: witErr) =>
  switch e {
  | Failed_request => "failed request"
  | Invalid_json => "invalid json"
  | Missing_value => "missing value"
  | Invalid_model_decode(msg) => msg
  }
