#!/usr/bin/env ruby

# This is the main file that will run this program

require_relative 'textmining/sentalysis/fuzzy/fuzzy_tester'
require_relative 'textmining/sentalysis/fuzzy/fuzzy_trainer'
require_relative 'textmining/sentalysis/fuzzy/fuzzy'
require_relative 'nlp/text'
require_relative 'wordnet/wnagent'
require_relative 'utils/cli_opts'
require 'logger'
require 'logger/colors'

logger = Logger.new(STDERR)
myOptParser = UTILS::CLIOptParser.new

options = myOptParser.parse(ARGV)

# So far, only the fuzzy classifier is supported
if options[:type] != 'fuzzy'
  logger.fatal("Invalid classifier type!! So far only 'fuzzy' supported.")
  abort
end

if options[:mode] != 'train' && options[:mode] != 'test' && options[:mode] != 'classify'
  logger.fatal("Invalid mode!! Must be one of: 'train', 'test', or 'classify'.")
  abort
end

if (options[:batch_polarity] != 'positive' && options[:batch_polarity] != 'negative') && (options[:mode] == 'train' || options[:mode] == 'test')
  logger.fatal("Invalid polarity!! Must be either 'positive' or 'negative'.")
  abort
end

index = SENTALYSIS::PolarityIndex.new('sample_index.json')
wnagent = WORDNET::WordNetAgent.new(Logger::FATAL)

if options[:mode] == 'train'
  trainer = SENTALYSIS::FuzzyTrainer.new(index, options[:batch_polarity], wnagent, options[:train_dir])
  trainer.train
elsif options[:mode] == 'test'
  tester = SENTALYSIS::FuzzyTester.new(index, options[:batch_polarity], wnagent, options[:test_dir])
  tester.test
elsif options[:mode] == 'classify'
  text = nil
  classifier = nil
  logger.info("Processing file #{options[:in_file]}...")
  if File.exist?(options[:in_file]) && File.file?(options[:in_file]) && File.readable?(options[:in_file])
    # Open the file and read its contents:
    file = File.new(options[:in_file], 'r')
    src_text = file.read
    file.close
    # Parse the file using the NLP elements:
    text = NLP::Text.new(src_text, wnagent)
  end
  if options[:type] == 'fuzzy'
    classifier = SENTALYSIS::FuzzyClassifier.new(index, wnagent)
  end
  result = classifier.classify(text)
  result.each do |key, value|
    puts "#{key}: #{value}"
  end
end
