bash
#!/usr/bin/with-contenv bashio

# 1. Passwort aus der HA-Konfiguration auslesen
SECRET=$(bashio::config 'shared_secret')

echo "Konfiguriere FreeRADIUS für Omada..."

# 2. Clients-Datei sauber neu schreiben
# Das Sternchen '*' erlaubt Anfragen von JEDER IP-Adresse im Netzwerk
cat << EOF > /etc/raddb/clients.conf
client omada_clients {
    ipaddr   = *
    secret   = ${SECRET}
}
EOF

echo "RADIUS-Client erfolgreich eingerichtet. Starte Server..."

# 3. FreeRADIUS im Vordergrund starten (ohne -X Debugging, um Passwort-Logs sauber zu halten)
exec radiusd -f
