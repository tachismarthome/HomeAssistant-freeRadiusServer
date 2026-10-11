#!/usr/bin/env bash

echo "Lese Konfiguration ein..."

if [ ! -z "$SUPERVISOR_SHARED_SECRET" ]; then
    SECRET=$SUPERVISOR_SHARED_SECRET
elif [ ! -z "$shared_secret" ]; then
    SECRET=$shared_secret
elif [ ! -z "$SHARED_SECRET" ]; then
    SECRET=$SHARED_SECRET
else
    SECRET="OmadaMasterPasswort123"
fi

echo "Konfiguriere FreeRADIUS für Omada..."

# Verzeichnisberechtigungen sicherstellen
chmod 640 /etc/raddb/clients.conf

# Clients-Datei schreiben
cat << EOF > /etc/raddb/clients.conf
client omada_clients {
    ipaddr   = 0.0.0.0/0
    secret   = ${SECRET}
}
EOF

echo "RADIUS-Client erfolgreich eingerichtet. Starte Server im Debug-Modus..."

# -X schaltet den Debug-Modus ein, damit wir eintreffende Pakete im Log sehen!
exec radiusd -f -X
