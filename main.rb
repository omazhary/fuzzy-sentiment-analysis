# This is the main file that will run this program

require_relative 'manipulation_syntax/clause_extractor'

clause_extractor = ClauseExtractor.new("This is the first sentence. And this is the second one.")

puts clause_extractor.clause_list
