module Bef
  module Net
    def self.escape(url)
      escaped_str = ""
      url.each_byte do |byte|
        if byte == 32
          escaped_str += "+"
        elsif (byte < 48 || byte > 57) && (byte < 65 || byte > 90) && (byte < 97 || byte > 122)
          escaped_str += "%%%02X" % byte
        else
          escaped_str += byte.chr
        end
      end
      return escaped_str
    end
  end
end