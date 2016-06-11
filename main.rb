#!/usr/bin/env ruby

# This is the main file that will run this program

require_relative 'textmining/sentalysis/fuzzy/fuzzy_tester'
require_relative 'textmining/sentalysis/fuzzy/fuzzy_trainer'
require_relative 'textmining/sentalysis/fuzzy/fuzzy'
require_relative 'wordnet/wnagent'
require 'logger'

index = SENTALYSIS::PolarityIndex.new("sample_index.json")
wnagent = WORDNET::WordNetAgent.new(Logger::ERROR)

tester = SENTALYSIS::FuzzyTester.new(index, "positive", wnagent, "../poldata/txt_sentoken/pos")
tester.test

#trainer = SENTALYSIS::FuzzyTrainer.new(index, "negative", wnagent, "../poldata/txt_sentoken/neg")
#trainer.train
