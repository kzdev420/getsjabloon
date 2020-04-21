import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "input", "amount", "discounted_amount", "status", "indicator" ]

  connect() {
    this.timeout         = null
    this.duration        = this.data.get("duration")     || 600
    this.intlFormat      = this.data.get("intlFormat")   || "en-US"
    this.validColor      = this.data.get("validColor")   || "bg-green-500"
    this.inValidColor    = this.data.get("inValidColor") || "bg-red-500"
    this.isCouponApplied = false
    this.clearDiscount()
  }

  checkValidity() {
    clearTimeout(this.timeout)

    this.setStatus("Checking…")
    this.timeout = setTimeout(() => {
      fetch(`${this.data.get("url")}?code=${this.inputTarget.value}`)
      .then(response => response.json())
      .then(response => {
        this.showResponse(response)
      })
    }, this.duration)
  }

  showResponse(response) {
    const status = response.status

    if (status == "valid") {
      this.calculateNewAmount(response)
      this.showStatusMessage(response)
    }
    else if(status == "not valid") {
      this.setStatus("Coupon not valid or expired")
      this.indicatorTarget.classList.remove(this.validColor)
      this.indicatorTarget.classList.add(this.inValidColor)
      this.clearDiscount()
    }
  }

  error() {
    this.setStatus("Sorry. Something went wrong.")
  }

  setStatus(message) {
    this.statusTarget.textContent = message
  }

  calculateNewAmount(response) {
    if (this.isCouponApplied) return

    var amount     = parseInt(this.amountTarget.textContent)
    var new_amount = null

    if (response.percent_off) {
      var percent  = parseInt(response.percent_off)
      var discount = (amount / 100) * percent
      new_amount   = amount - discount
    } else {
      var amount_off = parseInt(response.amount_off) / 100
      new_amount     = amount - amount_off
    }

    this.showNewAmount(new_amount, response.currency)
  }

  showStatusMessage(response) {
    var message = null

    if (!!response.percent_off) {
      message = `${response.percent_off}% off ${this.time_period(response.duration, response.duration_in_months)}`
    } else {
      message = `${(parseInt(response.amount_off) / 100).toLocaleString(this.intlFormat, { style: "currency", currency: (response.currency || "usd") })} off ${this.time_period(response.duration, response.duration_in_months)}`
    }

    this.setStatus(message)
  }

  time_period(duration, duration_in_months) {
    var time_period = null

    if (!!duration_in_months) {
      time_period = ` for ${duration_in_months} month${(duration_in_months === 1) ? "" : "s"}`
    } else {
      time_period = duration
    }

    return time_period
  }

  clearDiscount() {
    this.amountTarget.classList.remove("line-through")
    this.discounted_amountTarget.textContent = ""
    this.isCouponApplied = false
  }

  showNewAmount(new_amount, currency) {
    this.discounted_amountTarget.textContent = (new_amount).toLocaleString(this.intlFormat)
    this.amountTarget.classList.add("line-through")
    this.indicatorTarget.classList.add(this.validColor)
    this.isCouponApplied = true
  }
}

