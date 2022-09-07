//
//  Query.swift
//  TestServer-Guild
//
//  Created by Joanna Lingenfelter on 8/31/22.
//

import Foundation

protocol Query {
    /// The format of the response to expect from the GraphQL request
    associatedtype GraphQLResponse: Decodable

    /// The full string to send in the GraphQL request
    static var body: String { get }

    /**
     Decode a `Data` object from the GraphQL endpoint into our expected `Response` type.

     – Parameter data: `Data` – bytes from the network
     */
    static func decodeResponse(_ data: Data) throws -> GraphQLResponse
}

extension Query {
    static func decodeResponse(_ data: Data) throws -> GraphQLResponse {
        try JSONDecoder().decode(GraphQLResponse.self, from: data)
    }
}
