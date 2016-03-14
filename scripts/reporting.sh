#!/bin/bash
#$ -V
#$ -cwd
#$ -o log.out
#$ -e log.err
#$ -l mem=1G,time=1::

# This script generates the report

# defaults
input="blast/top.concat.txt"

while [[ $# > 0 ]]; do

	flag=${1}

	case $flag in
		-i|--input)	# the input blast file
		input="${2}"
		shift ;;

		-o|--outputdir)	# the output directory
		outputdir="${2}"
		shift ;;

		-l|--logsdir)	# the logs directory
		logsdir="${2}"
		shift ;;

		-d|--scripts)	# the git repository directory
		d="${2}"
		shift ;;

		--blacklist)	# text file of blacklist taxids
		blacklist="${2}"
		shift ;;

		--id)		# sample identifier
		id="${2}"
		shift ;;

		--noclean)	# noclean bool
		noclean="${2}"
		shift ;;

		-v|--verbose)	# verbose
		verbose=true ;;

		*)
				# unknown option
		;;
	esac
	shift
done

# exit if previous step produced zero output
if [ ! -s ${input} ]; then exit; fi

echo "------------------------------------------------------------------"
echo REPORTING START [[ `date` ]]

mkdir -p report

echo filtering blast results
# filter PREDICTED; sort by taxids then query sequence length (careful: this line can scramble the header)
${d}/scripts/makereport.py blast/header ${input} ${id} ${blacklist} | grep -v PREDICTED | sort -k5,5n -k6,6nr > report/blast.topfilter.txt

echo REPORTING END [[ `date` ]]
echo "------------------------------------------------------------------"
