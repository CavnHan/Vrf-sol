pragma solidity ^0.8.0;
import "@openzeppelin/contracts/proxy/Clones.sol";
import "./Vrf.sol";

contract VrfFactory {
    constructor() {}

    event ProxyCreated(address proxyAddress);

    function createProxy(address imlementation) external returns (address) {
        bytes memory byteCode = abi.encodePacked(
            hex"3d602d80600a3d3981f3",
            hex"363d3d373d3d3d363d73",
            imlementation,
            hex"5af43d82803e903d91602b57fd5bf3"
        );
        address proxy;
        assembly {
            proxy := create(0, add(byteCode, 0x20), mload(byteCode))
        }
        require(proxy != address(0), "Proxy Created failed");
        emit ProxyCreated(proxy);
        return proxy;
    }

    function createProxyByOZ(
        address implementation,
        address manager
    ) external returns (address) {
        address mintProxyAddress = Clones.clone(implementation);
        Vrf(mintProxyAddress).initialize(msg.sender,manager);
        emit ProxyCreated(mintProxyAddress);
        return mintProxyAddress;
    }
}
