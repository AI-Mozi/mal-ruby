# TODO: https://github.com/kanaka/mal/blob/master/process/guide.md#optional
require_relative 'reader'
require_relative 'printer'
require_relative 'types'

@repl_env = {
  '+': ->(a, b) { a + b },
  '-': ->(a, b) { a - b },
  '*': ->(a, b) { a * b },
  '/': ->(a, b) { (a / b).to_i }
}

public

def READ(val)
  read_str(val)
end

def EVAL(val, repl_env)
  if val.instance_of?(List)
    return val if val.size.zero?

    new_list = eval_ast(val, repl_env)
    args = new_list[1..-1]
    calc = new_list[0]

    return calc.call(*args) if calc.instance_of?(Proc)
  end

  eval_ast(val, repl_env)
end

def PRINT(val)
  pr_str(val)
end

def rep(input)
  PRINT(EVAL(READ(input), @repl_env))
end

def prompt(*args)
  print(*args)
  gets
end

def eval_ast(ast, struct)
  if ['+', '-', '/', '*'].include?(ast)
    ast = ast.to_sym
    raise 'key not found' if struct[ast].nil?

    struct[ast]
  elsif ast.instance_of?(List)
    List.new(ast.map { |a| EVAL(a, struct) })
  elsif ast.instance_of?(Vector)
    Vector.new(ast.map { |a| EVAL(a, struct) })
  elsif ast.instance_of?(Hash)
    Hash[ast.map { |k, v| [k, EVAL(v, struct)] }]
  else
    ast
  end
end

while input = prompt('user> ')
  puts rep(input)
end
