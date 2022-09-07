require_relative "types"

def pr_str(val)
  klass = val.class

  case 
  when klass == List
    "(" + val.join(" ") + ")"
  when klass == Vector
    "[" + val.join(" ") + "]"
  when klass == Hash
    key_val = []
    val.each { |k,v| key_val.push(k).push(v) }
    "{" + key_val.join(" ") + "}"
  when klass == NilClass
    "nil"
  else
    val.to_s
  end
end