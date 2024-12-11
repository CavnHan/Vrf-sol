pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import {Vrf} from "../src/Vrf.sol";
import {VrfFactory} from "../src/VrfFactory.sol";
import {console} from "forge-std/Script.sol";

contract ProxyTest is Test {
    Vrf public vrf;
    VrfFactory public vrfFactory;
    Vrf public vrfProxy;

    function setUp() public {
        vrf = new Vrf();
        vrfFactory = new VrfFactory();
        vrfProxy = Vrf(vrfFactory.createProxyByOZ(address(vrf),address(this)));
        console.log("manager address:",vrfProxy.VrfManager());
    }

    function testSetValue() public {
        vrfProxy.requestRandWords(1,3);
        uint256[] memory randomWords = new uint256[](3);
        randomWords[0] = 1;
        randomWords[1] = 2;
        randomWords[2] = 3;
        vrfProxy.fulfillRandomWords(1, randomWords);
        (bool success,uint256[] memory result) = vrfProxy.getRequestStatus(1);
        console.log("=======================================");
        console.log("status:", success);
        console.log("result is :", result[0]);
        console.log("result is :", result[1]);
        console.log("result is :", result[2]);
        console.log("=======================================");

    }

}
