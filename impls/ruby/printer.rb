require_relative "types"

def pr_str(val, print_readably = true)
  j = print_readably
  case val
  when List
    "(#{val.map { |v| pr_str(v, j) }.join(' ')})"
  when Vector
    "[#{val.map { |v| pr_str(v, j) }.join(' ')}]"
  when Hash
    key_val = []
    val.each { |k, v| key_val.push(pr_str(k, j)).push(pr_str(v, j)) }
    "{#{key_val.join(' ')}}"
  when Proc
    '#<function>'
  when NilClass
    'nil'
  when String
    if val[0] == ':'
      ":#{val[1..]}"
    elsif j
      val.inspect
    else
      val
    end
  when Atom
    "(atom #{pr_str(val.val, true)})"
  else
    val.to_s
  end
end
