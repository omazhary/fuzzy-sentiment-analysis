# This class allows you to train the fuzzy sentiment analyzer using a previously set corpora directory and polarity.

require 'logger'
require 'logger/colors'
require_relative 'polarity_index'
require_relative '../../../nlp/text'
require_relative '../../../wordnet/wnagent'

module SENTALYSIS

    class FuzzyTrainer
    
        attr_accessor :polarity
        attr_accessor :training_dir
        attr_accessor :polarity_index
        attr_reader :wordnet_agent
        
        def initialize(index = SENTALYSIS::PolarityIndex.new('sample_index.json'), current_polarity = 'positive', wn_agent = WORDNET::WordNetAgent.new, training_dir)
            @logger = Logger.new(STDERR)
            if training_dir == nil || training_dir.empty? || !File.directory?(training_dir) || Dir[training_dir + "/*"].empty?
                @logger.fatal("No valid training directory provided. The training process cannot proceed.")
                abort("Aborting due to error.")
            else
               @training_dir = training_dir 
            end
            @polarity_index = index
            @polarity = current_polarity
            @wordnet_agent = wn_agent
        end
        
        def train
            @logger.info("Starting training process...")
            start_time = Time.now
            files = Dir.entries(@training_dir)
            files.each do |filename|
                full_filename = File.absolute_path("#{training_dir}/#{filename}")
                @logger.info("Processing file #{full_filename}...")
                if File.exists?(full_filename) && File.file?(full_filename) && File.readable?(full_filename)
                    # Open the file and read its contents:
                    file = File.new(full_filename, "r")
                    src_text = file.read
                    file.close
                    # Parse the file using the NLP elements:
                    text = NLP::Text.new(src_text, @wordnet_agent)
                    text.paragraph_list.each do |paragraph|
                        paragraph.sentence_list.each do |sentence|
                            sentence.clause_list.each do |clause|
                                clause.word_list.each do |word|
                                    # Filter out adjectives:
                                    if word.types.include? 'adjective'
                                        # Update adjective polarity:
                                        @polarity_index.update_polarity(word, @polarity)
                                    end
                                end
                            end
                        end
                    end
                end
            end
            @logger.info("Saving polarity index to disk...")
            @polarity_index.save_polarity_file
            end_time = Time.now
            @logger.info("Training process ended after #{(end_time - start_time) / 60} minutes")
        end        
    end
    
end