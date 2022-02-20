const { expect } = require("chai");
const { ethers } = require("hardhat");
const { default: Web3 } = require("web3");

describe("Mint testings", function () {
  it("Mint a single GA", async function () {
    const [owner] = await ethers.getSigners();

    const OpenEvents = await hre.ethers.getContractFactory("OpenEvents");
    const openEvents = await OpenEvents.deploy();

    await openEvents.deployed();

    console.log("OpenEvents deployed to:", openEvents.address);
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

    await openEvents.buyTicket({ value: hre.ethers.utils.parseEther("0.1") });
    await openEvents.buyTicket({ value: hre.ethers.utils.parseEther("1") });
  });
  it("Mint VIP", async function () {
    const [owner] = await ethers.getSigners();

    const OpenEvents = await hre.ethers.getContractFactory("OpenEvents");
    const openEvents = await OpenEvents.deploy();

    await openEvents.deployed();

    console.log("OpenEvents deployed to:", openEvents.address);
    await openEvents.addVIPPackage(
      0,
      hre.ethers.utils.parseEther("0.33"),
      40,
      0,
      true,
      true
    );

    await openEvents.buyVIPTicket({
      value: hre.ethers.utils.parseEther("0.1"),
    });
  });
});
