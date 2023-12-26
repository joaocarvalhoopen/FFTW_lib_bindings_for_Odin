// File         : fftw_main.odin  - Example of usage of the FFTW library.
//
// Project name : FFTW lib bindings for Odin.
// Description  : These are bindings to the FFTW library - The Fastest Fourier
//                Transform in the West, so you can do FFT's and Inverse FFT's on 
//                f32 buffers. FFTW also allows for calculation of FFT's on f64,
//                but I didn't mapped it, it has to be linked with a different
//                version of the library, that also comes with the Linux version
//                that one installs with the package manager.
//                The FFTW library is a C library, so this binding
//                is a C binding. The FFTW library is a very fast FFT, also popular
//                library and it is very easy to use.
//                These bindings also use GCC to compile the .o obj file.
//
// License      : My code is MIT Open Source license, but the FFTW library has
//                it's own license. So usage must be in accordance with the FFTW
//                license.
// Author       : João Carvalho
// Date         : 2023.12.26

package fftw_for_odin

import f "./fftw"
import "core:fmt"
import "core:math"
import "core:strings"
import "core:mem"

// Fill in[] with data with size n_samples, at sample_rate, at sin_freq 
// with a  sin ( 2 * pi * f * t ) where t = i / sample_rate
fill_array_with_sin :: proc ( arr : [^]f.fftwf_complex, n_samples : int, sample_rate : int, sin_freq : f32 ) {
    fmt.printf("n_samples: %v, at sample_rate %v samples/sec , at sin_freq: %v Hz\n",
           n_samples, sample_rate, sin_freq )
    fmt.printf(" with a  sin ( 2 * pi * f * t ) where t = i / sample_rate\n")
    amplitude : f32 = 1.0
    for i in  0 ..< n_samples {
        t : f32 = f32( i ) / f32( sample_rate) 
        arr[i].re = amplitude * math.sin_f32( 2 * math.PI * sin_freq * t )
        arr[i].im = 0
    }
}

// Calculate magnitude for each complex number
magnitude :: proc ( val : f.fftwf_complex ) -> f32 {
    return math.sqrt_f32( val.re * val.re + val.im * val.im )
}

print_complex_array :: proc ( str_descrip : string, arr : [^]f.fftwf_complex, n : int, print_magnitude :  bool ) {
    fmt.printf("%v[] : \n", str_descrip);
    for i in 0 ..< n {
        if ( print_magnitude ) {
            fmt.printf("%d : real: %f + im : %f j -> Magnitude : %v\n", i, arr[ i ].re, arr [ i ].im, magnitude( arr[ i ] ) )
        } else {
            fmt.printf("%d : real: %f + im : %f j\n", i, arr[i].re, arr[i].im )
        }
    }
    fmt.printf("\n")
}

main :: proc () {

    // Allocates the memory for the in and out arrays for the fftw plan.
    buf_in  : [^]f.fftwf_complex
    buf_out : [^]f.fftwf_complex
    n_samples   : int = 10
    sample_rate : int = 10  // Samples per second.
    buf_in  = f.od_fftwf_malloc( n_samples )
    buf_out = f.od_fftwf_malloc( n_samples )


    // Creates the fftw plan for "in" and "out" buffer.
    plan : f.fftwf_plan
    plan = f.od_fftwf_plan_dft_1d( n_samples,
                                   buf_in,
                                   buf_out,
                                   int( f.Sign.FFTW_Forward ),
                                   uint( f.Flags.FFTW_Estimate ) )


    // 1º FFT

    // Clears in_a[] and out_a[]. This is optional!
    mem.zero( buf_in,  n_samples * size_of( f.fftwf_complex ) )
    mem.zero( buf_out, n_samples * size_of( f.fftwf_complex ) )

    // Fill in_a[] with data with size n_samples, at sample_rate, at sin_freq 
    // with a  sin ( 2 * pi * f * t ) where t = i / sample_rate
    
    sin_freq : f32 = 2    // Hz
    fill_array_with_sin( buf_in, n_samples, sample_rate, sin_freq )

    // Print in[].
    print_complex_array( "in A", buf_in, n_samples, false )
 
    // Execute the fftw plan.
    f.od_fftwf_execute( plan )

    // Print out[].
    print_complex_array( "out A", buf_out, n_samples, true )
 
    f.correct_complex_array_scale( buf_out, n_samples )

    // Print out[].
    print_complex_array( "out A scale factor corrected", buf_out, n_samples, true )
 
    // Clears in_a[] and out_a[]. This is optional!
    mem.zero( buf_in,  n_samples * size_of( f.fftwf_complex ) )
    mem.zero( buf_out, n_samples * size_of( f.fftwf_complex ) )



    // 2º FFT

    // Fill in[] with data with size n_samples, at sample_rate,
    //  at sin_freq with a  sin ( 2 * pi * f * t ) where t = i / sample_rate
    
    sin_freq = 4   // Hz
    fill_array_with_sin ( buf_in, n_samples, sample_rate, sin_freq );

    // Print in[].
    print_complex_array( "in B", buf_in, n_samples, false );
    
    f.od_fftwf_execute( plan ); // repeat as needed

    // print out[].
    print_complex_array( "out B", buf_out, n_samples, true );

    f.correct_complex_array_scale( buf_out, n_samples )

    // Print out[].
    print_complex_array( "out B scale factor corrected", buf_out, n_samples, true )



    // Destroy the fftw plan.
    f.od_fftwf_destroy_plan( plan )

    // Frees the memory for the "in" and "out" arrays for the fftw plan.
    f.od_fftwf_free( buf_out )
    f.od_fftwf_free( buf_in )
}



