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
    super.init(collectionViewLayout: layout)
//    loadPeopleModel()
    loadPeopleModelNSKeyed()
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
    collectionView.alwaysBounceVertical = true
    collectionView.bounces = true
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
    if UIImagePickerController.isSourceTypeAvailable(.camera) {
      picker.sourceType = .camera
    }
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

    /// # Append a `new Person` with the `image directory path`
    people.append(Person(name: "Unknown", image: imagePath.path))
    print("New person added: \(imagePath.path)")
    collectionView.reloadData()
    /// # Save `people` in `UserDefaults`
//    savePeopleModel()
    savePeopleModelNSKeyed()
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
    print("Loading person view: \(person.image)")
    /// # Set the `label text`
    cell.pictureName.text = person.name
    /// # Get the path set to `person.image`
    cell.picture.image = UIImage(contentsOfFile: person.image)
//    print("Image trying to load")
//    print(person.image)

    return cell
  }

  private func renamePictureAlert(person: Person) {
    let ac = UIAlertController(title: "Rename picture", message: nil, preferredStyle: .alert)
    ac.addTextField(configurationHandler: { textField in
      textField.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    })
    let dismissAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    let renameAction = UIAlertAction(title: "Rename", style: .default) { [weak ac, weak self] _ in
      guard let newName = ac?.textFields?[0].text else { return }
      person.name = newName
      /// # Save people to `UsersDefault`
//      self?.savePeopleModel()
      self?.savePeopleModelNSKeyed()
      /// # Reload collection view data
      self?.collectionView.reloadData()
    }
    ac.addAction(renameAction)
    ac.addAction(dismissAction)
    print(people.map { $0.name })
    present(ac, animated: true)
  }

  private func updatePictureAlert(personPosition: Int) {
    let ac = UIAlertController(title: "Update", message: "Would you like to change the picture name, or delete it?", preferredStyle: .alert)
    let deletePictureAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
      self?.people.remove(at: personPosition)
      /// # Save the new `people`
//      self?.savePeopleModel()
      self?.savePeopleModelNSKeyed()
      self?.collectionView.reloadData()
    }
    let editPictureAction = UIAlertAction(title: "Rename", style: .default) { [weak self] _ in
      guard let person = self?.people[personPosition] else { return }
      self?.renamePictureAlert(person: person)
      /// # Save `people` in `UserDefaults`
    }
    ac.addAction(deletePictureAction)
    ac.addAction(editPictureAction)
    present(ac, animated: true)
  }

  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    updatePictureAlert(personPosition: indexPath.item)
  }
}

extension CollectionVC: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//    return CGSize(width: collectionView.frame.width / 2.5, height: collectionView.frame.width / 2)
    return CGSize(width: 180, height: 250)
  }
}

/// # YOU CAN WRITE `DATA OBJECTS` TO ``USER DEFAULTS``
extension CollectionVC {
  func savePeopleModel() {
    /// # `people` is an `array`, `not` a `data obj.`
    /// # `archivedData` Turns an `object` into a `Data object
    /// # `root obj.` -> `obj. graph` -> ``data obj.``
    /// # `requiredSecudeCoding`: Should all `encoded objs.` conform `NSSecureCoding`
    /// # Converts the `array` [People], into a `data obj.`
//    if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: people, requiringSecureCoding: false) {
//      UserDefaults().set(savedData, forKey: "people")
//      print("write: \(savedData)")
//    }
    /// # ``Save as JSON``
    if let data = try? JSONEncoder().encode(people) {
      UserDefaults.standard.set(data, forKey: "photos")
    }
  }

  func loadPeopleModel() {
    if let savedPeople = UserDefaults.standard.object(forKey: "photos") as? Data {
      if let decodedData = try? JSONDecoder().decode([Person].self, from: savedPeople) {
        people = decodedData
        print("decoded data")
        print(decodedData.map { $0.name })
        print(decodedData.map { $0.image })
      }
    }
  }

  func savePeopleModelNSKeyed() {
    do {
      let archive = try NSKeyedArchiver.archivedData(withRootObject: people, requiringSecureCoding: false)
      UserDefaults.standard.set(archive, forKey: "photos-v1")
      print("Data saved: \(archive)")
    } catch {
      print("Error archiving: \(error)")
    }
  }

  func loadPeopleModelNSKeyed() {
    do {
      guard let data = UserDefaults.standard.object(forKey: "photos-v1") as? Data else {
        print("failed to find people in UserDefaults")
        return
      }
      guard let unarchivedData = try NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSString.self, NSArray.self, Person.self], from: data) as? [Person] else {
        print("failed to unarchive people")
        return
      }
      print("loaded people: \(unarchivedData)")
      people = unarchivedData
    } catch {
      print("Error unarchiving/loading: \(error)")
    }
  }
}
