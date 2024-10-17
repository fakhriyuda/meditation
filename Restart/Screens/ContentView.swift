//
//  ContentView.swift
//  Restart
//
//  Created by ISYS Macbook air 1 on 15/10/24.
//

import SwiftUI

struct ContentView: View {
    
    @AppStorage("onboarding") var isOnboardingViewActive : Bool = true
    
    var body: some View {
        ZStack{
            if isOnboardingViewActive {
                OnboardingView()
            }else{
                HomeView()
            }
        }.animation(.easeOut(duration: 0.5),value: isOnboardingViewActive)
    }
}

#Preview {
    ContentView()
}
