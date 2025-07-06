#!/bin/bash

# Aktueller Timestamp für Dateinamen
timestamp=$(date +"%d-%m-%Y_%H-%M-%S")
output_file="cdn_test_${timestamp}.txt"

# Liste an stabilen Test-URLs (nur statische Inhalte oder gut reproduzierbare Domains)
urls=(
  "https://a248.e.akamai.net"                                                # Akamai Testdomain
  "https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"        # Cloudflare CDN
  "https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css"  # jsDelivr CDN
  "https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"         # Google CDN
  "https://www.cloudflare.com/cdn-cgi/trace"                                 # Cloudflare Trace-Seite
)

echo "-------------------------------------------" | tee -a "$output_file"
echo "CDN-KPI Test beginnt am $(date +"%d-%m-%Y %H:%M:%S")" | tee -a "$output_file"
echo "-------------------------------------------" | tee -a "$output_file"

for url in "${urls[@]}"
do
  echo | tee -a "$output_file"
  echo "Teste URL: $url" | tee -a "$output_file"
  domain=$(echo "$url" | awk -F/ '{print $3}')

  echo "--- Ping Test ---" | tee -a "$output_file"
  ping -c 3 "$domain" | tee -a "$output_file"

  echo "--- Traceroute (max. 15 Hops, Abbruch nach 5 Timeouts) ---" | tee -a "$output_file"

  consecutive_timeouts=0
  max_timeouts=5
  max_hops=15

  for ((hop=1; hop<=max_hops; hop++))
  do
    line=$(traceroute -n -f $hop -m $hop -q 1 "$domain" 2>/dev/null | tail -n 1)
    echo "$line" | tee -a "$output_file"

    if echo "$line" | grep -q "\\s\\s\*"; then
      ((consecutive_timeouts++))
    else
      consecutive_timeouts=0
    fi

    if [ "$consecutive_timeouts" -ge "$max_timeouts" ]; then
      echo ">> Traceroute abgebrochen nach $max_timeouts aufeinanderfolgenden Timeouts." | tee -a "$output_file"
      break
    fi
  done

  echo "--- HTTP-Request & TTFB & Cache-Status ---" | tee -a "$output_file"
  curl -o /dev/null -s -w "TTFB: %{time_starttransfer}s\nTotal: %{time_total}s\nHTTP-Code: %{http_code}\n" -I "$url" | tee -a "$output_file"

  echo "--- Cache-Hit Header (falls vorhanden) ---" | tee -a "$output_file"
  curl -s -I "$url" | grep -i -E "x-cache|cf-cache-status|age|cache-control" | tee -a "$output_file"

  echo "-------------------------------------------" | tee -a "$output_file"
done

echo "Test abgeschlossen. Ergebnisse gespeichert in $output_file"