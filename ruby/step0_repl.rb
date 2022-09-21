#TODO: https://github.com/kanaka/mal/blob/master/process/guide.md#optional
def READ(val)
  val
end

def EVAL(val)
  val
end

def PRINT(val)
  print(val)
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
