
class User < ActiveRecord::Base
	has_secure_password 

	has_many :likes, dependent: :destroy
	has_many :bits
end