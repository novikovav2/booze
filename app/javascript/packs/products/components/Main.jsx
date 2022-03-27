import React, {useEffect, useRef, useState} from "react";
import List from "./List";
import Buttons from "./Buttons";

const Main = () => {
    const id = document.getElementById('id').value
    const url = `/products/${id}/eaters`
    const [eatersList, setEatersList] = useState([])
    const [nonEatersList, setNonEatersList] = useState([])
    const dataChanged = useRef(false)
    const [dataLoaded, setDataLoaded] = useState(false)

    const eaterItemClickHandle = (e) => {
        const id = +e.target.id
        const newList = eatersList.map((item) => {
            return item.id === id ? {...item, selected: !item.selected} : item
        })
        setEatersList(newList)
    }

    const nonEaterItemClickHandle = (e) => {
        const id = +e.target.id
        const newList = nonEatersList.map((item) => {
            return item.id === id ? {...item, selected: !item.selected} : item
        })
        setNonEatersList(newList)
    }

    const pushDataToDB = async () => {
        const token = document.querySelector('[name=csrf-token]').content
        try {
            const response = await fetch(url, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'X-CSRF-TOKEN': token
                },
                body: JSON.stringify({
                    eaters: eatersList
                })
            })
            return { success: true }
        } catch (error) {
            console.log(error)
            return { success: false }
        }
    }

    const allToRightBtnHandle = (e) => {
        e.preventDefault()
        setNonEatersList([...nonEatersList, ...eatersList])
        setEatersList([])
        dataChanged.current = true
    }

    const selectedToRightBtnHandle = (e) => {
        e.preventDefault()
        let selectedItems = []
        let newList = []
        eatersList.forEach((item) => {
            if (item.selected) {
                item.selected = false
                selectedItems.push(item)
            } else {
                newList.push(item)
            }
        })
        setNonEatersList([...nonEatersList, ...selectedItems])
        setEatersList(newList)
        console.log(eatersList === newList)
        dataChanged.current = true
    }

    const selectedToLeftBtnHandle = (e) => {
        e.preventDefault()
        let selectedItems = []
        let newList = []
        nonEatersList.forEach((item) => {
            if (item.selected) {
                item.selected = false
                selectedItems.push(item)
            } else {
                newList.push(item)
            }
        })
        setEatersList([...eatersList, ...selectedItems])
        setNonEatersList(newList)
        dataChanged.current = true
    }

    const allToLeftBtnHandle = (e) => {
        e.preventDefault()
        setEatersList([...eatersList, ...nonEatersList])
        setNonEatersList([])
        dataChanged.current = true
    }

    const fetchInitialData = async () => {
        try {
            const response = await fetch(url)
            const data = await response.json()
            return {
                success: true,
                eatersList: data.eaters,
                nonEatersList: data.nonEaters
            }
        } catch (error) {
            console.log(error)
            return { success: false }
        }
    }

    useEffect(async () => {
        if (dataChanged.current) {
            await pushDataToDB()
            dataChanged.current = false
        }
    }, [eatersList])

    useEffect(async () => {
        const data = await fetchInitialData()
        if (data.success) {
            const eaters = data.eatersList.map((item) => {
                return {...item, selected: false}   // Add selected field to data
            })
            const nonEaters = data.nonEatersList.map((item) => {
                return {...item, selected: false}
            })
            setEatersList(eaters)
            setNonEatersList(nonEaters)
            setDataLoaded(true)
        }
    }, [])



    return <div className="eaters-container">
        <List title="Употребляли" list={eatersList}
              clickHandle={eaterItemClickHandle}
              dataLoaded={dataLoaded}
        />
        <Buttons allToRight={allToRightBtnHandle}
                 allToLeft={allToLeftBtnHandle}
                 selectedToRight={selectedToRightBtnHandle}
                 selectedToLeft={selectedToLeftBtnHandle}
        />
        <List title="Не употребляли" list={nonEatersList}
              clickHandle={nonEaterItemClickHandle}
              dataLoaded={dataLoaded}
        />
    </div>

}
export default Main