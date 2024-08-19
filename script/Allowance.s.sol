// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {Allowance} from "../src/Allowance.sol";

contract AllowanceScript is Script {
    address[] private _kids = [
        0xa0Ee7A142d267C1f36714E4a8F75612F20a79720, // these are local mock addrs
        0x23618e81E3f5cdF7f54C3d65f7FBc0aBf5B21E8f
    ];
    Allowance public allowance;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        allowance = new Allowance(_kids, 25000, 60);

        vm.stopBroadcast();
    }
}
