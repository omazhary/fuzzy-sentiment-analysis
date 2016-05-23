# This class represents texts that consist of multiple paragraph.

require_relative 'paragraph'

module NLP

    class Text
        attr_accessor :src_text
        attr_reader :paragraph_list

        def initialize(text = "", wn_agent = WORDNET::WordNetAgent.new)
            @src_text = text
            @paragraph_list = []
            @wn_agent = wn_agent
            self.split_paragraphs
        end

        def split_paragraphs
            # This is merely an assumption that paragraphs can be delimited by newlines.
            # I will need to check the validity of this assumption when checking out corpora.
            paragraphs_raw = @src_text.split(/\n/)
            paragraphs_raw.each do |paragraph|
                # Removing hyphenation helps normalize internet-lingo to some extent.
                paragraph = paragraph.gsub(/-/, ' ')
                paragraph = paragraph.strip
                @paragraph_list.push(NLP::Paragraph.new(paragraph, @wn_agent))
            end
        end
    end

end
