//
//  TableVC.swift
//  PhotoLibrary
//
//  Created by Leonardo  on 8/01/22.
//

import UIKit

extension TableVC {
  private func handleSelectedPhoto(photo: UIImage) {
    print("photo: \(photo)")
    let photoFormVC = PhotoFormVC()
    photoFormVC.photoPickerDataSource = self
    photoFormVC.photoPickerDelegate = self
    photoFormVC.photo = photo
    navigationController?.pushViewController(photoFormVC, animated: true)
  }
}

extension TableVC: PhotoPickerDelegate, PhotoPickerDataSource {
  func getLibrary() -> Library {
    return library
  }

  func didCreateNewPhoto(photo: Photo) {
    print("did create new photo: \(photo)")
    let indexPath = IndexPath(row: library.photos.count - 1, section: 0)
    tableView.insertRows(at: [indexPath], with: .automatic)
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    print("table did appear")

//    addNewPhotoToTable()
  }

  func addNewPhotoToTable() {
    if library.photos.count > currentPhotos {
      print("did save new photo")
      print("Library count: \(library.photos.count)")
      print("Current photos reference: \(currentPhotos)")
      let indexPath = IndexPath(row: library.photos.count - 1, section: 0)
      tableView.insertRows(at: [indexPath], with: .automatic)
      currentPhotos = (library.photos.count - currentPhotos)
    }
  }

  func didSelectPhoto(image: UIImage) {
    handleSelectedPhoto(photo: image)
  }
}

extension TableVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
    picker.dismiss(animated: true, completion: nil)
    guard let image = info[.editedImage] as? UIImage else { return }
    handleSelectedPhoto(photo: image)
  }
}

extension TableVC {
  @objc private func addPhoto() {
    present(photoPicker.photoPickerVC, animated: true, completion: nil)
  }

  @objc private func takePhoto() {
    guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
      return
    }
    imagePicker.sourceType = .camera
    present(imagePicker, animated: true, completion: nil)
  }
}

extension TableVC {
  private func navigationBarSettings() {
    navigationItem.title = "Photo Library"
    navigationController?.navigationBar.prefersLargeTitles = false
    navigationItem.largeTitleDisplayMode = .never

    let camera = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(takePhoto))
    let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPhoto))
    navigationItem.rightBarButtonItems = [camera]
    navigationItem.leftBarButtonItems = [add]
  }
}

extension TableVC {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return library.photos.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath) as? CellView else {
      fatalError("Could not cast custom cell")
    }
    let photo = library.photos[indexPath.row]
    cell.photoNameLabel.text = photo.name
    cell.photoCaptionLabel.text = photo.caption
    cell.photoThumbnail.image = UIImage(contentsOfFile: photo.url)
    print(cell)
    return cell
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 80
  }
}

class TableVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
  lazy var photoPicker = PhotoPicker()
  private lazy var currentPhotos = library.photos.count

  private var library = Library(photos: [Photo]())
  private let CELL_ID: String = "CELL_ID"

  private lazy var imagePicker: UIImagePickerController = {
    let picker = UIImagePickerController()
    picker.allowsEditing = true
    picker.delegate = self
    return picker
  }()

  lazy var tableView: UITableView = {
    let tableView = UITableView()
    tableView.delegate = self
    tableView.dataSource = self
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.separatorStyle = .none
    tableView.register(CellView.self, forCellReuseIdentifier: CELL_ID)
    return tableView
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    photoPicker.photoPickerDelegate = self
    navigationBarSettings()
    view.addSubview(tableView)
    constraintsBuilder()
  }

  private func constraintsBuilder() {
    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: view.topAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
    ])
  }

  deinit {
    print("deinit \(self)")
  }
}
