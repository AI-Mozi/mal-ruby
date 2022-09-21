class Env
  attr_accessor :data

  def initialize(outer, binds = [], expres = [])
    @outer = outer
    @data = {}
    binds.each_index do |i|
      if binds[i] == :'&'
        set(binds[i + 1], List.new(expres.drop(i)))
        break
      else
        set(binds[i], expres[i])
      end
    end
  end

  def set(key, val)
    @data[key] = val
    val
  end

  def find(key)
    return self if @data.key?(key)

    return @outer.find(key) if @outer

    nil
  end

  def get(key)
    val = find(key)
    raise "'#{key}' not found" unless val

    val.data[key]
  end
end
