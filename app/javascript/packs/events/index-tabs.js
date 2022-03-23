const activeLink = document.getElementById('set-active')
const archivedLink = document.getElementById('set-archive')
const activeDiv = document.getElementById('active')
const archivedDiv = document.getElementById('archive')

activeLink.addEventListener('click', (e) => {
    e.preventDefault()
    activeDiv.style.display = 'block'
    archivedDiv.style.display = 'none'
})

archivedLink.addEventListener('click', (e) => {
    e.preventDefault()
    activeDiv.style.display = 'none'
    archivedDiv.style.display = 'block'
})