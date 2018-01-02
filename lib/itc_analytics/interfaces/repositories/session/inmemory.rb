module ITCAnalytics
	module Interfaces
		module Repositories
			module Session
				class InMemory
					attr_accessor :get

					def get 
						return @session
					end

					def save(session)
						@session = session
					end
				end
			end
		end
	end
end
