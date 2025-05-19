//
//  LessonDetailView.swift
//  ArtiumApp
//
//  Created by Amarjeet Kumar on 18/05/25.
//

import SwiftUI
import AVKit
import NimbusCache
import Kingfisher

struct LessonDetailView: View {
	let lesson: Lesson
	@State private var player: AVPlayer?
	@State private var isPlaying = false
	
	var body: some View {
		ScrollView {
			VStack(alignment: .leading, spacing: 20) {
					// Header
				VStack(alignment: .leading, spacing: 8) {
					Text(lesson.lesson_title)
						.font(.title)
					Text("with \(lesson.mentor_name)")
						.font(.title2)
						.foregroundColor(.secondary)
				}
				
					// Video Player
				videoPlayerSection
				
					// Lesson Notes
				lessonNotesSection
				
				Spacer()
			}
			.padding()
		}
		.overlay(alignment: .bottom) {
			SubmitPracticeButton()
		}
		.onAppear { setupPlayer() }
		.onDisappear { player?.pause() }
	}
	
		// MARK: - Subviews
	
	private var videoPlayerSection: some View {
		ZStack {
			if let player = player {
				VideoPlayer(player: player)
					.frame(height: 220)
					.onAppear {
						NotificationCenter.default.addObserver(
							forName: .AVPlayerItemDidPlayToEndTime,
							object: player.currentItem,
							queue: .main
						) { _ in
							isPlaying = false
							player.seek(to: .zero)
						}
					}
			} else {
				ProgressView()
					.frame(height: 220)
			}
			
			if !isPlaying, player != nil {
				playButtonOverlay
			}
		}
		.background(Color.black)
		.cornerRadius(12)
	}
	
	private var playButtonOverlay: some View {
		Button(action: togglePlayback) {
			Image(systemName: "play.circle.fill")
				.resizable()
				.frame(width: 50, height: 50)
				.foregroundColor(.white)
				.shadow(radius: 10)
		}
	}
	
	private var lessonNotesSection: some View {
		VStack(alignment: .leading, spacing: 8) {
			Text("Lesson Notes")
				.font(.title3)
			Text(lesson.lesson_notes)
		}
	}
	
		// MARK: - Methods
	
	private func setupPlayer() {
		guard let url = URL(string: lesson.video_url) else { return }
		player = AVPlayer()
		Task {
			if let playerItem = await AVPlayerItem(url: url, isCacheEnabled: true) {
				player = AVPlayer(playerItem: playerItem)
				player!.play()
			}
		}
	}
	
	private func togglePlayback() {
		guard let player = player else { return }
		
		if isPlaying {
			player.pause()
		} else {
			player.play()
		}
		isPlaying.toggle()
	}
}
