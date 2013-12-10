#! /bin/bash
DPI=72
SIZE_IN_CM=7
BORDER_IN_CM=1.5
SIZE_IN_IN=`echo "scale=10; ${SIZE_IN_CM}/2.54" | bc`
SIZE=`echo "${SIZE_IN_IN}*${DPI}" | bc`
BORDER_IN_IN=`echo "scale=10; ${BORDER_IN_CM}/2.54" | bc`
BORDER=`echo "${BORDER_IN_IN}*${DPI}" | bc`
BORDER_X=${BORDER}
BORDER_Y=`echo "scale=10; ${BORDER}*2" | bc`
NUMS=$*
PNGS=""
for NUM in $NUMS; do
  if [ "$NUM" -lt "100" ]; then
    R=10
    G=0
    B=0
  elif [ "$NUM" -lt "200" ]; then
    R=0
    G=10
    B=0
  elif [ "$NUM" -lt "300" ]; then
    R=10
    G=0
    B=10
  elif [ "$NUM" -lt "400" ]; then
    R=0
    G=0
    B=10
  else
    R=0
    G=0
    B=0
  fi

  ./aruco_create_marker $NUM ${NUM}.png $SIZE $R $G $B
  PNGS="${PNGS} ${NUM}.png"
done
MONTAGES=""
PNG_BUFFER=""
iter=0
NUM_PER_PAGE=4
NUM_PNGS=`echo ${PNGS} | wc -w`
for PNG in $PNGS; do
  PNG_BUFFER="${PNG_BUFFER} ${PNG}"
  if [ "$((iter % ${NUM_PER_PAGE}))" -eq "$((NUM_PER_PAGE - 1))" -o "$((iter+1))" -eq "${NUM_PNGS}" ]; then
    MONTAGE=montage_$((iter / ${NUM_PER_PAGE})).png
    echo montage -tile 2x2 -geometry ${SIZE}x${SIZE}+${BORDER_X}+${BORDER_Y} ${PNG_BUFFER} ${MONTAGE}
    montage -tile 2x2 -geometry ${SIZE}x${SIZE}+${BORDER_X}+${BORDER_Y} ${PNG_BUFFER} ${MONTAGE} 
    LABEL=`echo ${PNG_BUFFER} | sed -e s/\.png//g`
    convert ${MONTAGE} -gravity south -pointsize 7 -fill '#0004' -annotate 0 "${LABEL}"  ${MONTAGE}
    MONTAGES="${MONTAGES} ${MONTAGE}"
    PNG_BUFFER=""
  fi
  let iter+=1
done
convert -page A4 -gravity center $MONTAGES out.pdf
rm ${PNGS}
rm ${MONTAGES}
