unit help;



interface

	uses sysutils;
	
	type
		realArray = array of real;
		intArray = array of integer;
		realMatrix = array of realArray;

	procedure fscanf_data(const filename: string; x: realMatrix; const n, m: integer);
	procedure printf_res(const filename: string; y: intArray; const n: integer);
	procedure fscanf_partition(const filename: string; x: intArray; const n: integer);
	function get_precision(x, y: intArray): real;
	procedure printf_full_res(const filename: string; y: intArray; const n: integer; const p: real);


implementation

	procedure fscanf_data(const filename: string; x: realMatrix; const n, m: integer);
	var
		myfile: TextFile;
		i, j: integer;
	begin
		assign(myfile, filename);
		fileMode := fmOpenRead;
		reset(myfile);
		i := 0;
		while (i < n) and not eof(myFile) do
		begin
			j := 0;
			while (j < m) and not eof(myfile) do
			begin
				read(myfile, x[i][j]);
				inc(j);
			end;
			inc(i);
		end;
		close(myFile);
	end;


	procedure printf_res(const filename: string; y: intArray; const n: integer);
	var
		myfile: TextFile;
		i: integer;
	begin
		assign(myfile, filename);
		fileMode := fmOpenWrite;
		if (FileExists(filename)) then
		append(myfile)
		else Rewrite(myfile);
		writeln(myfile, 'Result of clustering using k-means');
		for i := low(y) to high(y) do
		begin
			writeln(myfile, format('Object[%d] = [%d]',[i + 1, y[i]]));
		end;
		writeln(myfile);
		close(myfile);
	end;


	procedure fscanf_partition(const filename: string; x: intArray; const n: integer);
	var
		myfile: TextFile;
		i: integer;
	begin
		assign(myfile, filename);
		fileMode := fmOpenRead;
		reset(myfile);
		i := 0;
		while (i < n) and not eof(myFile) do
		begin
			read(myfile, x[i]);
			inc(i);
		end;
		close(myFile);
	end;


	function get_precision(x, y: intArray): real;
	var
		i, j, n: integer;
		yy, yn: int64;
	begin
		yy := 0;
		yn := 0;
		n := high(x);
		for i := 0 to n do
		begin
			for j := i+1 to n do
			begin
				if ((x[i] = x[j]) and (y[i] = y[j])) then inc(yy);
				if ((x[i] <> x[j]) and (y[i] = y[j])) then inc(yn);
			
			end;
		end;
		get_precision := yy / (yy + yn);
	end;


	procedure printf_full_res(const filename: string; y: intArray; const n: integer; const p: real);
	var
		myfile: TextFile;
		i: integer;
	begin
		assign(myfile, filename);
		fileMode := fmOpenWrite;
		if (FileExists(filename)) then
		append(myfile)
		else Rewrite(myfile);
		writeln(myfile, 'Result of clustering using k-means');
		writeln(myfile, format('precision = %f',[p]));
		for i := low(y) to high(y) do
		begin
			writeln(myfile, format('Object[%d] = [%d]',[i + 1, y[i]]));
		end;
		writeln(myfile);
		close(myfile);
	end;
end.