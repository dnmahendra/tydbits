
require 'sinatra' 
require 'aws-sdk'

require 'pg'
require './db_config'
require './models/bit'
require './models/category'
require './models/user'
require './models/like'
require 'mini_magick'


configure :development do 
	require 'sinatra/reloader'
	require 'pry'
end

enable :sessions

helpers do
	def logged_in?
		!!current_user
	end

	def current_user
		User.find_by(id: session[:user_id])
	end

	def resize_image(thumbnail)
		image = MiniMagick::Image.new(thumbnail.path)
		image.resize "200x200"
		return image
	end

	def liked?(bit_id)
		if logged_in?
			if Like.find_by(user_id: current_user.id, bit_id: bit_id)
				return true
			end
		end
		return false
	end
end


get '/' do

	@categories = Category.all
	@bits = Bit.all

	@likes = Like.new
	erb :index
end

#login
post '/session' do

#search for the user
user = User.find_by(name: params[:name])

#Authenticate 
	if user && user.authenticate(params[:pwd])
		#create a session
		session[:user_id] = user.id
		session[:user_name] = user.name
		#redirect to somewhere else
		redirect to '/'

	else
		avatar = resize_image(params[:avatar][:tempfile])

		#Upload to Amazon S3
		s3 = Aws::S3::Resource.new(region: 'ap-southeast-2')

		img = s3.bucket('tydbits').object("Avatars/#{image_name}")
		img.upload_file(avatar.path, acl:'public-read')
		img_url = img.public_url

		newuser = User.new
		newuser[:name] = params[:name]
		newuser[:email] = params[:email]
		newuser.password = params[:pwd]
		newuser[:avatar] = img_url

		if newuser.save
			erb :login
		end
	end
end

#show the form
get '/session/new' do
	erb :login
end

get '/user/new' do
	erb :singup
end

# logout
delete '/session' do
	session[:user_id] = nil
	redirect to '/session/new'
end

#show new bit form
get '/bits/new' do

@categories = Category.all

erb :new
end

post '/upload' do

	file = params[:file][:tempfile]
	thumbnail = params[:avatar][:tempfile]
	image_name = params[:avatar][:filename]

	image = resize_image(thumbnail)

#Upload to Amazon S3
s3 = Aws::S3::Resource.new(region: 'ap-southeast-2')

img = s3.bucket('tydbits').object("Avatars/#{image_name}")
img.upload_file(image.path, acl:'public-read')
img_url = img.public_url

obj = s3.bucket('tydbits').object(params[:name])
obj.upload_file(file, acl:'public-read')
url = obj.public_url

bit = Bit.new
bit[:name] = params[:name]
bit[:description] = params[:description]
bit[:category_id] = params[:category_id]
bit[:url] = url
bit[:thumbnail] = img_url

bit.save

redirect to '/'

end

post '/likes/:bit_id' do

	if logged_in?

		if liked?(params[:bit_id])
			likes = Like.where(user_id: current_user.id,
	 				bit_id: params[:bit_id])

			likes.each do |like|
				like.destroy
			end
		else
			like = Like.new
			like.user_id = current_user.id
			like.bit_id = params[:bit_id]
			if like.save
				redirect to '/'
			end
		end
	else
		redirect to '/session/new'
	end
end

# binding.pry
