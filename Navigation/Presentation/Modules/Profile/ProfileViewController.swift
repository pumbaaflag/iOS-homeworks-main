//
//  ProfileViewController.swift
//  Navigation
//
//  Created by pumbaaflag on 08.02.2023.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    // MARK: - PROPERTIES
    

    private lazy var tableView: UITableView = { 
        let tableView = UITableView()
        tableView.backgroundColor = .systemGray6
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
        tableView.register(PhotosTableViewCell.self, forCellReuseIdentifier: "PhotoCell")
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: "PostCell")
        tableView.register(ProfileTableHeaderView.self, forHeaderFooterViewReuseIdentifier: "TableHeder")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        
        return tableView
    }()
    
    // MARK: - LIFECYCLE METHODS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - SETUP SUBVIEWS
    private func setupTableView() {
        self.view.addSubview(self.tableView)
        
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
}

// MARK: - EXTENSIONS

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? { // HEADER
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "TableHeder") as! ProfileTableHeaderView
        view.delegate = self
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            
            return 250 // ВЫСОТА HEADER
        } else {
            
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            
            return 1
        } else {
            
            return newsArticles.count // КОЛИЧЕСТВО ПОСТОВ В СЕКЦИИ
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 { // ЯЧЕЙКА ФОТОГРАФИЙ
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell", for: indexPath) as? PhotosTableViewCell else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
                
                return cell
            }
            cell.selectionStyle = .none
            cell.delegate = self
            cell.layer.shouldRasterize = true
            cell.layer.rasterizationScale = UIScreen.main.scale
            
            return cell
        } else { // ЯЧЕЙКИ ПОСТЫ
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? PostTableViewCell else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
                
                return cell
            }
            cell.selectionStyle = .none
            cell.delegate = self
            let article = newsArticles[indexPath.row]
            let viewModel = PostTableViewCell.ViewModel(
                author: article.author,
                description: article.description,
                image: article.image,
                likes: article.likes,
                views: article.views)
            cell.setup(with: viewModel)
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle { // УДАЛЕНИЕ ЯЧЕЙКИ ТОЛЬКО ИЗ СЕКЦИЙ ПОСТОВ
        if indexPath.section == 0 {

            return .none
        } else {

            return .delete
        }
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) { // УДАЛЕНИЕ ЯЧЕЙКИ
        self.tableView.beginUpdates()
        newsArticles.remove(at: indexPath.row)
        self.tableView.deleteRows(at: [indexPath], with: .automatic)
        self.tableView.endUpdates()
    }
}

extension ProfileViewController: ProfileTableHeaderViewProtocol {
    
    func buttonAction() { // АНИМАЦИЯ HEADER
        self.tableView.beginUpdates()
     
        self.tableView.endUpdates()
       
    }
    
    func delegateActionAnimatedAvatar(cell: ProfileTableHeaderView) { // АНИМАЦИЯ АВАТАР
        let animatedAvatarViewController = AnimatedAvatarViewController()
        self.view.addSubview(animatedAvatarViewController.view)
        self.addChild(animatedAvatarViewController)
        animatedAvatarViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            animatedAvatarViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            animatedAvatarViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            animatedAvatarViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            animatedAvatarViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        animatedAvatarViewController.didMove(toParent: self)
    }
}


extension ProfileViewController: PhotosTableViewCellProtocol { // ПЕРЕХОД К ФОТОГРАФИЯМ

    func delegateButtonAction(cell: PhotosTableViewCell) {
        let photosViewController = PhotosViewController()
        self.navigationController?.pushViewController(photosViewController, animated: true)
    }
}

extension ProfileViewController: PostTableViewCellProtocol { // НАЖАТИЕ НА LIKE И IMAGE

    func tapPostImageViewGestureRecognizerDelegate(cell: PostTableViewCell) { // УВЕЛИЧЕНИЕ ПРОСМОТРОВ
        
        let presentPostViewController = FullPostView()
        guard let index = self.tableView.indexPath(for: cell)?.row else { return }
        let indexPath = IndexPath(row: index, section: 1)
        newsArticles[indexPath.row].views += 1
        let article = newsArticles[indexPath.row]

        let viewModel = FullPostView.ViewModel(
            author: article.author,
            description: article.description,
            image: article.image,
            likes: article.likes,
            views: article.views)

        presentPostViewController.setup(with: viewModel)
        self.view.addSubview(presentPostViewController)

        presentPostViewController.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            presentPostViewController.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            presentPostViewController.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            presentPostViewController.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            presentPostViewController.topAnchor.constraint(equalTo: view.topAnchor)
        ])

        self.tableView.reloadRows(at: [indexPath], with: .fade)
    }

    func tapLikeTitleGestureRecognizerDelegate(cell: PostTableViewCell) { // УВЕЛИЧЕНИЕ ЛАЙКОВ
        guard let index = self.tableView.indexPath(for: cell)?.row else { return }
        let indexPath = IndexPath(row: index, section: 1)
        newsArticles[index].likes += 1
        self.tableView.reloadRows(at: [indexPath], with: .fade)
    }
}
