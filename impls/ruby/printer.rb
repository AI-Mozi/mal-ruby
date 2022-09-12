require_relative "types"

def pr_str(val)
  case val
  when List
    "(#{val.map { |v| pr_str(v) }.join(' ')})"
  when Vector
    "[#{val.map { |v| pr_str(v) }.join(' ')}]"
  when Hash
    key_val = []
    val.each { |k, v| key_val.push(pr_str(k)).push(pr_str(v)) }
    "{#{key_val.join(' ')}}"
  when NilClass
    'nil'
  else
    val.to_s
  end
end
