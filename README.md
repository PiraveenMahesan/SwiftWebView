
# WebView Swift App

This is a simple Swift-based iOS application that demonstrates the use of `WKWebView` with SwiftUI to create a basic web browser. It allows users to enter URLs, navigate back and forward, displays a progress view when a page is loading, and provides error handling with alerts for failed navigation.

## Features

-   Display web content using `WKWebView`.
    
-   Enter a URL manually and load it in the web view.
    
-   Navigate back and forward using buttons.
    
-   Automatically add "https://" to URLs that are missing a scheme.
    
-   Display a loading indicator when a page is being loaded.
    
-   Error handling with alerts for navigation failures.
    
-   Buttons are disabled if navigation is not possible (i.e., no back/forward history).

-   Unit test to check for validity of URL. 


## Technologies Used

-   Swift 5
    
-   SwiftUI
    
-   UIKit (`WKWebView` for web content)
    
-   MVVM architecture with observable objects
    

## Getting Started

### Prerequisites

-   macOS
    
-   Xcode 12 or later
    
-   iOS 14.0 or later
    

## Project Structure

-   `ContentView.swift`: The main view of the application that includes the user interface for the browser.
    
-   `WebViewModel.swift`: Contains the `WebViewModel` class, which manages state and interactions with the `WKWebView`.
    
-   `AltWebView.swift`: A `UIViewRepresentable` wrapper for `WKWebView` to be used within SwiftUI.

-   `IdentosInterviewTests.swift`: Contains `XCTestCase` sample for testing URL validity.  

    


