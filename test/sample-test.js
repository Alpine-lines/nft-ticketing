const { expect } = require("chai");
const { ethers } = require("hardhat");
const { default: Web3 } = require("web3");

describe("Mint testings", function () {
  var openEvents;
  var accounts;

  beforeEach(async function () {
    const OpenEvents = await hre.ethers.getContractFactory("OpenEvents");
    openEvents = await OpenEvents.deploy();

    await openEvents.deployed();

    console.log("OpenEvents deployed to:", openEvents.address);

    accounts = await hre.ethers.getSigners();

    console.log(accounts[4].address);

    await openEvents.createEvent(
      "Jetgang",
      1646323000,
      true,
      true,
      hre.ethers.utils.parseEther("0.1"),
      200,
      false,
      ""
    );

    await openEvents.setEventAdmin(accounts[4].address, 0);
  });
  it("Mint a single GA", async function () {
    await openEvents.buyTicket({ value: hre.ethers.utils.parseEther("0.1") });
    await openEvents.buyTicket({ value: hre.ethers.utils.parseEther("1") });
  });
  it("Mint VIP", async function () {
    await openEvents.addVIPPackage(
      0,
      hre.ethers.utils.parseEther("0.33"),
      40,
      0,
      true,
      true
    );

    await openEvents.buyVIPTicket({
      value: hre.ethers.utils.parseEther("0.33"),
    });
  });
  it("Redeems the tickets", async function () {
    await openEvents.redeemTicket(0, 0, { from: accounts[4].address });
  });
});
