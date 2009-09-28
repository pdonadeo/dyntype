(*pp camlp4o -I ../lib -I `ocamlfind query type-conv` pa_type_conv.cmo pa_orm.cma *)

TYPE_CONV_PATH "Tuple"

type x = {
  foo: int32;
  bar: string * char
}
with orm()

open Orm
open OUnit
open Test_utils

let name = "tuple.db"
let x = { foo = 1000l ; bar = ("hello",'w') }
let px n x = Printf.eprintf "%s = { foo=%lu ; bar=(%s,%c) }\n" n x.foo (fst x.bar) (snd x.bar)

let test_init () =
  ignore(open_db init name);
  ignore(open_db ~rm:false init name);
  ignore(open_db ~rm:false init name)

let test_save () =
  let db = open_db init name in
  x_save db x

let test_update () =
  let db = open_db init name in
  x_save db x;
  x_save db x

let test_get () =
  let db = open_db ~rm:false init name in
  let i = x_get db in
  "1 in db" @? (List.length i = 1);
  let i = List.hd i in
  "values match" @? (i.foo = x.foo && (i.bar = x.bar))

let test_save_get () =
  let db = open_db init name in
  x_save db x;
  let i = x_get db in
  "1 in db" @? (List.length i = 1);
  let i = List.hd i in
  px "x" x;
  px "i" i;
  "structural values equal" @? ( x = i);
  "physical values equal" @? ( x == i)

let suite = [
  "tuple_init" >:: test_init;
  "tuple_save" >:: test_save;
  "tuple_update" >:: test_update;
  "tuple_update" >:: test_update;
  "tuple_get" >:: test_get;
  "tuple_save_get" >:: test_save_get;
]

