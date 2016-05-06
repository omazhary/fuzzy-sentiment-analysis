# This class represents sentences.

require_relative 'clause'

module NLP

    class Sentence

        attr_accessor :src_text
        attr_reader :clause_list

        def initialize(text = "", wn_agent = WORDNET::WordNetAgent.new)
            @src_text = text
            @clause_list = []
            @wn_agent = wn_agent
            self.split_clauses
        end

        def split_clauses
            clauses_raw = @src_text.split(/[\,\.\?\!]+/)
            clauses_raw.each do |clause_raw|
                clause_raw = clause_raw.strip
                @clause_list.push(Clause.new(clause_raw, @wn_agent))
            end
        end

    end

end
