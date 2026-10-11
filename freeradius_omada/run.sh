#!/usr/bin/env bash

echo "Lese Konfiguration aus options.json..."

# Home Assistant speichert die Benutzeroberflächen-Optionen standardmäßig in dieser JSON-Datei
if [ -f "/data/options.json" ]; then
    # Extrahiert das Passwort sauber aus der JSON-Datei
    SECRET=$(sed -n 's/.*"shared_secret": *"\([^"]*\)".*/\1/p' /data/options.json)
fi

# Fallback, falls die Datei wider Erwarten nicht existiert oder leer ist
if [ -z "$SECRET" ]; then
    echo "WARNUNG: Passwort konnte nicht aus der UI gelesen werden. Nutze Standard-Fallback!"
    SECRET="MeinSicheresMasterPasswort123"
else
    echo "Passwort erfolgreich aus der Benutzeroberfläche geladen."
fi

echo "Konfiguriere FreeRADIUS für Omada..."

chmod 640 /etc/raddb/clients.conf

# Clients-Datei schreiben
cat << EOF > /etc/raddb/clients.conf
client omada_clients {
    ipaddr   = 0.0.0.0/0
    secret   = ${SECRET}
}
EOF

echo "RADIUS-Client erfolgreich eingerichtet. Starte Server..."
exec radiusd -f
