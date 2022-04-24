import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  select({ params, detail: { sizeSelected } }) {
    this.element.classList.toggle('selected', params.size === sizeSelected)
  }
}
