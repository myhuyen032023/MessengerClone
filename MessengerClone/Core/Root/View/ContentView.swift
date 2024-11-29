//
//  ContentView.swift
//  MessengerClone
//
//  Created by Hoang Thi My Huyen on 27/8/24.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var viewModel = ContentViewModel()
    
    var body: some View {
//        Group {
//            if viewModel.userSession != nil {
//                InboxView()
//            } else {
//                LoginView()
//            }
//        }
        
        if viewModel.userSession != nil {
            InboxView()
        } else {
            LoginView()
        }
    }
}

#Preview {
    ContentView()
}
