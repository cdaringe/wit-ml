open React

@react.component
let make = (~label, ~input) => {
  <> {`${label}: `->string} input </>
}
