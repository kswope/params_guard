class Document < ActiveRecord::Base

  belongs_to :account



  def self.params_guard(key, params, session)

    where(id: params[key], account_id: session[:aid]).any?

  end


end
