import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["form"]

  submitForm(event) {
    let isValid = this.validateForm(this.formTarget)

    if (!isValid) {
      event.preventDefault()
    }
  }

  validateForm() {
    let isValid = true
    let requiredFieldSelectors = "textarea:required, input:required"
    let requiredFields         = this.formTarget.querySelectorAll(requiredFieldSelectors)

    requiredFields.forEach((field) => {
      if (!field.disabled && !field.value.trim()) {
        field.classList.add("input__invalid")
        field.focus()

        isValid = false

        return false
      }
    })

    if (!isValid) {
      return false
    }

    let invalidFields = this.formTarget.querySelectorAll("input:invalid")

    invalidFields.forEach((field) => {
      if (!field.disabled) {
        field.classList.add("input__invalid")
        field.focus()

        isValid = false
      }
    })

    return isValid
  }
}

