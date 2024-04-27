(* FIXME: Figure out sharing with conditional PPX preprocessing yojson vs *)
(* json.browser to avoid redefining this here... *)

open Ppx_deriving_json_runtime.Primitives

type t = Js.Json.t
type datetime = Js.Date.t

let of_json_error msg = Js.Exn.raiseError msg

let datetime_to_json (dt : datetime) : t =
  (Obj.magic Js.Date.toISOString dt : t)

let datetime_of_json (json : t) : datetime =
  if Js.typeof json = "string" then Js.Date.fromString (Obj.magic json : string)
  else of_json_error "expected a string"

type location = { latitude : float; longitude : float } [@@deriving json]

type event = {
  id : string;
  title : string;
  description : string;
  has_markdown : bool; [@default false]
  url : string;
  start_time : datetime; [@key "start"]
  end_time : datetime option; [@default None] [@key "end"]
  created_time : datetime option; [@default None] [@key "created"]
  venue_name : string;
  venue_address : string option;
  location : location option;
}
[@@deriving json]

type data = { events : t array }
