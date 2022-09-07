//
//  UserProfile.swift
//  TestServer-Guild
//
//  Created by Joanna Lingenfelter on 9/6/22.
//

import Foundation

struct ResponseError: Decodable, Error {
    let errorCode: String
    let message: String
}

struct ResponseWrapper<T: Decodable>: Decodable {
    let data: T
    let error: ResponseError
}

struct UserProfileContainer: Decodable {
    let userProfile: ResponseWrapper<UserProfile>
}

struct UserProfile: Decodable {
    let userId: String?
}

struct UserProfileQuery: Query {
    static var body: String {
        """
        query Query {
          userProfile {
            data {
              userId
            }
            error {
              message
              errorCode
            }
          }
        }
        """
    }
    
    struct GraphQLResponse: Decodable {
        let data: UserProfileContainer
    }
}
