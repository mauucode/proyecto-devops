import boto3

def listar_instancias():
    print("Iniciando conexión con AWS EC2...")
    # Conectamos con el servicio EC2
    ec2 = boto3.client('ec2', region_name='us-east-1')
    
    try:
        # Obtenemos la información de las instancias
        respuesta = ec2.describe_instances()
        print("\n--- Inventario de Instancias EC2 ---")
        
        for reserva in respuesta['Reservations']:
            for instancia in reserva['Instances']:
                id_instancia = instancia['InstanceId']
                estado = instancia['State']['Name']
                
                print(f"ID: {id_instancia} | Estado: {estado}")
                
    except Exception as e:
        print(f"Ocurrió un error: {e}")

if __name__ == '__main__':
    listar_instancias()
