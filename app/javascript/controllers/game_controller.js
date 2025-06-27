import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static values = { gameId: Number }

  connect() {
    console.log('Game controller connected')
    this.direction = null
    this.nextDirection = null
    this.quit = false
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
    console.log('Game controller disconnected')
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

  startLoop() {
    this.interval = setInterval(() => this.tick(), 500)
  }

  tick() {
    // // Если quit уже нажали — останови цикл до запроса
    // if (this.quit) {
    //   clearInterval(this.interval)
    //   alert('Game over!')
    //   return
    // }

    if (this.nextDirection) {
      this.direction = this.nextDirection
      this.nextDirection = null
    }

    let headers = {
      Accept: 'text/vnd.turbo-stream.html',
      'X-CSRF-Token': document.querySelector("meta[name='csrf-token']").content,
      'Content-Type': 'application/json',
    }

    let body = JSON.stringify({
      direction: this.direction,
      quit: this.quit,
    })

    fetch(`/games/${this.gameIdValue}`, {
      method: 'PATCH',
      headers: headers,
      body: body,
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
          Turbo.visit('/games')
          return
        }
      })
      .catch((error) => {
        console.error('Turbo Stream update failed:', error)
      })
  }
}
