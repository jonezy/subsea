require 'net/http'
require 'uri'
require 'open-uri'
require 'rubygems'

begin 
  require 'nokogiri'
rescue
  puts "you need to have nokogiri installed for subsea to work, gem install nokogiri please"
end

require 'subsea/time_helpers'

module SubSea
  class Crawler

    include TimeHelpers

    attr_reader :already_visited, :message
		
    def initialize
      @already_visited = {}
      @visited_urls = {}
      @crawl_count = 0
      @current_domain = ""
    end

    def crawl(urls, page_limit = 50)
      raise "You must pass in a comma delimited list of urls to crawl, containing at least 1 url." if urls.empty? || urls == nil
      @visited_urls = urls # this keeps track of the original set of urls we were asked to crawl.	

      time do
        urls.each do |url|
          puts "\nStarting to crawl #{url}"
          @current_domain = url
          crawl_domain(url, page_limit)

          @crawl_count += @already_visited.size
          @already_visited = {}
        end
      end

      @message = "Crawled #{@crawl_count} urls in #{format_time_for_display(@finish)} #{get_ticks_for_display_from_time(@finish)}"  	
    end

    # private (mostly) helper methods
    private

    # crawls the specified url the number of times specified by page_limit
    def crawl_domain(url, page_limit)
      return if @already_visited.size == page_limit

      parsed_url = get_url(url) rescue return
      return if parsed_url == nil

      @already_visited[url]=true if @already_visited[url] == nil

      page_urls = find_urls_on_page(parsed_url, url)
      page_urls.each do |page_url|
        begin
          if urls_on_same_domain?(url, page_url) and @already_visited[page_url] == nil
            crawl_domain(page_url, page_limit)
          end
        rescue Exception => e
          puts e
        end
      end
    end
		
    def get_url(url)
      begin
        request = open(url)
        doc = Nokogiri::HTML(request)
      rescue
        puts "\tCould not parse url: " + request.base_uri.to_s
        doc = nil
      end
      puts "\tCrawling url " + request.base_uri.to_s
      return doc
    end		
	
    def find_urls_on_page(parsed_url, current_url)
      urls = []

      parsed_url.css('a').map do |a|
        u = a.attributes['href'].content rescue nil

        next if u.nil? or u.empty?
        next if !url_is_valid?(u)

        u = to_absolute_url(current_url, u) if relative?(u)

        urls.push(u)
      end

      return urls
    end		
    
    def urls_on_same_domain?(url1, url2)
      return URI(url1).host == URI(url2).host
    end    
    
    def to_absolute_url(potential_base, relative_url)
      relative_url = relative_url.gsub(/#[a-zA-Z0-9_-]*$/,'')
      absolute_url = URI(potential_base).merge(relative_url);

      return absolute_url.to_s
    end

    def relative?(url)
      return url.match(/^http/).nil?
    end
    
    def url_is_valid?(url)
      return false if url == "" || url == nil
      toRemove = ['.html','.pdf','.jpg','jpeg','.gif','javascript','.wmv','mailto','#']

      toRemove.each do |e|
        return false if url.downcase.match(e)
      end
    end    
  end
end
