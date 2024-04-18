# Etapa de construcción
FROM gradle:jdk21 AS TEMP_BUILD_IMAGE

# Establecer el directorio de la aplicación
ENV APP_HOME=/usr/app/
WORKDIR $APP_HOME

# Copiar los archivos de código fuente Java
COPY . .

# Compilar los proyectos utilizando Gradle

WORKDIR $APP_HOME/demo
RUN gradle clean build

WORKDIR $APP_HOME/demo1
RUN gradle clean build

WORKDIR $APP_HOME/demo2
RUN gradle clean build

WORKDIR $APP_HOME/demo3
RUN gradle clean build

WORKDIR $APP_HOME/demo4
RUN gradle clean build

WORKDIR $APP_HOME/demo5
RUN gradle clean build


# Etapa de producción
FROM openjdk:21-jdk-slim

# Establecer el directorio de la aplicación
ENV APP_HOME=/usr/app/
WORKDIR $APP_HOME

# Copiar los JARs construidos en la etapa anterior

COPY --from=TEMP_BUILD_IMAGE $APP_HOME/demo/build/libs/demo-0.0.1-SNAPSHOT.jar $APP_HOME/demo-0.0.1-SNAPSHOT.jar
COPY --from=TEMP_BUILD_IMAGE $APP_HOME/demo1/build/libs/demo1-0.0.1-SNAPSHOT.jar $APP_HOME/demo1-0.0.1-SNAPSHOT.jar
COPY --from=TEMP_BUILD_IMAGE $APP_HOME/demo2/build/libs/demo2-0.0.1-SNAPSHOT.jar $APP_HOME/demo2-0.0.1-SNAPSHOT.jar
COPY --from=TEMP_BUILD_IMAGE $APP_HOME/demo3/build/libs/demo3-0.0.1-SNAPSHOT.jar $APP_HOME/demo3-0.0.1-SNAPSHOT.jar
COPY --from=TEMP_BUILD_IMAGE $APP_HOME/demo4/build/libs/demo4-0.0.1-SNAPSHOT.jar $APP_HOME/demo4-0.0.1-SNAPSHOT.jar
COPY --from=TEMP_BUILD_IMAGE $APP_HOME/demo5/build/libs/demo5-0.0.1-SNAPSHOT.jar $APP_HOME/demo5-0.0.1-SNAPSHOT.jar

# Instalar Nginx
RUN apt-get update && apt-get install -y nginx

# Copiar el archivo de configuración de Nginx
COPY nginx.conf /etc/nginx/nginx.conf

# Exponer puertos de los microservicios
EXPOSE 8080

# Comando para ejecutar microservicios (confía en systemd para iniciar Nginx)
CMD ["java", "-jar", "demo1-0.0.1-SNAPSHOT.jar", "demo2-0.0.1-SNAPSHOT.jar", "demo3-0.0.1-SNAPSHOT.jar", "demo4-0.0.1-SNAPSHOT.jar", "demo5-0.0.1-SNAPSHOT.jar"]
