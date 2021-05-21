//
//  PlaybackPresenter.swift
//  spotify-clone
//
//  Created by Walid Rafei on 5/20/21.
//

import Foundation
import UIKit
import AVFoundation

protocol playerDataSource: AnyObject {
    var songName: String? { get }
    var subtitle: String? { get }
    var imageURL: URL? { get }
    var maximumTimeValue: Float? { get }
}

final class PlaybackPresenter {
    static let shared = PlaybackPresenter()
    
    private var track: AudioTrack?
    private var tracks = [AudioTrack]()
    private var timeObserver: Any? = nil
    private var vc: PlayerViewController? = nil
    var currentItem = 0
    var player: AVPlayer?
    
    var currentTrack: AudioTrack? {
        if let track = track, tracks.isEmpty {
            return track
        }
        
        else if !tracks.isEmpty {
            return tracks[currentItem]
        }
        return nil
    }
    
    var currentTrackURL: URL? {
        get {
            guard let playerItemURL = URL(string: currentTrack?.preview_url ?? "") else { return nil}
            return playerItemURL
        }
    }
            
    func startPlayback(from viewController: UIViewController, track: AudioTrack) {
        guard let url = URL(string: track.preview_url ?? "") else { return }
        player = AVPlayer(url: url)
        player?.volume = 1
        
        vc = PlayerViewController()
        guard let vc = vc else { return }
        vc.title = track.name
        vc.datasource = self
        vc.delegate = self
        self.tracks = []
        self.track = track
        viewController.present(UINavigationController(rootViewController: vc), animated: true, completion: { [weak self] in
            self?.player?.play()
        })
        addTimeObserver()
    }
    
    @objc func playerDidFinishPlaying() {
        forwardPlayer()
    }
    
    func startPlayback(from viewController: UIViewController, tracks: [AudioTrack]) {
        vc = PlayerViewController()
        guard let vc = vc else { return }
        
        self.tracks = tracks
        self.track = nil
        vc.datasource = self
        vc.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: nil)
        
        guard let currentTrackURL = currentTrackURL else { return }
        player = AVPlayer(url: currentTrackURL)

        viewController.present(UINavigationController(rootViewController: vc), animated: true, completion:{ [weak self] in
            self?.player?.play()
        })
        addTimeObserver()
    }
    
    private func addTimeObserver() {
        self.timeObserver = player?.addPeriodicTimeObserver(forInterval: CMTimeMake(value: 1, timescale: 30), queue: DispatchQueue.main, using: { [weak self] (time) in
            guard let strongSelf = self else { return }
            
            if strongSelf.player!.currentItem?.status == .readyToPlay {
                let time : Float64 = CMTimeGetSeconds(strongSelf.player!.currentTime())
                strongSelf.vc?.controlsView.updateSlider(currentTimePlayed: Float(time), totalTrackLength: strongSelf.maximumTimeValue)
            }
        })
    }
    
    private func forwardPlayer() {
        if tracks.isEmpty {
            player?.pause()
            updatePlayerPlayButton()
        }
        else {
            if currentItem + 1 > tracks.count - 1 {
                currentItem = 0
            } else {
                currentItem += 1;
            }
            guard let currentTrackURL = currentTrackURL else { return }
            let playerItem = AVPlayerItem(url: currentTrackURL)
            player?.replaceCurrentItem(with: playerItem)
            player?.play()
            vc?.refreshUI()
        }
    }
    
}
extension PlaybackPresenter: playerDataSource {
    
    var maximumTimeValue: Float? {
        if player != nil {
            let duration : CMTime = self.player?.currentItem?.asset.duration ?? CMTime(value: 0, timescale: 0)
            let seconds : Float64 = CMTimeGetSeconds(duration)
            return Float(seconds)
        }
        return nil
    }
    
    var songName: String? {
        return currentTrack?.name
    }
    
    var subtitle: String? {
        return currentTrack?.artists.first?.name
    }
    
    var imageURL: URL? {
        return URL(string: currentTrack?.album?.images.first?.url ?? "")
    }

}

extension PlaybackPresenter: PlayerViewControllerDelegate {
    func didClosePlayer() {
        guard let timeObserver = timeObserver else { return }
        player?.removeTimeObserver(timeObserver)
        self.timeObserver = nil
        self.track = nil
        self.tracks = []
        self.currentItem = 0
        player?.pause()
        NotificationCenter.default.removeObserver(self)
    }
    
    
    func didTouchDownSlider() {
        guard let timeObserver = timeObserver else { return }
        player?.removeTimeObserver(timeObserver)
        self.timeObserver = nil
    }
    
    
    func didTapPlayPause() {
        if let player = player {
            if player.timeControlStatus == .playing {
                player.pause()
            }
            else if player.timeControlStatus == .paused {
                player.play()
            }
        }
    }
    
    func didTapForward() {
        forwardPlayer()
    }
    
    func didTapBackward() {
        if tracks.isEmpty {
            player?.pause()
            player?.seek(to: .zero)
            player?.play()
            updatePlayerPlayButton()
        }
        else {
            if currentItem - 1 < 0 {
                currentItem = (tracks.count - 1) < 0 ? 0 : (tracks.count - 1)
            } else {
                currentItem -= 1
            }
            guard let currentTrackURL = currentTrackURL else { return }
            let playerItem = AVPlayerItem(url: currentTrackURL)
            player?.replaceCurrentItem(with: playerItem)
            vc?.refreshUI()
        }
    }
    
    func didSlideTrack(withValue: Float) {
        
        if player != nil {
            let seconds : Int64 = Int64(withValue)
            let targetTime:CMTime = CMTimeMake(value: seconds, timescale: 1)
            player!.seek(to: targetTime)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                self?.addTimeObserver()
            }
            player?.play()
            updatePlayerPlayButton()
        }
    }
    
    private func updatePlayerPlayButton() {
        if player != nil {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                self?.vc?.controlsView.isPlaying = self?.player?.timeControlStatus == .playing
                self?.vc?.controlsView.updatePlayButton(isPlaying: self?.player?.timeControlStatus == .playing )
            }
        }
    }
}
