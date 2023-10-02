async function main() {
    const tokenAdress = {
        sepolia: "0x6C2292d81F2C7874b75f568dDB439F116EBb8539",
        arbitrumGoerli: "0xC013B4D14f7Ac620c6254cBa29D079744Bf32778",
        polygonMumbai: "0x0ed07840b45fdBbf498AE669c894B81a81E1cE24"
    }

    const daoName = {
        sepolia: "WW Sepolia DAO",
        arbitrumGoerli: "WW Arbitrum Goerli DAO",
        polygonMumbai: "WW Polygon Mumbai DAO"
    }
  
    const MyGovernor = await hre.ethers.getContractFactory("WonderlandWanderersDao");
    const myGovernor = await MyGovernor.deploy(tokenAdress.polygonMumbai, daoName.polygonMumbai);
    await myGovernor.waitForDeployment();
  
    const governorAddress = myGovernor.target;
  
    console.log(`Governor deployed to ${governorAddress}`);
  
    const countdownTime = 20; // in seconds
  
    console.log(`Waiting for ${countdownTime} seconds before verifying contract...`);
  
    for (let i = countdownTime; i > 0; i--) {
        process.stdout.write(`\rTime remaining: ${i} seconds`);
        await new Promise(resolve => setTimeout(resolve, 1000));
    }
  
    console.log(`\nCountdown complete! verifying ${governorAddress} contracts...`);
  
    await hre.run("verify:verify", { address: governorAddress, constructorArguments: [tokenAdress.polygonMumbai, daoName.polygonMumbai]});
  }
  
  main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
  });