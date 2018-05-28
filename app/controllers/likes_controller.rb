class LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :find_likeable, only: :create
  before_action :find_like, only: :destroy
  before_action :load_support

  def create
    @like = @likeable.likes.build user: current_user
    if @like.save
      load_support
      flash[:success] = t "flash.likes.like_success"
    else
      flash[:success] = t "flash.likes.like_fail"
    end

    respond_to do |format|
      format.js
    end
  end

  def destroy
    if @like.destroy
      @like = @like.likeable.likes.build user: current_user
      load_support
      flash[:success] = t "flash.likes.unlike_success"
    else
      flash[:success] = t "flash.likes.unlike_fail"
    end

    respond_to do |format|
      format.js
    end
  end

  private
  def find_likeable
    @likeable = params[:klass].classify.constantize
      .find_by id: params[:object_id]
    unless @likeable
      object_type = params[:klass].downcase
      flash[:danger] = t "flash.#{object_type}s.#{object_type}_not_found"
      redirect_to root_path
    end
  end

  def find_like
    @like = Like.find_by id: params[:id]
    unless @like
      flash[:danger] = t "flash.likes.like_not_found"
      redirect_to root_path
    end
  end

  def load_support
    @supports = Supports::ReviewSupport.new user: current_user,
      like: @like
  end
end
