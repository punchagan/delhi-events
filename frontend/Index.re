module EventList = Components.EventList;
open Lib.Types;
external fetch: string => 'a = "fetch";

module App = {
  [@react.component]
  let make = () => {
    let (events, setEvents) = React.useState(() => [||]);

    // Fetch events.json and setEvents
    React.useEffect0(() => {
      let _ =
        fetch("./events.json")
        |> Js.Promise.then_(response => {
             let _p =
               switch (response##ok) {
               | true =>
                 response##json()
                 |> Js.Promise.then_(data => {
                      setEvents(_ => data.events |> Array.map(event_of_json));
                      Js.Promise.resolve();
                    })
               | _ => Js.Promise.reject(failwith("Network error"))
               };
             _p;
           });
      None;
    });

    <EventList events />;
  };
};

let node = ReactDOM.querySelector("#app");
switch (node) {
| None =>
  Js.Console.error("Failed to start React: couldn't find the #app element")
| Some(root) =>
  let root = ReactDOM.Client.createRoot(root);
  ReactDOM.Client.render(root, <App />);
};
