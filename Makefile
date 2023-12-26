all:
	# gcc -c -o ./fftw/fftw_lib.o ./fftw/fftw_lib.c -lfftw3f -lm
	gcc -c -o ./fftw/fftw_lib.o ./fftw/fftw_lib.c
	odin build . -out:fftw_main.exe	-extra-linker-flags:"-lfftw3f -lm"
	
clean:
	rm ./fftw/*.o ./*.exe

run:
	./fftw_main.exe


c_all:
	gcc -offtw_test.exe fftw_test.c -lfftw3f -lm

c_clean:
	rm *.o *.exe

c_run:
	./fftw_test.exe


