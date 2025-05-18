//
//  LessonService.swift
//  ArtiumApp
//
//  Created by Amarjeet Kumar on 18/05/25.
//

import Foundation

class LessonService {
	func fetchLessons() async throws -> [Lesson] {
		guard let url = URL(string: "https://www.jsonkeeper.com/b/7JF5") else {
			throw URLError(.badURL)
		}
		
		let (data, _) = try await URLSession.shared.data(from: url)
		let response = try JSONDecoder().decode(LessonResponse.self, from: data)
		return response.lessons
	}
}
