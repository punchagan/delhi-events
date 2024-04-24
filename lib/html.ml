open Tyxml.Html

let format_datetime t =
  let year, month, day = Ptime.to_date t in
  let time_str = Ptime.to_rfc3339 ~tz_offset_s:0 t in
  Printf.sprintf "%04d-%02d-%02d %s" year month day (String.sub time_str 11 5)

let event_to_html (event : Events.event) =
  let start_time = format_datetime event.start_time in
  let description =
    if event.has_markdown then
      let doc = Cmarkit.Doc.of_string ~strict:true event.description in
      let html_text = Cmarkit_html.of_doc ~safe:true doc in
      [ Unsafe.data html_text ]
    else [ txt event.description ]
  in
  let time =
    match event.end_time with
    | Some t -> start_time ^ " — " ^ format_datetime t
    | None -> start_time
  in
  div
    ~a:[ a_class [ "event-card" ] ]
    [
      a
        ~a:[ a_href event.url; a_class [ "event-title-link" ] ]
        [ h2 ~a:[ a_class [ "event-title" ] ] [ txt event.title ] ];
      details
        ~a:[ a_class [ "event-description" ] ]
        (summary [ txt "Description" ])
        description;
      p ~a:[ a_class [ "event-venue" ] ] [ txt @@ Events.venue event ];
      p ~a:[ a_class [ "event-time" ] ] [ txt ("Time: " ^ time) ];
    ]

let generate events =
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
  let page_footer =
    footer
      [
        ul
          ~a:[ a_class [ "footer-list" ] ]
          [
            li [ a ~a:[ a_href "" ] [ txt "Home" ] ];
            li [ a ~a:[ a_href "./events.ics" ] [ txt "Calendar" ] ];
          ];
      ]
  in
  let page =
    html
      (head
         (title (txt "Delhi NCR Events"))
         [
           meta ~a:[ a_charset "UTF-8" ] ();
           meta
             ~a:
               [
                 a_name "viewport";
                 a_content "width=device-width, initial-scale=1.0";
               ]
             ();
           link ~rel:[ `Stylesheet ]
             ~href:"https://cdn.simplecss.org/simple.min.css" ();
           style [ txt Asset.styles ];
         ])
      (body @@ [ page_header ] @ events_html @ [ page_footer ])
  in
  Format.asprintf "%a" (Tyxml.Html.pp ~indent:true ()) page
