module SessionsHelper

  #渡されたユーザーでログインする
  def log_in(user)
    session[:user_id] = user.id
  end

  # ユーザーのセッションを永続化にする
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  # 永続変セッションを破棄する
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  #ログインしていれば、ログイン中のユーザーを返す
  def current_user
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    # cookieにuser_idがあればそれでログインを試みる(セッション永続化）
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end
  
  def current_user?
    user == current_user
  end

  # ユーザーがログインしているかどうか返す
  def logged_in?
    !current_user.nil?
  end
  

  # 現在のユーザーをログアウトする
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  #記憶したURL（もしくはデフォルト値)へリダイレクト
    def redirect_back_or(default)
      redirect_to(session[:forwarding_url] || default)
      session.delete(:forwarding_url)
    end

  #アクセスしようとしたURLを覚えておく
    def store_location
      session[:forwarding_url] = request.original_url if request.get?
    end

end
