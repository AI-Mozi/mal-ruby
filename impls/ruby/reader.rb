REGEXP = /[\s,]*(~@|[\[\]{}()'`~^@]|"(?:\\.|[^\\"])*"?|;.*|[^\s\[\]{}('"`,;)]*)/
class Reader
  def initialize(tokens)
    @tokens = tokens
    @position = 0
  end

  def next
    @position += 1
    @tokens[@position - 1]
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

def read_list(reader)
  token = reader.next
  puts "t: #{reader.peek}"
  while reader.peek != ")"
    read_form(reader)
  end
end

def read_atom(reader)
  token = reader.next
  case token
    when /^-?[0-9]+$/ then       token.to_i
    when /^-?[0-9][0-9.]*$/ then token.to_
    when /^"(?:\\.|[^\\"])*"$/ then parse_str(token)
    when /^"/ then               raise "expected '\"', got EOF"
    when /^:/ then               "\u029e" + token[1..-1]
    when "nil" then              nil
    when "true" then             true
    when "false" then            false
    else                         token.to_sym
  end
end