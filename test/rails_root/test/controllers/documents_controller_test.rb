require 'test_helper'


class DocumentsControllerTest < ActionController::TestCase



  setup do

    @@account = FactoryGirl.create(:account)
    @@document = FactoryGirl.create(:document, :account => @@account)

    # set session indicating we've logged in as @@account
    session[:aid] = @@account.id

  end



  test 'show with model with correct id' do

    get :show_with_model, :id => @@document

    assert_equal @@document, assigns(:document)

  end



  test 'show with model with incorrect id' do

    assert_raises(ParamsGuardException) do
      get :show_with_model, :id => @@document.id + 1  # should not exist
    end

  end



  test 'show with model with nested param correct id' do

      get :show_with_model_nested, :user => {:id => @@document.id}
      assert_equal @@document, assigns(:document)

  end



  test 'show with model with nested param incorrect id' do

    assert_raises(ParamsGuardException) do
      get :show_with_model_nested, :user => {:id => @@document.id + 1}
    end

  end



  test 'show without model with correct id' do

    get :show_without_model, :id => @@document

    assert_equal @@document, assigns(:document)

  end


end
