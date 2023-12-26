# FFTW lib bindings for Odin
These are bindings for the FFTW - Fast Fourier Transform in the West, for the Odin programming language. 

## Description
These are bindings to the FFTW library - The Fastest Fourier Transform in the West, so you can do the FFT and Inverse FFT on f32 buffers. FFTW also allows for calculation of FFT's on f64, but I didn't mapped it, it has to be linked with a different version of the library, that also comes with the Linux version that one installs with the package manager of your distribution. The FFTW library is a C library, so this binding is a C binding. The FFTW library is a very fast FFT, also popular library and it is very easy to use. These bindings also use GCC to compile the .o obj file.

## Installation
To install the FFTW on your Linux use the FFTW package from your distribution.

## Example of usage
See the file fftw_main.odin for a full example of usage.

``` odin

import f "./fftw"

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
 

    // Destroy the fftw plan.
    f.od_fftwf_destroy_plan( plan )

    // Frees the memory for the "in" and "out" arrays for the fftw plan.
    f.od_fftwf_free( buf_out )
    f.od_fftwf_free( buf_in )

}

```

## License
My code is MIT Open Source license, but the FFTW library has it's own license. So usage of this library, must be in accordance with the FFTW license.

## Have fun
Best regards, <br>
João Carvalho