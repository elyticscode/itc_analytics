module ITCAnalytics
	module Domain
		module ValueObjects
			class SourcesOptions
				attr_reader :dimension
				attr_reader :limit

				def initialize(dimension:, limit:)
					@dimension = dimension
					@limit = limit
				end
			end
		end
	end
end
