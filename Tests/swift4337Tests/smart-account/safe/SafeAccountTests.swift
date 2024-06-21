//
//  SafeAccountTests.swift.swift
//
//
//  Created by Frederic DE MATOS on 20/06/2024.
//

import XCTest
import web3
import BigInt
@testable import swift4337


  

class SafeAccountTests: XCTestCase {
    var safeAccount: SafeAccount!
    let rpc = TestRPCClient(network: EthereumNetwork.sepolia)
    let bundler = TestBundlerClient()
    let account = try! EthereumAccount.init(keyStorage: TestEthereumKeyStorage(privateKey: "0x4646464646464646464646464646464646464646464646464646464646464646"))
  
    override func setUp(){
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
 
    func testInitWalletWithoutAddressProdictAddressIsOk() async throws {
        self.safeAccount = try await SafeAccount(signer: account, rpc: rpc, bundler: bundler)
        let expectedAddress = EthereumAddress("0x2ff46f26638977ae8c88e205cca407a1a9725f0b")
        
         XCTAssertEqual(safeAccount.address.toChecksumAddress(), expectedAddress.toChecksumAddress())
    }
    
    func testGetCallDataWithOnlyValueIsOk() async throws {
        self.safeAccount = try await SafeAccount(signer: account, rpc: rpc, bundler: bundler)
        let callData = try safeAccount.getCallData(to: EthereumAddress("0xF64DA4EFa19b42ef2f897a3D533294b892e6d99E"), value: BigUInt(1), data: "0x".web3.hexData!)
        
        let expected = "0x7bb37428000000000000000000000000f64da4efa19b42ef2f897a3d533294b892e6d99e0000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
        
        XCTAssertEqual(callData.web3.hexString, expected)
    }
    
    func testGetCallDataWithDataIsOk() async throws {
        self.safeAccount = try await SafeAccount(signer: account, rpc: rpc, bundler: bundler)
        let callData = try safeAccount.getCallData(to: EthereumAddress("0x0338Dcd5512ae8F3c481c33Eb4b6eEdF632D1d2f"), value: BigUInt(0), data: "0x06661abd".web3.hexData!)
        
        let expected = "0x7bb374280000000000000000000000000338dcd5512ae8f3c481c33eb4b6eedf632d1d2f000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000406661abd00000000000000000000000000000000000000000000000000000000"
        
        XCTAssertEqual(callData.web3.hexString, expected)
    }
    
    
    func testGetInitCodeIsOk() async throws {
        self.safeAccount = try await SafeAccount(signer: account, rpc: rpc, bundler: bundler)
        let initCode = try await safeAccount.getInitCode()
        
        let expected = "0x4e1dcf7ad4e460cfd30791ccc4f9c8a4f820ec671688f0b900000000000000000000000029fcb43b46531bca003ddc8fcb67ffe91900c7620000000000000000000000000000000000000000000000000000000000000060000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001e4b63e800d000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000010000000000000000000000002dd68b007b46fbe91b9a7c3eda5a7a1063cb5b470000000000000000000000000000000000000000000000000000000000000140000000000000000000000000a581c4a4db7175302464ff3c06380bc3270b403700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000009d8a62f656a8d1615c1294fd71e9cfb3e4855a4f00000000000000000000000000000000000000000000000000000000000000648d0dc49f00000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000001000000000000000000000000a581c4a4db7175302464ff3c06380bc3270b40370000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
        
        XCTAssertEqual(initCode.web3.hexString, expected)
    }
    
    func testSignUserOperationIsOk() async throws {
        
        self.safeAccount = try await SafeAccount(signer: account, rpc: rpc, bundler: bundler)
        let userOp = UserOperation(sender: "0x2ff46f26638977ae8c88e205cca407a1a9725f0b",
                                   nonce: "0x00",
                                   callData: "0x7bb374280000000000000000000000000338dcd5512ae8f3c481c33eb4b6eedf632d1d2f000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000406661abd00000000000000000000000000000000000000000000000000000000",
                                   preVerificationGas:"0xea60",
                                   callGasLimit: "0x1e8480",
                                   verificationGasLimit: "0x07a120", maxFeePerGas:"0x02ee7c55e2",
                                   maxPriorityFeePerGas: "0x1f2ecf7f",
                                   paymasterAndData:"0x")
                                   
        
        let expected = "0x000000000000000000000000a5927f1a1d8783d9d7033abf5f1883582525a3558055b46a9425c5627a1a83d460d64f361379e3aa710d74b3c4763288598f373c866263c4a45394908c74a6d31c"
        
        let signature = try  self.safeAccount.signUserOperation(userOp)
        
        XCTAssertEqual(signature.web3.hexString, expected)
    }
    
    
    
    func testGetOwnerWithNotDeployedThrows() async throws {
        self.safeAccount = try await SafeAccount(address: EthereumAddress("0xF64DA4EFa19b42ef2f897a3D533294b892e6d99E"), signer: account, rpc: rpc, bundler: bundler)
        
        do{
            _ = try await self.safeAccount.getOwners()
            XCTFail("Should throw error")
        } catch {
            XCTAssertEqual(error as! SmartAccountError, SmartAccountError.errorAccountNotDeployed)
        }
    }
    
    func testGetOwnerWithDeployedIsOk() async throws {
        self.safeAccount = try await SafeAccount(signer: account, rpc: rpc, bundler: bundler)
        
        let owners = try await self.safeAccount.getOwners()
        XCTAssertEqual(owners[0].toChecksumAddress(), account.address.toChecksumAddress())
    }
}