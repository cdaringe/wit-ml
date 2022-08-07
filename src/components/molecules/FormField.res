open React

@react.component
let make = (~err=?, ~label, ~input) => {
  <>
    <div> {`${label}: `->string} input </div>
    {switch err {
    | None => null
    | Some(v) => <span className="text-red-500"> {v->string} </span>
    }}
  </>
}
