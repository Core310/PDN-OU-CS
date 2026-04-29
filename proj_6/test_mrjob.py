import re
from mrjob.job import MRJob
from mrjob.step import MRStep

WORD_RE = re.compile(r"[a-zA-Z]+")

class MRLongestWord(MRJob):

    def mapper(self, _, line):
        for word in WORD_RE.findall(line):
            word = word.lower()
            yield word[0], word

    def reducer(self, first_char, words):
        max_len = 0
        longest_words = []
        for word in words:
            if len(word) > max_len:
                max_len = len(word)
                longest_words = [word]
            elif len(word) == max_len and word not in longest_words:
                longest_words.append(word)
        yield first_char, longest_words

if __name__ == '__main__':
    MRLongestWord.run()
