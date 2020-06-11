

trait address{

    ghost var GlobalStorage? : map<nat, address>
    var balance: nat
    var msg: Message
    var block: Block

    method transfer(payer: address)
        requires this != payer
        modifies this, payer
        ensures balance == old(balance) + payer.balance 
        ensures payer.balance == 0 
        {
            balance := balance + payer.balance;
            payer.balance := 0;
        }
}


class Message {

    var sender: address
    var value: nat
    var data: nat

    constructor(send: address, val: nat)
        ensures sender == send && value == val
        {
            sender := send;
            value := val;
        }
}

class Block{

    var timestamp: nat
    var coinbase: address
    var difficulty: nat
    var gaslimit: nat
    var number: nat

    constructor()
}