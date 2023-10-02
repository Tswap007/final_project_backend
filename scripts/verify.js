async function main() {
    const address = "0x6C2292d81F2C7874b75f568dDB439F116EBb8539"
  
    await hre.run("verify:verify", { address: address });
  }
  
  main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
  });