class DocumentsController < ApplicationController



  def show_with_model

    @document = Document.find(pg[:id, Document])

    render :text => nil

  end



  def show_with_model_nested

    @document = Document.find(pg[:user][:id, Document])

    render :text => nil

  end



  def show_without_model

    clog 'calling pg[:id]'
    @document = Document.find(pg[:id])
    clog '---returning from pg[:id]'

    render :text => nil

  end



end
