//
//  CollectionVC.swift
//  UICollectionView
//
//  Created by Leonardo  on 2/01/22.
//

import UIKit

private let reuseIdentifier = "Cell"

class CollectionVC: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  private let picker = UIImagePickerController()
  private var people = [Person]()

  init(collectionViewLayout layout: UICollectionViewFlowLayout) {
    layout.scrollDirection = .vertical
    layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 20)
//    layout.collectionView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//    layout.minimumInteritemSpacing = 0
    super.init(collectionViewLayout: layout)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.register(CollectionCellView.self, forCellWithReuseIdentifier: reuseIdentifier)
    navSettings()
    collectionView()
  }

  private func collectionView() {
    collectionView.backgroundColor = UIColor.white
  }

  private func navSettings() {
    navigationItem.title = "Mangakasa"
    navigationItem.largeTitleDisplayMode = .always
    let addImageItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addImage))
    addImageItem.tintColor = UIColor.white
    navigationItem.rightBarButtonItems = [addImageItem]
  }

  @objc private func addImage() {
    /// # Image picker set in `properties`
    picker.allowsEditing = true
    picker.delegate = self
    present(picker, animated: true)
  }

  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
    /// # Unwrap the image selected
    guard let image = info[.editedImage] as? UIImage else { return }
    /// # Set image name
    let imageName = UUID().uuidString
    /// # Set the `documents directory` and append the `image path`
    let documentsPath = getDocumentsDirectory()
    /// # Creates the `path` for the image, starting from the `App documents path`
    let imagePath = documentsPath.appendingPathComponent(imageName)

    /// # UImage needs to be converted to a `Data object` so it can be saved
    if let jpegData = image.jpegData(compressionQuality: 0.8) {
      /// # Write the `image` to the `documents path`
      try? jpegData.write(to: imagePath)
    }
    print("Documents path: \(documentsPath)")
    print("Image path: \(imagePath)")

    /// # Append the `image` to the `Person` model
    people.append(Person(name: "Unknown", image: imagePath.path))
    print("People: \(people)")
    collectionView.reloadData()
    picker.dismiss(animated: true, completion: nil)
  }

  /// # Path to `Documents`: ``Private App documents``
  private func getDocumentsDirectory() -> URL {
    /// Find the path
    let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    /// Get the first and only array item
    return path[0]
  }

  override func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }

  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return people.count
  }

  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionCellView
//    cell.backgroundColor = UIColor.systemBlue
    /// # Get `index` Person
    let person = people[indexPath.item]
    /// # Set the `label text`
    cell.pictureName.text = person.name
    /// # Get the path set to `person.image`
    cell.picture.image = UIImage(contentsOfFile: person.image)

    return cell
  }

  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let person = people[indexPath.item]
    let ac = UIAlertController(title: "Rename picture", message: nil, preferredStyle: .alert)
    ac.addTextField(configurationHandler: { textField in
      textField.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    })
    let dismissAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    let renameAction = UIAlertAction(title: "Rename", style: .default) { [weak ac, weak self] _ in
      guard let newName = ac?.textFields?[0].text else { return }
      person.name = newName
      /// # Reload collection view data
      self?.collectionView.reloadData()
    }
    ac.addAction(renameAction)
    ac.addAction(dismissAction)
    present(ac, animated: true)
  }
}

extension CollectionVC: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//    return CGSize(width: collectionView.frame.width / 2.5, height: collectionView.frame.width / 2)
    return CGSize(width: 180, height: 250)
  }
}
