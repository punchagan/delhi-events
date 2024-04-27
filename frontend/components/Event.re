open Lib.Types;
module H = Lib.Event_helpers;
[@mel.module "marked"] external marked: string => string = "marked";

let format_datetime = t => {
  let (year, month, date) = (
    Js.Date.getFullYear(t),
    Js.Date.getMonth(t) +. 1.,
    Js.Date.getDate(t),
  );
  let (hours, minutes) = (Js.Date.getHours(t), Js.Date.getMinutes(t));
  Printf.sprintf(
    "%04d-%02d-%02d %02d:%02d",
    int_of_float(year),
    int_of_float(month),
    int_of_float(date),
    int_of_float(hours),
    int_of_float(minutes),
  );
};

let time = event => {
  let start_time = format_datetime(event.start_time);
  let t =
    switch (event.end_time) {
    | Some(t) => start_time ++ {j| — |j} ++ format_datetime(t)
    | None => start_time
    };
  "Time: " ++ t;
};

[@react.component]
let make = (~event) => {
  let description =
    if (event.has_markdown) {
      <div dangerouslySetInnerHTML={"__html": marked(event.description)} />;
    } else {
      React.string(event.description);
    };
  <>
    <a href={event.url} className="event-title-link">
      <h2 className="event-title"> {React.string(event.title)} </h2>
    </a>
    <details className="event-description">
      <summary> {React.string("Description")} </summary>
      description
    </details>
    <p className="event-venue"> {React.string(H.venue(event))} </p>
    <p className="event-time"> {React.string(time(event))} </p>
  </>;
};
