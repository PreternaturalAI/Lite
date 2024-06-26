
# Sideproject
[![Build all  platforms](https://github.com/PreternaturalAI/Sideproject/actions/workflows/swift.yml/badge.svg)](https://github.com/PreternaturalAI/Sideproject/actions/workflows/swift.yml)
[![MIT License](https://img.shields.io/badge/License-MIT-green.svg)](https://choosealicense.com/licenses/mit/)

#### Supported Platforms
<p align="left">
<picture>
  <source media="(prefers-color-scheme: dark)" srcset="Images/macos.svg">
  <source media="(prefers-color-scheme: light)" srcset="Images/macos-active.svg">
  <img alt="macos" src="Images/macos-active.svg" height="24">
</picture>&nbsp;
  
<picture>
  <source media="(prefers-color-scheme: dark)" srcset="Images/ios.svg">
  <source media="(prefers-color-scheme: light)" srcset="Images/ios-active.svg">
  <img alt="macos" src="Images/ios-active.svg" height="24">
</picture>&nbsp;

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="Images/ipados.svg">
  <source media="(prefers-color-scheme: light)" srcset="Images/ipados-active.svg">
  <img alt="macos" src="Images/ipados-active.svg" height="24">
</picture>&nbsp;

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="Images/tvos.svg">
  <source media="(prefers-color-scheme: light)" srcset="Images/tvos-active.svg">
  <img alt="macos" src="Images/tvos-active.svg" height="24">
</picture>&nbsp;

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="Images/watchos.svg">
  <source media="(prefers-color-scheme: light)" srcset="Images/watchos-active.svg">
  <img alt="macos" src="Images/watchos-active.svg" height="24">
</picture>
</p>


Sideproject is a toolkit designed for developers looking to quickly prototype AI applications. It provides basic, high-performance UI components for platforms like iOS and macOS, allowing for fast experimentation and development without the complexities of full-scale customization. Targeted at simplifying common development challenges, such as file handling and UI creation, Sideproject is ideal for rapid testing and iteration of AI concepts. 

Sideproject is not meant for detailed customization or large-scale applications, serving instead as a temporary foundation while more personalized solutions are developed.

**What Sideproject Is:**

- A toolkit for rapid prototyping of AI applications.
- A collection of basic, high-performance UI components.
- Provides solutions for common development challenges like file handling.
- Offers cross-platform support for iOS, macOS, and visionOS.
- Ideal for developers who need quick UI implementations for chat views, data lists, etc.

**What Sideproject Is Not:**

- Not a general-purpose UI framework.
- Not meant for extensive customization or large-scale applications.
- Does not include implementations for specific services like OpenAI; these are in the AI framework.
- Not intended for long-term use in finalized apps; serves as a placeholder for custom implementations.

## Features

|  | Main Features |
| :-------- | :-----------|
| 📖 | Open Source |
|🙅‍♂️|No Account Required|


## Requirements

| Parameter | Type     | Description                |
| :-------- | :------- | :------------------------- |
|macOS|13.0+|Swift Package Manager|

## Installation

The Swift Package Manager is a tool for automating the distribution of Swift code and is integrated into the swift compiler.

Once you have your Swift package set up, adding Sideproject as a dependency is as easy as adding it to the dependencies value of your Package.swift or the Package list in Xcode.

```swift
dependencies: [
    .package(url: "https://github.com/PreternaturalAI/Sideproject", branch: "main")
]
```

## Usage/Examples

To create a request to an LLM, just create a prompt, enter in the services you'd like to use (OpenAI, Claude, Gemeni, etc...) and based on the prompt Sideproject will find which one will work best for your request.

### Import the framework

```diff
+ import Sideproject
```
### Streaming

```swift
// Initializes a chat prompt with user-provided text.
let prompt = AbstractLLM.ChatPrompt(messages: [.user("PROMPT GOES HERE")])

// Creates an API client instance with your unique API key.
let openAI = OpenAI.Client(apiKey: "API KEY GOES HERE")

// Wraps the OpenAI client in a 'Sideproject' service layer for streamlined API access.
let sideproject = Sideproject(services: [openAI])

// Initiates a streaming request to the OpenAI service with the user's prompt.
let result = try await sideproject.stream(prompt)

// Iterates over incoming messages from the OpenAI service as they arrive.
for try await message in result.messagePublisher.values {
    do {
        // Attempts to convert each message's content to a String.
        let value = try String(message.content)
        // Updates a local variable with the new message content.
        self.chatPrompt = value
    } catch {
        // Prints any errors that occur during the message handling.
        print(error)
    }
}
```
### Using GPT4 Vision (Sending Images/Files)
```swift
// Initializes an image-based prompt for the language model.
let imageSideprojectral = try PromptSideprojectral(image: image)

// Constructs a series of chat messages combining a predefined text prompt with the image literal.
let messages: [AbstractLLM.ChatMessage] = [
    .user {
        .concatenate(separator: nil) {
            PromptSideprojectral(Prompts.isThisAMealPrompt)
            imageSideprojectral
        }
    }
]

// Asynchronously sends the constructed messages to the LLM service and awaits the response.
// It specifies the maximum number of tokens (words) that the response can contain.
let completion = try await Sideproject.shared.complete(
    prompt: .chat(
        .init(messages: messages)
    ),
    parameters: AbstractLLM.ChatCompletionParameters(
        tokenLimit: .fixed(1000)
    )
)

// Extracts text from the completion response and attempts to convert it to a Boolean.
// This could be used, for example, to determine if the image is recognized as a meal.
let text = try completion._chatCompletion!._stripToText()
return Bool(text) ?? false
```

### Account Management
Quickly add a way for users to add their own API Provider API keys (stored locally in their Documents folder): 

```swift
struct MyView: ViewPreview {
    var body: some View {
        SideprojectAccountsView()
    }
}
```
<img width="713" alt="Screenshot 2024-06-22 at 12 53 48 PM" src="https://github.com/PreternaturalAI/Sideproject/assets/1157147/2b1c7c0a-01ce-43a4-a0ad-b9c52f0069cb">

Specify which providers to include: 

```swift
SideprojectAccountsView(only: [.openAI, .mistral, .anthropic])
```

Specify which providers to exlude: 
```swift
SideprojectAccountsView(excluding: [.elevenLabs, .notion, .replicate])
```

Check Account Credentials
```swift
let accountStore = Sideproject.ExternalAccountStore.shared

accountStore.hasCredentials(type: .openAI)
accountStore.hasCredentials(type: .anthropic)
accountStore.hasCredentials(type: .mistral)
accountStore.hasCredentials(type: .groq)
accountStore.hasCredentials(type: .elevenLabs)
```

## Demo

See demos on [Preternatural Explore](https://github.com/preternatural-explore)

## Support

For support, provide an issue on GitHub or [message me on Twitter.](https://twitter.com/vatsal_manot)
