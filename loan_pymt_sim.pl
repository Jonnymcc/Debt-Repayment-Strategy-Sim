#! /usr/bin/perl
use warnings;
use strict;
use feature qw/switch/;

my $payment = 600;
if (@ARGV) { $payment = $ARGV[0]}
print "Payment = $payment\n\n";

sub main {
    our $method = shift;

    given($method) {
        when (0) {print "Largest monthly accrued interest...\n"}
        when (1) {print "Highest APR...\n"}
        when (2) {print "Lowest balance...\n"}
    }

    our %loans = (
        loan1 => [1000, 0.068],
        loan2 => [1200, 0.0655],
        loan3 => [1500, 0.0235]);

    our $payed = 0;
    my $months_to_pay = 0;
    my $balance = 0;
    for (keys %loans) {
        $balance += $loans{$_}[0];    
    }
    my $principal = $balance;
    
    while ($balance > 0) {
    #for (my $x=0; $x<10; $x++) {
        print "month = $months_to_pay\n";
        
        our $pay_this;
    
        sub get_loan {
            my $method = shift;
            my $pay_this;
            my $biggest = 0;
            my $highest_apr = 0;
            my $lowest = 1000000000;
            for my $l (keys %loans) {
                #print "$l is " . $loans{$l}[0] * $loans{$l}[1] . " greater than or equal to " . $biggest . " with APR $loans{$l}[1]\t\t";
                if ($method == 0 && $loans{$l}[0] > 0 && $loans{$l}[0] * $loans{$l}[1] >= $biggest) {
                    #print "yes\n";
                    $biggest = $loans{$l}[0] * $loans{$l}[1];
                    $pay_this = $l;
                } elsif ($method == 1 && $loans{$l}[0] > 0 && $loans{$l}[1] > $highest_apr) {
                    #print "yes\n";
                    $highest_apr = $loans{$l}[1];
                    $pay_this = $l;
                } elsif ($method == 2 && $loans{$l}[0] <= $lowest && $loans{$l}[0] > 0) {
                    #print "yes\n";
                    $lowest = $loans{$l}[0];
                    $pay_this = $l;
                } else {
                    #print "no\n";
                }
                #print "\n";
            
            }
            return $pay_this;
        }

        $pay_this = get_loan($method);
        if ($pay_this eq '') {exit;}
        
        #print "Paying $pay_this\n";
        sub pay_it {
            my $payment = shift;
            $loans{$pay_this}[0] -= $payment;

            for (keys %loans) {
                #print "$_  $loans{$_}[0]\n";
            }   

            if ( $loans{$pay_this}[0] <= 0 ) {
                my $left_over = $loans{$pay_this}[0];
                print "paid " . ($payment + $loans{$pay_this}[0]) . " to $pay_this\n";
                print "left over from payment = " . -$left_over . "\n";
                $payed += $payment + $loans{$pay_this}[0];
                $loans{$pay_this}[0] = 0;
                $loans{$pay_this}[1] = 0;
                $pay_this = get_loan($method);
                if (!$pay_this) {
                    #print "paid $payment\n";
                    #$payed += $payment;
                    return;
                }
                pay_it(-$left_over);
                
            } else {
                print "paid $payment to $pay_this\n";
                $payed += $payment;
            }
        }
        
        pay_it($payment);

        $months_to_pay++;
    
        for (keys %loans) {
            $loans{$_}[0] += sprintf("%.2f", $loans{$_}[0] * $loans{$_}[1] /12);
        #    print "$_  $loans{$_}[0]\n";
        }   
        
        $balance = 0;
        for (keys %loans) {
            $balance += $loans{$_}[0];    
        }
        #print "\n";
    }
    
    print "Principal = $principal\n";
    print "Months payed = $months_to_pay\n";
    print "Years payed = " . $months_to_pay/12 . "\n";
    print "Amount payed = $payed\n";
    print "Amount payed to interest = " . ($payed - $principal) . "\n\n";
}

main(0);
main(1);
main(2);
