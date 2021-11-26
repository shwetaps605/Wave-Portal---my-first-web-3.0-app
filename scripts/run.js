const main = async () => {
    const [owner, randomPerson] = await hre.ethers.getSigners();
    const waveContractFactory = await hre.ethers.getContractFactory('WavePortal');
    const waveContract = await waveContractFactory.deploy({
        value: hre.ethers.utils.parseEther('0.1')
    });
    await waveContract.deployed();
    console.log("Contract addy:", waveContract.address);
    console.log("Contract deployed by:",owner.address);

    let contractBalance = await hre.ethers.provider.getBalance(waveContract.address);
    console.log('Contract balance..',hre.ethers.utils.formatEther(contractBalance));

    let waveCount;
    waveCount = await waveContract.getTotalWaves();

    let waveTxn = await waveContract.wave('First wave');
    await waveTxn.wait()

    waveTxn = await waveContract.connect(randomPerson).wave('A random person waved at me');
    await waveTxn.wait();

    waveTxn = await waveContract.connect(randomPerson).wave('A random person waved at me for the second time');
    await waveTxn.wait();

    contractBalance = await hre.ethers.provider.getBalance(waveContract.address);
    console.log('Contract balance..',hre.ethers.utils.formatEther(contractBalance));

    let allWaves = await waveContract.getAllWaves();
    console.log(allWaves);

    
    waveCount = await waveContract.getTotalWaves();
    console.log(waveCount);

};

const runMain = async () => {
    try {
        await main();
        process.exit(0);
    } catch (error) {
        console.log(error);
        process.exit(1);
    }
};

runMain();