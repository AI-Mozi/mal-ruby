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
    @token[@position]
  end
end

def read_str
  tokens = tokenize
  @reader = Reader.new(tokens)
end

def tokenize(string)
  arr = string.scan(REGEXP)
end

def read_from
  token = @reader.peek
  first = token[0]

  if first == "("
    read_list(token)
  else
    read_atom(token)
  end
end

def read_list(token)
  token.each do |w|
    read_from unless w == ")"
  end
end

def read_atom(token)

end