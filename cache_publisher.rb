require 'rss/2.0'
require 'rss/maker'
load 'cache.rb'

class CachePublisher
  def self.publish_rss(caches, filename)
    if(File.exists?(filename))
      previous_rss = RSS::Parser.parse(File.open(filename, 'r').read(), false)
    end

    content = RSS::Maker.make('2.0') do |m|
      m.channel.title = "NCA - Recent Cache Listing"
      m.channel.link = "www.example.com"
      m.channel.description = "The most recent GeoCaches from www.geocaching.com"
      m.items.do_sort = true

      if(previous_rss != nil)
        previous_rss.channel.items.each do |pi|
          ni = m.items.new_item
          ni.title = pi.title
          ni.link = pi.link
          ni.description = pi.description
          ni.date = pi.date
        end
      end

      caches.each do |c|
        i = m.items.new_item
        i.title = c.id.to_s + ' - ' + c.name
        i.link = 'http://www.geocaching.com/seek/cache_details.aspx?wp=' + c.id.to_s
        i.description = c.id.to_s + ' - ' + c.name
        i.date = Time.now
        end
    end

    File.open(filename, 'w+') { |f| f.puts content.to_s }
  end
end