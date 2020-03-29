import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["form", "token"]

  execute(event) {
    event.preventDefault()
    let ctrl = this

    grecaptcha.ready(() => {
      grecaptcha.execute(ctrl.siteKey, { action: ctrl.action }).then((token) => {
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
