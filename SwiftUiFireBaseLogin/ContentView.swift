//
//  ContentView.swift
//  SwiftUiFireBaseLogin
//
//  Created by Harshit Verma on 2/13/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Color.black
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .foregroundStyle(.linearGradient(colors: [.yellow, .orange], startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 1000, height: 400)
                .rotationEffect(Angle(degrees: 135))
                .offset(y: -350)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    ContentView()
}

