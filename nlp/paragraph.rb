# This class represents paragrphs

require_relative 'sentence'

class Paragraph
    attr_accessor :src_text
    attr_reader :sentence_list

    def initialize(text = "")
        @src_text = text
        @sentence_list = []
        self.split_sentences
    end

    def split_sentences
        sentences_raw = @src_text.split(/[\.\?\!]+/)
        sentences_raw.each do |sentence|
            sentence = sentence.strip
            @sentence_list.push(Sentence.new(sentence))
        end
    end
end
