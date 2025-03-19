# Memoria de la Base de Datos Redis para la selección de avatares


 **Iniciar el contenedor:**
   - Levantar el contenedor local para trabajar con jupyter-notebook:
     ```bash
     docker compose up -d
     ```

Una vez iniciado, nos registramos con la contraseña que aparece en el archivo `Dockerfile` dentro de la carpeta `dockerimg`.

> ⚠️ **Advertencia:** Es necesario subir al contenedor de trabajo Jupyter Notebook las imágenes `cara.png` y `hulk.webp`.

## Implementación del servicio Redis
... 



## Comparación de los resultados

Hemos utilizado **dos índices** para nuestras métricas:  

- **Índice FLAT**: No tiene ninguna estructura de optimización y busca en toda la base de datos al realizar consultas de similitud.  
- **Índice HNSW**: Usa una estructura en grafo para acelerar la búsqueda, siendo más eficiente en grandes conjuntos de datos.  

Las **métricas utilizadas** son:  

- **Métrica coseno**: Evalúa la alineación de los vectores sin importar su magnitud.  
- **Norma L2 (métrica euclídea)**: Mide la diferencia absoluta entre dos vectores y es sensible a la magnitud.  

### **Resultados de la búsqueda de fotos similares**  
Al buscar imágenes similares, los resultados obtenidos (imágenes consideradas similares) serán los mismos sin importar la métrica o el índice utilizado.  

### **Resultados al buscar imágenes basadas en un prompt**  
Cuando solicitamos imágenes basadas en un **prompt** (en este caso, avatares que contengan la palabra `caballeros`), los resultados sí varían:  

- **Usando la distancia euclídea**:  
  - Los resultados son aparentemente buenos, sin importar el tipo de índice utilizado.  

- **Usando la distancia coseno**:  
  - Los resultados varían más.  
  - Con el **índice FLAT**, a excepción del primero, los resultados no parecen estar relacionados con la solicitud.  
  - Con el **índice basado en grafos (HNSW)**, se obtiene un mejor desempeño, logrando encontrar caballeros en las tres imágenes obtenidas.  
