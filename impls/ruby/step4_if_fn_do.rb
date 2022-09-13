# TODO: https://github.com/kanaka/mal/blob/master/process/guide.md#optional
require_relative 'reader'
require_relative 'printer'
require_relative 'types'
require_relative 'env'
require_relative 'core'

@env = Env.new(nil)
$ns.each { |k, v| @env.set(k, v) }

def READ(val)
  read_str(val)
end

def EVAL(val, env)
  if val.instance_of?(List)
    return val if val.size.zero?

    case val[0]
    when :def!
      return env.set(val[1], EVAL(val[2], env))
    when :"let*"
      new_env = Env.new(@env)
      val[1].each_slice(2) do |f, s|
        new_env.set(f, EVAL(s, new_env))
      end
      return EVAL(val[2], new_env)
    when :do
      el = eval_ast(val.drop(1), env)
      return el.last
    when :if
      cond = EVAL(val[1], env)

      if cond
        return EVAL(val[2], env)
      else
        return nil if val[3].nil?

        return EVAL(val[3], env)
      end
    when :"fn*"
      return proc do |*args|
        new_env = Env.new(env, val[1], List.new(args))
        EVAL(val[2], new_env)
      end
    else
      new_list = eval_ast(val, env)
      args = new_list[1..]
      calc = new_list[0]

      return calc.call(*args)
    end
  end

  eval_ast(val, env)
end

def PRINT(val)
  pr_str(val)
end

def rep(input)
  PRINT(EVAL(READ(input), @env))
end

def prompt(*args)
  print(*args)
  gets
end

def eval_ast(ast, env)
  case ast
  when Symbol
    env.get(ast)
  when List
    List.new(ast.map { |a| EVAL(a, env) })
  when Vector
    Vector.new(ast.map { |a| EVAL(a, env) })
  when Hash
    Hash[ast.map { |k, v| [k, EVAL(v, env)] }]
  else
    ast
  end
end

while input = prompt('user> ')
  begin
    puts rep(input)
  rescue Exception => e
    puts "error: #{e}"
    puts "\t#{e.backtrace.join("\n\t")}"
  end
end
