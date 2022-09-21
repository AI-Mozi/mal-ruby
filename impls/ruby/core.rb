require_relative 'env'
require "readline"

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
  'concat': ->(*a) { List.new(a&.reduce(:+) || []) },

  'nth': ->(a, b) { raise "index out of range" if b >= a.size; a[b] },
  'first': ->(a) { a.nil? ? nil : a[0] },
  'rest': ->(a) { List.new(a.nil? || a.empty? ? [] : a[1..]) },
  'nil?': ->(a) { a.nil? },
  'true?': ->(a) { a == true },
  'false?': ->(a) { a == false },
  'symbol?': ->(a) { a.instance_of? Symbol },
  'symbol': ->(a) { a.to_sym },
  'keyword': ->(a) { a[0] == ':' ? a : ":#{a}" },
  'keyword?': ->(a) { print a.class },
  'vector': ->(*a) { Vector.new([*a]) },
  'vector?': ->(a) { a.instance_of? Vector },
  'sequential?': ->(a) { a.instance_of?(List) || a.instance_of?(Vector) },
  'hash-map': ->(*a) { Hash[*a.each_slice(2) { |k, v| [k, v] }] }, # cos zjebane
  'map?': ->(a) { a.instance_of? Hash },
  'keys': ->(a) { List.new(a.keys) },
  'vals': ->(a) { List.new(a.values) },
  'contains?': ->(a, b) { a.key?(b) },
  'get': ->(a, b) { a.nil? ? nil : a[b] },
  'dissoc': ->(a, *b) { a.reject { |k, _| b.include?(k) } },
  'assoc': ->(a, *b) { a.merge(Hash[b.each_slice(2).to_a]) },

  'throw': ->(a) { raise MalException.new(a), a },
  'apply': ->(*a) { a[0].call(*a[1..-2].concat(a[-1])) },
  'map': ->(a, b) { List.new(b.map { a.call(_1) }) },

  'readline': ->(a) { Readline.readline(a, true) },
  'string?': ->(a) { a.is_a?(String) && a[0] != ':' },
  'number?': ->(a) { a.is_a? Numeric },
  'macro?': ->(a) { (a.is_a? Function) && a.is_macro },
  'fn?': ->(a) { (a.is_a? Proc) && (!(a.is_a? Function) || !a.is_macro) },
  'seq': ->(a) { a.nil? ? nil : a.empty? ? nil : a.seq },
  'conj': ->(*a) { a[0].clone.conj(a[1..]) },
  'time-ms': -> { (Time.now.to_f * 1000).to_i },
  'meta': ->(a) { a.meta },
  'with-meta': ->(a, b) { t = a.clone; t.meta = b; t }
}
