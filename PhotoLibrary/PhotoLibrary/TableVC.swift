//
//  TableVC.swift
//  PhotoLibrary
//
//  Created by Leonardo  on 8/01/22.
//

import UIKit

extension TableVC: PhotoPickerDelegate {
  func didSelectPhoto(image: UIImage) {
    print(image)
  }
}

extension TableVC {
  @objc private func addPhoto() {
    photoPicker.setupPicker(self)
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
    navigationController?.navigationBar.prefersLargeTitles = true
    let camera = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(takePhoto))
    let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPhoto))
    navigationItem.rightBarButtonItems = [camera]
    navigationItem.leftBarButtonItems = [add]
  }
}

extension TableVC {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 20
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath) as? CellView else {
      fatalError("Could not cast custom cell")
    }
    return cell
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 80
  }
}

class TableVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
  let photoPicker = PhotoPicker()

  private var photos = [Photo]()
  private let CELL_ID: String = "CELL_ID"

  private lazy var imagePicker: UIImagePickerController = {
    let picker = UIImagePickerController()
    picker.allowsEditing = true
    return picker
  }()

  lazy var tableView: UITableView = {
    let tableView = UITableView()
    tableView.delegate = self
    tableView.dataSource = self
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.register(CellView.self, forCellReuseIdentifier: CELL_ID)
    return tableView
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    photoPicker.photoPickerDelegate = self
    navigationBarSettings()
    setupTableView()
  }

  private func setupTableView() {
    tableView.separatorStyle = .none
    view.addSubview(tableView)
    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: view.topAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
    ])
  }
}
