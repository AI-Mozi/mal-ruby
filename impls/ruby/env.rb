class Env
  attr_accessor :data

  def initialize(outer, binds = [], expres = [])
    @outer = outer
    @data = {}
    binds.each_with_index do |e, i|
      set(e, expres[i])
    end
  end

  def set(key, val)
    @data[key] = val
    val
  end

  def find(key)
    if @data[key]
      return self
    elsif @outer
      return @outer.find(key)
    end

    nil
  end

  def get(key)
    val = find(key)
    raise "'#{key}' not found" unless val

    val.data[key]
  end
end
