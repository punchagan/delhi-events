open Lib.Types;

[@react.component]
let make = (~events) => {
  let (displayedEvents, setDisplayedEvents) = React.useState(() => [||]);
  let (showAll, setShowAll) = React.useState(() => false);
  let (showOnline, setShowOnline) = React.useState(() => false);

  React.useEffect3(
    () => {
      let es =
        events
        |> Array.to_list
        |> List.filter(e => {
             let _now = Js.Date.make();
             showAll || e.start_time > _now;
           })
        |> List.filter(e => {
             let _now = Js.Date.make();
             showOnline || !e.is_online;
           })
        |> Array.of_list;
      setDisplayedEvents(_ => es);
      None;
    },
    (showAll, showOnline, events),
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
    <EventFilter setShowAll setShowOnline />
    {Array.length(displayedEvents) > 0 ? eventList : noEvents}
  </>;
};
