[@react.component]
let make = (~setShowAll) => {
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
       </p>
     </form>}
  </>;
};
