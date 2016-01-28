
class Bit < ActiveRecord::Base
	belongs_to :category
	has_many :likes, as: :attachable, dependent: :destroy

	belongs_to :user

	
	validates :name, presence: true
	validates :name, length: {minimum: 2}
end