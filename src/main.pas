program based;

uses sysutils, kmeans, help;

var
	y, yideal: intArray;
	x: realMatrix;
	i, n, m, k: integer;
	p: real;
	inputfile, outputfile, ideal: string;

begin
	if ParamCount < 5 then
		writeln('Not enough parameters')
	else	
	begin
		inputfile := ParamStr(1);
		n := StrToInt(ParamStr(2));
		m := StrToInt(ParamStr(3));
		k := StrToInt(ParamStr(4));
		outputfile := ParamStr(5);
		if ((n < 1) or (m < 1) or (k < 1) or (k > n)) then
		begin
			writeln('Values of input parameters are incorrect');
			exit;
		end;
		setLength(y, n);
		setLength(x, n);
		for i := 0 to n-1 do
			setLength(x[i], m);
		fscanf_data(inputfile, x, n, m);
		k_means(x, y, n, m, k);
		if (ParamCount > 5) then
		begin
			ideal := ParamStr(6);
			setLength(yideal, n);
			fscanf_partition(ideal, yideal, n);
			p := get_precision(yideal, y);
			writeln('Precision of clustering using k-means = ' + FloatToStr(p));
			printf_full_res(outputfile, y, n, p);
		end	
		else
		begin
			printf_res(outputfile, y, n);
			writeln('The work of the program is completed');
		end;
	end;
end.