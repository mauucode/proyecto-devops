#!/bin/bash

# --- 1. Generación de logs inicial y variables ---
LOG_FILE="logs/backup.log"
FECHA=$(date +"%Y-%m-%d_%H-%M-%S")

# Función para registrar logs en pantalla y en archivo al mismo tiempo
registrar_log() {
    echo "[$(date +"%Y-%m-%d %H:%M:%S")] $1" | tee -a "$LOG_FILE"
}

registrar_log "🚀 INICIANDO PROCESO DE RESPALDO..."

# --- 2. Validación de parámetros  ---
if [ "$#" -ne 2 ]; then
    registrar_log "❌ Error: Faltan parámetros."
    echo "💡 Uso: ./s3/backup_s3.sh <directorio_a_respaldar> <nombre_del_bucket_s3>"
    exit 1
fi

DIRECTORIO=$1
BUCKET=$2
ARCHIVO_ZIP="backup_${FECHA}.tar.gz"

# --- 3. Validación de directorio ---
if [ ! -d "$DIRECTORIO" ]; then
    registrar_log "❌ Error: El directorio '$DIRECTORIO' no existe."
    exit 1
fi

# --- 4. Compresión de archivos ---
registrar_log "⏳ Comprimiendo el directorio '$DIRECTORIO'..."
tar -czf "$ARCHIVO_ZIP" "$DIRECTORIO" 2>/dev/null

if [ $? -ne 0 ]; then
    registrar_log "❌ Error crítico al comprimir los archivos."
    exit 1
fi
registrar_log "✅ Archivo comprimido con éxito: $ARCHIVO_ZIP"

# --- 5. Subida a S3 ---
registrar_log "⏳ Subiendo a AWS S3 (s3://$BUCKET/)..."
aws s3 cp "$ARCHIVO_ZIP" "s3://$BUCKET/" >> "$LOG_FILE" 2>&1

if [ $? -eq 0 ]; then
    registrar_log "✅ Respaldo subido a S3 con éxito."
    # Limpieza: Borramos el zip local para no consumir espacio en la EC2
    rm "$ARCHIVO_ZIP"
    registrar_log "🧹 Archivo temporal eliminado de EC2. Respaldo finalizado."
else
    registrar_log "❌ Error al subir a S3. Revisa tus permisos o el nombre del bucket."
    exit 1
fi
