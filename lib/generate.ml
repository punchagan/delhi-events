let write_to_file root filename data =
  if not (Sys.file_exists root) then Unix.mkdir root 0o755;
  let path = Filename.concat root filename in
  let channel = Stdlib.open_out path in
  Stdlib.output_string channel data;
  Stdlib.close_out channel

let run input_file output_dir =
  let events = Events.read_events input_file in
  let html_output = Html.generate events in
  let cal_output = Cal.generate events in
  let rss_output = Feed.generate events in
  let static_dir = Filename.concat output_dir "static" in
  write_to_file output_dir "index.html" html_output;
  write_to_file static_dir "events.ics" cal_output;
  write_to_file static_dir "events.rss" rss_output;
  ()
