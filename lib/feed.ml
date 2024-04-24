let rss_to_string rss =
  let open Format in
  let buf = Buffer.create 256 in
  let fmt = formatter_of_buffer buf in
  Rss.print_channel ~indent:0 fmt rss;

  pp_print_flush fmt ();
  (* Flush the formatter to ensure all data is written to the buffer *)
  Buffer.contents buf (* Return the contents of the buffer as a string *)

let create_rss_item (event : Events.event) =
  let title = event.title in
  let link = Uri.of_string event.url in
  let desc =
    if event.has_markdown then Events.description_html event
    else event.description
  in
  let guid = Rss.Guid_permalink link in
  let pubdate =
    match event.created_time with Some t -> t | _ -> event.start_time
  in
  Rss.item ~title ~link ~desc ~guid ~pubdate ()

let generate events =
  let items = List.map create_rss_item events in
  let title = "Delhi NCR Events" in
  let link = Uri.of_string "http://example.com" in
  let desc = "Upcoming events in the Delhi NCR area" in
  let language = "en-us" in
  let pubdate = Ptime_clock.now () in
  let last_build_date = Ptime_clock.now () in
  let generator = "OCaml RSS library" in
  let rss =
    Rss.channel ~title ~link ~desc ~language ~pubdate ~last_build_date
      ~generator items
  in
  rss_to_string rss
