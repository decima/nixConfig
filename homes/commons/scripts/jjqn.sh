jq --unbuffered -R -r ". as \$line | try fromjson catch {\"jjq_error\": \$line}" | jq --unbuffered "''${1:-.}"
