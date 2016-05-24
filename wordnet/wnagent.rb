# This class provides an interface to communicate with wordNet online.

module WORDNET

require 'net/http'
require 'uri'
require 'nokogiri'
require 'logger'
require 'logger/colors'

    class WordNetAgent

        attr_reader :response

        def initialize(log_level)
            @@wn_word_uri = "http://wordnetweb.princeton.edu/perl/webwn?s="
            @response = ""
            @query_counter = 0
            @logger = Logger.new(STDERR)
            @logger.level = log_level
            @cache_unrecognizable = []
            @cache_processed = Hash.new
            if File.exists?("processed.json")
                @logger.info("File \"processed.json\" found.")
                begin
                    contents = File.read("processed.json")
                    @cache_processed = JSON.parse(contents)
                rescue
                    @logger.fatal("Unable to parse contents of file: \"processed.json\"")
                    abort("Aborting due to error.")
                end
                @logger.info("Cache updated successfully.")
            end
            if File.exists?("unrecog.json")
                @logger.info("File \"unrecog.json\" found.")
                begin
                    contents = File.read("unrecog.json")
                    @cache_unrecognizable = JSON.parse(contents)
                rescue
                    @logger.fatal("Unable to parse contents of file: \"unrecog.json\"")
                    abort("Aborting due to error.")
                end
                @logger.info("Cache updated successfully.")
            end
        end

        # Sends word queries to wordnet's web interface.
        def send_query(query = "")
            query_full = @@wn_word_uri + query + "&o0=&o1="
            query_uri = URI.parse(query_full)
            query_response = nil
            begin
                query_http = Net::HTTP.new(query_uri.host, query_uri.port)
                query_request = Net::HTTP::Get.new(query_uri.request_uri)
                query_response = query_http.request(query_request)
            rescue
                @logger.error("An exception occured with the HTTP request \"#{@query_full}\"")
            end
            if query_response.code != "200"
                @logger.error("An error occured with the HTTP request \"#{@query_full}\"\n which returned a code #{query_response.code}")
            else
                @response = Nokogiri::XML(query_response.body)
                @response.errors.each do |error|
                    @logger.warn(error)
                end
            end
            @query_counter += 1
            if (@query_counter % 10) == 0
                self.save_cache
            end
        end

        # Gets the type(s) of a word by querying wordnet
        def get_word_type(word = "")
            word_type = []
            # Check cache first:
            if @cache_unrecognizable.include? word
                return []
            end
            if @cache_processed.key? word
                word_type = @cache_processed[word]
                return word_type
            end
            # If it's not in the cache, query WordNet:
            send_query(word)
            types = @response.css("h3")
            types.each do |type|
                if type.text == "Your search did not return any results."
                    @logger.error("WordNet was unable to recognize the word #{word}")
                    @cache_unrecognizable.push(word)
                else
                    word_type.push(type.text.downcase)
                end
            end
            if types.length == 0
                @logger.error("Unable to retrieve type for word #{word}.")
                @cache_unrecognizable.push(word)
            elsif types.length > 1
                @logger.info("Word #{word} has more than one type depending on the context.")
                @cache_processed[word] = word_type
            end
            return word_type
        end
        
        def save_cache
            begin
                unrecognizable_file = File.new("unrecog.json", "w+")
                processed_file = File.new("processed.json", "w+")
                unrecognizable_file.write(JSON.generate(@cache_unrecognizable))
                unrecognizable_file.flush
                unrecognizable_file.close()
                @logger.info("\"Unrecognizable\" cache saved successfully.")
            rescue
                @logger.fatal("\"Unrecognizable\" cache encountered an error while saving.")
                abort("Aborting due to error.")
            end
            begin
                processed_file = File.new("processed.json", "w+")
                processed_file.write(JSON.generate(@cache_processed))
                processed_file.flush
                processed_file.close()
                @logger.info("\"Processed\" cache saved successfully.")
            rescue
                @logger.fatal("\"Processed\" cache encountered an error while saving.")
                abort("Aborting due to error.")
            end
        end

    end

end
