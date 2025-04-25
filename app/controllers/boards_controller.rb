class BoardsController < ApplicationController
  before_action :authenticate_user!, except: [ :index, :show ]
  before_action :set_board, only: [ :edit, :update, :destroy ]

  def index
    if params[:tag_name].present?
      @boards = Board.joins(:tags).where(tags: { name: params[:tag_name] }).includes(:user).order(created_at: :desc)
    else
      @boards = Board.includes(:user).order(created_at: :desc)
    end
  end

  def show
    @board = Board.find(params[:id])
    @comment = Comment.new
    @comments = @board.comments.includes(:user).order(created_at: :desc)
  end

  def new
    @board = Board.new
  end

  def create
    @board = current_user.boards.build(board_params)
    tag_names = params[:tag_names].to_s.split(",").map(&:strip).uniq

    if @board.save
      @board.save_tags(tag_names)
      redirect_to boards_path, notice: "投稿が作成されました。"
    else
      render :new
    end
  end

  def edit
    @tag_names = @board.tags.map(&:name).join(",")
  end

  def update
    if @board.update(board_params)
      # タグの更新
      tag_names = params[:tag_names].to_s.split(",").map(&:strip).uniq
      @board.tags.clear
      @board.save_tags(tag_names)

      redirect_to boards_path, notice: "投稿が更新されました。"
    else
      @tag_names = @board.tags.map(&:name).join(",")
      render :edit
    end
  end

  def destroy
    @board.destroy
    redirect_to boards_path, notice: "投稿を削除しました。"
  end

  private

  def set_board
    @board = current_user.boards.find_by(id: params[:id])
    redirect_to root_path, alert: "この投稿にはアクセスできません。" unless @board
  end

  def board_params
    params.require(:board).permit(:amount, :body)
  end
end
