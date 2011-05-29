load 'cache_searcher.rb'
load 'cache_record.rb'
load 'cache_publisher.rb'

#Get the GeoCaches from the record
cache_record = CacheRecord.new('caches.nca')
cache_record.load()

#Search for GeoCaches
caches = CacheSearcher.search_by_coordinates(-9.1259531, 38.7541235, 20, {'previous_total_results' => cache_record.get_total_results()})

#Check for new caches
new_caches = cache_record.compare(caches)

if(new_caches.size > 0)
  #Print the new GeoCaches
  new_caches.each { |new_cache| puts(new_cache.id + ' - ' +  new_cache.name)}
  #Update the CacheRecord
  cache_record.set(caches)
  cache_record.save()
  #Create the RSS feed
  CachePublisher.publish_rss(new_caches, 'feed.xml')
end
