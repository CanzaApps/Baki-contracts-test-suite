// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import "forge-std/console.sol";
import {Vault} from "../src/PreVault.sol";
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

        console2.log("USERS SWAP...........................................");

        vm.startPrank(b);
        vault.swap(100 * 1e18, "zusd", "zngn");
        vm.stopPrank();
        console2.log("global debt after user B swap =", vault.getGlobalDebt());
        console2.log("user debt A after swap =", vault.getUserDebt(a));
        console2.log("user debt B after swap =", vault.getUserDebt(b));
        console2.log("user debt C after swap =", vault.getUserDebt(c));
        console2.log("user debt D after swap =", vault.getUserDebt(d));
        console2.log("user debt E after swap =", vault.getUserDebt(e));
        console2.log("Global Minters Fee =", vault.globalMintersFee());
        console2.log("Treasury wallet balance =", zusd.balanceOf(0x6F996Cb36a2CB5f0e73Fc07460f61cD083c63d4b));

        vm.startPrank(c);
        vault.swap(100 * 1e18, "zusd", "zzar");
        vm.stopPrank();
        console2.log("global debt after user C swap =", vault.getGlobalDebt());
         console2.log("user debt A after swap =", vault.getUserDebt(a));
        console2.log("user debt B after swap =", vault.getUserDebt(b));
        console2.log("user debt C after swap =", vault.getUserDebt(c));
        console2.log("user debt D after swap =", vault.getUserDebt(d));
        console2.log("user debt E after swap =", vault.getUserDebt(e));
        console2.log("Global Minters Fee =", vault.globalMintersFee());
        console2.log("Treasury wallet balance =", zusd.balanceOf(0x6F996Cb36a2CB5f0e73Fc07460f61cD083c63d4b));

        console2.log("USERS CLAIM FEES...........................................");

        vm.startPrank(a);
        console2.log("user A accrued balance =", vault.getUserReward());
        vault.claimFees();
        vm.stopPrank();
        console2.log("global debt after user A claim fees =", vault.getGlobalDebt());
        console2.log("user A debt after claim fees =", vault.getUserDebt(a));
        console2.log("user B debt after claim fees =", vault.getUserDebt(b));
        console2.log("user C debt after claim fees =", vault.getUserDebt(c));
        console2.log("user D debt after claim fees =", vault.getUserDebt(d));
        console2.log("user E debt after claim fees =", vault.getUserDebt(e));
        
        vm.startPrank(b);
        console2.log("user B accrued balance =", vault.getUserReward());
        vault.claimFees();
        vm.stopPrank();
        console2.log("global debt after user B claim fees =", vault.getGlobalDebt());
        console2.log("user A debt after claim fees =", vault.getUserDebt(a));
        console2.log("user B debt after claim fees =", vault.getUserDebt(b));
        console2.log("user C debt after claim fees =", vault.getUserDebt(c));
        console2.log("user D debt after claim fees =", vault.getUserDebt(d));
        console2.log("user E debt after claim fees =", vault.getUserDebt(e));

        vm.startPrank(c);
        console2.log("user C accrued balance =", vault.getUserReward());
        vault.claimFees();
        vm.stopPrank();
        console2.log("global debt after user C claim fees =", vault.getGlobalDebt());
        console2.log("user A debt after claim fees =", vault.getUserDebt(a));
        console2.log("user B debt after claim fees =", vault.getUserDebt(b));
        console2.log("user C debt after claim fees =", vault.getUserDebt(c));
        console2.log("user D debt after claim fees =", vault.getUserDebt(d));
        console2.log("user E debt after claim fees =", vault.getUserDebt(e));

        vm.startPrank(d);
        console2.log("user D accrued balance =", vault.getUserReward());
        vault.claimFees();
        vm.stopPrank();
        console2.log("global debt after user D claim fees =", vault.getGlobalDebt());
        console2.log("user A debt after claim fees =", vault.getUserDebt(a));
        console2.log("user B debt after claim fees =", vault.getUserDebt(b));
        console2.log("user C debt after claim fees =", vault.getUserDebt(c));
        console2.log("user D debt after claim fees =", vault.getUserDebt(d));
        console2.log("user E debt after claim fees =", vault.getUserDebt(e));
        
        vm.startPrank(e);
        console2.log("user E accrued balance =", vault.getUserReward());
        vault.claimFees();
        vm.stopPrank();
        console2.log("global debt after user E claim fees =", vault.getGlobalDebt());
        console2.log("user A debt after claim fees =", vault.getUserDebt(a));
        console2.log("user B debt after claim fees =", vault.getUserDebt(b));
        console2.log("user C debt after claim fees =", vault.getUserDebt(c));
        console2.log("user D debt after claim fees =", vault.getUserDebt(d));
        console2.log("user E debt after claim fees =", vault.getUserDebt(e));
        
        console2.log("USERS REPAY...........................................");
        
        vm.startPrank(a);
        vault.repayAndWithdraw(16 * 1e16, 0, "zusd");
        vm.stopPrank();
        console2.log("global debt after user A repays =", vault.getGlobalDebt());
        console2.log("user A debt after repay =", vault.getUserDebt(a));
        console2.log("user B debt after repay =", vault.getUserDebt(b));
        console2.log("user C debt after repay =", vault.getUserDebt(c));
        console2.log("user D debt after repay =", vault.getUserDebt(d));
        console2.log("user E debt after repay =", vault.getUserDebt(e));

        vm.startPrank(b);
        vault.repayAndWithdraw(16 * 1e16, 0, "zusd");
        vm.stopPrank();
        console2.log("global debt after user B repays =", vault.getGlobalDebt());
         console2.log("user A debt after repay =", vault.getUserDebt(a));
        console2.log("user B debt after repay =", vault.getUserDebt(b));
        console2.log("user C debt after repay =", vault.getUserDebt(c));
        console2.log("user D debt after repay =", vault.getUserDebt(d));
        console2.log("user E debt after repay =", vault.getUserDebt(e));

        vm.startPrank(c);
        vault.repayAndWithdraw(16 * 1e16, 0, "zusd");
        vm.stopPrank();
        console2.log("global debt after user C repays =", vault.getGlobalDebt());
         console2.log("user A debt after repay =", vault.getUserDebt(a));
        console2.log("user B debt after repay =", vault.getUserDebt(b));
        console2.log("user C debt after repay =", vault.getUserDebt(c));
        console2.log("user D debt after repay =", vault.getUserDebt(d));
        console2.log("user E debt after repay =", vault.getUserDebt(e));

        vm.startPrank(d);
        vault.repayAndWithdraw(16 * 1e16, 0, "zusd");
        vm.stopPrank();
        console2.log("global debt after user D repays =", vault.getGlobalDebt());
        console2.log("user A debt after repay =", vault.getUserDebt(a));
        console2.log("user B debt after repay =", vault.getUserDebt(b));
        console2.log("user C debt after repay =", vault.getUserDebt(c));
        console2.log("user D debt after repay =", vault.getUserDebt(d));
        console2.log("user E debt after repay =", vault.getUserDebt(e));

        vm.startPrank(e);
        vault.repayAndWithdraw(16 * 1e16, 0, "zusd");
        vm.stopPrank();
        console2.log("global debt after user E repays =", vault.getGlobalDebt());
        console2.log("user A debt after repay =", vault.getUserDebt(a));
        console2.log("user B debt after repay =", vault.getUserDebt(b));
        console2.log("user C debt after repay =", vault.getUserDebt(c));
        console2.log("user D debt after repay =", vault.getUserDebt(d));
        console2.log("user E debt after repay =", vault.getUserDebt(e));


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

        console2.log("USERS SWAP...........................................");

        vm.startPrank(b);
        vault.swap(100 * 1e18, "zusd", "zngn");
        vm.stopPrank();

        vm.startPrank(c);
        vault.swap(100 * 1e18, "zusd", "zzar");
        vm.stopPrank();

        console2.log("USERS CLAIM FEES...........................................");

        vm.startPrank(a);
        console2.log("user A accrued balance =", vault.getUserReward());
        vault.claimFees();

        vm.startPrank(b);
        console2.log("user B accrued balance =", vault.getUserReward());
        vault.claimFees();
        vm.stopPrank();

        vm.startPrank(c);
        console2.log("user C accrued balance =", vault.getUserReward());
        vault.claimFees();
        vm.stopPrank();

        vm.startPrank(d);
        console2.log("user D accrued balance =", vault.getUserReward());
        vault.claimFees();
        vm.stopPrank();

        vm.startPrank(e);
        console2.log("user E accrued balance =", vault.getUserReward());
        vault.claimFees();
        vm.stopPrank();

        console2.log("USERS REPAY...........................................");

        vm.startPrank(a);
        vault.repayAndWithdraw(16 * 1e16, 0, "zusd");
        vm.stopPrank();
        console2.log("user A collateral ratio after repay =", vault.returnLastCollateralRatio(a));

        vm.startPrank(b);
        vault.repayAndWithdraw(16 * 1e16, 0, "zusd");
        vm.stopPrank();
        console2.log("user B collateral ratio after repay =", vault.returnLastCollateralRatio(b));

        vm.startPrank(c);
        vault.repayAndWithdraw(16 * 1e16, 0, "zusd");
        vm.stopPrank();
        console2.log("user C collateral ratio after repay =", vault.returnLastCollateralRatio(c));

        vm.startPrank(d);
        vault.repayAndWithdraw(16 * 1e16, 0, "zusd");
        vm.stopPrank();
        console2.log("user D collateral ratio after repay =", vault.returnLastCollateralRatio(d));

        vm.startPrank(e);
        vault.repayAndWithdraw(16 * 1e16, 0, "zusd");
        vm.stopPrank();
        console2.log("user E collateral ratio after repay =", vault.returnLastCollateralRatio(e));

    }

}
