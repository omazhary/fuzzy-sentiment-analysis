# This class allows you to test the fuzzy sentiment analyzer using a previously set corpora directory and polarity.

require 'logger'
require 'logger/colors'
require 'json'
require_relative 'polarity_index'
require_relative 'fuzzy'
require_relative '../../../nlp/text'
require_relative '../../../wordnet/wnagent'

module SENTALYSIS

    class FuzzyTester
    
        attr_accessor :polarity
        attr_accessor :testing_dir
        attr_accessor :polarity_index
        attr_reader :wordnet_agent
        
        def initialize(index = SENTALYSIS::PolarityIndex.new('sample_index.json'), current_polarity = 'positive', wn_agent = WORDNET::WordNetAgent.new, testing_dir)
            @logger = Logger.new(STDERR)
            if testing_dir == nil || testing_dir.empty? || !File.directory?(testing_dir) || Dir[testing_dir + "/*"].empty?
                @logger.fatal("No valid testing directory provided. The testing process cannot proceed.")
                abort("Aborting due to error.")
            else
               @testing_dir = testing_dir 
            end
            @polarity_index = index
            @polarity = current_polarity
            @wordnet_agent = wn_agent
            @classifier = SENTALYSIS::FuzzyClassifier.new(@polarity_index, @wordnet_agent)
        end
        
        def test
            @logger.info("Starting testing process...")
            file_counter = 1
            correct_classfications = 0.0
            total_classifications = 0.0
            start_time = Time.now
            files = Dir.entries(@testing_dir)
            testing_state = []
            testing_result = Hash.new
            if File.exists?("testing-state.json")
                @logger.info("File \"testing-state.json\" found.")
                begin
                    contents = File.read("testing-state.json")
                    testing _state = JSON.parse(contents)
                rescue
                    @logger.fatal("Unable to parse contents of file: \"testing-state.json\"")
                    abort("Aborting due to error.")
                end
                @logger.info("State updated successfully.")
            end
            begin
                files.delete(".")
                files.delete("..")
                files.each do |filename|
                    full_filename = File.absolute_path("#{testing_dir}/#{filename}")              
                    unless testing_state.include? full_filename
                        @logger.info("Processing file #{file_counter}/#{files.length} - #{full_filename}...")
                        if File.exists?(full_filename) && File.file?(full_filename) && File.readable?(full_filename)
                            # Open the file and read its contents:
                            file = File.new(full_filename, "r")
                            src_text = file.read
                            file.close
                            # Parse the file using the NLP elements:
                            text = NLP::Text.new(src_text, @wordnet_agent)
                            # Classify the text:
                            testing_result[filename] = @classifier.classify(text)
                            if @polarity == testing_result[filename]["recommended_class"]
                                testing_result[filename]["test_result"] = "passed"
                                correct_classfications += 1.0
                            else
                                testing_result[filename]["test_result"] = "failed"
                            end
                            total_classifications += 1
                            testing_state.push(full_filename)
                        end
                    else
                        @logger.info("File #{full_filename} already processed. Skipping...")
                    end
                    file_counter += 1
                end
            rescue
                @logger.fatal("The testing process encountered an unrecoverable error. Exiting...")
            ensure
                @logger.info("Saving testing state...")
                begin
                    state_file = File.new("testing-state.json", "w+")
                    state_file.write(JSON.generate(testing_state))
                    state_file.flush
                    state_file.close()
                    @logger.info("testing state saved successfully.")
                rescue
                    @logger.fatal("testing state encountered an error while saving.")
                ensure
                    @logger.info("Dumping testing state...")
                    puts JSON.generate(testing_state)
                end
                end_time = Time.now
                @logger.info("testing process ended after #{(end_time - start_time) / 60} minutes")
                precision = correct_classfications / total_classifications
                puts "Test Statistics:"
                puts "Files processed: #{total_classifications}"
                puts "Correct classifications: #{correct_classfications}"
                puts "Incorrect classifications: #{total_classifications - correct_classfications}"
                puts "Precision: #{(correct_classfications / total_classifications) * 100}%"
            end
        end        
    end
    
end