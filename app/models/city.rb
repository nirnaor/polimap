class City < ActiveRecord::Base
  has_many :members
  has_many :votes
  validates_uniqueness_of :name
end
