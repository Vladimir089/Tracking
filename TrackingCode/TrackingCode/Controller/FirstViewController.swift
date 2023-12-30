//
//  FirstViewController.swift
//  TrackingCode
//
//  Created by Владимир on 25.12.2023.
//

import UIKit

class FirstViewController: UIViewController {
    
    var code = [String]()
    let id = "1"
    var arrayEvents = [Event]()
    
    let labelNameDelivery: UILabel = {
        let label = UILabel()
        label.text = "1"
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    let lastUpdateLabel: UILabel = {
        let label = UILabel()
        label.text = " "
        return label
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0.5
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .systemGray5
        //collection.backgroundColor = .red
        collection.showsVerticalScrollIndicator = false
        return collection
    }()
    
    let isArrivedlabel: UILabel = {
        let label = UILabel()
        label.text = " "
        return label
    }()
    
    let awaitlabel: UILabel = {
        let label = UILabel()
        label.text = " "
        return label
    }()
    
    let isArrivedImage: UIImageView = {
        let image = UIImage(systemName: "checkmark.circle.fill")
        let imageView = UIImageView(image: image)
        return imageView
    }()
    
    let isAwaitingImage: UIImageView = {
        let image = UIImage(systemName: "checkmark.circle.fill")
        let imageView = UIImageView(image: image)
        return imageView
    }()
    
    let addedLabel: UILabel = {
        let label = UILabel()
        label.text = " "
        return label
    }()
    
    let inTransitLabel: UILabel = {
        let label = UILabel()
        label.text = " "
        return label
    }()
    
    let labelLastUpdate: UILabel = {
        let label = UILabel()
        label.text = "Last update:"
        label.font = .systemFont(ofSize: 15)
        label.textColor = .systemGray3
        return label
    }()
    
    let labelArrived: UILabel = {
        let label = UILabel()
        label.text = "Arrived:"
        label.font = .systemFont(ofSize: 15)
        label.textColor = .systemGray3
        return label
    }()
    
    let labelAwait: UILabel = {
        let label = UILabel()
        label.text = "Awaiting status:"
        label.font = .systemFont(ofSize: 15)
        label.textColor = .systemGray3
        return label
    }()
    
    let labelInTransit: UILabel = {
        let label = UILabel()
        label.text = "In transit:"
        label.font = .systemFont(ofSize: 15)
        label.textColor = .systemGray3
        return label
    }()
    
    let labelFirstAdded: UILabel = {
        let label = UILabel()
        label.text = "Added:"
        label.font = .systemFont(ofSize: 15)
        label.textColor = .systemGray3
        return label
    }()
    
    let topTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.textColor = .black
        textField.layer.cornerRadius = 22
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftView = leftPaddingView
        textField.leftViewMode = .always
        return textField
    }()
    
