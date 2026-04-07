# 🚀 Proyecto de Automatización DevOps - AWS (EC2 & S3)

Este proyecto demuestra un flujo de trabajo profesional de **CI/CD simulado** utilizando herramientas de AWS, Python y Bash. Permite la gestión dinámica de instancias EC2 y la automatización de respaldos en buckets de S3 mediante una arquitectura de "Cero Hardcoding".

---

## 📋 Descripción del Proyecto
El sistema se compone de tres módulos principales:
1.  **Gestor EC2 (Python/Boto3):** Permite listar, iniciar, detener y terminar instancias mediante parámetros de terminal.
2.  **Backup S3 (Bash):** Comprime directorios locales y los carga a AWS S3, generando logs de auditoría.
3.  **Orquestador (Deploy.sh):** Sincroniza ambos procesos cargando variables desde un archivo de configuración `.env`.

---

## 🛠️ Instrucciones de Uso

### 1. Configuración Inicial
Define tus variables en el archivo `config/config.env`:
```bash
INSTANCE_ID="i-0xxxxxxxxxxxx"
BUCKET_NAME="tu-bucket-nombre"
DIRECTORY="carpeta_a_respaldar"
REGION="us-east-1"
```

### 2. Ejecución del Orquestador (Recomendado)
Para ejecutar todo el flujo de inicio de instancia y respaldo:
```bash
./deploy.sh
```

### 3. Uso Individual de Scripts
- Gestión de EC2: `python3 ec2/gestionar_ec2.py [listar|iniciar|detener|terminar] [instance_id]`
- Respaldo S3: `./s3/backup_s3.sh [directorio] [nombre_bucket]`

---

## 🔄 Flujo Git (Estrategia de Ramas)
El desarrollo siguió una metodología de Feature Branches para asegurar la estabilidad del código:
- `main`: Rama de producción (Código estable).
- `develop`: Rama de integración.
- `feature/*`: Ramas temporales para desarrollo de funcionalidades específicas.

**Historial de Commits Progresivos:** Se utilizaron mensajes descriptivos y atómicos (ej. `feat: manejo de errores`, `feat: integración con S3`) para cumplir con las mejores prácticas de documentación de cambios.

---

## 📂 Estructura del Repositorio
- `ec2/`: Scripts de Python para infraestructura.
- `s3/`: Scripts de Bash para almacenamiento.
- `config/`: Archivos de configuración y variables de entorno.
- `logs/`: Registros de ejecución y auditoría.
- `deploy.sh`: Script maestro de orquestación.
