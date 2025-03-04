#!/bin/bash

# Esperar hasta que Cassandra esté listo
until cqlsh -e "describe keyspaces"; do
    echo "Esperando a Cassandra..."
    sleep 5
done

# Ejecutar el archivo CQL
echo "Ejecutando script de inicialización..."
cqlsh -f /scripts/tu_archivo.cql
echo "Inicialización completada."
