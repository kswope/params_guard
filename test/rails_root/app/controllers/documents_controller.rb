class DocumentsController < ApplicationController



  def show

    @document = Document.find(params[:id, Document])

  end


  def update

    Rails.logger.debug "++++++++++++++++"
    Rails.logger.debug params[:user]

    render :show

  end




end
