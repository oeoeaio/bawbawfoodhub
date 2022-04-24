import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["delivery", "dayOfWeek", "tuesday", "wednesday", "thursday"]
  static values = {
    delivery: String,
    dayOfWeek: String,
  }

  update({ detail: { deliveryVal, dayOfWeekVal } }) {
    this.deliveryValue = deliveryVal
    this.dayOfWeekValue = dayOfWeekVal

    this.element.classList.toggle('hidden', !(this.dayOfWeekValid && this.deliveryValid))
  }

  get validDays() {
    return ['tuesday', 'wednesday', 'thursday']
  }

  get deliveryValid() {
    return ["true", "false"].includes(this.deliveryValue)
  }

  get dayOfWeekValid() {
    return this.validDays.includes(this.dayOfWeekValue)
  }

  deliveryValueChanged() {
    if (!this.deliveryValid) return

    const deliveryText = (this.deliveryValue === "true" ? "delivery" : "pickup")
    this.deliveryTarget.textContent = deliveryText
  }

  dayOfWeekValueChanged() {
    if (!this.dayOfWeekValid) return

    const dayOfWeekText = this.dayOfWeekValue.replace(/^\w/, c => c.toUpperCase())
    this.dayOfWeekTarget.textContent = dayOfWeekText
    this.validDays.forEach((dayOfWeekName, i) => {
      this[`${dayOfWeekName}Target`].classList.toggle('hidden', this.dayOfWeekValue !== dayOfWeekName)
    })
  }
}
