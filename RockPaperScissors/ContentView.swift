//
//  ContentView.swift
//  RockPaperScissors
//
//  Created by Juan Francisco Dorado Torres on 17/07/20.
//

import SwiftUI

enum GameOptions: String, CaseIterable {
  case rock = "👊"
  case paper = "✋"
  case scissor = "✌️"
}

struct ContentView: View {
  var body: some View {
    ZStack {
      Color(.systemBackground)
        .edgesIgnoringSafeArea(.all)

      VStack {
        Text("Rock, Paper and Scissors")
          .fontWeight(.bold)
          .multilineTextAlignment(.center)
          .padding()
          .font(.largeTitle)

        Text("Choose your option")
          .font(.title2)
          .fontWeight(.regular)
          .multilineTextAlignment(.center)

        Spacer()

        HStack {
          ForEach(0..<3, content: { index in
            Button(action: {}, label: {
              Text(GameOptions.allCases[index].rawValue)
                .font(.system(size: 80, weight: .regular))
                .padding()
            })
          })
        }

        HStack {
          Text("Wins: 0")

          Spacer()

          Text("Lose: 0")
        }
        .padding()
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      ContentView()
      ContentView().environment(\.colorScheme, .dark)
    }
  }
}
