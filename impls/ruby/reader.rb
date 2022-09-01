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
  read_form(reader)
end

def tokenize(string)
  string.scan(REGEXP).map{|e| e[0]}.select{ |t| t != "" && t[0..0] != ";" }
end

def read_form(reader)
  token = reader.peek
  case token[0]
  when "("
    read_list(reader)
  else
    read_atom(reader)
  end
end

def read_list(obj)
end

def read_atom(reader)
  tokens = reader.peek
end