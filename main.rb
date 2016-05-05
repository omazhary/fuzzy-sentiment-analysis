# This is the main file that will run this program

require_relative 'nlp/paragraph'
require_relative 'wordnet/wnagent'

test_text1 = "This is the first sentence. And this is the second one."

test_text2 = "sentences, much more than sentences. SENTENCES! Give me more? And he said \"Ta-Da\""

para1 = NLP::Paragraph.new(test_text1)
para2 = NLP::Paragraph.new(test_text2)

wn_agent = WORDNET::WordNetAgent.new

para2.sentence_list.each do |sentence|
    sentence.clause_list.each do |clause|
        clause.word_list.each do |word|
            wn_agent.send_query(word.src_text)
        end
    end
end
