class DocumentsController < ApplicationController



  def show_with_model

    @document = Document.find(pg[:id, Document])

    render :text => nil

  end


  # same as above but with a nested id
  def show_with_model_nested

    @document = Document.find(pg[:user][:id, Document])

    render :text => nil

  end



  def show_without_model
    clog pg[:id]
    @document = Document.find(pg[:id])

    render :text => nil

  end



end
