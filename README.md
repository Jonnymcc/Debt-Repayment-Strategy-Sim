Debt-Repayment-Strategy-Sim
===========================

Simulates various debt repayment strategies.

USAGE: loan_pymt_sim.pl 600

In the script there is a hash of lists...

our %loans = (
  loan1 => [1200, 0.068],
  loan2 => [2000, 0.0655],
  loan3 => [1000, 0.0235]);

The names of the loans can be whatever and there can be as many as you want. The first list element
is the balance/principal and the second element is the APR.

The first argument to the script is the size of the anticpated monthly payment. The script accounts
for accumulated interest calculating it as principal * APR / 12 months. It also accounts for loans
that would be overpayed in a given month by checking for the next best loan using the given strategy
and apply the remainder of the payment to that loan. The script also assumes that the total payment
is made to one loan and doesn't account for minimum required payments.

I've recently seen on forums debates about what is the best approach to paying off loans. There seems
to be mainly two groups. One group thinks the debt snowball or paying the lowest balance first is best.
The other says that paying the one with the highest APR is best. Even though Dave Ramsey acknowledges
the math behind paying the one with the highest APR first he still believes the debt snowball is best
believing that paying off debt is partly a mind game.


Spoilers: Paying the loan with the highest APR will save more money on interest payed (duh) and also
pays off the total debt in less time (provided payments are consistent).
