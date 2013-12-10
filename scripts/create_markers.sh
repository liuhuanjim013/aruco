#! /bin/bash
DPI=72
SIZE_IN_CM=13
SIZE_IN_IN=`echo "scale=10; ${SIZE_IN_CM}/2.54" | bc`
SIZE=`echo "${SIZE_IN_IN}*${DPI}" | bc`
BORDER="$((BORDER_IN_IN * 75))"
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
  ./aruco_create_marker $NUM ${NUM}.png ${SIZE} $R $G $B
  PNGS="${PNGS} ${NUM}.png"
done
convert -gravity center  -page A4  ${PNGS} out.pdf
#rm ${PNGS}
