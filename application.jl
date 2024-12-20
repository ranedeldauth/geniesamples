#
#   Basic integer parser
#   Copyright (C) 2024 Democritus University of Thrace
#   Licensed under MIT
#


print("My First Actual Julia Program\n");

x = parse(Int,readline());

if x > 0
    print("Positive number $x was given");
else
    (x == 0) ? print("Number zero was given") : print("Negative number $x was given");
end

print("\n");
