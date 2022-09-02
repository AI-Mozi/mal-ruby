def pr_str(val)
  case val.class
  when Array
    val.each { pr_str(_1) }
  else
    val.to_s
  end
end