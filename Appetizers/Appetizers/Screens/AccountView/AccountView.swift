//
//  AccountView.swift
//  Appetizers
//
//  Created by Валентина Лінчук on 11/12/2024.
//

import SwiftUI

struct AccountView: View {
    
    @State private var text = ""
    
    var body: some View {
        NavigationStack {
//            Text("Account")
//                .navigationTitle("Account")
            TextField("Enter Text", text: $text)
                .textFieldStyle(.roundedBorder)
                .padding()
            Button("Tap Me") {
                print(text)
            }
        }
    }
}

#Preview {
    AccountView()
}
