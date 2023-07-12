//
//  VCFilter.swift
//  FiFoMatch
//
//  Created by Aryan Tak on 28/02/22.
//

import UIKit
import MRCountryPicker

class VCFilter: UIViewController {
  
  @IBOutlet weak var RoundedView: UIView!
  @IBOutlet weak var tableViewFilter: UITableView!
  @IBOutlet weak var txtFieldCountry: UITextField!
  @IBOutlet weak var sliderDistance: UISlider!
  @IBOutlet weak var lblSliderDistanceValue: UILabel!
  @IBOutlet weak var btnAdvancedFilter: UIButton!
  @IBOutlet weak var collectionViewIntrested: UICollectionView!
  
  var occupationArray = [ProfileList]()
  var relationshipStatusArray = [ProfileList]()

  var intrestedArr = ["Man","Woman","Transgender"]
  var selectedInterstedIndex = -1
  var selectedCountryName = ""
  
  static var advanceFilterActive = false
  
  var height = ""
  var heightType = ""
  var selectedBodyType = ""

  var selectedRelationshipId = 0
  var selectedOccupationId = 0
  var minAge = ""
  var maxAge = ""

  var workingFifo = ""
  
  var applyFilterDelegate: ApplyFilterDelegate?
  var previousApplyFilters = [String: Any]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setUpUi()
    getProfileRelatedInfo()
    setupOldFilters()
    self.tableViewFilter.reloadData()
  }
  
  override func viewWillLayoutSubviews() {
    self.RoundedView.roundCorners(corners: [.topLeft, .topRight], radius: 40)
    
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    guard let headerView = tableViewFilter.tableHeaderView else {
      return
    }
    let size = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    if headerView.frame.height != size.height {
      tableViewFilter.tableHeaderView?.frame = CGRect(
        origin: headerView.frame.origin,
        size: size
      )
      tableViewFilter.layoutIfNeeded()
    }
  }
  
  func setupOldFilters() {
    
    let interestInValue = previousApplyFilters["interested_in"] as? String ?? ""
    let row = intrestedArr.firstIndex(where: {$0 == interestInValue})
  
    selectedInterstedIndex = row ?? -1
//    selectedCountryName = previousApplyFilters["country"] as? String ?? ""
//    txtFieldCountry.text = selectedCountryName
    sliderDistance.value = previousApplyFilters["distance"] as? Float ?? 0
    lblSliderDistanceValue.text = "\(sliderDistance.value.description) KM"
    
    height = previousApplyFilters["height"] as? String ?? ""
    heightType = previousApplyFilters["height_type"] as? String ?? ""
    
    selectedBodyType = previousApplyFilters["body_type"] as? String ?? ""
    selectedOccupationId = previousApplyFilters["occupation"] as? Int ?? 0
    selectedRelationshipId = previousApplyFilters["relationship_status"] as? Int ?? 0
    
    workingFifo = previousApplyFilters["fifo"] as? String ?? ""
    
    minAge = previousApplyFilters["min_age"] as? String ?? ""
    maxAge = previousApplyFilters["max_age"] as? String ?? ""
    
  }
  
  func setUpUi(){
    self.navigationController?.setNavigationBarHidden(true, animated: false)
    tableViewFilter.delegate = self
    tableViewFilter.dataSource = self
    
//    self.txtFieldCountry.LeftView(of: nil)
//    self.txtFieldCountry.RightViewImage(UIImage(named: "dropdown-arrow"))
    
    if VCFilter.advanceFilterActive {
      self.btnAdvancedFilter.setImage(UIImage(named: "dropdown-arrow"), for: .normal)
    }else {
      self.btnAdvancedFilter.setImage(UIImage(named: "Path 126"), for: .normal)
      
    }
    
    
    //////// Setup country Picker Picker //////////
//    let countryPicker1 = MRCountryPicker()
//    countryPicker1.countryPickerDelegate = self
//    countryPicker1.showPhoneNumbers = false
//    txtFieldCountry.inputView = countryPicker1

    lblSliderDistanceValue.text = "\(sliderDistance.value.description) KM"
    
    collectionViewIntrested.delegate = self
    collectionViewIntrested.dataSource = self
    
    let collectionLayout = UICollectionViewFlowLayout()
    collectionLayout.itemSize = CGSize(width: self.collectionViewIntrested.bounds.width/3 - 10, height: self.collectionViewIntrested.bounds.height)
    collectionLayout.minimumInteritemSpacing = 0
    collectionLayout.scrollDirection = .horizontal
    collectionViewIntrested.collectionViewLayout = collectionLayout
  }
  
  @IBAction func sliderDistanceValueChanged(sender: UISlider) {
    let currentValue = Int(sender.value)
    lblSliderDistanceValue.text = "\(currentValue) KM"
  }
  
  @IBAction func btnAdvancedFilter(_ sender: Any) {
    if VCFilter.advanceFilterActive{
      VCFilter.advanceFilterActive = false
      self.btnAdvancedFilter.setImage(UIImage(named: "Path 126"), for: .normal)
    }else {
      VCFilter.advanceFilterActive = true
      self.btnAdvancedFilter.setImage(UIImage(named: "dropdown-arrow"), for: .normal)
    }
    tableViewFilter.reloadData()
  }
  
  //MARK:- action methods
  @IBAction func btnResetFilter(_ sender: Any) {
    dismiss(animated: true) {
      self.applyFilterDelegate?.applyFilter(params: [:])
    }
  }
  
  @IBAction func btnClose(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
  }
  
  @IBAction func btnApplyFilter(_ sender: Any) {
    applyFilters()
  }
  
  
}

