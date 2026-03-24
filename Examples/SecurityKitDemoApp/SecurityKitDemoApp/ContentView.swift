//
//  ContentView.swift
//  SecurityKitDemoApp
//
//  Created by Thulani Mtetwa on 2026/03/24.
//

import SwiftUI
import SecurityKit

struct ContentView: View {

    // MARK: - State

    @State private var inputKey: String = "com.nullstack.demo.token"
    @State private var inputValue: String = ""
    @State private var retrievedValue: String = ""
    @State private var statusMessage: String = ""
    @State private var isError: Bool = false

    private let storage = SecureStorage()
    private let integrity = DeviceIntegrity()

    // MARK: - Body

    var body: some View {
        NavigationStack {
            List {

                // ── Device Integrity ──────────────────────────────────────
                Section("Device integrity") {
                    HStack(spacing: 12) {
                        Image(systemName: integrity.isCompromised ? "exclamationmark.shield.fill" : "checkmark.shield.fill")
                            .foregroundStyle(integrity.isCompromised ? .red : .green)
                            .font(.title2)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(integrity.statusMessage)
                                .font(.subheadline)
                                .fontWeight(.medium)
                            Text("Risk level: \(integrity.riskLevel.rawValue)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.vertical, 4)
                }

                // ── Keychain write ────────────────────────────────────────
                Section("Keychain — save") {
                    TextField("Key", text: $inputKey)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()

                    SecureField("Value to store", text: $inputValue)

                    Button("Save to Keychain") {
                        saveValue()
                    }
                    .disabled(inputValue.isEmpty)
                }

                // ── Keychain read/delete ──────────────────────────────────
                Section("Keychain — retrieve & delete") {
                    Button("Retrieve") {
                        retrieveValue()
                    }

                    if !retrievedValue.isEmpty {
                        HStack {
                            Text("Stored value:")
                                .foregroundStyle(.secondary)
                                .font(.caption)
                            Text(retrievedValue)
                                .font(.caption)
                                .fontWeight(.medium)
                                .monospaced()
                        }
                    }

                    Button("Delete", role: .destructive) {
                        deleteValue()
                    }
                }

                // ── Status feedback ───────────────────────────────────────
                if !statusMessage.isEmpty {
                    Section {
                        Label(statusMessage, systemImage: isError ? "xmark.circle" : "checkmark.circle")
                            .foregroundStyle(isError ? .red : .green)
                            .font(.subheadline)
                    }
                }
            }
            .navigationTitle("SecurityKit Demo")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    // MARK: - Actions

    private func saveValue() {
        do {
            try storage.save(inputValue, forKey: inputKey)
            setStatus("Saved successfully", error: false)
            inputValue = ""
        } catch {
            setStatus(error.localizedDescription, error: true)
        }
    }

    private func retrieveValue() {
        do {
            retrievedValue = try storage.retrieve(forKey: inputKey)
            setStatus("Retrieved successfully", error: false)
        } catch {
            retrievedValue = ""
            setStatus(error.localizedDescription, error: true)
        }
    }

    private func deleteValue() {
        storage.delete(forKey: inputKey)
        retrievedValue = ""
        setStatus("Deleted from Keychain", error: false)
    }

    private func setStatus(_ message: String, error: Bool) {
        statusMessage = message
        isError = error
    }
}

#Preview {
    ContentView()
}
