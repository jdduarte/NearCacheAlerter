require 'nokogiri'
load 'cache.rb'

class CacheParser
  def self.parse(html)
    #Get the nokogiri object which represents the HTML document
    document = Nokogiri::HTML(html)

    #Get the <tr> elements. Each <tr> represents a GeoCache
    results_table = document.css('.SearchResultsTable, .Table')
    cache_rows = results_table.css('.Data')

    #Create the cache array
    caches = Array.new

    #Parse each cache (<tr>) into a Cache object
    cache_rows.each do |cache|
      name = cache.xpath('td')[4].xpath('a/span').inner_text
      id = cache.xpath('td')[4].xpath('span').inner_text.split('|')[1].strip
      caches.push(Cache.new(id, name))
    end

    #Parse the total number of records
    total_results = document.css('.PageBuilderWidget')[0].xpath('span/b')[0].inner_text.to_i

    return {'caches' => caches, 'total_results' => total_results}
  end
end