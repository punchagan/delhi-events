open Yojson.Basic.Util

let read_events path =
  let json = Yojson.Basic.from_file path in
  json |> member "events" |> to_list
