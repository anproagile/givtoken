const { expect } = require('chai')
const { ethers } = require('hardhat')

describe("GivPaymentSplitter Tests", function () {
    let deployer
    let account1  // Token Reward holder
    let account2  // Charity Pool address
    let account3  // Consider second charity pool in some case
    let givingToken
    let charityPool
    beforeEach(async () => {
        [deployer, account1, account2, account3] = await ethers.getSigners()
        const GivingToken = await ethers.getContractFactory('ERC20PresetMinterPauser')
        givingToken = await GivingToken.deploy('GivingToken', 'GIV')
        await givingToken.deployed()
    });
    describe('Add payees with varying amounts and distribute payments', async () => {})

    it('payment token is distributed evenly to multiple payees', async () => {
        payeeAddressArray = [account1.address, account2.address, account3.address]
        payeeShareArray = [5, 5, 0]
        const CharityPool = await ethers.getContractFactory('CharityPool')
        charityPool = await CharityPool.deploy(
            payeeAddressArray,
            payeeShareArray,
            testPaymentToken.address
        )
        await charityPool.deployed()
        await givingToken.mint(charityPool.address, 100000)
        await charityPool
            .connect(account1)
            .release(account1.address)
        await charityPool
            .connect(account2)
            .release(account2.address)
        await charityPool
            .connect(account3)
            .release(account3.address)
        const account1TokenBalance = await givingToken.balanceOf(account1.address)
        const account2TokenBalance = await givingToken.balanceOf(account2.address)
        const account3TokenBalance = await givingToken.balanceOf(account3.address)
        expect(account1TokenBalance).to.equal(5000)
        expect(account2TokenBalance).to.equal(5000)
        expect(account3TokenBalance).to.equal(0)
    })


    it('payment token is distributed unevenly to multiple payees', async () => {
        payeeAddressArray = [account1.address, account2.address, account3.address]
        payeeShareArray = [5, 5, 0]
        const charityPool = await ethers.getContractFactory('charityPool')
        charityPool = await CharityPool.deploy(
            payeeAddressArray,
            payeeShareArray,
            givingToken.address
        )
        await charityPool.deployed()
        await givingToken.mint(charityPool.address, 100000)
        await charityPool
            .connect(account1)
            .release(account1.address)
        await charityPool
            .connect(account2)
            .release(account2.address)
        await charityPool
            .connect(account3)
            .release(account3.address)
        const charityPoolGivingTokenBalance = await givingToken.balanceOf(
            charityPool.address
        )
        const account1TokenBalance = await givingToken.balanceOf(account1.address)
        const account2TokenBalance = await givingToken.balanceOf(account2.address)
        const account3TokenBalance = await givingToken.balanceOf(account3.address)
        expect(charityPoolGivingTokenBalance).to.equal(1)
        expect(account1TokenBalance).to.equal(30303)
        expect(account2TokenBalance).to.equal(15151)
        expect(account3TokenBalance).to.equal(33333)
    })


    it('payment token is distributed to multiple payees with additional payment token sent to pool', async () => {
    payeeAddressArray = [account1.address, account2.address, account3.address]
    payeeShareArray = [10, 5, 5]
    const CharityPool = await ethers.getContractFactory('CharityPool')
    charityPool = await CharityPool.deploy(
        payeeAddressArray,
        payeeShareArray,
        givingToken.address
    )
    await charityPool.deployed()
    await givingToken.mint(charityPool.address, 100000)
    await charityPool
        .connect(account1)
        .release(account1.address)
    await charityPool
        .connect(account2)
        .release(account2.address)
    await givingToken.mint(mockPool.address, 100000)
    await charityPool
        .connect(account3)
        .release(account3.address)
    await charityPool
        .connect(account1)
        .release(account1.address)
    await charityPool
        .connect(account2)
        .release(account2.address)
    const charityPoolGivingTokenBalance = await givingToken.balanceOf(
        charityPool.address
            )
    const account1TokenBalance = await givingToken.balanceOf(account1.address)
    const account2TokenBalance = await givingToken.balanceOf(account2.address)
    const account3TokenBalance = await givingToken.balanceOf(account3.address)
    expect(charityPoolGivingTokenBalance).to.equal(1)
    expect(account1TokenBalance).to.equal(60606)
    expect(account2TokenBalance).to.equal(30303)
    expect(account3TokenBalance).to.equal(66666)
})


});


