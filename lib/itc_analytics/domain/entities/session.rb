module ITCAnalytics
  	module Domain	
	  	module Entities
		  	class Session
		  		attr_accessor :id
		  		attr_reader   :account_cookie
		  		attr_reader   :itctx_cookie

		  		def initialize(account_cookie: '', itctx_cookie: '')
		  			@account_cookie = account_cookie
		  			@itctx_cookie = itctx_cookie
		  		end 

		  		def valid? 
		  			String(account_cookie).length > 0 && String(itctx_cookie).length > 0
		  		end
		  	end
	  	end
	end
end 
