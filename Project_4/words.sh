#!/bin/bash

# Skrypt do utrwalania słówek języka obcego

usage () {
	echo -e "\nWywołanie skryptu:"
	echo "$0 [-e]"
}

# funkcja do pobrania liczby wierszy ze słownika, liczba określa koniec zakresu pętli do wypisywania słówek
# $1 - nazwa pliku słownika
get_row_number () { 
	SLOWNIK="$1" # nazwa pliku słownika
	if [ -f "$SLOWNIK" ]; then
		ROW_NUMBER=$(cat "$SLOWNIK"| wc -l) # liczba wierszy w słowniku
	else
		echo "ERROR: Brak slownika ('dictionary.txt') w obecnym katalogu!"
		exit 1
	fi
}

# funkcja do wprowadzanie tłumaczeń 
# $1 - słowo/słowa z języka A
# $2 - słowo/słowa z języka B
# [$3] - suma do tej pory prawidłowo wprowadzonych tłumaczeń ($CORRECT) 
correct_translation() {
	local WRONG="false" # flaga do sprawdzania czy słówko/słówka zostały przetłumaczone (w pełni) prawidłowo
	if [ $# -eq 3 ]; then
		local -n CORRECT_L=$3 # zmienna referencyjna do liczenia prawidłowych tłumaczeń
	fi
	
	read -p "$1 - " TRANSLATED # przetłumaczone słowo/słowa
	echo
	for j in $TRANSLATED; do
		if [[ $2 =~ $j ]]; then
			echo "    OK"
			if [ $# -eq 3 ]; then
				(( CORRECT_L++ ))
			fi
		else
			echo "   ŹLE!"
			WRONG="true"
		fi
	done
	
	local TRANSLATED_ARRAY=($TRANSLATED) # tablica wprowadzonych tłumaczeń (do weryfikacji czy wszystkie możliwe warianty tłumaczeń zostały wprowadzone)
	local WRONG_WORDS_POL_ARRAY=($2) # tablica wszystkich możliwych tłumaczeń (do weryfikacji czy wszystkie możliwe warianty tłumaczeń zostały wprowadzone)
	if [ "${#TRANSLATED_ARRAY[@]}" -lt "${#WRONG_WORDS_POL_ARRAY[@]}" ]; then
		echo "Za mało wypisanych tłumaczeń!"
		WRONG="true"
	fi
	
	echo -e "\n >>>  ${WRONG_WORDS_POL_ARRAY[@]}  <<<"	
	echo -e "--------------------------------------------\n"

	if [ $WRONG == "false" ]; then
		return 0
	else
		return 11
	fi
}

# funkcja do tłumaczenia
# [$1] - jeżeli brak parametrów tłumacz: ang-pol, jeżeli podany parametr '-e' tłumacz: pol-ang
translation () {
	RAND_ARRAY=($(shuf -i 1-$ROW_NUMBER)) # uzyskanie tablicy z losową kolejnością liczb od 1 do ROW_NUMBER (liczba wierszy w słowniku)
	ALL_WORDS=0 # suma wszystkich możliwych tłumaczeń
	CORRECT=0 # suma prawidłowo wprowadzonych tłumaczeń
	WRONG_WORDS_ENG=() # tablica błędnych tłumaczeń (słówek angielskich)
	WRONG_WORDS_POL=() # tablica błędnych tłumaczeń (słówek polskich)

	for ((i=0; i<${#RAND_ARRAY[@]}; i++)); do
		if [ "$1" == "-e" ]; then
			POL_WORD=$(sed -n "${RAND_ARRAY[$i]}p" $SLOWNIK | awk -F "-" '{if($1=="hands") print $1"-"$2; else print $1}') # angielskie słowo/słowa do przetłumacznia
			ENG_WORD=$(sed -n "${RAND_ARRAY[$i]}p" $SLOWNIK | awk -F "-" '{if($1=="hands") print $3; else print $2}') # polskie słowo/słowa do weryfikacji poprawności wprowadzenia (przetłumaczenia)
			ENG_WORD=$(echo "$ENG_WORD" | awk '{$1=$1}1') # aby usunąć znak tabulacji z polskich słów
		else
			ENG_WORD=$(sed -n "${RAND_ARRAY[$i]}p" $SLOWNIK | awk -F "-" '{if($1=="hands") print $1"-"$2; else print $1}') # angielskie słowo/słowa do przetłumacznia
			POL_WORD=$(sed -n "${RAND_ARRAY[$i]}p" $SLOWNIK | awk -F "-" '{if($1=="hands") print $3; else print $2}') # polskie słowo/słowa do weryfikacji poprawności wprowadzenia (przetłumaczenia)
		fi
		
		(( ALL_WORDS+=$(echo "$POL_WORD" | wc -w) ))

		# jeżeli źle przetłumaczono, wprowadź słówka do tablic:
		correct_translation "$ENG_WORD" "$POL_WORD" CORRECT || \
		WRONG_WORDS_ENG+=("$ENG_WORD") \
		WRONG_WORDS_POL+=("$POL_WORD")
	done
	
	echo -e "===================================================================="
	printf "Poprawność = "
	echo -e "scale=2 ; 100 * $CORRECT / $ALL_WORDS"|bc # statystyka poprawności
	echo -e "====================================================================\n\n"
	
	# dla źle przetłumaczonych słów wykonaj ponowne tłumaczenie:
	while [ ${#WRONG_WORDS_ENG[@]} -gt 0 ]; do
		TMP_WRONG_WORDS_ENG=("${WRONG_WORDS_ENG[@]}")
		TMP_WRONG_WORDS_POL=("${WRONG_WORDS_POL[@]}")
		unset WRONG_WORDS_ENG
		unset WRONG_WORDS_POL
		for ((i=0; i<${#TMP_WRONG_WORDS_ENG[@]}; i++)); do
			correct_translation "${TMP_WRONG_WORDS_ENG[$i]}" "${TMP_WRONG_WORDS_POL[$i]}" || \
			WRONG_WORDS_ENG+=("${TMP_WRONG_WORDS_ENG[$i]}") \
			WRONG_WORDS_POL+=("${TMP_WRONG_WORDS_POL[$i]}")
		done
	done
}



# ----------------- main() ------------------------------------
get_row_number "dictionary.txt" # nazwa pilku z słownikiem

if [ $# -gt 0 ]; then
	if [ $1 == "-e" ]; then
		translation -e
	else
		echo "Zła opcja!"
		usage
		exit 2
	fi
else
	translation
fi
