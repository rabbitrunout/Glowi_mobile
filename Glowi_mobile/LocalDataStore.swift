//
//  LocalDataStore.swift
//  Glowi_mobile
//
//  Created by Irina Saf on 2026-04-24.
//

import Foundation

final class LocalDataStore {
    static let shared = LocalDataStore()

    private let appDataKey = "glowi_app_data"

    private init() {}

    func save(_ data: AppData) {
        do {
            let encoded = try JSONEncoder().encode(data)
            UserDefaults.standard.set(encoded, forKey: appDataKey)
        } catch {
            print("Failed to save app data:", error.localizedDescription)
        }
    }

    func load() -> AppData? {
        guard let data = UserDefaults.standard.data(forKey: appDataKey) else {
            return nil
        }

        do {
            return try JSONDecoder().decode(AppData.self, from: data)
        } catch {
            print("Failed to load app data:", error.localizedDescription)
            return nil
        }
    }

    func clear() {
        UserDefaults.standard.removeObject(forKey: appDataKey)
    }
}
