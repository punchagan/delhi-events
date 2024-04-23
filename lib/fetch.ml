open Cohttp_eio
open Eio.Std

let meetup_url = "https://www.meetup.com"

let null_auth ?ip:_ ~host:_ _ =
  (* FIXME: use a real authenticator!!! *)
  Ok None

let https ~authenticator =
  let tls_config = Tls.Config.client ~authenticator () in
  fun uri raw ->
    let host =
      Uri.host uri
      |> Option.map (fun x -> Domain_name.(host_exn (of_string_exn x)))
    in
    Tls_eio.client_of_flow ?host tls_config raw

let fetch_webpage ~net url =
  let client =
    Cohttp_eio.Client.make ~https:(Some (https ~authenticator:null_auth)) net
  in
  Eio.Switch.run @@ fun sw ->
  let uri = Uri.of_string url in
  let resp, body = Client.get client ~sw uri in
  if Http.Status.compare resp.status `OK = 0 then
    let content = Eio.Buf_read.(parse_exn take_all) body ~max_size:max_int in
    Some content
  else None

let extract_build_version html_content =
  let soup = Soup.parse html_content in
  match Soup.select_one "meta[name=\"X-Build-Version\"]" soup with
  | Some tag -> Soup.R.attribute "content" tag
  | None -> failwith "X-Build-Version tag not found"

let get_version () =
  Eio_main.run @@ fun env ->
  Mirage_crypto_rng_eio.run (module Mirage_crypto_rng.Fortuna) env @@ fun () ->
  let net = env#net in
  let version =
    match fetch_webpage ~net meetup_url with
    | Some page_content -> extract_build_version page_content
    | None -> failwith "No page content"
  in
  version

let meetup_urls version =
  let groups = [ "pydelhi"; "rustdelhi" ] in
  List.map
    (fun name ->
      Printf.sprintf "%s/_next/data/%s/en-US/%s/events/calendar.json" meetup_url
        version name)
    groups

let meetup_event_to_event ~venues event =
  let open Yojson.Safe.Util in
  let get_time_opt event k =
    match event |> member k |> Events.datetime_of_yojson with
    | Ok s -> Some s
    | Error _ -> None
  in
  let start_time = get_time_opt event "dateTime" in
  let end_time = get_time_opt event "endTime" in
  let venue_ref = member "venue" event |> member "__ref" in
  let venue_id =
    match venue_ref with
    | `String venue_id -> (
        match String.split_on_char ':' venue_id with
        | [ _; venue_id ] -> Some venue_id
        | _ -> None)
    | _ -> None
  in
  let venue_name, venue_address =
    match venue_id with
    | Some venue_id ->
        let venue = Hashtbl.find venues venue_id in
        let name = venue |> member "name" |> to_string in
        let address = venue |> member "address" |> to_string in
        let city = venue |> member "city" |> to_string in
        let full_address =
          match (address, city) with
          | "", "" -> ""
          | x, "" -> x
          | "", x -> x
          | x, y -> Printf.sprintf "%s, %s" x y
        in
        (name, Some full_address)
    | None -> ("Unknown", None)
  in
  match start_time with
  | Some start_time ->
      Some
        {
          Events.id =
            event |> member "id" |> to_string |> Printf.sprintf "meetup-%s";
          title = event |> member "title" |> to_string;
          (* FIXME: Markdown? *)
          description = event |> member "description" |> to_string;
          url = event |> member "eventUrl" |> to_string;
          start_time;
          end_time;
          venue_name;
          venue_address;
          location = None;
        }
  | None ->
      Printf.printf "Skipping event with no start_time: %s"
        (Yojson.Safe.pretty_to_string event);
      None

let filter_key_starts_with ~prefix = function
  | `Assoc l ->
      `Assoc (List.filter (fun (k, _) -> String.starts_with ~prefix k) l)
  | _ -> failwith "Expected an assoc list"

let extract_meetup_events json_str =
  let json = Yojson.Safe.from_string json_str in
  let open Yojson.Safe.Util in
  let data = json |> member "pageProps" |> member "__APOLLO_STATE__" in
  let venues_json = data |> filter_key_starts_with ~prefix:"Venue:" |> values in
  let venues = Hashtbl.create 10 in
  List.iter
    (fun x -> Hashtbl.add venues (member "id" x |> to_string) x)
    venues_json;
  let events = data |> filter_key_starts_with ~prefix:"Event:" |> values in
  List.filter_map (meetup_event_to_event ~venues) events

let run events_db =
  let version = get_version () in
  let urls = meetup_urls version in
  Eio_main.run @@ fun env ->
  Mirage_crypto_rng_eio.run (module Mirage_crypto_rng.Fortuna) env @@ fun () ->
  let net = env#net in
  let events = ref [] in
  let requests =
    List.map
      (fun url () ->
        match fetch_webpage ~net url with
        | Some content -> events := [ extract_meetup_events content ] @ !events
        | None -> ())
      urls
  in
  Fiber.all requests;
  (* FIXME: Filter old events? Probably in the generation phase? *)
  let events_json =
    !events |> List.concat
    |> List.sort (fun (a : Events.event) b ->
           Stdlib.compare b.start_time a.start_time)
    |> List.map Events.event_to_yojson
    |> fun es -> `Assoc [ ("events", `List es) ]
  in
  let chan = open_out events_db in
  Yojson.Safe.pretty_to_channel chan events_json;
  close_out chan
