require 'mechanize'
load 'cache_parser.rb'

class CacheSearcher

  def self.search_by_coordinates(longitude, latitude, radius, options)
    #Build the request URL
    url = @@urls['coordinates']
    url += '?lat=' + latitude.to_s + '&lng=' + longitude.to_s + '&dist=' + radius.to_s

    #Get the HTML document
    agent = Mechanize.new
    page = agent.get(url)

    #Parse the HTML document
    result = CacheParser.parse(page.body)
    caches = result['caches']
    total_results = result['total_results']

    if(options != nil && options['previous_total_results'] != nil && options['previous_total_results'] != total_results)
      current_page = 2
      pages = total_results / 20 + 1

      while(current_page <= pages)
        form = page.form("aspnetForm")
        form.add_field!('__EVENTARGUMENT', '')
        form.add_field!('__EVENTTARGET', 'ctl00$ContentBody$pgrTop$ctl08')
        page = agent.submit(form)

        result = CacheParser.parse(page.body)
        caches.concat(result['caches'])

        current_page += 1
        sleep(1)
      end
    end

    return caches
  end

  private

  @@urls = {'coordinates' => 'http://www.geocaching.com/seek/nearest.aspx'}
end