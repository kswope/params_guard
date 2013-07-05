class DocumentsController < ApplicationController



  def show

    @document = Document.find(pg[:id, Document])

  end


  def update

    clog pg[:id, Document]

    render :show

  end




end
