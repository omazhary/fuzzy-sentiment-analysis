# This class represents words.

module NLP

    class Word
        attr_accessor :src_text

        def initialize(text = "")
            if text != nil
                @src_text = text.gsub(/[^0-9A-Za-z]/, '')
            else
                @src_text = text
            end
        end
    end

end
