//
//  ViewController.swift
//  TrackingCode
//
//  Created by Владимир on 15.12.2023.
//

import UIKit

class ViewController: UIViewController {
    
    var botViewConstrains = NSLayoutConstraint()
    let id = "ID"
    
    var retrievedArray = UserDefaults.standard.array(forKey: "mainArrayKey")
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .systemGray5
        collection.showsVerticalScrollIndicator = false
        collection.isHidden = true
        return collection
    }()
    
    var botView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 25
        return view
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(systemName: "tray.fill")
        imageView.tintColor = .systemGray3
        imageView.image = image
        return imageView
    }()
    
    let noLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .systemGray3
        label.text = "You dont have any package yet"
        return label
    }()
    
    let trackNumberLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    let topViewinBotView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray4
        view.layer.cornerRadius = 2
        return view
    }()
    
    let viewTop: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 30
        view.backgroundColor = .systemBlue
        return view
    }()
    
    let errorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .red
        label.layer.borderColor = UIColor.clear.cgColor
        label.layer.borderWidth = 0
        label.alpha = 0.0
        label.text = "  Error tracking number"
        return label
    }()
    
    let errorLabelinBoatView: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .red
        label.layer.borderColor = UIColor.clear.cgColor
        label.layer.borderWidth = 0
        label.alpha = 0
        label.text = "Tracking number already exists"
        return label
    }()
    
    let topLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 27)
        label.textColor = .white
        label.text = "Lets track your package"
        return label
    }()
    
    let boatLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .lightText
        label.text = "Please enter your tracking number"
        return label
    }()
    
    let descriptionTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Description (optional)..."
        
        textField.backgroundColor = .white
        textField.layer.borderColor = UIColor.systemGray4.cgColor
        textField.layer.borderWidth = 0.7
        
        textField.layer.cornerRadius = 25
        
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: textField.frame.height))
        textField.leftView = leftPaddingView
        textField.leftViewMode = .always
        
        return textField
    }()
    
    let codeTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Tracking number..."
        
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 25
        
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftView = leftPaddingView
        textField.leftViewMode = .always
        
        return textField
    }()
    
    let searchButton: UIButton = {
        let but = UIButton()
        let searchImage = UIImage(systemName: "magnifyingglass")
        but.setImage(searchImage, for: .normal)
        but.layer.cornerRadius = 26
        but.tintColor = .black
        but.backgroundColor = .white
        
        return but
    }()
    
    
    let trackButton: UIButton = {
        let button = UIButton()
        button.setTitle("Track", for: .normal)
        button.layer.cornerRadius = 26
        button.backgroundColor = .systemBlue
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20.0)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        //        UserDefaults.standard.removeObject(forKey: "trackedItemsMain")
        //        UserDefaults.standard.removeObject(forKey: "mainArrayKey")
        view.backgroundColor = .systemGray5
        collectionView.isEditing = true
        collectionView.isUserInteractionEnabled = true
        self.navigationItem.backButtonTitle = " "
        
        setupConstrains()
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: id)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        if retrievedArray?.count != 0 {
            
            imageView.isHidden = true
            noLabel.isHidden = true
            collectionView.isHidden = false
        }
        
    }
    
    //MARK: -Add View
    func setupView() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        codeTextField.delegate = self
        view.addSubview(viewTop)
        viewTop.translatesAutoresizingMaskIntoConstraints = false
        viewTop.addSubview(topLabel)
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        viewTop.addSubview(boatLabel)
        boatLabel.translatesAutoresizingMaskIntoConstraints = false
        viewTop.addSubview(codeTextField)
        viewTop.translatesAutoresizingMaskIntoConstraints = false
        viewTop.addSubview(searchButton)
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        viewTop.addSubview(errorLabel)
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(botView)
        botView.translatesAutoresizingMaskIntoConstraints = false
        botView.addSubview(topViewinBotView)
        topViewinBotView.translatesAutoresizingMaskIntoConstraints = false
        botView.addSubview(trackNumberLabel)
        trackNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        botView.addSubview(descriptionTextField)
        descriptionTextField.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextField.delegate = self
        botView.addSubview(trackButton)
        trackButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(noLabel)
        noLabel.translatesAutoresizingMaskIntoConstraints = false
        botView.addSubview(errorLabelinBoatView)
        errorLabelinBoatView.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    //MARK: -Add Constrains
    func setupConstrains() {
        
        view.addSubview(imageView)
        
        viewTop.topAnchor.constraint(equalTo: view.topAnchor, constant: -30).isActive = true
        viewTop.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -650).isActive = true
        viewTop.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        viewTop.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        topLabel.topAnchor.constraint(equalTo: viewTop.topAnchor, constant: 120).isActive = true
        topLabel.leftAnchor.constraint(equalTo: viewTop.leftAnchor, constant: 20).isActive = true
        
        boatLabel.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 5).isActive = true
        boatLabel.leftAnchor.constraint(equalTo: viewTop.leftAnchor, constant: 20).isActive = true
        boatLabel.bottomAnchor.constraint(equalTo: viewTop.bottomAnchor, constant: -90).isActive = true
        codeTextField.frame = CGRect(x: 20, y: 200, width: 290, height: 50)
        searchButton.topAnchor.constraint(equalTo: boatLabel.bottomAnchor, constant: 15).isActive = true
        searchButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
        searchButton.leftAnchor.constraint(equalTo: codeTextField.rightAnchor, constant: 20).isActive = true
        searchButton.bottomAnchor.constraint(equalTo: viewTop.bottomAnchor, constant: -25).isActive = true
        searchButton.isUserInteractionEnabled = true
        searchButton.addTarget(self, action: #selector(touchDown(_:)), for: .touchDown)
        searchButton.addTarget(self, action: #selector(touchUp), for: .touchUpInside)
        
        errorLabel.topAnchor.constraint(equalTo: codeTextField.bottomAnchor, constant: 2).isActive = true
        errorLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        
        botViewConstrains = botView.topAnchor.constraint(equalTo: view.bottomAnchor, constant: 1)
        botViewConstrains.isActive = true
        botView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        botView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        botView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        
        topViewinBotView.topAnchor.constraint(equalTo: botView.topAnchor, constant: 5).isActive = true
        topViewinBotView.leftAnchor.constraint(equalTo: botView.leftAnchor, constant: 180).isActive = true
        topViewinBotView.rightAnchor.constraint(equalTo: botView.rightAnchor, constant: -180).isActive = true
        topViewinBotView.bottomAnchor.constraint(equalTo: botView.topAnchor, constant: 10).isActive = true
        
        trackNumberLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        trackNumberLabel.topAnchor.constraint(equalTo: topViewinBotView.bottomAnchor, constant: 20).isActive = true
        
        errorLabelinBoatView.topAnchor.constraint(equalTo: trackNumberLabel.bottomAnchor, constant: 5).isActive = true
        errorLabelinBoatView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        descriptionTextField.topAnchor.constraint(equalTo: trackNumberLabel.bottomAnchor, constant: 30).isActive = true
        descriptionTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        descriptionTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20)
            .isActive = true
        descriptionTextField.bottomAnchor.constraint(equalTo: trackNumberLabel.bottomAnchor, constant: 80).isActive = true
        
        trackButton.topAnchor.constraint(equalTo: descriptionTextField.bottomAnchor, constant: 20).isActive = true
        trackButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        trackButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        trackButton.bottomAnchor.constraint(equalTo: descriptionTextField.bottomAnchor, constant: 70).isActive = true
        trackButton.isUserInteractionEnabled = true
        trackButton.addTarget(self, action: #selector(touchDown(_:)), for: .touchDown)
        trackButton.addTarget(self, action: #selector(touchUp(_:)), for: .touchUpInside)
        
        imageView.frame = CGRect(x: 150, y: 450, width: 120, height: 70)
        
        noLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20).isActive = true
        noLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        collectionView.topAnchor.constraint(equalTo: viewTop.bottomAnchor, constant: 10).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 5).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -5).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    
    //MARK: -func buttonsearch
    
    @objc func touchDown(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2) {
            sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }
    }
    
    
    @objc func touchUp(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2) {
            sender.transform = .identity
        }
        
        if sender == searchButton {
            codeTextField.resignFirstResponder()
            searchAPI()
        }
        
        if sender == trackButton {
            let trackingNumber = codeTextField.text!
            let description = descriptionTextField.text ?? "Null"

            if var savedArray = UserDefaults.standard.array(forKey: "mainArrayKey") as? [[String]] {
                
                if !savedArray.contains(where: { $0[0] == trackingNumber }) {
                    
                    savedArray.append([trackingNumber, description])

                    UserDefaults.standard.set(savedArray, forKey: "mainArrayKey")
                    retrievedArray = savedArray
                    UserDefaults.standard.synchronize()

                    collectionView.reloadData()

                    if savedArray.count > 0 {
                        imageView.isHidden = true
                        noLabel.isHidden = true
                        collectionView.isHidden = false
                    }
                    
                } else {

                    DispatchQueue.main.async {
                        UIView.animate(withDuration: 0.2) {
                            self.errorLabelinBoatView.alpha = 1
                        }
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        UIView.animate(withDuration: 0.5) {
                            self.errorLabelinBoatView.alpha = 0
                        }
                    }
                }
            } else {
                
                let newElement = [trackingNumber, description]
                UserDefaults.standard.set([newElement], forKey: "mainArrayKey")
                UserDefaults.standard.synchronize()

                collectionView.reloadData()

                imageView.isHidden = true
                noLabel.isHidden = true
                collectionView.isHidden = false
            }
        }
    }
      
    func searchAPI() {
        let trackingNumber = codeTextField.text!
        guard let url = URL(string: "https://api.track24.ru/tracking.json.php?apiKey=2b1cc0250fddc14198e0446cf74d3f27&domain=track24.ru&pretty=true&code=\(codeTextField.text ?? "Error")") else { return }
        
        let request = URLRequest(url: url)
        let session = URLSession.shared.dataTask(with: request) { [self] data, response, error in
            do {
                if let data = data {
                    let track = try JSONDecoder().decode(Tracker.self, from: data)
                    
                    var existingTracks = UserDefaults.standard.array(forKey: "trackedItemsMain") as? [[String: Any]] ?? []
                    
                    
                    if var savedArray = UserDefaults.standard.array(forKey: "mainArrayKey") as? [[String]] {
                        
                        
                        if savedArray.contains(where: { $0[0] == trackingNumber }) {
                            DispatchQueue.main.async {
                                UIView.animate(withDuration: 0.2) {
                                    errorLabel.text = "  Tracking number already exists"
                                    self.errorLabel.alpha = 1
                                }
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                UIView.animate(withDuration: 0.5) {
                                    errorLabel.text = "  Error tracking number"
                                    self.errorLabel.alpha = 0
                                }
                            }
                            return
                        }
                    }
                    
                    existingTracks.append([
                        "itemWeight": "\(track.data.itemWeight )",
                        "fromCity": "\(track.data.fromCity)",
                        "fromAddress": "\(track.data.fromAddress)" ,
                        "fromCountry": "\(track.data.fromCountry)" ,
                        "destinationCity": "\(track.data.destinationCity)",
                        "destinationAddress": "\(track.data.destinationAddress)" ,
                        "lastPoint": "\(track.data.lastPoint.operationAttribute)",
                        "destinationCountry": "\(track.data.destinationCountry )"
                        
                    ])
                    UserDefaults.standard.synchronize()
                    UserDefaults.standard.set(existingTracks, forKey: "trackedItemsMain")
                    
                    self.createBotView()
                } else {
                    throw NSError(domain: "YourErrorDomain", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                }
            } catch {
                print("Error decoding data: \(error)")
                
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.2) { [self] in
                        errorLabel.alpha = 1
                    }
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    UIView.animate(withDuration: 0.5) { [self] in
                        errorLabel.alpha = 0
                    }
                }
            }
        }
        
        session.resume()
    }
    
    func createBotView() {
        DispatchQueue.main.async {
            let swipe = UIPanGestureRecognizer(target: self, action: #selector(self.hideboatView))
            self.botView.addGestureRecognizer(swipe)
            self.searchButton.isUserInteractionEnabled = false
            self.codeTextField.isUserInteractionEnabled = false
            self.trackNumberLabel.text = self.codeTextField.text
            UIView.animate(withDuration: 0.3) { [self] in
                botViewConstrains.constant = -300
                view.backgroundColor = .systemGray3
                collectionView.backgroundColor = .systemGray3
                view.layoutIfNeeded()
            }
        }
    }
    
    func cleanUpStatusString(_ status: String) -> String? {
        var cleanedStatus = status
        cleanedStatus = cleanedStatus.replacingOccurrences(of: "StringOrIntWrapper(", with: "")
        cleanedStatus = cleanedStatus.replacingOccurrences(of: ")", with: "")
        cleanedStatus = cleanedStatus.replacingOccurrences(of: "\"", with: "")
        cleanedStatus = cleanedStatus.replacingOccurrences(of: "value:", with: "")
        return cleanedStatus.isEmpty ? nil : cleanedStatus
    }
    
    @objc func hideboatView() {
        
        searchButton.isUserInteractionEnabled = true
        self.codeTextField.isUserInteractionEnabled = true
        UIView.animate(withDuration: 0.3) { [self] in
            botViewConstrains.constant += 300
            
            view.backgroundColor = .systemGray5
            collectionView.backgroundColor = .systemGray5
            view.layoutIfNeeded()
            
        }
        
    }
    
}

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == codeTextField {
            UIView.animate(withDuration: 0.3) {
                self.view.backgroundColor = .systemGray5
                self.collectionView.backgroundColor = .systemGray5
            }
            textField.resignFirstResponder()
            searchAPI()
        }
        if textField == descriptionTextField {
            
            UIView.animate(withDuration: 0.3) {
                textField.resignFirstResponder()
                self.view.frame.origin.y = 0.0
            }
            
        }
        
        return true
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == codeTextField {
            UIView.animate(withDuration: 0.3) {
                self.view.backgroundColor = .systemGray3
                self.collectionView.backgroundColor = .systemGray3
            }
        }
        
        if textField == descriptionTextField {
            UIView.animate(withDuration: 0.4) {
                self.view.frame.origin.y = -250
            }
            
        }
        
    }
    
    @objc func cellTapped(_ gesture: UITapGestureRecognizer) {
        guard let tappedCell = gesture.view as? UICollectionViewCell else { return }
        guard let indexPath = collectionView.indexPath(for: tappedCell) else { return }
        guard let retrievedArray = UserDefaults.standard.array(forKey: "mainArrayKey") as? [[String]] else { return }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "vc") as! FirstViewController
        
        let code: String = retrievedArray[indexPath.row][0]
        let dop: String = retrievedArray[indexPath.row][1]
        vc.code.append(code)
        vc.code.append(dop)
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
       
}


extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        retrievedArray = UserDefaults.standard.array(forKey: "mainArrayKey")
        
        return retrievedArray?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: id, for: indexPath)
        
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        
        let dopArray = UserDefaults.standard.array(forKey: "trackedItemsMain") as? [[String: Any]] ?? []
        
        let retrievedArray = UserDefaults.standard.array(forKey: "mainArrayKey") as? [[String]]
        
        cell.isUserInteractionEnabled = true
        
        let labelMain = UILabel()
        let labelDisk = UILabel()
        let labelInfo = UILabel()
        
        if retrievedArray?.count != 0 {
            labelDisk.text = retrievedArray![indexPath.row][1]
            labelDisk.font = .boldSystemFont(ofSize: 20)
            labelDisk.frame = CGRect(x: 20, y: 20, width: 350, height: 30)
            cell.contentView.addSubview(labelDisk)
            
            labelMain.text = retrievedArray![indexPath.row][0]
            labelMain.font = .systemFont(ofSize: 20)
            labelMain.frame = CGRect(x: 20, y: 50, width: 350, height: 30)
            labelMain.textColor = .lightGray
            cell.contentView.addSubview(labelMain)
            
            labelInfo.text = cleanUpStatusString(dopArray[indexPath.row]["lastPoint"] as! String)!
            labelInfo.numberOfLines = 2
            labelInfo.frame = CGRect(x: 20, y: 80, width: 350, height: 60)
            cell.addSubview(labelInfo)
            
            
            let labelFormInfo: UILabel = {
                let fromCity = cleanUpStatusString(dopArray[indexPath.row]["fromCity"] as? String ?? " ") ?? ""
                let fromAddress = cleanUpStatusString(dopArray[indexPath.row]["fromAddress"] as? String ?? " ") ?? ""
                let fromCountry = cleanUpStatusString(dopArray[indexPath.row]["fromCountry"] as? String ?? " ") ?? ""
                
                let label = UILabel()
                label.text = "\(fromCity) \(fromAddress) \(fromCountry)"
                label.numberOfLines = 3
                label.font = .systemFont(ofSize: 16)
                label.contentMode = .topLeft
                
                return label
            }()
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cellTapped(_:)))
            cell.addGestureRecognizer(tapGesture)
            
            let labelToInfo: UILabel = {
                let toCity = cleanUpStatusString(dopArray[indexPath.row]["destinationCity"] as? String ?? " ") ?? ""
                let toAddress = cleanUpStatusString(dopArray[indexPath.row]["destinationAddress"] as? String ?? " ") ?? ""
                let toCountry = cleanUpStatusString(dopArray[indexPath.row]["destinationCountry"] as? String ?? " ") ?? ""
                
                let label = UILabel()
                label.text = "\(toCity) \(toAddress) \(toCountry)"
                label.numberOfLines = 3
                label.font = .systemFont(ofSize: 16)
                label.contentMode = .topLeft
                
                return label
            }()

            labelFormInfo.frame = CGRect(x: 20, y: 145, width: 160, height: 80)
            cell.addSubview(labelFormInfo)
            
            labelToInfo.frame = CGRect(x: 200, y: 145, width: 160, height: 80)
            cell.addSubview(labelToInfo)
            
        }
        
        let separatorView: UIView = {
            let view = UIView()
            view.backgroundColor = .separator
            return view
        }()
        
        let labelFrom: UILabel = {
            let label = UILabel()
            label.text = "From:"
            label.font = .systemFont(ofSize: 16)
            label.textColor = .systemGray3
            
            return label
        }()
        labelFrom.frame = CGRect(x: 20, y: 140, width: 100, height: 30)
        
        let labelTo: UILabel = {
            let label = UILabel()
            label.text = "To:"
            label.font = .systemFont(ofSize: 16)
            label.textColor = .systemGray3
            
            return label
        }()
        labelTo.frame = CGRect(x: 200, y: 140, width: 100, height: 30)
        cell.addSubview(labelTo)
        cell.addSubview(labelFrom)
        separatorView.frame = CGRect(x: 0, y: 140, width: 390, height: 0.5)
        cell.addSubview(separatorView)
        cell.layer.cornerRadius = 25
        cell.backgroundColor = .white
        cell.isUserInteractionEnabled = true
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 390, height: 230)
    }
    
    func collectionView(_ collectionView: UICollectionView, canEditItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in
            let deleteAction = UIAction(title: "Delete", image: UIImage(systemName: "trash"), identifier: nil) { _ in
                
                if var savedArray = UserDefaults.standard.array(forKey: "mainArrayKey") as? [[String]] {
                    savedArray.remove(at: indexPath.row)
                    UserDefaults.standard.set(savedArray, forKey: "mainArrayKey")
                    self.retrievedArray = savedArray
                    UserDefaults.standard.synchronize()
                    collectionView.deleteItems(at: [indexPath])
                    if self.retrievedArray?.count == 0 {
                        self.imageView.isHidden = false
                        self.noLabel.isHidden = false
                        self.collectionView.isHidden = true
                    }
                }
                
                if var savedArrayTwo = UserDefaults.standard.array(forKey: "trackedItemsMain") as? [[String: Any]]  {
                    savedArrayTwo.remove(at: indexPath.row)
                    UserDefaults.standard.set(savedArrayTwo, forKey: "trackedItemsMain")
                    
                    UserDefaults.standard.synchronize()
                    
                    
                }
            }
            return UIMenu(title: "", children: [deleteAction])
        }
        return configuration
    }
    
}
