class FoldersController < ApplicationController
  before_filter :authenticate_user!

  def index
    @folders = current_user.folders
  end

  def show
    @folder = current_user.folders.find(params[:id])
  end

  def new
    @folder = current_user.folders.new
  end

  def create
    @folder = current_user.folders.new(params[:folder])

  end

  def edit
    @folder = current_user.folders.find(params[:id])
  end

  def update
    @folder = current_user.folders.find(params[:id])

  end

  def destroy
    @folder = current_user.folders.find(params[:id])

  end
end