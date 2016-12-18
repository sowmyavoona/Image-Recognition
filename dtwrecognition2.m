function [out] = dtwrecognition2(path1, nc, ts, ext, nstr, nsts, out, tdb1, tdb, width, height)
	tot = 0;
	ret = 0;

	for i = 1:nc*nsts
		Test_Image = tdb1(:, i);
		test_image = tdb(:, i);
%		Test_Image = reshape(Test_Image, height1, width1);
		test_image = reshape(test_image, height, width);
		subplot('Position', [0.25 0.5 0.2 0.2]);
		imshow(uint8(test_image));
		xlabel(strcat('TEST IMAGE:', num2str(ceil(i/nsts))));
		alldist = [];
		
		parfor j = 1:nc*nstr
			Ori_Img = out(:, j);
%			Ori_Img = reshape(Ori_Img, height1, width1);
			dist = dtw(Test_Image, Ori_Img);
			alldist = [alldist dist];
		end
	
		[dist_min , Recognized_index] = min(alldist);
		s1 = ceil(Recognized_index/nstr);
		subplot('Position', [0.5 0.5 0.2 0.2]);
		imshow(strcat(path1, '/(', num2str(s1), ')/(1)', ext));
		xlabel(strcat(' FOUND IMAGE : ', num2str(s1)));
		ret = s1;
%		subplot('Position', [0.2 0.5 0.2 0.2]);
%		imshow(Test_Image);
%		xlabel(strcat(' TEST IMAGE : ', num2str(i))); 
		k = ceil(i/nsts);
		
		if(ret == k)
			tot = tot + 1;
		end
		drawnow   
	end
	out = tot;
