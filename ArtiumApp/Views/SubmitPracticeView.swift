//
//  SubmitPracticeView.swift
//  ArtiumApp
//
//  Created by Amarjeet Kumar on 18/05/25.
//


import SwiftUI

struct SubmitPracticeButton: View {
	@State private var showSubmitModal = false
	
	var body: some View {
		Button(action: { showSubmitModal = true }) {
			HStack {
				Image(systemName: "arrow.up.circle.fill")
				Text("Submit Practice")
			}
			.frame(maxWidth: .infinity)
		}
		.buttonStyle(.borderedProminent)
		.controlSize(.large)
		.padding()
		.sheet(isPresented: $showSubmitModal) {
			SubmitPracticeView()
				.presentationDetents([.medium])
		}
	}
}

struct SubmitPracticeView: View {
	enum UploadState: Equatable {
		case idle
		case uploading(progress: Double)
		case success
		case failure
		case retry(error: String)
	}
	
	@State private var uploadState: UploadState = .idle
	@State private var selectedFile: String?
	@Environment(\.dismiss) private var dismiss
	
	var body: some View {
		NavigationStack {
			VStack(spacing: 24) {
				uploadStateView
				
				if case .idle = uploadState, selectedFile != nil {
					submitButton
				}
				
				if case .retry = uploadState {
					retryActions
				}
			}
			.padding()
			.navigationTitle("Submit Practice")
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				if case .idle = uploadState {
					Button("Cancel") { dismiss() }
				}
			}
			.animation(.default, value: uploadState)
		}
	}
	
		// MARK: - Subviews
	
	@ViewBuilder
	private var uploadStateView: some View {
		switch uploadState {
			case .idle:
				idleStateView
			case .uploading(let progress):
				uploadingStateView(progress: progress)
			case .success:
				successStateView
			case .failure:
				failureStateView
			case .retry(let error):
				retryStateView(error: error)
		}
	}
	
	private var idleStateView: some View {
		VStack(spacing: 20) {
			Image(systemName: "folder.badge.plus")
				.font(.system(size: 50))
				.foregroundColor(.blue)
			
			Text("Select your practice recording")
				.font(.headline)
			
			Button(action: selectFile) {
				Label("Choose File", systemImage: "doc")
					.frame(maxWidth: .infinity)
			}
			.buttonStyle(.bordered)
			.controlSize(.large)
			
			if let file = selectedFile {
				selectedFileView(file: file)
			}
		}
	}
	
	private func selectedFileView(file: String) -> some View {
		HStack {
			Image(systemName: "checkmark.circle.fill")
				.foregroundColor(.green)
			
			VStack(alignment: .leading) {
				Text(file)
					.font(.caption)
					.lineLimit(1)
				Text("15.2 MB • MP3 Audio")
					.font(.caption2)
					.foregroundColor(.secondary)
			}
			
			Spacer()
			
			Button(action: { selectedFile = nil }) {
				Image(systemName: "xmark.circle.fill")
					.foregroundColor(.gray)
			}
		}
		.padding()
		.background(Color.gray.opacity(0.1))
		.cornerRadius(8)
	}
	
	private func uploadingStateView(progress: Double) -> some View {
		VStack(spacing: 20) {
			ProgressView(value: progress, total: 1.0)
				.progressViewStyle(.linear)
				.tint(.blue)
			
			Text("Uploading... \(Int(progress * 100))%")
				.font(.headline)
			
			ProgressView()
				.scaleEffect(1.5)
		}
	}
	
	private var successStateView: some View {
		VStack(spacing: 20) {
			Image(systemName: "checkmark.circle.fill")
				.font(.system(size: 60))
				.foregroundColor(.green)
				.symbolEffect(.bounce, value: uploadState)
			
			Text("Upload Successful!")
				.font(.title2)
			
			Button("Done") { dismiss() }
				.buttonStyle(.borderedProminent)
		}
	}
	
	private var failureStateView: some View {
		VStack(spacing: 20) {
			Image(systemName: "exclamationmark.triangle.fill")
				.font(.system(size: 50))
				.foregroundColor(.orange)
			
			Text("Upload Failed")
				.font(.title2)
			
			Button("Try Again Later") { dismiss() }
				.buttonStyle(.bordered)
		}
	}
	
	private func retryStateView(error: String) -> some View {
		VStack(spacing: 20) {
			Image(systemName: "arrow.clockwise.circle.fill")
				.font(.system(size: 60))
				.foregroundColor(.blue)
				.symbolEffect(.variableColor, value: uploadState)
			
			Text("Upload Failed")
				.font(.title2)
			
			Text(error)
				.font(.caption)
				.foregroundColor(.red)
				.multilineTextAlignment(.center)
		}
	}
	
		// MARK: - Action Buttons
	
	private var submitButton: some View {
		Button(action: startUpload) {
			Label("Submit Now", systemImage: "paperplane.fill")
				.frame(maxWidth: .infinity)
		}
		.buttonStyle(.borderedProminent)
	}
	
	private var retryActions: some View {
		VStack(spacing: 12) {
			Button("Retry Upload") { startUpload() }
				.buttonStyle(.borderedProminent)
			
			Button("Select Different File") { uploadState = .idle }
				.buttonStyle(.bordered)
		}
	}
	
		// MARK: - Methods
	
	private func selectFile() {
		selectedFile = "Practice_\(Date().formatted()).mp3"
	}
	
	private func startUpload() {
		guard selectedFile != nil else { return }
		
		uploadState = .uploading(progress: 0)
		
			// Simulate upload with possible failure
		Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { timer in
			if case .uploading(let progress) = uploadState {
				let newProgress = progress + 0.02
				
					// Randomly fail between 30-70% progress
				let shouldFail = progress > 0.3 && progress < 0.7 && Bool.random()
//				let shouldFail = false
				
				if shouldFail {
					uploadState = .retry(error: "Network error occurred")
					timer.invalidate()
				} else if newProgress >= 1.0 {
					uploadState = .success
					timer.invalidate()
				} else {
					uploadState = .uploading(progress: newProgress)
				}
			}
		}
	}
}
