# File Downloader App

## Introduction

The File Downloader App is a Flutter application that allows users to download files efficiently using an API. It supports various file formats and provides a smooth user experience with a clean UI.

### Features 

* Download files from URLs.

* Show download progress in real-time.

* Save downloaded files to local storage.

* Search files by id

* Downloads section to view all downloaded files..

### Instructions to Run the App

*Prerequisites*

Flutter installed on your system (Install Flutter).

git clone (https://github.com/sajalbnl/Files-Downloader)

cd files-downloader

Install dependencies: flutter pub get

Run the app: flutter run

### RapidAPI Integration

This app uses RapidAPI to fetch images of cats. The API helps in getting valid file URLs, ensuring a secure and smooth download experience.

API Details: Base URL: https://free-images-api.p.rapidapi.com/v2/cat/1

Authentication: Requires X-RapidAPI-Key in the request header.

Response: Returns a valid file URL for downloading.

curl --request GET \
	--url https://free-images-api.p.rapidapi.com/v2/cat/1 \
	--header 'x-rapidapi-host: free-images-api.p.rapidapi.com' \
	--header 'x-rapidapi-key: 78a2bdd017msh5b5dce52e24e172p1d492cjsnacd8e8dd3f95'


### State Management Approach

* This application uses Provider for state management.

* ThemeProvider: Handles dark/light mode changes.

* Using Provider ensures efficient state updates and enhances performance.

### Additional Features

Multi-File Downloads: Allows downloading multiple files simultaneously.



# Demo App


https://github.com/user-attachments/assets/1d5c1ecd-2d98-4fa6-8550-f8b5c1416ef5

