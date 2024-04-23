open Delhi_events
open Cmdliner

let input_arg =
  let doc = "Path to the input JSON file with events." in
  Arg.(
    value
    & opt string "data/events.json"
    & info [ "i"; "input" ] ~docv:"FILE" ~doc)

let output_dir_arg =
  let doc = "Directory where the output files will be saved." in
  Arg.(value & opt string "output" & info [ "o"; "output" ] ~docv:"DIR" ~doc)

let generate_output_cmd =
  let doc = "Generate HTML, RSS and iCal output from the events list" in
  let term = Term.(const Generate.run $ input_arg $ output_dir_arg) in
  let info =
    Cmd.info "generate" ~doc ~sdocs:"COMMON OPTIONS" ~exits:Cmd.Exit.defaults
  in
  Cmd.v info term

let default_cmd =
  let doc = "Generate event pages from a JSON file" in
  let term = Term.(ret (const (fun _ -> `Help (`Pager, None)) $ const ())) in
  let info =
    Cmd.info "generate_events" ~doc ~sdocs:"COMMON OPTIONS"
      ~exits:Cmd.Exit.defaults
  in
  Cmd.group ~default:term info [ generate_output_cmd ]

let () = Cmd.eval default_cmd |> exit
