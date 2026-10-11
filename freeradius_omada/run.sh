#!/usr/bin/env bash
# Sichert ab, dass echte Bash genutzt wird

# Lädt die Home Assistant Bashio-Bibliothek manuell
source /usr/lib/bashio/bashio.sh

# Passwort aus der HA-Konfiguration auslesen
SECRET=$(bashio::config 'shared_secret')

echo "Konfiguriere FreeRADIUS für Omada..."

# Clients-Datei sauber neu schreiben
cat << EOF > /etc/raddb/clients.conf
client omada_clients {
    ipaddr   = *
    secret   = ${SECRET}
}
EOF

echo "RADIUS-Client erfolgreich eingerichtet. Starte Server..."

# FreeRADIUS im Vordergrund starten
exec radiusd -f
