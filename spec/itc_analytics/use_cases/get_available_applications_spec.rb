require "spec_helper"
require "itc_analytics/use_cases/get_available_applications"
require "itc_analytics/domain/entities/application"

RSpec.describe ITCAnalytics::UseCases::GetAvailableApplications do 
	describe '.execute' do 
		def session_repo(return_session)
			repo = double("Repositories::Session::InMemory")
			allow(repo).to receive(:get).and_return(return_session)
			allow(repo).to receive(:save)
			repo
		end

		def session
			s = double("Domain::Entities::Session")
			allow(s).to receive(:account_cookie).and_return("fake_account_cookie")
			allow(s).to receive(:itctx_cookie).and_return("fake_itctx_cookie")
			return s
		end
		
		def valid_session 
			valid_session = session
			allow(valid_session).to receive(:nil?).and_return(false)
			allow(valid_session).to receive(:valid?).and_return(true)
			valid_session
		end

		def invalid_session
			valid_session = session
			allow(valid_session).to receive(:nil?).and_return(false)
			allow(valid_session).to receive(:valid?).and_return(false)
			valid_session
		end

		def itunesconnect_gateway(data_returned) 
			gateway = double("itunesconnect_gateway")
			if data_returned == nil 
				allow(gateway).to receive(:get_applications_json).and_raise(
					ITCAnalytics::Interfaces::Gateways::Exceptions::ItunesUnauthorized
				)
			else
				allow(gateway).to receive(:get_applications_json).and_return(data_returned)
			end
			gateway
		end

		it 'gets a list of available Application Entities' do 
			use_case = ITCAnalytics::UseCases::GetAvailableApplications.new(
				session_repository: session_repo(valid_session),
				itunesconnect_gateway: itunesconnect_gateway(File.read('spec/data/get_applications.json'))
			)

			applications = use_case.execute
			expect(applications).not_to be_nil
			expect(applications).not_to be_empty
			expect(applications).to all( be_an(ITCAnalytics::Domain::Entities::Application) )
		end

		it 'fails to get a list because the results returned were nil' do 
			use_case = ITCAnalytics::UseCases::GetAvailableApplications.new(
				session_repository: session_repo(valid_session),
				itunesconnect_gateway: itunesconnect_gateway(nil))

			expect { use_case.execute }.to raise_error(
				ITCAnalytics::UseCases::Exceptions::InvalidSession
			)
		end

		it 'fails to get a list because there was no results key' do 
			use_case = ITCAnalytics::UseCases::GetAvailableApplications.new(
				session_repository: session_repo(valid_session),
				itunesconnect_gateway: itunesconnect_gateway('{"size": 0}'))

			expect { use_case.execute }.to raise_error(
				ITCAnalytics::UseCases::Exceptions::NoResults
			)
		end

		it 'failse to get a list because the session is invalid from the beginning' do 
			use_case = ITCAnalytics::UseCases::GetAvailableApplications.new(
				session_repository: session_repo(invalid_session),
				itunesconnect_gateway: itunesconnect_gateway('{"size": 0}')
			)
			expect { use_case.execute }.to raise_error(
				ITCAnalytics::UseCases::Exceptions::InvalidSession
			)
		end
	end
end 
