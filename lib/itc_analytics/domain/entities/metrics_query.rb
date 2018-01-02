require "itc_analytics/domain/entities/analytics_query"
module ITCAnalytics
	module Domain
		module Entities
			class MetricsQuery < AnalyticsQuery

				attr_reader	:metrics_options

				def initialize(session:, applications:, analytics_options:, metrics_options:)
					super(session: session, applications: applications, analytics_options: analytics_options)
					@metrics_options = metrics_options
				end

				def assemble_body
					measures = [@analytics_options.primary_measure]
		            measures << @metrics_options.secondary_measure unless @metrics_options.secondary_measure == nil

		            adamIds = @applications.map { |application| application.itunes_app_id } 
		            	
		            startTime = @analytics_options.start_date.strftime("%Y-%m-%dT%H:%M:000Z")
		            endTime = @analytics_options.end_date.strftime("%Y-%m-%dT%H:%M:000Z")
		            return {
		            	:startTime => startTime,
		              	:endTime => endTime,
		              	:adamId => adamIds,
		              	:measures => measures,
		              	:group => @metrics_options.group,
		              	:frequency => @metrics_options.frequency
		            }
				end
			end
		end
	end
end
