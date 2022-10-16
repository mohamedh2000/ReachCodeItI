'reach 0.1'

const codeI = {
    getChallenge: Fun([], UInt),
    seeResult: Fun([UInt], Null),
}

const codeII = {
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
        ...codeII
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
        const payment = declassify(interact.seePrice())
    })
    Buyer.publish(description, payment).pay(payment)
    commit()

});