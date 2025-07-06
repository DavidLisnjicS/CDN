$timestamp = Get-Date -Format dd-MM-yyyy_HH-mm-ss
$outputFile = cdn_test_$timestamp.txt

$urls = @(
    httpsv19.muscdn.com,
    httpscdnjs.cloudflare.comajaxlibsjquery3.6.0jquery.min.js,
    httpsa248.e.akamai.net,
    httpscdn.jsdelivr.netnpmbootstrap@5.1.3distcssbootstrap.min.css,
    httpsajax.googleapis.comajaxlibsjquery3.6.0jquery.min.js,
    httpsr1---sn-5uaeznsl.googlevideo.com
)

-------------------------------------------  Tee-Object -FilePath $outputFile -Append
CDN-KPI Test beginnt am $(Get-Date)  Tee-Object -FilePath $outputFile -Append
-------------------------------------------  Tee-Object -FilePath $outputFile -Append

foreach ($url in $urls) {
      Tee-Object -FilePath $outputFile -Append
    Teste URL $url  Tee-Object -FilePath $outputFile -Append

    $uri = [System.Uri]$url
    $domain = $uri.Host

    --- Ping Test ---  Tee-Object -FilePath $outputFile -Append
    ping -n 3 $domain  Tee-Object -FilePath $outputFile -Append

    --- Traceroute (max. 15 Hops) ---  Tee-Object -FilePath $outputFile -Append
    tracert -h 15 $domain  Tee-Object -FilePath $outputFile -Append

    --- HTTP-Request & TTFB ---  Tee-Object -FilePath $outputFile -Append
    try {
        $request = Invoke-WebRequest -Uri $url -Method Head -TimeoutSec 10
        HTTP-Code $($request.StatusCode)  Tee-Object -FilePath $outputFile -Append
        if ($request.RawContentLength -gt 0) {
            Inhalt empfangen $($request.RawContentLength) Bytes  Tee-Object -FilePath $outputFile -Append
        }
    } catch {
        Fehler bei HTTP-Request $_  Tee-Object -FilePath $outputFile -Append
    }

    --- Cache-Header (falls vorhanden) ---  Tee-Object -FilePath $outputFile -Append
    try {
        $headers = Invoke-WebRequest -Uri $url -Method Head -TimeoutSec 10
        $headers.Headers  Where-Object { $_.Name -match cacheagex-cachecf-cache-status }  Format-Table  Out-String  Tee-Object -FilePath $outputFile -Append
    } catch {
        Fehler beim Lesen von Headern $_  Tee-Object -FilePath $outputFile -Append
    }

    -------------------------------------------  Tee-Object -FilePath $outputFile -Append
}

Test abgeschlossen. Ergebnisse gespeichert in $outputFile  Tee-Object -FilePath $outputFile -Append