struct LoginResponse: Decodable {
    let access_token: String
    let token_type: String
}

struct User: Decodable {
    let id: Int
    let email: String
    let name: String
    let created_at: String
}
