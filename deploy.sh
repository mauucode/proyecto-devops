#!/bin/bash

# --- 1. Configuración de Logs ---
LOG_DEPLOY="logs/deploy.log"
echo "[$(date +"%Y-%m-%d %H:%M:%S")] 🚀 INICIANDO DESPLIEGUE GLOBAL (CI/CD SIMULADO)" | tee -a "$LOG_DEPLOY"

# --- 2. Validación de Parámetros (Cero Hardcoding) ---
# Esperamos: accion, id_instancia, directorio_respaldo, nombre_bucket
if [ "$#" -ne 4 ]; then
    echo "❌ Error: Faltan parámetros." | tee -a "$LOG_DEPLOY"
    echo "💡 Uso: ./deploy.sh <accion_ec2> <id_instancia> <dir_respaldo> <bucket_s3>"
    exit 1
fi

ACCION_EC2=$1
ID_INSTANCIA=$2
DIR_RESPALDO=$3
BUCKET_S3=$4

# --- 3. Ejecución del Script de Python (Gestión EC2) ---
echo "--- Paso 1: Gestión de Infraestructura (Python) ---" | tee -a "$LOG_DEPLOY"
python3 ec2/gestionar_ec2.py "$ACCION_EC2" "$ID_INSTANCIA" | tee -a "$LOG_DEPLOY"

if [ ${PIPESTATUS[0]} -ne 0 ]; then
    echo "❌ Error en la fase de EC2. Abortando deploy." | tee -a "$LOG_DEPLOY"
    exit 1
fi

# --- 4. Ejecución del Script de Bash (Respaldo S3) ---
echo "--- Paso 2: Respaldo de Datos (Bash) ---" | tee -a "$LOG_DEPLOY"
./s3/backup_s3.sh "$DIR_RESPALDO" "$BUCKET_S3" | tee -a "$LOG_DEPLOY"

if [ ${PIPESTATUS[0]} -ne 0 ]; then
    echo "❌ Error en la fase de S3. Revisa los logs." | tee -a "$LOG_DEPLOY"
    exit 1
fi

echo "[$(date +"%Y-%m-%d %H:%M:%S")] ✅ DESPLIEGUE FINALIZADO EXITOSAMENTE." | tee -a "$LOG_DEPLOY"
