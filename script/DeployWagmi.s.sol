// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script} from "forge-std/Script.sol";
import {WagmiToken} from "../src/WagmiToken.sol";

contract DeployWagmi is Script {
    uint256 private constant _initialSupply = 1000 ether;

    function run() external returns (WagmiToken) {
        vm.startBroadcast();
        WagmiToken wagmiToken = new WagmiToken(_initialSupply);
        vm.stopBroadcast();
        return wagmiToken;
    }
}
