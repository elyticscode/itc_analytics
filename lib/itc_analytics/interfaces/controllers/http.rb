require 'net/http'
require 'uri'
require 'openssl'

module ITCAnalytics
	module Interfaces
		module Controllers
			class Http
				def get(url:, headers:)
					uri = URI(url)

					request = Net::HTTP::Get.new(uri)
					headers.each do |key, value|
						request[key] = value
					end

					return fire_request(uri: uri, request: request)

				end
				def post(url:, headers:, post_body:) 
					uri = URI(url)

					request = Net::HTTP::Post.new(uri)
					request.body = post_body
					headers.each do |key, value|
						request[key] = value
					end

					return fire_request(uri: uri, request: request)

				end

				def fire_request(uri:, request:) 

					http = Net::HTTP.new(uri.host, uri.port)
					http.use_ssl = true 
					http.verify_mode = OpenSSL::SSL::VERIFY_NONE

					#remove
					http.set_debug_output($stdout)
					
					res = http.request(request)

					return Http.hash_response(res)
				end

				def self.hash_response(res) 
					begin
						body = res.body
					rescue Exception => e
						body = ""
					end
					return Hash["error" => !res.is_a?(Net::HTTPSuccess), 
								"body" => body,
								"code" => res.code,
								"message" => res.message,
								"headers" => res.to_hash]
				end
			end
		end
	end
end
