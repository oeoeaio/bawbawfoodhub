import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["boxSize", "frequency", "dayOfWeek", "delivery", "address", "summary", "terms", "termsFrequency"]

  initialize() {
    this.updateSummary()
  }

  updateSummary() {
    this.dispatch(
      'optionsChanged',
      {
        target: this.summaryTarget,
        detail: {
          deliveryVal: this.deliveryTarget.value,
          dayOfWeekVal: this.dayOfWeekTarget.value,
        }
      }
    )
  }

  resetDayOfWeek() {
    const delivery = this.deliveryTarget.value
    const dayOfWeek = (delivery === "true" ? 'wednesday' : 'tuesday')
    this.dayOfWeekTarget.value = dayOfWeek
  }

  updateDelivery() {
    const delivery = this.deliveryTarget.value
    this.addressTarget.classList.toggle('hidden', delivery === "false")
    this.resetDayOfWeek()
    this.updateSummary()
  }

  updateFrequency(){
    this.termsFrequencyTarget.textContent = this.frequencyTarget.value.replace("ly","")
  }

  updateSize(event) {
    this.boxSizeTargets.forEach((target) => {
      this.dispatch('sizeChanged', { target: target, detail: { sizeSelected: event.target.value } })
    })
  }

  toggleTerms() {
    this.termsTarget.classList.toggle('hidden')
  }
}
