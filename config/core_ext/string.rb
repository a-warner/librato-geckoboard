class String
  def camelize
    split('/').map(&:upcase_first).join('::').split('_').map(&:upcase_first).join
  end

  def upcase_first
    sub(/^(.)/) { $1.upcase }
  end
end
