class Admin::UsersController < Admin::ApplicationController

  load_and_authorize_resource param_method: :user_params

  def index
    @users = User.search(search_params).result.order_desc.all_customer
      .paginate page: params[:page], per_page: Settings.users.order_per_page
  end

  def new
  end

  def create
    if @user.save
      flash[:success] = t "flash.users.add_user_success"
      redirect_to admin_users_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update_attributes user_params
      if @user.current_user? current_user
        sign_in @user, bypass: true
        flash[:success] = t "flash.users.change_password_success"
      else
        flash[:success] = t "flash.users.update_user_success"
      end
      redirect_to admin_users_path
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t "flash.users.user_deleted"
      redirect_to admin_users_path
    else
      flash[:danger] = t "flash.users.user_cant_delete"
    end
  end

  rescue_from ActiveRecord::RecordNotFound do
    flash[:danger] = t "flash.find_user_fail"
    redirect_to admin_users_path
  end

  private
  def search_params
    params.permit :name_or_email_cont, :phone_cont
  end

  def user_params
    params.require(:user).permit :email, :name, :phone, :address, :password,
      :password_confirmation
  end
end
