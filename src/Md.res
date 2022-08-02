@module("marked") external parse: string => string = "parse"
@deriving(abstract)
type insaneOpts = {@optional allowedTags: array<string>}
@module("insane") external insane: (string, insaneOpts) => string = "default"

let toHtml = (~allowedTags: option<array<string>>=None, md) => {
  let opts = Belt_Option.mapWithDefault(allowedTags, insaneOpts(), allowedTags =>
    insaneOpts(~allowedTags, ())
  )
  parse(md)->insane(_, opts)
}
