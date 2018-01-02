module ITCAnalytics
	module Domain
		module ValueObjects
			class GroupOptions

				attr_reader :metric
				attr_reader :dimension
				attr_reader :rank
				attr_reader :limit 

				def initialize(metric:, dimension:, rank:, limit:) 
					@metric = metric
					@dimension = dimension 
					@rank = rank
					@limit = limit
				end
			end
		end
	end
end
