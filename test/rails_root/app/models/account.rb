class Account < ActiveRecord::Base

  has_many :documents
  has_many :folders

end
