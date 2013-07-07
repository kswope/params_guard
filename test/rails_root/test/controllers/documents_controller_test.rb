require 'test_helper'


class DocumentsControllerTest < ActionController::TestCase



  setup do

    @@right_account = FactoryGirl.create(:account)
    @@right_document = FactoryGirl.create(:document, :account => @@right_account)

    @@wrong_account = FactoryGirl.create(:account)
    @@wrong_document = FactoryGirl.create(:document, :account => @@wrong_account)

    # set session indicating we've logged in as @@account
    session[:aid] = @@right_account.id

  end



  test 'show with model with right document' do

    get :show_with_model, :id => @@right_document
    assert_equal @@right_document, assigns(:document)

  end



  test 'show with model with wrong document' do

    assert_raises(ParamsGuardException) do
      get :show_with_model, :id => @@wrong_document
    end

  end



  test 'show with model with nested param with right document' do

    get :show_with_model_nested, :user => {:id => @@right_document}
    assert_equal @@right_document, assigns(:document)

  end



  test 'show with model with nested param with wrong document' do

    assert_raises(ParamsGuardException) do
      get :show_with_model_nested, :user => {:id => @@wrong_document}
    end

  end



  test 'show without model with right document' do

    get :show_without_model, :id => @@right_document
    assert_equal @@right_document, assigns(:document)

  end



  test 'show without model with wrong document' do

    assert_raises(ParamsGuardException) do
      get :show_without_model, :id => @@wrong_document
    end

  end



end
