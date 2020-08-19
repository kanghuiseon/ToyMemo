//
//  MemoListTableViewController.swift
//  ToyMemo
//
//  Created by 강희선 on 2020/08/10.
//  Copyright © 2020 강희선. All rights reserved.
//

import UIKit

class MemoListTableViewController: UITableViewController {
    let formatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .long
        f.timeStyle = .short
        f.locale = Locale(identifier: "Ko_kr")
        return f
    }()
    var token: NSObjectProtocol?
    // 옵저버 삭제
    deinit{
        if let token = token{
            NotificationCenter.default.removeObserver(token)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell){
            if let vc = segue.destination as? DetailViewController{
                vc.memo = DataManager.shared.memoList[indexPath.row]
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // 옵저버 실행코드는 한번만 실행하면되기때문에 보통 여기서 구현함
        // ui 업데이트 코드는 반드시 메인스레드에서 실행해야함
        // ios에서는 스레드를 직접 처리하지않고 dispatchqueue, operationqueue를 이용해서 처리함
        // using에서 전달한 클로저가 queue에서 실행됨.
        token = NotificationCenter.default.addObserver(forName: ComposeViewController.newMemoDidInsert, object: nil, queue: OperationQueue.main, using: { [weak self] (noti) in
            print("신호 받음")
            self?.tableView.reloadData()
            print(#function)
        })
    }

    // MARK: - Table view data source

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DataManager.shared.fetchMemo()
        tableView.reloadData()
        print(#function)
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return DataManager.shared.memoList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let target = DataManager.shared.memoList[indexPath.row]
        cell.textLabel?.text = target.content
        cell.detailTextLabel?.text = formatter.string(for: target.insertDate)
        if #available(iOS 11.0, *) {
            cell.detailTextLabel?.textColor = UIColor(named: "MyLabelColor")
        } else {
            // Fallback on earlier versions
            cell.detailTextLabel?.textColor = UIColor.lightGray
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            // db삭제
            let target = DataManager.shared.memoList[indexPath.row]
            DataManager.shared.deleteMemo(target)
            DataManager.shared.memoList.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
