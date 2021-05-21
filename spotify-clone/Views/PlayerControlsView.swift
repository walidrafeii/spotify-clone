//
//  PlayerControlsView.swift
//  spotify-clone
//
//  Created by Walid Rafei on 5/20/21.
//

import Foundation
import UIKit

protocol PlayerControlViewDelegate: AnyObject {
    func playerControlsViewDidTapPlayPause(_ playerControlsView: PlayerControlsView)
    func playerControlsViewDidTapForwardButton(_ playerControlsView: PlayerControlsView)
    func playerControlsViewDidTapPreviousButton(_ playerControlsView: PlayerControlsView)
    func playerControlsViewDidSlide(_ playerControlsView: PlayerControlsView, withValue: Float)
    func playerControlsViewTouchDownSlider(_ playerControlsView: PlayerControlsView)
}

final class PlayerControlsView: UIView {
    
    weak var delegate: PlayerControlViewDelegate?
    var isPlaying = true
    
    private let trackSlider: UISlider = {
        let slider = UISlider()
        slider.value = 0.0
        slider.tintColor = .label
        slider.isContinuous = false
        return slider
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let previousButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(systemName: "backward.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 35, weight: .regular))
        button.setImage(image, for: .normal)
        return button
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(systemName: "forward.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 35, weight: .regular))
        button.setImage(image, for: .normal)
        return button
    }()
    
    private let tracklengthLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 14, weight: .light)
        label.textColor = .secondaryLabel
        label.text = "00:00"
        return label
    }()
    
    private let currentTrackTime: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 14, weight: .light)
        label.textColor = .secondaryLabel
        label.text = "00:00"
        return label
    }()
    
    private let pause = UIImage(systemName: "pause", withConfiguration: UIImage.SymbolConfiguration(pointSize: 40, weight: .regular))
    
    private let play = UIImage(systemName: "play.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 40, weight: .regular))

    
    private let playPauseButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(systemName: "pause", withConfiguration: UIImage.SymbolConfiguration(pointSize: 40, weight: .regular))
        button.setImage(image, for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        addSubview(nameLabel)
        addSubview(subtitleLabel)
        addSubview(trackSlider)
        addSubview(nextButton)
        addSubview(previousButton)
        addSubview(playPauseButton)
        addSubview(currentTrackTime)
        addSubview(tracklengthLabel)
        
        nextButton.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
        previousButton.addTarget(self, action: #selector(didTapPrevious), for: .touchUpInside)
        playPauseButton.addTarget(self, action: #selector(didTapPlayPause), for: .touchUpInside)
        trackSlider.addTarget(self, action: #selector(userDidSeekTrack), for: .valueChanged)
        trackSlider.addTarget(self, action: #selector(userDidTouchDownSlider), for: .touchDown)
        clipsToBounds = true
    }
    
    @objc func userDidSeekTrack() {
        delegate?.playerControlsViewDidSlide(self, withValue: trackSlider.value)
    }
    
    @objc func didTapNext() {
        delegate?.playerControlsViewDidTapForwardButton(self)
    }
    
    @objc func userDidTouchDownSlider() {
        delegate?.playerControlsViewTouchDownSlider(self)
    }
    
    @objc func didTapPrevious() {
        delegate?.playerControlsViewDidTapPreviousButton(self)
    }
    
    @objc func didTapPlayPause() {
        self.isPlaying = !self.isPlaying
        delegate?.playerControlsViewDidTapPlayPause(self)
        //update icon
        updatePlayButton(isPlaying: isPlaying)
    }
    
    func updatePlayButton(isPlaying: Bool) {
        playPauseButton.setImage(isPlaying ? pause: play, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        nameLabel.frame = CGRect(x: 0, y: 0, width: width, height: 50)
        subtitleLabel.frame = CGRect(x: 0, y: nameLabel.bottom + 10, width: width, height: 50)
        trackSlider.frame = CGRect(x: 10, y: subtitleLabel.bottom + 20, width: width - 20, height: 44)
        tracklengthLabel.frame = CGRect(x: width - 50, y: trackSlider.bottom + 1, width: 60, height: 20)
        currentTrackTime.frame = CGRect(x: 18, y: trackSlider.bottom + 1, width: 60, height: 20)
        
        let buttonSize: CGFloat = 60
        playPauseButton.frame = CGRect(x: (width - buttonSize) / 2, y: trackSlider.bottom + 30, width: buttonSize, height: buttonSize)
        
        previousButton.frame = CGRect(x: playPauseButton.left - 60 - buttonSize, y: playPauseButton.top, width: buttonSize, height: buttonSize)
        
        nextButton.frame = CGRect(x: playPauseButton.left + 60 + buttonSize, y: playPauseButton.top, width: buttonSize, height: buttonSize)
    }
    
    public func configure(with viewModel: PlayerControlsViewModel) {
        nameLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
        tracklengthLabel.text = secondsToHoursMinutesSeconds(seconds: Double(viewModel.trackLength ?? 0))
        trackSlider.maximumValue = viewModel.trackLength ?? 0
    }
    
    public func updateSlider(currentTimePlayed: Float?, totalTrackLength: Float?) {
        trackSlider.value = currentTimePlayed ?? 0.0
        let trackLength = Double(totalTrackLength ?? 0.0)
        let timePlayed = Double(currentTimePlayed ?? 0.0)
        tracklengthLabel.text = secondsToHoursMinutesSeconds(seconds: trackLength - timePlayed)
        currentTrackTime.text = secondsToHoursMinutesSeconds(seconds: timePlayed)
    }

    func secondsToHoursMinutesSeconds (seconds : Double) -> (String) {
        let (_,  minf) = modf (seconds / 3600)
        let (min, secf) = modf (60 * minf)
        return ("\(Int(min)):\(Int(60 * secf))")
    }
}


