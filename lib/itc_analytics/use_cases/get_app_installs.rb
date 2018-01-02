require "itc_analytics/domain/entities/metrics_query"
require "itc_analytics/domain/value_objects/analytics_options"
require "itc_analytics/domain/value_objects/metrics_options"
require "itc_analytics/use_cases/exceptions"
module ITCAnalytics
	module UseCases
		class GetAppInstalls
			attr_accessor :applications, :session_repository, :start_date, :end_date, :itunes_gateway

			def initialize(applications:, session_repository:, start_date:, end_date:, itunes_gateway:)
				@applications,
				@session_repository, 
				@start_date, 
				@end_date, 
				@itunes_gateway = [
					applications,
					session_repository, 
					start_date, 
					end_date, 
					itunes_gateway
				]
			end

			def execute
				session = @session_repository.get 
				if (session == nil || session.valid? == false) 
					raise Exceptions::InvalidSession, "Session was nil!"
				end

				analytics_options = Domain::ValueObjects::AnalyticsOptions.new(
					primary_measure: Domain::ValueObjects::AnalyticsOptions.measures[:installs],
					start_date: @start_date, 
					end_date: @end_date)

				metrics_options = Domain::ValueObjects::MetricsOptions.new(secondary_measure: nil,
					frequency: Domain::ValueObjects::MetricsOptions.frequencies[:days],
					group: {
						:metric => Domain::ValueObjects::AnalyticsOptions.measures[:installs],
						:dimension => Domain::ValueObjects::MetricsOptions.dimension_filter_keys[:device],
						:rank => "",
						:limit => 10
					},
					dimension_filters: [])
				
				query = Domain::Entities::MetricsQuery.new(session: session,
					applications: @applications, 
					analytics_options: analytics_options,
					metrics_options: metrics_options)
				
				results = @itunes_gateway.execute_metrics_query(query: query)

				results_obj = JSON.parse(results)
				if !results_obj.key?("results")
					raise Exceptions::NoResults, "There were no results in the json #{results}"
				end 

				return results_obj["results"].map { |result| {
					:adamId => result["adamId"],
					:meetsThreshold => result["meetsThreshold"],
					:platform => result["group"]["key"],
					:data => result["data"]
				} }


				

			rescue Interfaces::Gateways::Exceptions::ItunesUnauthorized => e 
				puts e.message
				@session_repository.save(nil)
				raise Exceptions::InvalidSession
			end

		end
	end
end
