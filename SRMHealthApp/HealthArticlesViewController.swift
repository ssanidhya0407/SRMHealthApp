//
//  HealthArticlesViewController.swift
//  SRMHealthApp
//
//  Created by Sanidhya's MacBook Pro on 11/03/25.
//

import UIKit
import FirebaseFirestore

struct HealthArticle {
    var id: String
    var title: String
    var content: String
    var category: String
    
    init(dictionary: [String: Any]) {
        self.id = dictionary["id"] as? String ?? ""
        self.title = dictionary["title"] as? String ?? ""
        self.content = dictionary["content"] as? String ?? ""
        self.category = dictionary["category"] as? String ?? ""
    }
}

class HealthArticlesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let tableView = UITableView()
    var articles: [HealthArticle] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Health Articles"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(HealthArticleTableViewCell.self, forCellReuseIdentifier: "HealthArticleCell")
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        fetchArticles()
    }
    
    func fetchArticles() {
        let db = Firestore.firestore()
        db.collection("articles").getDocuments { (snapshot, error) in
            if let error = error {
                print("Error fetching articles: \(error)")
                return
            }
            guard let documents = snapshot?.documents else { return }
            self.articles = documents.map { HealthArticle(dictionary: $0.data()) }
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HealthArticleCell", for: indexPath) as! HealthArticleTableViewCell
        let article = articles[indexPath.row]
        cell.configure(with: article)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let article = articles[indexPath.row]
        let articleDetailVC = HealthArticleDetailViewController(article: article)
        navigationController?.pushViewController(articleDetailVC, animated: true)
    }
}

class HealthArticleTableViewCell: UITableViewCell {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .gray
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(titleLabel)
        addSubview(categoryLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            categoryLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            categoryLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func configure(with article: HealthArticle) {
        titleLabel.text = article.title
        categoryLabel.text = article.category
    }
}
