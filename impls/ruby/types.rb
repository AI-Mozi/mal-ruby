class List < Array
  attr_accessor :meta
  def seq
    self
  end

  def conj(params)
    params.each{ unshift(_1)}
    self
  end
end

class Vector < Array
  attr_accessor :meta
  def seq
    List.new(self)
  end

  def conj(params)
    self.push(*params)
    self
  end
end

class String
  def seq
    List.new(split(''))
  end
end

class Proc
  attr_accessor :meta
end

class Hash
  attr_accessor :meta
end

class Function < Proc
  attr_accessor :ast, :params, :env, :fn, :is_macro

  def initialize(ast, params, env, is_macro = false, &blk)
    @ast = ast
    @params = params
    @env = env
    @is_macro = is_macro
  end
end

class Atom
  attr_accessor :val

  def initialize(val)
    @val = val
  end
end

class MalException < StandardError
  attr_accessor :data, :meta

  def initialize(data)
    @data = data
  end
end
