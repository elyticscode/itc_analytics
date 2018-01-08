require "spec_helper"
require 'itc_analytics/domain/entities/application'
RSpec.describe ITCAnalytics::Domain::Entities::Application do 
	
	def application_build(itunes_app_id,
						  itunes_app_name,
						  is_bundle,
						  icon_url,
						  asset_token,
						  platforms,
						  is_enabled,
						  app_opt_in_rate)
		ITCAnalytics::Domain::Entities::Application.new(itunes_app_id: itunes_app_id,
			itunes_app_name: itunes_app_name,
			is_bundle: is_bundle,
			icon_url: icon_url,
			asset_token: asset_token,
			platforms: platforms,
			is_enabled: is_enabled,
			app_opt_in_rate: app_opt_in_rate)
	end

	describe '.valid?' do
		it 'is valid with a name and id' do 
			app = application_build("valid_id", "valid_name", nil, nil, nil, nil, nil, nil)
			expect(app).not_to be_nil
			expect(app.valid?).to be(true)
		end

		it 'is not valid missing id' do 

			app = application_build("", "valid_name", nil, nil, nil, nil, nil, nil)
			expect(app).not_to be_nil
			expect(app.valid?).to be(false)


			app = application_build(nil, "valid_name", nil, nil, nil, nil, nil, nil)
			expect(app).not_to be_nil
			expect(app.valid?).to be(false)
		end
	end 
end 
