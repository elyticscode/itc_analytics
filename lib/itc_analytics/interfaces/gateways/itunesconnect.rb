require "itc_analytics/interfaces/gateways/exceptions"
require 'json'
module ITCAnalytics
	module Interfaces
		module Gateways
			class ItunesConnect

				def initialize(http_controller:, apple_widget_key:)
					@http_controller = http_controller
					@apple_widget_key = apple_widget_key
				end

				def create_account_info_cookie(username:, password:)
					result = @http_controller.post(url: "https://idmsa.apple.com/appleauth/auth/signin",
						headers: Hash["Content-Type" => "application/json", "X-Apple-Widget-Key" => @apple_widget_key],
						post_body: "{\"accountName\": \"" << username << "\",\"password\": \"" << password << "\",\"rememberMe\": false}")

					if result['error'] == false && result['headers']['set-cookie'].find { |e| /myacinfo=.+?;/ =~ e }
						return result['headers']['set-cookie'].find { |e| /(myacinfo=.+?;)/ =~ e }.scan(/(myacinfo=.+?;)/).last.first
					end
					raise Exceptions::ItunesRequestFailure, "failed to get myacinfo apple may have changed login routine"
				end

				def get_itctx_cookie(account_info_cookie:) 
					result = @http_controller.get(url: "https://olympus.itunes.apple.com/v1/session",
						headers: Hash["Cookie" => account_info_cookie])

					if result['error'] == false && result['headers']['set-cookie'].find { |e| /itctx=.+?;/ =~ e }
						return result['headers']['set-cookie'].find { |e| /(itctx=.+?;)/ =~ e }.scan(/(itctx=.+?Only)/).last.first
					end
					raise Exceptions::ItunesRequestFailure, "failed to get itctx cookie apple may have changed login routine" 
				end

				def get_headers(get_cookies) 
					Hash["Content-Type" => "application/json;charset=UTF-8",
						 "Accept" => "application/json, text/plain, */*",
						 "Origin" => "https://analytics.itunes.apple.com",
						 "X-Requested-By" => "analytics.itunes.apple.com",
						 "Referer" => "https://analytics.itunes.apple.com/",
						 "Cookie" => get_cookies]
				end

        def result_body(result) 
          if result["error"] 
            if result["code"] == 401
              raise Exceptions::ItunesUnauthorized, "Unauthorized call to iTunesConnect #{result['message']}"
            end
            raise Exceptions::ItunesRequestFailure,  "iTunesConnect not responding to #{result['message']}"
          end
          return result["body"]
        end

				def get_api_url(url:, session_cookies:)
					result = @http_controller.get(url: url, headers: get_headers(session_cookies))
					return result_body(result)
				end

				def get_applications_json(session_cookies:) 
					url = 'https://analytics.itunes.apple.com/analytics/api/v1/app-info/app'
					return get_api_url(url: url, session_cookies: session_cookies)
				end

        def execute_metrics_query(query:)
          url = "https://analytics.itunes.apple.com/analytics/api/v1/data/time-series"
          post_body = query.assemble_body.to_json
          
          result = @http_controller.post(url: url, 
            headers: get_headers([query.session.account_cookie, query.session.itctx_cookie]),
            post_body: post_body)

          return result_body(result)
        end
			end
		end
	end
end
