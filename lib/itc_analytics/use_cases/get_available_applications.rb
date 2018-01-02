require "itc_analytics/domain/entities/application"
require "itc_analytics/use_cases/exceptions"
require "itc_analytics/interfaces/gateways/exceptions"
module ITCAnalytics
	module UseCases
		class GetAvailableApplications

			attr_accessor :session_repository, :itunesconnect_gateway

			def initialize(session_repository:, itunesconnect_gateway:)
				@session_repository = session_repository
				@itunesconnect_gateway = itunesconnect_gateway
			end

			def execute

				session = @session_repository.get 
				if session == nil || !session.valid? 
					raise Exceptions::InvalidSession
				end

				results = @itunesconnect_gateway.get_applications_json(
					session_cookies: [session.account_cookie, session.itctx_cookie]
				)

				obj = JSON.parse(results)
				if !obj.key?("results")
					raise Exceptions::NoResults
				end

				applications = obj["results"].map { |e| 
					Domain::Entities::Application.new(
						itunes_app_id: e["adamId"],
						itunes_app_name: e["name"],
						is_bundle: e["is_bundle"],
						icon_url: e["icon_url"],
						asset_token: e["asset_token"],
						platforms: e["platforms"],
						is_enabled: e["is_enabled"],
						app_opt_in_rate: e["app_opt_in_rate"]
					)
				}
				return applications

			rescue Interfaces::Gateways::Exceptions::ItunesUnauthorized => e 
				@session_repository.save(nil)
				raise Exceptions::InvalidSession, "The session was invalid"
			end
		end
	end
end
