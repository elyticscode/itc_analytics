require "spec_helper"

RSpec.describe ITCAnalytics::UseCases::Login do 
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

		def create_new_session_use_case(return_session)
			create_new_session = double("UseCases::CreateNewSession")
			allow(create_new_session).to receive(:execute).and_return(return_session)
			create_new_session
		end 

		it 'gets an existing valid session' do 
			
			repo = session_repo(valid_session)

			login_use_case = 
			ITCAnalytics::UseCases::Login.new(username: "fake",
				password: "fake",
				session_repository: repo,
				itunesconnect_gateway: nil)
			result = login_use_case.execute
			expect(result).to eq(true)
		end

		it 'creates a new session after existing is invalid' do 

			repo = session_repo(invalid_session)


			login_use_case = 
			ITCAnalytics::UseCases::Login.new(username: "fake",
				password: "fake",
				session_repository: repo,
				itunesconnect_gateway: nil)

			create_new_session = create_new_session_use_case(valid_session)
			login_use_case.create_new_session_use_case = create_new_session

			expect(repo).to receive(:save)
			result = login_use_case.execute
			expect(result).to eq(true)
		end 

		it 'fails to create a new session after existing is invalid' do 
			repo = session_repo(invalid_session)


			login_use_case = 
			ITCAnalytics::UseCases::Login.new(username: "fake",
				password: "fake",
				session_repository: repo,
				itunesconnect_gateway: nil)


			create_new_session = create_new_session_use_case(invalid_session)
			login_use_case.create_new_session_use_case = create_new_session

			result = login_use_case.execute
			expect(result).to eq(false)
		end
	end 
end
