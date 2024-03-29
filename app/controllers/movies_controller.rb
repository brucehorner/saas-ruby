class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @orderby=params[:orderby] || session[:orderby] || 'title'
    @ratings=params[:ratings] || session[:ratings] || {}
    puts "First level ratings is '#{@ratings.keys}', order is '#{@orderby}'"
    
    if params[:orderby] != session[:orderby]
      session[:orderby] = @orderby
      flash.keep
      redirect_to :orderby=>@orderby, :ratings=>@ratings
      return
    end
    
    if params[:ratings] != session[:ratings] and @ratings!={}
      session[:orderby] = @orderby
      session[:ratings] = @ratings
      flash.keep
      redirect_to :orderby=>@orderby, :ratings=>@ratings
      return
    end
    
    if @orderby
      if @ratings.size>0
        @movies=Movie.order(@orderby).find_all_by_rating @ratings.keys
      elsif
        @movies=Movie.order(@orderby).all
      end
    end
    @all_ratings = Movie.all_ratings
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
