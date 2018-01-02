module ITCAnalytics
	module Domain
		module ValueObjects
			class AnalyticsOptions

		  		attr_reader   :primary_measure
		  		attr_reader   :start_date
		  		attr_reader	  :end_date 

				def initialize(primary_measure:, start_date:, end_date:)
					@primary_measure = primary_measure
					@start_date = start_date
					@end_date = end_date 
				end

				def self.measures 
					measures = Hash.new
					measures[:installs] = "installs"
					measures[:sessions] = "sessions"
					measures[:pageViews] = "pageViewCount"
					measures[:activeDevices] = "activeDevices"
					measures[:rollingActiveDevices] = "rollingActiveDevices"
					measures[:crashes] = "crashes"
					measures[:payingUsers] = "payingUsers"
					measures[:units] = "units"
					measures[:sales] = "sales"
					measures[:iap] = "iap"
					measures[:impressionsTotal] = "impressionsTotal"
					measures[:impressionsUnique] = "impressionsUnique"
					measures[:pageViewUnique] = "pageViewUnique"
					return measures
				end 
			end
		end
	end
end
