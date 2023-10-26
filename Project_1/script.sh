#!/bin/bash
# Skrypt do wypakowywania i parsowania logu

# funkcja do wyświetlania prawidłowego użycia parametrów w skrypcie
usage () {     
	echo -e "\nUsage:"
	echo "$0 -f/--file \"compressed_log_name\" [-u/--user-agent \"user_agent\"] [-m/--method]"
}

# funkcja parsująca log z opcją --file
primary_parse () {     
	INDEX=0    # index tablicy wypakowanych plików/katalogów
	for LINE in $(tar -tvf $1 | awk '{print $6}'); do
		EX_FILES[INDEX]=$LINE    # tablica nazw wypakowanych plików/katalogów
		((INDEX++))
	done
	END_INDEX=$(($INDEX - 1))    # ostatni index w tablicy - wykorzystywany do identyfikacji nazwy logu po wypakowaniu

	if tar -xvf $1 > /dev/null; then
		echo -e "ADDRESS\t\tREQUESTS"
		cat ${EX_FILES[$END_INDEX]} | awk '{print $14}' | sed 's/"//g' | sort | uniq -c | awk 'BEGIN{OFS="\t"} {print $2, $1}'
		rm -rf ${EX_FILES[0]}    # usuwanie całego wypakowanego katalogu
	else
		echo "Error while unpacking the file!"
	fi
}

# funkcja parsująca log z opcją --file i --user-agent
user_agent_parse () {
	INDEX=0    # index tablicy wypakowanych plików/katalogów
	for LINE in $(tar -tvf $1 | awk '{print $6}'); do
		EX_FILES[INDEX]=$LINE    # tablica nazw wypakowanych plików/katalogów
		((INDEX++))
	done
	END_INDEX=$(($INDEX - 1))    # ostatni index w tablicy - wykorzystywany do identyfikacji nazwy logu po wypakowaniu

	if tar -xvf $1 > /dev/null; then
		echo -e "ADDRESS\t\tREQUESTS"
		cat ${EX_FILES[$END_INDEX]} | awk -v var="$2" '{i=16;pole=""; while ($i != "accept_language:") {pole=pole $i; i++}; if(pole ~ var) print $14}' | sed 's/"//g' | sort | uniq -c | awk 'BEGIN{OFS="\t"} {print $2, $1}'
		
		rm -rf ${EX_FILES[0]}    # usuwanie całego wypakowanego katalogu
	else
		echo "Error while unpacking the file!"
	fi
}

# funkcja parsująca log z opcją: --file i --method
method_parse () {     
	INDEX=0    # index tablicy wypakowanych plików/katalogów
	for LINE in $(tar -tvf $1 | awk '{print $6}'); do
		EX_FILES[INDEX]=$LINE    # tablica nazw wypakowanych plików/katalogów
		((INDEX++))
	done
	END_INDEX=$(($INDEX - 1))    # ostatni index w tablicy - wykorzystywany do identyfikacji nazwy logu po wypakowaniu

	if tar -xvf $1 > /dev/null; then
		echo -e "METHOD\tADDRESS\t\tREQUESTS"
		cat ${EX_FILES[$END_INDEX]} | awk '{print $6, $14}'| sed 's/"//g' | sort | uniq -c | awk 'BEGIN{OFS="\t"} {print $2, $3, $1}'
		rm -rf ${EX_FILES[0]}    # usuwanie całego wypakowanego katalogu
	else
		echo "Error while unpacking the file!"
	fi
}

# funkcja parsująca log z opcją: --file i --user-agent i --method
user_agent_method_parse () {
	INDEX=0    # index tablicy wypakowanych plików/katalogów
	for LINE in $(tar -tvf $1 | awk '{print $6}'); do
		EX_FILES[INDEX]=$LINE    # tablica nazw wypakowanych plików/katalogów
		((INDEX++))
	done
	END_INDEX=$(($INDEX - 1))    # ostatni index w tablicy - wykorzystywany do identyfikacji nazwy logu po wypakowaniu

	if tar -xvf $1 > /dev/null; then
		echo -e "METHOD\tADDRESS\t\tREQUESTS"
		cat ${EX_FILES[$END_INDEX]} | awk -v var="$2" '{i=16;pole=""; while ($i != "accept_language:") {pole=pole $i; i++}; if(pole ~ var) print $6, $14}' | sed 's/"//g' | sort | uniq -c | awk 'BEGIN{OFS="\t"} {print $2, $3, $1}'
		
		rm -rf ${EX_FILES[0]}    # usuwanie całego wypakowanego katalogu
	else
		echo "Error while unpacking the file!"
	fi
}

# -------------------------- main () --------------------------

if [ "$#" -eq 0 ]; then
	echo "No options! "
	usage
	exit 1
else
	O_FILE=0    # opcja --file nie podana
	O_USER_AGENT=0    # opcja --user-agent nie podana
	O_METHOD=0    # opcja --method nie podana
	
	while [ "$#" -gt 0 ]; do
		case $1 in
		"-f" | "--file")
			shift
			O_FILE=1
			if [ -n "$1" ] && [ -f "$1" ]; then
				COMPRESS_FILE_NAME=$1
			else
				echo "Bad name of compressed log!"
				usage
				exit 3
			fi
			shift ;;
			
		"-u" | "--user-agent")
			shift
			O_USER_AGENT=1
			if [ -n "$1" ]; then
				GREP_WORD=$1    # parametr user agent ("providded user agent" z bonusowego zadania)
			else
				echo "Bad parameter of user-agent!"
				usage
				exit 3
			fi
			shift ;;

		"-m" | "--method")
			shift
			O_METHOD=1 ;;

		*)
			echo "Bad options!"
			usage
			exit 4
		esac			
	done
	
	if [ "$O_FILE" == "0" ]; then    # opcja --file musi być podana, bo po niej znajduje się nazwa skompresowanego logu
		echo "No --file option!"
		usage
		exit 4
	else
		if [ "$O_USER_AGENT" == "1" ] && [ "$O_METHOD" == "1" ]; then
			user_agent_method_parse $COMPRESS_FILE_NAME $GREP_WORD
		elif [ "$O_USER_AGENT" == "1" ]; then
			user_agent_parse $COMPRESS_FILE_NAME $GREP_WORD
		elif [ "$O_METHOD" == "1" ]; then
			method_parse $COMPRESS_FILE_NAME
		else
			primary_parse $COMPRESS_FILE_NAME
		fi
	fi
fi



