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

  describe '.get_available_apps' do

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

    it 'gets all available apps' do
      ITCAnalytics.configure do |config|
        config.session_repository = session_repo(valid_session)
        config.itunesconnect_gateway = itunesconnect_gateway(File.read('spec/data/get_applications.json'))
      end

      result = ITCAnalytics.get_available_apps
      expect(result).not_to be_nil
      expect(result).to be_an(Array)
      expect(result[0]).to be_an(ITCAnalytics::Domain::Entities::Application)
    end
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


