# This class provides an interface to communicate with wordNet online.

module WORDNET

require 'net/http'
require 'uri'
require 'nokogiri'

    class WordNetAgent

        attr_reader :response

        def initialize()
            @@wn_word_uri = "http://wordnetweb.princeton.edu/perl/webwn?s="
            @response = ""
        end

        # Sends word queries to wordnet's web interface.
        def send_query(query = "")
            query_full = @@wn_word_uri + query
            query_uri = URI.parse(query_full)
            query_response = nil
        #    begin
                query_http = Net::HTTP.new(query_uri.host, query_uri.port)
                query_request = Net::HTTP::Get.new(query_uri.request_uri)
                query_response = query_http.request(query_request)
                puts query_response.inspect
        #    rescue
        #        puts "An exception occured with the HTTP request \"#{@query_uri}\"\n which returned a code #{query_response.code}"
        #    end
            #if query_response.code != 200
        #        puts "An error occured with the HTTP request \"#{@query_uri}\"\n which returned a code #{query_response.code}"
            #end
            #@response = Nokogiri::XML(response.body)
        end

        # Gets the type(s) of a word by querying wordnet
        def get_word_type(word = "")
            word_type = []
            send_query(word)
            type = @response.xpath('//h3').content
            puts type.inspect
        end

    end

end
