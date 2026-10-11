bash
#!/usr/bin/with-contenv bashio

# Masterpasswort aus der HA-Konfiguration auslesen
SECRET=$(bashio::config 'shared_secret')

echo "Konfiguriere FreeRADIUS für Omada..."

# Bestehende Clients-Datei leeren und Omada-Netzwerk erlauben
cat << EOF > /etc/raddb/clients.conf
client local_network {
    ipaddr   = 0.0.0.0/0
    secret   = ${SECRET}
}
EOF

echo "RADIUS-Client erfolgreich eingerichtet. Starte Server..."

# FreeRADIUS im Vordergrund starten
exec radiusd -f -X
