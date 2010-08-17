require 'net/http'
require 'uri'
require 'open-uri'
require 'test/unit'
require 'rubygems'
require 'nokogiri'

class NokogiriTest < Test::Unit::TestCase	

	def test_setup
				
	end
	
	def test_nokogiri_opens_doc_if_doc_is_valid
		expected = "<!DOCTYPE html PUBLIC \"-//W3C//DTD HTML 4.0 Transitional//EN\" \"http://www.w3.org/TR/REC-html40/loose.dtd\">\n<html><body><h1>Mr. Belvedere Fan Club</h1></body></html>\n"
		actual = Nokogiri::HTML(expected).to_s

		assert_equal expected, actual
	end

	def test_find_all_hrefs_finds_2
		html = "<html><body><a href='index.html'>Home</a><a href='about.html'>About</a></body></body>"
		html_doc = Nokogiri::HTML(html)
		
		expected = 2
		actual = html_doc.css('a').size
		
		assert_equal expected, actual
	end

	def test_find_all_finds_2_urls
		html = "<html><body><a href='index.html'>Home</a><a href='about.html'>About</a></body></body>"
		html_doc = Nokogiri::HTML(html)
		expected = 2
		actual = 0
				
		html_doc.css('a').map do |href|
			href = href['href']
			actual = actual + 1 if href = "index.html" || href == "about.html"
		end
		
		assert_equal expected, actual	
	end
	
end
