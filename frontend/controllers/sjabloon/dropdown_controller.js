import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "menu", "icon" ]

  connect() {
    this.toggleClass = this.data.get("class")           || "hidden"
    this.iconToggleClass = this.data.get("toggleClass") || "dropdown__icon--toggled"
  }

  toggle() {
    this.menuTarget.classList.toggle(this.toggleClass)

    if (this.hasIconTarget) {
      this.iconTarget.classList.toggle(this.iconToggleClass)
    }
  }

  hide(event) {
    if ((this.element.contains(event.target) === false) && (!this.menuTarget.classList.contains(this.toggleClass))) {
      this.menuTarget.classList.add(this.toggleClass)

      if (this.hasIconTarget) {
        this.iconTarget.classList.toggle(this.iconToggleClass)
      }
    }
  }
}

