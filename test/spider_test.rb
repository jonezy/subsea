require 'test/unit'
require 'subsea/subsea'

class SpiderTest < Test::Unit::TestCase

	def test_crawl_should_return_error_if_urls_is_empty
		urls = []
		subsea_crawler = SubSea::Crawler.new
		
		begin
			subsea_crawler.crawl(urls, 500)
		rescue Exception => e
			assert_equal true, e.to_s.length > 0, "Expected an error message, didn't get one."
		end
	end

end
