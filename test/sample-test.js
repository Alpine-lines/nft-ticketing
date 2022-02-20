const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Mint testings", function () {
  it("Mint a single token", async function () {
    const [owner] = await ethers.getSigners();

    const OpenEvents = await hre.ethers.getContractFactory("OpenEvents");
    const openEvents = await OpenEvents.deploy();
  
    await openEvents.deployed();
  
    console.log("OpenEvents deployed to:", openEvents.address);
    await openEvents.createEvent("Jetgang", 1645323000, true, true, hre.ethers.utils.parseEther('0.1'), 200, false, '')

    await openEvents.buyTicket({value:hre.ethers.utils.parseEther('0.1')})
    await openEvents.buyTicket({value:hre.ethers.utils.parseEther('1')})

  });
});
