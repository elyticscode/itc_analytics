require "spec_helper"

RSpec.describe ITCAnalytics::Domain::Entities::Session do 
	def	session_build(account, itctx)
		ITCAnalytics::Domain::Entities::Session.new(account_cookie: account, itctx_cookie: itctx)
	end
	describe '.valid?' do 
		it 'is valid if not missing either account info or itctx' do 
			session = session_build('account_info', 'itctx_info')
			expect(session.valid?).to be(true)
		end

		it 'is not valid if missing account info' do 
			session = session_build(nil, 'itctx_info')
			expect(session.valid?).to be(false)

			session = session_build('', 'itctx_info')
			expect(session.valid?).to be(false)
		end 

		it 'is not valid if missing itctx info' do 
			session = session_build('account_info', nil)
			expect(session.valid?).to be(false)
			session = session_build('account_info', '')
			expect(session.valid?).to be(false)
		end
	end
end 
