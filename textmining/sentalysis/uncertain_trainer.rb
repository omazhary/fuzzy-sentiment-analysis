# This class allows you to train the sentiment analyzer using a previously set corpora directory and polarity.

require 'logger'
require 'logger/colors'
require 'json'

module SENTALYSIS

    class UncertainTrainer
    
        attr_accessor :polarity_index_filename
        
        def initialize(index_file_path = Dir.pwd)
            @logger = Logger.new(STDERR)
            @polarity_index_filename = index_file_path
            contents = ""
            if !@polarity_index_filename.end_with? ".json"
                @logger.fatal("Polarities must be stored in a .json file. #{@polarity_index_filename} is not a valid JSON file.")
            end
            # If the file does not exist, we assume best intentions and create it.
            if !File.exists?(@polarity_index_filename)
                @logger.info("File #{@polarity_index_filename} not found. Creating...")
                @polarity_index_file = File.new(polarity_index_filename, "w+")
                @polarity_index_file.write('{"total_positive_corpora": 0,"total_negative_corpora": 0,"entries": []}')
                @polarity_index_file.flush
                @polarity_index_file.close()
                @logger.info("File #{@polarity_index_filename} created successfully.")
            else
                @logger.info("File #{@polarity_index_filename} found.")
            end
            begin
                contents = File.read(@polarity_index_filename)
                @polarity_index = JSON.parse(contents)
            rescue
                @logger.fatal("Unable to parse contents of file: #{@polarity_index_filename}")
            end
            # For simplicity, the hash values will be 2-element arrays, the first representing positivity, and the second representing negativity. These are contained within the "entries" object.
            @entries = @polarity_index["entries"]
            # We also need to keep track of how many corpora we've used as training samples which will help later when calculating the relative frequency.
            @total_positive_corpora = @polarity_index["total_positive_corpora"]
            @total_negative_corpora = @polarity_index["total_negative_corpora"]
        end
        
        def train(corpora_directory = "<empty>", polarity = "positive")
            @entries[2] = Hash.new
            @entries[2]["text"] = "exam"
            @entries[2]["positivity"] = 2
            @entries[2]["negativity"] = 2
            
            puts JSON.generate(@polarity_index)
        end        
    end
    
end