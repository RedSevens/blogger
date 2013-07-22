class CommentsController < ApplicationController
	before_filter :require_login, except: [:create]
	def create
  	@comment = Comment.new(comment_params)
  	@comment.article_id = params[:article_id]
  	@comment.save
  	redirect_to article_path(@comment.article)
	end

	def comment_params
	  params.require(:comment).permit(:author_name, :body)
	end

	def require_login
    if !current_user
      redirect_to root_path
      flash.notice = "Sorry, you have to log in to do that!"
      return false
    end
  end
end