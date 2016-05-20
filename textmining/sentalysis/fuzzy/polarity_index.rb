require 'logger'
require 'logger/colors'
require 'json'

module SENTALYSIS

    class PolarityIndex
        
        attr_accessor :polarity_index_filename
        
        def initialize(index_file_path = Dir.pwd)
            @logger = Logger.new(STDERR)
            @polarity_index_filename = index_file_path
            contents = ""
            if !@polarity_index_filename.end_with? ".json"
                @logger.fatal("Polarities must be stored in a .json file. #{@polarity_index_filename} is not a valid JSON file.")
                abort("Aborting due to error.")
            end
            # If the file does not exist, we assume best intentions and create it.
            if !File.exists?(@polarity_index_filename)
                @logger.info("File #{@polarity_index_filename} not found. Creating...")
                @polarity_index_file = File.new(polarity_index_filename, "w+")
                @polarity_index_file.write('{"total_positive_corpora": 0,"total_negative_corpora": 0,"entries": {}}')
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
                abort("Aborting due to error.")
            end
            # For simplicity, the hash values will be 5-element arrays, the first representing positivity, the second representing negativity, the third representing the total times a text was positive, the fourth representing the total times a text was negative, and the fifth representing how many times a text was encountered in general. These are contained within the "entries" object.
            @entries = @polarity_index["entries"]
            if @entries == nil
                @entries = Hash.new
            end
            # We also need to keep track of how many corpora we've used as training samples which will help later when calculating the relative frequency.
            @total_positive_corpora = @polarity_index["total_positive_corpora"]
            @total_negative_corpora = @polarity_index["total_negative_corpora"]
        end
        
        # Updates the polarity of a given text by increasing and recalculating its number of encounters. If a text is not found, it is added.
        def update_polarity(text, polarity_inclination)
            if text == nil
                @logger.fatal("A text must be given, for which the polarity will be updated.")
                abort("Aborting due to error.")
            end
            if polarity_inclination != "positive" && polarity_inclination != "negative"
                @logger.fatal("Unrecognizable polarity inclinations supplied.")
                abort("Aborting due to error.")
            end
            if !@entries.has_key? text
                @entries[text] = Hash.new
                @entries[text]["total_positive_encounters"] = 0.0
                @entries[text]["total_negative_encounters"] = 0.0
                @entries[text]["total_encounters"] = 0.0
                @entries[text]["positivity"] = 0.0
                @entries[text]["negativity"] = 0.0
            end
            @entries[text]["total_#{polarity_inclination}_encounters"] += 1
            @entries[text]["total_encounters"] += 1
            @entries[text]["positivity"] = @entries[text]["total_positive_encounters"] / @entries[text]["total_encounters"] 
            @entries[text]["negativity"] = @entries[text]["total_negative_encounters"] / @entries[text]["total_encounters"]
        end
        
        def save_polarity_file
            begin
                @polarity_index_file = File.new(polarity_index_filename, "w+")
                @polarity_index_file.write(JSON.generate(@polarity_index))
                @polarity_index_file.flush
                @polarity_index_file.close()
                @logger.info("File #{@polarity_index_filename} saved successfully.")
            rescue
                @logger.fatal("File #{@polarity_index_filename} encountered an error while saving.")
                abort("Aborting due to error.")
            end
        end
        
    end
    
end