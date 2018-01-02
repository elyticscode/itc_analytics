require "spec_helper"
require "itc_analytics/use_cases/create_new_session"
RSpec.describe ITCAnalytics do
  describe '.login' do 
  	let(:repo) { ITCAnalytics.session_repository }


  	it 'gets a session cookie from the session repository' do

  		ITCAnalytics.configure do |config|
  			gateway = double("itunesconnect_gateway")
  			allow(gateway).to receive(:create_account_info_cookie).and_return("fakecookie") 
  			allow(gateway).to receive(:get_itctx_cookie).and_return("anotherfakecookie")
  			config.itunesconnect_gateway = gateway

  			
  		end

  		expect { ITCAnalytics.login('user', 'pass') }.
  			to change{ repo.get }
  	end
  end

  def http_controller 
    return ITCAnalytics::Interfaces::Controllers::Http.new
  end  

  def itunesconnect_gateway 
    return ITCAnalytics::Interfaces::Gateways::ItunesConnect.new(http_controller: http_controller, 
      apple_widget_key: "22d448248055bab0dc197c6271d738c3")
  end


=begin
  describe '.get_installs_for_date' do 
    it 'gets the app installs data for a give date and app id' do

      session = ITCAnalytics::UseCases::CreateNewSession.new(
        username: "appledev@bonneville.com",
        password: "Hans41?soak",
        itunesconnect_gateway: itunesconnect_gateway
      ).execute

      repo = ITCAnalytics::Interfaces::Repositories::Session::InMemory.new
      repo.save(session)

      applications = ITCAnalytics::UseCases::GetAvailableApplications.new(
        session_repository: repo,
        itunesconnect_gateway: itunesconnect_gateway
      ).execute

      application = applications[0]
      puts "Calling for data for application #{application.itunes_app_name}"

      start_date = Date.parse('01-12-2017')
      end_date = start_date
      results = ITCAnalytics::UseCases::GetAppInstalls.new(
        applications: [application], 
        session_repository: repo,
        start_date: start_date,
        end_date: end_date,
        itunes_gateway: itunesconnect_gateway
      ).execute

      expect(results).not_to be(nil)
    end
  end
=end
end


