module ITCAnalytics
	module Domain
		module Entities
			class Query
				attr_accessor :id, :session
				def initialize(session:)
					@session = session
				end
			end
		end
	end
end
