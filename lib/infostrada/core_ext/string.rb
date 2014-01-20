class String
  def snake_case
    result = self.gsub(/::/, '/')
    result.gsub!(/([A-Z]+)([A-Z][a-z])/,'\1_\2')
    result.gsub!(/([a-z\d])([A-Z])/,'\1_\2')
    result.tr!("-", "_")
    result.downcase
  end
end