class City < ActiveRecord::Base
  has_many :members
  validates_uniqueness_of :name
end
