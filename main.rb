# This is the main file that will run this program

require_relative 'nlp/paragraph'

test_text1 = "This is the first sentence. And this is the second one."

test_text2 = "sentences, much more than sentences. SENTENCES! Give me more? And he said \"Ta-Da\""

para1 = Paragraph.new(test_text1)
puts para1.sentence_list.inspect
