open Yojson.Basic.Util
open Tyxml.Html

let rec format_datetime iso_string =
  match Ptime.of_rfc3339 iso_string ~strict:false with
  | Ok (time, _, _) ->
      let year, month, day = Ptime.to_date time in
      let time_str = Ptime.to_rfc3339 ~tz_offset_s:0 time in
      Printf.sprintf "%04d-%02d-%02d %s" year month day
        (String.sub time_str 11 5)
  | Error _ ->
      (* Try adding Z for timestamps that are missing TZ info *)
      if String.ends_with ~suffix:"Z" iso_string then iso_string
      else format_datetime @@ iso_string ^ "Z"

let event_to_html event =
  let title = event |> member "title" |> to_string in
  let description = event |> member "description" |> to_string in
  let url = event |> member "url" |> to_string in
  let venue = event |> member "venue" |> to_string in
  let start_time = event |> member "start" |> to_string |> format_datetime in
  let end_time = event |> member "end" |> to_string |> format_datetime in
  div
    ~a:[ a_class [ "event-card" ] ]
    [
      a
        ~a:[ a_href url; a_class [ "event-title-link" ] ]
        [ h2 ~a:[ a_class [ "event-title" ] ] [ txt title ] ];
      p ~a:[ a_class [ "event-description" ] ] [ txt description ];
      p ~a:[ a_class [ "event-venue" ] ] [ txt ("Venue: " ^ venue) ];
      p
        ~a:[ a_class [ "event-time" ] ]
        [ txt ("Time: " ^ start_time ^ " — " ^ end_time) ];
    ]

let generate_html events =
  let events_html = List.map event_to_html events in
  let page_header =
    header
      [
        h1 [ txt "Delhi NCR events" ];
        p
          [
            txt
              "An aggregator for events in Delhi NCR by @punchagan and friends";
          ];
      ]
  in
  let page =
    html
      (head
         (title (txt "Delhi NCR Events"))
         [
           link ~rel:[ `Stylesheet ]
             ~href:"https://cdn.simplecss.org/simple.min.css" ();
         ])
      (body @@ [ page_header ] @ events_html)
  in
  Format.asprintf "%a" (Tyxml.Html.pp ()) page

let write_to_file root filename data =
  if not (Sys.file_exists root) then Unix.mkdir root 0o755;
  let path = Filename.concat root filename in
  let channel = Stdlib.open_out path in
  Stdlib.output_string channel data;
  Stdlib.close_out channel
