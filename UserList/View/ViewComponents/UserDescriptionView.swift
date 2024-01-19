//
//  UserDescriptionView.swift
//  UserList
//
//  Created by Benjamin LEFRANCOIS on 19/01/2024.
//

import SwiftUI

// NEW_BL: user description structure, possible to indicate if date is displayed or not
struct UserDescriptionView: View {
    let user: User
    let withDate: Bool

    var body: some View {
        if withDate {
            VStack(alignment: .leading) {
                Text("\(user.name.first) \(user.name.last)")
                    .font(.headline)
                Text("\(user.dob.date)")
                    .font(.subheadline)
            }
        } else {
            Text("\(user.name.first) \(user.name.last)")
                .font(.headline)
                .multilineTextAlignment(.center)
        }
    }
}
