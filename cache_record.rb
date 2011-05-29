load 'cache.rb'

class CacheRecord
  attr_accessor :filename, :caches

  def initialize(filename)
    @filename = filename
  end

  def set(caches)
    @caches = caches
  end

  def add(caches)
    @caches.push(caches)
  end

  def get_total_results
    @caches.size
  end

  def compare(caches)
    if(@caches == nil || @caches.size == 0)
      return caches
    end

    caches - @caches
  end

  def load()
    if (!File.exists?(@filename))
      @caches = Array.new
      return
    end

    file_content = File.open(@filename, 'r').read()
    caches_info = file_content.split('!cp#')

    @caches = Array.new

    caches_info.each do |cache_info|
      cache_info = cache_info.split(',')
      @caches.push(Cache.new(cache_info[0], cache_info[1]))
    end
  end

  def save()
    #File.delete(@filename) if (File.exists?(@filename))

    new_record = File.new(@filename, 'w+')

    @caches.each { |cache| new_record.write(cache.id.to_s + ',' + cache.name + '!cp#') }

    new_record.close()
  end

end