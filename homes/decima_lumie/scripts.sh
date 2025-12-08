jjqn () {
	jq --unbuffered -R -r ". as \$line | try fromjson catch {\"jjq_error\": \$line}" | jq --unbuffered "${1:-.}"
}


_decode_base64_url() {
    local len=$((${#1} % 4))
    local result="$1"
    if [ $len -eq 2 ]; then result="$1"'=='
    elif [ $len -eq 3 ]; then result="$1"'='
    fi
    echo "$result" | tr '_-' '/+' | base64 -d
}

Bearer(){
  export TOKEN_KEY="${2:-TOKEN}"
  export $TOKEN_KEY=$1
  echo "$TOKEN_KEY env var available."
  decode_jwt $1
}

bearer(){
  Bearer $1 ${2:-TOKEN}
}

kmlt() {
	curl -s https://kaamelott.chaudie.re/api/random | jjqn
}

decode_jwt() {
    _decode_base64_url $(echo -n $1 | cut -d "." -f ${2:-2}) |
        jq 'if .exp then (.expLocal = (.exp|gmtime|strftime("%c"))) else . end' |
        jq -S 'if .iat then (.iatLocal = (.iat|gmtime|strftime("%c"))) else . end'
}


kubeloggrep() {
	 grep --line-buffered -v "/health" | grep --line-buffered -v "/ping" | grep --line-buffered -v "/debug/vars" | grep --line-buffered -v "/ready"
}

fzf-history-search() {
  local selected
  selected=$(fc -rl 1 | fzf --height 40% --reverse --inline-info --border +m)
  BUFFER=$selected
  CURSOR=$#BUFFER
  zle end-of-line
}
zle -N fzf-history-search
bindkey '^R' fzf-history-search



uuid_id() {
    (python - <<EOF $1
import sys, uuid

output="{"

try:
    output+=f'"id": "{int(uuid.UUID(sys.argv[1]))}",'
except:
    output+='"id_error": "error translating to ID",'

try:
    output+=f'"uuid": "{str(uuid.UUID(int=int(sys.argv[1])))}"'
except:
    output+=f'"uuid_error": "error translating to UUID"'

output += "}"
print(output)
EOF
    ) | jq .
}

uuid(){
  python -c "from uuid import UUID; import sys; print(str(UUID(sys.argv[1]).int));" "$1"
}

remote_kibana(){
  CELL=$1
  echo $(kibana.sh deployed_kibana_get_credentials $CELL)| awk -F '\t' 'NR==2{print $2}'|xclip -selection clipboard
  (sleep 10; open https://localhost:5601/) &
  kibana.sh deployed_kibana_port_forward $CELL
}

to_accounts_admin() {
    gcloud config configurations activate admin
    sed -i '/access-token:/d' ~/.kube/config
    rm -f ~/.kube/gke_gcloud_auth_plugin_cache
}

to_accounts_default() {
    gcloud config configurations activate default
    sed -i '/access-token:/d' ~/.kube/config
    rm -f ~/.kube/gke_gcloud_auth_plugin_cache
}