# Our list to add all unique words
Unique_Words = []

# Cheking if the char in each word are alphabetic characters & removing non-alphabetic characters
def checking_chars(text) :
    word = ""
    for x in text:
        x = (x.lower().rstrip().lstrip())
        if ('a' <= x <= 'z') :
            word += x
    return word     

# Geting all words that have alphabetic characters 
# Writing all words in out textfile [allwords.txt]
# Adding all unique Words into out list 
def GettingAllWords(ourTextFile, allwords) :
    for line in ourTextFile:        
        text = line.split()                
        for i in text :
            i = checking_chars(i)
            # Writing all words in out textfile [allwords.txt]
            allwords.write(i + '\n') 
            Unique_Words.append(i)

  
#  Writing our frequencies of Unique Words in out textfile [wordfrequency.txt]
def WordFrequencies(wordfrequencyTextFile, uniquewordsTextFile ) :   
    frequenciesOfWord = {}
    textFile = open("allwords.txt",'r')
    for word in textFile :
        word = word[:-1]
        if word in frequenciesOfWord.keys() :
            frequenciesOfWord[word] += 1
        else:
            frequenciesOfWord[word] = 1
    
    #  Writing all Unique Words in out textfile [uniquewords.txt]
    for word in frequenciesOfWord.keys():
        if frequenciesOfWord[word] == 1:
            uniquewordsTextFile.write(word + "\n")
            
    #  Writing our frequencies all words in out textfile [wordfrequency.txt]
    wordFrequency = {}
    for word in frequenciesOfWord.keys() :
        if frequenciesOfWord[word] in wordFrequency.keys() :
            wordFrequency[frequenciesOfWord[word]] += 1
        else:
            wordFrequency[frequenciesOfWord[word]] = 1
    for count in sorted(wordFrequency.keys()):
        wordfrequencyTextFile.write(str(count) + ":" + str(wordFrequency[count]) + "\n")
       
             
def main():
    ourTextFile = open("TheThreeMusketeers.txt",'r')
    allwords = open("allwords.txt",'w')
    uniquewords = open("uniquewords.txt",'w')
    wordfrequency = open("wordfrequency.txt",'w')
    GettingAllWords(ourTextFile, allwords)
    WordFrequencies(wordfrequency, uniquewords)
    
main()