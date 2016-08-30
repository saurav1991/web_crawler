require "sqlite3"
class Database
  def initialize
    @db = SQLite3::Database.new "test.db"
    @db.execute <<-SQL
      create table visited_pages (
        url text
      );
    SQL
    @db.execute <<-SQL
      create index url_index ON visited_pages(url);
    SQL
  end

  def insert(visited_pages)
    visited_pages.keys.each do |page|
      @db.execute("insert into visited_pages values (?)", page)
    end
  end

  def get_count(url)
    query = "select count(*) from visited_pages where url = \"#{url}\""
    @db.execute(query).last.last
  end

  def get_pages
    query = "select url from visited_pages"
    @db.execute(query).flatten
  end
end
