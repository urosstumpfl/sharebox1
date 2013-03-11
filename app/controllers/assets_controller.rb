class AssetsController < ApplicationController

  before_filter :authenticate_user!

  def index
    @assets = current_user.assets
  end

  def show
    @asset = current_user.assets.find(params[:id])
  end

  def new
    @asset = current_user.assets.build
    if params[:folder_id] #if we want to upload a file inside another folder
      @current_folder = current_user.folders.find(params[:folder_id])
      @asset.folder_id = @current_folder.id
    end
  end

  def create
    @asset = current_user.assets.build(params[:asset])
    if @asset.save
      redirect_to @asset, :notice => "Successfully updated asset."

    end
  end

  def edit
    @asset = current_user.assets.find(params[:id])
  end

  def update
    @asset = current_user.assets.find(params[:id])
    if @asset.update_attributes(params[:asset])
      redirect_to @asset, :notice  => "Successfully updated asset."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @asset = current_user.assets.find(params[:id])
    @parent_folder = @asset.folder #grabbing the parent folder before deleting the record
    @asset.destroy
    flash[:notice] = "Successfully deleted the file."

    #redirect to a relevant path depending on the parent folder
    if @parent_folder
      redirect_to browse_path(@parent_folder)
    else
      redirect_to root_url
    end
  end

    #this action will let the users download the files (after a simple authorization check)
  def get
#first find the asset within own assets
    asset = current_user.assets.find_by_id(params[:id])

#if not found in own assets, check if the current_user has share access to the parent folder of the File
    asset ||= Asset.find(params[:id]) if current_user.has_share_access?(Asset.find_by_id(params[:id]).folder)

    if asset
      send_file asset.uploaded_file.path, :type => asset.uploaded_file_content_type
#require 'open-uri'
#Parse the URL for special characters first before downloading
#test = "http://localhost:3000/#{asset.uploaded_file.url}"
#test = "#{asset.uploaded_file.url}"
#data = open(URI.parse(URI.encode(test)))
#send_data data, :filename => asset.uploaded_file_file_name
#redirect_to asset.uploaded_file.url
    else
      flash[:error] = "Don't be cheeky! Mind your own assets!"
      redirect_to assets_path
#redirect_to root_url
    end
  end


end

