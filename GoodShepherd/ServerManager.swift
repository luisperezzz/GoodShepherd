//
//  ServerConnector.swift
//  VisaNet
//
//  Created on 26/11/17.
//  Copyright © 2017. All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreLocation


typealias DefaultResponse = (RequestResult<JSON>) -> Void
typealias Params = [String:Any]?
typealias ImageResponse = (_ image: UIImage?, _ error: NSError?) -> Void
typealias LocationResponse = (_ locationCoordinate : CLLocation)->Void
typealias PlacemarkResponse = (_ placemark : CLPlacemark)->Void

public enum RequestResult<Value> {
    case success(Value)
    case failure(NSError)
    
    public var isSuccess: Bool {
        switch self {
        case .success:  return true
        case .failure:  return false
        }
    }
    
    public var isFailure: Bool {
        return !isSuccess
    }
    
    public var value: Value? {
        switch self {
        case .success(let value):   return value
        case .failure:              return nil
        }
    }
    
    public var error: NSError? {
        switch self {
        case .success:              return nil
        case .failure(let error):   return error
        }
    }
}

public enum RequestMethod: String {
    case get    = "GET"
    case post   = "POST"
    case put    = "PUT"
    case delete = "DELETE"
}


struct ICURL {

    enum ServerEnvironment {
        case dev
        case pro
    }
    
    static var environment : ServerEnvironment = .dev
    
    static var baseUrl: String {
        return self.baseUrlFor(environment: .dev)
    }
    
    static func baseUrlFor(environment: ServerEnvironment) -> String {
        switch environment {
        case .dev:  return "https://ciddwebdesign.com/wp1"
        case .pro:  return "https://ibericoclub.com"
        }
    }
    
    static var getProductsURL: String { return "\(ICURL.baseUrl)/wp-json/wc/v2/products"}
    static var getOrdersURL: String { return "\(ICURL.baseUrl)/wp-json/wc/v2/orders"}
    static var getCategoriesURL : String {return "\(ICURL.baseUrl)/wp-json/wc/v2/products/categories"}
    static var getRecipesURL: String { return  "\(ICURL.baseUrl)/wp-json/wp/v2/posts"}
    static var loginURL: String { return "\(ICURL.baseUrl)/api/auth/generate_auth_cookie"}
    static var getCustomerInfoURL: String { return "\(ICURL.baseUrl)/wp-json/wc/v2/customers"}
    static var getRecipeCategoriesURL: String { return "\(ICURL.baseUrl)/wp-json/wp/v2/categories"}
    static var getSubscriptionsURL: String {return "\(ICURL.baseUrl)/wp-json/wc/v1/subscriptions"}
    static var getReferralURL: String {return "\(ICURL.baseUrl)/wp-json/wc/v2/coupons"}
    static var retrieveCouponURL: String {return "\(ICURL.baseUrl)/wp-json/wc/v2/coupons"}
    static var clearSessionURL: String {return "\(ICURL.baseUrl)/clear.sessions.php"}
    static var getCouponsURL: String {return "\(ICURL.baseUrl)/wp-services/wp-json-coupons.php"}
    static var getUsersURL: String {return "\(ICURL.baseUrl)/wp-json/wp/v2/users"}
    static var getLinkedProductsURL : String {return "\(ICURL.baseUrl)/wp-services/wp-json-post-connector.php"}
    
    
}



class Server {
    
    fileprivate let consumer_key = "ck_f7d0e857357e96ab3659e763cb872e50c7703d82"
    fileprivate let consumer_secret = "cs_fd210e8516ed42a2a722a7e303403f4853878a5d"
    fileprivate let consumer_user = "ciddteam"
    fileprivate let consumer_password = "Cultur@W3b"
    let authorizationHeader = ""
    
    
    enum JSONError: String, Error {
        case NoData = "No data"
        case JSONConversionFailed = "JSON conversion failed"
        case StringConversionFailed = "String conversion failed"
    }
    
    private init () {}
    static let instance = Server()
    var currentRequest : URLSessionDataTask?
    
    
    
    class func requestBasicAuth(urlString: String?, method: RequestMethod, parameters: Params = nil, completion: @escaping DefaultResponse) -> URLSessionDataTask? {
        
        
        
        guard let urlString_ = urlString else {
            return nil
        }
        guard let url = URL(string: urlString_) else {
            return nil
        }
        
        
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
    
        let userPasswordString = self.instance.consumer_user+":"+self.instance.consumer_password
        let base64EncodedCredential = userPasswordString.data(using: .utf8)!.base64EncodedString()
        let authString = "Basic \(base64EncodedCredential)"
        
