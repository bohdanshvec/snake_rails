import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static values = { gameId: Number }

  connect() {
    console.log('Tick called for Game ID:', this.gameIdValue)
    this.direction = null
    this.handleKey = this.handleKey.bind(this)

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
    console.log('Game ID:', this.gameIdValue)
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

    if (dir) this.direction = dir
  }

  startLoop() {
    this.interval = setInterval(() => this.tick(), 150)
  }

  tick() {
    const body = this.direction
      ? JSON.stringify({ direction: this.direction })
      : null

    fetch(`/games/${this.gameIdValue}/tick`, {
      method: 'POST',
      headers: {
        Accept: 'text/vnd.turbo-stream.html',
        'X-CSRF-Token': document.querySelector("meta[name='csrf-token']")
          .content,
        'Content-Type': 'application/json',
      },
      body: body,
    })
  }
}
