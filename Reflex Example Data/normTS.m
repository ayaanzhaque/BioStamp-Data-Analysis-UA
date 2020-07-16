function newTS= normTS(oldTS, TS0)

TSmat = oldTS;
for i = 1:length(TSmat)
newTS(i) = (TSmat(i)-TS0)/1000;
end
end