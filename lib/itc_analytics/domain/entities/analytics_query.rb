require "itc_analytics/domain/entities/query"
module ITCAnalytics
	module Domain
		module Entities
			class AnalyticsQuery < Query
				attr_accessor :application 
				def initialize(session:, applications:, analytics_options:)
					super(session: session)
					@applications = applications 
					@analytics_options = analytics_options
				end
			end
		end
	end
end
