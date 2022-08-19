/**
 * CQuery is a simple version of ReactQuery::useQuery that _cares_ about
 * Result<'t, 'e>, vs using untyped Promise rejections.
 */

type data_state<'a, 'e> =
  | Empty
  | Data('a)
  | Error('e)

type fetch_state =
  | Idle
  | Fetching(/* retry */ int)

type exn_interop<'t> =
  | Pok('t)
  | Pexn

/**
 * @warn fatalErr must be of the same type 'e of queryFns Promise.t<result<'a, 'e>>
 */
let useQuery = (~queryFn, ~fatalErr) => {
  let (state, setState) = React.useState(_ => (Empty, Fetching(0)))
  React.useEffect0(() => {
    let isCancelled = ref(false)
    queryFn()
    ->Promise.map(v => Pok(v))
    ->Promise.Js.catch(_exn => Promise.Js.resolved(Pexn))
    ->Promise.get(res =>
      // maybe add retries later
      if isCancelled.contents {
        ()
      } else {
        switch res {
        | Pok(res') =>
          switch res' {
          | Ok(v) => setState(_ => (Data(v), Idle))
          | Error(e) => setState(_ => (Error(e), Idle))
          }
        | Pexn => setState(_ => (Error(fatalErr), Idle))
        }
      }
    )
    Some(() => isCancelled := true)
  })
  state
}