//extension VCFilter : MRCountryPickerDelegate {
//
//  func countryPhoneCodePicker(_ picker: MRCountryPicker, didSelectCountryWithName name: String, countryCode: String, phoneCode: String, flag: UIImage) {
//
//    self.selectedCountryName = name
//    txtFieldCountry.text = name
//
//  }
//}

//MARK: - Api Calles
extension VCFilter {
  
  func getProfileRelatedInfo() {
    
    AppManager().startActivityIndicator(sender: self.view)
    
    CompleteProfileViewModel.shared.getProfileRelatedInfo { relationShipList, occupationList, educationList, isSuccess, message in
      
      AppManager().stopActivityIndicator(self.view)
      
      guard isSuccess else {
        Common.showAlert(alertMessage: message ?? "", alertButtons: ["Ok"]) { (bt) in
        }
        return
      }
      
      self.relationshipStatusArray = relationShipList
      self.occupationArray = occupationList
      self.tableViewFilter.reloadData()
    }
  }
  
  func applyFilters() {
    
   
    let distance = sliderDistance.value
//    "country" : selectedCountryName,
    var params: [String: Any] = [
      "fifo" : workingFifo,
      "height" : height,
      "height_type" : heightType,
      "min_age" : minAge,
      "max_age" : maxAge,
      "body_type" : selectedBodyType
    ]
    
    if selectedInterstedIndex != -1 {
      let interestIn = intrestedArr[selectedInterstedIndex]
      params["interested_in"] = interestIn
    }
    
    if distance != 0.0 || distance != 0 || distance != .zero {
      let lat = UserDefault.shared.getlatitude()
      let lng = UserDefault.shared.getLongitude()
      
      params["distance"] = distance.rounded()
      params["lat"] = lat
      params["lng"] = lng
    }
    
    if selectedOccupationId != 0 {
      params["occupation"] = selectedOccupationId
    }
    
    if selectedRelationshipId != 0 {
      params["relationship_status"] = selectedRelationshipId
    }
    
    dismiss(animated: true) {
      self.applyFilterDelegate?.applyFilter(params: params)
    }
  }
  
  
}

