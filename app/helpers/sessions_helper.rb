module SessionsHelper

  def log_in(member)
    session[:member_id] = member.id
    cookies[:member_id] = member.id
  end

  def current_member
    @current_member ||= Member.find_by(id: session[:member_id]) if session[:member_id]
  end

  def logged_in?
    !current_member.nil?
  end

  def log_out
    session.delete(:member_id)
	  @current_member = nil
  end

  def authenticate_member
    if !logged_in?
      redirect_to root_path
    else
      cookies[:member_id] = current_member.id
    end
  end

  def not_allow_to_enter_login
    if logged_in?
      redirect_to home_path(current_member)
    end
  end

  def is_joined
    topic = Topic.where(id: params[:id]).first
    member = current_member

    if topic
      room = topic.room

      unless room.members.include?(member) or room.owner == member
        flash[:notice] = "You are not joined in this room"
        redirect_to home_path(member)
      end
    else
      flash[:notice] = "This topic does not exist"
      redirect_to home_path(member)
    end
  end
end
