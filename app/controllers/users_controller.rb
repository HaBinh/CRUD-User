
class UsersController < ApplicationController 


# ** Log in
  get '/login' do
  	if logged_in?
  		redirect '/update'
  	else
  		erb :'users/login'
  	end
  end

  post '/login' do
  	@user = User.find_by(:email => params[:email])
  	if @user && @user.password == params[:password]
  		session[:user_email] = @user.email
  		redirect '/update'
  	else
  		redirect '/login'
  	end
  end

# ** Logout
  get '/logout' do 
  	if session[:user_email] != nil
  		session.clear
  		redirect to '/login'
  	else
  		redirect to '/'
  	end
  end

# ** Sign up
	get '/new' do
		if logged_in? 
			redirect '/update'
		else
			erb :'users/new'
		end
	end

	post '/new' do 
    temp = User.find_by(:email => params[:email])
    if temp != nil 
      redirect '/new'
    end
		if params[:email] == "" || params[:password] == ""
			redirect '/new'
		else
      file = params[:file][:tempfile]
      File.open("./public/upload/images/#{params[:email]}", 'wb') do |f|
        f.write(file.read)
      end

			@user = User.create(
					:first_name =>   params[:first_name],
					:last_name =>    params[:last_name],
					:email =>       params[:email],
					:password =>    params[:password],
					:about_me =>    params[:about_me],
          :avatar_path =>  "./upload/images/#{params[:email]}"
			)
			session[:user_email] = @user.email
			redirect '/update'
		end
	end

# ** update
  get '/update' do 
  	@user = current_user
  	erb :'users/update'
  end

  put '/update' do 
    @user = current_user
    @user.first_name = params[:first_name]
    @user.last_name = params[:last_name]
    @user.password = params[:about_me]

    # Update avatar
    
    if params[:avatar] != nil
      fileUpload = params[:avatar][:tempfile]
      File.delete(@user.avatar_path) if File.exist?(@user.avatar_path)

      File.open("./public/upload/images/#{@user.email}", 'wb') do |f|
      f.write(fileUpload.read)
      end
    end
    @user.save
    redirect '/update'
  end

  delete '/delete/:id' do 
    @user = User.find_by_id(params[:id])
    @user.destroy
  end

  # ** Search 

  get '/search' do 
    if session[:result_search] != nil
      @user = User.find_by_id(session[:result_search])
    else
      @user = nil
    end
    erb :'users/search'
  end

  post '/search' do 
    @user = User.find_by(:email => params[:email])
    if @user == nil
      session[:result_search] = nil
    else
      session[:result_search] = @user.id
    end
    redirect '/search'
  end

end