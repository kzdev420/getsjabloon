import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "link", "field" ]

  connect() {
    this.hiddenClass  = this.data.get("hiddenClass")  || "hidden"
    this.visibleClass = this.data.get("visibleClass") || "block"
  }

  toggle() {
    if (this.hasLinkTarget) {
      this.linkTarget.classList.add(this.hiddenClass)
    }

    this.fieldTarget.classList.toggle(this.visibleClass)
    this.fieldTarget.classList.toggle(this.hiddenClass)
    this.fieldTarget.focus()
  }
}

