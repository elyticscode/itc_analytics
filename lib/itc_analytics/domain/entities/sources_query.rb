module ITCAnalytics
	module Domain
		module Entities
			class SourcesQuery < AnalyticsQuery

				attr_reader :sources_options

				def self.dimensions
					d = Hash.new
					d[:appVersion] = "appVersion"
					d[:campaigns] = "campaignId"
					d[:device] = "platform"
					d[:platformVersion] = "platformVersion"
					d[:region] = "region"
					d[:territory] = "storefront"
					d[:websites] = "domainReferrer"
					d[:apps] = "appReferer"
					d[:sourceType] = "source"
					return d 
				end

				def initialize(session:, applications:, analytics_options:, sources_options:)
					super(session: session, applications: applications, analytics_options: analytics_options)
					@sources_options = sources_options
				end
			end
		end
	end
end
