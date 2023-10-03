// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import "forge-std/console.sol";
import {Vault} from "../src/Vault.sol";
import {ZToken} from "../src/ZToken.sol";
import {BakiOracle} from "../src/Oracle.sol";
import {Collateral} from "../src/Collateral.sol";

contract VaultTest is Test {
    Vault public vault;
    Collateral public collateral;
    BakiOracle public oracle;
    ZToken public zngn;
    ZToken public zzar;
    ZToken public zusd;
    ZToken public zxaf;
    address public user;

    function setUp() public {
        // Contracts prior to Vault
        collateral = new Collateral();
        zngn = new ZToken();
        zzar = new ZToken();
        zusd = new ZToken();
        zxaf = new ZToken();
        oracle = new BakiOracle(address(this), address(zusd), address(zngn), address(zzar), address(zxaf));
        user = address(0x01);

        vault = new Vault();
        vault.vault_init(address(this), address(oracle), address(collateral), address(zusd));

        //set zToken's value.
        oracle.setZTokenUSDValue("zusd", 1000);
        oracle.setZTokenUSDValue("zngn", 1000000); 
        oracle.setZTokenUSDValue("zzar", 18000);
        oracle.setZTokenUSDValue("zxaf", 900000);

        oracle.setZCollateralUSD(1000);
    }

    function test_globalDebt() public {
        address a = address(0x1111);
        address b = address(0x2222);
        address c = address(0x3333);
        address d = address(0x4444);
        address e = address(0x5555);
        collateral.transfer(a, 150 * 1e18);
        collateral.transfer(b, 150 * 1e18);
        collateral.transfer(c, 150 * 1e18);
        collateral.transfer(d, 150 * 1e18);
        collateral.transfer(e, 150 * 1e18);

        console2.log("DEPOSIT AND MINT...........................................");

        vm.startPrank(a);
        vault.depositAndMint(150 * 1e18, 100 * 1e18);
        vm.stopPrank();
        console2.log("global debt after user A deposit =", vault.getGlobalDebt());
        console2.log("user debt A after deposit =", vault.getUserDebt(a));
        console2.log("user debt B after deposit =", vault.getUserDebt(b));
        console2.log("user debt C after deposit =", vault.getUserDebt(c));
        console2.log("user debt D after deposit =", vault.getUserDebt(d));
        console2.log("user debt E after deposit =", vault.getUserDebt(e));

        vm.startPrank(b);
        vault.depositAndMint(150 * 1e18, 100 * 1e18);
        vm.stopPrank();
        console2.log("global debt after user B deposit =", vault.getGlobalDebt());
        console2.log("user debt A after deposit =", vault.getUserDebt(a));
        console2.log("user debt B after deposit =", vault.getUserDebt(b));
        console2.log("user debt C after deposit =", vault.getUserDebt(c));
        console2.log("user debt D after deposit =", vault.getUserDebt(d));
        console2.log("user debt E after deposit =", vault.getUserDebt(e));

        vm.startPrank(c);
        vault.depositAndMint(150 * 1e18, 100 * 1e18);
        vm.stopPrank();
        console2.log("global debt after user C deposit =", vault.getGlobalDebt());
        console2.log("user debt A after deposit =", vault.getUserDebt(a));
        console2.log("user debt B after deposit =", vault.getUserDebt(b));
        console2.log("user debt C after deposit =", vault.getUserDebt(c));
        console2.log("user debt D after deposit =", vault.getUserDebt(d));
        console2.log("user debt E after deposit =", vault.getUserDebt(e));

        vm.startPrank(d);
        vault.depositAndMint(150 * 1e18, 100 * 1e18);
        vm.stopPrank();
       console2.log("global debt after user D deposit =", vault.getGlobalDebt());
        console2.log("user debt A after deposit =", vault.getUserDebt(a));
        console2.log("user debt B after deposit =", vault.getUserDebt(b));
        console2.log("user debt C after deposit =", vault.getUserDebt(c));
        console2.log("user debt D after deposit =", vault.getUserDebt(d));
        console2.log("user debt E after deposit =", vault.getUserDebt(e));

        vm.startPrank(e);
        vault.depositAndMint(150 * 1e18, 100 * 1e18);
        vm.stopPrank();
       console2.log("global debt after user E deposit =", vault.getGlobalDebt());
        console2.log("user debt A after deposit =", vault.getUserDebt(a));
        console2.log("user debt B after deposit =", vault.getUserDebt(b));
        console2.log("user debt C after deposit =", vault.getUserDebt(c));
        console2.log("user debt D after deposit =", vault.getUserDebt(d));
        console2.log("user debt E after deposit =", vault.getUserDebt(e));

        console2.log("USER SWAP...........................................");

        vm.startPrank(b);
        vault.swap(100 * 1e18, "zusd", "zngn");
        vm.stopPrank();
       

        vm.startPrank(c);
        vault.swap(100 * 1e18, "zusd", "zzar");
        vm.stopPrank();
        console2.log("global debt after user C swap =", vault.getGlobalDebt());
        console2.log("user debt A after swap =", vault.getUserDebt(a));
        console2.log("user debt B after swap =", vault.getUserDebt(b));
        console2.log("user debt C after swap =", vault.getUserDebt(c));
        console2.log("user debt D after swap =", vault.getUserDebt(d));
        console2.log("user debt E after swap =", vault.getUserDebt(e));
    }

    function test_CollateralRatio() public {
        address a = address(0x1111);
        address b = address(0x2222);
        address c = address(0x3333);
        address d = address(0x4444);
        address e = address(0x5555);
        collateral.transfer(a, 150 * 1e18);
        collateral.transfer(b, 150 * 1e18);
        collateral.transfer(c, 150 * 1e18);
        collateral.transfer(d, 150 * 1e18);
        collateral.transfer(e, 150 * 1e18);

        console2.log("DEPOSIT AND MINT...........................................");

        vm.startPrank(a);
        vault.depositAndMint(150 * 1e18, 100 * 1e18);
        vm.stopPrank();
        console2.log("user A collateral ratio after deposit =", vault.returnLastCollateralRatio(a));

        vm.startPrank(b);
        vault.depositAndMint(150 * 1e18, 100 * 1e18);
        vm.stopPrank();
        console2.log("user B collateral ratio after deposit =", vault.returnLastCollateralRatio(b));

        vm.startPrank(c);
        vault.depositAndMint(150 * 1e18, 100 * 1e18);
        vm.stopPrank();
        console2.log("user C collateral ratio after deposit =", vault.returnLastCollateralRatio(c));

        vm.startPrank(d);
        vault.depositAndMint(150 * 1e18, 100 * 1e18);
        vm.stopPrank();
        console2.log("user D collateral ratio after deposit =", vault.returnLastCollateralRatio(d));

         vm.startPrank(e);
        vault.depositAndMint(150 * 1e18, 100 * 1e18);
        vm.stopPrank();
        console2.log("user E collateral ratio after deposit =", vault.returnLastCollateralRatio(e));

        console2.log("USER SWAP...........................................");

        vm.startPrank(b);
        vault.swap(100 * 1e18, "zusd", "zngn");
        vm.stopPrank();

        vm.startPrank(c);
        vault.swap(100 * 1e18, "zusd", "zzar");
        vm.stopPrank();
        console2.log("user A collateral ratio after swap =", vault.getUserCollateralRatio(a));
        console2.log("user B collateral ratio after swap =", vault.getUserCollateralRatio(b));
        console2.log("user C collateral ratio after swap =", vault.getUserCollateralRatio(c));
        console2.log("user D collateral ratio after swap =", vault.getUserCollateralRatio(d));
        console2.log("user E collateral ratio after swap =", vault.getUserCollateralRatio(e));
    }

    function test_zeroDebts() public {
         address a = address(0x1111);

         collateral.transfer(a, 150 * 1e18);

         console2.log("DEPOSIT AND MINT...........................................");

        vm.startPrank(a);
        vault.depositAndMint(150 * 1e18, 0 * 1e18);
        vm.stopPrank();
        console2.log("user A collateral ratio after deposit =", vault.returnLastCollateralRatio(a));

        console2.log("WITHDRAWALS...........................................");

        vm.startPrank(a);
        vault.repayAndWithdraw(0, 100 * 1e18, "zusd");
        vm.stopPrank();
        console2.log("user A collateral ratio after first withdrawal =", vault.returnLastCollateralRatio(a));

        vm.startPrank(a);
        vault.repayAndWithdraw(0, 50 * 1e18, "zngn");
        vm.stopPrank();
        console2.log("user A collateral ratio after second withdrawals =", vault.returnLastCollateralRatio(a));
    }

    function test_Liquidation() public {
        address a = address(0x1111);

         collateral.transfer(a, 150 * 1e18);

         console2.log("DEPOSIT AND MINT...........................................");

        vm.startPrank(a);
        vault.depositAndMint(150 * 1e18, 100 * 1e18);
        vm.stopPrank();
        console2.log("user A collateral ratio after deposit =", vault.returnLastCollateralRatio(a));

        console2.log("SWAP TO ZNGN...........................................");

        vm.startPrank(a);
        vault.swap(100 * 1e18, "zusd", "zngn");
        vm.stopPrank();
        console2.log("user A collateral ratio after swap =", vault.getUserCollateralRatio(a));

        console2.log("ZNGN STRENGTHENS IN VALUE..................................");

        oracle.setZTokenUSDValue("zngn", 500000); 

        console2.log("check user for liquidation", vault.checkUserForLiquidation(a));

        console2.log("user A collateral ratio after swap =", vault.getUserCollateralRatio(a));

    }
}
