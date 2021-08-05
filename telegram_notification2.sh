#!/bin/sh

BOT_URL="https://api.telegram.org/bot${TELEGRAM_TOKEN}/sendMessage"

PARSE_MODE="Markdown"

build_status="$TEST_OUTCOME"

send_msg () {
    curl -s -X POST ${BOT_URL} -d chat_id=$TELEGRAM_CHAT_ID \
        -d text="$1" -d parse_mode=${PARSE_MODE}
}

send_msg "
-------------------------------------
GitHub Actions build *${build_status}!*
\`Repository:  ${GITHUB_REPOSITORY}\`
\`Branch:      ${GITHUB_REF}\`
*Commit Msg:*
${ACTION_COMMIT_MESSAGE}
--------------------------------------
"
