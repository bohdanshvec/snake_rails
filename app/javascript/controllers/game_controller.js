import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static values = { gameId: Number }

  connect() {
    console.log('Game controller connected')
    this.direction = null
    this.nextDirection = null
    this.quit = false
    this.handleKey = this.handleKey.bind(this)
    this.handleTouch = this.handleTouch.bind(this)

    if (!this.hasGameIdValue || this.gameIdValue <= 0) {
      requestAnimationFrame(() => this.waitForGameId())
      return
    }

    this.initializeGame()
  }

  waitForGameId() {
    if (!this.hasGameIdValue || this.gameIdValue <= 0) {
      requestAnimationFrame(() => this.waitForGameId())
      return
    }

    this.initializeGame()
  }

  initializeGame() {
    document.addEventListener('keydown', this.handleKey)
    this.startLoop()
  }

  disconnect() {
    clearInterval(this.interval)
    document.removeEventListener('keydown', this.handleKey)
  }

  handleKey(event) {
    const dir = {
      ArrowUp: 'up',
      ArrowDown: 'down',
      ArrowLeft: 'left',
      ArrowRight: 'right',
    }[event.key]

    if (dir) {
      this.nextDirection = dir
    }

    if (event.key === 'Escape') {
      this.quit = true
    }
  }

  handleTouch(event) {
    const button = event.target.closest('button[data-direction]')
    if (!button) return

    const direction = button.dataset.direction
    if (['up', 'down', 'left', 'right'].includes(direction)) {
      this.nextDirection = direction
    }
  }

  startLoop() {
    this.interval = setInterval(() => this.tick(), 300)
  }

  tick() {
    if (this.nextDirection) {
      this.direction = this.nextDirection
      this.nextDirection = null
    }

    const headers = {
      Accept: 'text/vnd.turbo-stream.html',
      'X-CSRF-Token': document.querySelector("meta[name='csrf-token']").content,
      'Content-Type': 'application/json',
    }

    const body = JSON.stringify({
      direction: this.direction,
      quit: this.quit,
    })

    fetch(`/games/${this.gameIdValue}`, {
      method: 'PATCH',
      headers,
      body,
    })
      .then((response) => {
        if (!response.ok) throw new Error('Network response was not ok')
        return response.text()
      })
      .then((html) => {
        Turbo.renderStreamMessage(html)

        const field = document.getElementById('field')
        if (field?.dataset.gameOver === 'true') {
          alert('Game over!')
          clearInterval(this.interval)
          Turbo.visit('/games')
        }
      })
      .catch((error) => {
        console.error('Turbo Stream update failed:', error)
      })
  }
}
