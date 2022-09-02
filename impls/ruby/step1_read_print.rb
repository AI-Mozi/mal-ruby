#TODO: https://github.com/kanaka/mal/blob/master/process/guide.md#optional
require_relative "reader"
require_relative "printer"

def READ(val)
  read_str(val)
end

def EVAL(val)
  val
end

def PRINT(val)
  pr_str(val)
end

def REP(input)
  PRINT(EVAL(READ(input)))
end

def prompt(*args)
  print(*args)
  gets
end

while input = prompt("user> ")
  REP(input)
end