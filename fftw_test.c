// NOTE(jnc) : 
//   fftwf_XXXXX  for float 32 values and computations.  In gcc, link with -lfftw3f option. 
//   fftw_XXXXX   for double 64 values and computations. In gcc, link with -lfftw3 option.

#include <fftw3.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <stdint.h>
#include <stdbool.h>

float my_PI = 3.14159265358979323846;


// Fill in[] with data with size n_samples, at sample_rate, at sin_freq 
// with a  sin ( 2 * pi * f * t ) where t = i / sample_rate
void fill_array_with_sin ( fftwf_complex *arr, int n_samples, int sample_rate, float sin_freq ) {
    printf("n_samples: %d, at sample_rate %d samples/sec , at sin_freq: %f Hz\n",
           n_samples, sample_rate, sin_freq );
    printf(" with a  sin ( 2 * pi * f * t ) where t = i / sample_rate\n");
    for (int i = 0; i < n_samples; i++) {
        float t = ( double ) i / sample_rate;
        arr[i][0] = sinf( 2 * my_PI * sin_freq * t );
        arr[i][1] = 0;
    }
}

// Calculate magnitude for each complex number
float magnitude ( fftwf_complex val ) {
    return sqrtf( val[0] * val[0] + val[1] * val[1] );
}

void print_complex_array ( char * str_descrip, fftwf_complex *arr, int n, bool print_magnitude ) {
    printf("%s[] : \n", str_descrip);
    for (int i = 0; i < n; i++) {
        if ( print_magnitude ) {
            printf("%d : real: %f + im : %f j -> Magnitude : %f\n", i, arr[i][0], arr[i][1], magnitude( arr[i] ) );
        } else {
            printf("%d : real: %f + im : %f j\n", i, arr[i][0], arr[i][1]);
        }
    }
    printf("\n");
}

int main ( int argc, char **argv ) {
    fftwf_complex *in, *out;
    fftwf_plan p;

    int n_samples   = 10;
    int sample_rate = 10;   

    in  = ( fftwf_complex * ) fftwf_malloc( sizeof( fftwf_complex ) * n_samples );
    out = ( fftwf_complex * ) fftwf_malloc( sizeof( fftwf_complex ) * n_samples );

    p = fftwf_plan_dft_1d( n_samples, in, out, FFTW_FORWARD, FFTW_ESTIMATE);

    // 1º FFT

    // Fill in[] with data with size n_samples, at sample_rate, at sin_freq 
    // with a  sin ( 2 * pi * f * t ) where t = i / sample_rate
    float sin_freq = 2; // Hz
    fill_array_with_sin ( in, n_samples, sample_rate, sin_freq );

    // Print in[].
    print_complex_array( "in A", in, n_samples, false );
 
    fftwf_execute( p ); // repeat as needed

    // print out[].
    print_complex_array( "out A", out, n_samples, true );


    // 2º FFT

    // Fill in[] with data with size n_samples, at sample_rate,
    //  at sin_freq with a  sin ( 2 * pi * f * t ) where t = i / sample_rate
    sin_freq = 4; // Hz
    fill_array_with_sin ( in, n_samples, sample_rate, sin_freq );

    // Print in[].
    print_complex_array( "in B", in, n_samples, false );
    
    fftwf_execute( p ); // repeat as needed

    // print out[].
    print_complex_array( "out B", out, n_samples, true );


    fftwf_destroy_plan( p );
    fftwf_free( in ); 
    fftwf_free( out );
}

