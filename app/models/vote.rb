class Vote < ActiveRecord::Base
  belongs_to :city
  belongs_to :party
end
