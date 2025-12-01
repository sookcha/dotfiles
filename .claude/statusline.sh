#!/bin/bash

INPUT=$(cat)

CWD=$(echo "$INPUT" | sed -n 's/.*"cwd":"\([^"]*\)".*/\1/p')
PROJECT=$(basename "$CWD")

trap 'exit 0' SIGTERM SIGINT

NEWS_CACHE_FILE="$HOME/.claude/news_cache.txt"
NEWS_CACHE_AGE=1800
WEATHER_CACHE_FILE="$HOME/.claude/weather_cache.txt"
WEATHER_CACHE_AGE=1800

fetch_news() {
  curl -sL "https://www.yna.co.kr/rss/news.xml" | \
    grep '<title><!\[CDATA\[' | \
    sed 's/.*<title><!\[CDATA\[//g; s/\]\]><\/title>.*//g' | \
    grep -v "^연합뉴스" | \
    head -15
}

fetch_weather() {
  curl -s "https://wttr.in/Seoul?format=%c+%t+%w" 2>/dev/null
}

get_news() {
  if [ -f "$NEWS_CACHE_FILE" ]; then
    AGE=$(($(date +%s) - $(stat -f %m "$NEWS_CACHE_FILE" 2>/dev/null || echo 0)))
    if [ $AGE -lt $NEWS_CACHE_AGE ]; then
      cat "$NEWS_CACHE_FILE"
      return
    fi
  fi

  NEWS=$(fetch_news)
  if [ -n "$NEWS" ] && [ ${#NEWS} -gt 50 ]; then
    echo "$NEWS" > "$NEWS_CACHE_FILE"
    echo "$NEWS"
  elif [ -f "$NEWS_CACHE_FILE" ]; then
    cat "$NEWS_CACHE_FILE"
  else
    echo "연합뉴스 속보 준비중"
  fi
}

get_weather() {
  if [ -f "$WEATHER_CACHE_FILE" ]; then
    AGE=$(($(date +%s) - $(stat -f %m "$WEATHER_CACHE_FILE" 2>/dev/null || echo 0)))
    if [ $AGE -lt $WEATHER_CACHE_AGE ]; then
      cat "$WEATHER_CACHE_FILE"
      return
    fi
  fi

  WEATHER=$(fetch_weather)
  if [ -n "$WEATHER" ]; then
    echo "$WEATHER" > "$WEATHER_CACHE_FILE"
    echo "$WEATHER"
  elif [ -f "$WEATHER_CACHE_FILE" ]; then
    cat "$WEATHER_CACHE_FILE"
  else
    echo "날씨 로딩중"
  fi
}

SEP=""

if [ -d "$CWD/.git" ]; then
  cd "$CWD" 2>/dev/null
  BRANCH=$(git branch --show-current 2>/dev/null || echo "main")
  STATUS=$(git status --porcelain 2>/dev/null | wc -l | tr -d ' ')

  if [ "$STATUS" -gt 0 ]; then
    GIT_INFO="  $BRANCH ±$STATUS "
  else
    GIT_INFO="  $BRANCH  "
  fi
else
  GIT_INFO=""
fi

HEADLINES=$(get_news)
NUM_HEADLINES=$(echo "$HEADLINES" | wc -l | tr -d ' ')
WEATHER=$(get_weather)

if [ "$NUM_HEADLINES" -gt 0 ]; then
  INDEX=$(($(date +%s) % NUM_HEADLINES + 1))
  CURRENT_HEADLINE=$(echo "$HEADLINES" | sed -n "${INDEX}p")
else
  CURRENT_HEADLINE="뉴스 로딩중..."
fi

echo " $PROJECT $SEP$GIT_INFO$SEP $WEATHER $SEP  $CURRENT_HEADLINE"
