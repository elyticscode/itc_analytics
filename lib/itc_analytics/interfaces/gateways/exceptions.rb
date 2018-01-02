
module ITCAnalytics
	module Interfaces
		module Gateways
			module Exceptions
				class ItunesRequestFailure < StandardError
				end

				class ItunesUnauthorized < StandardError
				end
			end
		end
	end
end
