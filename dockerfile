FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src
COPY *.sln .
COPY ./Client/*.csproj ./Client/
COPY ./Shared/*.csproj ./Shared/
COPY ./Server/*.csproj ./Server/
RUN dotnet restore
COPY ./Shared/. ./Shared/
COPY ./Client/. ./Client/
COPY ./Server/. ./Server/
WORKDIR /src/Server/
RUN dotnet publish -c Release -o /app --no-restore

FROM mcr.microsoft.com/dotnet/aspnet:7.0
WORKDIR /app
COPY --from=build /app ./
CMD ASPNETCORE_URLS=http://*:$PORT dotnet BlazorApp.Server.dll