require "spec_helper"
require "itc_analytics/use_cases/get_app_installs"
RSpec.describe ITCAnalytics::UseCases::GetAppInstalls do 
	describe '.execute' do 

		def session_repo(return_session)
			repo = double("Repositories::Session::InMemory")
			allow(repo).to receive(:get).and_return(return_session)
			allow(repo).to receive(:save)
			repo
		end

		def session
			double("Domain::Entities::Session")
		end
		
		def valid_session 
			valid_session = session
			allow(valid_session).to receive(:nil?).and_return(false)
			allow(valid_session).to receive(:valid?).and_return(true)
			valid_session
		end

		def invalid_session
			invalid_session = session 
			allow(invalid_session).to receive(:nil?).and_return(false)
			allow(invalid_session).to receive(:valid?).and_return(false)
			invalid_session
		end

		it 'gets a valid set of install data for a given application and given start and end date' do 
			start_date = Date.parse('01-12-2017')
			end_date = start_date

			gateway = double("Interfaces::Gateways::ItunesConnect")
			allow(gateway).to receive(:execute_metrics_query).and_return(File.read('spec/data/get_installs.json'))
			repo = session_repo(valid_session)
			application = double("Domain::Entities::Application")
			use_case = ITCAnalytics::UseCases::GetAppInstalls.new(
				applications: [application],
				session_repository: repo,
				start_date: start_date,
				end_date: end_date,
				itunes_gateway: gateway
			)
			result = use_case.execute
			expect(result).not_to be(nil)
			expect(result).to be_an(Array)
			expect(result.count).to eq(4)
		end

		it 'fails to get a valid set of install data due to invalid session' do
			start_date = Date.parse('01-12-2017')
			end_date = start_date

			gateway = double("Interfaces::Gateways::ItunesConnect")
			allow(gateway).to receive(:execute_metrics_query).and_return(File.read('spec/data/get_installs.json'))
			repo = session_repo(invalid_session)
			application = double("Domain::Entities::Application")
			use_case = ITCAnalytics::UseCases::GetAppInstalls.new(
				applications: [application],
				session_repository: repo,
				start_date: start_date,
				end_date: end_date,
				itunes_gateway: gateway
			)
			expect { use_case.execute }.to raise_error(
				ITCAnalytics::UseCases::Exceptions::InvalidSession
			)
		end

		it 'fails to get a valid set of install data due to no results key' do 
			start_date = Date.parse('01-12-2017')
			end_date = start_date

			gateway = double("Interfaces::Gateways::ItunesConnect")
			allow(gateway).to receive(:execute_metrics_query).and_return("{}")
			repo = session_repo(valid_session)
			application = double("Domain::Entities::Application")
			use_case = ITCAnalytics::UseCases::GetAppInstalls.new(
				applications: [application],
				session_repository: repo,
				start_date: start_date,
				end_date: end_date,
				itunes_gateway: gateway
			)
			expect { use_case.execute }.to raise_error(
				ITCAnalytics::UseCases::Exceptions::NoResults
			)
		end

		it 'fails to get a valid set of install data due to itunes unauthorized and raises invalid session' do
			start_date = Date.parse('01-12-2017')
			end_date = start_date

			gateway = double("Interfaces::Gateways::ItunesConnect")
			allow(gateway).to receive(:execute_metrics_query).and_raise(
				ITCAnalytics::Interfaces::Gateways::Exceptions::ItunesUnauthorized
			)
			repo = session_repo(valid_session)
			application = double("Domain::Entities::Application")
			use_case = ITCAnalytics::UseCases::GetAppInstalls.new(
				applications: [application],
				session_repository: repo,
				start_date: start_date,
				end_date: end_date,
				itunes_gateway: gateway
			)
			expect { use_case.execute }.to raise_error(
				ITCAnalytics::UseCases::Exceptions::InvalidSession
			)
		end
	end
end
