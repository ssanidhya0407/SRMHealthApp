//
//  LabTestDetailViewController.swift
//  SRMHealthApp
//
//  Created by Sanidhya's MacBook Pro on 11/03/25.
//


import UIKit

class LabTestDetailViewController: UIViewController {
    
    var labTest: LabTest
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    let addToCartButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add to Cart", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.addTarget(self, action: #selector(addToCartTapped), for: .touchUpInside)
        return button
    }()
    
    init(labTest: LabTest) {
        self.labTest = labTest
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = labTest.name
        
        setupViews()
        populateData()
    }
    
    func setupViews() {
        view.addSubview(descriptionLabel)
        view.addSubview(priceLabel)
        view.addSubview(addToCartButton)
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        addToCartButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            priceLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
            priceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            addToCartButton.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 20),
            addToCartButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addToCartButton.widthAnchor.constraint(equalToConstant: 200),
            addToCartButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func populateData() {
        descriptionLabel.text = labTest.description
        priceLabel.text = "$\(labTest.price)"
    }
    
    @objc func addToCartTapped() {
        // Add lab test to cart logic here
        let alert = UIAlertController(title: "Added to Cart", message: "\(labTest.name) has been added to your cart.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}