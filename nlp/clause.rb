# This class represents clauses in a sentence.

require_relative 'word'

class Clause
    attr_accessor :src_text
    attr_reader :word_list

    def initialize(text = "")
        @src_text = text
        @word_list = []
        self.split_words
    end

    def split_words
        words_raw = @src_text.split
        words_raw.each do |word_raw|
            word_raw = word_raw.strip
            @word_list.push(Word.new(word_raw))
        end
    end
end
