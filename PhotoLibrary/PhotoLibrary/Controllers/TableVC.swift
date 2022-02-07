//
//  TableVC.swift
//  PhotoLibrary
//
//  Created by Leonardo  on 8/01/22.
//

import UIKit

extension TableVC {
  private func handleSelectedPhoto(photo: UIImage) {
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
    print("did create name: \(photo.name)")
    let indexPath = IndexPath(row: 0, section: 0)
    tableView.insertRows(at: [indexPath], with: .automatic)
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
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
    photoPicker = PhotoPicker()
    photoPicker?.photoPickerDelegate = self
    present(photoPicker!.photoPickerVC, animated: true, completion: nil)
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
    return cell
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 80
  }
}

extension TableVC: UITableViewDelegate {
  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let deleteAction = UIContextualAction(style: .normal, title: "Delete", handler: { [weak self] _, _, completion in
      self?.library.photos.remove(at: indexPath.row)
      tableView.deleteRows(at: [indexPath], with: .left)
      completion(true)
    })
    /// # `Icon` and `text` will always be white
    
    let iconImage = UIImage(systemName: "trash")?.withRenderingMode(.alwaysOriginal)
    iconImage?.withTintColor(UIColor.systemPink)
    
    deleteAction.image = iconImage
    deleteAction.backgroundColor = UIColor.white
    deleteAction.title = "Delete"

//    let editAction = UIContextualAction(style: .destructive, title: "Edit", handler: { _, _, completion in
//      completion(true)
//    })
//    editAction.image = UIImage(systemName: "square.and.pencil")
//    editAction.backgroundColor = UIColor.systemBlue

    let swipeConfig = UISwipeActionsConfiguration(actions: [deleteAction])
    swipeConfig.performsFirstActionWithFullSwipe = true
    return swipeConfig
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let photo = library.photos[indexPath.row]
    let detailVC = DetailVC(photo: photo)
    navigationController?.pushViewController(detailVC, animated: true)
  }
}

class TableVC: UIViewController, UITableViewDataSource {
  var photoPicker: PhotoPicker?

  private var library = Library()
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
//    photoPicker.photoPickerDelegate = self
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
