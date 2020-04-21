import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "wrapper" ]

  close() {
    this.wrapperTarget.classList.add("flashHideAnimation")
  }
}


