
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
		image.resize "200x200!"
		return image
	end

	def resize_avatar(avatar)
		image = MiniMagick::Image.new(avatar.path)
		image.resize "100x100!"
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

	if params[:category_id] 
		@bits = Bit.where(category_id: params[:category_id])
	else
		@bits = Bit.all
	end
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
		avatar = resize_avatar(params[:avatar][:tempfile])
		image_name = params[:avatar][:filename]

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

get '/user/show' do

	@bit = Bit.where(:user_id => current_user.id)
	@like = Like.where(:user_id => current_user.id)
	erb :show_user
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
	if logged_in?

		@categories = Category.all
		erb :new
	else
		erb :login
	end
end

post '/upload' do

bit = Bit.new
if params[:category_id].to_i == 1

	file = params[:file][:tempfile]

	if !params[:avatar].nil?
		thumbnail = params[:avatar][:tempfile]
		image_name = params[:avatar][:filename]

		image = resize_image(thumbnail)
		s3 = Aws::S3::Resource.new(region: 'ap-southeast-2')

		img = s3.bucket('tydbits').object("Avatars/#{image_name}")
		img.upload_file(image.path, acl:'public-read')
		img_url = img.public_url
		bit[:thumbnail] = img_url
	end

else

	file = params[:file][:tempfile]

	file = resize_image(file)
end

#Upload to Amazon S3
s3 = Aws::S3::Resource.new(region: 'ap-southeast-2')

obj = s3.bucket('tydbits').object(params[:name])
obj.upload_file(file.path, acl:'public-read')
url = obj.public_url


bit[:name] = params[:name]
bit[:description] = params[:description]
bit[:category_id] = params[:category_id]
bit[:url] = url
bit[:user_id] = current_user.id

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

#editing bits
get '/bits/:id/edit' do

	@categories = Category.all

	@bit = Bit.find(params[:id])
	erb :edit_bit

end

put '/bits/:id' do

	bit = Bit.find(params[:id])

	if !params[:file].nil?

		file = params[:file][:tempfile]

		s3 = Aws::S3::Resource.new(region: 'ap-southeast-2')

		obj = s3.bucket('tydbits').object(params[:name])
		obj.upload_file(file, acl:'public-read')
		url = obj.public_url
		bit.url = url
	end

	if !params[:avatar].nil?
		thumbnail = params[:avatar][:tempfile]
		image_name = params[:avatar][:filename]

		image = resize_image(thumbnail)

		s3 = Aws::S3::Resource.new(region: 'ap-southeast-2')

		img = s3.bucket('tydbits').object("Avatars/#{image_name}")
		img.upload_file(image.path, acl:'public-read')
		thumbnail = img.public_url
		bit.thumbnail = thumbnail
	end


	bit.name = params[:name]
	bit.description = params[:description]
	bit.category_id = params[:category_id]

	bit.save
	redirect to "/"
end

#delete bit
delete '/bits/:id' do

	bit = Bit.find(params[:id])

	if !bit.thumbnail.nil?
		image = bit.thumbnail.split('/').last

		s3 = Aws::S3::Resource.new(region: 'ap-southeast-2')

		bucket = s3.bucket('tydbits')

		obj = bucket.object(bit.name)
		obj.delete

		obj = bucket.object("Avatars/#{image}")
		obj.delete
	end

	bit.destroy

	redirect to '/'

end 

#User edit
get '/user/edit' do


	erb :edit_user
end

post '/session/:id' do


	user = User.find(params[:id])
	user[:name] = params[:name]
	user[:email] = params[:email]
	user.password = params[:pwd]

	if !params[:avatar].nil?

		avatar = resize_avatar(params[:avatar][:tempfile])
		name = params[:avatar][:filename]

		#Upload to Amazon S3
		s3 = Aws::S3::Resource.new(region: 'ap-southeast-2')

		img = s3.bucket('tydbits').object("Avatars/#{name}")
		img.upload_file(avatar.path, acl:'public-read')
		img_url = img.public_url
		user[:avatar] = img_url

	end

	if user.save
		erb :login
	end
end

get '/users' do
	if logged_in?
		@users = User.all
		erb :show_users
	else
		erb :login
	end
end

get '/uploads/:id' do

	@bits = Bit.where(user_id: params[:id])

	erb :show_uploads
end


get '/favs/:id' do

	@bits = Bit.joins(:likes).where(user_id: params[:id])

	erb :show_favs
end


# binding.pry
