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
      self.posterView
      
      Text(self.movie.title)
        .font(.title)
        .bold()
        .multilineTextAlignment(.center)
        .padding(.vertical, 2)
      
      if let movieDetails {
        VStack(spacing: 20) {
          Text(movieDetails.tagline)
            .font(.headline)
          
          VStack {
            Text("Release: \(movieDetails.releaseDate.asFormattedDate())")
            Text("Runtime: \(movieDetails.runtime.minutesToFormattedTime())")
          }
          
          Text(movieDetails.overview)
        }
      }
      
      Spacer()
    }
    .padding()
  }
  
  private var posterView: some View {
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

extension Int {
  
  func minutesToFormattedTime() -> String {
    let hours = self / 60
    let minutes: Int = self % 60
    
    return hours != 0 ? "\(hours)h \(minutes)m" : "\(minutes)m"
  }
}

extension String {
  
  func asFormattedDate() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "YYYY-mm-dd"
    
    let date = dateFormatter.date(from: self)
    
    return date?.formatted(date: .abbreviated, time: .omitted) ?? "TBA"
  }
}

struct DetailsView_Previews: PreviewProvider {
  static var previews: some View {
    DetailsView(movie: .empty)
      .environmentObject(MoviesNetworkingManager())
  }
}
