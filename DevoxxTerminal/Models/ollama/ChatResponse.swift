struct ChatResponse: Codable {
    let model: String
    let created_at: String
    let message: ChatMessage
    let done: Bool
    let total_duration: Int
    let load_duration: Int
    let prompt_eval_count: Int
    let prompt_eval_duration: Int
    let eval_count: Int
    let eval_duration: Int
}
