# This class consumes a text, and returns clauses out of that text. Clauses are
# assumed to be any sentence fragment ending with any of the following characters:
# full-stops, commas, exclamation marks, question marks, and colons.

class ClauseExtractor

    attr_accessor :src_text
    attr_reader :clause_list

    def initialize(text = "")
        @src_text = text
    end

    def split_on_space
        @clause_list = @src_text.split(" ")
    end

end
