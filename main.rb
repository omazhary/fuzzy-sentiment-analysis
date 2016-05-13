# This is the main file that will run this program

require_relative 'textmining/sentalysis/uncertain_trainer'

trainer = SENTALYSIS::UncertainTrainer.new("polarity_index.json")
trainer.train("bla", "negative")
