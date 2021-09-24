const Volcano = artifacts.require("VolcanoCoin");
contract("Volcano", accounts => {
    it("should mint 10000 VolcanoCoin", async() => {
        const instance = await Volcano.deployed();
        const totalSupply = await instance.totalSupply.call();
        assert.equal(
            totalSupply.toNumber(),
            9999,
            "Minting Failed!"
        );
    });

    it("account 0xcB7C09fEF1a308143D9bf328F2C33f33FaA46bC2 should have zero balance", async() => {
        const instance = await Volcano.deployed();
        const balance = await instance.balanceOf("0xcB7C09fEF1a308143D9bf328F2C33f33FaA46bC2");
        assert.equal(
            balance.toNumber(),
            1,
            "balance is not zero!"
        );
    });

    it("Owner has balance of 10000 VolcanoCoin", async() => {
        const instance = await Volcano.deployed();
        const address = await instance.owner();
        const balance = await instance.balanceOf(address);
        assert.equal(
            balance.toNumber(),
            11000,
            "Owner balance should be 10000"
        );
    });
});
