class SongsController < ApplicationController
  def index
    if params[:artist_id]
      @artist = Artist.find_by(id: params[:artist_id])
      if @artist.nil?
        redirect_to artists_path, alert: "Artist not found"
      else
        @songs = @artist.songs
      end
    else
      @songs = Song.all
    end
  end

  def show
    if params[:artist_id]
      @artist = Artist.find_by(id: params[:artist_id])
      @song = @artist.songs.find_by(id: params[:id])
      if @song.nil?
        redirect_to artist_songs_path(@artist), alert: "Song not found"
      end
    else
      @song = Song.find(params[:id])
    end
  end

  def new
    if params[:artist_id] && !Artist.exists?(params[:artist_id])
      redirect_to artists_path
    else
      @song = Song.new(artist_id: params[:artist_id])
    end
  end

  def create
    @song = Song.new(song_params)

    if @song.save
      redirect_to @song
    else
      render :new
    end
  end

  def edit
    # params has artist_id but no valid artist
    # params has artist_id, valid artist, but song not theirs
    # params does not have artist_id

    if params[:artist_id]
      artist = Artist.find_by(id: params[:artist_id])
      if artist.nil?
        redirect_to artists_path
      else 
        @song = artist.songs.find_by(id: params[:id])
        redirect_to artist_songs_path(artist) if @song.nil?
      end
    else
      @song = Song.find_by(id: params[:id])
    end
  end

  #   binding.pry

  #   @artist = Artist.find_by(id: params[:artist_id])
  #   @song = Song.find_by(id: params[:id])
  

  #   if !@artist.nil?
  #     @artist = Artist.find_by(id: params[:artist_id])
  #     if @artist
  #       @song = @artist.songs.find_by(id: params[:id])
  #     end
    
      
  #     # deal with nesting
  #   else
  #     @song = Song.find(params[:id])
  #   end

  #   @artist = Artist.find_by(id: params[:artist_id])
  #   if params[:artist_id] && @artist.nil?
  #     redirect_to artists_path
  #   else 
     
  #     if !@artist.songs.find_by(id: params[:id])
  #       redirect_to artist_songs_path(@artist)
  #     else
  #       @song = Song.find(params[:id])
  #     end
  #   end
  # end

  def update
    @song = Song.find(params[:id])

    @song.update(song_params)

    if @song.save
      redirect_to @song
    else
      render :edit
    end
  end

  def destroy
    @song = Song.find(params[:id])
    @song.destroy
    flash[:notice] = "Song deleted."
    redirect_to songs_path
  end

  private

  def song_params
    params.require(:song).permit(:title, :artist_name, :artist_id)
  end
end

