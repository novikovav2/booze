const formButton = document.getElementsByClassName('form-button')[0]
const emailInput = document.getElementById('user_email')
const passwordInput = document.getElementById('user_password')
const confirmInput = document.getElementById('user_password_confirmation')

const changeHandler = () => {
    if (emailInput.validity.valid
        && passwordInput.validity.valid
        && confirmInput.validity.valid
        && passwordsEquals()) {
        formButton.disabled = false
    } else {
        formButton.disabled = true
    }
}

const passwordsEquals = () => {
    const password = passwordInput.value
    const confirm = confirmInput.value

    return password === confirm
}

const passwordEqualHandler = () => {
    const message = document.getElementById('confirm-message')
    message.style.display = passwordsEquals() ? 'none' : 'block'
}

emailInput.addEventListener('input', changeHandler)
passwordInput.addEventListener('input', changeHandler)
confirmInput.addEventListener('input', changeHandler)

confirmInput.addEventListener('input', passwordEqualHandler)