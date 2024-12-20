#
#   Power of two caculator
#   Copyright (C) 2024 Democritus University of Thrace
#   Licensed under MIT
#

print("A power of two calculator\n");
global temp = 0;

print("Give how many values of two you want calculated: ");
limit=parse(Int, readline());

while(temp <= limit)
twopow = 1;

for i in 0:temp
    if i != 0
        twopow = twopow * 2;
    end
end

print("The power of two in $temp is $twopow\n");

global temp = temp + 1;
end
