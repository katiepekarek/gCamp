class TasksController < ApplicationController

  def index
    @blog_posts = BlogPost.all
  end
