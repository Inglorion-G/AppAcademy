require 'set'

def adjacent_words(word, dictionary)
  words_array = []
  dictionary.each do |dict_word|
    word.split('').each_with_index do |char, idx|
      next if dict_word == word

      if idx == 0
        if word[1...word.length] == dict_word[1...dict_word.length]
          words_array << dict_word
        end
      elsif idx == word.length - 1
        if word[0..-2] == dict_word[0..-2]
          words_array << dict_word
        end
      else
        if word[0..(idx-1)] == dict_word[0..(idx-1)] && word[(idx + 1)..-1] == dict_word[(idx + 1)..-1]
          words_array << dict_word
        end
      end
    end
  end
  words_array
end


def load_and_sort_dict(source, dictionary)
  dictionary = File.readlines(dictionary).map(&:chomp)
  candidate_words = []
  dictionary.each do |dict_word|
    candidate_words << dict_word if dict_word.length == source.length
  end
  candidate_words
end

def find_chain(source, target, dictionary)
  candidate_words = load_and_sort_dict(source, dictionary)

  words_to_expand = [source]
  banned_words = []
  parents = {}

  until parents.has_key?(target)
    word1 = words_to_expand.pop
    adj_words = adjacent_words(word1, candidate_words)
    banned_words << word1
    adj_words.delete_if do |word|
      banned_words.include?(word)
    end
    adj_words.each do |word2|
       parents[word2] = word1
    end
    words_to_expand += adj_words
  end
  build_path_from_breadcrumbs(source, target, parents)


end

def build_path_from_breadcrumbs(source, target, parents_hash)
  path = [target]
  current_word = target
  until current_word == source
    parents_hash.each do |k,v|
      if k == current_word
        path << v
        current_word = v
        break
      end
    end
  end

  path
end

p find_chain('pale', 'salt', 'dictionary.txt')