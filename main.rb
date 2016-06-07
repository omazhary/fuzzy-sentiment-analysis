#!/usr/bin/env ruby

# This is the main file that will run this program

require_relative 'textmining/sentalysis/fuzzy/fuzzy_trainer'
require_relative 'textmining/sentalysis/fuzzy/fuzzy'
require_relative 'wordnet/wnagent'
require 'logger'

index = SENTALYSIS::PolarityIndex.new("sample_index.json")
wnagent = WORDNET::WordNetAgent.new(Logger::INFO)

classifier = SENTALYSIS::FuzzyClassifier.new(index, wnagent)

test_text = NLP::Text.new("This tastes awful. But that is amazing!", wnagent)

puts classifier.classify(test_text)

#trainer = SENTALYSIS::FuzzyTrainer.new(index, "negative", wnagent, "../poldata/txt_sentoken/neg")
#trainer.train