    let middleView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 25
        return view
    }()
    
   
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = code[0]
        view.backgroundColor = .systemGray5
        print(code)
        topTextField.delegate = self
        adds()
        
        makeConstrains()
        getInfo()
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: id)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func getInfo() {
        guard let url = URL(string: "https://api.track24.ru/tracking.json.php?apiKey=2b1cc0250fddc14198e0446cf74d3f27&domain=track24.ru&pretty=true&code=\(code[0])") else { return }
        //2b1cc0250fddc14198e0446cf74d3f27
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data , response , error  in
            if let data = data, let track = try? JSONDecoder().decode(Tracker.self, from: data) {
//                print(track.data.shippers)
                DispatchQueue.main.async { [self] in
                    labelNameDelivery.text = " "
                    for i in track.data.shippers {
                        labelNameDelivery.text? += " \( i)"
                    }
                    lastUpdateLabel.text = track.data.trackUpdateDateTime
                    addedLabel.text = track.data.trackCreationDateTime
                    inTransitLabel.text = "\(track.data.daysInTransit) days"
                    
                    if Int(track.data.deliveredStatus) == 1 {
                        let image = UIImage(systemName: "checkmark.circle.fill")
                        isArrivedImage.image = image
                        isArrivedlabel.text = "Delivered"
                        isArrivedlabel.textColor = .systemGreen
                        isArrivedImage.tintColor = .systemGreen
                    } else {
                        let image = UIImage(systemName: "shippingbox.circle")
                        isArrivedImage.image = image
                        isArrivedlabel.text = "En route"
                        isArrivedlabel.textColor = .systemRed
                        isArrivedImage.tintColor = .systemRed
                    }
                    
                    if Int(track.data.awaitingStatus) == 1 {
                        
                        let image = UIImage(systemName: "checkmark.circle.fill")
                        isAwaitingImage.image = image
                        awaitlabel.text = "Pending receipt"
                        awaitlabel.textColor = .systemGreen
                        isAwaitingImage.tintColor = .systemGreen
                    } else {
                        let image = UIImage(systemName: "shippingbox.circle")
                        isAwaitingImage.image = image
                        awaitlabel.text = "En route"
                        awaitlabel.textColor = .systemRed
                        isAwaitingImage.tintColor = .systemRed
                    }
                    
                    for i in track.data.events {
                        arrayEvents.append(i)
                        
                        collectionView.reloadData()
                    }
                    print(arrayEvents)
                }
            }
        }
        task.resume()
    }
    
    
    func adds() {
        view.addSubview(topTextField)
        topTextField.text = code[1]
        topTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(middleView)
        middleView.translatesAutoresizingMaskIntoConstraints = false
        middleView.addSubview(labelNameDelivery)
        labelNameDelivery.translatesAutoresizingMaskIntoConstraints = false
        createSeparatorView(frame: CGRect(x: 0, y: 50, width: 375, height: 0.7))
        
        middleView.addSubview(labelLastUpdate)
        labelLastUpdate.translatesAutoresizingMaskIntoConstraints = false
        middleView.addSubview(lastUpdateLabel)
        lastUpdateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        createSeparatorView(frame: CGRect(x: 0, y: 120, width: 375, height: 0.7))
        
        
        
        middleView.addSubview(labelFirstAdded)
        labelFirstAdded.translatesAutoresizingMaskIntoConstraints = false
        middleView.addSubview(addedLabel)
        addedLabel.translatesAutoresizingMaskIntoConstraints = false
        
        createSeparatorView(frame: CGRect(x: 0, y: 190, width: 375, height: 0.7))
        
        middleView.addSubview(labelInTransit)
        labelInTransit.translatesAutoresizingMaskIntoConstraints = false
        
        middleView.addSubview(inTransitLabel)
        inTransitLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        middleView.addSubview(labelArrived)
        labelArrived.translatesAutoresizingMaskIntoConstraints = false
        
        middleView.addSubview(isArrivedImage)
        isArrivedImage.translatesAutoresizingMaskIntoConstraints = false
        
        middleView.addSubview(isArrivedlabel)
        isArrivedlabel.translatesAutoresizingMaskIntoConstraints = false
        
        middleView.addSubview(labelAwait)
        labelAwait.translatesAutoresizingMaskIntoConstraints = false
        
        middleView.addSubview(isAwaitingImage)
        isAwaitingImage.translatesAutoresizingMaskIntoConstraints = false
        
        middleView.addSubview(awaitlabel)
        awaitlabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func makeConstrains() {
        topTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 90).isActive = true
        topTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        topTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        topTextField.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -760).isActive = true
        
        middleView.topAnchor.constraint(equalTo: topTextField.bottomAnchor, constant: 15).isActive = true
        middleView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        middleView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        middleView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -480).isActive = true
        
        
        labelNameDelivery.topAnchor.constraint(equalTo: middleView.topAnchor, constant: 15).isActive = true
        labelNameDelivery.leftAnchor.constraint(equalTo: middleView.leftAnchor, constant: 10).isActive = true
        
        labelLastUpdate.topAnchor.constraint(equalTo: labelNameDelivery.bottomAnchor, constant: 20).isActive = true
        labelLastUpdate.leftAnchor.constraint(equalTo: middleView.leftAnchor, constant: 10).isActive = true
        
        lastUpdateLabel.leftAnchor.constraint(equalTo: middleView.leftAnchor, constant: 10).isActive = true
        lastUpdateLabel.topAnchor.constraint(equalTo: labelLastUpdate.bottomAnchor, constant: 7).isActive = true
        
        labelFirstAdded.topAnchor.constraint(equalTo: lastUpdateLabel.bottomAnchor, constant: 25).isActive = true
        labelFirstAdded.leftAnchor.constraint(equalTo: middleView.leftAnchor, constant: 10).isActive = true
        
        addedLabel.topAnchor.constraint(equalTo: labelFirstAdded.bottomAnchor, constant: 7).isActive = true
        addedLabel.leftAnchor.constraint(equalTo: middleView.leftAnchor, constant: 10).isActive = true
        
        labelInTransit.topAnchor.constraint(equalTo: labelFirstAdded.topAnchor, constant: 0).isActive = true
        labelInTransit.leftAnchor.constraint(equalTo: labelFirstAdded.rightAnchor, constant: 150).isActive = true
        
        inTransitLabel.topAnchor.constraint(equalTo: addedLabel.topAnchor, constant: 0).isActive = true
        inTransitLabel.leftAnchor.constraint(equalTo: labelInTransit.leftAnchor, constant: 0).isActive = true
        
        labelArrived.topAnchor.constraint(equalTo: addedLabel.bottomAnchor, constant: 25).isActive = true
        labelArrived.leftAnchor.constraint(equalTo: middleView.leftAnchor, constant: 10).isActive = true
        
        isArrivedImage.topAnchor.constraint(equalTo: labelArrived.bottomAnchor, constant: 7).isActive = true
        isArrivedImage.leftAnchor.constraint(equalTo: middleView.leftAnchor, constant: 10).isActive = true
        
        isArrivedlabel.topAnchor.constraint(equalTo: isArrivedImage.topAnchor, constant: 0).isActive = true
        isArrivedlabel.leftAnchor.constraint(equalTo: isArrivedImage.rightAnchor).isActive = true
        
        labelAwait.topAnchor.constraint(equalTo: labelArrived.topAnchor).isActive = true
        labelAwait.leftAnchor.constraint(equalTo: labelInTransit.leftAnchor).isActive = true
        
        isAwaitingImage.topAnchor.constraint(equalTo: isArrivedImage.topAnchor).isActive = true
        isAwaitingImage.leftAnchor.constraint(equalTo: labelAwait.leftAnchor).isActive = true
        
        awaitlabel.topAnchor.constraint(equalTo: isAwaitingImage.topAnchor).isActive = true
        awaitlabel.leftAnchor.constraint(equalTo: isAwaitingImage.rightAnchor).isActive = true
        
        collectionView.topAnchor.constraint(equalTo: middleView.bottomAnchor, constant: 10).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -150).isActive = true
      
    }
    
    func createSeparatorView(frame: CGRect) -> UIView {
        let sepview: UIView = {
            let view = UIView()
            view.frame = frame
            view.backgroundColor = .separator
            return view
        }()
        middleView.addSubview(sepview)
        return view
    }

}



