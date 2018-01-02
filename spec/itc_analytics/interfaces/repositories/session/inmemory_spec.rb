require "spec_helper"

RSpec.describe ITCAnalytics::Interfaces::Repositories::Session::InMemory do 

	def repository
		ITCAnalytics::Interfaces::Repositories::Session::InMemory.new
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


	describe '.get/.save' do 
		it 'gets a nil session with no saves' do 
			repo = repository
			expect(repo.get).to be(nil)
		end

		it 'gets a good session with a save' do 
			session = valid_session 
			repo = repository
			repo.save(session)
			expect(repo.get).to be(session)
		end 

		it 'gets a nil session after saving nil session' do
			session = valid_session 
			repo = repository
			repo.save(session)
			expect(repo.get).to be(session) 

			repo.save(nil)
			expect(repo.get).to be(nil)
		end
	end 
end 
