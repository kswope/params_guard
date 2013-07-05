class Document < ActiveRecord::Base

  belongs_to :account



  def self.params_guard(key, value, session)

    case key
    when :id
      where(id: value, account_id: session[:aid]).any?
    end

  end


end
