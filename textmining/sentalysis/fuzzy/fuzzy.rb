# This class is responsible for classifying texts according to polarity.

module SENTALYSIS
    
    class FuzzyClassifier
        
        def initialize(index = SENTALYSIS::PolarityIndex.new('sample_index.json'), wn_agent = WORDNET::WordNetAgent.new)
            @polarity_index = index
            @wnagent = wn_agent
        end
        
        def classify(text)
            average_positivity = 0.0
            average_negativity = 0.0
            total_adjectives = 0.0
            recommended_class = ""
            
            text.paragraph_list.each do |paragraph|
                paragraph.sentence_list.each do |sentence|
                    sentence.clause_list.each do |clause|
                        clause.word_list.each do |word|
                            # Filter out adjectives:
                            if word.types.include? 'adjective'
                                # Get adjective polarity:
                                result = @polarity_index.get_polarity(word.src_text)
                                if result[0] != 0.0 && result[1] != 0.0
                                    average_positivity += result[0]
                                    average_negativity += result[1]
                                    total_adjectives += 1
                                end
                            end
                        end
                    end
                end
            end
            
            average_positivity = average_positivity / total_adjectives
            average_negativity = average_negativity / total_adjectives
            if average_negativity > average_positivity
                recommended_class = "negative"
            elsif average_positivity > average_negativity
                recommended_class = "positive"
            else
                recommended_class = "neutral"
            end
            return {"average_positivity" => average_positivity, "average_negativity" => average_negativity, "recommended_class" => recommended_class}
        end
        
    end
    
end