//
//  NetworkService.swift
//  Glowi_mobile
//
//  Created by Irina Saf on 2026-04-02.
//

import Foundation

final class NetworkService {
    static let shared = NetworkService()
    private init() {}

    func loadMockData() -> AppData? {
        guard let url = Bundle.main.url(forResource: "MockData", withExtension: "json") else {
            print("MockData.json not found")
            return nil
        }

        do {
            let data = try Data(contentsOf: url)
            let decoded = try JSONDecoder().decode(AppData.self, from: data)
            return decoded
        } catch {
            print("Failed to decode MockData.json:", error)
            return nil
        }
    }
}
