const checkbox = document.getElementById('countable')
const block = document.getElementById('hidden')

checkbox.addEventListener('change', (event) => {
    if (event.target.checked) {
        block.style.display = 'block'
    } else {
        block.style.display = 'none'
    }
})