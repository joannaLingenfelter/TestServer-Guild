//
//  ContentView.swift
//  TestServer-Guild
//
//  Created by Joanna Lingenfelter on 8/31/22.
//

import SwiftUI

enum NetworkError: LocalizedError {
    case unknownError

    var errorDescription: String? {
        switch self {
        case .unknownError:
            return "An unknown error has occured"
        }
    }
}

struct ContentView: View {
    @State var isShowingError: Bool = false
    @State var error: String?
    @State var userId: String?
    @State var isLoading: Bool = false

    var body: some View {
        VStack(spacing: 15) {
            Text(userId ?? "")
            PrimaryButton("Fetch User Profile", isLoading: $isLoading) {
                withAnimation {
                    fetchUserProfile()
                }
            }
        }
        .onAppear {

        }
        .alert(isPresented: $isShowingError) {
            Alert(title: Text("Error"),
                  message: Text(error ?? ""))
        }
        .padding()
    }

    func fetchUserProfile() {
        Task {
            isLoading = true
            do {
                try await Task.sleep(nanoseconds: NSEC_PER_SEC / 2)
                self.userId = try await fetchUserProfile().userId
            } catch {
                self.isShowingError = true
                self.error = error.localizedDescription
            }
            isLoading = false
        }
    }

    private func fetchUserProfile() async throws -> UserProfile {
        let query = UserProfileQuery()
        let queryResult = try await APIClient().request(query: query)
        print("*** \(queryResult.data)")
        print("*** \(queryResult.data)")
        return queryResult.data.userProfile.data
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
