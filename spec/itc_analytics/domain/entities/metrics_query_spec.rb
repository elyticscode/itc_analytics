require "spec_helper"
require "itc_analytics/domain/entities/metrics_query"

RSpec.describe ITCAnalytics::Domain::Entities::MetricsQuery do 
	describe('.assemble_body') do 
		it 'assembles a proper hash based on input' do
			app_id = "012345"
			session = double('session')
			account_cookie = "fake_account_cookie"
			itctx_cookie = "fake_itctx_cookie"
			date = Date.parse('01-12-2017')
			allow(session).to receive(:account_cookie).and_return(account_cookie)
			allow(session).to receive(:itctx_cookie).and_return(itctx_cookie)
			application = double('application')
			allow(application).to receive(:itunes_app_id).and_return(app_id)
			analytics_options = double('analytics_options')
			allow(analytics_options).to receive(:primary_measure).and_return("installs")
			allow(analytics_options).to receive(:start_date).and_return(date)
			allow(analytics_options).to receive(:end_date).and_return(date)
			metrics_options = double('metrics_options')
			allow(metrics_options).to receive(:secondary_measure).and_return(nil)
			allow(metrics_options).to receive(:frequency).and_return("DAY")
			allow(metrics_options).to receive(:group).and_return(
				{
					:metric => "installs", 
					:dimension => "platform",
					:rank => "",
					:limit => 10
				}
			)
			query = ITCAnalytics::Domain::Entities::MetricsQuery.new(session: session, 
				applications: [application], 
				analytics_options: analytics_options,
				metrics_options: metrics_options)
			result = query.assemble_body

			datestr = date.strftime("%Y-%m-%dT%H:%M:000Z")
			expect(result).to eq({:adamId => [app_id],
				:endTime => datestr,
				:startTime => datestr,
				:frequency => "DAY",
				:group => {
					:metric => "installs", 
					:dimension => "platform", 
					:rank => "", 
					:limit => 10
				},
				:measures => ["installs"]
			})
		end
	end
end
