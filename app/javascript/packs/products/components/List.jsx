import React from "react";
import ListItem from "./ListItem";

const List = (props) => {
    if (props.dataLoaded) {
        return <div className="eaters-list">
            <p className="eaters-list_title">
                {props.title}
            </p>
            <div className="eaters-list_body">
                {props.list.map(user =>
                     <ListItem key={user.id} user={user}
                               numerable={props.numerable}
                               clickHandle={props.clickHandle}
                               plusOne={props.plusOne}
                               minusOne={props.minusOne}
                    />
                )}
            </div>
        </div>
    } else {
        return <div className="eaters-list">
            <p className="eaters-list_title">
                {props.title}
            </p>
            <div className="eaters-list_body">
                Загружается...
            </div>
        </div>
    }
}

export default List