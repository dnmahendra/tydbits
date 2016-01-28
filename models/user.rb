
class User < ActiveRecord::Base
	has_secure_password 

	has_many :likes, as: :attachable, dependent: :destroy
	has_many :bits
end