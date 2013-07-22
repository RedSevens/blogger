class TagsController < ApplicationController
	before_filter :require_login, only: [:destroy]

	def show
		@tag = Tag.find(params[:id])
	end

	def index
		@tags = Tag.all
	end

	def destroy
		@tag = Tag.find(params[:id])
		@tag.destroy
		flash.notice = "Tag '#{@tag.name}' Has Been Deleted!"
		redirect_to tags_path
	end

	def require_login
    if !current_user
      redirect_to root_path
      flash.notice = "Sorry, you have to log in to do that!"
      return false
    end
  end
end