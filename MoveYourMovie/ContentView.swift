//
//  ContentView.swift
//  MoveYourMovie
//
//  Created by Vlad Kozlov on 20.04.2023.
//

import SwiftUI
import MoviesNetworking

struct ContentView: View {
  
  // MARK: - Environment
  
  @EnvironmentObject var moviesNetworking: MoviesNetworkingManager
  
  // MARK: - Variables
  
  @State private var movies: [Movie] = []
  @State private var showDetailsFor: Movie? = nil
  
  // MARK: - Body
  
  var body: some View {
    NavigationStack {
      List {
        ForEach(self.movies) { movie in
          self.movieCell(movie)
            .onTapGesture {
              self.showDetailsFor = movie
            }
        }
      }
      .navigationTitle("MoveYourMovie")
    }
    .task {
      await self.getMovies()
    }
    .sheet(
      item: self.$showDetailsFor,
      onDismiss: {
        self.showDetailsFor = nil
      },
      content: {
        DetailsView(movie: $0)
      }
    )
  }
  
  // MARK: - Views
  
  private func movieCell(_ movie: Movie) -> some View {
    HStack {
      if let posterUrl = movie.posterUrl() {
        AsyncImage(url: posterUrl) { image in
          image
            .resizable()
            .aspectRatio(contentMode: .fit)
        } placeholder: {
          ProgressView()
        }
        .frame(height: 175)
      }
      
      Spacer()
      
      Text(movie.title)
        .font(.headline)
        .multilineTextAlignment(.trailing)
    }
  }
  
  // MARK: - Private
  
  private func getMovies() async {
    let result = await self.moviesNetworking.getMovies()
    
    switch result {
    case .success(let success):
      self.movies = success.movies
    case .failure(let failure):
      print(failure.description)
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
      .environmentObject(MoviesNetworkingManager())
  }
}
