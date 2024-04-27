open Lib.Types;

[@react.component]
let make = (~events) => {
  <>
    {Array.map(
       (event: Lib.Types.event) => {<Event key={event.id} event />},
       events,
     )
     |> React.array}
  </>;
};
