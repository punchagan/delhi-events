open Yojson.Safe.Util

type datetime = Ptime.t

let datetime_to_yojson (t : Ptime.t) =
  `String (Ptime.to_rfc3339 ~tz_offset_s:0 t)

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
  url : string;
  venue : string;
  start_time : datetime; [@key "start"]
  end_time : datetime option; [@default None] [@key "end"]
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
