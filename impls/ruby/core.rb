$ns = {
  '+': ->(a, b) { a + b },
  '-': ->(a, b) { a - b },
  '*': ->(a, b) { a * b },
  '/': ->(a, b) { (a / b).to_i },
  'pr-str': ->(*args) { args.map { |x| pr_str(x, true) }.join(' ') },
  'str': ->(*args) { args.map { |x| pr_str(x, false) }.join('') },
  'prn': ->(*args) { puts(args.map { |x| pr_str(x, true) }.join(' ')) },
  'println': ->(*args) { puts(args.map { |x| pr_str(x, false) }.join(' ')) },
  'list': ->(*args) { List.new(args) },
  'list?': ->(a) { a.instance_of? List },
  'empty?': ->(a) { a.empty? },
  'count': ->(a) { a&.count || 0 },
  '=': ->(a, b) { a == b },
  '<': ->(a, b) { a < b },
  '<=': ->(a, b) { a <= b },
  '>': ->(a, b) { a > b },
  '>=': ->(a, b) { a >= b }
}
