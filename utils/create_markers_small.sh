#! /bin/bash
NUMS=$*
PNGS=""
for NUM in $NUMS; do
  if [ "$NUM" -lt "100" ]; then
    R=25
    G=0
    B=0
  elif [ "$NUM" -lt "200" ]; then
    R=0
    G=25
    B=0
  elif [ "$NUM" -lt "300" ]; then
    R=20
    G=0
    B=20
  elif [ "$NUM" -lt "400" ]; then
    R=0
    G=0
    B=25
  else
    R=0
    G=0
    B=0
  fi
  ./aruco_create_marker $NUM ${NUM}.png 180 $R $G $B
  PNGS="${PNGS} ${NUM}.png"
done
MONTAGES=""
FOUR_PNGS=""
iter=0
NUM_PNGS=`echo ${PNGS} | wc -w`
for PNG in $PNGS; do
  FOUR_PNGS="${FOUR_PNGS} ${PNG}"
  if [ "$((iter % 4))" -eq "3" -o "$((iter+1))" -eq "${NUM_PNGS}" ]; then
    MONTAGE=montage_$((iter / 4)).png
    echo montage -geometry 180x180+48+48 ${FOUR_PNGS} ${MONTAGE}
    montage -geometry 180x180+48+48 ${FOUR_PNGS} ${MONTAGE}
    MONTAGES="${MONTAGES} ${MONTAGE}"
    FOUR_PNGS=""
  fi
  let iter+=1
done
convert -page A4 -gravity center $MONTAGES out.pdf
rm ${PNGS}
rm ${MONTAGES}
