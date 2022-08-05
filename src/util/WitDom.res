let {document} = module(Webapi.Dom)
let {asHtmlDocument} = module(Webapi.Dom.Document)
let {setTitle} = module(Webapi.Dom.HtmlDocument)

let setTitle = title => {
  let doc' = asHtmlDocument(document)
  Opt.effect(doc', doc => setTitle(doc, `witwiki - ${title}`))
  None
}
