async function main() {
  const ww = await hre.ethers.deployContract("WonderlandWanderers");

  await ww.waitForDeployment();

  console.log(
    `Contract deployed to ${ww.target}`
  );
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
