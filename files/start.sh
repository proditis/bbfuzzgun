#!/bin/bash
# Perform needed checks automaticaly
REPORTS_DIR=/checks/reports
function do_gixy
{
  echo "Starting gixy checks"
  for _ngx_conf in /checks/nginx/*.conf;do
    echo "Parsing jinja2 $_ngx_conf => ${_ngx_conf}.parsed"
    /tools/bin/atemplate -e "TEMPLATE=${_ngx_conf}" -e "OUTPUT=${_ngx_conf}.parsed" -e fqdn=${FQDN} -e ipv4=${IPV4}
    REPORT_JSON="${REPORTS_DIR}/$(basename ${_ngx_conf})-report.json"
    echo "gixy file ${_ngx_conf}.parsed"
    gixy --disable-includes -o "${REPORT_JSON}" -f json "${_ngx_conf}.parsed" && echo "Report saved [${REPORT_JSON}]"
    echo "b25b294cb4deb69ea00a4c3cf3113904801b6015e5956bd019a8570b1fe1d6040e944ef3cdee16d0a46503ca6e659a25f21cf9ceddc13f352a3c98138c15d6af  ${REPORT_JSON}"|sha512sum -c --status 
    if [ $? -eq 0 ]; then
      echo "Empty report deleting..."
      rm -f "${REPORTS_DIR}/$(basename ${_ngx_conf})-report.json"
    fi
  done
}
# If mount|grep '/checks/nginx/'
mkdir -p "${REPORTS_DIR}"
mount|grep '/checks/nginx/' >/dev/null && do_gixy

#ffuf -t 2 -p 0.5  -w /wordlists/all-files.txt  -H "${HEADER}" -recursion -recursion-depth 2 -u ${URL}FUZZ -mc 500,501,502,504,505
ffuf -w /wordlists/all-files.txt  -H "${HEADER}" -recursion -recursion-depth 2 -u ${URL}FUZZ -mc 500,501,502,504,505
#for endpoint in $(grep FUZZ /checks/urllist);do 
#  ffuf -v -w /wordlists/all-files.txt  -H "${HEADER}" -u "${endpoint}" -mc 500,501,502,504,505 -or -of json -od /checks/reports || echo "Failed ${TARGET}"
#done

# Check rate limits work
#ffuf -t 2 -p 0.5  -w /checks/ratelimit-urls.txt  -H "${HEADER}" -recursion -recursion-depth 2 -u ${URL}FUZZ -mc 503