## CDN Test Script
Dieses Skript dient zur Netzwerk- und Performance-Analyse von Content Delivery Networks (CDNs). Unterstützt werden zwei Plattformen:
- Linux/macOS (Bash)
- Windows (PowerShell)

Funktionen des Skripts
Für jede vordefinierte URL werden folgende Tests durchgeführt:
-  Ping-Test – misst die Netzwerkantwortzeit zum Zielhost.
-  Traceroute – zeigt die Route (max. 15 Hops) zum Zielhost.
-  HTTP-Request – prüft Statuscode, Antwortzeit und ggf. Dateigröße.
-  Cache-Header – extrahiert typische Cache-relevante HTTP-Header (z. B. x-cache, age, cache-control).

Version 1: Bash (Linux/macOS)
Voraussetzungen
- Bash-Shell
- Tools: ping, traceroute, curl
- Schreibrechte im aktuellen Verzeichnis

Installation
Speichere das Skript z. B. als cdn_test.sh.

Ausführung
chmod +x cdn_test.sh
./cdn_test.sh

Die Ergebnisse werden in einer Datei wie cdn_test_06-07-2025_14-52-11.txt gespeichert.

Anpassung
URLs können direkt im Skript über das urls=(...) Array angepasst werden.

# Version 2: PowerShell (Windows)
Voraussetzungen
- Windows 10/11 mit PowerShell
- Internetzugang
- Schreibrechte im Skriptverzeichnis

Installation
Speichere das Skript z. B. als cdn_test.ps1.

Ausführung
Öffne PowerShell (als Administrator empfohlen).

Gehe ins Verzeichnis mit dem Skript.

Starte das Skript mit:
.\cdn_test.ps1

Hinweis: Falls die Ausführung blockiert wird, musst du ggf. einmalig die Ausführungsrichtlinie ändern:

Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

Ergebnis:
Die Ergebnisse befinden sich in einer Datei namens z. B. cdn_test_06-07-2025_14-52-11.txt.

Anpassung
URLs können im $urls = @(...) Block angepasst oder erweitert werden.

Beispielhafte getestete CDNs
- Akamai
- Cloudflare CDN
- jsDelivr
- Google Hosted Libraries
- TikTok / muscdn
- Google Video CDN

Hinweise
- Die Skripte eignen sich für Einzelanalysen oder Performancevergleiche von CDNs.
- Sie sollten nicht dauerhaft im Dauereinsatz laufen, um Serverlast zu vermeiden.
- Alle Ausgaben sind rein informativ und erfordern keine zusätzlichen Tools.
