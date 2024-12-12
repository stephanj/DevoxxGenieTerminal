import Foundation

class CommandHistory: ObservableObject {
    @Published private(set) var commands: [String] = []
    private var currentIndex: Int = -1 // -1 indicates no history item selected

    private let storageKey = "commandHistory"
    private let maxHistorySize = 100 // Limit history size (optional)

    init() {
        load()
    }

    func addCommand(_ command: String) {
        if !command.isEmpty {
            // Prevent duplicate consecutive commands
            if commands.last != command {
                commands.append(command)
            }

            // Limit history size (optional)
            if commands.count > maxHistorySize {
                commands.removeFirst()
            }

            currentIndex = -1 // Reset index after adding a new command
            save()
        }
    }

    func navigate(direction: HistoryDirection) -> String? {
        guard !commands.isEmpty else { return nil }

        switch direction {
        case .up:
            if currentIndex == -1 {
                currentIndex = commands.count - 1
            } else if currentIndex > 0 {
                currentIndex -= 1
            }
        case .down:
            if currentIndex < commands.count - 1 {
                currentIndex += 1
            } else {
                currentIndex = -1 // Reset to -1 to indicate no history item selected
            }
        }

        return currentIndex >= 0 ? commands[currentIndex] : nil
    }

    func clear() {
        commands.removeAll()
        currentIndex = -1
        save()
    }

    // MARK: - Persistence (using UserDefaults in this example)

    private func save() {
        UserDefaults.standard.set(commands, forKey: storageKey)
    }

    private func load() {
        if let storedCommands = UserDefaults.standard.array(forKey: storageKey) as? [String] {
            commands = storedCommands
        }
    }

    enum HistoryDirection {
        case up, down
    }
}
