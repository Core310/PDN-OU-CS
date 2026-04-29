from mrjob.job import MRJob
import re

class MRLongestWord(MRJob):
    """
    Finds the longest words tied for the maximum length for each letter 'a'-'z'.
    """

    def mapper(self, _, line):
        # Extract all words consisting of only letters a-z/A-Z
        # re.findall automatically ignores punctuation, numbers, and the UTF-8 BOM
        words = re.findall(r'[a-zA-Z]+', line)
        for word in words:
            # First letter as key, word as value (both lowercased)
            yield word[0].lower(), word.lower()

    def combiner(self, letter, words):
        # Local aggregation to reduce data sent to reducer
        # Tracks max length and words matching it for each letter locally
        max_len = 0
        longest_words = set()

        for word in words:
            current_len = len(word)
            if current_len > max_len:
                max_len = current_len
                longest_words = {word}
            elif current_len == max_len:
                longest_words.add(word)
        
        # Yield the candidates for the global longest words
        for word in longest_words:
            yield letter, word

    def reducer(self, letter, words):
        # Global aggregation to find the absolute longest words per letter
        max_len = 0
        longest_words = set()

        for word in words:
            current_len = len(word)
            if current_len > max_len:
                max_len = current_len
                longest_words = {word}
            elif current_len == max_len:
                longest_words.add(word)

        # Output: Key is starting letter, Value is sorted list of longest words
        yield letter, sorted(list(longest_words))

if __name__ == '__main__':
    MRLongestWord.run()
