
class User < ActiveRecord::Base
	has_secure_password 

	has_many :likes, dependant :destroy
	has_many :bits
end