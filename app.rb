require 'byebug'
require 'sinatra'
require_relative 'models/employee'
require_relative 'database/database'
require_relative 'models/user'

class App < Sinatra::Base

	enable :sessions
    
    before do
        if session[:user_id]
            @current_user = User.get('id', session[:user_id])
        end
    end

	post '/login' do
        session[:user_id] = User.login(params)
		redirect '/tasks'
	end

	post '/logout' do
		session.destroy
		redirect '/'
	end

    get '/register' do
        slim :'users/register'
    end

    post '/register' do
        begin
            @current_user = User.create(params)
            session[:user_id] = @current_user.id
        rescue 
            redirect back
        end
        redirect '/'
    end

    post '/tasks/new' do
        if @current_user.id == session[:user_id]
            @current_user.add_task(params)
        end
        redirect back
    end


    get '/' do
        if session[:user_id]
            redirect '/tasks'
        end
        slim :'index' 
    end

    get '/tasks' do
        if !session[:user_id]
            redirect '/'
        end
        @tasks = @current_user.get_tasks()
        slim :'tasks/index'
    end

    post '/tasks/:id/complete' do
        if session[:user_id] == @current_user.id
            Task.complete(params[:id]) 
        end
        redirect back
    end

    post '/tasks/:id/remove' do
        if session[:user_id] == @current_user.id
            Task.remove(params[:id])
        end
        redirect back
    end

    post '/tasks/:id/invite' do 
        if session[:user_id] == @current_user.id
            Task.invite(params)
        end
        redirect back
    end

    post '/database/clear' do
        if @current_user.admin 
            Database.clear()
        end
    end

end

  
