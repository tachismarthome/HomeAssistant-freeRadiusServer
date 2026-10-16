#!/usr/bin/env bash

echo "Lese Konfiguration aus options.json..."

# Home Assistant speichert die Benutzeroberflächen-Optionen standardmäßig in dieser JSON-Datei
if [ -f "/data/options.json" ]; then
    # Extrahiert das Passwort sauber aus der JSON-Datei
    SECRET=$(sed -n 's/.*"shared_secret": *"\([^"]*\)".*/\1/p' /data/options.json)
fi

# Wenn kein Passwort gefunden wurde, bricht das Skript aus Sicherheitsgründen ab
if [ -z "$SECRET" ]; then
    echo "FEHLER: Es wurde kein Passwort in der Benutzeroberfläche eingetragen! Breche ab."
    exit 1
else
    echo "Passwort erfolgreich aus der Benutzeroberfläche geladen."
fi

echo "Konfiguriere FreeRADIUS für Omada..."

# Berechtigungen für die Konfigurationsdatei setzen
chmod 640 /etc/raddb/clients.conf

# Clients-Datei schreiben
cat << EOF > /etc/raddb/clients.conf
client omada_clients {
    ipaddr   = *
    secret   = ${SECRET}
}
EOF

echo "RADIUS-Client erfolgreich eingerichtet. Starte Server..."
exec radiusd -f
