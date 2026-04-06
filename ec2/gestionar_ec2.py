import sys
import boto3

def main():
    # Validamos que al menos se haya enviado la acción (listar, iniciar, etc.)
    if len(sys.argv) < 2:
        print("❌ Error: Faltan parámetros.")
        print("💡 Uso: python3 gestionar_ec2.py [listar|iniciar|detener|terminar] [instance_id]")
        sys.exit(1)

    # Atrapamos la acción (ej. 'iniciar')
    accion = sys.argv[1].lower()
    ec2 = boto3.client('ec2', region_name='us-east-1')

    # Lógica para 'listar' (no requiere ID)
    if accion == 'listar':
        print("\n--- Inventario de Instancias EC2 ---")
        respuesta = ec2.describe_instances()
        for reserva in respuesta['Reservations']:
            for instancia in reserva['Instances']:
                id_instancia = instancia['InstanceId']
                estado = instancia['State']['Name']
                print(f"ID: {id_instancia} | Estado: {estado}")

    # Lógica para acciones que SÍ requieren ID
    elif accion in ['iniciar', 'detener', 'terminar']:
        if len(sys.argv) < 3:
            print(f"❌ Error: La acción '{accion}' requiere un ID de instancia.")
            print(f"💡 Ejemplo: python3 gestionar_ec2.py {accion} i-1234567890abcdef0")
            sys.exit(1)
        
        # Atrapamos el ID de la instancia
        instance_id = sys.argv[2]
        
        try:
            if accion == 'iniciar':
                print(f"Iniciando instancia {instance_id}...")
                ec2.start_instances(InstanceIds=[instance_id])
            elif accion == 'detener':
                print(f"Deteniendo instancia {instance_id}...")
                ec2.stop_instances(InstanceIds=[instance_id])
            elif accion == 'terminar':
                print(f"Terminando instancia {instance_id}...")
                ec2.terminate_instances(InstanceIds=[instance_id])
            
            print("✅ Comando ejecutado con éxito.")
        except Exception as e:
            print(f"❌ Error de AWS: {e}")

    else:
        print(f"❌ Acción '{accion}' no reconocida.")

if __name__ == '__main__':
    main()
