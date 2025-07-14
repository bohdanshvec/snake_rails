class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      respond_to do |format|
        format.html { redirect_to root_path, notice: "Успішний вхід!" }
        format.turbo_stream
      end
    else
      flash.now[:alert] = "Невірна пошта або пароль"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session.delete(:user_id)
    redirect_to root_path, notice: "Ви вийшли з акаунту"
  end
end
