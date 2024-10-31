//
//  ContentView.swift
//  IdentosInterview
//
//  Created by Piraveen Mahesan on 2024-10-30.
//

import Foundation
import SwiftUI
import WebKit

struct ContentView: View {
    @ObservedObject var webViewModel = WebViewModel()
    @State var urlString = "https://www.google.com"  // Default URL
    @State  var showingAlert = false
    @State  var alertMessage = ""

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    webViewModel.webView.goBack()
                }){
                    Image(systemName: "arrow.backward")
                        .font(.title)
                        .padding()
                }
                .disabled(!webViewModel.canGoBack)  //Back button is enabled when backstack is available


                TextField("Enter url", text: $urlString, onCommit: {
                                    loadURL()
                                })
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.horizontal)

                
                Button(action: {
                                    loadURL()
                                }, label: {
                                    Text("Go")
                                })

                Button(action: {
                    webViewModel.webView.goForward()
                }){
                    Image(systemName: "arrow.forward")
                        .font(.title)
                        .padding()
                }
                .disabled(!webViewModel.canGoForward) //Forward button is enabled when forward navigation is possible

            }
            .background(Color(.systemGray6))

            if webViewModel.isLoading {
                ProgressView()
            }

            CustomWebView(webViewModel: webViewModel)
        }
        .onAppear {
            webViewModel.loadURL(urlString: urlString)
        }
        .onChange(of: webViewModel.currentURLString) {
            urlString = webViewModel.currentURLString ?? urlString
        }
        .alert(isPresented: $showingAlert ) {
            Alert(title: Text("Invalid URL"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
        //This function was preferred to show usage of Alert
    private func loadURL() {
           if let url = URL(string: urlString), url.scheme != nil, url.host != nil {
               webViewModel.loadURL(urlString: urlString)
           } else {
               alertMessage = "Please enter a valid URL (e.g., https://www.example.com)."
               showingAlert = true
           }
       }
    
                                    //Below function should be used after handling erros in WKNavigationDelegate
    
//    private func loadURL() {
//        var modifiedURLString = urlString.trimmingCharacters(in: .whitespacesAndNewlines)
//        
//        if !modifiedURLString.hasPrefix("http://") && !modifiedURLString.hasPrefix("https://") {
//            modifiedURLString = "https://" + modifiedURLString
//        }
//        
//        if let url = URL(string: modifiedURLString), url.scheme != nil, url.host != nil {
//            urlString = modifiedURLString // Update the urlString state to reflect the change
//            webViewModel.loadURL(urlString: modifiedURLString)
//        } else {
//            alertMessage = "Please enter a valid URL (e.g., https://www.example.com)."
//            showingAlert = true
//        }
//    }
    
}

class WebViewModel: ObservableObject {
    @Published var webView = WKWebView()
    @Published var isLoading = false
    @Published var currentURLString: String?
    @Published var canGoBack = false
    @Published var canGoForward = false
    
    private var isLoadingObservation: NSKeyValueObservation?
    private var urlObservation: NSKeyValueObservation?
    private var canGoBackObservation: NSKeyValueObservation?
    private var canGoForwardObservation: NSKeyValueObservation?
    
    init() {

        isLoadingObservation = webView.observe(\.isLoading, options: [.new]) { [weak self] _, change in
            self?.isLoading = change.newValue ?? false
        }

        urlObservation = webView.observe(\.url, options: [.new]) { [weak self] _, change in
            if let url = change.newValue as? URL {
                self?.currentURLString = url.absoluteString
            }
        }
        canGoBackObservation = webView.observe(\.canGoBack, options: [.new]) { [weak self] _, change in
            self?.canGoBack = change.newValue ?? false
        }

        canGoForwardObservation = webView.observe(\.canGoForward, options: [.new]) { [weak self] _, change in
            self?.canGoForward = change.newValue ?? false
        }
    }

    func loadURL(urlString: String) {
        if let url = URL(string: urlString) {
            webView.load(URLRequest(url: url))
        }
    }
    
    func handleLoadingError(error: Error) {
         print(error)
            //Currently webview stays in the previous URL, when entered URL cannot be loaded even if it is in the correct format.
    }
}


    // WKWebView is wrapped in UIViewRepresentable since SwiftUI does not offer a native WebView component
struct CustomWebView: UIViewRepresentable {
    @ObservedObject var webViewModel: WebViewModel

    func makeUIView(context: Context) -> WKWebView {
        webViewModel.webView.allowsBackForwardNavigationGestures = true
        webViewModel.webView.navigationDelegate = context.coordinator
        return webViewModel.webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        // Nothing to update here for now
    }
    
    func makeCoordinator() -> Coordinator {
            Coordinator(self)
        }
                        // WKNavigationDelegate is implemented to detect loading errors 
        class Coordinator: NSObject, WKNavigationDelegate {
            var parent: CustomWebView

            init(_ parent: CustomWebView) {
                self.parent = parent
            }

            func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
                parent.webViewModel.handleLoadingError(error: error)
            }

            func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
                parent.webViewModel.handleLoadingError(error: error)
            }
        }
}

//#Preview {
//    ContentView()
//}

