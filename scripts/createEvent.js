const hre = require("hardhat");

const EVENTS_ADDRESS = '0x5FbDB2315678afecb367f032d93F642f64180aa3'
async function main() {

    const openEvents = await hre.ethers.getContractAt("OpenEvents",
    EVENTS_ADDRESS
    );

    await openEvents.createEvent(
        "Jet Gang NFT Benifit Concert Series | EthDenver",
        1645412400,
        false,
        true,
        hre.ethers.utils.parseEther('0.175'),
        400,
        true,
        "ipfs://QmYZwj6SK5nyJfzNxs6i29uFCkF7yCsdTnKunz7MF7uDmi"
    )

    await openEvents.addVIPPackage(
      0, hre.ethers.utils.parseEther('0.33'), 40, 0, true, true
    );

}


main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
