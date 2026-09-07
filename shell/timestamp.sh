#!/usr/bin/env bash

TZ=${TZ:-Asia/Shanghai}
export TZ

print_range() {
  date -d "$1 00:00:00" +%s
  date -d "$2 23:59:59" +%s
}

print_now() {
  date -d "today 00:00:00" +%s
  date +%s
}

month_end() {
  date -d "$1-01 +1 month -1 day" +%F
}

relative_offset() {
  case "$1" in
    yesterday) echo "-1 day" ;;
    tomorrow) echo "+1 day" ;;
    lastweek) echo "-7 days" ;;
    nextweek) echo "+7 days" ;;
    lastmonth) echo "-1 month" ;;
    nextmonth) echo "+1 month" ;;
    lastseason) echo "-3 months" ;;
    nextseason) echo "+3 months" ;;
    lastyear) echo "-1 year" ;;
    nextyear) echo "+1 year" ;;
    *) return 1 ;;
  esac
}

if [ -n "$2" ]; then
  offset=$(relative_offset "$2") || {
    echo "invalid second arg: $2" >&2
    exit 1
  }
  date +%s
  date -d "now $offset" +%s
  exit 0
fi

monday=$(date -d "today - $(($(date +%u) - 1)) days" +%F)
year_month=$(date +%Y-%m)
year=$(date +%Y)
quarter_start_month=$(((10#$(date +%m) - 1) / 3 * 3 + 1))
quarter_start=$(printf "%04d-%02d-01" "$year" "$quarter_start_month")

case "${1:-now}" in
now) print_now ;;
today) print_range "today" "today" ;;
yesterday) print_range "yesterday" "yesterday" ;;
tomorrow) print_range "tomorrow" "tomorrow" ;;
week) print_range "$monday" "$(date -d "$monday +6 days" +%F)" ;;
lastweek) print_range "$(date -d "$monday -7 days" +%F)" "$(date -d "$monday -1 day" +%F)" ;;
nextweek) print_range "$(date -d "$monday +7 days" +%F)" "$(date -d "$monday +13 days" +%F)" ;;
month) print_range "$year_month-01" "$(month_end "$year_month")" ;;
lastmonth) print_range "$(date -d "$year_month-01 -1 month" +%F)" "$(date -d "$year_month-01 -1 day" +%F)" ;;
nextmonth) print_range "$(date -d "$year_month-01 +1 month" +%F)" "$(month_end "$(date -d "$year_month-01 +1 month" +%Y-%m)")" ;;
season) print_range "$quarter_start" "$(date -d "$quarter_start +3 month -1 day" +%F)" ;;
lastseason) print_range "$(date -d "$quarter_start -3 month" +%F)" "$(date -d "$quarter_start -1 day" +%F)" ;;
nextseason) print_range "$(date -d "$quarter_start +3 month" +%F)" "$(date -d "$quarter_start +6 month -1 day" +%F)" ;;
year) print_range "$year-01-01" "$year-12-31" ;;
lastyear) print_range "$((year - 1))-01-01" "$((year - 1))-12-31" ;;
nextyear) print_range "$((year + 1))-01-01" "$((year + 1))-12-31" ;;
*)
  echo "usage: $0 [now|today|yesterday|tomorrow|week|lastweek|nextweek|month|lastmonth|nextmonth|season|lastseason|nextseason|year|lastyear|nextyear]" >&2
  exit 1
  ;;
esac
