class PasswordResetsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(email: params[:email])

    if @user.present?
      # send email
      PasswordMailer.with(user: @user).reset.deliver_later
    end

    redirect_to root_path, notice: "Email sent to reset password"
  end

  def edit
    @user = User.find_signed!(params[:token], purpose: "password_reset")

  rescue ActiveSupport::MessageVerifier::InvalidSignature
    redirect_to sign_in_path, alert: "token expired"
  end

  def update
    @user = User.find_signed!(params[:token], purpose: "password_reset")

    if @user.update(password_params)
      redirect_to sign_in_path, notice: "Password changed successfully. please login"
    else
      render :edit, status: 422
    end
  end

  private

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end