        urlRequest.setValue(authString, forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        
        if let params = parameters {
            print(params)
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: params, options: [])
                urlRequest.httpBody = jsonData
            }
            catch let error as NSError {
                completion(.failure(error))
                return nil
            }
        }
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            print("\n\nBasic Auth Authorization: \(authString)")
            print("URL STRING: \(urlString_)\n\n")
            
            if error == nil {
                guard let data_ = data else {
                    completion(.failure(JSONError.NoData as NSError))
                    return
                }
                do {
                    let jsonObject = try JSON(data: data_)
                    
                    if let statusCode = jsonObject["data"]["status"].int {
                        switch statusCode {
                        case 400, 401, 404:
                            let customError = NSError(domain: "ICDomain", code: statusCode, userInfo: [NSLocalizedDescriptionKey : jsonObject["message"].string ?? ""])
                            completion(.failure(customError))
                            print("'ServerConnector' Response   FAILURE: 😢\n–––––––––––––––––––––––––––––––––––––\n\(customError)\n\n\n")
                            break
                        default:
                            completion(.success(jsonObject))
                            print("'ServerConnector' Response   SUCCESS: 😁\n–––––––––––––––––––––––––––––––––––––\n\(jsonObject)\n\n\n")
                            break
                        }
                    }
                    else {
                        print("'ServerConnector' Response   SUCCESS: 😁\n–––––––––––––––––––––––––––––––––––––\n\(jsonObject)\n\n\n")
                        completion(.success(jsonObject))
                        
                    }
                    
                    
                }
                catch let error as NSError {
                    let jsonString = String(data: data_, encoding: String.Encoding.utf8)
                    print("json string: \(jsonString)")
                    completion(.failure(error as NSError))
                    return
                }
                
            }
            else {
                if let errorCode = (response as? HTTPURLResponse)?.statusCode {
                    let errorMessage = error?.localizedDescription ?? "Unknown error"
                    let customError = NSError(domain: "ICDomain", code: errorCode, userInfo: [NSLocalizedDescriptionKey : errorMessage])
                    print("'ServerConnector' Response   FAILURE: 😢\n–––––––––––––––––––––––––––––––––––––\n\(customError)\n\n\n")
                    completion(.failure(customError))
                }
                else {
                    print("'ServerConnector' Response   FAILURE: 😢\n–––––––––––––––––––––––––––––––––––––\n\(error)\n\n\n")
                    completion(.failure(error as! NSError))
                }
                return
            }
        }
        task.resume()
        return task
    }
    
    
    
    
    
    class func downloadImage(urlString: String, completion: @escaping ImageResponse) {
        
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if error == nil {
                    guard let data_ = data else {
                        let customError = NSError(domain: "ICDomain", code: 281117, userInfo: [NSLocalizedDescriptionKey : "Error while converting image"])
                        completion(nil, customError)
                        return
                    }
                    let image = UIImage(data: data_)
                    completion(image, nil)
                }
                else {
                    completion(nil, error as NSError?)
                }
                
                }.resume()
        }
        else {
            let customError = NSError(domain: "ICDomain", code: 291117, userInfo: [NSLocalizedDescriptionKey : "URL not valid"])
            completion(nil, customError)
        }
    }
    
    
    // API URLS
    
    class func getCategories(parameters: Params = nil, completion: @escaping DefaultResponse) {
        self.instance.currentRequest = Server.requestBasicAuth(urlString: ICURL.getCategoriesURL, method: .get, parameters: parameters, completion: completion)
    }
    
    class func getProductsByCategory(categoryID: String? = nil, completion: @escaping DefaultResponse) {
        if let categoryID_ = categoryID {
            self.instance.currentRequest = Server.requestBasicAuth(urlString: ICURL.getProductsURL+"?category="+categoryID_, method: .get, completion: completion)
        }
        else {
            self.instance.currentRequest = Server.requestBasicAuth(urlString: ICURL.getProductsURL, method: .get, completion: completion)
        }
    }
    
    class func getProductsByID(productID: String, completion: @escaping DefaultResponse) {
        self.instance.currentRequest = Server.requestBasicAuth(urlString: ICURL.getProductsURL+"/\(productID)", method: .get, completion: completion)
    }
    
    class func getRecipes(categoryID: String = "0", completion: @escaping DefaultResponse) {
        if categoryID == "0" {
            self.instance.currentRequest = Server.requestBasicAuth(urlString: ICURL.getRecipesURL+"?_embed", method: .get, completion: completion)
        }
        else {
            self.instance.currentRequest = Server.requestBasicAuth(urlString: ICURL.getRecipesURL+"?_embed&categories=\(categoryID)", method: .get, completion: completion)
            
        }
        
    }
    
    class func getProductsByText(text: String, completion: @escaping DefaultResponse) {
        self.instance.currentRequest = Server.requestBasicAuth(urlString: ICURL.getProductsURL+"?search=\(text)", method:.get, completion: completion)
    }
    
    class func getReviewsByProductID(productID: String, completion: @escaping DefaultResponse) {
        self.instance.currentRequest = Server.requestBasicAuth(urlString: ICURL.getProductsURL+"/\(productID)/reviews", method: .get, completion: completion)
    }
    
    class func getOrdersByCustomer(customerID: String, completion: @escaping DefaultResponse) {
        self.instance.currentRequest = Server.requestBasicAuth(urlString: ICURL.getOrdersURL+"?customer="+customerID, method: .get, completion: completion)
    }
    
    class func getUpdatedRecipeContent(recipeID: String, completion: @escaping DefaultResponse) {
        self.instance.currentRequest = Server.requestBasicAuth(urlString: ICURL.getRecipesURL+"/"+recipeID+"?_embed", method: .get, completion: completion)
    }
    
    class func getRecipeCategories( completion: @escaping DefaultResponse) {
        self.instance.currentRequest = Server.requestBasicAuth(urlString: ICURL.getRecipeCategoriesURL, method: .get, completion: completion)
    }
    
    class func getSubscriptionsByCustomer(customerID: String, completion: @escaping DefaultResponse) {
        self.instance.currentRequest = Server.requestBasicAuth(urlString: ICURL.getSubscriptionsURL+"?customer="+customerID, method: .get, completion: completion)
    }
    
    class func getReferralsByCustomer(customerID: String? = nil, completion: @escaping DefaultResponse) {
        if let _customerID = customerID {
            self.instance.currentRequest = Server.requestBasicAuth(urlString: ICURL.getReferralURL+"?customer="+_customerID, method: .get, completion: completion)
        }
        else {
            self.instance.currentRequest = Server.requestBasicAuth(urlString: ICURL.getReferralURL, method: .get, completion: completion)
        }
    }
    
    class func retrieveCoupon(couponID: String, completion: @escaping DefaultResponse) {
        self.instance.currentRequest = Server.requestBasicAuth(urlString: ICURL.retrieveCouponURL+"/\(couponID)", method: .get, completion: completion)
    }
    
    
    
    class func clearUserSession(completion: @escaping DefaultResponse) {
        self.instance.currentRequest = Server.requestBasicAuth(urlString: ICURL.clearSessionURL, method: .get, completion: completion)
    }
    
    class func getCoupons(email: String, completion: @escaping DefaultResponse) {
        self.instance.currentRequest = Server.requestBasicAuth(urlString: ICURL.getCouponsURL+"?email=\(email)", method: .get, completion: completion)
    }
    
    class func updateAccountDetails(userID: String, parameters: Params, completion: @escaping DefaultResponse) {
        self.instance.currentRequest = Server.requestBasicAuth(urlString: ICURL.getUsersURL+"/\(userID)", method: .post, parameters: parameters, completion: completion)
    }
    
    // User
    
    class func login(userName: String, password: String, completion: @escaping DefaultResponse) {
        _ = Server.requestBasicAuth(urlString: ICURL.loginURL+"/?username="+userName+"&password="+password, method: .get) { (result) in
            switch result {
            case .success(let value):
                //print("value: \(value)")
                guard let status = value["status"].string else {
                    let customError = NSError(domain: "ICDomain", code: 29121716, userInfo: [NSLocalizedDescriptionKey : "Unknown error"])
                    completion(.failure(customError))
                    return
                }
                if status == "error" {
                    let customError = NSError(domain: "ICDomain", code: 29121717, userInfo: [NSLocalizedDescriptionKey : value["error"].stringValue])
                    completion(.failure(customError))
                }
                else {
                    // SUCCESS! NOW, GET THE USER INFO
                    DispatchQueue.main.async {
                        let customerID = value["user"]["id"].intValue
                        _ = Server.requestBasicAuth(urlString: ICURL.getCustomerInfoURL+"/\(customerID)", method: .get, completion: { (userInfoResult) in
                            switch userInfoResult {
                            case .success(let value):
                                completion(.success(value))
                                break
                            case .failure(let userError):
                                completion(.failure(userError))
                                break
                            }
                        })
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    class func updateUser(customerID: String, parameters: Params, completion: @escaping DefaultResponse){
        self.instance.currentRequest = Server.requestBasicAuth(urlString: ICURL.getCustomerInfoURL+"/"+customerID, method: .put, parameters: parameters, completion: completion)
    }
    
    class func getLinkedProducts(recipeID: Int, completion: @escaping DefaultResponse) {
        self.instance.currentRequest = Server.requestBasicAuth(urlString: ICURL.getLinkedProductsURL+"?id=\(recipeID)", method: .get, completion: completion)
    }
    
    
}
