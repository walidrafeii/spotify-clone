//
//  SearchResultsViewController.swift
//  spotify-clone
//
//  Created by Walid Rafei on 5/20/21.
//

import UIKit

protocol SearchResultsViewControllerDelegate: AnyObject {
    func didTapResult(_ result: SearchResult)
}

class SearchResultsViewController: UIViewController {
    
    weak var delegate: SearchResultsViewControllerDelegate?
    
    private var currentSection: SearchSection? = nil
    private var albumsSection = [SearchResult]()
    private var tracksSection = [SearchResult]()
    private var artistsSection = [SearchResult]()
    private var playlistsSection = [SearchResult]()

    
    private let albumsButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .lightGray.withAlphaComponent(0.5)
        button.setAttributedTitle(NSAttributedString(string: "Albums", attributes: [.font: UIFont.systemFont(ofSize: 16, weight: .semibold)]), for: .normal)
        button.layer.masksToBounds = true
        button.tag = 1
        return button
    }()
    
    private let artistsButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(NSAttributedString(string: "Artists", attributes: [.font: UIFont.systemFont(ofSize: 16, weight: .semibold)]), for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .lightGray.withAlphaComponent(0.5)
        button.layer.masksToBounds = true
        button.tag = 2
        return button
    }()
    
    private let playlistsButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .lightGray.withAlphaComponent(0.5)
        button.setAttributedTitle(NSAttributedString(string: "Playlists", attributes: [.font: UIFont.systemFont(ofSize: 16, weight: .semibold)]), for: .normal)
        button.layer.masksToBounds = true
        button.tag = 3
        return button
    }()
    
    private let songsButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.label, for: .normal)
        button.setAttributedTitle(NSAttributedString(string: "Tracks", attributes: [.font: UIFont.systemFont(ofSize: 16, weight: .semibold)]), for: .normal)
        button.backgroundColor = .lightGray.withAlphaComponent(0.5)
        button.layer.masksToBounds = true
        button.tag = 4
        return button
    }()
    
    private let HStackHeader: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 10
        stackView.axis = .horizontal
        stackView.isHidden = true
        return stackView
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(SearchResultDefaultTableViewCell.self, forCellReuseIdentifier: SearchResultDefaultTableViewCell.identifier)
        tableView.register(SearchResultSubtitleTableViewCell.self, forCellReuseIdentifier: SearchResultSubtitleTableViewCell.identifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.isHidden = true
        tableView.rowHeight = 80
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        HStackHeader.backgroundColor = .clear
        tableView.backgroundColor = .systemBackground
        view.addSubview(HStackHeader)
        view.addSubview(tableView)
        HStackHeader.addArrangedSubview(songsButton)
        HStackHeader.addArrangedSubview(albumsButton)
        HStackHeader.addArrangedSubview(artistsButton)
        HStackHeader.addArrangedSubview(playlistsButton)
        
        albumsButton.addTarget(self, action: #selector(albumsButtonTapped), for: .touchUpInside)
        songsButton.addTarget(self, action: #selector(tracksButtonTapped), for: .touchUpInside)
        artistsButton.addTarget(self, action: #selector(artistsButtonTapped), for: .touchUpInside)
        playlistsButton.addTarget(self, action: #selector(playlistButtonTapped), for: .touchUpInside)

        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @objc private func albumsButtonTapped() {
        highlightSelectedButton(buttonTag: albumsButton.tag)
        self.currentSection = SearchSection(title: "Albums", results: albumsSection)
        guard let section = currentSection else { return }
        
        tableView.reloadData()
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        tableView.isHidden = section.results.isEmpty
        HStackHeader.isHidden = section.results.isEmpty
    }
    
    @objc private func tracksButtonTapped() {
        highlightSelectedButton(buttonTag: songsButton.tag)
        self.currentSection = SearchSection(title: "Tracks", results: tracksSection)
        guard let section = currentSection else { return }
        
        tableView.reloadData()
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        tableView.isHidden = section.results.isEmpty
        HStackHeader.isHidden = section.results.isEmpty
    }
    
    @objc private func artistsButtonTapped() {
        highlightSelectedButton(buttonTag: artistsButton.tag)
        self.currentSection = SearchSection(title: "Artists", results: artistsSection)
        guard let section = currentSection else { return }
        
        tableView.reloadData()
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        tableView.isHidden = section.results.isEmpty
        HStackHeader.isHidden = section.results.isEmpty
    }
    
    @objc private func playlistButtonTapped() {
        highlightSelectedButton(buttonTag: playlistsButton.tag)
        self.currentSection = SearchSection(title: "Playlists", results: playlistsSection)
        guard let section = currentSection else { return }
        
        tableView.reloadData()
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        tableView.isHidden = section.results.isEmpty
        HStackHeader.isHidden = section.results.isEmpty
    }
    
    private func highlightSelectedButton(buttonTag: Int) {
        for tag in 1...4 {
            if tag != buttonTag {
                let view = view.viewWithTag(tag)
                view?.backgroundColor = .lightGray.withAlphaComponent(0.5)
            }
        }
        let view = view.viewWithTag(buttonTag)
        view?.backgroundColor = .systemTeal
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let window = UIApplication.shared.windows[0]
        let topPadding = window.safeAreaInsets.top
        
        HStackHeader.frame = CGRect(x: view.safeAreaLayoutGuide.layoutFrame.minX + 5, y: view.safeAreaLayoutGuide.layoutFrame.minY + 15, width: view.width - 10, height: 40)
        tableView.frame = CGRect(x: 0, y: HStackHeader.bottom, width: view.width, height: view.height - HStackHeader.height - topPadding - 30)
        
        albumsButton.layer.cornerRadius = albumsButton.height / 2
        songsButton.layer.cornerRadius = songsButton.height / 2
        artistsButton.layer.cornerRadius = artistsButton.height / 2
        playlistsButton.layer.cornerRadius = playlistsButton.height / 2
    }
    
    func update(with results: [SearchResult]) {
        let artists = results.filter({
            switch $0 {
            case .artist: return true
            default: return false
            }
        })
        
        let albums = results.filter({
            switch $0 {
            case .album: return true
            default: return false
            }
        })
        
        let tracks = results.filter({
            switch $0 {
            case .track: return true
            default: return false
            }
        })
        
        let playlists = results.filter({
            switch $0 {
            case .playlist: return true
            default: return false
            }
        })
        self.albumsSection = albums
        self.tracksSection = tracks
        self.artistsSection = artists
        self.playlistsSection = playlists
        songsButton.sendActions(for: .touchUpInside)
    }

}

extension SearchResultsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = currentSection else { return 0 }
        return section.results.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if currentSection != nil { return 1 }
        else { return 0 }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let result = currentSection?.results[indexPath.row] else { return UITableViewCell() }
        switch result {
        case .artist(let artist):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultDefaultTableViewCell.identifier, for: indexPath) as? SearchResultDefaultTableViewCell else {
                    return UITableViewCell()
            }
            let viewModel = SearchResultDefaultTableViewCellViewModel(
                title: artist.name,
                imageURL: URL(string: artist.images?.first?.url ?? "")
            )
            cell.configure(with: viewModel)
            return cell
            
        case .album(let album):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultSubtitleTableViewCell.identifier, for: indexPath) as? SearchResultSubtitleTableViewCell else {
                    return UITableViewCell()
            }
            let viewModel = SearchResultSubtitleTableViewCellViewModel(
                title: album.name,
                subtitle: album.artists.first?.name ?? "",
                imageURL: URL(string: album.images.first?.url ?? "")
            )
            cell.configure(with: viewModel)
            return cell
            
        case .track(let track):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultSubtitleTableViewCell.identifier, for: indexPath) as? SearchResultSubtitleTableViewCell else {
                    return UITableViewCell()
            }
            let viewModel = SearchResultSubtitleTableViewCellViewModel(
                title: track.name,
                subtitle: track.artists.first?.name ?? "",
                imageURL: URL(string: track.album?.images.first?.url ?? "")
            )
            cell.configure(with: viewModel)
            return cell
            
        case .playlist(let playlist):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultSubtitleTableViewCell.identifier, for: indexPath) as? SearchResultSubtitleTableViewCell else {
                    return UITableViewCell()
            }
            let viewModel = SearchResultSubtitleTableViewCellViewModel(
                title: playlist.name,
                subtitle: playlist.owner.display_name,
                imageURL: URL(string: playlist.images.first?.url ?? "")
            )
            cell.configure(with: viewModel)
            return cell

        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let section = currentSection else { return }
        let result = section.results[indexPath.row]
        delegate?.didTapResult(result)
    }
}
