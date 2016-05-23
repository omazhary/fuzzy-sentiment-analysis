# This is the main file that will run this program

require_relative 'textmining/sentalysis/fuzzy/fuzzy_trainer'
require_relative 'wordnet/wnagent'
require 'logger'

index = SENTALYSIS::PolarityIndex.new("sample_index.json")

trainer = SENTALYSIS::FuzzyTrainer.new(index, "positive", WORDNET::WordNetAgent.new(Logger::ERROR), "../poldata/txt_sentoken/pos")
trainer.train
