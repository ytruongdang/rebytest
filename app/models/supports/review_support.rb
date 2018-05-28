class Supports::ReviewSupport
  def initialize params
    @review = params[:review]
    @like = params[:like]
    @page = params[:page]
    @user = params[:user]
    @parent_comment = @review.comments.find_by id: params[:parent_id] if @review
  end

  def user_rated? user
    @review.rates(:quality).find_by(rater: user).present?
  end

  def comments
    @comments = @review.comments.roots.order_desc.paginate page: @page,
      per_page: Settings.reviews.comment_per_page
  end

  def comment
    @comment = @parent_comment ?
      @parent_comment.children.build : @review.comments.build
  end

  def parent_comment
    @parent_comment
  end

  def like object
    @like = object.likes.find_or_initialize_by user: @user
  end

  def like_title object
    @like = like object
    if @like.new_record?
      I18n.t "likes.like.like"
    else
      I18n.t "likes.like.unlike"
    end
  end

  def likeable
    @like ? @like.likeable : @review
  end
end
