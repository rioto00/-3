class BooksController < ApplicationController
  def index
    @user = current_user
    to = Time.current.at_end_of_day
    from = (to - 6.day).at_beginning_of_day
    @books = Book.includes(:favorites).sort_by { |book| -book.favorites.where(created_at: from...to).count }
    @book = Book.new
    @books = Book.all
  end

  def show
    @book = Book.new
    @book1 = Book.find(params[:id])
    @user = @book1.user
    @book_comment = BookComment.new
    unless ViewCount.find_by(user_id: current_user.id, book_id: @book.id)
      current_user.view_counts.create(book_id: @book.id)
    end
  end

  def edit
    is_matching_login_user
    @book = Book.find(params[:id])
  end
  
  def update 
    is_matching_login_user
    @book = Book.find(params[:id])
    @book.update(book_params)
    if @book.save
      redirect_to book_path(@book.id)
      flash[:notice] = "You have updated book successfully."
    else
      @user = current_user
      @books = Book.all
      render :edit
    end
  end
  
  def destroy
    book = Book.find(params[:id])
    #@book = current_user
    book.destroy
    redirect_to books_path
    #redirect_to user_path(@user.id)
    #redirect_to book_path(book.id)
  end
  
  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to book_path(@book.id)
      flash[:notice] = "You have created book successfully."
    else
      @user = current_user
      @books = Book.all
      render :index
    end
  end
  
  private
  def book_params
    params.require(:book).permit(:title, :body)
  end
  
  def is_matching_login_user
    book = Book.find(params[:id])
    unless book.user == current_user
      redirect_to books_path
    end
  end
end
