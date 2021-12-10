const formButton = document.getElementsByClassName('form-button')[0]
const emailInput = document.getElementById('user_email')
const passwordInput = document.getElementById('user_password')

const changeHandler = () => {
    if (emailInput.validity.valid && passwordInput.validity.valid) {
        formButton.disabled = false
    } else {
        formButton.disabled = true
    }
}

emailInput.addEventListener('input', changeHandler)
passwordInput.addEventListener('input', changeHandler)
