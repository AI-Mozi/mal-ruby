class List < Array; end
class Vector < Array; end

class Function < Proc
  attr_accessor :ast, :params, :env, :fn

  def initialize(ast, params, env, &blk)
    @ast = ast
    @params = params
    @env = env
  end
end

class Atom
  attr_accessor :val

  def initialize(val)
    @val = val
  end
end
