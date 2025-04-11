class BoardsController < ApplicationController
  before_action :authenticate_user!, except: [ :index ]
  before_action :set_board, only: [ :show, :edit, :update, :destroy ]
  before_action :authorize_user!, only: [ :edit, :update, :destroy ]

  def index
    @boards = Board.includes(:user).order(created_at: :desc)
  end

  def show
  end

  def new
    @board = Board.new
  end

  def create
    @board = current_user.boards.build(board_params)
    if @board.save
      redirect_to boards_path, notice: "投稿が作成されました。"
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @board.update(board_params)
      redirect_to boards_path, notice: "投稿が更新されました。"
    else
      render :edit
    end
  end

  def destroy
    @board.destroy
    redirect_to boards_path, notice: "投稿を削除しました。"
  end

  private

  def set_board
    @board = Board.find(params[:id])
  end

  def authorize_user!
    unless @board.user == current_user
      redirect_to boards_path, alert: "他のユーザーの投稿を編集・削除することはできません。"
    end
  end

  def board_params
    params.require(:board).permit(:amount, :body)
  end
end
