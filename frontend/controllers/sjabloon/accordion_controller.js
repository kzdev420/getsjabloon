import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "pointer", "content", "icon" ]

  connect() {
    this.activeClass      = this.data.get("activeClass")      || "active"
    this.toggleIconClass  = this.data.get("toggleIconClass")  || "toggled"
  }

  toggle(event) {
    event.preventDefault()
    this.index = this.pointerTargets.indexOf(event.currentTarget)
  }

  showContent() {
    this.pointerTargets.forEach((pointer, index) => {
      const content = this.contentTargets[index]
      const icon    = this.iconTargets[index]
      content.classList.toggle(this.activeClass, index == this.index)

      if (index === this.index) {
        icon.classList.add(this.toggleIconClass)
      } else {
        icon.classList.remove(this.toggleIconClass)
      }
    })
  }

  get index() {
    return parseInt(this.data.get("index") || 0)
  }

  set index(value) {
    this.data.set("index", value)
    this.showContent()
  }
}

