// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";
import {DeployWagmi} from "../script/DeployWagmi.s.sol";
import {WagmiToken} from "../src/WagmiToken.sol";

contract WagmiTokenTest is Test {
    WagmiToken public wagmiToken;
    DeployWagmi public deployer;

    address bob = makeAddr("bob");
    address alice = makeAddr("alice");

    uint256 public constant STARTING_BALANCE = 100 ether;

    function setUp() public {
        deployer = new DeployWagmi();
        wagmiToken = deployer.run();

        vm.prank(msg.sender);
        wagmiToken.transfer(bob, STARTING_BALANCE);
    }

    function testBobBalance() public {
        assertEq(wagmiToken.balanceOf(bob), STARTING_BALANCE);
    }

    function testAllowancesWork() public {
        uint256 initialAllowance = 1000;
        uint256 transferAmount = 500;

        vm.prank(bob);
        wagmiToken.approve(alice, initialAllowance);

        vm.prank(alice);
        wagmiToken.transferFrom(bob, alice, transferAmount);

        assertEq(wagmiToken.balanceOf(bob), STARTING_BALANCE - transferAmount);
        assertEq(wagmiToken.balanceOf(alice), transferAmount);
    }

    function testTransfer() public {
        uint256 transferAmount = 50;

        vm.prank(bob);
        wagmiToken.transfer(alice, transferAmount);

        assertEq(wagmiToken.balanceOf(bob), STARTING_BALANCE - transferAmount);
        assertEq(wagmiToken.balanceOf(alice), transferAmount);
    }

    function testTransferFrom() public {
        uint256 initialAllowance = 1000;
        uint256 transferAmount = 500;

        vm.prank(bob);
        wagmiToken.approve(alice, initialAllowance);

        vm.prank(alice);
        wagmiToken.transferFrom(bob, alice, transferAmount);

        assertEq(wagmiToken.balanceOf(bob), STARTING_BALANCE - transferAmount);
        assertEq(wagmiToken.balanceOf(alice), transferAmount);
        assertEq(
            wagmiToken.allowance(bob, alice),
            initialAllowance - transferAmount
        );
    }

    function testInsufficientAllowance() public {
        uint256 initialAllowance = 50;
        uint256 transferAmount = 100;

        vm.prank(bob);
        wagmiToken.approve(alice, initialAllowance);

        vm.prank(alice);
        // This should revert due to insufficient allowance
        vm.expectRevert();
        wagmiToken.transferFrom(bob, alice, transferAmount);
    }

    function testTransferToZeroAddress() public {
        // Attempting to transfer to the zero address should revert
        // as transfers to the zero address are not allowed by ERC-20
        vm.prank(bob);
        // This should revert
        vm.expectRevert();
        wagmiToken.transfer(address(0), 10);
    }

    function testSelfTransfer() public {
        // Attempting to transfer to the same address should revert
        vm.prank(bob);
        // This should revert
        vm.expectRevert();
        wagmiToken.transfer(bob, 10);
    }
}
