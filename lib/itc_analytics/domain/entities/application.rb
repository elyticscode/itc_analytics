module ITCAnalytics
	module Domain
		module Entities
			class Application
				attr_accessor :id,
				   			  :itunes_app_id,
				              :itunes_app_name,
				              :is_bundle,
				              :icon_url,
				              :asset_token,
				              :platforms,
				              :is_enabled,
				              :app_opt_in_rate


				def initialize(itunes_app_id:, 
							   itunes_app_name:,
							   is_bundle:,
							   icon_url:,
							   asset_token:,
							   platforms:,
							   is_enabled:,
							   app_opt_in_rate:
							   )
					@itunes_app_id = itunes_app_id
					@itunes_app_name = itunes_app_name
					@is_bundle = is_bundle
					@icon_url = icon_url
					@asset_token = asset_token
					@platforms = platforms
					@is_enabled = is_enabled
					@app_opt_in_rate = app_opt_in_rate
				end

				def valid?
	  				String(itunes_app_id).length > 0
				end
			end
		end
	end
end
