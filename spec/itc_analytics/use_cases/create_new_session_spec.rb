require "spec_helper"

RSpec.describe ITCAnalytics::UseCases::CreateNewSession do 
	describe '.execute' do 

		def itunesconnect_gateway(account_info_cookie, itctx_cookie)
			gateway = double("Interfaces::Gateways::ItunesConnect")
			allow(gateway).to receive(:create_account_info_cookie).and_return(account_info_cookie)
			allow(gateway).to receive(:get_itctx_cookie).and_return(itctx_cookie)
			gateway 
		end

		def use_case(gateway) 
			ITCAnalytics::UseCases::CreateNewSession.new(username: "fake",
				password: "fake", 
				itunesconnect_gateway: gateway)
		end
		
		it 'creates a new session by calling the itunesconnect_gateway' do 
			gateway = itunesconnect_gateway("account_info", "itctx")


			result = use_case(gateway).execute 
			expect(result).to be_an(ITCAnalytics::Domain::Entities::Session)
		end

		it 'fails to get the account info cookie and so fails to create a new session' do 
			gateway = itunesconnect_gateway(nil, "itctx")
			expect(gateway).to receive(:create_account_info_cookie)
			result = use_case(gateway).execute
			expect(result).to be(nil)
		end 

		it 'succeeds to get the account info cookie but fails to get the itctx_cookie and so fails to create a new session' do
			gateway = itunesconnect_gateway("account_info", nil) 
			expect(gateway).to receive(:create_account_info_cookie)
			expect(gateway).to receive(:get_itctx_cookie)
			result = use_case(gateway).execute
			expect(result).to be(nil)
		end
	end 
end
