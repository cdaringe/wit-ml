let useSetMarkdown = (setter, v) => React.useEffect1(() => {
    setter(_ => Md.toHtml(v))
    None
  }, [v])
let useSetMarkdownOpt = (setter, vOpt, map) => React.useEffect1(() => {
    Belt_Option.map(vOpt, v => {
      setter(_ => Some(Md.toHtml(v->map)))
      None
    })->ignore
    None
  }, [vOpt])
