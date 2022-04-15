import React from "react";

const ListItem = (props) => {


    return <div className={"eaters-list_item " + (props.user.selected ? 'eaters-selected' : '')}
                onClick={props.clickHandle}
                id={props.user.id}>
        { props.user.username }
        {(props.numerable) ?
            <p>
                {props.user.count} шт.
                (<a href='#' onClick={props.plusOne} id={props.user}> +1 </a>
                /
                {props.user.count > 1 ?
                    <a href='#' onClick={props.minusOne}> -1 </a> : ''
                })
            </p> : ''
        }
    </div>
}

export default ListItem