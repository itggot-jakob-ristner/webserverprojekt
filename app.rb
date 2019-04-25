require 'byebug'
require 'sinatra'
require_relative 'database/database'
require_relative 'models/user'

class App < Sinatra::Base

	enable :sessions
    register Sinatra::Flash
    
    before do
        @no_re_paths = ['/', '/register', '/login']
        if session[:user_id]
            @current_user = User.new(User.get({:id => session[:user_id]}))
        elsif !session[:user_id] && !@no_re_paths.include?(request.path_info)
            redirect '/'
        end
    end

	post '/login' do
        result = User.login(params)
        if result.class == Array
            flash[session['session_id']] = result
            redirect back
        else
            session[:user_id] = result
		    redirect '/tasks'
        end
	end

	post '/logout' do
		session.destroy
		redirect '/'
	end

    get '/register' do
        slim :'users/register'
    end

    post '/register' do
        result = User.register(params)
        if result.class == User
            @current_user = result
            session[:user_id] = @current_user.id
            redirect '/tasks'
        else
            flash[session['session_id']] = result
            redirect back
        end
    end

    post '/tasks/new' do
        if session[:user_id] == @current_user.id
            id_hash = {'user_id': @current_user.id}
            hash = params.merge(id_hash)
            Task.add(hash)
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
            Task.delete(params[:id])
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

  
