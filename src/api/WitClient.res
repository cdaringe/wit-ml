type response = Fetch.Response.t
@val external fetch: string => Promise.t<response> = "fetch"
@val external fetchWithInit: (string, Fetch.RequestInit.t) => Promise.t<response> = "fetch"
@send external text: response => Promise.t<string> = "text"

type apiResult<'a> = Promise.result<'a, WitErr.t>
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

let tapCatchLog = (description, p) => Promise.tapError(p, e => Js.Console.error2(description, e))

let getJson = pathParts =>
  pathParts->getUrl->(url => fetch(url)->errorOnNotOk->json->(p => tapCatchLog("GET: " ++ url, p)))

let post = (
  ~method=Bs_fetch.Post,
  ~makeInit as makeInit'=?,
  ~setHeaders as setHeaders'=?,
  ~encodeBody=Js.Json.stringify,
  ~body,
  urlParts,
) => {
  let url = getUrl(urlParts)
  let makeInit = Bs_fetch.RequestInit.make
  let method_ = method
  let encodedBody = Fetch.BodyInit.make(body->encodeBody)
  let defaultHeaders = Js.Dict.fromArray([
    ("content-type", "application/json"),
    ("accept", "application/json"),
  ])
  let headers = switch setHeaders' {
  | Some(m) => m(defaultHeaders)
  | _ => defaultHeaders
  }->Fetch.HeadersInit.makeWithDict
  let init = switch makeInit' {
  | Some(fn) => fn(~makeInit, ~url, ~method_, ~headers, ~body=encodedBody)
  | None => makeInit(~method_, ~headers, ~body=encodedBody, ())
  }
  fetchWithInit(url, init)->errorOnNotOk->json->(p => tapCatchLog(url, p))
}

let getModel = (pathParts, decode) =>
  getJson(pathParts)->Promise.mapOk(json => ApiResponse.t_decode(decode, json)->Belt_Result.getExn)

let writeJsonHttp = (method, urlParts, json, decode) =>
  post(~method, ~body=json, urlParts)->Promise.flatMapOk(json =>
    switch ApiResponse.t_decode(decode, json) {
    | Ok(v) => Ok(v)
    | Error(e) => Error(WitErr.Invalid_model_decode(e))
    }->Promise.resolved
  )

let postModel = (urlParts, json, decode) => writeJsonHttp(Bs_fetch.Post, urlParts, json, decode)
let patchModel = (urlParts, json, decode) => writeJsonHttp(Bs_fetch.Patch, urlParts, json, decode)

module Posts = {
  let get = (~slug: string, ()) =>
    getModel([j`posts/${slug}?body_as=html`], Post.t_decode)->Promise.mapOk(res =>
      Belt_Array.getUnsafe(res.values, 0)
    )
  let getRecent = (~limit: int, ~offset: int, ()) =>
    getModel(
      [j`posts/recent?limit=${Belt.Int.toString(limit)}&offset=${Belt.Int.toString(offset)}`],
      Post.t_decode,
    )
  let patch = (~id, ~json) => patchModel([j`posts/${Js.Int.toString(id)}`], json, _ => Ok())
}

let tapSetState = (setState: ('a => 'a) => unit, fn: ('a, 'b) => 'a, apiCall: Js.Promise.t<'b>) =>
  apiCall |> Js.Promise.then_((v: 'b) => {
    let _ = setState(prev => fn(prev, v))
    Js.Promise.resolve(v)
  })

module Auth = {
  let logout = () => postModel(["logout"], Js.Json.null, _ => Ok())
  let login = (~username, ~password) => {
    let model = PasswordLogin.login_encode({
      username: username,
      password: password,
    })
    postModel(["login"], model, User.t_decode)
  }
}
