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

enum GameStatus: String {
  case win, lose, draw, standby
}

struct ContentView: View {

  @State private var aiSelection = -1
  @State private var selection = -1
  @State private var wins = 0
  @State private var lose = 0
  @State private var numberOfGames = 0
  @State private var gameStatus = GameStatus.standby
  @State private var startMatch = false
  @State private var showAlert = false

  var body: some View {
    ZStack {
      Color(.systemBackground)
        .edgesIgnoringSafeArea(.all)

      VStack {
        Group {
          Text("Rock, Paper and Scissors")
            .fontWeight(.bold)
            .multilineTextAlignment(.center)
            .padding()
            .font(.largeTitle)

          Text("Choose your option")
            .font(.title2)
            .fontWeight(.regular)
            .multilineTextAlignment(.center)
        }

        Spacer()

        Text(aiSelection != -1 ? "\(GameOptions.allCases[aiSelection].rawValue)" : "👨‍💻")
          .font(.system(size: 50, weight: .regular))
          .padding(25)
          .background(Color.primary)
          .clipShape(Circle())
          .shadow(color: .primary, radius: 5)

        Text(gameStatus != .standby ? gameStatus.rawValue.capitalized : "")
          .padding(25)
          .font(.system(size: 35, weight: .bold, design: .rounded))

        HStack(spacing: 20.0) {
          ForEach(0..<3, content: { index in
            Button(action: {
              self.selection = index
            }, label: {
              Text(GameOptions.allCases[index].rawValue)
                .font(.system(size: 50, weight: .regular))
                .padding(25)
                .background(selection == index ? Color.blue : Color.primary)
                .clipShape(Circle())
                .shadow(color: .primary, radius: 5)
            })
            .disabled(startMatch)
          })
        }

        Spacer()

        Group {
          Button("Match", action: play)
            .font(.system(size: 24, weight: .semibold))
            .padding()
            .frame(maxWidth: .infinity)
            .foregroundColor(.white)
            .background(Color.blue)
            .clipShape(RoundedRectangle(cornerRadius: 25.0, style: .continuous))
            .padding(.top, 10)
            .padding(.bottom, 10)
            .disabled(startMatch)

          HStack {
            Text("Wins: \(wins)")

            Spacer()

            Text("Lose: \(lose)")
          }
          .font(.system(size: 16, weight: .semibold, design: .rounded))
          .padding(.top, 10)
        }
        .padding()
      }
    }
    .animation(.default)
    .alert(isPresented: $showAlert) {
      Alert(title: Text("The game has finished!"), message: Text("You have won \(wins) time(s)"), dismissButton: .default(Text("Play again"), action: resetGame))
    }
  }

  private func resetGame() {
    self.wins = 0
    self.lose = 0

    self.gameStatus = .standby
    self.aiSelection = -1
    self.selection = -1
    self.numberOfGames = 0
    self.startMatch = false

    self.showAlert = false
  }

  private func play() {
    self.startMatch = true
    self.aiSelection = Int.random(in: 0..<GameOptions.allCases.count)
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
      switch GameOptions.allCases[selection] {
      case .rock:
        switch GameOptions.allCases[aiSelection] {
        case .paper:
          gameStatus = .lose
        case .scissor:
          gameStatus = .win
        case .rock:
          gameStatus = .draw
        }
      case .paper:
        switch GameOptions.allCases[aiSelection] {
        case .scissor:
          gameStatus = .lose
        case .rock:
          gameStatus = .win
        case .paper:
          gameStatus = .draw

        }
      case .scissor:
        switch GameOptions.allCases[aiSelection] {
        case .paper:
          gameStatus = .win
        case .rock:
          gameStatus = .lose
        case .scissor:
          gameStatus = .draw
        }
      }

      playAgain()
    })
  }

  private func playAgain() {
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
      switch gameStatus {
      case .win:
        self.wins += 1
      case .lose:
        self.lose += 1
      default:
        break
      }

      self.gameStatus = .standby
      self.aiSelection = -1
      self.selection = -1
      self.numberOfGames += 1
      self.startMatch = false

      if numberOfGames == 10 {
        self.showAlert = true
      }
    })
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
