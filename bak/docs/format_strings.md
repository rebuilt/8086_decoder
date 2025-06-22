= .format

(from ruby core)
=== Implementation from Tms
------------------------------------------------------------------------
  format(format = nil, *args)

------------------------------------------------------------------------

Returns the contents of this Tms object as a formatted string, according
to a format string like that passed to Kernel.format. In addition,
#format accepts the following extensions:

%u:
  Replaced by the user CPU time, as reported by Tms#utime.

%y:
  Replaced by the system CPU time, as reported by #stime (Mnemonic: y of
  "s*y*stem")

%U:
  Replaced by the children's user CPU time, as reported by Tms#cutime

%Y:
  Replaced by the children's system CPU time, as reported by Tms#cstime

%t:
  Replaced by the total CPU time, as reported by Tms#total

%r:
  Replaced by the elapsed real time, as reported by Tms#real

%n:
  Replaced by the label string, as reported by Tms#label (Mnemonic: n of
  "*n*ame")


If format is not given, FORMAT is used as default value, detailing the
user, system and real elapsed time.


(from ruby core)
=== Implementation from Kernel
------------------------------------------------------------------------
  format(*args)

------------------------------------------------------------------------

Returns the string resulting from formatting objects into format_string.

For details on format_string, see {Format
Specifications}[rdoc-ref:format_specifications.rdoc].


