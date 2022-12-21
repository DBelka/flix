class GenresController < ApplicationController
  before_action :require_admin
  before_action :set_genre, only: [:edit, :update, :destroy]

  def index
    @genres = Genre.order(:name)
  end

  def new
    @genre = Genre.new
  end

  def create
    @genre = Genre.new(genre_params)
    if @genre.save
      redirect_to genres_path, notice: "Genre successfully created!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @genre.update(genre_params)
      redirect_to @genre, notice: "Genre successfully updated!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @genre.destroy

    redirect_to genres_path, alert: "Genre successfully deleted!", status: :see_other
  end

private

  def set_genre
    @genre = Genre.find(params[:id])
  end

  def genre_params
    genre_params = params.require(:genre).permit(:name)
  end

end
