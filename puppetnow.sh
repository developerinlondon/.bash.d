puppetnow(){
	__usage "$1" "puppetnow <env>" || return 1

	for j in {"web","celery","ingestion","geostore_new"}; do
		for i in `thor_get_nodes geoinsights $j $1`; do
        		echo "Running puppet on $j $1"
        		vpcssh $i 'sudo puppet agent -t';
	    done
	done
}
