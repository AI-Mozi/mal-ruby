REGEXP = /[\s,]*(~@|[\[\]{}()'`~^@]|"(?:\\.|[^\\"])*"?|;.*|[^\s\[\]{}('"`,;)]*)/
class Reader
  def initialize(tokens)
    @tokens = tokens
    @position = 0
  end

  def next
    peek
    @position += 1
  end

  def peek
    @tokens[@position]
  end
end

def read_str(string)
  tokens = tokenize(string)
  reader = Reader.new(tokens)
  read_from(reader)
end

def tokenize(string)
  arr = string.scan(REGEXP)
end

def read_from(instance)
  token = instance.peek
  first = token[0]

  if first == "("
    read_list(instance)
  else
    read_atom(token)
  end
end

def read_list(token)
  read_from(token) unless token == ")"
end

def read_atom(token)
  token
end