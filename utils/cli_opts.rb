# This class allows users to pass command line options and flags to the application

module UTILS

    require 'optparse'

    class CLIOptParser

        def parse(options)
            args = {:type => "fuzzy", :mode => "classify", :train_dir =>nil, :test_dir => nil, :batch_polarity => nil, :in_file => nil}

            opt_parser = OptionParser.new do |opts|
              opts.banner = "Usage: main.rb [options]"

              opts.on("-tTYPE", "--type=TYPE", "Type of classifier to use [fuzzy]") do |t|
                args[:type] = t
              end

              opts.on("-mMODE", "--mode=MODE", "What mode to use [train|test]") do |m|
                args[:mode] = m
              end

              opts.on("--trainDir=dir", "The path to your training directory") do |t|
                args[:train_dir] = t
              end

              opts.on("--testDir=dir", "The path to your testing directory") do |t|
                args[:test_dir] = t
              end

              opts.on("-pPolarity", "--polarity=Polarity", "Polarity label for training or testing [positive|negative]") do |t|
                args[:batch_polarity] = t
              end

              opts.on("-i", "--input=file", "File containing single text to classify") do |t|
                args[:in_file] = t
              end

              opts.on("-h", "--help", "Prints this help") do
                puts opts
                exit
              end
            end

            opt_parser.parse!(options)
            return args
        end

    end

end
