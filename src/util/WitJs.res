module Promise = {
  let tap = (fn, p) => {
    open Js.Promise
    then_(v => {
      fn(v)
      resolve(v)
    }, p)
  }

  let catchTap = (fn, p) => {
    open Js.Promise
    catch(err => {
      fn(err)
      reject(err->Obj.magic)
    }, p)
  }

  let then = (p, fn) => Js.Promise.then_(fn, p)

  let then_map = (p, fn) => {
    open Js.Promise
    then_(v => resolve(fn(v)), p)
  }
}