//
//  LessonListViewModel.swift
//  ArtiumApp
//
//  Created by Amarjeet Kumar on 18/05/25.
//

import SwiftUI

@MainActor
class LessonListViewModel: ObservableObject {
	@Published var lessons: [Lesson] = []
	@Published var isLoading = false
	@Published var error: Error?
	
	private let service = LessonService()
	
	func fetchLessons() async {
		isLoading = true
		error = nil
		
		do {
			lessons = try await service.fetchLessons()
		} catch {
			self.error = error
		}
		
		isLoading = false
	}
}

