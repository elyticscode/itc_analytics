
require "itc_analytics/domain/entities/session"

module ITCAnalytics
	module UseCases
		class CreateNewSession
			attr_accessor :username,
						  :password,
						  :itunesconnect_gateway
			def initialize(username:, password:, itunesconnect_gateway:)
				@username = username
				@password = password 
				@itunesconnect_gateway = itunesconnect_gateway
			end 
			def execute
				account_cookie = @itunesconnect_gateway.create_account_info_cookie(
					username: @username, 
					password: @password
				) 
				if account_cookie == nil 
					return nil 
				end

				itctx_cookie = @itunesconnect_gateway.get_itctx_cookie(account_info_cookie: account_cookie)
				if itctx_cookie == nil 
					return nil 
				end

				return Domain::Entities::Session.new(account_cookie: account_cookie, itctx_cookie: itctx_cookie)
			end 
		end
	end
end 
