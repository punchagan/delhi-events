let write_to_file root filename data =
  if not (Sys.file_exists root) then Unix.mkdir root 0o755;
  let path = Filename.concat root filename in
  let channel = Stdlib.open_out path in
  Stdlib.output_string channel data;
  Stdlib.close_out channel
