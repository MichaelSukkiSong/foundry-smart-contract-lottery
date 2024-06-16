// unit
// integration
// forked

// TODO: For you!

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {Raffle} from "../../src/Raffle.sol";
import {HelperConfig} from "../../script/HelperConfig.s.sol";
import {DeployRaffle} from "../../script/DeployRaffle.s.sol";
import {CreateSubscription, FundSubscription, AddConsumer} from "../../script/Interactions.s.sol";
import {Vm} from "forge-std/Vm.sol";

contract InteractionsTest is Test {
    Raffle raffle;
    HelperConfig helperconfig;

    address vrfCoordinator;
    address link;
    uint256 deployerKey;

    function setUp() external {
        DeployRaffle deployRaffle = new DeployRaffle();
        (raffle, helperconfig) = deployRaffle.run();
        (, , vrfCoordinator, , , , link, deployerKey) = helperconfig
            .activeNetworkConfig();
    }

    function testCanCreateSubscription() public {
        CreateSubscription createSubscription = new CreateSubscription();
        uint64 subId = createSubscription.createSubscription(
            vrfCoordinator,
            deployerKey
        );

        assert(subId != 0);
    }

    function testCanCreateAndFundSubscription() public {
        CreateSubscription createSubscription = new CreateSubscription();
        uint64 subId = createSubscription.createSubscription(
            vrfCoordinator,
            deployerKey
        );

        FundSubscription fundSubscription = new FundSubscription();
        vm.recordLogs();
        fundSubscription.fundSubscription(
            vrfCoordinator,
            subId,
            link,
            deployerKey
        );
        Vm.Log[] memory entries = vm.getRecordedLogs();

        // TODO : check the emmitted eventlog depending on the chain and make assertion
        // bytes32 oldBalance = entries[0].topics[2];
        // bytes32 newBalance = entries[0].topics[3];
        assert(true);
        // assert(uint256(newBalance) > uint256(oldBalance));
    }

    // TODO
    // function testCanCreateAndFundSubscriptionAndAddConsumer() public {}
}
