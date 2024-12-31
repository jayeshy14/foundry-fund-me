//SPDX-Licence-Identifier: MIT
pragma solidity ^0.8.18;

//deploy mock contracts when we are on a local network
//store the addresses of the deployed contracts

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mock/MockAggregatorV3.sol";

contract HelperConfig is Script {
    struct NetworkConfig {
        address priceFeed;
    }

    NetworkConfig public activeNetworkConfig;

    uint8 DECIMALS = 8;
    int256 INITIAL_PRICE = 2000e8;

    constructor() {
        if (block.chainid == 11155111) {
            activeNetworkConfig = getSepoliaEthConfig();
        } else {
            activeNetworkConfig = getOrCreateAnvilEthConfig();
        }
    }

    function getSepoliaEthConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory config;
        config.priceFeed = 0x694AA1769357215DE4FAC081bf1f309aDC325306;
        return config;
    }

    function getOrCreateAnvilEthConfig() public returns (NetworkConfig memory) {
        vm.startBroadcast();
        MockV3Aggregator mockV3Aggregator = new MockV3Aggregator(DECIMALS, INITIAL_PRICE);
        vm.stopBroadcast();

        NetworkConfig memory config = NetworkConfig({priceFeed: address(mockV3Aggregator)});
        return config;
    }
}
