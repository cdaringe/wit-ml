let tapOk = (v, cb) =>
  Belt.Result.map(v, v' => {
    cb(v')
    v'
  })