extension FirstViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayEvents.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: id, for: indexPath)
        //cell.backgroundColor = .red
        
        
        let labelMain = UILabel()
        labelMain.font = .systemFont(ofSize: 16)
                
        labelMain.text = (arrayEvents[indexPath.row].operationAttribute)
        
        labelMain.frame = CGRect(x: 50, y: 10, width: 300, height: 20)
        
        cell.addSubview(labelMain)
        
      
        let labelStat = UILabel()
        labelStat.font = .systemFont(ofSize: 16)
                
        labelStat.text = (arrayEvents[indexPath.row].serviceName)
        labelStat.textColor = .systemGray3
        labelStat.frame = CGRect(x: 50, y: 40, width: 150, height: 20)
        
        cell.addSubview(labelStat)
      
        
        let labeldate = UILabel()
        labeldate.font = .systemFont(ofSize: 16)
                
        labeldate.text = (arrayEvents[indexPath.row].eventDateTime)
        labeldate.textColor = .systemGray3
        labeldate.frame = CGRect(x: 190, y: 40, width: 200, height: 20)
        
        cell.addSubview(labeldate)
        let ovalView = UIView()
        let inOvalView = UIView()
        ovalView.frame = CGRect(x: 10, y: 20, width: 30, height: 30)
        
        if arrayEvents[indexPath.row].operationAttribute == arrayEvents.last?.operationAttribute {
            
            inOvalView.backgroundColor = .systemBlue
            
        
        } else {
            
            inOvalView.backgroundColor = .systemGray3
        }
        
        if arrayEvents[indexPath.row].operationAttribute != arrayEvents.last?.operationAttribute && arrayEvents[indexPath.row].operationAttribute != arrayEvents.first?.operationAttribute {
            
            let viewTopOne = UIView()
            viewTopOne.backgroundColor = .systemGray3
            viewTopOne.frame = CGRect(x: 24.5, y: 15, width: 1, height: 5)
            cell.addSubview(viewTopOne)
            
            let viewTopTwo = UIView()
            viewTopTwo.backgroundColor = .systemGray3
            viewTopTwo.frame = CGRect(x: 24.5, y: 2, width: 1, height: 7)
            cell.addSubview(viewTopTwo)
            
            let viewBotOne = UIView()
            viewBotOne.backgroundColor = .systemGray3
            viewBotOne.frame = CGRect(x: 24.5, y: 50, width: 1, height: 5)
            cell.addSubview(viewBotOne)
            
            let viewBotTwo = UIView()
            viewBotTwo.backgroundColor = .systemGray3
            viewBotTwo.frame = CGRect(x: 24.5, y: 60.5, width: 1, height: 7)
            cell.addSubview(viewBotTwo)
            
        } else if arrayEvents[indexPath.row].operationAttribute == arrayEvents.last?.operationAttribute {
            
            let viewTopOne = UIView()
            viewTopOne.backgroundColor = .systemGray3
            viewTopOne.frame = CGRect(x: 24.5, y: 15, width: 1, height: 5)
            cell.addSubview(viewTopOne)
            
            let viewTopTwo = UIView()
            viewTopTwo.backgroundColor = .systemGray3
            viewTopTwo.frame = CGRect(x: 24.5, y: 2, width: 1, height: 7)
            cell.addSubview(viewTopTwo)
        } else if arrayEvents[indexPath.row].operationAttribute == arrayEvents.first?.operationAttribute {
            
            let viewBotOne = UIView()
            viewBotOne.backgroundColor = .systemGray3
            viewBotOne.frame = CGRect(x: 24.5, y: 50, width: 1, height: 5)
            cell.addSubview(viewBotOne)
            
            let viewBotTwo = UIView()
            viewBotTwo.backgroundColor = .systemGray3
            viewBotTwo.frame = CGRect(x: 24.5, y: 60.5, width: 1, height: 7)
            cell.addSubview(viewBotTwo)
        }
        
        ovalView.layer.borderWidth = 1
        ovalView.layer.borderColor = UIColor.systemGray3.cgColor
        ovalView.layer.cornerRadius = 15
        cell.addSubview(ovalView)
        
        
        inOvalView.frame = CGRect(x: 7.5 , y: 7.5, width: 15, height: 15)
        
        inOvalView.layer.cornerRadius = 7.5
        ovalView.addSubview(inOvalView) 
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 370, height: 70)
    }
}


extension FirstViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
