#!/usr/bin/env bash

echo "Lese Konfiguration ein..."

# Verschiedene Wege des Supervisors abfangen, falls die Variable anders benannt ist
if [ ! -z "$SUPERVISOR_SHARED_SECRET" ]; then
    SECRET=$SUPERVISOR_SHARED_SECRET
elif [ ! -z "$shared_secret" ]; then
    SECRET=$shared_secret
elif [ ! -z "$SHARED_SECRET" ]; then
    SECRET=$SHARED_SECRET
else
    # Letzter Rettungsanker: Falls alles leer ist, ein Fallback setzen
    SECRET="OmadaMasterPasswort123"
fi

echo "Konfiguriere FreeRADIUS für Omada..."

# Clients-Datei schreiben
cat << EOF > /etc/raddb/clients.conf
client omada_clients {
    ipaddr   = *
    secret   = ${SECRET}
}
EOF

echo "RADIUS-Client erfolgreich eingerichtet. Starte Server..."

# FreeRADIUS starten
exec radiusd -f
