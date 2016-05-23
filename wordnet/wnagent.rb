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
            @logger = Logger.new(STDERR)
            @logger.level = log_level
            @cache_unrecognizable = []
            @cache_processed = Hash.new
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

    end

end
