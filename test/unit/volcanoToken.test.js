
/**
 * 
 * autogenerated by solidity-visual-auditor
 * 
 * execute with: 
 *  #> truffle test <path/to/this/test.js>
 * 
 * */
const { expectRevert } = require('@openzeppelin/test-helpers');
const VolcanoToken = artifacts.require("VolcanoToken");

contract('VolcanoToken', (accounts) => {
    /* random address to check transfer */
    var unprivilegedAddress = accounts[4]
    /* create named accounts for contract roles */

    before(async () => {
        /* before tests */
        volcanoTokenInstance = await VolcanoToken.deployed();
    })
    
    it("Burnt token can not be transferred!", async() => {
        const owner = await volcanoTokenInstance.owner();
        await volcanoTokenInstance.mintToken();
        /* the token minted is 1 */
        /* this can be tested with some random token number that is not alredy minted(non existing) */
        const tokenId = 1;
        await volcanoTokenInstance.burnToken(tokenId);
        /* verify the burnt token can be transferred */
        await expectRevert(volcanoTokenInstance.safeTransferFrom(owner, unprivilegedAddress, tokenId), "ERC721: operator query for nonexistent token");
        //await expectRevert.unspecified(volcanoTokenInstance.safeTransferFrom(owner, unprivilegedAddress, tokenId));
    });
});