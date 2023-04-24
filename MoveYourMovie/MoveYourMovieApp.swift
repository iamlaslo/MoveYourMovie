//
//  MoveYourMovieApp.swift
//  MoveYourMovie
//
//  Created by Vlad Kozlov on 20.04.2023.
//

import SwiftUI
import MoviesNetworking

@main
struct MoveYourMovieApp: App {
  
  private let moviesNetworking = MoviesNetworkingManager()
  
    var body: some Scene {
        WindowGroup {
            ContentView()
            .environmentObject(self.moviesNetworking)
        }
    }
}
