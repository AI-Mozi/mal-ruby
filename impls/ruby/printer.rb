require_relative "types"

def pr_str(val)
  klass = val.class

  case 
  when klass == List
    "(" + val.map { |v| pr_str(v) }.join(" ") + ")"
  when klass == Vector
    "[" + val.map { |v| pr_str(v) }.join(" ") + "]"
  when klass == Hash
    key_val = []
    val.each { |k,v| key_val.push(pr_str(k)).push(pr_str(v)) }
    "{" + key_val.join(" ") + "}"
  when klass == NilClass
    "nil"
  else
    val.to_s
  end
end