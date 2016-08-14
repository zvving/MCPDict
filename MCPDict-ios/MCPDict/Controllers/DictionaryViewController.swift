//
//  DictionaryViewController.swift
//  MCPDict
//
//  Created by zengming on 16/5/5.
//  Copyright © 2016年 ioi.im. All rights reserved.
//

import ReactiveCocoa

import UIKit

class DictionaryViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource,UITableViewDelegate {
    
    private var dictModels : [DictModel]!
    
    @IBOutlet weak var tfSearchText: UITextField!
    
    @IBOutlet weak var switchKuangxYonhOnly: UISwitch!
    @IBOutlet weak var labelKuangxYonhOnly: UILabel!
    @IBOutlet weak var switchAllowVariants: UISwitch!
    @IBOutlet weak var labelAllowVariants: UILabel!
    @IBOutlet weak var switchToneInsensitive: UISwitch!
    @IBOutlet weak var labelToneInsensitive: UILabel!
    
    @IBOutlet weak var btnSearchMode: UIButton!
    
    // search arguments
//    private var isKuangxYonhOnly : Bool = false
//    private var isAllowVariants : Bool = false
//    private var isToneInsensitive : Bool = false
    
    // search arguments switch able
    dynamic private var enableKuangxYonhOnly : Bool = false
    dynamic private var enableAllowVariants : Bool = false
    dynamic private var enableToneInsensitive : Bool = false
    
    private var searchMode = SearchMode.HZ {
        didSet {
            self.btnSearchMode.setTitle(self.searchMode.rawValue, forState: .Normal)
            self.resetSearchArgumentsAvailable(self.searchMode)
            
            self.researchAction()
        }
    }
    
    // table
    @IBOutlet weak var tableView: UITableView!
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        dictModels = DictProvider.sharedInstance.query("", mode: .HZ, extraArguments: [])
        
        // bind SearchArguments
//        switchKuangxYonhOnly.rac_newOnChannel().subscribeNext{ self.isKuangxYonhOnly = $0 as! Bool }
//        switchAllowVariants.rac_newOnChannel().subscribeNext{ self.isAllowVariants = $0 as! Bool }
//        switchToneInsensitive.rac_newOnChannel().subscribeNext{ self.isToneInsensitive = $0 as! Bool }
        
        // bind UIs available
        
        rac_valuesForKeyPath("enableKuangxYonhOnly", observer: self).subscribeNext { enable in
            let enableBool = enable as! Bool
            self.switchKuangxYonhOnly.enabled = enableBool
            self.labelKuangxYonhOnly.enabled = enableBool
        }
        rac_valuesForKeyPath("enableAllowVariants", observer: self).subscribeNext { enable in
            let enableBool = enable as! Bool
            self.switchAllowVariants.enabled = enableBool
            self.labelAllowVariants.enabled = enableBool
        }
        rac_valuesForKeyPath("enableToneInsensitive", observer: self).subscribeNext { enable in
            let enableBool = enable as! Bool
            self.switchToneInsensitive.enabled = enableBool
            self.labelToneInsensitive.enabled = enableBool
        }
        
        searchMode = SearchMode.HZ
        
        // todo: for test
        
        self.tfSearchText.text = "你我"
        self.researchAction()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
         
    }
    
    // MARK: action
    
    
    @IBAction func showSearchModeList() {
        
        // 优化体验
        self.view.endEditing(true)
        
        let alertController = UIAlertController(title: nil, message: "查询模式", preferredStyle: .Alert)
        
        for mode in SearchMode.allValues {
            let oneAction = UIAlertAction(title: mode.rawValue, style: .Default) { (action) in
                self.searchMode = mode
            }
            alertController.addAction(oneAction)
        }

        let destroyAction = UIAlertAction(title: "取消", style: .Cancel) { (action) in
            
        }
        alertController.addAction(destroyAction)
        
        self.presentViewController(alertController, animated: true) {
            
        }
    }
    
    @IBAction func switchValueChanged() {
        self.researchAction()
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
     
        self.researchAction()
        
        return true
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dictModels.count
    }
    
    func tableView(tableView: UITableView,
                   cellForRowAtIndexPath indexPath: NSIndexPath
        ) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(
            "kDictCell",
            forIndexPath: indexPath) as! DictCell
        
        let model = dictModels[indexPath.row]
        cell.configCellWith(model)
        
        return cell
    }
    
    // MARK: - private
    
    private func resetSearchArgumentsAvailable(mode : SearchMode) -> Void {
        
        enableKuangxYonhOnly = mode != SearchMode.MC
        enableAllowVariants = mode == SearchMode.HZ
        enableToneInsensitive = mode == SearchMode.MC ||
            mode == SearchMode.PU ||
            mode == SearchMode.CT ||
            mode == SearchMode.SH ||
            mode == SearchMode.MN ||
            mode == SearchMode.VN
    }
    
    private func researchAction() {
        let keywords = tfSearchText.text!
        
        var extraArguments:[SearchArgument] = []
        if enableAllowVariants && switchAllowVariants.on {
            extraArguments.append(SearchArgument.AllowVariants)
        }
        if enableKuangxYonhOnly && switchKuangxYonhOnly.on {
            extraArguments.append(SearchArgument.KuangxYonhOnly)
        }
        if enableToneInsensitive && switchToneInsensitive.on {
            extraArguments.append(SearchArgument.ToneInsensitive)
        }
        
        self.dictModels = DictProvider.sharedInstance.query(keywords,
                                                            mode: searchMode,
                                                            extraArguments: extraArguments)
        self.tableView.reloadData()
        
        self.view.endEditing(true)
    }

}
