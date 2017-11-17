test: build
	echo "Running ALU test bench"
	./alu
	echo -e "\n\nRunning memory test bench"
	./memory
	echo -e "\n\nRunning register file test bench"
	./registerFile
	echo -e "\n\nRunning CPU test bench"
	./cpu

build: alu.t.v alu.v cpu.t.v cpu.v memory.t.v memory.v registerFile.t.v registerFile.v
	iverilog alu.t.v -o alu
	iverilog cpu.t.v -o cpu
	iverilog memory.t.v -o memory
	iverilog registerFile.t.v -o registerFile

clean:
	rm alu cpu memory registerFile
