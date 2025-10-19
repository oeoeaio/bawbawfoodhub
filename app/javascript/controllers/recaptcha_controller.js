import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form", "token"]

  // This is to avoid a token timeout
  execute(event) {
    event.preventDefault()
    let ctrl = this

    grecaptcha.enterprise.ready(() => {
      grecaptcha.enterprise.execute(ctrl.siteKey, { action: ctrl.action }).then((token) => {
        ctrl.tokenTarget.value = token
        ctrl.formTarget.submit()
      })
    })
  }

  get siteKey() {
    return this.data.get("siteKey")
  }

  get action() {
    return this.data.get("action")
  }
}
