require "spec_helper"
require "itc_analytics/interfaces/controllers/http"
require "itc_analytics/interfaces/gateways/exceptions"

def myacinfo
	return 'myacinfo=DAWTKNV27d3f4d80df44499bf05b013a73595da565ac745f88640d2c8b16760cb461b0e15dd5f9ab36735e3ff3caf0fd79ff5a22f504c85da23c859f23b28d94dbd31667230f286ee97fd04fcbd0f715baf2afaec8fffc7f7af75c471b298842ee73a1bdaa7056d5cbe4bd21605f758252a3e822eb513d206c6a9d90ff394092667b53034a4fdaa9e2dca4ca125e0de4e79080bc832abb4e1fee268279842f3fe665bb64e4304092c0b8bef3efb0e676eb08c565ba2ed0e76b90a3bdbffa2aa5a3ce8920956378a04c85bb61670f2ab1129564c6e16b6b34ef07be73fceec5788bc2f2d4609e44f840cef1b22e1f5336b0bb3fca32396161356430393463393862633666303033323031336136306561663361626166633965336137MVRYV2'
end

def good_myacinfo_cookie
	return "aa=CB7DAAED1B19690D9F9B0C7B893F85C6; Domain=idmsa.apple.com; Path=/; Secure; HttpOnly, dslang=US-EN; Domain=apple.com; Path=/; Secure; HttpOnly, site=USA; Domain=apple.com; Path=/; Secure; HttpOnly, #{myacinfo}; Domain=apple.com; Path=/; Secure; HttpOnly"
end

def bad_myacinfo_cookie
	return 'aa=5C86CCCB5FC60B653B0BB92318928976; Domain=idmsa.apple.com; Path=/; Secure; HttpOnly, dslang=US-EN; Domain=apple.com; Path=/; Secure;'
end 

def itctx
	return 'itctx=eyJjcCI6MjY2MzgyLCJkcyI6MTA5MDU2NDQzODAsImV4IjoiMjAxNy0xMS0yNyAxMTozODo1In0|6bsuogavt4t5ctfaeigs9bitsp|JDoSZkeUo8t9ovgK-jWNpv5Yc8A'
end 

def good_itctx_cookie
	return "dqsid=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJqdGkiOiI5enNZQmNyNzhBeDV0QXVSaXBjUVF3In0.91hP5dtMF2o_NqyG1mS5crYiw8okI6aFkxBX4NKDKVY; Max-Age=1800; Expires=Mon, 27 Nov 2017 04:08:05 GMT; Path=/; Secure; HTTPOnly, dc=-1;Version=1;Domain=.itunes.apple.com;Path=/;Max-Age=3600, #{itctx};Version=1;Comment=;Domain=.apple.com;Path=/;Secure;HttpOnly, itcdq=0;Version=1;Comment=;Domain=.apple.com;Path=/;Secure;HttpOnly"
end

def bad_itctx_cookie
	return "dqsid=; Expires=Thu, 01 Jan 1970 00:00:00 GMT; Path=/; Secure; HTTPOnly"
end

def no_error_response(cookie)
	net_http_resp = Net::HTTPSuccess.new(1.1, 200, "No Error")
	net_http_resp.add_field 'Set-Cookie', cookie
	return ITCAnalytics::Interfaces::Controllers::Http.hash_response(net_http_resp)
end

def no_error_response_body(body)
	net_http_resp = double("Net::HTTPSuccess")
	allow(net_http_resp).to receive(:is_a?).and_return(true)
	allow(net_http_resp).to receive(:code).and_return(200)
	allow(net_http_resp).to receive(:message).and_return("")
	allow(net_http_resp).to receive(:to_hash).and_return([])
	allow(net_http_resp).to receive(:body).and_return(body)
	return ITCAnalytics::Interfaces::Controllers::Http.hash_response(net_http_resp)
end

def error_response(code)
	resp = double("Net::HTTPError")
	allow(resp).to receive(:is_a?).and_return(false)
	allow(resp).to receive(:code).and_return(code)
	allow(resp).to receive(:message).and_return("")
	allow(resp).to receive(:to_hash).and_return([])
	allow(resp).to receive(:body).and_return("")
	return ITCAnalytics::Interfaces::Controllers::Http.hash_response(resp)
end


