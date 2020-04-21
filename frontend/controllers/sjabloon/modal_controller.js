import { Controller } from "stimulus"
import { setCookie } from "./utilities.js"

export default class extends Controller {
  static targets = [ "background", "container" ]

  connect(e) {
    this.toggleClass        = this.data.get("class")              || "hidden"
    this.setCookieOnClose   = this.data.get("cookieOnClose")      || false
    this.stopScroll         = this.data.get("stopScroll")         || true
    this.storeCookieForDays = this.data.get("storeCookieForDays") || 28

    if (this.data.get('intervalTimeInSeconds')) { this.setTimer() }
  }

  open(e) {
    if (this.stopScroll == true) { this.lockScroll() }

    this.containerTarget.classList.remove(this.toggleClass)
  }

  close(e) {
    e.preventDefault()

    this.unlockScroll()

    this.containerTarget.classList.add(this.toggleClass)

    if (this.setCookieOnClose) { setCookie(this.storeCookieForDays, `_${this.data.get("cookieName")}`, true) }
  }

  closeBackground(e) {
    if (e.target === this.backgroundTarget) { this.close(e) }
  }

  closeWithKeyboard(e) {
    if (e.keyCode === 27) {
      this.close(e)
    }
  }

  lockScroll () {
    let scrollbarWidth               = window.innerWidth - document.documentElement.clientWidth
    document.body.style.paddingRight = `${scrollbarWidth}px`
    document.body.style.overflow     = "hidden"
  }

  unlockScroll() {
    document.body.style.paddingRight = null
    document.body.style.overflow     = null
  }

  setTimer() {
    setTimeout(() => { this.open() }, Number(this.data.get('intervalTimeInSeconds')) * 1000)
  }
}

