class AuthorsController < ApplicationController
  before_filter :require_login, except: [:new, :create]

  def zero_authors_or_authenticated
    unless Author.count == 0 || current_user
      redirect_to root_path
      return false
    end
  end

  # GET /authors
  # GET /authors.json
  def index
    @authors = Author.all
  end

  # GET /authors/new
  def new
    @author = Author.new
  end

  # GET /authors/1
  # GET /authors/1.json
  def show
    confirm_user
  end

  # GET /authors/1/edit
  def edit
    confirm_user
  end

  # POST /authors
  # POST /authors.json
  def create
    @author = Author.new(author_params)

    respond_to do |format|
      if @author.save
        format.html { redirect_to @author, notice: 'Author was successfully created.' }
        format.json { render action: 'show', status: :created, location: @author }
      else
        format.html { render action: 'new' }
        format.json { render json: @author.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /authors/1
  # PATCH/PUT /authors/1.json
  def update
    respond_to do |format|
      if @author.update(author_params)
        format.html { redirect_to @author, notice: 'Author was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @author.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /authors/1
  # DELETE /authors/1.json
  def destroy
    if !confirm_user
      @author.destroy
      respond_to do |format|
        format.html { redirect_to authors_url }
        format.json { head :no_content }
      end
    end
  end

  def require_login
    if !current_user
      redirect_to root_path
      flash.notice = "Sorry, you have to log in to do that!"
      return false
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_author
      @author = Author.find(params[:id])
    end

    def confirm_user
      if current_user.username == Author.find(params[:id]).username || current_user.username.downcase == "admin"
        @author = set_author
      else
        redirect_to authors_path
        flash.notice = "Sorry! You cannot access that user's account information."
        return true
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def author_params
      params.require(:author).permit(:username, :email, :password, :password_confirmation)
    end
end
