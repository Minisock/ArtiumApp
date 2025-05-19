//
//  ContentView.swift
//  ArtiumApp
//
//  Created by Amarjeet Kumar on 17/05/25.
//

import SwiftUI
import Kingfisher

struct LessonListView: View {
	@StateObject private var viewModel = LessonListViewModel()
	
	var body: some View {
		NavigationStack {
			Group {
				if viewModel.isLoading {
					ProgressView("Loading lessons...")
				} else if let error = viewModel.error {
					ErrorView(error: error) {
						Task { await viewModel.fetchLessons() }
					}
				} else {
					List(viewModel.lessons) { lesson in
						NavigationLink(destination: LessonDetailView(lesson: lesson)) {
							LessonRowView(lesson: lesson)
						}
					}
					.refreshable {
						await viewModel.fetchLessons()
					}
				}
			}
			.navigationTitle("Artium Lessons")
			.task {
				await viewModel.fetchLessons()
			}
		}
	}
}

	// Subview for each lesson row
struct LessonRowView: View {
	let lesson: Lesson
	
	var body: some View {
		HStack(spacing: 12) {
				// Lesson Image from API
			KFImage(URL(string: lesson.lesson_image_url))
				.resizable()
				.aspectRatio(1, contentMode: .fill)
				.frame(width: 60, height: 60)
				.cornerRadius(8)
				.clipped()
			
			VStack(alignment: .leading) {
				Text(lesson.lesson_title)
					.font(.headline)
				Text("with \(lesson.mentor_name)")
					.font(.subheadline)
					.foregroundColor(.secondary)
			}
		}
		.padding(.vertical, 4)
	}
}

	// Error state view
struct ErrorView: View {
	let error: Error
	let retryAction: () -> Void
	
	var body: some View {
		VStack(spacing: 16) {
			Image(systemName: "exclamationmark.triangle.fill")
				.font(.system(size: 40))
				.foregroundColor(.red)
			
			Text("Failed to load lessons")
				.font(.title3)
			
			Text(error.localizedDescription)
				.font(.caption)
				.multilineTextAlignment(.center)
				.foregroundColor(.secondary)
			
			Button("Retry", action: retryAction)
				.buttonStyle(.borderedProminent)
		}
		.padding()
	}
}
