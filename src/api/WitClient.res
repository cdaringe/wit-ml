let text = (p: Js.Promise.t<'a>) => {
  open Js.Promise
  let textP = then_(Fetch.Response.text, p)
  then_(v => resolve(Js.Json.parseExn(v)), textP)
}
let getString = route => Bs_fetch.fetch(j`/api${route}`) |> text

let getModel = (route, decode) => {
  open Js.Promise
  getString(route) |> then_(v => ApiResponse.t_decode(decode, v) |> Belt_Result.getExn |> resolve)
}

module Posts = {
  let get = (~slug: string) => getModel(j`/posts/${slug}`, Post.t_decode)

  let getRecent = (~limit: int, ~offset: int) =>
    getModel(
      j`/posts/recent?limit=${Belt.Int.toString(limit)}&offset=${Belt.Int.toString(offset)}`,
      Post.t_decode,
    )
}

let tapSetState = (setState: ('a => 'a) => unit, fn: ('a, 'b) => 'a, apiCall: Js.Promise.t<'b>) =>
  apiCall |> Js.Promise.then_((v: 'b) => {
    let _ = setState(prev => fn(prev, v))
    Js.Promise.resolve(v)
  })