RSpec.describe ITCAnalytics::Interfaces::Gateways::ItunesConnect do 
#   let(:log) { 
#		Logger.new(STDOUT).tap { |l| l.level = Logger::DEBUG }
#	}
	describe '.create_account_info_cookie' do 

		it 'creates a new account info cookie' do 
			http_controller = double("http_controller")
			allow(http_controller).to receive(:post).and_return(no_error_response(good_myacinfo_cookie))
			itunes_connect_gateway = 
			ITCAnalytics::Interfaces::Gateways::ItunesConnect.new(http_controller: http_controller,
				apple_widget_key: "22d448248055bab0dc197c6271d738c3")

			result = itunes_connect_gateway.create_account_info_cookie(username: "fakeuser", password: "fakepass")
			expect(result).to match a_string_starting_with(myacinfo)

		end 

		it 'fails to create a new account info cookie' do 
			http_controller = double("http_controller")
			allow(http_controller).to receive(:post).and_return(no_error_response(bad_myacinfo_cookie))
			itunes_connect_gateway = 
			ITCAnalytics::Interfaces::Gateways::ItunesConnect.new(http_controller: http_controller,
				apple_widget_key: "22d448248055bab0dc197c6271d738c3")

			expect { 
				itunes_connect_gateway.create_account_info_cookie(username: "fakeuser", password: "fakepass")
			}.to raise_error(ITCAnalytics::Interfaces::Gateways::Exceptions::ItunesRequestFailure)
		end
	end

	describe '.get_itctx_cookie' do 
		it 'gets an itctx cookie' do 
			http_controller = double("http_controller")
			allow(http_controller).to receive(:get).and_return(no_error_response(good_itctx_cookie))
			itunes_connect_gateway = 
			ITCAnalytics::Interfaces::Gateways::ItunesConnect.new(http_controller: http_controller,
				apple_widget_key: "22d448248055bab0dc197c6271d738c3")

			result = itunes_connect_gateway.get_itctx_cookie(account_info_cookie: "fakemyacinfo")
			expect(result).to match a_string_starting_with(itctx)
		end 

		it 'fails to get an itctx cookie' do 
			http_controller = double("http_controller")
			allow(http_controller).to receive(:get).and_return(no_error_response(bad_itctx_cookie))
			itunes_connect_gateway = 
			ITCAnalytics::Interfaces::Gateways::ItunesConnect.new(http_controller: http_controller,
				apple_widget_key: "22d448248055bab0dc197c6271d738c3")
			expect { 
				itunes_connect_gateway.get_itctx_cookie(account_info_cookie: "fakemyacinfo")
			}.to raise_error(ITCAnalytics::Interfaces::Gateways::Exceptions::ItunesRequestFailure)	
		end
	end 

	describe '.get_applications_json' do 
		it 'gets a list of applications in raw data format from itunesconnect with a valid session' do 
			http_controller = double("http_controller")
			json = File.read('spec/data/get_applications.json')
			response = no_error_response_body(json)
			allow(http_controller).to receive(:get).and_return(response)
			itunes_connect_gateway = 
			ITCAnalytics::Interfaces::Gateways::ItunesConnect.new(http_controller: http_controller,
				apple_widget_key: "22d448248055bab0dc197c6271d738c3")

			cookies = "account_info_cookie; itctx_cookie;"
			result = itunes_connect_gateway.get_applications_json(session_cookies: cookies)
			expect(result).to eq(json)
		end

		it 'fails to get a list of applications because results came back nil' do 
			http_controller = double("http_controller")
			response = error_response(401)
			allow(http_controller).to receive(:get).and_return(response)
			itunes_connect_gateway = 
			ITCAnalytics::Interfaces::Gateways::ItunesConnect.new(http_controller: http_controller,
				apple_widget_key: "22d448248055bab0dc197c6271d738c3")

			cookies = "account_info_cookie; itctx_cookie;"
			expect {
				itunes_connect_gateway.get_applications_json(session_cookies: cookies)
			}.to raise_error(ITCAnalytics::Interfaces::Gateways::Exceptions::ItunesUnauthorized)
		end 

		it 'fails to get a list of applications because the request timed out' do 
			http_controller = double("http_controller")
			response = error_response(500)
			allow(http_controller).to receive(:get).and_return(response)
			itunes_connect_gateway = 
			ITCAnalytics::Interfaces::Gateways::ItunesConnect.new(http_controller: http_controller,
				apple_widget_key: "22d448248055bab0dc197c6271d738c3")

			cookies = "account_info_cookie; itctx_cookie;"
			expect { 
				itunes_connect_gateway.get_applications_json(session_cookies: cookies)
			}.to raise_error(ITCAnalytics::Interfaces::Gateways::Exceptions::ItunesRequestFailure)
		end 
	end

	describe '.execute_metrics_query' do
		it 'executes a metrics query successfully' do

			session = double("session")
			allow(session).to receive(:valid?).and_return(true)
			allow(session).to receive(:account_cookie).and_return("fake_account_cookie")
			allow(session).to receive(:itctx_cookie).and_return("fake_itctx_cookie")

			application = double("application")
			allow(application).to receive(:itunes_app_id).and_return("012345")
			start_date = Date.parse('01-12-2017')
			end_date = start_date
			analytics_options = ITCAnalytics::Domain::ValueObjects::AnalyticsOptions.new(
				primary_measure: ITCAnalytics::Domain::ValueObjects::AnalyticsOptions.measures[:installs],
				start_date: start_date,
				end_date: end_date,
			)

			metrics_options = ITCAnalytics::Domain::ValueObjects::MetricsOptions.new(
				secondary_measure: nil,
				frequency: ITCAnalytics::Domain::ValueObjects::MetricsOptions.frequencies[:days],
				group: {
					:metric => analytics_options.primary_measure,
					:dimension => ITCAnalytics::Domain::ValueObjects::MetricsOptions.dimension_filter_keys[:device],
					:rank => "",
					:limit => 10
				},
				:dimension_filters => nil
			)

			query = ITCAnalytics::Domain::Entities::MetricsQuery.new(
				session: session,
				applications: [application],
				analytics_options: analytics_options,
				metrics_options: metrics_options
			)

			http_controller = double("http_controller")
			json = File.read('spec/data/get_installs.json')
			response = no_error_response_body(json)
			allow(http_controller).to receive(:post).and_return(response)
			itunes_connect_gateway = 
			ITCAnalytics::Interfaces::Gateways::ItunesConnect.new(http_controller: http_controller,
				apple_widget_key: "22d448248055bab0dc197c6271d738c3")

			itunes_connect_gateway.execute_metrics_query(query: query)


		end
	end

end
