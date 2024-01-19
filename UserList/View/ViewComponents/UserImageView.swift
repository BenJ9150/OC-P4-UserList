//
//  UserImageView.swift
//  UserList
//
//  Created by Benjamin LEFRANCOIS on 19/01/2024.
//

import SwiftUI

struct UserImageView: View {
    let user: User
    let imageSize: ImageSize

    enum ImageSize {
        case large, medium, thumbnail
    }

    var body: some View {
        AsyncImage(url: URL(string: imageUrl)) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: imageWidth, height: imageWidth)
                .clipShape(Circle())
        } placeholder: {
            ProgressView()
                .frame(width: imageWidth, height: imageWidth)
                .clipShape(Circle())
        }
    }

    // MARK: Private properties

    private var imageUrl: String {
        switch imageSize {
        case .large:
            return user.picture.large
        case .medium:
            return user.picture.medium
        case .thumbnail:
            return user.picture.thumbnail
        }
    }

    private var imageWidth: CGFloat {
        switch imageSize {
        case .large:
            return 200
        case .medium:
            return 150
        case .thumbnail:
            return 50
        }
    }
}