extension VCFilter: FilterDelegate {
 
  func heightFilter(height: String, heightType: String) {
    self.heightType = heightType
    self.height = height
  }
  
  func ageFilter(minAge: String, maxAge: String) {
    self.maxAge = maxAge
    self.minAge = minAge
  }
  
  func bodyTypeFilter(value: String) {
    self.selectedBodyType = value
  }
  
  func occupationFilter(id: Int) {
    selectedOccupationId = id
  }
  
  func relationshipFilter(id: Int) {
    selectedRelationshipId = id
  }
  
  func fifoFilter(value: String) {
    self.workingFifo = value
  }
  
}

extension VCFilter: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "CellAdvancedFilter") as! CellAdvancedFilter
    
    cell.delegate = self
    
    cell.setData(occupation: occupationArray, relationship: relationshipStatusArray, bodyType: selectedBodyType, height: height, heightType: heightType, occupationId: selectedOccupationId, relationId: selectedRelationshipId, fifo: workingFifo, minAge: minAge, maxAge: maxAge)
   
    return cell
  }
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
    if VCFilter.advanceFilterActive{
      return UITableView.automaticDimension
    }
    
    return 0
  }
  
}

extension VCFilter: UICollectionViewDelegate, UICollectionViewDataSource{
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return intrestedArr.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCellIntrested", for: indexPath) as! CollectionCellIntrested
    
    cell.lblTitle.text = intrestedArr[indexPath.row]
    
    if selectedInterstedIndex == indexPath.row
    {
      cell.viewBackground.layer.borderColor = CustomColor.themeOrangecolor.cgColor
      cell.viewBackground.layer.borderWidth = 1
      
      cell.lblTitle.textColor = CustomColor.themeOrangecolor
    }else{
      cell.viewBackground.layer.borderColor = CustomColor.themeLightGray.cgColor
      cell.viewBackground.layer.borderWidth = 1
      
      cell.lblTitle.textColor = CustomColor.themeLightGray
      
    }
    return cell
  }
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    selectedInterstedIndex = indexPath.row
    collectionViewIntrested.reloadData()
  }
  
}

class CellAdvancedFilter: UITableViewCell {
  
  @IBOutlet weak var sliderHeight: UISlider!
  @IBOutlet weak var heightSwitch: UISwitch!
  
  @IBOutlet weak var lblCm: UILabel!
  @IBOutlet weak var lblInches: UILabel!
  @IBOutlet weak var lblHeightSliderValue: UILabel!
  
  @IBOutlet weak var collectionViewBodyType: UICollectionView!
  
  @IBOutlet weak var txtOccupation: UITextField!
  @IBOutlet weak var txtRelationship: UITextField!
  
  @IBOutlet weak var ageRangeSlider: RangeSlider!
  
  @IBOutlet weak var btnFifoYes: UIButton!
  @IBOutlet weak var btnFifoNo: UIButton!
  
  weak var delegate: FilterDelegate?
  
  var occupationPicker: UIPickerView!
  var relationshipPicker: UIPickerView!
  
  var occupationArray = [ProfileList]()
  var relationshipArray = [ProfileList]()
  
  var fifo = false
  
  var dataArr = ["Slim", "Athletic", "A few pounds"]
  
  var selectedIndexBodyType = -1
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    
    sliderHeight.value = 0
    lblHeightSliderValue.text = ""
    
    self.txtOccupation.LeftView(of: nil)
    self.txtRelationship.LeftView(of: nil)
    
    self.txtOccupation.RightViewImage(UIImage(named: "dropdown-arrow"))
    self.txtRelationship.RightViewImage(UIImage(named: "dropdown-arrow"))
    
    //////// Setup country Picker Picker //////////
    occupationPicker = UIPickerView()
    occupationPicker.delegate = self
    occupationPicker.dataSource = self
    txtOccupation.inputView = occupationPicker
    