(This method is an alias for Kernel#sprintf.)

Returns the string resulting from formatting objects into format_string.

For details on format_string, see {Format
Specifications}[rdoc-ref:format_specifications.rdoc].


(from ruby core)
=== Implementation from PrettyPrint
------------------------------------------------------------------------
  format(output=''.dup, maxwidth=79, newline="\n", genspace=lambda {|n| ' ' * n}) { |q| ... }

------------------------------------------------------------------------

This is a convenience method which is same as follows:

  begin
    q = PrettyPrint.new(output, maxwidth, newline, &genspace)
    ...
    q.flush
    output
  end


(from ruby core)
=== Implementation from Errors
------------------------------------------------------------------------
  format()

------------------------------------------------------------------------

Formats the errors in a human-readable way and return them as a string.


(from ruby core)
=== Implementation from RDoc::Comment
------------------------------------------------------------------------

The format of this comment.  Defaults to RDoc::Markup


(from ruby core)
=== Implementation from DisplayCodeWithLineNumbers
------------------------------------------------------------------------
  format(contents:, number:, empty:, highlight: false)

------------------------------------------------------------------------


==== Expanded from format_specifications.rdoc

= Format Specifications

Several Ruby core classes have instance method printf or sprintf:

* ARGF#printf
* IO#printf
* Kernel#printf
* Kernel#sprintf

Each of these methods takes:

* Argument format_string, which has zero or more embedded
  ______ ______________ (see
  below).
* Arguments *arguments, which are zero or more objects to be formatted.

Each of these methods prints or returns the string resulting from
replacing each format specification embedded in format_string with a
string form of the corresponding argument among arguments.

A simple example:

  sprintf('Name: %s; value: %d', 'Foo', 0) # => "Name: Foo; value: 0"

A format specification has the form:

  %[flags][width][.precision]type

It consists of:

* A leading percent character.
* Zero or more _____ (each is a character).
* An optional _____ _________ (an integer).
* An optional _________ _________ (a
  period followed by a non-negative integer).
* A ____ _________ (a character).

Except for the leading percent character, the only required part is the
type specifier, so we begin with that.

== Type Specifiers

This section provides a brief explanation of each type specifier. The
links lead to the details and examples.

=== Integer Type Specifiers

* b or B: Format argument as a binary integer. See {Specifiers b and
  B}[rdoc-ref:format_specifications.rdoc@Specifiers+b+and+B].
* d, i, or u (all are identical): Format argument as a decimal integer.
  See {Specifier d}[rdoc-ref:format_specifications.rdoc@Specifier+d].
* o: Format argument as an octal integer. See {Specifier
  o}[rdoc-ref:format_specifications.rdoc@Specifier+o].
* x or X: Format argument as a hexadecimal integer. See {Specifiers x
  and X}[rdoc-ref:format_specifications.rdoc@Specifiers+x+and+X].

=== Floating-Point Type Specifiers

* a or A: Format argument as hexadecimal floating-point number. See
  {Specifiers a and
  A}[rdoc-ref:format_specifications.rdoc@Specifiers+a+and+A].
* e or E: Format argument in scientific notation. See {Specifiers e and
  E}[rdoc-ref:format_specifications.rdoc@Specifiers+e+and+E].
* f: Format argument as a decimal floating-point number. See {Specifier
  f}[rdoc-ref:format_specifications.rdoc@Specifier+f].
* g or G: Format argument in a "general" format. See {Specifiers g and
  G}[rdoc-ref:format_specifications.rdoc@Specifiers+g+and+G].

=== Other Type Specifiers

* c: Format argument as a character. See {Specifier
  c}[rdoc-ref:format_specifications.rdoc@Specifier+c].
* p: Format argument as a string via argument.inspect. See {Specifier
  p}[rdoc-ref:format_specifications.rdoc@Specifier+p].
* s: Format argument as a string via argument.to_s. See {Specifier
  s}[rdoc-ref:format_specifications.rdoc@Specifier+s].
* %: Format argument ('%') as a single percent character. See {Specifier
  %}[rdoc-ref:format_specifications.rdoc@Specifier+-25].

== Flags

The effect of a flag may vary greatly among type specifiers. These
remarks are general in nature. See {type-specific
details}[rdoc-ref:format_specifications.rdoc@Type+Specifier+Details+and+
Examples].

Multiple flags may be given with single type specifier; order does not
matter.

=== ' ' Flag

Insert a space before a non-negative number:

  sprintf('%d', 10)  # => "10"
  sprintf('% d', 10) # => " 10"

Insert a minus sign for negative value:

  sprintf('%d', -10)  # => "-10"
  sprintf('% d', -10) # => "-10"

=== '#' Flag

Use an alternate format; varies among types:

  sprintf('%x', 100)  # => "64"
  sprintf('%#x', 100) # => "0x64"

=== '+' Flag

Add a leading plus sign for a non-negative number:

  sprintf('%x', 100)  # => "64"
  sprintf('%+x', 100) # => "+64"

=== '-' Flag

Left justify the value in its field:

  sprintf('%6d', 100)  # => "   100"
  sprintf('%-6d', 100) # => "100   "

=== '0' Flag

Left-pad with zeros instead of spaces:

  sprintf('%6d', 100)  # => "   100"
  sprintf('%06d', 100) # => "000100"

=== '*' Flag

Use the next argument as the field width:

  sprintf('%d', 20, 14)  # => "20"
  sprintf('%*d', 20, 14) # => "                  14"

=== 'n$' Flag

Format the (1-based) nth argument into this field:

  sprintf("%s %s", 'world', 'hello')     # => "world hello"
  sprintf("%2$s %1$s", 'world', 'hello') # => "hello world"

== Width Specifier

In general, a width specifier determines the minimum width (in
characters) of the formatted field:

  sprintf('%10d', 100)  # => "       100"

  # Left-justify if negative.
  sprintf('%-10d', 100) # => "100       "

  # Ignore if too small.
  sprintf('%1d', 100)   # => "100"

== Precision Specifier

A precision specifier is a decimal point followed by zero or more
decimal digits.

For integer type specifiers, the precision specifies the minimum number
of digits to be written. If the precision is shorter than the integer,
the result is padded with leading zeros. There is no modification or
truncation of the result if the integer is longer than the precision:

  sprintf('%.3d', 1)    # => "001"
  sprintf('%.3d', 1000) # => "1000"

  # If the precision is 0 and the value is 0, nothing is written
  sprintf('%.d', 0)  # => ""
  sprintf('%.0d', 0) # => ""

For the a/A, e/E, f/F specifiers, the precision specifies the number of
digits after the decimal point to be written:

  sprintf('%.2f', 3.14159)  # => "3.14"
  sprintf('%.10f', 3.14159) # => "3.1415900000"

  # With no precision specifier, defaults to 6-digit precision.
  sprintf('%f', 3.14159)    # => "3.141590"

For the g/G specifiers, the precision specifies the number of
significant digits to be written:

  sprintf('%.2g', 123.45)  # => "1.2e+02"
  sprintf('%.3g', 123.45)  # => "123"
  sprintf('%.10g', 123.45) # =>  "123.45"

  # With no precision specifier, defaults to 6 significant digits.
  sprintf('%g', 123.456789) # => "123.457"

For the s, p specifiers, the precision specifies the number of
characters to write:

  sprintf('%s', Time.now)    # => "2022-05-04 11:59:16 -0400"
  sprintf('%.10s', Time.now) # => "2022-05-04"

== Type Specifier Details and Examples

=== Specifiers a and A

Format argument as hexadecimal floating-point number:

  sprintf('%a', 3.14159)   # => "0x1.921f9f01b866ep+1"
  sprintf('%a', -3.14159)  # => "-0x1.921f9f01b866ep+1"
  sprintf('%a', 4096)      # => "0x1p+12"
  sprintf('%a', -4096)     # => "-0x1p+12"

  # Capital 'A' means that alphabetical characters are printed in upper case.
  sprintf('%A', 4096)      # => "0X1P+12"
  sprintf('%A', -4096)     # => "-0X1P+12"

=== Specifiers b and B

The two specifiers b and B behave identically except when flag '#'+ is
used.

Format argument as a binary integer:

  sprintf('%b', 1)  # => "1"
  sprintf('%b', 4)  # => "100"

  # Prefix '..' for negative value.
  sprintf('%b', -4) # => "..100"

  # Alternate format.
  sprintf('%#b', 4)  # => "0b100"
  sprintf('%#B', 4)  # => "0B100"

=== Specifier c

Format argument as a single character:

  sprintf('%c', 'A') # => "A"
  sprintf('%c', 65)  # => "A"

This behaves like String#<<, except for raising ArgumentError instead of
RangeError.

=== Specifier d

Format argument as a decimal integer:

  sprintf('%d', 100)  # => "100"
  sprintf('%d', -100) # => "-100"

Flag '#' does not apply.

=== Specifiers e and E

Format argument in {scientific
notation}[https://en.wikipedia.org/wiki/Scientific_notation]:

  sprintf('%e', 3.14159)  # => "3.141590e+00"
  sprintf('%E', -3.14159) # => "-3.141590E+00"

=== Specifier f

Format argument as a floating-point number:

  sprintf('%f', 3.14159)  # => "3.141590"
  sprintf('%f', -3.14159) # => "-3.141590"

Flag '#' does not apply.

=== Specifiers g and G

Format argument using exponential form (e/E specifier) if the exponent
is less than -4 or greater than or equal to the precision. Otherwise
format argument using floating-point form (f specifier):

  sprintf('%g', 100)  # => "100"
  sprintf('%g', 100.0)  # => "100"
  sprintf('%g', 3.14159)  # => "3.14159"
  sprintf('%g', 100000000000)  # => "1e+11"
  sprintf('%g', 0.000000000001)  # => "1e-12"

  # Capital 'G' means use capital 'E'.
  sprintf('%G', 100000000000)  # => "1E+11"
  sprintf('%G', 0.000000000001)  # => "1E-12"

  # Alternate format.
  sprintf('%#g', 100000000000)  # => "1.00000e+11"
  sprintf('%#g', 0.000000000001)  # => "1.00000e-12"
  sprintf('%#G', 100000000000)  # => "1.00000E+11"
  sprintf('%#G', 0.000000000001)  # => "1.00000E-12"

=== Specifier o

Format argument as an octal integer. If argument is negative, it will be
formatted as a two's complement prefixed with ..7:

  sprintf('%o', 16)   # => "20"

  # Prefix '..7' for negative value.
  sprintf('%o', -16)  # => "..760"

  # Prefix zero for alternate format if positive.
  sprintf('%#o', 16)  # => "020"
  sprintf('%#o', -16) # => "..760"

=== Specifier p

Format argument as a string via argument.inspect:

  t = Time.now
  sprintf('%p', t)   # => "2022-05-01 13:42:07.1645683 -0500"

=== Specifier s

Format argument as a string via argument.to_s:

  t = Time.now
  sprintf('%s', t) # => "2022-05-01 13:42:07 -0500"

Flag '#' does not apply.

=== Specifiers x and X

Format argument as a hexadecimal integer. If argument is negative, it
will be formatted as a two's complement prefixed with ..f:

  sprintf('%x', 100)   # => "64"

  # Prefix '..f' for negative value.
  sprintf('%x', -100)  # => "..f9c"

  # Use alternate format.
  sprintf('%#x', 100)  # => "0x64"

  # Alternate format for negative value.
  sprintf('%#x', -100) # => "0x..f9c"

=== Specifier %

Format argument ('%') as a single percent character:

  sprintf('%d %%', 100) # => "100 %"

Flags do not apply.

== Reference by Name

For more complex formatting, Ruby supports a reference by name. %<name>s
style uses format style, but %{name} style doesn't.

Examples:

  sprintf("%<foo>d : %<bar>f", { :foo => 1, :bar => 2 }) # => 1 : 2.000000
  sprintf("%{foo}f", { :foo => 1 })                      # => "1f"

==== Expanded from format_specifications.rdoc

= Format Specifications

Several Ruby core classes have instance method printf or sprintf:

* ARGF#printf
* IO#printf
* Kernel#printf
* Kernel#sprintf

Each of these methods takes:

* Argument format_string, which has zero or more embedded
  ______ ______________ (see
  below).
* Arguments *arguments, which are zero or more objects to be formatted.

Each of these methods prints or returns the string resulting from
replacing each format specification embedded in format_string with a
string form of the corresponding argument among arguments.

A simple example:

  sprintf('Name: %s; value: %d', 'Foo', 0) # => "Name: Foo; value: 0"

A format specification has the form:

  %[flags][width][.precision]type

It consists of:

* A leading percent character.
* Zero or more _____ (each is a character).
* An optional _____ _________ (an integer).
* An optional _________ _________ (a
  period followed by a non-negative integer).
* A ____ _________ (a character).

Except for the leading percent character, the only required part is the
type specifier, so we begin with that.

== Type Specifiers

This section provides a brief explanation of each type specifier. The
links lead to the details and examples.

=== Integer Type Specifiers

* b or B: Format argument as a binary integer. See {Specifiers b and
  B}[rdoc-ref:format_specifications.rdoc@Specifiers+b+and+B].
* d, i, or u (all are identical): Format argument as a decimal integer.
  See {Specifier d}[rdoc-ref:format_specifications.rdoc@Specifier+d].
* o: Format argument as an octal integer. See {Specifier
  o}[rdoc-ref:format_specifications.rdoc@Specifier+o].
* x or X: Format argument as a hexadecimal integer. See {Specifiers x
  and X}[rdoc-ref:format_specifications.rdoc@Specifiers+x+and+X].

=== Floating-Point Type Specifiers

* a or A: Format argument as hexadecimal floating-point number. See
  {Specifiers a and
  A}[rdoc-ref:format_specifications.rdoc@Specifiers+a+and+A].
* e or E: Format argument in scientific notation. See {Specifiers e and
  E}[rdoc-ref:format_specifications.rdoc@Specifiers+e+and+E].
* f: Format argument as a decimal floating-point number. See {Specifier
  f}[rdoc-ref:format_specifications.rdoc@Specifier+f].
* g or G: Format argument in a "general" format. See {Specifiers g and
  G}[rdoc-ref:format_specifications.rdoc@Specifiers+g+and+G].

=== Other Type Specifiers

* c: Format argument as a character. See {Specifier
  c}[rdoc-ref:format_specifications.rdoc@Specifier+c].
* p: Format argument as a string via argument.inspect. See {Specifier
  p}[rdoc-ref:format_specifications.rdoc@Specifier+p].
* s: Format argument as a string via argument.to_s. See {Specifier
  s}[rdoc-ref:format_specifications.rdoc@Specifier+s].
* %: Format argument ('%') as a single percent character. See {Specifier
  %}[rdoc-ref:format_specifications.rdoc@Specifier+-25].

== Flags

The effect of a flag may vary greatly among type specifiers. These
remarks are general in nature. See {type-specific
details}[rdoc-ref:format_specifications.rdoc@Type+Specifier+Details+and+
Examples].

Multiple flags may be given with single type specifier; order does not
matter.

=== ' ' Flag

Insert a space before a non-negative number:

  sprintf('%d', 10)  # => "10"
  sprintf('% d', 10) # => " 10"

Insert a minus sign for negative value:

  sprintf('%d', -10)  # => "-10"
  sprintf('% d', -10) # => "-10"

=== '#' Flag

Use an alternate format; varies among types:

  sprintf('%x', 100)  # => "64"
  sprintf('%#x', 100) # => "0x64"

=== '+' Flag

Add a leading plus sign for a non-negative number:

  sprintf('%x', 100)  # => "64"
  sprintf('%+x', 100) # => "+64"

=== '-' Flag

Left justify the value in its field:

  sprintf('%6d', 100)  # => "   100"
  sprintf('%-6d', 100) # => "100   "

=== '0' Flag

Left-pad with zeros instead of spaces:

  sprintf('%6d', 100)  # => "   100"
  sprintf('%06d', 100) # => "000100"

=== '*' Flag

Use the next argument as the field width:

  sprintf('%d', 20, 14)  # => "20"
  sprintf('%*d', 20, 14) # => "                  14"

=== 'n$' Flag

Format the (1-based) nth argument into this field:

  sprintf("%s %s", 'world', 'hello')     # => "world hello"
  sprintf("%2$s %1$s", 'world', 'hello') # => "hello world"

== Width Specifier

In general, a width specifier determines the minimum width (in
characters) of the formatted field:

  sprintf('%10d', 100)  # => "       100"

  # Left-justify if negative.
  sprintf('%-10d', 100) # => "100       "

  # Ignore if too small.
  sprintf('%1d', 100)   # => "100"

== Precision Specifier

A precision specifier is a decimal point followed by zero or more
decimal digits.

For integer type specifiers, the precision specifies the minimum number
of digits to be written. If the precision is shorter than the integer,
the result is padded with leading zeros. There is no modification or
truncation of the result if the integer is longer than the precision:

  sprintf('%.3d', 1)    # => "001"
  sprintf('%.3d', 1000) # => "1000"

  # If the precision is 0 and the value is 0, nothing is written
  sprintf('%.d', 0)  # => ""
  sprintf('%.0d', 0) # => ""

For the a/A, e/E, f/F specifiers, the precision specifies the number of
digits after the decimal point to be written:

  sprintf('%.2f', 3.14159)  # => "3.14"
  sprintf('%.10f', 3.14159) # => "3.1415900000"

  # With no precision specifier, defaults to 6-digit precision.
  sprintf('%f', 3.14159)    # => "3.141590"

For the g/G specifiers, the precision specifies the number of
significant digits to be written:

  sprintf('%.2g', 123.45)  # => "1.2e+02"
  sprintf('%.3g', 123.45)  # => "123"
  sprintf('%.10g', 123.45) # =>  "123.45"

  # With no precision specifier, defaults to 6 significant digits.
  sprintf('%g', 123.456789) # => "123.457"

For the s, p specifiers, the precision specifies the number of
characters to write:

  sprintf('%s', Time.now)    # => "2022-05-04 11:59:16 -0400"
  sprintf('%.10s', Time.now) # => "2022-05-04"

== Type Specifier Details and Examples

=== Specifiers a and A

Format argument as hexadecimal floating-point number:

  sprintf('%a', 3.14159)   # => "0x1.921f9f01b866ep+1"
  sprintf('%a', -3.14159)  # => "-0x1.921f9f01b866ep+1"
  sprintf('%a', 4096)      # => "0x1p+12"
  sprintf('%a', -4096)     # => "-0x1p+12"

  # Capital 'A' means that alphabetical characters are printed in upper case.
  sprintf('%A', 4096)      # => "0X1P+12"
  sprintf('%A', -4096)     # => "-0X1P+12"

=== Specifiers b and B

The two specifiers b and B behave identically except when flag '#'+ is
used.

Format argument as a binary integer:

  sprintf('%b', 1)  # => "1"
  sprintf('%b', 4)  # => "100"

  # Prefix '..' for negative value.
  sprintf('%b', -4) # => "..100"

  # Alternate format.
  sprintf('%#b', 4)  # => "0b100"
  sprintf('%#B', 4)  # => "0B100"

=== Specifier c

Format argument as a single character:

  sprintf('%c', 'A') # => "A"
  sprintf('%c', 65)  # => "A"

This behaves like String#<<, except for raising ArgumentError instead of
RangeError.

=== Specifier d

Format argument as a decimal integer:

  sprintf('%d', 100)  # => "100"
  sprintf('%d', -100) # => "-100"

Flag '#' does not apply.

=== Specifiers e and E

Format argument in {scientific
notation}[https://en.wikipedia.org/wiki/Scientific_notation]:

  sprintf('%e', 3.14159)  # => "3.141590e+00"
  sprintf('%E', -3.14159) # => "-3.141590E+00"

=== Specifier f

Format argument as a floating-point number:

  sprintf('%f', 3.14159)  # => "3.141590"
  sprintf('%f', -3.14159) # => "-3.141590"

Flag '#' does not apply.

=== Specifiers g and G

Format argument using exponential form (e/E specifier) if the exponent
is less than -4 or greater than or equal to the precision. Otherwise
format argument using floating-point form (f specifier):

  sprintf('%g', 100)  # => "100"
  sprintf('%g', 100.0)  # => "100"
  sprintf('%g', 3.14159)  # => "3.14159"
  sprintf('%g', 100000000000)  # => "1e+11"
  sprintf('%g', 0.000000000001)  # => "1e-12"

  # Capital 'G' means use capital 'E'.
  sprintf('%G', 100000000000)  # => "1E+11"
  sprintf('%G', 0.000000000001)  # => "1E-12"

  # Alternate format.
  sprintf('%#g', 100000000000)  # => "1.00000e+11"
  sprintf('%#g', 0.000000000001)  # => "1.00000e-12"
  sprintf('%#G', 100000000000)  # => "1.00000E+11"
  sprintf('%#G', 0.000000000001)  # => "1.00000E-12"

=== Specifier o

Format argument as an octal integer. If argument is negative, it will be
formatted as a two's complement prefixed with ..7:

  sprintf('%o', 16)   # => "20"

  # Prefix '..7' for negative value.
  sprintf('%o', -16)  # => "..760"

  # Prefix zero for alternate format if positive.
  sprintf('%#o', 16)  # => "020"
  sprintf('%#o', -16) # => "..760"

=== Specifier p

Format argument as a string via argument.inspect:

  t = Time.now
  sprintf('%p', t)   # => "2022-05-01 13:42:07.1645683 -0500"

=== Specifier s

Format argument as a string via argument.to_s:

  t = Time.now
  sprintf('%s', t) # => "2022-05-01 13:42:07 -0500"

Flag '#' does not apply.

=== Specifiers x and X

Format argument as a hexadecimal integer. If argument is negative, it
will be formatted as a two's complement prefixed with ..f:

  sprintf('%x', 100)   # => "64"

  # Prefix '..f' for negative value.
  sprintf('%x', -100)  # => "..f9c"

  # Use alternate format.
  sprintf('%#x', 100)  # => "0x64"

  # Alternate format for negative value.
  sprintf('%#x', -100) # => "0x..f9c"

=== Specifier %

Format argument ('%') as a single percent character:

  sprintf('%d %%', 100) # => "100 %"

Flags do not apply.

== Reference by Name

For more complex formatting, Ruby supports a reference by name. %<name>s
style uses format style, but %{name} style doesn't.

Examples:

  sprintf("%<foo>d : %<bar>f", { :foo => 1, :bar => 2 }) # => 1 : 2.000000
  sprintf("%{foo}f", { :foo => 1 })                      # => "1f"

