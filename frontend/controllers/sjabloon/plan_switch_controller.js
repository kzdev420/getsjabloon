import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "select", "amount", "interval", "button" ]

  connect() {
    this.selectActiveClass = "bg-blue-400"
    this.planParam         = "plan"
  }

  toggle(event) {
    var currentInterval = event.target.dataset.planSwitchTargetValue
    if (currentInterval == this.interval) return

    this.toggleAmounts()
    this.toggleIntervals()
    this.toggleSelects()
    this.toggleButtons()

    this.data.set("interval", (this.interval == "month" ? "year" : "month"))
  }

  toggleAmounts() {
    this.amountTargets.forEach((el, i) => {
      el.textContent = (this.interval == "month" ? el.dataset.planSwitchYearAmount : el.dataset.planSwitchMonthAmount)
    })
  }

  toggleIntervals() {
    this.intervalTargets.forEach((el, i) => {
      el.textContent = (this.interval == "month" ? "year" : "month")
    })
  }

  toggleSelects() {
    this.selectTargets.forEach((el, i) => {
      el.classList.remove(this.selectActiveClass)
      event.target.classList.add(this.selectActiveClass)
    })
  }

  toggleButtons() {
    this.buttonTargets.forEach((el, i) => {
      var href = new URL(el.href);

      href.searchParams.set(this.planParam, (this.interval == "month" ? el.dataset.planSwitchYearId : el.dataset.planSwitchMonthId));
      el.href = href.toString()
    })
  }

  get interval() {
    return this.data.get("interval")
  }
}

