
class Bit < ActiveRecord::Base
	belongs_to :category
	has_many :likes, dependent: :destroy

	belongs_to :user

	
	validates :name, presence: true
	validates :name, length: {minimum: 2}
end