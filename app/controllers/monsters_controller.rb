class MonstersController < ApplicationController
  def new
    Monster.new
  end

  def create
    @monster = Monster.new(monster_params)
    @monster.user = current_user
    @monster.xp = 0
    if @monster.save!
      current_user.onboard = true
      redirect_to page_start_tutoriel_path
    else
      render :start_monster, status: :unprocessable_entity
    end
  end

  private

  def monster_params
    params.require(:monster).permit(:name, :specie_id)
  end
end
