
require "itc_analytics/use_cases/create_new_session"

module ITCAnalytics
	module UseCases
		class Login
			attr_accessor :username, 
						  :password, 
						  :session_repository, 
						  :itunesconnect_gateway, 
						  :create_new_session_use_case

			def initialize(username:, password:, session_repository:, itunesconnect_gateway:)
				@username = username
				@password = password 
				@session_repository = session_repository
				@itunesconnect_gateway = itunesconnect_gateway
				@create_new_session_use_case = UseCases::CreateNewSession.new(
					username: @username,
					password: @password,
					itunesconnect_gateway: @itunesconnect_gateway)
			end

			def execute
				existing = @session_repository.get
				unless existing.nil? || ! existing.valid?
					return true 
				end

				existing = @create_new_session_use_case.execute  

				if existing.nil? || ! existing.valid?
					return false 
				end 

				@session_repository.save(existing)
				return true
			end
		end
	end
end
