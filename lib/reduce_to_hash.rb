class Array
  def reduce_to_hash(sym_or_hash = nil, &block)
    raise ArgumentError.new('Either block or symbol(s) required') if block.nil? and sym_or_hash.nil?
    raise ArgumentError.new('Block and symbol(s) cannot be used together') unless block.nil? or sym_or_hash.nil?

    if block
      self.reduce({}) do |memo, item|
        mapped = block.call(item)
        if mapped.nil?
          memo
        else
          memo.merge(mapped)
        end
      end

    elsif sym_or_hash.respond_to? :keys
      raise ArgumentError.new('Mapping hash must have single k=>v pair') if sym_or_hash.keys.length != 1

      key = sym_or_hash.keys.first
      val = sym_or_hash.values.first
      self.reduce({}) { |memo, item| memo.merge({rth_extract(item, key) => rth_extract(item, val)}) }

    else
      self.reduce({}) { |memo, item| memo.merge({rth_extract(item, sym_or_hash) => item}) }

    end
  end

  private

  def rth_extract(item, key)
    if item.is_a? Hash
      item[key]
    else
      item.send(key)
    end
  end
end
