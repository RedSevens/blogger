class ArticlesController < ApplicationController
	before_filter :require_login, except: [:index, :show]

	def index
		@articles = Article.all                
	end

	def show
		@article = Article.find(params[:id])
		@comment = Comment.new
		@comment.article_id = @article.id
	end

	def new
		@article = Article.new
	end

	def create
		@article = Article.create(article_params)
		flash.notice = "Article '#{@article.title}' Has Been Created!"
		redirect_to article_path(@article)																																																	
	end

	def destroy
		@article = Article.find(params[:id])
		@article.destroy
		flash.notice = "Article '#{@article.title}' Has Been Deleted!"
		redirect_to articles_path
	end

	def edit
		@article = Article.find(params[:id])
	end

	def update
		@article = Article.find(params[:id])
		@article.update(article_params)
		flash.notice = "Article '#{@article.title}' Has Been Updated!"
		redirect_to article_path(@article)
	end

	def article_params
		params.require("article").permit("title", "body", "tag_list", :image)
	end

	def require_login
    if !current_user
      redirect_to root_path
      flash.notice = "Sorry, you have to log in to do that!"
      return false
    end
  end
end