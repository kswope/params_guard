require 'test_helper'


class DocumentsControllerTest < ActionController::TestCase



  setup do

    @@account = FactoryGirl.create(:account)
    @@document = FactoryGirl.create(:document, :account => @@account)

    # set session indicating we've logged in as @@account
    session[:aid] = @@account.id

  end



  test 'show with correct id' do

    get :show, :id => @@document

    assert_equal @@document, assigns(:document)

  end



  test 'show with incorrect id' do

    assert_raises(ParamsGuardException) do

      get :show, :id => @@document.id + 1  # should not exist

    end

  end



  test 'update' do


      post :update, :id => 1, :user => {:name => 'kevin'}


  end


end
