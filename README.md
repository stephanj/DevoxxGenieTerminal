# Devoxx Genie Terminal Prototype

**Devoxx Genie Terminal** is a macOS Swift application that provides a user-friendly terminal interface with AI-powered command suggestions and execution. It leverages the Ollama service for natural language processing and command generation, enhancing the traditional terminal experience.

https://github.com/user-attachments/assets/840cca49-04c1-4c75-a7a4-09b2c291d313


## Features

-   **AI-Powered Command Suggestions:** Get intelligent suggestions for shell commands based on natural language input.
-   **Command Execution:** Execute suggested commands or directly enter shell commands.
-   **Multiple Tabs:** Manage multiple terminal sessions with a tabbed interface.
-   **Customizable Themes:** Switch between light and dark themes.
-   **Debug Panel:** View Ollama debug logs for insights into AI interactions.
-   **Command History:** Easily navigate through previously executed commands.

## Prerequisites

-   macOS 14.2 or later
-   Xcode 15.2 or later
-   Ollama service running locally (see [Ollama](https://ollama.com/))

## Getting Started

1. **Clone the repository:**

    ```bash
    git clone https://github.com/stephanj/DevoxxGenieTerminal.git
    ```

2. **Open the project in Xcode:**

    Navigate to the `DevoxxGenieTerminal` directory and open `DevoxxTerminal.xcodeproj`.

3. **Build and run the application:**

    Select a simulator or a connected device and click the "Play" button.

## Usage

1. **Enter a command:** Type a natural language description of what you want to achieve in the input field, or directly enter a shell command.
2. **Get suggestions:** The application will query the Ollama service and display suggested commands.
3. **Execute a command:** Click on a suggestion to execute it, or press Enter to execute the text in the input field.
4. **Manage tabs:** Use the "+" button to add new tabs and the "x" button to close them.
5. **Toggle theme:** Click the sun/moon icon to switch between light and dark themes.
6. **View debug logs:** Click the terminal icon to show/hide the debug panel.

## Project Structure

-   **`DevoxxTerminal/`:** Contains the source code for the application.
    -   **`theme/`:** Theme-related files.
    -   **`Views/`:** SwiftUI views for the UI.
        -   **`Main/`:** Main view components.
        -   **`Components/`:** Reusable UI components.
    -   **`Models/`:** Data models.
        -   **`ollama/`:** Models related to Ollama communication.
    -   **`Services/`:** Services for interacting with Ollama and managing command history.
    -   **`ViewModels/`:** View models for managing application state.
    -   **`Shell.swift`:** Handles shell command execution.
    -   **`MainView.swift`:** The main view of the application.
    -   **`Assets.xcassets/`:** Application assets.
    -   **`Preview Content/`:** Assets for Xcode previews.
    -   **`DevoxxTerminalApp.swift`:** Application entry point.
-   **`DevoxxTerminalTests/`:** Unit tests.
-   **`DevoxxTerminalUITests/`:** UI tests.
-   **`DevoxxTerminal.xcodeproj/`:** Xcode project file.

## Contributing

Contributions are welcome! Please follow the standard Git flow process:

1. Fork the repository.
2. Create a new branch for your feature or bug fix.
3. Commit your changes.
4. Push your branch to your forked repository.
5. Create a pull request to the main repository.

## License

This project is licensed under the MIT License.

## Contact

Follow us on Bluesky: [@devoxxgenie.bsky.social](https://bsky.app/profile/devoxxgenie.bsky.social)
