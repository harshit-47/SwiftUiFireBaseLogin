//
//  SwiftUiFireBaseLoginApp.swift
//  SwiftUiFireBaseLogin
//
//  Created by Harshit Verma on 2/13/25.
//

import SwiftUI
import Firebase
import FirebaseAppCheck

@main
struct SwiftUiFireBaseLoginApp: App {
    
    init() {
        FirebaseApp.configure()

        #if DEBUG
        let providerFactory = AppCheckDebugProviderFactory()
        AppCheck.setAppCheckProviderFactory(providerFactory)
        #endif
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
