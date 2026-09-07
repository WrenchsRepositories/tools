#!/usr/bin/env bash

TZ=${TZ:-Asia/Shanghai}
export TZ

resolve_date() {
  case "$1" in
    today) date +%F ;;
    yesterday) date -v-1d +%F ;;
    tomorrow) date -v+1d +%F ;;
    *) echo "$1" ;;
  esac
}

print_range() {
  local d1 d2
  d1=$(resolve_date "$1")
  d2=$(resolve_date "$2")
  date -j -f "%Y-%m-%d %H:%M:%S" "$d1 00:00:00" +%s
  date -j -f "%Y-%m-%d %H:%M:%S" "$d2 23:59:59" +%s
}

print_now() {
  date -j -f "%Y-%m-%d %H:%M:%S" "$(date +%F) 00:00:00" +%s
  date +%s
}

month_end() {
  date -j -v+1m -v-1d -f "%Y-%m" "$1" +%F
}

relative_offset() {
  case "$1" in
    yesterday) echo "-1d" ;;
    tomorrow) echo "+1d" ;;
    lastweek) echo "-7d" ;;
    nextweek) echo "+7d" ;;
    lastmonth) echo "-1m" ;;
    nextmonth) echo "+1m" ;;
    lastseason) echo "-3m" ;;
    nextseason) echo "+3m" ;;
    lastyear) echo "-1y" ;;
    nextyear) echo "+1y" ;;
    *) return 1 ;;
  esac
}

if [ -n "$2" ]; then
  offset=$(relative_offset "$2") || {
    echo "invalid second arg: $2" >&2
    exit 1
  }
  date +%s
  date -j -v"$offset" +%s
  exit 0
fi

monday=$(date -v-"$(($(date +%u) - 1))d" +%F)
year_month=$(date +%Y-%m)
year=$(date +%Y)
quarter_start_month=$(((10#$(date +%m) - 1) / 3 * 3 + 1))
quarter_start=$(printf "%04d-%02d-01" "$year" "$quarter_start_month")

case "${1:-now}" in
now) print_now ;;
today) print_range "today" "today" ;;
yesterday) print_range "yesterday" "yesterday" ;;
tomorrow) print_range "tomorrow" "tomorrow" ;;
week) print_range "$monday" "$(date -j -v+6d -f "%Y-%m-%d" "$monday" +%F)" ;;
lastweek) print_range "$(date -j -v-7d -f "%Y-%m-%d" "$monday" +%F)" "$(date -j -v-1d -f "%Y-%m-%d" "$monday" +%F)" ;;
nextweek) print_range "$(date -j -v+7d -f "%Y-%m-%d" "$monday" +%F)" "$(date -j -v+13d -f "%Y-%m-%d" "$monday" +%F)" ;;
month) print_range "$year_month-01" "$(month_end "$year_month")" ;;
lastmonth) print_range "$(date -j -v-1m -f "%Y-%m-%d" "$year_month-01" +%F)" "$(date -j -v-1d -f "%Y-%m-%d" "$year_month-01" +%F)" ;;
nextmonth) print_range "$(date -j -v+1m -f "%Y-%m-%d" "$year_month-01" +%F)" "$(month_end "$(date -j -v+1m -f "%Y-%m-%d" "$year_month-01" +%Y-%m)")" ;;
season) print_range "$quarter_start" "$(date -j -v+3m -v-1d -f "%Y-%m-%d" "$quarter_start" +%F)" ;;
lastseason) print_range "$(date -j -v-3m -f "%Y-%m-%d" "$quarter_start" +%F)" "$(date -j -v-1d -f "%Y-%m-%d" "$quarter_start" +%F)" ;;
nextseason) print_range "$(date -j -v+3m -f "%Y-%m-%d" "$quarter_start" +%F)" "$(date -j -v+6m -v-1d -f "%Y-%m-%d" "$quarter_start" +%F)" ;;
year) print_range "$year-01-01" "$year-12-31" ;;
lastyear) print_range "$((year - 1))-01-01" "$((year - 1))-12-31" ;;
nextyear) print_range "$((year + 1))-01-01" "$((year + 1))-12-31" ;;
*)
  echo "usage: $0 [now|today|yesterday|tomorrow|week|lastweek|nextweek|month|lastmonth|nextmonth|season|lastseason|nextseason|year|lastyear|nextyear]" >&2
  exit 1
  ;;
esac
