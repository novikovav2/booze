const activeLink = document.getElementById('set-active')
const archivedLink = document.getElementById('set-archive')
const activeDiv = document.getElementById('active')
const archivedDiv = document.getElementById('archive')

activeLink.addEventListener('click', (e) => {
    e.preventDefault()
    activeDiv.style.display = 'block'
    archivedDiv.style.display = 'none'
    activeLink.classList.add('status-links_active')
    archivedLink.classList.remove('status-links_active')
})

archivedLink.addEventListener('click', (e) => {
    e.preventDefault()
    activeDiv.style.display = 'none'
    archivedDiv.style.display = 'block'
    activeLink.classList.remove('status-links_active')
    archivedLink.classList.add('status-links_active')
})