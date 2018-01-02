module ITCAnalytics
	module Domain
		module ValueObjects
			class MetricsOptions

				attr_reader :secondary_measure
				attr_reader :frequency
				attr_reader :group
				attr_reader :dimension_filters

				def initialize(secondary_measure:, frequency:, group:, dimension_filters:)
					@secondary_measure = secondary_measure
					@frequency = frequency
					@group = group
					@dimension_filters = dimension_filters
				end

				def self.dimension_filter_keys
					dfk = Hash.new
					dfk[:appPurchaseWeek] = "apppurchaseWeek"
					dfk[:appPurchaseDay] = "apppurchaseDay"
					dfk[:appPurchaseMonth] = "apppurchaseMonth"
					dfk[:appVersion] = "appVersion"
					dfk[:campaigns] = "campaignId"
					dfk[:device] = "platform"
					dfk[:platformVersion] = "platformVersion"
					dfk[:territory] = "storefront"
					dfk[:region] = "region"
					dfk[:websites] = "domainReferrer"
					return dfk
				end

				def self.platforms 
					pl = Hash.new 
					pl[:iPhone] = "iPhone"
					pl[:iPad] = "iPad"
					pl[:iPod] = "iPod"
					pl[:appleTV] = "AppleTV"
					return pl 
				end 

				def self.frequencies
					f = Hash.new
					f[:days] = "DAY"
					f[:weeks] = "WEEK"
					f[:months] = "MONTH"
					return f
				end
			end
		end
	end
end
