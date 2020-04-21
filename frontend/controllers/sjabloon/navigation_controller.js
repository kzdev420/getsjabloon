import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "items", "toggle", "component" ]

  connect() {
    this.classOnScroll = this.data.get("class-on-scroll") || "nav--is-scrolling"
  }

  toggle() {
    this.itemsTarget.classList.toggle("nav__items--visible");
    this.toggleTarget.classList.toggle("nav__toggle--toggled");

    if(this.toggleTarget.textContent == "menu") {
      this.toggleTarget.textContent = "close"
    } else {
      this.toggleTarget.textContent = "menu"
    }
  }

  onScroll() {
    this.componentTarget.classList.toggle(
      this.classOnScroll, window.scrollY > this.navigationComponentHeight()
    )
  }

  navigationComponentHeight() {
    return this.componentTarget.clientHeight
  }
}

