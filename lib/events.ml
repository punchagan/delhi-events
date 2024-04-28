open Yojson.Safe.Util

type datetime = Ptime.t

let tz_offset_s = int_of_float (3600. *. 5.5)
let datetime_to_yojson (t : Ptime.t) = `String (Ptime.to_rfc3339 ~tz_offset_s t)

let datetime_of_yojson = function
  | `String s -> (
      match Ptime.of_rfc3339 s with
      | Ok (t, _, _) -> Ok t
      | Error _ -> (
          match Ptime.of_rfc3339 (s ^ "Z") with
          | Ok (t, _, _) -> Ok t
          | Error _ -> Error "Invalid RFC3339 date format"))
  | _ -> Error "Expected a string for RFC3339 date"

type location = { latitude : float; longitude : float } [@@deriving yojson]

type event = {
  id : string;
  title : string;
  description : string;
  has_markdown : bool; [@default false]
  is_online : bool; [@default false]
  url : string;
  start_time : datetime; [@key "start"]
  end_time : datetime option; [@default None] [@key "end"]
  created_time : datetime option; [@default None] [@key "created"]
  venue_name : string;
  venue_address : string option;
  location : location option;
}
[@@deriving yojson { strict = false }]

let read_events path =
  let json = Yojson.Safe.from_file path in
  json |> member "events" |> to_list
  |> List.filter_map (fun event ->
         match event_of_yojson event with
         | Ok e -> Some e
         | Error e ->
             Printf.printf "Failed to parse event: %s (Error: %s)"
               (Yojson.Safe.to_string event)
               e;
             None)

let venue event =
  match event.venue_address with
  | Some address when address <> "" ->
      Printf.sprintf "Venue: %s, %s" event.venue_name address
  | _ -> Printf.sprintf "Venue: %s" event.venue_name

let description_html event =
  if event.has_markdown then
    let doc = Cmarkit.Doc.of_string ~strict:true event.description in
    Cmarkit_html.of_doc ~safe:true doc
  else event.description
