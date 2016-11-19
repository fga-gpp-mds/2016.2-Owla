class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token if Rails.env.test?
  before_action :not_allow_to_enter_login, only: [:new]

  def new
  end

  def create
    member = Member.find_by(email: params[:session][:email].downcase)
    if member && member.authenticate(params[:session][:password])
      log_in member
      redirect_to home_path(member)
      flash[:success] = 'Log in bem-sucedido!'
    else
      if Member.find_by(email: params[:session][:email])
        flash.now[:danger] = 'Invalid password'
      else
        flash.now[:danger] = 'Invalid email or password'
      end
      render 'new'
    end
  end

  def destroy
    if current_member
      log_out
    end
    redirect_to root_path
  end
end
