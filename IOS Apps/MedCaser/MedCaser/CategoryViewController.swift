//
//  CategoryViewController.swift
//  MedCaser
//
//  Created by Tingbo Chen on 1/4/16.
//  Copyright © 2016 Tingbo Chen. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIWebViewDelegate, NSFetchedResultsControllerDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var categoryTitle: UILabel!
    @IBOutlet weak var categoryTable: UITableView!
    @IBOutlet weak var categoryText: UIWebView!
    @IBOutlet weak var explanationText: UIWebView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var fontSizeSlider: UISlider!
    @IBOutlet weak var menuButton: UIButton!
    
    var categoryList = [Category]()
    var currentCategory:Int = 0
    var currentAnswerChoiceList:[AnswerChoice] = []
    var rowHeightTable:[CGFloat] = []
    var choiceRecordList = [ChoiceRecord]()
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var fetchedResultController: NSFetchedResultsController = NSFetchedResultsController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextButton.backgroundColor = UIColor(red: 255.0/255.0, green: 156.0/255.0, blue: 76.0/255.0, alpha:1)
        prevButton.backgroundColor = UIColor(red: 255.0/255.0, green: 156.0/255.0, blue: 76.0/255.0, alpha:1)

    
        categoryTable.layer.cornerRadius = 10
        self.view.backgroundColor = UIColor(red: 50.0/255.0, green: 50.0/255.0, blue: 50.0/255.0, alpha:1)
        categoryTable.backgroundColor = UIColor(red: 50.0/255.0, green: 50.0/255.0, blue: 50.0/255.0, alpha:1)
        

        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().closePanGestureRecognizer())
        
        if let currentFontSize = defaults.stringForKey("preferFont") {
            self.fontSizeSlider.value = Float(defaults.integerForKey("preferFont"))
        }
        else{
            defaults.setObject("\(fontSizeSlider.value)", forKey: "preferFont")
        }

        
        if let categoryRevealViewController = self.revealViewController() as? CategoryRevealViewController{
            categoryList = categoryRevealViewController.categoryList
        }
        
        var filter:[Int] = []
        for cat in categoryList{
            if cat.type == "qa"{
                filter.append(cat.id.integerValue)
            }
        }
        if filter.count > 0 {
            fetchedResultController = getFetchedResultController(filter)
            fetchedResultController.delegate = self
            do {
                try fetchedResultController.performFetch()
            }
            catch {
                
            }
            choiceRecordList = fetchedResultController.fetchedObjects as! [ChoiceRecord]
        }
        
        categoryUpdate(currentCategory)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer!.enabled = false
        self.navigationController?.interactivePopGestureRecognizer!.delegate = self;
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.interactivePopGestureRecognizer!.enabled = true
        self.navigationController?.interactivePopGestureRecognizer!.delegate = nil;
    }
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
    func getFetchedResultController(filter:[Int]) -> NSFetchedResultsController {
        fetchedResultController = NSFetchedResultsController(fetchRequest: choiceRecordFetchRequest(filter), managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultController
    }
    
    func choiceRecordFetchRequest(filter:[Int]) -> NSFetchRequest {
        let fetchRequest = NSFetchRequest(entityName: "ChoiceRecord")
        let sortDescriptor = NSSortDescriptor(key: "categoryId", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let predicate = NSPredicate(format: "categoryId IN %@", filter)
        fetchRequest.predicate = predicate
        return fetchRequest
    }
    
    func save() {
//        let error : NSError?
//        if(!managedObjectContext!.save(&error) ) {
//            //println(error?.localizedDescription)
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var previouslyAnswered = false
    var previouslyAnsweredChoiceId:Int = 0
    func categoryUpdate(index:Int){
        currentCategory = index
        categoryTitle.text = categoryList[index].title
        
        if categoryList[index].text == nil {
            categoryText.loadHTMLString("No Text", baseURL: nil)
        }
        else{
            categoryText.loadHTMLString(makeImgClickable(categoryList[index].text!), baseURL: nil)
        }
        
        if currentCategory == 0 && currentCategory == categoryList.count - 1 {
            prevButton.setTitle("Start of Case", forState: UIControlState.Normal)
            nextButton.setTitle("End of Case", forState: UIControlState.Normal)
            prevButton.enabled = false
            nextButton.enabled = false
            
        }
        else if currentCategory == 0 {
            if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
                nextButton.setTitle("Next: \(categoryList[currentCategory+1].title!)", forState: UIControlState.Normal)
            }
            else {
                nextButton.setTitle("Next: \(categoryList[currentCategory+1].type.uppercaseString)", forState: UIControlState.Normal)
                
            }
            prevButton.setTitle("Start of Case", forState: UIControlState.Normal)
            prevButton.enabled = false
            nextButton.enabled = true
        }
        else if currentCategory == categoryList.count - 1{
            if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
                prevButton.setTitle("Prev: \(categoryList[currentCategory-1].title!)", forState: UIControlState.Normal)
            }
            else {
                prevButton.setTitle("Prev: \(categoryList[currentCategory-1].type.uppercaseString)", forState: UIControlState.Normal)
                
            }
            prevButton.enabled = true
            nextButton.setTitle("End of Case", forState: UIControlState.Normal)
            nextButton.enabled = false
        }
        else {
            if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
                nextButton.setTitle("Next: \(categoryList[currentCategory+1].title!)", forState: UIControlState.Normal)
                prevButton.setTitle("Prev: \(categoryList[currentCategory-1].title!)", forState: UIControlState.Normal)

            }
            else {
                nextButton.setTitle("Next: \(categoryList[currentCategory+1].type.uppercaseString)", forState: UIControlState.Normal)
                prevButton.setTitle("Prev: \(categoryList[currentCategory-1].type.uppercaseString)", forState: UIControlState.Normal)
            }
            nextButton.enabled = true
            prevButton.enabled = true

        }
        
        if categoryList[currentCategory].answerChoices.count > 0 {
            if let answerChoice = categoryList[currentCategory].answerChoices.allObjects as? [AnswerChoice]{
                currentAnswerChoiceList = answerChoice.sort({$0.id.integerValue < $1.id.integerValue})
                rowHeightTable = [CGFloat](count: currentAnswerChoiceList.count, repeatedValue: 0.0)
            }
        }
        else{
            currentAnswerChoiceList = []
        }
        
        
        //reset answer choice selection variable
        selectedIndex = nil
        whitenCell = false
        
        if let index = choiceRecordList.map({$0.categoryId}).indexOf(categoryList[currentCategory].id){
            previouslyAnswered = true
            previouslyAnsweredChoiceId = choiceRecordList[index].choiceId.integerValue
            categoryTable.allowsSelection = false
            if categoryList[currentCategory].explanation != nil {
                explanationText.loadHTMLString(makeImgClickable(categoryList[currentCategory].explanation!), baseURL: nil)
            }
            else{
                explanationText.loadHTMLString("No explanation", baseURL: nil)
            }
            
        }
        else{
            previouslyAnswered = false
            for cell in categoryTable.visibleCells {
                cell.contentView.backgroundColor = UIColor.whiteColor()
            }
            categoryTable.allowsSelection = true
            categoryTable.tableFooterView?.hidden = true
        }
        
        
        categoryTable.reloadData()

  
    }
    
    func makeImgClickable(text:String) -> String{
        let nsTextString:NSString = text
        do {
            let urlRegex = try NSRegularExpression(pattern: "(https?|ftp|file)://[^\"]*", options: NSRegularExpressionOptions.CaseInsensitive)
            
            let urlResults = urlRegex.matchesInString(nsTextString as String, options: NSMatchingOptions.ReportCompletion, range: NSMakeRange(0, nsTextString.length)) as [NSTextCheckingResult]
            
            let urls = urlResults.map() {nsTextString.substringWithRange($0.range)}
            
            if urls.count > 0 {
                var tempString:NSString = text
                for var index = 0; index < urls.count; ++index{
                    let regex = try NSRegularExpression(pattern: "[<][img][^<>]*\(urls[index])(.*?)[>]", options: NSRegularExpressionOptions.CaseInsensitive)
                    let results = regex.matchesInString(tempString as String, options: NSMatchingOptions.ReportCompletion, range: NSMakeRange(0, tempString.length))
                        
                    let stringArray = results.map { tempString.substringWithRange($0.range)}
                    if(stringArray.count == 1){
                        tempString = tempString.stringByReplacingOccurrencesOfString(stringArray[0], withString: "<a href=\"\(urls[index])\">\(stringArray[0])</a>")
                    }
                }
                return "<style type='text/css'>img { max-width: 100%; width: auto; height: auto; margin: 7px 0px;}</style> \(tempString)"
            }
            else{
                return text
            }

        }
        catch
        {
            
        }
        return text
    }
    
    func resizeWebView(webView: UIWebView) {
//        webView.scrollView.contentSize.height = 1 //to reset the height, sizeToFit does not seems to shrink when contents get smaller
//        webView.sizeToFit()
//
//        webView.frame.size.height = webView.scrollView.contentSize.height
        
        var frame = webView.frame
        frame.size.height = 1
        webView.frame = frame
        let fittingSize = webView.sizeThatFits(CGSizeZero)
        frame.size = fittingSize
        webView.frame = frame
        
        
        webView.layer.cornerRadius = 10
        webView.scrollView.layer.cornerRadius = 10
        webView.layer.borderColor = self.view.tintColor.CGColor
        webView.layer.borderWidth = 3
        
        if webView == categoryText{
            
            //make it recalculate tableheader
            let tempCategoryTable:UIWebView = webView
            categoryTable.tableHeaderView = nil
            categoryTable.tableHeaderView = tempCategoryTable
        }
        else if webView == explanationText {
            //resize footer(containing the explanation)
            let tempExplanationWebView:UIWebView = webView
            categoryTable.tableFooterView = nil
            categoryTable.tableFooterView = tempExplanationWebView
        }
    }
    
    override func willAnimateRotationToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        resizeWebView(categoryText)
        resizeWebView(explanationText)
    }
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    func webViewDidFinishLoad(webView: UIWebView) {


        let stripString = "function removeStyles(el) { el.removeAttribute('style'); if(el.childNodes.length > 0) {for(var child in el.childNodes) { if(el.childNodes[child].nodeType == 1) removeStyles(el.childNodes[child]);} } } removeStyles(document.body);"
        webView.stringByEvaluatingJavaScriptFromString(stripString)
        
        let currentFontSize = defaults.stringForKey("preferFont")
        webView.stringByEvaluatingJavaScriptFromString("document.body.style.fontSize='\(currentFontSize!)px'")
        webView.stringByEvaluatingJavaScriptFromString("document.body.style.wordWrap = 'break-word'")
    
        resizeWebView(webView)
        
        self.categoryTable.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        
        if webView == explanationText {
            
            if self.categoryTable.contentSize.height >= self.categoryTable.bounds.size.height {
                let newContentOffset = CGPointMake(0, self.categoryTable.contentSize.height - self.categoryTable.bounds.size.height)
                self.categoryTable.setContentOffset(newContentOffset, animated: true)
            }
            
            categoryTable.tableFooterView?.hidden = false
        }
        
    }

    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        if (navigationType == UIWebViewNavigationType.LinkClicked){
            
            let url = NSURL(string: (request.URL?.absoluteString)!)
            if let data = NSData(contentsOfURL: url!) {//make sure your image in this url does exist, otherwise unwrap in a if let check
                if let image = UIImage(data: data){
                    let imageView:UIImageView = UIImageView(image: image)
                    let vc:GGFullscreenImageViewController = GGFullscreenImageViewController()
                    vc.liftedImageView = imageView
                    self.presentViewController(vc, animated: false, completion: {self.categoryUpdate(self.currentCategory)
                    })
                }
                else {
                    UIApplication.sharedApplication().openURL(request.URL!)
                    return false
                }
            }
            else {
                return false
            }
            
        }

        return true
    }
    
    @IBAction func fontSizeSlider(sender: UISlider) {
        var currentValue = Int(sender.value)
        categoryText.stringByEvaluatingJavaScriptFromString("document.body.style.fontSize='\(currentValue)px'")
        resizeWebView(categoryText)
        defaults.setObject("\(currentValue)", forKey: "preferFont")
        if !categoryTable.tableFooterView!.hidden {
            explanationText.stringByEvaluatingJavaScriptFromString("document.body.style.fontSize='\(currentValue)px'")
            resizeWebView(explanationText)
        }
        categoryTable.reloadData()
    }
    
    @IBAction func clickNextButton(sender: UIButton) {
        currentCategory += 1
        categoryUpdate(currentCategory)
    }
    
    @IBAction func clickPrevButton(sender: UIButton) {
        currentCategory -= 1
        categoryUpdate(currentCategory)
    }
    
    @IBAction func clickMenuButton(sender: UIButton) {
        self.revealViewController().rightRevealToggleAnimated(true)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return currentAnswerChoiceList.count
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
        
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 50
        }
        else{
            return 2
        }
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == currentAnswerChoiceList.count - 1{
            return 20
        }
        else{
            return 2
        }
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let uiView = UIView()
        uiView.backgroundColor = UIColor.clearColor()
        return uiView
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let uiView = UIView()
        uiView.backgroundColor = UIColor.clearColor()
        return uiView
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")!
        cell.textLabel?.text = currentAnswerChoiceList[indexPath.section].choiceText
        cell.textLabel?.lineBreakMode = NSLineBreakMode.ByWordWrapping
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.font = UIFont(name: cell.textLabel!.font.fontName, size: CGFloat(defaults.floatForKey("preferFont") * 0.7 ))
        if currentAnswerChoiceList[indexPath.section].choiceText != nil {
            rowHeightTable[indexPath.section] = minHeightForText(currentAnswerChoiceList[indexPath.section].choiceText!, fontSize: cell.textLabel!.font.pointSize)
        }
        cell.contentView.layer.borderColor = self.view.tintColor.CGColor
        cell.contentView.layer.borderWidth = 3.0
        cell.backgroundColor = UIColor(red: 50.0/255.0, green: 50.0/255.0, blue: 50.0/255.0, alpha:1)
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        if previouslyAnswered {
            if currentAnswerChoiceList[indexPath.section].correctAnswer == 1 {
                cell.contentView.backgroundColor = UIColor(red: 138.0/255.0, green: 255.0/255.0, blue: 109.0/255.0, alpha: 1)
            }
            else if currentAnswerChoiceList[indexPath.section].id.integerValue == previouslyAnsweredChoiceId{
                if currentAnswerChoiceList[indexPath.section].correctAnswer == 0 {
                    cell.contentView.backgroundColor = UIColor(red: 232.0/255.0, green: 33.0/255.0, blue: 96.0/255.0, alpha: 1)
                }
                else{
                    cell.contentView.backgroundColor = UIColor.whiteColor()
                }
            }
            else {
                cell.contentView.backgroundColor = UIColor.whiteColor()
            }
        }
        else {
            if selectedIndex == indexPath.section {
                cell.contentView.backgroundColor = UIColor.grayColor()

            }
            else {
                cell.contentView.backgroundColor = UIColor.whiteColor()
            }
        }

        return cell
    }
    
    

    
    func minHeightForText(text:NSString, fontSize:CGFloat) -> CGFloat{
        
        let font:UIFont = UIFont.systemFontOfSize(fontSize)
        let rectSize:CGRect = text.boundingRectWithSize(CGSizeMake(categoryTable.frame.size.width, CGFloat.max), options: NSStringDrawingOptions.UsesLineFragmentOrigin
, attributes: [NSFontAttributeName:font], context: nil)
        return rectSize.height + 20
    }
    

    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return rowHeightTable[indexPath.section]
   }
    

    
    var selectedIndex:Int? = nil
    var whitenCell = false
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        if let explanationWebView = categoryTable.tableFooterView as? UIWebView{

            if selectedIndex == nil || selectedIndex != indexPath.section{
                selectedIndex = indexPath.section
                explanationWebView.loadHTMLString("Click Again To Submit Answer", baseURL: nil)

                for cell in tableView.visibleCells {
                    cell.contentView.backgroundColor = UIColor.whiteColor()
                }

                tableView.cellForRowAtIndexPath(indexPath)?.contentView.backgroundColor = UIColor.grayColor()
                whitenCell = true
                
            }
            else{
                //submit answer
                whitenCell = false
                if categoryList[currentCategory].explanation != nil {
                    explanationWebView.loadHTMLString(makeImgClickable(categoryList[currentCategory].explanation!), baseURL: nil)
                }
                else{
                    explanationWebView.loadHTMLString("No explanation", baseURL: nil)
                }
                if currentAnswerChoiceList[indexPath.section].correctAnswer == 1{
                    tableView.cellForRowAtIndexPath(indexPath)?.selected = false
                    tableView.cellForRowAtIndexPath(indexPath)?.contentView.backgroundColor = UIColor(red: 138.0/255.0, green: 255.0/255.0, blue: 109.0/255.0, alpha: 1)
                }
                else{
                    tableView.cellForRowAtIndexPath(indexPath)?.selected = false
                    tableView.cellForRowAtIndexPath(indexPath)?.contentView.backgroundColor = UIColor(red: 232.0/255.0, green: 33.0/255.0, blue: 96.0/255.0, alpha: 1)
                    for var index = 0; index < currentAnswerChoiceList.count; ++index{
                        if currentAnswerChoiceList[index].correctAnswer == 1{
                            let correctAnswerIndexPath = NSIndexPath(forRow: 0, inSection: index)
                            tableView.cellForRowAtIndexPath(correctAnswerIndexPath)?.contentView.backgroundColor = UIColor(red: 138.0/255.0, green: 255.0/255.0, blue: 109.0/255.0, alpha: 1)
                            break
                        }
                    }
                }
                //add to choiceRecord
                if let index = choiceRecordList.map({$0.categoryId}).indexOf(currentAnswerChoiceList[indexPath.section].category.id){
                    //existing record
                    choiceRecordList[index].choiceId = currentAnswerChoiceList[indexPath.section].id
                    save()
                    
                }
                else{
                    //create record
                    var choiceRecord = ChoiceRecord.createInManagedObjectContext(self.managedObjectContext, categoryId: currentAnswerChoiceList[indexPath.section].category.id, choiceId: currentAnswerChoiceList[indexPath.section].id)
                    save()
                    choiceRecordList.append(choiceRecord)
                    
                }
                tableView.allowsSelection = false
                previouslyAnswered = true
                previouslyAnsweredChoiceId = currentAnswerChoiceList[indexPath.section].id.integerValue
            }
         
        }
        
    }



}
