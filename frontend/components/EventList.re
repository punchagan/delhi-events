open Lib.Types;

[@react.component]
let make = (~events) => {
  let (displayedEvents, setDisplayedEvents) = React.useState(() => [||]);
  let (showPast, setShowPast) = React.useState(() => false);
  let (showOnline, setShowOnline) = React.useState(() => false);

  React.useEffect3(
    () => {
      let es =
        events
        |> Array.to_list
        |> List.filter(e => {
             let _now = Js.Date.make();
             showPast || e.start_time > _now;
           })
        |> List.filter(e => {
             let _now = Js.Date.make();
             showOnline || !e.is_online;
           })
        |> Array.of_list;
      setDisplayedEvents(_ => es);
      None;
    },
    (showPast, showOnline, events),
  );

  let eventList = {
    Array.map(
      (event: Lib.Types.event) => {<Event key={event.id} event />},
      displayedEvents,
    )
    |> React.array;
  };

  let noEvents = {
    <p style={ReactDOM.Style.make(~textAlign="center", ())}>
      {React.string("No upcoming events")}
    </p>;
  };

  <>
    <EventFilter setShowPast setShowOnline />
    {Array.length(displayedEvents) > 0 ? eventList : noEvents}
  </>;
};
