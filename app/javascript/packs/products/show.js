const id = document.getElementById('id').value
const url = `/products/${id}/`

const nameInput = document.getElementById('name')
const priceInput = document.getElementById('price')
const totalInput = document.getElementById('total')

nameInput.addEventListener('change', async (e) => {
    e.preventDefault()
    const data = {
        name: e.target.value
    }
    if (await sendData(data)) {
        nameInput.classList.remove('product-input_error')
    } else {
        nameInput.classList.add('product-input_error')
    }
})

priceInput.addEventListener('change', async (e) => {
    e.preventDefault()
    const data = {
        price: e.target.value
    }
    if (await sendData(data)) {
        priceInput.classList.remove('product-input_error')
    } else {
        priceInput.classList.add('product-input_error')
    }
})

totalInput.addEventListener('change', async (e) => {
    e.preventDefault()
    const data = {
        total: e.target.value
    }
    if (await sendData(data)) {
        totalInput.classList.remove('product-input_error')
    } else {
        totalInput.classList.add('product-input_error')
    }
})

const sendData = async (data = {}) => {
    let result = true
    try {
        const response = await fetch(url, {
            method: 'PUT',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(data)
        })
        result = response.ok
    } catch (error) {
        result = false
    }
    return result
}