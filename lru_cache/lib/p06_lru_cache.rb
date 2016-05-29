require_relative 'p05_hash_map'
require_relative 'p04_linked_list'

class LRUCache
  attr_reader :count
  def initialize(max, prc)
    @map = HashMap.new
    @store = LinkedList.new
    @max = max
    @prc = prc
  end

  def count
    @map.count
  end

  def get(key)
    if @map[key]
      update_link!(@map[key])
      @map[key].val
    else
      calc!(key).val
    end

  end

  def to_s
    "Map: " + @map.to_s + "\n" + "Store: " + @store.to_s
  end

  private

  def calc!(key)
    # suggested helper method; insert an (un-cached) key
    eject! if @map.count >= @max
    new_link = @store.insert(key, @prc.call(key))
    @map[key] = new_link
  end

  def update_link!(link)
    # suggested helper method; move a link to the end of the list
    @store.remove(link.key) if @store.include?(link.key)
    @store.insert(link.key, link.val)
  end

  def eject!
    @map.delete(@store.first.key)
    @store.remove(@store.first.key)
  end
end
