# This class allows you to train the fuzzy sentiment analyzer using a previously set corpora directory and polarity.

require 'logger'
require 'logger/colors'
require_relative 'polarity_index'

module SENTALYSIS

    class FuzzyTrainer
    
        attr_accessor :polarity
        attr_accessor :corpora_dir
        attr_accessor :polarity_index
        
        def initialize(index = SENTALYSIS::PolarityIndex.new('sample_index.json'), current_polarity = 'positive', training_dir)
            @logger = Logger.new(STDERR)
            if training_dir == nil
                @logger.fatal("No training directory provided. The training process cannot proceed.")
                abort("Aborting due to error.")
            else
               @training_dir = training_dir 
            end
            @polarity_index = index
            @polarity = current_polarity
        end
        
        def train(corpora_directory = "<empty>", polarity = "positive")
            @polarity_index.update_polarity("test", "negative")
            @polarity_index.save_polarity_file
        end        
    end
    
end