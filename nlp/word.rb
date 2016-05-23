# This class represents words.

require_relative "../wordnet/wnagent"

module NLP

    class Word
        attr_accessor :src_text
        attr_reader :types

        def initialize(text = "", wn_agent = WORDNET::WordNetAgent.new)
            if text != nil
                @src_text = text.gsub(/[^0-9A-Za-z\-]/, '')
            else
                @src_text = text
            end
            @wn_agent = wn_agent
            @types = @wn_agent.get_word_type(@src_text)
        end
    end

end
