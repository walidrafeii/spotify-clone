//
//  PlayerViewController.swift
//  spotify-clone
//
//  Created by Walid Rafei on 5/19/21.
//

import UIKit
import SDWebImage

protocol PlayerViewControllerDelegate: AnyObject {
    func didTapPlayPause()
    func didTapForward()
    func didTapBackward()
    func didSlideTrack(withValue: Float)
    func didClosePlayer()
    func didTouchDownSlider()
}

class PlayerViewController: UIViewController {
    
    let controlsView = PlayerControlsView()
    
    weak var datasource: playerDataSource?
    weak var delegate: PlayerViewControllerDelegate?

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .red
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(imageView)
        view.addSubview(controlsView)
        controlsView.delegate = self
        configureBarButtons()
        configureWithDataSource()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        delegate?.didClosePlayer()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.width, height: view.width)
        controlsView.frame = CGRect(x: 10, y: imageView.bottom + 10, width: view.width - 20, height: view.height - imageView.height - view.safeAreaInsets.top - view.safeAreaInsets.bottom - 15)
    }
    
    private func configureWithDataSource() {
        imageView.sd_setImage(with: datasource?.imageURL, completed: nil)
        let viewModel = PlayerControlsViewModel(title: datasource?.songName, subtitle: datasource?.subtitle, trackLength: datasource?.maximumTimeValue)
        controlsView.configure(with: viewModel)
    }
    
    private func configureBarButtons() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapClose))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapAction))
    }
    
    func refreshUI() {
        configureWithDataSource()
    }
    
    @objc private func didTapClose() {
        dismiss(animated: true, completion: nil)
        delegate?.didClosePlayer()
    }

    @objc private func didTapAction() {
        dismiss(animated: true, completion: nil)
    }
}

extension PlayerViewController: PlayerControlViewDelegate {
    func playerControlsViewDidSlide(_ playerControlsView: PlayerControlsView, withValue: Float) {
        delegate?.didSlideTrack(withValue: withValue)
    }
    
    func playerControlsViewTouchDownSlider(_ playerControlsView: PlayerControlsView) {
        delegate?.didTouchDownSlider()
    }
    
    func playerControlsViewDidTapPlayPause(_ playerControlsView: PlayerControlsView) {
        delegate?.didTapPlayPause()
    }
    
    func playerControlsViewDidTapForwardButton(_ playerControlsView: PlayerControlsView) {
        delegate?.didTapForward()
    }
    
    func playerControlsViewDidTapPreviousButton(_ playerControlsView: PlayerControlsView) {
        delegate?.didTapBackward()
    }
    
}
