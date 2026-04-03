//
//  APIModels.swift
//  Pokedex
//
//  Created by Michael Tufillaro on 3/28/26.
//

//Create dedicated model types to represent request and response data for API communication (i.e., LoginRequest, SignupRequest, TokenResponse). This improves type safety, code maintainability, and makes your networking layer more robust. You can find the details of these models at the bottom of the SwaggerUI docs.

import Foundation

//mostly taken from class code

// MARK: - Request Models
struct SignupRequest: Codable
{
    let email: String
    let password: String
}

struct LoginRequest: Codable
{
    let email: String
    let password: String
}

// MARK: - Response Models

//unlike class code, this needs a tokenType and user struct as well
struct TokenResponse: Codable
{
    let accessToken: String
    let tokenType: String
    let user: User
    
    //in SwaggerUI, these are snake case instead of camel case so this allows you to use camel case instead
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case user
    }
}

struct User: Codable
{
    let id: Int
    let email: String
}
