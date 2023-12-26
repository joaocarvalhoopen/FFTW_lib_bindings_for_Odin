// Project name : FFTW lib bindings for Odin.
// Description  : These are bindings to the FFTW library - The Fastest Fourier
//                Transform in the West for odin, so you can do FFT's and Inverse
//                FFT's on f32 buffers. FFTW also allows for calculation of FFT on
//                f64, but I didn't maped it, it has to be linked with a different
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

package fftw

import "core:fmt"
import "core:math"

Sign :: enum  {
    FFTW_Forward  = -1,
    FFTW_Backward =  1,
}

Flags :: enum uint {
    FFTW_Measure         = 0,
    FFTW_Destroy_input   = uint( 1 ) <<  0,
    FFTW_Unaligned       = uint( 1 ) <<  1,
    FFTW_Conserve_Memory = uint( 1 ) <<  2,
    FFTW_Exhaustive      = uint( 1 ) <<  3,   // NO_EXHAUSTIVE is default.
    FFTW_Preserve_Input  = uint( 1 ) <<  4,   // Cancels FFTW_DESTROY_INPUT.
    FFTW_Patient         = uint( 1 ) <<  5,   // IMPATIENT is default.
    FFTW_Estimate        = uint( 1 ) <<  6,
    FFTW_Wisdom_Only     = uint( 1 ) << 21,

// undocumented beyond-guru flags.
    FFTW_Estimate_Patient       = uint( 1 ) <<  7,
    FFTW_Believe_PCost          = uint( 1 ) <<  8,
    FFTW_No_DFT_R2HC            = uint( 1 ) <<  9,
    FFTW_No_NonThreaded         = uint( 1 ) << 10,
    FFTW_No_Buffering           = uint( 1 ) << 11,
    FFTW_No_Indirect_OP         = uint( 1 ) << 12,
    FFTW_Allow_Large_Generic    = uint( 1 ) << 13,  // NO_LARGE_GENERIC is default.
    FFTW_No_Rank_Splits         = uint( 1 ) << 14,
    FFTW_NoO_VRank_Splits       = uint( 1 ) << 15,
    FFTW_No_VRecurse            = uint( 1 ) << 16,
    FFTW_No_SIMD                = uint( 1 ) << 17,
    FFTW_No_Slow                = uint( 1 ) << 18,
    FFTW_No_Fixed_Radix_Large_N = uint( 1 ) << 19,
    FFTW_Allow_Pruning          = uint( 1 ) << 20,
}

// External C object import.
when ODIN_OS == .Linux   do foreign import foo { "fftw_lib.o" }   // "libc++" }

foreign foo {
    // Allocates the memory for the in and out arrays for the fftw plan.
    od_fftwf_malloc :: proc "c" ( n_samples: int ) -> [^]fftwf_complex ---

    // Frees the memory for the "in" and "out" arrays for the fftw plan.
    od_fftwf_free :: proc "c" ( buf : rawptr ) --- 

    // Creates the fftw plan for "in" and "out" buffer.
    od_fftwf_plan_dft_1d :: proc "c" ( n_samples : int,
                                     in_a        : [^]fftwf_complex,
                                     out_a       : [^]fftwf_complex,
                                     sign        : int,
                                     flags       : uint ) -> fftwf_plan ---

    // Destroy the fftw plan.
    od_fftwf_destroy_plan :: proc "c" ( p : fftwf_plan ) ---

    // Execute the fftw plan.
    od_fftwf_execute :: proc "c" ( p : fftwf_plan )  ---
}

fftwf_complex :: struct #packed {
    re : f32,
    im : f32,
}

fftwf_plan :: struct {
    p : rawptr,
}

correct_complex_array_scale :: proc ( arr : [^]fftwf_complex, n_samples : int ) {
    scale_factor := f32( n_samples / 2 )
    for i in 0 ..< n_samples {
        arr[ i ].re  /= scale_factor
        arr [ i ].im /= scale_factor
    }
}


