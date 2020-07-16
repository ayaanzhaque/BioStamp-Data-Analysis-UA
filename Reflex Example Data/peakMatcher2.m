function matchedPeaks = peakMatcher2(hammerTime, responseTime)
foo = 2;
a = [1 2 3];
matchedPeaks(foo,1) = a(1);
matchedPeaks(foo,2) = a(2);
matchedPeaks(foo,3) = a(3);


for i=1:(length(hammerTime))

for j = foo:(length(responseTime))
   if responseTime(j) < (hammerTime(i) + 1) && responseTime(j) > hammerTime(i)
            matchedPeaks(foo,1) = hammerTime(i);
            matchedPeaks(foo,2) = responseTime(j);
            matchedPeaks(foo,3) = responseTime(j)-hammerTime(i);
            foo = foo +1;
   end
end


end

end











