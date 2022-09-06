class BattlesController < ApplicationController
  def match
    # j'instancie la battle
    # je trouve un user connecté
    # je valide le match
  end

  def create
    # j'enregistre la battle
    # je redirige vers setup
    @battle = Battle.new
    @battle.pc_win = 10
    @battle.xp_win = 20
    @battle.status = "waiting"
    @battle.save!
    @deck_1 = Deck.new
    @deck_1.user = current_user
    @deck_1.monster_id = current_user.monsters.first.id


    @deck_1.battle_id = @battle.id
    @deck_1.save!
    @user_2 = User.find(params[:battle][:user_id])
    @deck_2 = Deck.new
    @deck_2.user_id = @user_2.id

    @deck_2.monster_id = @user_2.monsters.first.id
    @deck_2.battle_id = @battle.id
    @deck_2.save!
    @battle.current_deck = @deck_1
    @battle.save!
    redirect_to connect_path
  end

  def setup
    @battle = Battle.find(params[:battle_id])
    @setup_deck = @battle.decks.where(user_id: current_user).first
    @setup_deck.monster = current_user.monsters.first
    @setup_deck.save
    @setup_specie = @setup_deck.monster.specie
  end

  def setup_create
    # j'enregistre le setup
    # je redirige vers loading
  end

  def loading
    @battle = Battle.find(params[:battle_id])
    @battle.current_deck = @battle.decks.first
    @battle.save
    select_deck
    respond_to do |format|
      format.html
      format.json do
        render json: {
          html: render_to_string(partial: 'load', locals: { battle: @battle, deck1: @deck1, deck2: @deck2 }, formats: [:html])
        }
      end
    end
  end

  def show
    @battle = Battle.find(params[:id])
    @current_deck = @battle.current_deck
    select_deck
    redirect_to battle_setup_path(@battle, @my_deck) if @my_deck.empty
    @battle.status = "started" if @battle.status == "pending"
    @battle.save
  end

  def next_round
    @battle = Battle.find(params[:battle_id])
    select_deck

    @fail = false
    success = rand * 100 <= current_attack.success
    if success
      if (@next_deck.hp - current_attack.damage).positive?
        @battle.round += 1
        @next_deck.hp -= current_attack.damage
      else
        @next_deck.hp = 0
      end
    else
      @battle.round += 1
      @fail = true
    end
    @next_deck.save

    @current_deck = @battle.current_deck
    @current_deck = @next_deck
    @current_deck.save

    if @battle.save
      deck1_html = render_to_string(partial: "round", locals: { battle: @battle, deck1: @deck1, deck2: @deck2, current_deck: @current_deck, next_deck: @next_deck, current_user: @deck1.user })
      DeckChannel.broadcast_to(
        @deck1,
        { html: deck1_html, deckID: @my_deck.id, deck1_HP: @deck1.hp, deck2_HP: @deck2.hp, current_attack: current_attack, fail: @fail}.to_json
      )
      deck2_html = render_to_string(partial: "round", locals: { battle: @battle, deck1: @deck1, deck2: @deck2, current_deck: @current_deck, next_deck: @next_deck, current_user: @deck2.user })
      DeckChannel.broadcast_to(
        @deck2,
        { html: deck2_html, deckID: @my_deck.id, deck1_HP: @deck1.hp, deck2_HP: @deck2.hp, current_attack: current_attack, fail: @fail }.to_json
      )
      head :ok
      # redirect_to battle_path(@battle)
    else
      render :show, status: :unprocessable_entity
    end
  end

  def update
    @battle = Battle.find(params[:id])
    @battle.update(game_over)
    @battle.status = "finished"
    winner = User.find(@battle.winner_id)
    winner_monster = winner.monsters.first
    winner.pc += @battle.pc_win
    winner_monster.xp += @battle.xp_win

    if @battle.save
      winner.save
      winner_monster.save
      redirect_to profil_path(current_user)
    else
      render :show, status: :unprocessable_entity
    end
  end

  def connect
    # @users = User.where(lived: 5.seconds.ago..)
    # current_user.update(lived: Time.now)
    # respond_to do |format|
    #   format.html
    #   format.json { render json: @users}
    # end
    @pending_deck = current_user.decks.joins(:battle).where(battles: {status: "pending"}).last

    current_user.update(lived: Time.now)
    @users = User.where(lived: 10.seconds.ago..).where.not(id: current_user.id)
    respond_to do |format|
      format.html
      format.json do
        render json: {
          html: render_to_string(partial: "users", locals: {users: @users, pending_deck: @pending_deck}, formats: [:html] )
        }
      end
    end
  end

  def accept
    @battle = Battle.find(params[:battle_id])
    @battle.status = "pending"
    @battle.save
    redirect_to   battle_setup_path(@battle.id)
  end

  private

  def select_deck
    @deck1 = @battle.decks.first
    @deck2 = @battle.decks.last
    if current_user == @deck1.user
      @next_deck = @deck2
      @my_deck = @deck1

    else
      @next_deck = @deck1
      @my_deck = @deck2
    end
  end

  def current_attack
    case params[:attack]
    when 'one'
      @my_deck.attack_one
    when 'two'
      @my_deck.attack_two
    when 'three'
      @my_deck.attack_three
    end
  end

  def game_over
    params.require(:battle).permit(:winner_id)
  end

end
