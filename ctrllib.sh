root=~/gartenctrl/

mystrom_gridinverter=192.168.1.10
mystrom_charger=192.168.1.197
actionlogfile=~/gartenctrl/action.log

function actionlog()
{
    if [ "$2" != "0" ];
    then
	echo -n `date` >> $actionlogfile
	printf "\t" >> $actionlogfile
	echo $1 >> $actionlogfile
    fi
    echo $1
} ;

