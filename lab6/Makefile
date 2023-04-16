ASM_FILES := $(wildcard *.asm)
OUTPUT := main.exe

run : $(ASM_FILES)
	dosbox-x -c "mount c $(PWD)" -c "c:" -c "ML.EXE *.asm /Fe $(OUTPUT)" -set lfn=true

clean :
	-$(RM) *.OBJ
