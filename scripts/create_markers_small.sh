#! /bin/bash
DPI=72
SIZE_IN_CM=7
BORDER_IN_CM=0.5
SIZE_IN_IN=`echo "scale=10; ${SIZE_IN_CM}/2.54" | bc`
SIZE=`echo "${SIZE_IN_IN}*${DPI}" | bc`
BORDER_IN_IN=`echo "scale=10; ${BORDER_IN_CM}/2.54" | bc`
BORDER=`echo "${BORDER_IN_IN}*${DPI}" | bc`
NUMS=$*
PNGS=""
for NUM in $NUMS; do
  if [ "$NUM" -lt "100" ]; then
    R=40
    G=0
    B=0
  elif [ "$NUM" -lt "200" ]; then
    R=0
    G=40
    B=0
  elif [ "$NUM" -lt "300" ]; then
    R=35
    G=0
    B=35
  elif [ "$NUM" -lt "400" ]; then
    R=0
    G=0
    B=40
  else
    R=0
    G=0
    B=0
  fi

  ./aruco_create_marker $NUM ${NUM}.png $SIZE $R $G $B
  PNGS="${PNGS} ${NUM}.png"
done
MONTAGES=""
FOUR_PNGS=""
iter=0
NUM_PNGS=`echo ${PNGS} | wc -w`
for PNG in $PNGS; do
  FOUR_PNGS="${FOUR_PNGS} ${PNG}"
  if [ "$((iter % 6))" -eq "5" -o "$((iter+1))" -eq "${NUM_PNGS}" ]; then
    MONTAGE=montage_$((iter / 6)).png
    echo montage -geometry ${SIZE}x${SIZE}+${BORDER}+${BORDER} ${FOUR_PNGS} ${MONTAGE}
    montage -tile 2x3 -geometry ${SIZE}x${SIZE}+${BORDER}+${BORDER} ${FOUR_PNGS} ${MONTAGE}
    MONTAGES="${MONTAGES} ${MONTAGE}"
    FOUR_PNGS=""
  fi
  let iter+=1
done
convert -page A4 -gravity center $MONTAGES out.pdf
#rm ${PNGS}
rm ${MONTAGES}
