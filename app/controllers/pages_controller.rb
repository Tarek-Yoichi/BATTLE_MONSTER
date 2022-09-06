class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

  def home
  end

  def profil
    @user = User.find(params[:id])
  end

  def main
  end

  def start_intro
  end

  def start_monster
    @monster = Monster.new
  end

  def start_tutoriel
  end

  def combats
  end

  def edit
  end
end
