require "mechanize"
require "./db.rb"

class Crawler
  attr_reader :root, :crawl_limit, :visited_pages
  SIZE_LIMIT = 50
  SLEEP_TIMER = 1

  def initialize(url = "http://python.org", crawl_limit = 100)
    @root = url
    @visited_pages = {}
    @pages_to_visit = []
    @pages_to_visit << @root
    @crawl_limit = crawl_limit.to_i
    @pages_crawled = 0
    @agent = Mechanize.new
    @db = Database.new
  end

  def crawl
    puts '######################CRAWL START####################'
    while @pages_crawled < @crawl_limit && @pages_to_visit.length != 0
      url = @pages_to_visit.shift
      puts "Crawled url #{url}"
      begin
        page = @agent.get(url)
        @pages_crawled += 1
        @visited_pages[url] = true
        page.links_with(href: /http.*/).each do |link|
          @pages_to_visit << link.href if !page_visited?(link.href)
        end
      rescue => ex
        next
      end
      @pages_to_visit.uniq!
      flush_to_db if @visited_pages.length == SIZE_LIMIT
      sleep SLEEP_TIMER
    end
    flush_to_db if @visited_pages.length > 0
  end

  def page_visited?(url)
    @visited_pages[url] || check_db(url)
  end

  def crawled_pages
    @db.get_pages
  end

  def flush_to_db
    @db.insert(visited_pages)
    @visited_pages = {}
  end

  def check_db(url)
    @db.get_count(url) == 1
  end
end
