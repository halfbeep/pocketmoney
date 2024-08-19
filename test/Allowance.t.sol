// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Allowance} from "../src/Allowance.sol";

contract AllowanceTest is Test {
    Allowance public allowance;

    address[] private _kids = [
        0xa0Ee7A142d267C1f36714E4a8F75612F20a79720, // these are local mock addrs
        0x23618e81E3f5cdF7f54C3d65f7FBc0aBf5B21E8f
    ];

    function setUp() public {
        allowance = new Allowance(_kids, 25000, 60);
    }

    function testFuzz_SetFrequency(uint256 x) public {
        allowance.setFrequency(x);
        assertEq(allowance.frequency(), x);
    }

    function test_ReleaseAllowance() public {
        allowance.releaseAllowance();
    }

    function testFuzz_SetAmount(uint256 x) public {
        allowance.setAmount(x);
        assertEq(allowance.amount(), x);
    }

    function test_ContractBalance() public view {
        uint256 test = allowance.contractBalance();
        console.log("balance = ", test);
    }
}
