
class Bit < ActiveRecord::Base
	belongs_to :category
	has_many :likes

	
	validates :name, presence: true
	validates :name, length: {minimum: 2}
end