#! /usr/bin/perl
use warnings;
use strict;
use feature qw/switch/;

my $payment = 600;
if (@ARGV) { $payment = $ARGV[0]}
print "Payment = $payment\n\n";

my $verbose=0;

sub main {
    our $method = shift;

    given($method) {
        when (0) {print "Largest monthly accrued interest...\n"}
        when (1) {print "Highest APR...\n"}
        when (2) {print "Lowest balance...\n"}
    }

    our %loans = (
        loan1 => [2000, 0.068],
        loan2 => [1200, 0.0655],
        loan3 => [1500, 0.0235]);

    our $payed = 0;
    our $pay_this;
    my $months_to_pay = 0;
    my $balance = 0;
    for (keys %loans) {
        $balance += $loans{$_}[0];    
    }
    my $principal = $balance;

    sub get_loan {
        use Math::BigFloat;
        my $pay_this;
        my $biggest = 0;
        my $highest_apr = 0;
        my $lowest = Math::BigFloat->binf;
        for my $l (keys %loans) {
            if ($method == 0 && $loans{$l}[0] > 0 && $loans{$l}[0] * $loans{$l}[1] >= $biggest) {
                print "$l is the best, " . sprintf("%.2f", ($loans{$l}[0] * $loans{$l}[1])) . " is greater than $biggest\n" if $verbose;
                $biggest = $loans{$l}[0] * $loans{$l}[1];
                $pay_this = $l;
            } elsif ($method == 1 && $loans{$l}[0] > 0 && $loans{$l}[1] > $highest_apr) {
                print "$l is the best, $loans{$l}[1] is greater than $highest_apr\n" if $verbose;
                $highest_apr = $loans{$l}[1];
                $pay_this = $l;
            } elsif ($method == 2 && ($loans{$l}[0] <= $lowest) && $loans{$l}[0] > 0) {
                print "$l is the best, $loans{$l}[0] is less than $lowest\n" if $verbose;
                $lowest = $loans{$l}[0];
                $pay_this = $l;
            } elsif ($loans{$l}[0] <= 0) {
                print "$l is paid off!\n" if $verbose;
            } else {
                print "$l is not a good choice\n" if $verbose;
            }
        }
        return $pay_this;
    }

    # How to pay a loan.
    sub pay_it {
        my $payment = shift;
        $loans{$pay_this}[0] -= $payment;

        # Print running balances...
        #for (keys %loans) {
        #    print "$_  " . sprintf("%.2f", $loans{$_}[0]) . "\n";
        #}   

        if ( $loans{$pay_this}[0] <= 0 ) { # Handle event that the loan is overpayed.
            my $left_over = $loans{$pay_this}[0];
            print "paid " . sprintf("%.2f", $payment + $left_over) . " to $pay_this\n";
            print "left over from payment = " . sprintf("%.2f", -$left_over) . "\n";
            $payed += $payment + $left_over;

            $loans{$pay_this}[0] = 0; # Set balance to zero
            $loans{$pay_this}[1] = 0; # Set interest rate to zero

            $pay_this = get_loan($method); # Get next loan to pay...
            
            return if not $pay_this; # No loans left to pay!

            pay_it(-$left_over);
            
        } else {
            print "paid $payment to $pay_this\n";
            $payed += $payment;
        }
    }
    
    while ($balance > 0) {
        print "month = $months_to_pay\n";

        $pay_this = get_loan(); # Get the best loan to pay.
        if ($pay_this eq '') {exit;} # There is nothing left to pay.
        
        print "Paying $pay_this\n";
        pay_it($payment);

        # We've payed another month...
        $months_to_pay++;
    
        # Add interest to the loans...
        for (keys %loans) {
            $loans{$_}[0] += sprintf("%.2f", $loans{$_}[0] * $loans{$_}[1] /12);
            print "$_  " . sprintf("%.2f", $loans{$_}[0]) . "\n" if $verbose; # Running balances.
        }   
        
        # Get the new total balance...
        $balance = 0;
        for (keys %loans) {
            $balance += $loans{$_}[0];    
        }
    }
    
    print "Principal = $principal\n";
    print "Months payed = $months_to_pay\n";
    print "Years payed = " .              sprintf("%.2f", $months_to_pay/12) . "\n";
    print "Amount payed = " .             sprintf("%.2f", $payed) . "\n";
    print "Amount payed to interest = " . sprintf("%.2f", ($payed - $principal)) . "\n\n";
}

main(0);
main(1);
main(2);
