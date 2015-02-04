class Member < ActiveRecord::Base
  validates_uniqueness_of :name
  belongs_to :city
  has_and_belongs_to_many :parties
end
