let {document} = module(Webapi.Dom)
let {asHtmlDocument} = module(Webapi.Dom.Document)
let {setTitle} = module(Webapi.Dom.HtmlDocument)

let setTitle = title => {
  let doc' = asHtmlDocument(document)
  Opt.effect(doc', doc => setTitle(doc, `witwiki - ${title}`))
  None
}

module React = {
  let targetValue = evt => ReactEvent.Form.target(evt)["value"]
  let setTargetValue = (setter, evt) => setter(_ => evt->targetValue)
  let useSetOnChange = setter => React.useCallback0(setTargetValue(setter))
}
