# ====== Etapa 1: Fase de construcción (temporal) ======
# Usamos JDK 21 que es la versión LTS más estable para entornos de producción
FROM maven:3.9-eclipse-temurin-21 AS imagen_construccion

# Definimos el directorio de trabajo
WORKDIR /app

# Copiamos archivos necesarios para la construcción
COPY pom.xml .
COPY src ./src

# Construimos el paquete saltando los tests para acelerar el proceso
RUN mvn clean package -DskipTests

# ====== Etapa 2: Fase de ejecución (Imagen final) ======
# Usamos JRE 21 para ejecutar el .jar generado
FROM eclipse-temurin:21-jre-alpine AS imagen_ejecucion

WORKDIR /app

# Copiamos el .jar desde la etapa de construcción
# Usamos el comodín *.jar para que no importe el nombre exacto definido en el pom.xml
COPY --from=imagen_construccion /app/target/*.jar app.jar

# Exponemos el puerto de la aplicación (Spring Boot suele usar 8080)
EXPOSE 8080

# Comando para arrancar la aplicación
ENTRYPOINT ["java", "-jar", "app.jar"]
