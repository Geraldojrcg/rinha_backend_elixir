#!/bin/bash
# Rodar migration e seed resulta em startup mais lento
# echo "Starting migrations..."
# eval /app/bin/rinha_backend eval RinhaBackend.Release.migrate

# echo "Seeding database..."
# eval /app/bin/rinha_backend eval RinhaBackend.Release.seed

# start the elixir application
echo "Starting application"
exec /app/bin/rinha_backend start