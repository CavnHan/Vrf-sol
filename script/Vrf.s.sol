pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import {Vrf} from "../src/Vrf.sol";
import {VrfFactory} from "../src/VrfFactory.sol";

contract VrfScript is Script {
    function run() external {
        vm.startBroadcast();

        Vrf vrf = new Vrf();
        console.log("Vrf contract address: ", address(vrf));

        VrfFactory vrfFactory = new VrfFactory();
        console.log("VrfFactory contract address: ", address(vrfFactory));

        console.log("address this is :", address(this));
        address proxy = vrfFactory.createProxyByOZ(address(vrf),msg.sender);
        console.log("Proxy contract address: ", proxy);

        vm.stopBroadcast();
    }
}
