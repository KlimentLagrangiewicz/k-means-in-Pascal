unit kmeans;


interface
	
	type
		realArray = array of real;
		intArray = array of integer;
		realMatrix = array of realArray;

	function get_distance(const x, y: realArray): real;
	procedure scaling(var x: realMatrix; const n, m: integer);
	procedure k_means(const _x: realMatrix; y: intArray; const n, m, k: integer);

implementation

	uses sysutils;
	
	function get_distance(const x, y: realArray): real;
	var
		i: integer;
		d, s: real;
	begin
		s := 0.0;
		for i := low(x) to high(x) do
		begin
			d := x[i] - y[i];
			s := s + d * d;
		end;
		get_distance := sqrt(s);
	end;
	
	procedure scaling(var x: realMatrix; const n, m: integer);
	var
		i, j: integer;
		exx, ex: real;
	begin
		for j := 0 to m-1 do
		begin
			ex := 0.0;
			exx := 0.0;
			for i := 0 to n-1 do
			begin
				ex := ex + x[i][j];
				exx := exx + x[i][j] * x[i][j];
			end;
			ex := ex / n;
			exx := exx / n - ex * ex;
			if exx <= 0.0 then exx := 1.0
			else exx := 1.0 / sqrt(exx);
			for i := 0 to n-1 do
				x[i][j] := (x[i][j] - ex) * exx;
		end;
	end;
	
	function not_constr(const x: intArray; const val: integer; s: integer): boolean;
	var
		flag: boolean;
	begin
		flag := true;
		while (s > 0) and flag do
			if x[s - 1] = val then flag := false
			else dec(s);
		not_constr := flag;
	end;
	
	procedure realcpy(var x: realArray; const y: realArray);
	var
		i: integer;
	begin
		for i := low(y) to high(y) do
			x[i] := y[i];
	end;
		
	function det_cores(const x: realMatrix; const n, m, k: integer): realMatrix;
	var
		hr, min, sec, ms: Word;
		i, number: integer;
		nums: intArray;
		res: realMatrix;
	begin
		decodeTime(Time, hr, min, sec, ms);
		randseed := ms;
		setLength(nums, k);
		nums[0] := random(k);
		for i := 1 to k-1 do
		begin
			repeat number := random(n);
			until not_constr(nums, number, i);
			nums[i] := number;
		end;
		setLength(res, k);
		for i := 0 to k-1 do
		begin
			setLength(res[i], m);
			realcpy(res[i], x[nums[i]]);
		end;
		det_cores := res;
	end;
	
	
	function get_cluster(x: realArray; const c: realMatrix; const m, k: integer): integer;
	var
		i, res: integer;
		cur, min: real;
	begin
		res := 0;
		min := get_distance(x, c[0]);
		for i := 1 to k-1 do
		begin
			cur := get_distance(x, c[i]);
			if (cur < min) then
			begin
				min := cur;
				res := i;
			end;
		end;
		get_cluster := res;
	end;
	
	procedure iasz(var x: intArray);
	var
		i: integer;
	begin
		for i := low(x) to high(x) do
			x[i] := 0;
	end;
	
	procedure fasz(var x: realArray);
	var
		i: integer;
	begin
		for i := low(x) to high(x) do
			x[i] := 0.0;
	end;
		
	procedure det_start_partition(const x, c: realMatrix; y, nums: intArray; const n, m, k: integer);
	var
		i, l: integer;
	begin
		iasz(nums);
		for i := 0 to n-1 do
		begin
			l := get_cluster(x[i], c, m, k);
			y[i] := l;
			inc(nums[l]);
		end;
	end;
	
	procedure calc_cores(const x: realMatrix; c: realMatrix; const y, nums: intArray; const n, m, k: integer);
	var
		i, j, f: integer;
	begin
		for i := 0 to k-1 do
			fasz(c[i]);
		for i := 0 to n-1 do
		begin
			f := y[i];
			for j := 0 to m-1 do
				c[f][j] := c[f][j] + x[i][j];
		end;
		for i := 0 to k-1 do
		begin
			f := nums[i];
			for j := 0 to m-1 do
				c[i][j] := c[i][j] / f;
		end;
	end;
	
	function check_partition(const x: realMatrix; c: realMatrix; y, nums: intArray; const n, m, k: integer): boolean;
	var
		i, l: integer;
		flag: boolean;
	begin
		calc_cores(x, c, y, nums, n, m, k);
		iasz(nums);
		flag := true;
		for i := 0 to n-1 do
		begin
			l := get_cluster(x[i], c, m, k);
			if (y[i] <> l) then flag := false;
			y[i] := l;
			inc(nums[l]);
		end;
		check_partition := flag;	
	end;
	
	procedure k_means(const _x: realMatrix; y: intArray; const n, m, k: integer);
	var
		i: integer;
		flag: boolean;
		x, c: realMatrix;
		nums: intArray;
	begin
		setLength(x, n);
		for i := 0 to n-1 do
		begin
			setLength(x[i], m);
			realcpy(x[i], _x[i]);
		end;
		scaling(x, n, m);
		c := det_cores(x, n, m, k);
		setLength(nums, k);
		det_start_partition(x, c, y, nums, n, m, k);
		repeat flag := check_partition(x, c, y, nums, n, m, k);
		until flag;
	end;

end.
