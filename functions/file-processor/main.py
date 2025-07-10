import json
import base64
from google.cloud import storage
import logging
import os

# Configurar logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

def process_file(event, context):
    """
    Función que se ejecuta cuando llega un archivo al bucket
    """
    try:
        # Decodificar el mensaje de Pub/Sub
        pubsub_message = base64.b64decode(event['data']).decode('utf-8')
        message_data = json.loads(pubsub_message)
        
        logger.info(f"Mensaje recibido: {message_data}")
        
        # Obtener información del archivo (estructura correcta)
        bucket_name = message_data['bucket']
        file_name = message_data['name']
        
        logger.info(f"Procesando archivo: {file_name} del bucket: {bucket_name}")
        
        # Inicializar cliente de Storage
        client = storage.Client()
        
        # Obtener el archivo del bucket de entrada
        input_bucket = client.bucket(bucket_name)
        blob = input_bucket.blob(file_name)
        
        # Leer el contenido del archivo
        content = blob.download_as_text()
        
        # Procesar el archivo (ejemplo: agregar timestamp y info de procesamiento)
        processed_content = f"""ARCHIVO PROCESADO
Timestamp: {context.timestamp}
Archivo original: {file_name}
Bucket origen: {bucket_name}
Tamaño original: {len(content)} caracteres

=== CONTENIDO ORIGINAL ===
{content}
=== FIN CONTENIDO ===
"""
        
        # Subir archivo procesado al bucket de salida
        output_bucket_name = os.environ.get('OUTPUT_BUCKET', 'test-gcp-processed-files-dev')
        output_bucket = client.bucket(output_bucket_name)
        output_blob = output_bucket.blob(f"processed_{file_name}")
        output_blob.upload_from_string(processed_content)
        
        logger.info(f"Archivo procesado y guardado como: processed_{file_name}")
        
        return f"Archivo {file_name} procesado exitosamente"
        
    except Exception as e:
        logger.error(f"Error procesando archivo: {str(e)}")
        raise e