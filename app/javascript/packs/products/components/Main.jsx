import React, {useCallback, useEffect, useRef, useState} from "react";
import List from "./List";
import Buttons from "./Buttons";

const Main = () => {
    const id = document.getElementById('id').value
    const url = `/products/${id}/eaters`
    const [eatersList, setEatersList] = useState([])
    const [nonEatersList, setNonEatersList] = useState([])
    const dataChanged = useRef(false)
    const [dataLoaded, setDataLoaded] = useState(false)
    const [total, setTotal] = useState(0)

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

    const eaterPlusOne = async (e) => {
        e.preventDefault()
        const eaterId = +e.target.parentNode.parentNode.id
        if (eaterId) {
            const newEaterList = []
            eatersList.forEach((eater) => {
                if (eater.id === eaterId) {
                    ++eater.count
                }
                newEaterList.push(eater)
            })
            setEatersList(newEaterList)
            dataChanged.current = true
        }
    }

    const eaterMinusOne = (e) => {
        e.preventDefault()
        const eaterId = +e.target.parentNode.parentNode.id
        if (eaterId) {
            const newEaterList = []
            const newNonEaterList = []
            eatersList.forEach((eater) => {
                let item = { ...eater }
                if (eater.id === eaterId) {
                    --eater.count
                }
                if (eater.count === 0) {
                    newNonEaterList.push(eater)
                } else {
                    newEaterList.push(eater)
                }
            })
            setEatersList(newEaterList)

            if (newNonEaterList.length > 0) {
                setNonEatersList([...nonEatersList, ...newNonEaterList])
            }
            dataChanged.current = true
        }
    }

    useEffect(() => {
        const changeData = async () => {
            if (dataChanged.current) {
                await pushDataToDB()
                dataChanged.current = false
            }
        }
        changeData()
    }, [eatersList])

    useEffect(() => {
        const getDate = async () => {
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
        }
        getDate()
    }, [])

    useEffect(() => {
        const getTotalEl = async () => {
            const totalEl = document.getElementById('total')
            setTotal(+totalEl.value)
        }
        getTotalEl()
    }, [])

    return <div className="eaters-container">
        <List title="Употребляли" list={eatersList}
              clickHandle={eaterItemClickHandle}
              dataLoaded={dataLoaded}
              numerable={total > 0}
              plusOne={eaterPlusOne}
              minusOne={eaterMinusOne}
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