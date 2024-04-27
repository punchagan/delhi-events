(* FIXME: Remove duplicated code when figuring out sharing *)
let venue (event : Types.event) =
  match event.venue_address with
  | Some address when address <> "" ->
      (* FIXME: Use of printf -> large bundle?! *)
      Printf.sprintf "Venue: %s, %s" event.venue_name address
  | _ -> Printf.sprintf "Venue: %s" event.venue_name
