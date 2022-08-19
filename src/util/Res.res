let map = Belt.Result.map
let tapOk = (v, cb) =>
  map(v, v' => {
    cb(v')
    v'
  })

let tapError = (v, fn) => {
  let _ = switch v {
  | Error(e) => {
      fn(e)
      ()
    }
  | _ => ()
  }
}

let effectOk = (v, cb) => {
  let _ = tapOk(v, cb)
}

let throwErr = v => v->tapError(e => Js.Exn.raiseError(e))

let throwErrP = p => p->Promise.tapError(throwErr)
