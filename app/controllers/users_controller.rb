# app/controllers/users_controller.rb
class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      respond_to do |format|
        format.html { redirect_to root_path, notice: "Рєестрація успішна!" }
        format.turbo_stream
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @user = User.find(params[:id])
    if params[:all]
      @games = @user.games.order(created_at: :desc)
    else
      @games = @user.games.order(created_at: :desc).limit(5)
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end
end
