import { Controller } from "@hotwired/stimulus"
import { end } from "@popperjs/core"
import { createConsumer } from "@rails/actioncable"

export default class extends Controller {
  static values = { deckId: Number, deck1Id: Number, deck2Id: Number }
  static targets = ["round", "rounds"]

  connect() {
    this.channel = createConsumer().subscriptions.create(
      { channel: "DeckChannel", id: this.deckIdValue },
      { received: data => {
          const json = JSON.parse(data)
          this.roundsTarget.innerHTML = json.html
          const roundControl = document.querySelector('#round-controls')

          const monster1 = document.querySelector('#arena-deck-1-monster')
          const monster2 = document.querySelector('#arena-deck-2-monster')
          const arenaAttack1 = document.querySelector('#arena-attack-1')
          const arenaAttack2 = document.querySelector('#arena-attack-2')
          arenaAttack1.style.visibility="visible";
          arenaAttack2.style.visibility="visible";

          let attackSkin = "0"
          if (json.fail == false) {
            attackSkin = json.current_attack.id
          }

          arenaAttack1.style.background = "url('https://onepage.dropagence.fr/game/bm/img/static/attack/" + attackSkin + "')";
          arenaAttack2.style.background = "url('https://onepage.dropagence.fr/game/bm/img/static/attack/" + attackSkin + "')";
          // arenaAttack1.innerHTML = "<h3>" + json.current_attack.name + "</h3>"
          // arenaAttack2.innerHTML = "<h3>" + json.current_attack.name + "</h3>"

          if (json.deckID == this.deck1IdValue) {
            // start
            monster1.classList.add('attack')
            roundControl.classList.add('controls-off')
            // cascade
            monster1.addEventListener("animationend", function(){
              arenaAttack1.classList.add('attack-1')
            });

            // if fail false
            if (json.fail == false) {
              arenaAttack1.addEventListener("animationend", function(){
                arenaAttack1.style.visibility="hidden";
                arenaAttack2.style.visibility="hidden";
                monster2.classList.add('hurt')
              });

              monster2.addEventListener("animationend", function(){
                document.querySelector('.prog-2').style.width="" + json.deck2_HP + "%"
              });

              document.querySelector('#progress2').addEventListener("transitionend", function(){
                roundControl.classList.remove('controls-off')
                arenaAttack1.classList.remove('attack-1')
                arenaAttack2.classList.remove('attack-2')
                monster2.classList.remove('hurt')
                monster1.classList.remove('attack')
                monster1.classList.remove('hurt')
                monster2.classList.remove('attack')
                if (json.deck2_HP <= 0 ) {
                  monster2.classList.add('die')
                  document.querySelector('.die').addEventListener("animationend", function(){
                    arenaAttack2.classList.remove('attack-2')
                    arenaAttack1.classList.remove('attack-1')
                    monster2.classList.add('ground')
                  })
                }
              });
            // else (fail)
            } else {
              arenaAttack1.addEventListener("animationend", function(){
                arenaAttack1.style.visibility="hidden";
                arenaAttack2.style.visibility="hidden";
                // monster1.classList.add('hurt')
                arenaAttack1.classList.remove('attack-1')
                arenaAttack2.classList.remove('attack-2')
                monster2.classList.remove('hurt')
                monster1.classList.remove('attack')
                monster2.classList.remove('attack')
                setTimeout(() => {
                  roundControl.classList.remove('controls-off')
                  monster1.classList.remove('hurt')
                }, 1000)
              });
            }

          // joueur 2
          } else if (json.deckID == this.deck2IdValue) {
            monster2.classList.add('attack')
            roundControl.classList.add('controls-off')
            // cascade
            monster2.addEventListener("animationend", function(){
              arenaAttack2.classList.add('attack-2')
            });

            // if fail false
            if (json.fail == false) {
              arenaAttack2.addEventListener("animationend", function(){
                arenaAttack2.style.visibility="hidden";
                arenaAttack1.style.visibility="hidden";
                monster1.classList.add('hurt')
              });

              monster1.addEventListener("animationend", function(){
                document.querySelector('.prog-1').style.width="" + json.deck1_HP + "%"
              });

              document.querySelector('#progress1').addEventListener("transitionend", function(){
                roundControl.classList.remove('controls-off')
                arenaAttack2.classList.remove('attack-2')
                arenaAttack1.classList.remove('attack-1')
                monster1.classList.remove('hurt')
                monster2.classList.remove('attack')
                monster2.classList.remove('hurt')
                monster1.classList.remove('attack')
                if (json.deck1_HP <= 0 ) {
                  monster1.classList.add('die')
                  document.querySelector('.die').addEventListener("animationend", function(){
                    arenaAttack2.classList.remove('attack-2')
                    arenaAttack1.classList.remove('attack-1')
                    monster1.classList.add('ground')
                  })
                }
              });
            // else (fail)
            } else {
              arenaAttack2.addEventListener("animationend", function(){
                arenaAttack1.style.visibility="hidden";
                arenaAttack2.style.visibility="hidden";
                // monster2.classList.add('hurt')
                arenaAttack1.classList.remove('attack-1')
                arenaAttack2.classList.remove('attack-2')
                monster2.classList.remove('hurt')
                monster1.classList.remove('attack')
                monster1.classList.remove('hurt')
                setTimeout(() => {
                  roundControl.classList.remove('controls-off')
                  monster2.classList.remove('attack')
                }, 1000)
              });
            }
          }
        }
      }
    )
  }

  next(e, attack) {
    e.preventDefault();
    console.log(e)
    fetch(e.target.parentElement.parentElement.href + '?attack=' + attack, {headers: {"Accept": "text/html"}})
      .then(response => response.text())
      .then((data) => {
        // console.log('data2', data)
      }
    )
  }

  one(e) { this.next(e, 'one') }
  two(e) { this.next(e, 'two') }
  three(e) { this.next(e, 'three') }

}
