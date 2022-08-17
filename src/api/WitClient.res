type response = Fetch.Response.t
@val external fetch: string => Promise.t<response> = "fetch"
@val external fetchWithInit: (string, Fetch.RequestInit.t) => Promise.t<response> = "fetch"
@send external text: response => Promise.t<string> = "text"

type apiResult<'a> = Promise.result<'a, WitErr.witErr>
type apiPMap<'a, 'b> = Promise.t<apiResult<'a>> => Promise.t<apiResult<'b>>

let getUrl = parts => j`/api/${Str.join(parts, "/")}`

let errorOnNotOk: Promise.t<response> => Promise.t<apiResult<response>> = p =>
  p->Promise.flatMap(res => {
    if Fetch.Response.ok(res) {
      Ok(res)->Promise.resolved
    } else {
      Error(WitErr.Failed_request)->Promise.resolved
    }
  })

let json: apiPMap<'a, 'b> = p =>
  p
  ->Promise.flatMapOk(res => text(res)->Promise.map(v => Ok(v)))
  ->Promise.mapError(_e => WitErr.Failed_request)
  ->Promise.flatMapOk(text => {
    let v: Promise.t<apiResult<'b>> = WitJson.parse(text)->Promise.resolved
    v
  })

let getJson = pathParts => pathParts->getUrl->fetch->errorOnNotOk->json

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
  fetchWithInit(url, init)->errorOnNotOk->json
}

let getModel = (pathParts, decode) =>
  getJson(pathParts)->Promise.mapOk(json => ApiResponse.t_decode(decode, json)->Belt_Result.getExn)

let postModel = (routeParts, ~json, decode) =>
  post(~body=json, routeParts)->Promise.flatMapOk(json =>
    switch ApiResponse.t_decode(decode, json) {
    | Ok(v) => Ok(v)
    | Error(e) => Error(WitErr.Invalid_model_decode(e.message))
    }->Promise.resolved
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
    postModel(["login"], ~json=model, User.t_decode)
  }
}
