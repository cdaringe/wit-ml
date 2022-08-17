let getUrl = parts => j`/api/${Str.join(parts, "/")}`

let raiseOnNotOk = WitJs.Promise.tap(res => {
  if Fetch.Response.ok(res) {
    ()
  } else {
    raise(Exn.FailedRequest(res))
  }
})

let json: Js.Promise.t<'a> => Js.Promise.t<Js.Json.t> = reqP => {
  open WitJs.Promise
  then(reqP, req => {
    let textP = Fetch.Response.text(req)
    then_map(textP, text => WitJson.parse(text, Exn.FailedRequestJson(req)))
  })
}

let getJson = pathParts => pathParts->getUrl->Bs_fetch.fetch->raiseOnNotOk->json

let post = (
  ~makeInit as makeInit'=?,
  ~setHeaders as setHeaders'=?,
  ~encodeBody=Js.Json.stringify,
  ~body,
  parts,
) => {
  let url = getUrl(parts)
  let makeInit = Bs_fetch.RequestInit.make
  let method_ = Bs_fetch.Post
  let encodedBody = Fetch.BodyInit.make(body->encodeBody)
  let defaultHeaders = Js.Dict.fromArray([("content-type", "application/json")])
  let headers = switch setHeaders' {
  | Some(m) => m(defaultHeaders)
  | _ => defaultHeaders
  }->Fetch.HeadersInit.makeWithDict
  let init = switch makeInit' {
  | Some(fn) => fn(~makeInit, ~url, ~method_, ~headers, ~body=encodedBody)
  | None => makeInit(~method_, ~headers, ~body=encodedBody, ())
  }
  Bs_fetch.fetchWithInit(url, init)->raiseOnNotOk->json
}

let getModel = (pathParts, decode) =>
  getJson(pathParts)->WitJs.Promise.then_map(json =>
    ApiResponse.t_decode(decode, json)->Belt_Result.getExn
  )

let postModel = (routeParts, ~json, decode) =>
  post(~body=json, routeParts)->WitJs.Promise.then_map(json =>
    ApiResponse.t_decode(decode, json)->Belt_Result.getExn
  )

module Posts = {
  let get = (~slug: string) => getModel([j`/posts/${slug}`], Post.t_decode)
  let getRecent = (~limit: int, ~offset: int) =>
    getModel(
      [j`/posts/recent?limit=${Belt.Int.toString(limit)}&offset=${Belt.Int.toString(offset)}`],
      Post.t_decode,
    )
}

let tapSetState = (setState: ('a => 'a) => unit, fn: ('a, 'b) => 'a, apiCall: Js.Promise.t<'b>) =>
  apiCall |> Js.Promise.then_((v: 'b) => {
    let _ = setState(prev => fn(prev, v))
    Js.Promise.resolve(v)
  })

module Auth = {
  let login = (~username, ~password) => {
    let model = PasswordLogin.login_encode({
      username: username,
      password: password,
    })
    postModel(["login", "password"], ~json=model, _t => Belt.Result.Ok(Js.Json.null))
  }
}
