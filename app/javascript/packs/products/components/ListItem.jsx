import React from "react";

const ListItem = (props) => {
    return <div className={"eaters-list_item " + (props.user.selected ? 'eaters-selected' : '')}
                onClick={props.clickHandle}
                id={props.user.id}>
        { props.user.username }
    </div>
}

export default ListItem