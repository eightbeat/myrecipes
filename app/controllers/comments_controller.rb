class CommentsController < ApplicationController
  before_action :require_user
  #require_user from application_comtroller.rb


  def create
    @recipe = Recipe.find(params[:recipe_id])
    @comment = @recipe.comments.build(comment_params)
    @comment.chef = current_chef
    if @comment.save
      flash[:success] = "Comments was created successfully"
      redirect_to recipe_path(@recipe)
    else
       flash[:danger] = "Comment was not created"
       redirect_back(fallback_location: root_path)
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:description)
  end
end
