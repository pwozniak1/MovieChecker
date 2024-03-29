//
//  MoviePosterCard.swift
//  MovieChecker
//
//  Created by Piotr Woźniak on 10/07/2022.
//

import SwiftUI

enum MovieThumbnailType {
    case poster(showTitle: Bool = false)
    case backdrop
}

struct MovieThumbnailCard: View {
    let movie: Movie
    @StateObject var imageLoader = ImageLoader()
    var thumbnailType: MovieThumbnailType = .poster()
    
    var body: some View {
        containerView
        .onAppear {
            switch thumbnailType {
            case .poster:
                imageLoader.loadImage(with: movie.posterURL)
            case .backdrop:
                imageLoader.loadImage(with: movie.backdropURL)
            }
        }
    }
    @ViewBuilder private var containerView: some View {
        if case .backdrop = thumbnailType {
            VStack(alignment: .leading, spacing: 8) {
                imageView
                Text(movie.title)
                    .font(.headline)
                    .lineLimit(1)
            }
        } else {
            imageView
        }
    }
    private var imageView: some View {
        ZStack {
            Color.gray.opacity(0.3)
            if case .poster(let showTitle) = thumbnailType, showTitle {
                Text(movie.title)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .lineLimit(4)
            }
            if let image = imageLoader.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .layoutPriority(1)
            }
        }
        .cornerRadius(8)
        .shadow(radius: 4)
    }
}

struct MoviePosterCard_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MovieThumbnailCard(movie: Movie.stubbedMovie, thumbnailType: .poster(showTitle: true))
                .frame(width: 204, height: 306)
            MovieThumbnailCard(movie: Movie.stubbedMovie, thumbnailType: .backdrop)
                .aspectRatio(16/9, contentMode: .fit)
                .frame(height: 160)
        }
    }
}
