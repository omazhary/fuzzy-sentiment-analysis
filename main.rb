# This is the main file that will run this program

require_relative 'textmining/sentalysis/fuzzy/fuzzy_trainer'
require_relative 'wordnet/wnagent'

index = SENTALYSIS::PolarityIndex.new("sample_index.json")

trainer = SENTALYSIS::FuzzyTrainer.new(index, "positive", WORDNET::WordNetAgent.new, "../poldata/txt_sentoken/pos")
trainer.train
