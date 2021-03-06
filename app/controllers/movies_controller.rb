class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end



  def index
    # defaults
    need_reload = false
    @hilite_title = "normal"
    @hilite_release = "normal"
    
 	@all_ratings = Movie.get_ratings
  	
  	# load ratings from params, if not then session, if not then show all
  	# if loading from session, we'll need to reload
  	if params["ratings"] != nil
  	  @show_ratings = params["ratings"].keys
  	  session["ratings"] = params["ratings"]
  	elsif session["ratings"] != nil
  	  @show_ratings = session["ratings"].keys
  	  params["ratings"] = session["ratings"]
  	  need_reload = true
  	else
  	  @show_ratings = @all_ratings
  	end
  	
  	
  	# load sort_by from params if possible, then session (which will require reload)
  	# if not in session either, assume it's default and set it to id
  	# sorting by id will not be stored in session
    if (params[:sort_by] == "title")
      @hilite_title = "hilite"
      session["sort_by"] = params[:sort_by]
    elsif (params[:sort_by] == "release_date")
      @hilite_release = "hilite"
      session["sort_by"] = params[:sort_by]
    else
      if session["sort_by"] != nil
        params[:sort_by] = session["sort_by"]
        need_reload = true
      else
        params[:sort_by] = "id"
      end
    end
  
    # to maintain the RESTful structure where URI is what you get
    if need_reload
      redirect_to movies_path(params)
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
