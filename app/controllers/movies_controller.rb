class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.order(:rating).select(:rating).map(&:rating).uniq
    if not params[:ratings]
      params[:ratings] = session[:params_ratings]
    end 
    if not params[:sort]
      params[:sort] = session[:params_sort]
    end
    if params[:ratings]
      session[:params_ratings] = params[:ratings]
      @get_raitings = params[:ratings].keys
    else
      @get_raitings = @all_ratings
    end
    @get_raitings.each do |rating|
      params[rating] = true
    end
    
    if params[:sort]
      session[:params_sort] = params[:sort]
      @movies = Movie.order(params[:sort])
    else
      @movies = Movie.order(params[:sort]).where(:rating => @get_raitings)
    end
    
  end
  
  def new
    # default: render 'new' template
  end

  def create
    session.clear
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end
  
end