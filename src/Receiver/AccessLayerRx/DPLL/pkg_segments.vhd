-- typedef segments

-- I don't like magic numbers or making a 1 bit signal for all of these, the 'compiler' surely must be better at optimizing this than us mere mortals.

package pkg_segments is
    type segment is (SEG_A, SEG_B, SEG_C, SEG_D, SEG_E);
end package;
