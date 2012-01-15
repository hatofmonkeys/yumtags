# Patching String to make this work in earlier versions of ruby :(
class String
 def start_with?(characters)
     self.match(/^#{characters}/) ? true : false
 end
end
