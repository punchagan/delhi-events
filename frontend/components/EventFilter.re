[@react.component]
let make = (~setShowPast, ~setShowOnline) => {
  <>
    {<form>
       <p>
         <label>
           <input
             type_="checkbox"
             onChange={_ => {setShowPast(prev => !prev)}}
           />
           {React.string("Show Past Events")}
         </label>
         <label>
           <input
             type_="checkbox"
             onChange={_ => {setShowOnline(prev => !prev)}}
           />
           {React.string("Show Online Events")}
         </label>
       </p>
     </form>}
  </>;
};
