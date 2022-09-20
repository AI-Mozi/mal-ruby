class List < Array; end
class Vector < Array; end

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
  attr_accessor :data
  def initialize(data)
    @data = data
  end
end
