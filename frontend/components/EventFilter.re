[@react.component]
let make = (~setShowAll, ~setShowOnline) => {
  <>
    {<form>
       <p>
         <label>
           <input
             type_="checkbox"
             onChange={_ => {setShowAll(prev => !prev)}}
           />
           {React.string("Show All Events")}
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
