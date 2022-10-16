import { loadStdlib } from "@reach-sh/stdlib";
import * as backend from './build/index.main.mjs';
const stdlib = loadStdlib({REACH_NO_WARN: 'Y' })

const fmt = (amt, decimalAmt) => stdlib.formatCurrency(amt, decimalAmt);
const getBalance = async (who) => fmt(await stdlib.balanceOf(who), 3);

const startingBalance = stdlib.parseCurrency(1000);
const testAccA = await stdlib.newTestAccount(startingBalance);
const testAccB = await stdlib.newTestAccount(startingBalance);

const ctcUserA = testAccA.contract(backend);
const ctcUserB = testAccB.contract(backend, ctcUserA.getInfo());

const atomicBalanceUserA = await stdlib.balanceOf(testAccA);
const atomicBalanceUserB = await stdlib.balanceOf(testAccB)
const standardBalanceUserA = fmt(atomicBalanceUserA, 3);
const standardBalanceUserB = fmt(atomicBalanceUserB, 3);

console.log(atomicBalanceUserA,atomicBalanceUserB,
    standardBalanceUserA,standardBalanceUserB)
