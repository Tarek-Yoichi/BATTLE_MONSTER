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
    # @user = current_user
    # if @user.onboard
    #   redirect_to
  end

  def start_monster
    @monster = Monster.new
  end

  def start_tutoriel
    # @user = current_user
    # @monster = Monster.find(params[:id])
    #   redirect_to page_main_path
  end

  def combats
  end

  def edit
  end
end
