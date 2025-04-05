const hre = require("hardhat");

async function main() {
  console.log("Deploying VotingSystem contract...");
  
  const VotingSystem = await hre.ethers.getContractFactory("VotingSystem");
  const voting = await VotingSystem.deploy();
  
  // For ethers v6:
  await voting.waitForDeployment();
  
  console.log("VotingSystem deployed to:", voting.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});