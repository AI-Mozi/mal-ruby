require_relative 'env'

$ns = {
  'pr-str': ->(*a) { a.map { |x| pr_str(x, true) }.join(' ') },
  'str': ->(*a) { a.map { |x| pr_str(x, false) }.join('') },
  'prn': ->(*a) { puts(a.map { |x| pr_str(x, true) }.join(' ')) },
  'println': ->(*a) { puts(a.map { |x| pr_str(x, false) }.join(' ')) },
  'read-string': ->(a) { read_str(a) },
  'slurp': ->(a) { return File.read(a) },

  'list': ->(*a) { List.new(a) },
  'list?': ->(a) { a.instance_of? List },
  'empty?': ->(a) { a.empty? },
  'count': ->(a) { a&.count || 0 },
  'vec': ->(a) { Vector.new(a) },

  '+': ->(a, b) { a + b },
  '-': ->(a, b) { a - b },
  '*': ->(a, b) { a * b },
  '/': ->(a, b) { (a / b).to_i },
  '=': ->(a, b) { a == b },
  '<': ->(a, b) { a < b },
  '<=': ->(a, b) { a <= b },
  '>': ->(a, b) { a > b },
  '>=': ->(a, b) { a >= b },

  'atom': ->(a) { Atom.new(a) },
  'atom?': ->(a) { a.instance_of? Atom },
  'deref': ->(a) { a.val },
  'reset!': ->(a, b) { a.val = b },
  'swap!': ->(*a) { a[0].val = a[1].call(*[a[0].val].concat(a[2..])) },

  'cons': ->(a, b) { List.new(b.clone.unshift(a)) },
  'concat': ->(*a) { List.new(a&.reduce(:+) || []) }
}
