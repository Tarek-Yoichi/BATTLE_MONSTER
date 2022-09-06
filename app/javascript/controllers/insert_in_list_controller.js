import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="insert-in-list"
export default class extends Controller {
  //static event = "connect"
  static targets = ["items"]
  connect() {
    console.log("coucou");
    this.interval = setInterval(this.update_user, 1000);
  }

  update_user =()=> {
    console.log("ici");
    fetch("/connect", { headers: {accept: "application/json"}})
    .then(response => response.json())
    .then((data) => {
      console.log("connect");
      this.itemsTarget.innerHTML = data.html;
    })
  }


  disconnect() {
    clearInterval(this.interval)
  }
}
