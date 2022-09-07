//
//  APIClient.swift
//  TestServer-Guild
//
//  Created by Joanna Lingenfelter on 9/6/22.
//

import Foundation

final class APIClient {
    private let session: URLSession

    init(session: URLSession = URLSession.shared) {
        self.session = session
    }

    func request<Q: Query>(query: Q) async throws -> Q.GraphQLResponse {
        try await withCheckedThrowingContinuation { continuation in
            request(query: query) { result in
                switch result {
                case .success(let queriedObject):
                    continuation.resume(returning: queriedObject)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    struct RequestBody: Codable {
        let operationName: String
        let query: String
        let variables: String?

        init(operationName: String = "Query", query: String, variables: String? = nil) {
            self.operationName = operationName
            self.query = query
            self.variables = variables
        }
    }

    /*
     {"operationName":"Query","query":"query Query {  userProfile {   __typename    data {      __typename      userId    }    error {      __typename      message      errorCode    }  }}","variables":null}
     """
     */

    private func request<Q: Query>(query: Q, completion: @escaping (Result<Q.GraphQLResponse, Error>) -> ()) {
        let url = URL(string: "http://localhost:4000/")!

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(RequestBody(query: Q.body))

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
            }

            guard let data = data else {
                let error = ResponseError(errorCode: "Missing Data", message: "No data for this request.")
                completion(.failure(error))
                return
            }

            do {
                let json = try JSONSerialization.jsonObject(with: data)
                print("*** json: \(json)")

                let result = try Q.decodeResponse(data)
                completion(.success(result))
            } catch {
                print("*** decoding error: \(error)")
                completion(.failure(error))
            }
        }.resume()
    }
}
