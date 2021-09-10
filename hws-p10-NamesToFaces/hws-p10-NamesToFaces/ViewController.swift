//
//  ViewController.swift
//  hws-p10-NamesToFaces
//
//  Created by Terry Kuo on 2021/8/17.
//

import UIKit

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    lazy var addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPerson))
    lazy var cameraButton = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(cameraButtonTapped))
    var people = [Person]()
    
    //MARK: - App's Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = addButton
        navigationItem.rightBarButtonItem = cameraButton
        
        title = "Names to Faces"
    }
    
    //MARK: - CollectionView Delegate
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as? PersonCell else { ///we need to typecast our collection view cell as a PersonCell because we'll soon want to access its imageView and name outlets.
            fatalError("Unable to deque PersonCell")
        }
        
        cell.name.text = people[indexPath.item].name
        let path = getDocumentsDirectory().appendingPathComponent(people[indexPath.row].image)
        cell.imageView.image = UIImage(contentsOfFile: path.path)
        
        cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7
        return cell
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let ac = UIAlertController(title: "Rename photo", message: nil, preferredStyle: .alert)
        
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        ac.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self]_ in
            guard let self = self else { return }
            self.people.remove(at: indexPath.item)
            self.collectionView.reloadData()
        }))
        ac.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak self, weak ac] _ in
            guard let self = self else { return }
            guard let newName = ac?.textFields?[0].text else { return }
            guard ac?.textFields?[0].text != "" else { return }
            self.people[indexPath.item].name = newName
            self.collectionView.reloadData()
        }))
        
        present(ac, animated: true, completion: nil)
    }
    
    //MARK: - ImagePickerController Delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.editedImage] as? UIImage else { return }
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        print("imagePath is \(imagePath)")
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        let person = Person(name: "Unknown", image: imageName)
        people.append(person)
        collectionView.reloadData()
        
        dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: - Functions
    func getDocumentsDirectory()  -> URL {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        return path[0]
    }
    
    @objc private func addPerson() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self //conform not only to the UIImagePickerControllerDelegate protocol, but also the UINavigationControllerDelegate
        
        
        present(picker, animated: true, completion: nil)
    }
    
    @objc private func cameraButtonTapped() {
        let picker = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.camera) == false {
            return
        } else {
            picker.sourceType = .camera
            picker.allowsEditing =  true
            picker.delegate = self
            present(picker, animated: true, completion: nil)
        }
    }

}

