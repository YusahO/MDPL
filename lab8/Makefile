CC = g++

OUT_DIR = out
DIS_DIR = dis
SRC1 = main_1
SRC2 = main_2

.PHONY: clean

operations:
	$(CC) */$(SRC1).cpp -mno-80387 -O0 -o $(SRC1).exe
	./$(SRC1).exe

	$(CC) */$(SRC1).cpp -m80387 -O0 -o $(SRC1).exe
	./$(SRC1).exe

asm:
	$(CC) */$(SRC1).cpp -DASM -masm=intel -O0 -o $(SRC1).exe
	./$(SRC1).exe

main_1: oper asm

sin:
	$(CC) */$(SRC2).cpp -masm=intel -O0 -o $(SRC2).exe
	./$(SRC2).exe

disassemble:
	mkdir -p $(DIS_DIR)
	mkdir -p $(OUT_DIR)

	$(CC) -c */$(SRC1).cpp -mno-80387 -O0 -o $(OUT_DIR)/$(SRC1).o
	objdump -M intel-mnemonic -d $(OUT_DIR)/$(SRC1).o  > $(DIS_DIR)/$(SRC1)_m.txt

	$(CC) -c */$(SRC1).cpp -m80387 -O0 -o $(OUT_DIR)/$(SRC1).o
	objdump -M intel-mnemonic -d $(OUT_DIR)/$(SRC1).o  > $(DIS_DIR)/$(SRC1)_mno.txt

	$(CC) -c */$(SRC1).cpp -DASM -masm=intel -O0 -o $(OUT_DIR)/$(SRC1).o
	objdump -M intel-mnemonic -d $(OUT_DIR)/$(SRC1).o  > $(DIS_DIR)/$(SRC1)_asm.txt

clean:
	rm *.exe
	rm -r out dis
