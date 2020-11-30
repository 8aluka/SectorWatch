#!/bin/sh
svname=$(hostname)
disklist=/var/tmp/disklist
senddata=/var/tmp/senddata
nb=1

smartctl --scan > $disklist
disknb=$(cat $disklist | wc -l | sed 's/ .*/ /')

while [ $nb -le $disknb ]
do
    selectdisk=$(head -$nb $disklist | tail -1 | sed 's/#.*/ /')
    result_05=$(smartctl -A $selectdisk | grep Reallocated_Sector | tail -c 2)
    result_197=$(smartctl -A $selectdisk | grep Current_Pending | tail -c 2)

    result_05=1

    if [ $result_05 -gt 0 ] || [ $result_197 -gt 0 ]; then
        echo 該当ディスク:$selectdisk >> $senddata
        echo ・代替処理済のセクタ数:$result_05 >> $senddata
        echo ・代替処理保留中のセクタ数:$result_197 >> $senddata
    fi
    nb=`expr $nb + 1`
done

if [ -s $senddata ]; then
    URL='https://hooks.slack.com/services/**************'
    CHANNEL=${CHANNEL:-'#random'}
    BOTNAME=${BOTNAME:-"$svname"}
    EMOJI=${EMOJI:-':confounded:'}
    HEAD=${HEAD:-'不良セクタがあるみたい\n'}
    MESSAGE='```'`cat $senddata`'```'

    payload="payload={
        \"channel\": \"${CHANNEL}\",
        \"username\": \"${BOTNAME}\",
        \"icon_emoji\": \"${EMOJI}\",
        \"text\": \"${HEAD}${MESSAGE}\"
    }"
    curl -s -S -X POST --data-urlencode "${payload}" ${URL} > /dev/null
fi
rm $disklist $senddata
