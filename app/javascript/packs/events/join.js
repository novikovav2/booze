const link = document.getElementById('join-link')
const msg = document.getElementById('join-confirm')



link.addEventListener('click', (event) => {
    event.preventDefault()
    const url = event.target.text
    navigator.clipboard.writeText(url);

    msg.style.display = 'block'
    setInterval(() => {
        msg.style.display = 'none'
    }, 3000)
})

