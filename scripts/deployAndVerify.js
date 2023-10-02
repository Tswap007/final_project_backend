async function main() {
  const ww = await hre.ethers.deployContract("WonderlandWanderers");

  await ww.waitForDeployment();

  const wwAdress = ww.target;

  console.log(`Contract deployed to ${wwAdress}`);

  const countdownTime = 20; // in seconds

  console.log(`Waiting for ${countdownTime} seconds before verifying contracts...`);

  for (let i = countdownTime; i > 0; i--) {
      process.stdout.write(`\rTime remaining: ${i} seconds`);
      await new Promise(resolve => setTimeout(resolve, 1000));
  }

  console.log(`\nCountdown complete! verifying ${wwAdress} contracts...`);

  await hre.run("verify:verify", { address: wwAdress });
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
