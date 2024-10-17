//
//  OnboardingView.swift
//  Restart
//
//  Created by ISYS Macbook air 1 on 15/10/24.
//

import SwiftUI

struct OnboardingView: View {
    
    @AppStorage("onboarding") var isOnboardingViewActive : Bool = true
    
    @State var buttonWidth : Double  = (UIScreen.current?.bounds.width ?? 0) - 80
    @State var buttonOffset : Double = 0
    @State var isAnimating : Bool = false
    @State var imageOffSet : CGSize = .zero
    @State var indicatorOpacity : Double = 1.0
    @State var textTitle : String = "Share."
    
    let hapticFeedback = UINotificationFeedbackGenerator()
    
    var body: some View {
        ZStack{
            Color("ColorBlue")
                .ignoresSafeArea(.all,edges: .all)
            VStack(spacing:20){
                Spacer()
                // MARK:  Header
                VStack(spacing:0){
                    Text(textTitle)
                        .font(.system(size: 60))
                        .foregroundStyle(.white)
                        .fontWeight(.heavy)
                        .transition(.opacity)
                        .id(textTitle)
                    
                    Text("""
                        It's not how much we give, but how much love we put into giving
                        """)
                    .font(.title3)
                    .fontWeight(.light)
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal,10)
                }
                .opacity(isAnimating ? 1:0)
                .offset(y: isAnimating ? 0 : -40)
                .animation(.easeIn(duration: 1), value: isAnimating)
                
                ZStack{
                    CircleGroupView(shapeColor: .white, shapeOpacity: 0.25)
                        .offset(x: imageOffSet.width * -1)
                        .blur(radius: abs(imageOffSet.width) / 5)
                        .animation(.easeOut(duration: 1), value: imageOffSet)
                    Image("character-1")
                        .resizable()
                        .scaledToFit()
                        .opacity(isAnimating ? 1 : 0)
                        .animation(.easeOut(duration: 1), value: isAnimating)
                        .offset(x: imageOffSet.width * 1.2)
                        .rotationEffect(.degrees(imageOffSet.width / 20))
                        .gesture(
                            DragGesture()
                                .onChanged{
                                    gesture in
                                    if (abs(imageOffSet.width) <= 150){
                                        imageOffSet = gesture.translation
                                        withAnimation(.linear(duration: 0.25)){
                                            indicatorOpacity = 0
                                            textTitle = "Give."
                                        }
                                    }
                                }
                                .onEnded{ _ in
                                    imageOffSet = .zero
                                    
                                    withAnimation(.linear(duration: 0.25)){
                                        indicatorOpacity = 1
                                        textTitle = "Share."
                                    }
                                }
                        )
                        .animation(.easeOut(duration: 1), value: imageOffSet)
                }.overlay(
                    Image(systemName: "arrow.left.and.right.circle")
                        .font(.system(size: 44))
                        .fontWeight(.ultraLight)
                        .foregroundStyle(.white)
                        .offset(y:20)
                        .opacity(isAnimating ? 1 : 0)
                        .animation(.easeOut(duration: 1).delay(2), value: isAnimating)
                        .opacity(indicatorOpacity)
                    ,alignment: .bottom
                )
                
                Spacer()
                // MARK:  Footer
                ZStack{
                    Capsule()
                        .fill(.white.opacity(0.2))
                    Capsule()
                        .fill(.white.opacity(0.2))
                        .padding(8)
                    
                    Text("Get Started")
                        .font(.title3)
                        .fontWeight(.heavy)
                        .fontDesign(.rounded)
                        .foregroundStyle(.white)
                        .offset(x: 20)
                    HStack{
                        Capsule()
                            .fill(Color("ColorRed"))
                            .frame(width: buttonOffset + 80)
                        Spacer()
                    }
                    HStack {
                        ZStack{
                            Circle()
                                .fill(Color("ColorRed"))
                            Circle()
                                .fill(.black).opacity(0.15)
                                .padding(8)
                            Image(systemName: "chevron.right.2")
                                .font(.system(size: 24))
                                .foregroundStyle(.white)
                        }
                        .foregroundStyle(.white)
                        .frame(width: 80, height: 80, alignment: .center)
                        .offset(x: buttonOffset)
                        .gesture(
                            DragGesture()
                                .onChanged{gesture in
                                    if gesture.translation.width > 0 && gesture.translation.width <= buttonWidth - 80{
                                        buttonOffset = gesture.translation.width
                                    }
                                }
                                .onEnded{ _ in
                                    withAnimation(Animation.easeOut(duration: 0.5)){
                                        if buttonOffset > buttonWidth / 2 {
                                            buttonOffset = buttonWidth - 80
                                            playSound(sound: "chimeup", type: "mp3")
                                            isOnboardingViewActive = false
                                            hapticFeedback.notificationOccurred(.success)
                                        }else{
                                            buttonOffset = 0
                                            hapticFeedback.notificationOccurred(.warning)
                                        }
                                    }
                                }
                        )
                        Spacer()
                    }
                }
                .frame(width: buttonWidth,
                       height: 80,alignment: .center)
                .padding()
                .opacity(isAnimating ? 1 : 0)
                .offset(y: isAnimating ? 0 : 40)
                .animation(.easeOut(duration: 1), value: isAnimating)
                
            }
        }
        .onAppear(perform: {
            isAnimating = true
        })
        .preferredColorScheme(.dark)
    }
}
extension UIWindow {
    static var current: UIWindow? {
        for scene in UIApplication.shared.connectedScenes {
            guard let windowScene = scene as? UIWindowScene else { continue }
            for window in windowScene.windows {
                if window.isKeyWindow { return window }
            }
        }
        return nil
    }
}


extension UIScreen {
    static var current: UIScreen? {
        UIWindow.current?.screen
    }
}

#Preview {
    OnboardingView()
}
