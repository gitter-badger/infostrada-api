class String
  # This is a version of the method stolen from railties and it converts 'Text-LikeThis' to
  # 'text_like_this'.
  def snake_case
    result = self.gsub(/::/, '/')
    result.gsub!(/([A-Z]+)([A-Z][a-z])/,'\1_\2')
    result.gsub!(/([a-z\d])([A-Z])/,'\1_\2')
    result.tr!("-", "_")
    result.downcase
  end
end