# Use a base image with Java and Gradle
FROM gradle:jdk21

# Set the working directory
WORKDIR /app

# Copy the Gradle files
COPY build.gradle settings.gradle /app/

# Copy the source code
COPY src /app/src

# Copy or download the TopoLibrary JAR and Garmin FIT SDK JAR
# COPY cubetrek_data/libs/fit.jar /app/libs/
RUN mkdir -p /app/libs && \
    curl -sSL https://developer.garmin.com/downloads/fit/sdk/FitSDKRelease_21.171.00.zip -o /tmp/fit_sdk.zip && \
    unzip -j /tmp/fit_sdk.zip "java/fit.jar" -d /app/libs && \
    rm /tmp/fit_sdk.zip

# COPY cubetrek_data/libs/TopoLibrary-2.2-SNAPSHOT.jar /app/libs/
RUN mkdir -p /app/libs && \
    curl -sSL https://github.com/r-follador/TopoLibrary/releases/download/v2.3/TopoLibrary-2.3-SNAPSHOT.jar \
    -o /app/libs/TopoLibrary-2.3-SNAPSHOT.jar


# Download dependencies
RUN /bin/bash -c "gradle --no-daemon dependencies"

# Build the application without running tests
RUN /bin/bash -c "gradle --no-daemon build -x test"

# Expose the port for the application
EXPOSE 8080

# Set the entry point to run the application
ENTRYPOINT ["java", "-jar", "/app/build/libs/cubetrek-1.1-SNAPSHOT.jar"]
