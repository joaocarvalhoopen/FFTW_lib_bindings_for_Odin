// File         : fftw_lib.c  - The file that generates the .o object file.
//
// Project name : FFTW lib bindings for Odin.
// Description  : These are bindings to the FFTW library - The Fastest Fourier
//                Transform in the West, so you can do FFT's and Inverse FFT's on 
//                f32 buffers. FFTW also allows for calculation of FFT on f64,
//                but I didn't mapped it, it has to be linked with a different
//                version of the library, that also comes with the Linux version
//                that one installs with the package manager.
//                The FFTW library is a C library, so this binding
//                is a C binding. The FFTW library is a very fast FFT, also
//                popular library and it is very easy to use.
//                These bindings also use GCC to compile the .o obj file.
//
// License      : My code is MIT Open Source license, but the FFTW library has
//                it's own license. So usage must be in accordance with the FFTW
//                license.
// Author       : João Carvalho
// Date         : 2023.12.26
//

#include <fftw3.h>
// #include <stdio.h>
// #include <stdlib.h>
// #include <math.h>
// #include <stdint.h>
// #include <stdbool.h>

// Allocates the memory for the in and out arrays for the fftw plan.
fftwf_complex * od_fftwf_malloc( int n_samples ) {
    fftwf_complex *buf;
    buf  = ( fftwf_complex * ) fftwf_malloc( sizeof( fftwf_complex ) * n_samples );
    return buf;
}

// Frees the memory for the "in" and "out" arrays for the fftw plan.
void od_fftwf_free( void * buf ) {
    fftwf_free( buf );
} 

// Creates the fftw plan for "in" and "out" buffer.
fftwf_plan od_fftwf_plan_dft_1d( int n_samples,
                                 fftwf_complex *in,
                                 fftwf_complex *out,
                                 int sign,
                                 unsigned int flags ) {
    fftwf_plan p;
    p = fftwf_plan_dft_1d( n_samples, in, out, sign, flags );
    // p = fftwf_plan_dft_1d( n_samples, in, out, FFTW_FORWARD, FFTW_ESTIMATE );
    return p;
}

// Destroy the fftw plan.
void od_fftwf_destroy_plan( fftwf_plan p ) {
    fftwf_destroy_plan( p );
}

// Execute the fftw plan.
void od_fftwf_execute( fftwf_plan p ) {
    fftwf_execute( p );
}


