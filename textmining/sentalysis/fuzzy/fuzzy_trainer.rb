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
            file_counter = 1
            start_time = Time.now
            files = Dir.entries(@training_dir)
            training_state = []
            if File.exists?("state.json")
                @logger.info("File \"state.json\" found.")
                begin
                    contents = File.read("state.json")
                    training_state = JSON.parse(contents)
                rescue
                    @logger.fatal("Unable to parse contents of file: \"state.json\"")
                    abort("Aborting due to error.")
                end
                @logger.info("State updated successfully.")
            end
            begin
                files.delete(".")
                files.delete("..")
                files.each do |filename|
                    full_filename = File.absolute_path("#{training_dir}/#{filename}")              
                    unless training_state.include? full_filename
                        @logger.info("Processing file #{file_counter}/#{files.length} - #{full_filename}...")
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
                                                @polarity_index.update_polarity(word.src_text, @polarity)
                                            end
                                        end
                                    end
                                end
                            end
                            training_state.push(full_filename)
                        end
                    else
                        @logger.info("File #{full_filename} already processed. Skipping...")
                    end
                    file_counter += 1
                end
            rescue
                @logger.fatal("The training process encountered an unrecoverable error. Exiting...")
            ensure
                @logger.info("Saving polarity index...")
                @polarity_index.save_polarity_file
                @logger.info("Saving state...")
                begin
                    state_file = File.new("state.json", "w+")
                    state_file.write(JSON.generate(training_state))
                    state_file.flush
                    state_file.close()
                    @logger.info("Training state saved successfully.")
                rescue
                    @logger.fatal("Training state encountered an error while saving.")
                ensure
                    @logger.info("Dumping training state...")
                    puts JSON.generate(training_state)
                    abort("Exiting...")
                end
            end
            @logger.info("Saving polarity index to disk...")
            @polarity_index.save_polarity_file
            end_time = Time.now
            @logger.info("Training process ended after #{(end_time - start_time) / 60} minutes")
        end        
    end
    
end