# This is the main file that will run this program

require_relative 'textmining/sentalysis/fuzzy/fuzzy_trainer'

index = SENTALYSIS::PolarityIndex.new("sample_index.json")

trainer = SENTALYSIS::FuzzyTrainer.new(index, "positive", "sample_Dir")
trainer.train("bla", "negative")
