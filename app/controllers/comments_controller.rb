class CommentsController < UsersController
  before_action :authenticate_user!

  def index
    @playlist = Playlist.find_by(id: params[:playlist_id])
    @comments = Comment.where(playlist_id: params[:playlist_id])
    @comment_user_ids = @comments.pluck(:user_id)
    @user_name_array = Array.new
    @comment_user_ids.each do |user_id|
      @user_name = User.find(user_id).name
      @user_name_array << @user_name
    end

    render layout: false
  end

  def create
    @comment = Comment.new(comment_params)
    if @comment.save
      @comments = Comment.where(playlist_id: params[:playlist_id])
      @users = User.all
      render json: {result: "success"}
    else
      render json: {result: "fail"}
    end

  end

  def destroy
    @comments = Comment.where(playlist_id: params[:playlist_id])
    @comment = Comment.find_by(id: params[:id])
    if @comment.destroy
      render json: {status: "success"}
    end
  end

  private
  def comment_params
    params.require(:comment).permit(:content, :user_id, :playlist_id)
  end

end
