type t = [
  | `Channel of string
  | `Id of int
]

let wrap (x : Yojson.Safe.json) : t =
  match x with
  | `String s -> `Channel s
  | `Int n -> `Id n
  | _ -> invalid_arg "Chat_id.wrap"

let unwrap (x : t) : Yojson.Safe.json =
  match x with
  | `Channel s -> `String s
  | `Id n -> `Int n
