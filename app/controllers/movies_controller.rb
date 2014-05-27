class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    # defaults
    @hilite_title = "normal"
    @hilite_release = "normal"
    
 	@all_ratings = Movie.get_ratings
  	@show_ratings = []
  	
  	if params["ratings"] != nil
  	  @show_ratings = params["ratings"].keys
  	end
  	
  	
  	# change defaults if sorting by title or release date
    if (params[:sort_by] == "title")
      @hilite_title = "hilite"
    elsif (params[:sort_by] == "release_date")
      @hilite_release = "hilite"
    else
      params[:sort_by] = "id"
    end
  
  
  	if @show_ratings[0] == nil
      @movies = Movie.find(:all, :order => params[:sort_by]) 
    else
      @movies = Movie.where("rating" => @show_ratings).find(:all, :order => params[:sort_by])
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
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
