#TODO: https://github.com/kanaka/mal/blob/master/process/guide.md#optional
require_relative "./reader"
def READ(val)
  read_str(val)
end

def EVAL(val)
  val
end

def PRINT(val)
  puts(val)
end

def rep(input)
  PRINT(EVAL(READ(input)))
end

def prompt(*args)
  print(*args)
  gets
end

while input = prompt("user> ")
    rep(input)
end