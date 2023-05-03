module Bef
  module DotEnv
    def self.get_content_lines
      content = $gtk.read_file(Bef::Constants::PATH_ENV)
      content.lines.map(&:strip) if content
    end

    def self.decode(lines)
      if lines
        hash = {}
        lines.each do |line|
          kv = line.partition('=')
          unless kv[0].index('#') or kv[0].empty?
            key = kv[0]
            value = kv[2].chars.map.with_index do |c,i|
              if (i == 0 || i == kv[2].length - 1) && (c == "\"" || c == "\'")
                ''
              else
                c
              end
            end.join
            hash[key.to_sym] = value
          end
        end
        return hash
      end

      return nil
    end

    def self.get
      lines = get_content_lines()
      decode(lines)
    end
  end
end