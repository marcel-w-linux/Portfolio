The script `script.sh` extracts the contents of archive with a log given as argument and parses those log to display the number of request per IP, for example:
ADDRESS              REQUESTS
10.0.0.1             10
10.0.0.2             20
...

The script also takes additional two options:
'--user-agent': which allows restricting parsing of log only to provided user agent.
'--method': which prints in output number of requests per method/address instead of just per address.
The script removes extracted files after parsing.

Usage of the script:
./script.sh -f/--file "compressed_log_name" [-u/--user-agent "user_agent"] [-m/--method]
Example:
./script.sh -f log.tar.bz2 -u "Windows" -m

In the repository is an example compressed tar archive (`log.tar.bz2`), that contains directory with log from web server.
