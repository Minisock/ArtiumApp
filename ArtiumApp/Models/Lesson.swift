//
//  Lesson.swift
//  ArtiumApp
//
//  Created by Amarjeet Kumar on 18/05/25.
//

import Foundation

struct Lesson: Codable, Identifiable {
	let id = UUID()
	let mentor_name: String
	let lesson_title: String
	let video_thumbnail_url: String
	let lesson_image_url: String
	let video_url: String
	
		// Mock lesson notes (not in API)
	var lesson_notes: String {
		"""
		In this lesson with \(mentor_name), you'll learn:
		
		• Fundamental techniques
		• Practical exercises
		• Performance tips
		
		Duration: 45 minutes
		Difficulty: Intermediate
		"""
	}
}

struct LessonResponse: Codable {
	let lessons: [Lesson]
}
