require 'optparse'
require "./crawler.rb"
options = {:limit => nil, :domain => nil}
parser = OptionParser.new do|opts|
	opts.banner = "Usage: crawl.rb [options]"
	opts.on('-d', '--domain domain', 'Domain [default = http://python.org]') do |domain|
		options[:domain] = domain
	end

	opts.on('-l', '--limit limit', 'Limit [ default = 100]') do |limit|
		options[:limit] = limit
	end

	opts.on('-h', '--help', 'Displays Help') do
		puts opts
		exit
	end
end
parser.parse!
options[:domain] = options[:domain].nil? ? "http://python.org" : options[:domain]
options[:limit] = options[:limit].nil? ? 100 : options[:limit]
crawler = Crawler.new(options[:domain], options[:limit])
crawler.crawl
puts "***********************CRAWL_OVER*******************"
puts crawler.crawled_pages
