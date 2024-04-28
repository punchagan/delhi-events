open Lib.Types;

[@react.component]
let make = (~events) => {
  let (displayedEvents, setDisplayedEvents) = React.useState(() => [||]);
  let (showAll, setShowAll) = React.useState(() => false);

  React.useEffect2(
    () => {
      let es =
        showAll
          ? events
          : List.filter(
              e => {
                let _now = Js.Date.make();
                e.start_time > _now;
              },
              events |> Array.to_list,
            )
            |> Array.of_list;
      setDisplayedEvents(_ => es);
      None;
    },
    (showAll, events),
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
    <EventFilter setShowAll />
    {Array.length(displayedEvents) > 0 ? eventList : noEvents}
  </>;
};
