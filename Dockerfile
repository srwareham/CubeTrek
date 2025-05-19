# Use a base image with Java and Gradle
FROM gradle:jdk21

# Set the working directory
WORKDIR /app

# Copy the Gradle files
COPY build.gradle settings.gradle /app/

# Copy the source code
COPY src /app/src

# Copy the TopoLibrary JAR and Garmin FIT SDK JAR
COPY externaljars/TopoLibrary-2.2-SNAPSHOT.jar /app/libs/
COPY externaljars/fit.jar /app/libs/

# Download dependencies
RUN /bin/bash -c "gradle --no-daemon dependencies"

# Build the application without running tests
RUN /bin/bash -c "gradle --no-daemon build -x test"

# Expose the port for the application
EXPOSE 8080

# Set the entry point to run the application
ENTRYPOINT ["java", "-jar", "/app/build/libs/cubetrek-1.1-SNAPSHOT.jar"]
