
module SiteDomain
	class Processor < Sprockets::Processor
		def evaluate(context, locals)
    		data.gsub(%r"\bHOSTNAME\b", "myserver.com")
    	end
  	end
		
end
