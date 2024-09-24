//
//  AllCharactersVC.swift
//  NPCGenerator
//
//  Created by Jack Wright on 2024-09-20.
//

import Foundation
import RxSwift
import RxDataSources
import UIKit
import SwiftUI

struct ConversionControllerView : UIViewControllerRepresentable {

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {

    }

    func makeUIViewController(context: Context) -> some UIViewController {
        let viewController = AllCharactersVC()
        return viewController
    }
}

class AllCharactersVC: UIViewController {
    var viewModel = DependencyContainer.shared.container.resolve(AllCharactersVM.self)!
    let disposeBag = DisposeBag()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.bounces = false
        tableView.dataSource = nil
        tableView.register(FullNpcCell.self, forCellReuseIdentifier: FullNpcCell.reuseIdentifier)
        return tableView
    }()

    private lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "Previously generated NPCs will appear here."
        label.textAlignment = .center
        return label
    }()

    private var loadingImageView = UIImageView(image: UIImage(systemName: "arrow.trianglehead.2.counterclockwise.rotate.90"))

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }

    func setupUI() {
        view.addSubviews([tableView, loadingImageView, emptyLabel])

        tableView.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            left: view.safeAreaLayoutGuide.leftAnchor,
            bottom: view.bottomAnchor,
            right: view.safeAreaLayoutGuide.rightAnchor
        )
    }

    func setupBindings() {
        viewModel.npcList.skip(1).distinctUntilChanged().bind(
            to: tableView.rx.items(
                cellIdentifier: FullNpcCell.reuseIdentifier,
                cellType: FullNpcCell.self
            )
        ) { (_, config: NpcDetails, cell: FullNpcCell) in
            cell.configureCell(npcDetail: config)
        }.disposed(by: disposeBag)

        tableView.reachedBottom
            .throttle(.milliseconds(500), latest: false, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isReachedBottom in
                guard let this = self else {
                    return
                }
                if isReachedBottom {
                    this.viewModel.getNextPage()
                }
            }).disposed(by: disposeBag)

        tableView.rx.itemSelected.asObservable()
            .observe(on: MainScheduler.instance)
            .bind { _ in /* Go to details of NPC */ }.disposed(by: disposeBag)
    }
}


