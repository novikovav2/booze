const menu = document.getElementById('header-menu')
const close = document.getElementById('header-menu-close')
const show = document.getElementById('header-menu-show')

show.addEventListener('click', (event) => {
    event.preventDefault()
    menu.style.display = 'flex'
})

close.addEventListener('click', (event) => {
    event.preventDefault()
    menu.style.display = 'none'
})