# Fuzzy Sentiment Analyzer
This project attempts to provide a proof of concept regarding the detection and classification of textual elements which are ambiguous with respect to sentiment.

## Installation
1. Make sure you have the nokogiri prerequisites installed (when working on linux/unix -based systems):
    - ruby-dev
    - build-essential
    - patch
    - zlib1g-dev
    - liblzma-dev
2. You'll need to install ruby depending on your distribution
3. Run ```gem install bundler``` to install bundler
4. Change to the project's root folder ```cd /path/to/project/root```
5. Run ```bundle install``` to install required dependencies

For problems with ```nokogiri``` see the [official documentation](https://www.google.de/url?sa=t&rct=j&q=&esrc=s&source=web&cd=1&ved=0ahUKEwi6ttyN4_rMAhVBthQKHfidD78QFggcMAA&url=http%3A%2F%2Fnokogiri.org%2Ftutorials%2Finstalling_nokogiri.html&usg=AFQjCNEM1XBiStk70xeHAOfCvnHJyvi3qw&sig2=6PY4RgCVdpSREpdpW890_w&bvm=bv.122676328,d.d24).

## Execution
To run the program, you only need to use bundler:
```
bundle exec main.rb [options]
```
There are three main modes that are supported by the application:
- train
- test
- classify

### train
Training runs the application in training mode, and allows you to specify a label for your chosen training set. Any deduced information that results from this mode will be assigned that label, and used accordingly.
#### Example:
This runs the application in training mode to process a group of negatively labeled files:
```
bundle exec main.rb -t fuzzy -m train --trainDir path/to/training/files -p negative
```
The above example specifies a fuzzy classifier, in training mode, that looks for training files in the ```
path/to/training/files``` directory, and treats them as negatively polarized.

### test
Testing runs the application in test mode, and allows you to specify a label for your chosen test set. Any deduced information that results from this mode will be compared against that label, and tests will pass or fail depending on the result of that comparison.
#### Example:
This runs the application in test mode to process a group of files that are assumed to be positively labeled:
```
bundle exec main.rb -t fuzzy -m test --testDir path/to/test/files -p positive
```
The above example specifies a fuzzy classifier, in test mode, that looks for test files in the ```
path/to/test/files``` directory, and compares the result of their classification to a positive polarity. If the result of the classification is a negative polarity, the test will fail.

### classify
Classify runs the application in classification mode, and allows you to specify an input file that should contain the text to be classified.
#### Example:
This runs the application in classification mode to process a file called ```test.txt```:
```
bundle exec main.rb -t fuzzy -m classify -i test.txt
```
The above example specifies a fuzzy classifier, in classification mode, that looks for ```test.txt```, and classifies it as either positive or negative.
