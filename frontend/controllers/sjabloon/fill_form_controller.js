import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "button" ]

  connect() {
    if (this.formElementsOnPage() && this.devEnvironment()) {
      this.addComponent()
    }
  }

  addComponent() {
    this.element.insertAdjacentHTML('beforeend',
      this.buttonTag()
    )
  }

  analysePage() {
    if (this.formElementsOnPage() == 1) {
      this.fillForm()
    } else {
      this.buttonTarget.text = 'Too many forms on this page…'
    }
  }

  analysePageWithKeybinding(e) {
    if (e.key === 'f') {
      this.analysePage()
    }
  }

  buttonTag() {
    return `
      <button
        class="fixed bottom-0 right-0 mb-4 mr-4 p-2 bg-gray-900 text-gray-100 rounded shadow-lg"
        data-target="sjabloon--fill-form.button"
        data-action="click->sjabloon--fill-form#analysePage keydown@window->sjabloon--fill-form#analysePageWithKeybinding"
        >
        Fill form
      </button>
    `
  }

  fillForm() {
    const forms = document.getElementsByTagName('form');

    [].forEach.call(forms, (form) => {
      const inputs = form.getElementsByTagName('input')

      this.fillInputsFor(form)
    })
  }

  fillInputsFor(form) {
    const inputs = form.getElementsByTagName('input');

    [].forEach.call(inputs, (input) => {
      let regex     = /(^.*\[|\].*$)/g;
      let inputName = input.name.replace(regex, '');

      switch (inputName) {
        case 'name':
          input.value = this.randomiseValue(this.nameValueOptions())
        break;
        case 'email':
          input.value = this.randomiseValue(this.emailValueOptions())
        break;
        case 'password':
          input.value = this.randomiseValue(this.passwordValueOptions())
        break;
      }
    })
  }

  nameValueOptions() {
    return [
      'Eelco', 'Kate', 'Cameron'
    ]
  }

  emailValueOptions() {
    return [
      'test@example.com'
    ]
  }

  passwordValueOptions() {
    return [
      '1234'
    ]
  }

  randomiseValue(items) {
    return items[Math.floor(Math.random() * items.length)]
  }

  formElementsOnPage() {
    return this.numberOfFormElements() > 0
  }

  numberOfFormElements() {
    return document.getElementsByTagName('form').length
  }

  devEnvironment() {
    return process.env.RAILS_ENV === 'development'
  }
}


