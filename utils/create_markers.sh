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
  ./aruco_create_marker $NUM ${NUM}.png 360 $R $G $B
  PNGS="${PNGS} ${NUM}.png"
done
convert -page A4 -gravity center ${PNGS} out.pdf
rm ${PNGS}
