import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  connect() {
    setTimeout(() => {
      this.element.style.transition = 'opacity 2s ease'
      this.element.style.opacity = '0'

      setTimeout(() => {
        this.element.remove()
      }, 2000)
    }, 2000)
  }
}
