open Icalendar

let domain = "delhincr.events"

let event_to_ical (event : Events.event) =
  let empty = Params.empty in
  let uid = (empty, Printf.sprintf "event-%s@%s" event.id domain) in
  let dtstamp = (empty, Ptime_clock.now ()) in
  let dtstart = (empty, `Datetime (`Utc event.start_time)) in
  let dtend =
    match event.end_time with
    | Some t -> Some (`Dtend (empty, `Datetime (`Utc t)))
    | _ -> None
  in
  let summary = event.title in
  let description = event.description in
  let location = Events.venue event in
  let props =
    [
      `Summary (empty, summary);
      `Description (empty, description);
      `Location (empty, location);
      `Url (empty, Uri.of_string event.url);
    ]
  in
  let props =
    match event.location with
    | Some geo -> [ `Geo (empty, (geo.latitude, geo.longitude)) ] @ props
    | None -> props
  in
  let alarms = [] in
  let rrule = None in
  `Event
    { uid; dtstamp; dtstart; dtend_or_duration = dtend; rrule; props; alarms }

let generate events =
  let ical_events = List.map event_to_ical events in
  let empty = Params.empty in
  let cal_props =
    [
      `Prodid (empty, "-//Delhi NCR Events//All Events//EN");
      `Version (empty, "0.1");
    ]
  in
  let cal = (cal_props, ical_events) in
  to_ics cal
