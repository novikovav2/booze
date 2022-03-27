import React from "react";

const Buttons = (props) => {
    return <div className={"eaters-buttons"}>
        <a href="#" className={"eaters-button"} onClick={props.allToRight}>
            <i className="fa-solid fa-angles-right"></i>
        </a>
        <a href="#" className={"eaters-button"} onClick={props.selectedToRight}>
            <i className="fa-solid fa-chevron-right"></i>
        </a>
        <a href="#" className={"eaters-button"} onClick={props.selectedToLeft}>
            <i className="fa-solid fa-chevron-left"></i>
        </a>
        <a href="#" className={"eaters-button"} onClick={props.allToLeft}>
            <i className="fa-solid fa-angles-left"></i>
        </a>
    </div>
}

export default Buttons