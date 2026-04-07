#!/bin/bash

# --- 1. Cargar Configuración ---
if [ -f "config/config.env" ]; then
    source config/config.env
    echo "✅ Configuración cargada desde config/config.env"
else
    echo "❌ Error: No se encontró el archivo de configuración."
    exit 1
fi

LOG_DEPLOY="logs/deploy.log"
echo "[$(date +"%Y-%m-%d %H:%M:%S")] 🚀 INICIANDO DESPLIEGUE CON VARIABLES DE ENTORNO" | tee -a "$LOG_DEPLOY"

# --- 2. Ejecución de Scripts usando las variables cargadas ---

echo "--- Paso 1: Gestión de EC2 ($INSTANCE_ID) ---" | tee -a "$LOG_DEPLOY"
# Aquí usamos la variable $INSTANCE_ID que viene del archivo .env
python3 ec2/gestionar_ec2.py iniciar "$INSTANCE_ID" | tee -a "$LOG_DEPLOY"

echo "--- Paso 2: Respaldo en S3 ($BUCKET_NAME) ---" | tee -a "$LOG_DEPLOY"
# Aquí usamos $DIRECTORY y $BUCKET_NAME del archivo .env
./s3/backup_s3.sh "$DIRECTORY" "$BUCKET_NAME" | tee -a "$LOG_DEPLOY"

echo "[$(date +"%Y-%m-%d %H:%M:%S")] ✅ PROCESO FINALIZADO." | tee -a "$LOG_DEPLOY"
