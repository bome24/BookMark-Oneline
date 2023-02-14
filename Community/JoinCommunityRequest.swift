//
//  JoinCommunityRequestViewController.swift
//  BookMark
//
//  Created by BoMin on 2023/01/26.
//

import UIKit
import SnapKit
import Kingfisher

class JoinCommunityRequestViewController: UIViewController {
    
//MARK: NetworkTintin
    let network = NetworkTintin()
    
    var clubID: String = ""
    
    var clubName: String = ""
    var userName: String = ""
    var clubInviteOption: Int = 0
    var clubImgURL: String = ""
    var profileImgURL: String = ""
    
    let backgroundImageView: UIImageView = {
        let view = UIImageView()
        let img = UIImage(named: "myeongsoo.png")
        
        view.image = img
        view.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        view.contentMode = .scaleAspectFill
        
        return view
    }()
    
    let communityNameLabel: UILabel = {
        let label = UILabel()
        
        label.frame = CGRect(x: 0, y: 0, width: 290, height: 64)
        label.textColor = .white
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
//        label.text = "책마니+ 스터디와 함께하는 책읽기 프로젝트"
        label.font = .boldSystemFont(ofSize: 26)
        
        return label
    }()
    
    let communityProfileImageView = {
        let view = UIImageView()
        let image = UIImage(named: "haerin.jpg")
        
//        view.backgroundColor = .red // 위치 확인용
        view.image = image
        view.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 50 / 2.0
        view.clipsToBounds = true
        
        return view
    }()

    let communityProfileNameLabel = {
        let label = UILabel()
        
        label.frame = CGRect(x: 0, y: 0, width: 84, height: 20)
        label.textColor = .white
//        label.text = "독서왕김독서"
        label.font = .boldSystemFont(ofSize: 16)
        label.numberOfLines = 1
        label.textAlignment = .left
        
        return label
    }()
    
    let communityStatusLabel = {
        let label = UILabel()
        
        label.frame = CGRect(x: 0, y: 0, width: 63, height: 15)
        label.textColor = UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 1)
        label.text = "일부가입허용"
        label.font = .boldSystemFont(ofSize: 12)
        label.numberOfLines = 1
        label.textAlignment = .left
        
        return label
    }()
    
    let buttonFloatView = {
        let view = UIView()
        
        view.frame = CGRect(x: 0, y: 0, width: 390, height: 95)
        view.backgroundColor = .white
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 15
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        return view
    }()
    
    let requestButton = {
        let btn = UIButton()
        
        btn.frame = CGRect(x: 0, y: 0, width: 344, height: 50)
        btn.backgroundColor = .lightOrange
        btn.setTitle("가입 요청", for: .normal)
        btn.titleLabel?.textColor = .white
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 25
        btn.addTarget(self, action: #selector(requestButtonPress), for: .touchUpInside)
        
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCommunitySearchResultData()
        print(clubName)
        setBackgroundImage()
        setLayouts()
        setNavCustom()
    }
    
    @objc func requestButtonPress() {
        print("가입 요청")
        postUserCommunityJoinRequestData()
    }
}

extension JoinCommunityRequestViewController {
    func getCommunitySearchResultData() {
        network.getCommunitySearchResult(clubID: clubID) { res in
            switch res {
            case .success(let communitySearch):
                if let com = communitySearch as? [CommunitySearch] {
                    print(com[0].clubName)
                    
                    self.clubName = com[0].clubName
                    self.userName = com[0].userName
                    self.clubInviteOption = com[0].clubInviteOption
                    self.clubImgURL = com[0].clubImgURL
                    self.profileImgURL = com[0].imgURL
                    
                    self.showContents()
                }
            default:
                print("failed")
            }
        }
    }
    
    func postUserCommunityJoinRequestData() {
        network.postCommunityJoinRequest(userID: String(UserInfo.shared.userID), clubID: "1", completion: { res in
            switch res {
            case .success:
                print("succcccc")
                print("POST CommunityJoinRequest")
                self.navigationController?.popToRootViewController(animated: true)
            case .decodeFail:
                print("DF")
            default:
                print("failed")
            }
        })
    }
}

extension JoinCommunityRequestViewController {
    func setBackgroundImage() {
        view.addSubview(backgroundImageView)
        backgroundImageView.snp.makeConstraints() { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-70)
//            make.bottom.equalTo(additionalSafeAreaInsets.bottom).offset(-70)
        }
        self.view.sendSubviewToBack(backgroundImageView)
    }
    
    func setLayouts() {
        view.addSubviews(communityNameLabel, communityProfileImageView, communityProfileNameLabel, communityStatusLabel)
        
        
        communityNameLabel.snp.makeConstraints() { make in
            make.width.equalTo(290)
            make.height.equalTo(64)
            make.leading.equalToSuperview().offset(23)
            make.top.equalToSuperview().offset(557)
        }
        
        communityProfileImageView.snp.makeConstraints() { make in
            make.width.equalTo(50)
            make.height.equalTo(50)
            make.leading.equalTo(communityNameLabel)
            make.top.equalTo(communityNameLabel.snp.bottom).offset(23)
        }
        
        communityProfileNameLabel.snp.makeConstraints() { make in
            make.width.equalTo(100)
            make.height.equalTo(20)
            make.leading.equalTo(communityProfileImageView.snp.trailing).offset(10)
            make.top.equalTo(communityNameLabel.snp.bottom).offset(28)
        }
        
        communityStatusLabel.snp.makeConstraints() { make in
            make.width.equalTo(100)
            make.height.equalTo(15)
            make.leading.equalTo(communityProfileNameLabel.snp.leading)
            make.top.equalTo(communityProfileNameLabel.snp.bottom).offset(5)
        }
        
        view.addSubview(buttonFloatView)
        
        buttonFloatView.snp.makeConstraints() { make in
            make.width.equalToSuperview()
            make.height.equalTo(95)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-24)
        }
        
        buttonFloatView.addSubview(requestButton)
        
        requestButton.snp.makeConstraints() { make in
            make.height.equalTo(50)
            make.leading.equalToSuperview().offset(23)
            make.trailing.equalToSuperview().offset(-23)
            make.top.equalToSuperview().offset(15)
        }
        
    }
    
    func setNavCustom() {
        self.navigationItem.backButtonTitle = ""
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    func showContents() {
        communityNameLabel.text = self.clubName
        communityProfileNameLabel.text = self.userName
        backgroundImageView.kf.indicatorType = .activity
        backgroundImageView.kf.setImage(with: URL(string: clubImgURL), placeholder: nil, options: [.transition(.fade(1)), .cacheOriginalImage, .forceTransition], completionHandler: nil)
        communityProfileImageView.kf.indicatorType = .activity
        communityProfileImageView.kf.setImage(with: URL(string: profileImgURL), placeholder: nil, options: [.transition(.fade(1)), .cacheOriginalImage, .forceTransition], completionHandler: nil)
        
//MARK: CommunityInviteOption
        if (clubInviteOption == 0) {
            communityStatusLabel.text = "모두가입허용"
        } else if (clubInviteOption == 1) {
            communityStatusLabel.text = "일부가입허용"
        } else if (clubInviteOption == 2) {
            communityStatusLabel.text = "모든가입거부"
        }
    }
}
