# This class represents sentences.

require_relative 'clause'

module NLP

    class Sentence

        attr_accessor :src_text
        attr_reader :clause_list

        def initialize(text = "")
            @src_text = text
            @clause_list = []
            self.split_clauses
        end

        def split_clauses
            clauses_raw = @src_text.split(/[\,\.\?\!]+/)
            clauses_raw.each do |clause_raw|
                clause_raw = clause_raw.strip
                @clause_list.push(Clause.new(clause_raw))
            end
        end

    end

end
