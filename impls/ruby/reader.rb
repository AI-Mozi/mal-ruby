require_relative "types"

REGEX = /[\s,]*(~@|[\[\]{}()'`~^@]|"(?:\\.|[^\\"])*"?|;.*|[^\s\[\]{}('"`,;)]*)/
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
  return nil if tokens.size.zero?

  reader = Reader.new(tokens)
  read_form(reader)
end

def tokenize(string)
  string.scan(REGEX).map { |e| e[0] }.select { |t| t != '' && t[0..0] != ';' }
end

def parse_str(token)
  return token[1..-2].gsub(/\\./, {"\\\\" => "\\", "\\n" => "\n", "\\\"" => '"'})
end

def read_form(reader)
  token = reader.peek
  case token
  when '@'
    reader.next
    List.new(['deref', read_form(reader)])
  when '^'
    reader.next
    m = read_form(reader)
    List.new(['with-meta', read_form(reader), m])
  when '('
    read_list(reader, List, '(', ')')
  when '{'
    Hash[read_list(reader, List, '{', '}').each_slice(2).to_a]
  when '['
    read_list(reader, Vector, '[', ']')
  when ')', ']', '}'
    raise "unexpeted closing bracker [)', ']' or '}']"
  else
    read_atom(reader)
  end
end

def read_list(reader, klass, first, last)
  result = klass.new
  token = reader.next

  raise "Expected: #{first} got: #{token}" if token != first
  while (token = reader.peek) != last
    raise "expected ')', got EOF" unless token

    result.push(read_form(reader))
  end

  reader.next
  result
end

def read_atom(reader)
  token = reader.next
  case token
  when /^-?[0-9]+$/ then       token.to_i
  when /^-?[0-9][0-9.]*$/ then token.to_
  when /^"(?:\\.|[^\\"])*"$/ then parse_str(token)
  when /^"/ then               raise "expected '\"', got EOF"
  when /^:/ then               "':#{token[1..]}'"
  when 'nil' then              nil
  when 'true' then             true
  when 'false' then            false
  else                         token.to_sym
  end
end
