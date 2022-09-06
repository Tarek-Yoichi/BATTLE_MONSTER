class DecksController < ApplicationController
  def update
    @deck = Deck.find(params[:id])
    @deck.update(setup_params)
    @deck.empty = false
    if @deck.attack_one && @deck.attack_two && @deck.attack_three && @deck.save
      redirect_to battle_loading_path(@deck.battle)
    else
      redirect_to battle_setup_path(@battle, @deck)
    end
  end

  private

  def setup_params
    params.require(:deck).permit(:attack_one_id, :attack_two_id, :attack_three_id)
  end
end
