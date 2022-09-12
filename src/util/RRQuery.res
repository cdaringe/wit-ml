open ReactQuery

external unsafeToJsExn: exn => Js.Exn.t = "%identity"

type jsexn_or_err<'t> =
  | JsError(Js.Exn.t)
  | Err('t)

type rec queryResultR<'queryError, 'queryData> = {
  status: ReactQuery_Types.queryStatus,
  isIdle: bool,
  isError: bool,
  isFetched: bool,
  isFetchedAfterMount: bool,
  isFetching: bool,
  isLoading: bool,
  isLoadingError: bool,
  isPlaceholderData: bool,
  isPreviousData: bool,
  isRefetchError: bool,
  isStale: bool,
  isSuccess: bool,
  data: option<'queryData>,
  dataUpdatedAt: int,
  errorUpdatedAt: int,
  failureCount: int,
  refetch: ReactQuery_Types.refetchOptions => Js.Promise.t<queryResult<'queryError, 'queryData>>,
  remove: unit => unit,
  error: option<jsexn_or_err<'queryError>>,
}

let useQueryR = (~queryFn) => {
  let (err, setErr) = React.useState(_ => None)
  let queryFnWithResultHandling = React.useCallback1(opts => {
    queryFn(opts)
    ->Promise.tapError(e => setErr(_ => Some(Err(e))))
    ->Promise.Js.fromResult
    ->Promise.Js.toBsPromise
      |> Js.Promise.catch(exn => {
        let err = exn->%raw("(x => x instanceof Error ? x : new Error(String(x)))")
        setErr(_ => Some(JsError(err)))
        Js.Promise.reject(err)
      })
  }, [queryFn])
  let r = ReactQuery_Query.useQuery(
    ReactQuery_Query.queryOptions(~queryFn=queryFnWithResultHandling, ()),
  )
  {
    status: r.status,
    isIdle: r.isIdle,
    isError: r.isError,
    isFetched: r.isFetched,
    isFetchedAfterMount: r.isFetchedAfterMount,
    isFetching: r.isFetching,
    isLoading: r.isLoading,
    isLoadingError: r.isLoadingError,
    isPlaceholderData: r.isPlaceholderData,
    isPreviousData: r.isPreviousData,
    isRefetchError: r.isRefetchError,
    isStale: r.isStale,
    isSuccess: r.isSuccess,
    data: r.data,
    dataUpdatedAt: r.dataUpdatedAt,
    errorUpdatedAt: r.errorUpdatedAt,
    failureCount: r.failureCount,
    refetch: r.refetch,
    remove: r.remove,
    error: err,
  }
}

let eToString: ('a => string, jsexn_or_err<'a>) => string = (tostring, t) =>
  switch t {
  | JsError(e) => Belt.Option.getExn(Js.Exn.message(e))
  | Err(e) => e->tostring
  }
