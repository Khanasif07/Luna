//
//  EncryptionController.swift
//  Luna
//
//  Created by Admin on 26/11/21.
//

import Foundation
import CommonCrypto

protocol Randomizer {
    static func randomIv() -> Data
    static func randomSalt() -> Data
    static func randomData(length: Int) -> Data
}

protocol Crypter {
    func encrypt(_ digest: Data) throws -> Data
    func decrypt(_ encrypted: Data) throws -> Data
}

struct AES256Crypter {
    
    private var key: Data
    private var iv: Data
    
    public init(key: Data, iv: Data) throws {
        guard key.count == kCCKeySizeAES256 else {
            throw Error.badKeyLength
        }
        guard iv.count == kCCBlockSizeAES128 else {
            throw Error.badInputVectorLength
        }
        self.key = key
        self.iv = iv
    }
    
    enum Error: Swift.Error {
        case keyGeneration(status: Int)
        case cryptoFailed(status: CCCryptorStatus)
        case badKeyLength
        case badInputVectorLength
    }
    
    static func encryptionAESModeECB(messageData data: Data, key: String) -> Data? {
        guard let keyData = key.data(using: String.Encoding.utf8) else { return nil }
        guard let cryptData = NSMutableData(length: Int((data.count)) + kCCBlockSizeAES128) else { return nil }
        
        let keyLength               = size_t(kCCKeySizeAES128)
        let operation:  CCOperation = UInt32(kCCEncrypt)
        let algoritm:   CCAlgorithm = UInt32(kCCAlgorithmAES)
        let options:    CCOptions   = UInt32(kCCOptionECBMode + kCCOptionPKCS7Padding)
        let iv:         String      = ""
        
        var numBytesEncrypted: size_t = 0
        
        let cryptStatus = CCCrypt(operation,
                                  algoritm,
                                  options,
                                  (keyData as NSData).bytes, keyLength,
                                  iv,
                                  (data as NSData).bytes, data.count,
                                  cryptData.mutableBytes, cryptData.length,
                                  &numBytesEncrypted)
        
        if UInt32(cryptStatus) == UInt32(kCCSuccess) {
            cryptData.length = Int(numBytesEncrypted)
            let encryptedString = cryptData.base64EncodedString(options: .lineLength64Characters)
            return encryptedString.data(using: .utf8)
        } else {
            return nil
        }
    }

    static func decryptionAESModeECB(messageData: Data, key: String) -> Data? {
        guard let messageString = String(data: messageData, encoding: .utf8) else { return nil }
        guard let data = Data(base64Encoded: messageString, options: .ignoreUnknownCharacters) else { return nil }
        guard let keyData = key.data(using: String.Encoding.utf8) else { return nil }
        guard let cryptData = NSMutableData(length: Int((data.count)) + kCCBlockSizeAES128) else { return nil }
        
        let keyLength               = size_t(kCCKeySizeAES128)
        let operation:  CCOperation = UInt32(kCCDecrypt)
        let algoritm:   CCAlgorithm = UInt32(kCCAlgorithmAES)
        let options:    CCOptions   = UInt32(kCCOptionECBMode + kCCOptionPKCS7Padding)
        let iv:         String      = ""
        
        var numBytesEncrypted: size_t = 0
        
        let cryptStatus = CCCrypt(operation,
                                  algoritm,
                                  options,
                                  (keyData as NSData).bytes, keyLength,
                                  iv,
                                  (data as NSData).bytes, data.count,
                                  cryptData.mutableBytes, cryptData.length,
                                  &numBytesEncrypted)
        
        if UInt32(cryptStatus) == UInt32(kCCSuccess) {
            cryptData.length = Int(numBytesEncrypted)
            return cryptData as Data
        } else {
            return nil
        }
    }
    
}
