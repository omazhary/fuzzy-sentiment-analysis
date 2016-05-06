# This class represents paragrphs

require_relative 'sentence'

module NLP

    class Paragraph
        attr_accessor :src_text
        attr_reader :sentence_list

        def initialize(text = "", wn_agent = WORDNET::WordNetAgent.new)
            @src_text = text
            @sentence_list = []
            @wn_agent = wn_agent
            self.split_sentences
        end

        def split_sentences
            sentences_raw = @src_text.split(/[\.\?\!]+/)
            sentences_raw.each do |sentence|
                sentence = sentence.strip
                @sentence_list.push(Sentence.new(sentence, @wn_agent))
            end
        end
    end

end
