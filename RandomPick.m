function BestMatch = RandomPick(matches)
    index = find(matches);
    BestMatch = index(floor(rand() * length(index))+1); 
end