import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { gameId: Number }

  connect() {
    console.log("Game controller connected")
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
    console.log("Game ID:", this.gameIdValue)
    document.addEventListener("keydown", this.handleKey)
    this.startLoop()
  }

  disconnect() {
    console.log("Game controller disconnected")
    clearInterval(this.interval)
    document.removeEventListener("keydown", this.handleKey)
  }

  handleKey(event) {
    const dir = {
      ArrowUp: "up",
      ArrowDown: "down",
      ArrowLeft: "left",
      ArrowRight: "right",
    }[event.key]

    if (dir) this.direction = dir
  }

  startLoop() {
    this.interval = setInterval(() => this.tick(), 1000)
  }


  tick() {
    let headers = {
      Accept: "text/vnd.turbo-stream.html",
      "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").content,
    }

    let body = null

    if (this.direction) {
      headers["Content-Type"] = "application/json"
      body = JSON.stringify({ direction: this.direction })
    }

    fetch(`/games/${this.gameIdValue}`, {
      method: "PATCH",
      headers: headers,
      body: body,
    })
      .then(response => {
        if (!response.ok) throw new Error("Network response was not ok")
        return response.text()
      })
      .then(html => {
        Turbo.renderStreamMessage(html)
      })
      .catch(error => {
        console.error("Turbo Stream update failed:", error)
      })
  }
}
