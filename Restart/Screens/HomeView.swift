//
//  HomeView.swift
//  Restart
//
//  Created by ISYS Macbook air 1 on 15/10/24.
//

import SwiftUI

struct HomeView: View {
    
    @AppStorage("onboarding") var isOnboardingShowActive : Bool = false
    @State private var isAnimating : Bool = false
    var body: some View {
        VStack(spacing:20) {
            Spacer()
            ZStack {
                CircleGroupView(shapeColor: .gray, shapeOpacity: 0.1)
                Image("character-2")
                    .resizable()
                    .scaledToFit()
                    .padding()
                    .offset(y: isAnimating ? 35 : -35)
                    .animation(.easeOut(duration: 4).repeatForever(), value: isAnimating)
            }
            
            Text("The time that leads to mastery is dependent on the intensity of our focus")
                .font(.title3)
                .fontWeight(.light)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding()
            
            Button{
                withAnimation{
                    playSound(sound: "success", type: "m4a")
                    isOnboardingShowActive = true
                }
            }label: {
                Image(systemName: "arrow.triangle.2.circlepath.circle.fill")
                Text("Restart")
                    .font(.title3)
                    .fontWeight(.bold)
                    .fontDesign(.rounded)
            }
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.capsule)
            .controlSize(.large)
        }
        .onAppear(perform: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                isAnimating = true
            }
        })
    }
}

#Preview {
    HomeView()
}
