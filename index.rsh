'reach 0.1'

const codeI = {
    getChallenge: Fun([], UInt),
    seeResult: Fun([UInt], Null),
}

const codeII = {
    ...hasRandom, 
    seePrice: Fun([], UInt),
    getDescription: Fun([], UInt) //should be a byte 
}

//backend code
export const main = Reach.App(() => {

    const Pat = Participant('Pat', {
        ...codeI
    })
    const Vanna = Participant('Vanna', {
       ...codeI 
    })

    const Creator = Participant('Creator', {
        ...codeII
    })
    const Bidder = Participant('Bidder', {
        ...codeII
    })
    const Buyer = Participant('Buyer', {
        ...codeII,
        price: UInt
    })
    init()

    Pat.only(() => {
         const challengePat = declassify(interact.getChallenge())
    })
    Pat.publish(challengePat);
    commit()
    Vanna.only(() => {
        const challengeVanna = declassify(interact.getChallenge())
    })
    Vanna.publish(challengeVanna);
    commit()
    Bidder.only(() => {
        const price = declassify(interact.seePrice())
    })
    Bidder.publish(price)
    commit()
    Buyer.only(() => {
        const description = declassify(interact.getDescription())
        const _payment = interact.seePrice()
        const [_commitBuyer, _saltBuyer] = makeCommitment(interact, _payment);
        const commitBuyer = declassify(_commitBuyer);
    })
    Buyer.publish(description, commitBuyer).pay(price)
    commit()

    Buyer.only(() => {
        const saltBuyer = declassify(_saltBuyer)
        const payment = declassify(_payment)
    })
    Buyer.publish(saltBuyer, payment)
    checkCommitment(commitBuyer, saltBuyer, payment)
});