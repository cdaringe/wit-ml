let pop = path => {
  open Belt.List
  path->reverse->tailExn->reverse->toArray |> Js.Array.joinWith("/")
}

let popStr = path => `/${path->pop}`
