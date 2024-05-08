//SPDX License Identifier: MIT
pragma solidity ^0.8.19;
import {Script} from "forge-std/Script.sol";
import {TokenERC20} from "../src/TokenERC20.sol";

contract DeployToken {
    uint256 public constant INITIAL_SUPPLY = 1000 ether;

    function run() external returns (TokenERC20) {
        TokenERC20 token = new TokenERC20(INITIAL_SUPPLY, "MyToken", "MTK");
        return token; // so, while deployin itself you pass the args.. but when u use the oz erc20 inheritance, then in the contract.sol file itself, u giv ethe args and these can be directly used in the deploy script. but here as the constructor while deploying take sthe inputs, we can give in the deploy script by the way of args..
    }
}
