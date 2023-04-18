// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.7;

import "forge-std/Test.sol";
import "../src/savings.sol";
import "../src/token.sol";
import "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
contract CounterTest is Test {
    miniWallet public MiniWallet;
    address Alice;
    address Dilshad;
    address Shahad;
    IERC20 Token = IERC20 (0x865b5751bcDe7E06030670b4d9D27651A25f2fCF);
    uint256 alfajoresFork;
    string CELO_RPC_URL = vm.envString("CELO_RPC_URL");
    
    function setUp() public {
        alfajoresFork = vm.createFork(CELO_RPC_URL);
        vm.selectFork(alfajoresFork);
        MiniWallet = new miniWallet(ERC20 (0x865b5751bcDe7E06030670b4d9D27651A25f2fCF));
        MiniWallet.activateSaving(true);
        Alice = 0xE7818b0e067Bc205B0a2A3055818083D13F11aA8;
        Dilshad = 0x085Ee67132Ec4297b85ed5d1b4C65424D36fDA7d;
        Shahad = 0xD06e61faEB0d8a7B0835C0F3C127aED98908a687;
    }

    function testconfirmActiveFork() public{
        assertEq(vm.activeFork(), alfajoresFork);
    }

    function testActivateSaving() public {
        MiniWallet.activateSaving(true);
        assertEq(MiniWallet.savingActive(), true);
    }

    function testTransfer() public {
        vm.startPrank(0x049C780d7fa94AA70194eFC88ee109781eaeE1C2);
        Token.transfer(Alice, 10000);
        Token.transfer(Dilshad, 10000);
        Token.transfer(Shahad, 10000);
        vm.stopPrank();
        assert(Token.balanceOf(Alice) == 10000);
         assert(Token.balanceOf(Dilshad) ==10000);
         assert(Token.balanceOf(Shahad) == 10000);

// Test save(), viewWalletBalance(), and addSaving functions on address Alice
       vm.startPrank(Alice);
        MiniWallet.save(600, 4);
        MiniWallet.viewWalletBalance();
        MiniWallet.addSaving(100);
        MiniWallet.viewWalletBalance();
        vm.stopPrank();

// Test save(), viewWalletBalance(), and addSaving functions on address Dilshad
        vm.startPrank(Dilshad);
        MiniWallet.save(300, 2);
        MiniWallet.viewWalletBalance();
        MiniWallet.addSaving(300);
        MiniWallet.viewWalletBalance();
        vm.stopPrank();

// Attempt to addSaving() without any previous saving on address Shahad. 
//This test us expected to fail because Shahad hasn't used the saved tokens before.
        //vm.startPrank(Shahad);
        // MiniWallet.save(300, 2);
        // MiniWallet.viewWalletBalance();
        //MiniWallet.addSaving(300);
        //MiniWallet.viewWalletBalance();
       //vm.stopPrank();

// Test withdraw() function with address Dilshad
    //    vm.startPrank(Dilshad);
    //    MiniWallet.withdraw(500);
    //    vm.stopPrank();
// Test withdraw() function with address Shahad, which hasn't saved any token on savings.sol
       vm.startPrank(Shahad);
       MiniWallet.withdraw(200);
       vm.stopPrank();
    }

    // function testSave() public {
    // }
}


/*  

    No, first, I want to fork mainnet then activate it.
    Next get an address that has CELO, the CELO contract address and addresses to impersonate
    I also wanna activate saving and withdraw, then save with some addresses and attempt to withdraw.
    Deactive and try to save
    prank another address to withdraw.
 */