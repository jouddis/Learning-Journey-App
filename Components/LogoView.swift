//
//  LogoView.swift
//  Learning Journey
//
//  Created by Joud Almashgari on 20/10/2025.
//
import SwiftUI

struct LogoView: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.red)
                .frame(width: 109, height: 109)
                .opacity(10/100)
                .overlay(
                    Circle().stroke(
                        AngularGradient(
                            gradient:Gradient(
                                colors:[Color.orange.opacity(40/100),
                                        Color.yellow,
                                        Color.red.opacity(50/100),
                                        Color.brown,
                                        Color.yellow,
                                        Color.orange,
                                        Color.red.opacity(40/100),
                                        Color.red.opacity(40/100)]),
                            center: .center)
                        ,
                        lineWidth: 0.4
                    )
                )
            Image(systemName: "flame.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 43, height: 43)
                .foregroundColor(.orange)
        }
    }
}

//#Preview {
//    LogoView()
//}