    relationshipPicker = UIPickerView()
    relationshipPicker.delegate = self
    relationshipPicker.dataSource = self
    txtRelationship.inputView = relationshipPicker
    
    collectionViewBodyType.dataSource = self
    collectionViewBodyType.delegate = self
    
    let collectionLayout = UICollectionViewFlowLayout()
    collectionLayout.itemSize = CGSize(width: self.collectionViewBodyType.bounds.width/3, height: self.collectionViewBodyType.bounds.height)
    collectionLayout.minimumInteritemSpacing = 20
    collectionLayout.minimumInteritemSpacing = 0
    collectionLayout.scrollDirection = .horizontal
    collectionViewBodyType.collectionViewLayout = collectionLayout
  }
  
//  override func layoutSubviews() {
//
//    DispatchQueue.main.async {
//      self.ageRangeSlider.maximumValue = 70
//      self.ageRangeSlider.minimumValue = 18
//    }
//
//  }
  
  func setData(occupation: [ProfileList], relationship: [ProfileList], bodyType: String, height: String, heightType: String, occupationId: Int, relationId: Int, fifo: String, minAge: String, maxAge: String) {
    
    self.occupationArray = occupation
    self.relationshipArray = relationship
    
    if occupationId != 0 {
      if let selectedOccupation = occupation.first(where: {$0.id == occupationId}) {
        self.txtOccupation.text = selectedOccupation.name
      }
    }
    
    if relationId != 0 {
      if let selectedRelation = relationship.first(where: {$0.id == relationId}) {
        self.txtRelationship.text = selectedRelation.name
      }
    }
    
    let boyTypeIndex = dataArr.firstIndex(of: bodyType)
    selectedIndexBodyType = boyTypeIndex ?? -1
    
    if heightType == "cm" {
      let cmValue = Float(height) ?? 0
      sliderHeight.value = cmValue.rounded()
      heightSwitch.isOn = false
      lblHeightSliderValue.text = height + " cm"
    }else if heightType == "inch"{
      let cmValue = (Float(height) ?? 0) * 2.54
      sliderHeight.value = cmValue.rounded()
      heightSwitch.isOn = true
      lblHeightSliderValue.text = height + " inch"
    }
    
//    ageRangeSlider.minimumValue =  18
//    ageRangeSlider.maximumValue =  70
    
    DispatchQueue.main.async {
      self.ageRangeSlider.lowerValue = Double(minAge)?.rounded() ?? 18
      self.ageRangeSlider.upperValue = Double(maxAge)?.rounded() ?? 70
      self.ageRangeSlider.updateLayerFramesAndPositions()
    }
    
    
    if fifo == "Yes" {
      fifoYesSelect()
    }else if fifo == "No"{
      fifoNoSelect()
    }
    
  }
  
  @IBAction func sliderHeightValueChanged(sender: UISlider) {
    
    let sliderValue = sender.value.rounded()
    
    if heightSwitch.isOn {
      heightInch(value: sliderValue)
    }else{
      heightCM(value: sliderValue)
    }
  }
  
  @IBAction func inchCmSwitchBtnAction(_ sender: UISwitch) {
    
    let sliderValue = sliderHeight.value.rounded()
    
    if sender.isOn {
      heightInch(value: sliderValue)
    }else {
      heightCM(value: sliderValue)
    }
  }
  
  func heightInch(value: Float) {
    
    let inches = value * 0.39370
    lblHeightSliderValue.text = "\(inches.rounded()) inch"
    delegate?.heightFilter(height: "\(inches.rounded())", heightType: "inch")
  }
  
  func heightCM(value: Float) {
    
    lblHeightSliderValue.text = "\(value) cm"
    delegate?.heightFilter(height: "\(value)", heightType: "cm")
  }
  
  @IBAction func ageSliderAction(_ sender: RangeSlider) {
    
    let minAge = Int(sender.lowerValue.rounded())
    let maxAge = Int(sender.upperValue.rounded())
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
      self.delegate?.ageFilter(minAge: "\(minAge)", maxAge: "\(maxAge)")
    }
    
  }
  
  @IBAction func btnFifoYesNo(_ sender: UIButton) {
    if sender.tag == 1 {
      fifoYesSelect()
      delegate?.fifoFilter(value: "Yes")
    }
    else if sender.tag == 2 {
      fifoNoSelect()
      delegate?.fifoFilter(value: "No")
    }
  }
  
  func fifoYesSelect() {
    btnFifoYes.layer.borderColor = CustomColor.themeOrangecolor.cgColor
    btnFifoNo.layer.borderColor = CustomColor.themeLightGray.cgColor
    
    btnFifoYes.setTitleColor(CustomColor.themeOrangecolor, for: .normal)
    btnFifoNo.setTitleColor(CustomColor.themeLightGray, for: .normal)
  }
  
  func fifoNoSelect() {
    btnFifoYes.layer.borderColor = CustomColor.themeLightGray.cgColor
    btnFifoNo.layer.borderColor = CustomColor.themeOrangecolor.cgColor
    
    btnFifoYes.setTitleColor(CustomColor.themeLightGray, for: .normal)
    btnFifoNo.setTitleColor(CustomColor.themeOrangecolor, for: .normal)
  }
}

