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
  loop do
    return eval_ast(val, env) unless val.instance_of?(List)
    return val if val.size.zero?

    case val[0]
    when :def!
      return env.set(val[1], EVAL(val[2], env))
    when :"let*"
      env = Env.new(@env)
      val = val[2]
    when :do
      val = eval_ast(List.new(val[1..]), env)[-1]
    when :if
      EVAL(val[1], env) ? val = val[2] : val = val[3]
    when :"fn*"
      return Function.new(val[2], val[1], env) do |*args|
        new_env = Env.new(env, val[1], List.new(args))
        EVAL(val[2], new_env)
      end
    else
      ev = eval_ast(val, env)
      f = ev[0]
      if f.instance_of? Function
        val = f.ast
        env = Env.new(env, f.params, ev.drop(1))
      else
        return f.call(*ev.drop(1))
      end
    end
  end
end

def PRINT(val)
  pr_str(val)
end

def rep(input)
  PRINT(EVAL(READ(input), @env))
end

def not_rep(input)
  EVAL(READ(input), @env)
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

rep('(def! not (fn* (a) (if a false true)))')

while input = prompt('user> ')
  begin
    puts rep(input)
  rescue Exception => e
    puts "error: #{e}"
    puts "\t#{e.backtrace.join("\n\t")}"
  end
end
