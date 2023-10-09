# Use the official .NET SDK as a build image
FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build

# Set the working directory in the container
WORKDIR /app

# Copy the project file and restore dependencies
COPY *.csproj ./
RUN dotnet restore

# Copy the remaining source code
COPY . ./

# Build the application
RUN dotnet publish -c Release -o out

# Use the official .NET runtime as a runtime image
FROM mcr.microsoft.com/dotnet/runtime:5.0 AS runtime

# Set the working directory in the container
WORKDIR /app

# Copy the published application from the build image
COPY --from=build /app/out ./

# Specify the entry point for the application
ENTRYPOINT ["dotnet", "YourConsoleApp.dll"]
