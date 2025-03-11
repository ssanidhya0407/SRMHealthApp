//
//  OrderDetailsViewController.swift
//  SRMHealthApp
//
//  Created by Sanidhya's MacBook Pro on 11/03/25.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

struct Order {
    var id: String
    var userId: String
    var orderDate: Date
    var items: [String]
    var status: String
    
    init(dictionary: [String: Any]) {
        self.id = dictionary["id"] as? String ?? ""
        self.userId = dictionary["userId"] as? String ?? ""
        self.orderDate = (dictionary["orderDate"] as? Timestamp)?.dateValue() ?? Date()
        self.items = dictionary["items"] as? [String] ?? []
        self.status = dictionary["status"] as? String ?? ""
    }
}

class OrderDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let tableView = UITableView()
    var orders: [Order] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Order Details"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(OrderTableViewCell.self, forCellReuseIdentifier: "OrderCell")
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        fetchOrders()
    }
    
    func fetchOrders() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        db.collection("orders").whereField("userId", isEqualTo: userId).getDocuments { (snapshot, error) in
            if let error = error {
                print("Error fetching orders: \(error)")
                return
            }
            guard let documents = snapshot?.documents else { return }
            self.orders = documents.map { Order(dictionary: $0.data()) }
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath) as! OrderTableViewCell
        let order = orders[indexPath.row]
        cell.configure(with: order)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let order = orders[indexPath.row]
        let orderDetailVC = OrderDetailViewController(order: order)
        navigationController?.pushViewController(orderDetailVC, animated: true)
    }
}

class OrderTableViewCell: UITableViewCell {
    
    let orderDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    let statusLabel: UILabel = {
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
        addSubview(orderDateLabel)
        addSubview(statusLabel)
        
        orderDateLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            orderDateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            orderDateLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            statusLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            statusLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func configure(with order: Order) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        orderDateLabel.text = dateFormatter.string(from: order.orderDate)
        statusLabel.text = order.status
    }
}
