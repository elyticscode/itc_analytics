require "itc_analytics/version"
require "itc_analytics/interfaces/controllers/http"
require "itc_analytics/interfaces/gateways/itunesconnect"
require "itc_analytics/interfaces/repositories/session/inmemory"
require "itc_analytics/use_cases/create_new_session"
require "itc_analytics/use_cases/login"
require "itc_analytics/use_cases/get_available_applications"
require "itc_analytics/use_cases/get_app_installs"
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

      def get_available_apps
        UseCases::GetAvailableApplications.new(
          session_repository: session_repository,
          itunesconnect_gateway: itunesconnect_gateway
        ).execute
      end

      def get_app_downloads_for_date_range(app_id, start_date, end_date) 
        application = Domain::Entities::Application.new(
          itunes_app_id: app_id,
          itunes_app_name: nil,
          is_bundle: nil,
          icon_url: nil,
          asset_token: nil,
          platforms: nil,
          is_enabled: nil,
          app_opt_in_rate: nil
        )
        UseCases::GetAppInstalls.new(
          applications: [application],
          session_repository: session_repository,
          start_date: start_date,
          end_date: end_date,
          itunes_gateway: itunesconnect_gateway
        ).execute
      end
    end
end
