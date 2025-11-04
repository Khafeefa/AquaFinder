//
//  FountainsAPI.swift
//  AquaFinder
//
//  Created on 11/03/2025.
//

import Foundation

protocol FountainsAPI {
    func fetchFountains(completion: @escaping (Result<[Fountain], Error>) -> Void)
    func addFountain(_ fountain: Fountain, completion: @escaping (Result<Fountain, Error>) -> Void)
    func updateFountain(_ fountain: Fountain, completion: @escaping (Result<Fountain, Error>) -> Void)
    func deleteFountain(id: String, completion: @escaping (Result<Void, Error>) -> Void)
}
