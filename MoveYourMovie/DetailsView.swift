//
//  DetailsView.swift
//  MoveYourMovie
//
//  Created by Vlad Kozlov on 24.04.2023.
//

import SwiftUI
import MoviesNetworking

struct DetailsView: View {
  
  // MARK: - Environment
  
  @EnvironmentObject var moviesNetworking: MoviesNetworkingManager
  
  // MARK: - Variables
  
  @State var movieDetails: MovieDetails? = nil
  
  var movie: Movie
  
  // MARK: - Body
  
  var body: some View {
    self.contentView
      .presentationBackground(.thinMaterial)
      .task {
        await self.getDetails()
      }
  }
  
  // MARK: - Views
  
  private var contentView: some View {
    VStack {
      AsyncImage(url: self.movie.posterUrl()) { image in
        image
          .resizable()
          .aspectRatio(contentMode: .fit)
      } placeholder: {
        ProgressView()
      }
      .frame(height: 250)
      .clipShape(RoundedRectangle(cornerRadius: 20))
      .padding()
      
      Text(self.movie.title)
        .font(.title)
        .bold()
        .multilineTextAlignment(.center)
        .padding(.vertical)
      
      if let movieDetails {
        VStack(spacing: 20) {
          Text(movieDetails.tagline)
            .font(.headline)
          
          Text(movieDetails.overview)
        }
      }
      
      Spacer()
    }
    .padding()
  }
  
  // MARK: - Private
  
  private func getDetails() async {
    let result = await self.moviesNetworking.getDetails(for: self.movie)
    
    switch result {
    case .success(let success):
      self.movieDetails = success
    case .failure(let failure):
      print(failure.description)
    }
  }
}

struct DetailsView_Previews: PreviewProvider {
  static var previews: some View {
    DetailsView(movie: .empty)
      .environmentObject(MoviesNetworkingManager())
  }
}
