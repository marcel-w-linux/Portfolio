The script 'words.sh' is used to memorize challenging words from a foreign language (in this case, from English, as the dictionary specifies). The script provides a word/words in one language and expects them to be translated in another. The words are randomly retrieved from the dictionary file: 'dictionary.txt'. It then provides information about whether correct translations were entered, for example:
	diversity	 - różnorodność

		OK

	 >>>  różnorodność  <<<
	--------------------------------------------

	prior	 - wcześniej

		OK
	Za mało wypisanych tłumaczeń!

	 >>>  wcześniejszy, wcześniej  <<<
	--------------------------------------------

	towards	 - przed w kierunku w pobliżu

		OK
		OK
		OK
		OK
		OK

	 >>>  w kierunku, przed, w pobliżu  <<<
	--------------------------------------------

	additional, extra	 - ...

After translating all the words from the dictionary, accuracy statistics are provided. For all previously mistranslated words, the script is rerun until all translations are entered correctly.
Thanks to the randomness, we avoid associating the meanings of words that appear in a fixed order, for example, when we have the following entries in the dictionary:
...
evaluate	-	oceniać
manner	-	sposób
facility	-	funkcja, zdolność
...
we can associate that after the word 'oceniać' there is the word 'sposób' but we may not remember that the word 'manner' means 'sposób'.

The script also takes one additional option:
'-e': to translate to the opposite language (in this case, from Polish to English).

Usage of the script:
./words.sh [-e]

The repository includes the following files:
- 'words.sh': the script
- `dictionary.txt`: an example of a dictionary with words, the convention of dictionary is:
word_1_a, word_1_b, ...	-	translation_1_a, translation_1_b, ...
word_2_a, word_2_b, ...	-	translation_2_a, translation_2_b, ...
word_3_a, word_3_b, ...	-	translation_3_a, translation_3_b, ...
Example:
achieve	-	osiągać, zdobywać
ultimately	-	ostatecznie
retirement, old age pension	-	emerytura
effective, successful	-	skuteczny, efektywny, udany

