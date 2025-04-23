class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_comment, only: [:edit, :update, :destroy]

  def create
    @board = Board.find(params[:board_id])
    @comment = @board.comments.new(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to board_path(@board), notice: 'コメントを投稿しました。'
    else
      redirect_to board_path(@board), alert: 'コメントの投稿に失敗しました。'
    end
  end

  def edit
  end

  def update
    if @comment.update(comment_params)
      redirect_to board_path(@comment.board), notice: 'コメントが更新されました。'
    else
      render :edit
    end
  end

  def destroy
    @board = @comment.board
    @comment.destroy
    redirect_to board_path(@comment.board), notice: 'コメントを削除しました。'
  end

  private

  def set_comment
    @comment = current_user.comments.find_by(id: params[:id])
    redirect_to root_path, alert: "このコメントにはアクセスできません。" unless @comment
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
