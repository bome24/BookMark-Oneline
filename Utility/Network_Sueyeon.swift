//
//  Network_Sueyeon.swift
//  BookMark
//
//  Created by JOSUEYEON on 2023/02/13.
//

import Foundation
import Alamofire

// MARK: - 네트워킹 용 클래스 나중에 싱글톤으로 만들기
extension Network {
    // API 2-11: 게시물의 제목, 내용, 작성자, 댓글 조회
    func getCommunityPost(postID: Int, completion: @escaping (NetworkResult<Any>) -> Void) {
        let URL = baseUrl + "/club/post/\(postID)"
        let datarequest = AF.request(URL, method: .get, encoding: JSONEncoding.default)
        
        datarequest.responseData(completionHandler: { res in
            switch res.result {
            case .success:
                guard let value = res.value else {return}
                guard let rescode = res.response?.statusCode else {return}
                
                let networkResult = self.tempJudgeStatus(object: 3, by: rescode, value)
                completion(networkResult)
                
            case .failure(let e):
                print(e)
                completion(.pathErr)
            }
        
        })
    }
    
    private func tempJudgeStatus(object: Int = 0, by statusCode: Int, _ data: Data) -> NetworkResult<Any> {
        switch statusCode {
        case 200:
            // API 2-11
            if (object == 3) {
                return isValidData_CommunityPost(data: data)
            }
            else {
                return .success(data)
            }
        case 400: return .pathErr // 요청이 잘못됨
        case 500: return .serverErr // 서버 에러
        default: return .networkFail // 네트워크 에러
        }
    }
    
    private func isValidData_CommunityPost(data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        
        guard let decodedData = try? decoder.decode(CommunityPost.self, from: data) else {
            return .decodeFail }
    
        return .success(decodedData)
    }
}
