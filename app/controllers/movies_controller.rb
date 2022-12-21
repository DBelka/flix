class MoviesController < ApplicationController
  before_action :set_movie, only: [:show, :edit, :update, :destroy]
  before_action :require_signin, except: [:index, :show]
  before_action :require_admin, except: [:index, :show]

  def index
    @movies = Movie.send(movies_filter)

    # case params[:filter]
    # when "upcoming"
    #   @movies = Movie.upcoming
    # when "recent"
    #   @movies = Movie.recent(6)
    # when "flops"
    #   @movies = Movie.flops
    # when "hits"
    #   @movies = Movie.hits
    # else
    #   @movies = Movie.released
    # end
  end

  def show
    @review = @movie.reviews.new
    @fans = @movie.fans
    @genres = @movie.genres.order(:name)
    if current_user
      @favourite = current_user.favourites.find_by(movie_id: @movie.id)
    end
  end

  def edit
  end

  def new
    @movie = Movie.new
  end

  def create
    @movie = Movie.new(movie_params)
    if @movie.save
      redirect_to @movie, notice: "Movie successfully created!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @movie.update(movie_params)
      redirect_to @movie, notice: "Movie successfully updated!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @movie.destroy

    redirect_to movies_url, status: :see_other, alert: "Movie successfully deleted!"
  end

private

  def movies_filter
    if params[:filter].in? %w(upcoming recent hits flops)
      params[:filter]
    else
      :released
    end
  end

  def set_movie
    @movie = Movie.find_by!(slug: params[:id])
  end

  def movie_params
    movie_params = params.require(:movie).
      permit(:title, :description, :rating, :released_on,
             :total_gross, :director, :duration, :image_file_name, genre_ids: [])
  end
end
