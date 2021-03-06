//
//  SettingViewController.swift
//  Eventory
//
//  Created by jumpei on 2016/09/10.
//  Copyright © 2016年 jumpei. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!

        var newEventCount: Int = 0 {
            didSet {
                tableView.reloadData()
            }
        }

    var settingClasses: [Dictionary<String, String>] = [
        [
            "name": "興味のあるジャンル",
            "controller": RegisterGenreViewControllerIdentifier
        ],
        [
            "name": "開催地",
            "controller": RegisterPlaceViewControllerIdentifier
        ],
        [
            "new": "false"
        ],
        [
            "name": "レビューする",
            "url": "itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=1194029971&pageNumber=0&sortOrdering=2&mt=8"
        ]
        // 1194029971

    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.separatorInset = UIEdgeInsets.zero
        self.tableView.layoutMargins = UIEdgeInsets.zero
        self.tableView.tableFooterView = UIView()
        self.tableView.rowHeight = 50
    }

    override func viewWillAppear(_ animated:Bool) {
        super.viewWillAppear(animated)

        if let indexPathForSelectedRow = tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: indexPathForSelectedRow, animated: true)
        }
        self.newEventCount = EventManager.sharedInstance.getSelectNewEventAll().count
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

// MARK: - UITableViewDataSource

extension SettingViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.settingClasses.count
    }


    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: SettingTableViewCellIdentifier, for: indexPath)

        if indexPath.row <= 1 {
            cell.textLabel?.text = self.settingClasses[indexPath.row]["name"]
            cell.accessoryType = .disclosureIndicator
            return cell
        } else if indexPath.row == 2 {
            if newEventCount > 0 {
                cell.textLabel?.textColor = UIColor.white
                cell.backgroundColor = Colors.main2
                cell.textLabel?.text = "新着情報：\(newEventCount)件"
                self.settingClasses[indexPath.row]["new"] = "true"
                return cell
            }
            cell.textLabel?.textColor = UIColor.black
            cell.backgroundColor = UIColor.white
            cell.textLabel?.text = "新着情報：なし"
            self.settingClasses[indexPath.row]["new"] = "false"
            return cell
        } else if indexPath.row == 3 {
            cell.textLabel?.text = self.settingClasses[indexPath.row]["name"]
            cell.accessoryType = .disclosureIndicator
            return cell
        }
        return UITableViewCell()
    }
}


// MARK: - UITableViewDelegate

extension SettingViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let nextVc = settingClasses[indexPath.row]["controller"] {
           
            // どのコントローラに遷移するか判定している
            // 既存にあるRegister系は少し煩雑になっているが、初期登録アクセスかを判定しているだけ
            if nextVc == RegisterPlaceViewControllerIdentifier {
                let vc = UIStoryboard(name:"Register", bundle: nil).instantiateViewController(withIdentifier: nextVc) as! RegisterPlaceViewController
                vc.settingStatus = true
                self.navigationController?.pushViewController(vc, animated: true)
            } else if nextVc == RegisterGenreViewControllerIdentifier {
                let vc = UIStoryboard(name:"Register", bundle: nil).instantiateViewController(withIdentifier: nextVc) as! RegisterGenreViewController
                vc.settingStatus = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else if let url = settingClasses[indexPath.row]["url"] {
            let app:UIApplication = UIApplication.shared
            app.openURL(URL(string: url)!)
        } else if let _ = settingClasses[indexPath.row]["new"], settingClasses[indexPath.row]["new"] == "true" {
            let vc = self.tabBarController! as! MainMenuTabBarController
            vc.selectTab(at: 0, animated: true)
        }
    }
}

