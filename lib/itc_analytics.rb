require "itc_analytics/version"
require "itc_analytics/interfaces/gateways/itunesconnect"
require "itc_analytics/interfaces/repositories/session/inmemory"
require "itc_analytics/use_cases/create_new_session"
require "itc_analytics/use_cases/login"

module ITCAnalytics
    #the main class 
  	class << self 
      
  		attr_accessor :session_repository
  		attr_accessor :http_controller
  		attr_accessor :itunesconnect_gateway

  		def configure
  			yield self 
  		end 

  		def session_repository 
  			@session_repository ||= Interfaces::Repositories::Session::InMemory.new
  		end

  		def http_controller 
  			@http_controller ||= Interfaces::Controllers::Http.new
  		end  

  		def itunesconnect_gateway 
  			@itunesconnect_gateway ||= Interfaces::Gateways::ItunesConnect.new(http_controller: http_controller, 
  				apple_widget_key: "22d448248055bab0dc197c6271d738c3")
  		end

  		def login(user, pass)
  			success = UseCases::Login.new(
  				username: user, 
  				password: pass, 
  				session_repository: session_repository,
  				itunesconnect_gateway: itunesconnect_gateway)
  			.execute
  			return success 
  		end

  	end
end
