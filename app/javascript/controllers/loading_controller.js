import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="loading"
export default class extends Controller {
  static targets = ["load"]
  connect() {
    this.interval = setInterval(this.refreshRender, 1000);
  }

  refreshRender = () => {

    fetch( window.location.href, { headers: {accept: "application/json"} })
      .then(response => response.json())
      .then((data) => {
        this.loadTarget.innerHTML = data.html;
      }
    )

  }

  disconnect() {
    clearInterval(this.interval)
  }
}
