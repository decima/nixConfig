export ENV=$1
export ORG=$2
export DOCID=$3
echo "kube_es -p -c $ENV -m GET \"w_''${ORG}__/_doc/''${DOCID}?_source_excludes=vectorized_content,vectorized_title\" | jq"
kube_es -p -c $ENV -m GET "w_''${ORG}__/_doc/''${DOCID}?_source_excludes=vectorized_content,vectorized_title" | jq