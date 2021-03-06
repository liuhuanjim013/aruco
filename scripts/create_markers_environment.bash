#! /bin/bash
DPI=72
SIZE_IN_CM=11
BORDER_IN_CM=1.25
SIZE_IN_IN=`echo "scale=10; ${SIZE_IN_CM}/2.54" | bc`
SIZE=`echo "${SIZE_IN_IN}*${DPI}" | bc`
BORDER_IN_IN=`echo "scale=10; ${BORDER_IN_CM}/2.54" | bc`
BORDER=`echo "${BORDER_IN_IN}*${DPI}" | bc`
R=$1
G=$2
B=$3
echo "color: $R,$G,$B"
NUMS="${*:4}"
PNGS=""
for NUM in $NUMS; do
  aruco_create_marker $NUM ${NUM}.png $SIZE $R $G $B
  PNGS="${PNGS} ${NUM}.png"
done
MONTAGES=""
PNG_BUFFER=""
iter=0
NUM_PNGS=`echo ${PNGS} | wc -w`
for PNG in $PNGS; do
  PNG_BUFFER="${PNG_BUFFER} ${PNG}"
  if [ "$((iter % 2))" -eq "1" -o "$((iter+1))" -eq "${NUM_PNGS}" ]; then
    MONTAGE=montage_$((iter / 2)).png
    echo montage -geometry ${SIZE}x${SIZE}+${BORDER}+${BORDER} ${PNG_BUFFER} ${MONTAGE}
    montage -tile 1x2 -geometry ${SIZE}x${SIZE}+${BORDER}+${BORDER} ${PNG_BUFFER} ${MONTAGE}
    LABEL=`echo ${PNG_BUFFER} | sed -e s/\.png//g`
    convert ${MONTAGE} -gravity south -pointsize 7 -fill '#0004' -annotate 0 "${LABEL}"  ${MONTAGE}
    MONTAGES="${MONTAGES} ${MONTAGE}"
    PNG_BUFFER=""
  fi
  let iter+=1
done
convert -page A4 -gravity center $MONTAGES out.pdf
#rm ${PNGS}
rm ${MONTAGES}
