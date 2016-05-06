# This is the main file that will run this program

require_relative 'nlp/paragraph'
require_relative 'wordnet/wnagent'

test_text1 = "This is the first sentence. And this is the second one."

test_text2 = "sentences, much more than sentences. SENTENCES! Give me more? And he said \"Ta-Da\""

wn_agent = WORDNET::WordNetAgent.new

para1 = NLP::Paragraph.new(test_text1, wn_agent)
para2 = NLP::Paragraph.new(test_text2, wn_agent)