//MARK:- Picker for occupation, relationship and language
extension CellAdvancedFilter: UIPickerViewDelegate, UIPickerViewDataSource {
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    
    if pickerView == occupationPicker {
      return occupationArray.count
    }else if pickerView == relationshipPicker{
      return relationshipArray.count
    }else{
      return 0
    }
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    

    if pickerView == occupationPicker {
      let data = occupationArray[row].name
      return data
    }else if pickerView == relationshipPicker {
      let data = relationshipArray[row].name
      return data
    }else {
      return nil
    }
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
   
    if pickerView == occupationPicker {
      self.txtOccupation.text = occupationArray[row].name
      if let id = occupationArray[row].id {
        self.delegate?.occupationFilter(id: id)
      }
      
    }else if pickerView == relationshipPicker {
      self.txtRelationship.text = relationshipArray[row].name
      if let id = relationshipArray[row].id {
        self.delegate?.relationshipFilter(id: id)
      }
    }
  }
}

extension CellAdvancedFilter: UICollectionViewDelegate, UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return dataArr.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCellBodyType", for: indexPath) as! CollectionCellBodyType
    cell.lblTitle.text = dataArr[indexPath.row]
    
    if selectedIndexBodyType == indexPath.row
    {
      cell.viewBackground.layer.borderColor = CustomColor.themeOrangecolor.cgColor
      cell.viewBackground.layer.borderWidth = 1
      
      cell.lblTitle.textColor = CustomColor.themeOrangecolor
    }else{
      cell.viewBackground.layer.borderColor = CustomColor.themeLightGray.cgColor
      cell.viewBackground.layer.borderWidth = 1
      
      cell.lblTitle.textColor = CustomColor.themeLightGray
      
    }
    return cell
  }
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
  
    selectedIndexBodyType = indexPath.item
    collectionViewBodyType.reloadData()
    let bodyType = dataArr[indexPath.item]
    delegate?.bodyTypeFilter(value: bodyType)
  }
  
}

class CollectionCellBodyType:UICollectionViewCell{
  
  @IBOutlet weak var viewBackground: UIView!
  @IBOutlet weak var lblTitle: UILabel!
  
  override  func awakeFromNib() {
    super.awakeFromNib()
  }
  
}

class CollectionCellIntrested:UICollectionViewCell{
  
  @IBOutlet weak var viewBackground: UIView!
  @IBOutlet weak var lblTitle: UILabel!
  
  override  func awakeFromNib() {
    super.awakeFromNib()
  }
  
}
