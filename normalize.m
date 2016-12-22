function out = normalize(S)
	for i = 1:size(S,2)
		S(:, i) = histeq(S(:, i), 32);
	end
	
	out = S;
	%out = uint8(out);