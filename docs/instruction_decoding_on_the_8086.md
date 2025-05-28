This is the first video in Part 1 of the Performance-Aware Programming series. Please see the Table of Contents to quickly navigate through the rest of the course as it is updated weekly. Homework data is available on the github. A lightly-edited transcript of the video appears below.

In my experience, the easiest way to understand how something works is to build one yourself. If you know how something works, you can build it. If you don't know how something works, you definitely can't.

What I'd like to do for the first part of this course is to have you build a virtual CPU in software \u2014 not the whole thing, because we don't need to go that far just for educational purposes. And we certainly don't need to ever fabricate the CPU, so we only need to simulate it\u2019s functionality, not its actual circuitry. But the goal will be to build enough of a CPU simulation that you deeply understand how it functions.

I don't want to overwhelm anybody with all of the components that you would find in something like a modern Alder Lake or Zen4 CPU. They're incredibly complicated because they represent over forty years of continuous evolution on the x86 architecture.

So in order to keep things simple enough to fit in a reasonable set of homework assignments, I'd like to rewind all the way back to the original 8086 that started the whole lineage. This was the original CPU architecture used in the very first IBM PC1.

The 8086 architecture is much simpler than the modern x64 instruction set, and the behavior of the chip is much simpler, too. It will give us a chance to understand the basic concepts of a CPU without all the modern complexity. Plus, when we later jump forward and start looking at modern x64 CPUs, they will make a lot more sense why they\u2019re doing what they\u2019re doing, because you will understand how the design evolved.

What I'd like to do in this post is get you started with some basic 8086 concepts, then give you some homework to do that will let you practice the ideas directly.

The fundamental model for CPUs in the 8086 era was that inside the CPU, there are specific places that can store bits of data. These are called registers. I mentioned these in passing during the prologue, but we never really said what they were.

In an 8086, a register was literally something that could store 16 bits of data. Just 16. Not 32, not 64, not 512. 16. Chips were a lot smaller and less capable forty years ago!

So if you imagine an 8086 chip, inside it there are literally a series of transistors dedicated to storing groups of 16 bits:

Each group of 16 bits has a name: the first 16 bits was AX, the second 16 bits was BX, then CX, and so on:

When you wanted to describe an operation for the CPU to perform, you had to describe it in terms of these registers. To do a computation, you had to:

    Copy some bits from memory into one of the registers.

    Perform operations on that register, perhaps using data in the other registers.

    Copy the bits from the register back out to memory to complete the operation.

That was the fundamental computation model then, and it's still with us today to a certain extent. But back then \u2014 and this is one of the benefits of rewinding the clock and learning the basics first \u2014 a named register was literally a specific slot on the CPU for holding bits. So when we say \u201ccopy 16 bits from memory into AX\u201d, it literally meant that the state of 16 bits would copy across the data bus from main memory, into the CPU, and be stored in the 16 bits designated for AX.

All the computations the 8086 did were some variant of this process \u2014 we copy some bits from memory into the registers, we perform some arithmetic on them in there, then when we\u2019re done, we copy the bits back out to memory2.

So how do we get started building something that simulates this process? Well, obviously we could make an array and store 16 bit values each for AX, BX, CX and so on. We could make another array of memory, and we could move things between the two. That would start to mimic what the 8086 was doing.

But if we did that, we'd be jumping the gun. We have no idea what registers to use or what memory to access because we haven\u2019t yet talked about the input instruction stream! Before we can actually do anything in a virtual CPU model, we need to have some way of accepting instructions that tell the CPU what to do.

The real place to start is with how the CPU knows what to do in the first place? And that brings us to our first homework assignment, which is to simulate an instruction decode.

Instruction decode is a real thing that happens on the CPU. It's not something we are doing mentally just to understand what's going on. It's an actual network of transistors in the CPU that take incoming bits that encode an instruction, and determine what the CPU should do to execute that instruction.

We're going to start with one of the most important instructions, the \u201cmov\u201d instruction. This instruction encodes one of the most fundamental operations the CPU can do: copy bits from one place to another. The mov instruction has many variants, but we\u2019re going to start with the simplest form, which is copying bits from one register to another register.

Now you\u2019ll notice it\u2019s the \u201cmov\u201d instruction, which is sort-of like an English word, and not binary at all. The reason for that is because when we speak or write assembly language, we don\u2019t write the literal bits for instructions, we write a mnemonic the is easier for us to read and remember.

In Intel assembly, \u201cmov\u201d happens to be the mnemonic for the \u201cmove\u201d instruction, which despite its name, copies bits. They don\u2019t get erased from their source, as \u201cmove\u201d might mean in normal English.

If we wanted to talk about copying bits from one register to another, we write it like this:

mov ax, bx

The \u201cmov\u201d mnemonic says we are trying to do a move instruction, and then the two parameters \u2014 typically called \u201coperands\u201d in assembly language \u2014 tell us which registers are involved.

The first register (\u201cax\u201d) is the destination register. This is where the bits will be copied to. The second register (\u201cbx\u201d) is the source register. This is where the bits will be copied from.

The operand order in Intel syntax is usually this way: the destination register comes first, followed by the sources. This is not always the case in other assembly languages, but it is a fairly consistent rule for Intel. You can remember this by just thinking of an equals operator in higher-level programming languages: the destination is on the left hand side of the equals, and the source is on the right.

So that\u2019s the assembly language instruction for doing a register-to-register move. If you were to write this instruction in an asm program and run it through an assembler, it will encode the instruction into a binary form that can be read directly by the 8086. Inside the 8086, there\u2019s transistors specifically for decoding binary data that encodes all the instructions the 8086 can do.

What does this data actually look like in binary? A register-to-register move instruction is encoded as a two-byte sequence:

The first byte \u2014 eight bits \u2014 has the pattern 100010 in its high six bits. That is what indicates that it will be a mov instruction specifically.

The bottom two bits actually encode options for the move instruction. Bit 1 is the D bit, and bit 0 is the W bit, and they can both be set to either 0 or 1 to encode different options for are move (which we\u2019ll see shortly).

You can already see the complexity start to creep in a little bit here! Intel instruction encodings have a bit of a reputation for unnecessary complexity, and you\u2019re getting a taste of that already.

Anyway, the second byte in the two-byte sequence encodes three separate things. The high two bits are the mod field, then the low six bits are split three and three for the reg field and the r/m field.

These are all the bits involved in a register-to-register move instruction. Let\u2019s look at what they all mean.

The two-bit mod field is a code that tells us what kind of move this is: is it between two registers, or between a register and memory? Since we\u2019re only looking at register-register moves, the value will always be 11 (since we\u2019re talking about bits, that\u2019s two 1 bits, not eleven!). 11 is the code for \u201cregister to register\u201d.

The three-bit reg and r/m fields encode the two registers involved in the move. Three bits for each gives 8 possible names for each register. How does this correspond to ax, bx, etc.? Well, there\u2019s actually a special table that defines the mapping, which we\u2019ll see when we look at this on the computer.

But how do we know which of the two encoded registers is the source and which is the destination? That\u2019s where the d bit comes in \u2014 it\u2019s the destination bit. If the d bit is 1, then the reg register is the destination. If the d bit is 0, then the reg register is the source. And by process of elimination, whichever one the reg register is not, the r/m register is.

Finally, we have the w bit, which says whether the instruction is going to be wide, meaning that it will operate on 16 bits. When the w bit is 0, it means the mov will copy 8 bits. If the w bit is 1, it means the mov will copy 16 bits.

In addition to saying how many bits to copy, the w bit also therefore implicitly says how much of a register is being targeted by the copy. If it is only copying 8 bits, then by definition it would only be reading from half of the source register. What would this look like in the assembly language?

Well, in addition to naming the entire 16-bit register with ax, bx, and so on, you can also refer just to the high 8 or low 8 bits of a register using \u201cl\u201d and \u201ch\u201d. So \u201cx\u201d is, in some sense, less part of the register name and more of a notation for \u201call 16 bits\u201d. The register name is perhaps more properly just \u201ca\u201d, and then the suffix x, l, or h is appended to say how much of the register you are talking about. So this:

mov al, bl

would copy just the low 8 bits, unlike the ax/bx version which copied all 16.

OK. That\u2019s actually a complete description of how a register-to-register move is encoded for the CPU. You now know everything you need to know to decode one \u2014 so let\u2019s do it! Let's make a binary instruction stream consisting of nothing but register-to-register moves, and decode them. This will be your homework.

The first thing you probably should do while you're working on this is to keep the Intel 8086 reference manual handy. You can Google it and download it in PDF form:

This manual has all the technical details of how the 8086 chip works\u2026 and when I say \u201call\u201d, I mean \u201call\u201d, as in way more details than we need to know for this course. It\u2019s a 200 page manual with pin diagrams and all that! So you don\u2019t have to read most of it, but if you\u2019re the sort of person who likes computing history, I would highly recommend skimming through it. You\u2019ll find a lot of neat glimpses into the past in there that give you a sense of how computing worked back then!

Anyway, the part we actually care about starts around page 160 of the PDF:

There's a little introduction there, and they even talk about \u201cmov\u201d first just like I did3. There is also a diagram, just like the one I drew:

You can see all the bits I talked about in there: w, d, mod, etc.

So everything you want to know about decoding instructions is right here in the manual. Some of it may be a bit confusing if you\u2019re new to this sort of thing, but don\u2019t worry \u2014 we\u2019ll be going over the necessary parts for the course in later posts, just like we did for the mov instruction.

But more relevant to today\u2019s exercise is the reg field table:

Remember I said there was a table that would tell us how the three-bit register fields correspond to the specific registers? Well here is that table. And, like I foretold earlier, you can see how the w bit is necessary to determine exactly which register maps to the three-bit reg pattern.

In addition to those general decoding tables, which apply to several instructions, there\u2019s also table 4-12 which lists the specific encoding for each instruction:

The one we want is right at the top: \u201cRegister/memory to/from register\u201d. That\u2019s the variant of mov that we need for a register-to-register copy.

Now, as you can see, there are actually two additional bytes shown there in parentheses \u2014 (DISP-LO) and (DISP-HI). These are only present if you\u2019re doing the memory version of the mov. Since we\u2019re only doing register-to-register for the homework, we don\u2019t have to worry about those\u2026 yet!

So how do you actually do the homework? First, pick the programming language you are most comfortable with. For this first part, we are not thinking about performance, we\u2019re building a little CPU model to learn how it works. You can use whatever language you prefer. As long as it can read binary files into memory and do bit operations on them, it will work for this part of the course. So feel free to use C# or Java or Python or anything else that meets that criteria.

The assembly language programs you\u2019ll be decoding are listings thirty-seven and thirty-eight:

; ========================================================================
; LISTING 37
; ========================================================================

bits 16

mov cx, bx

; ========================================================================
; LISTING 38
; ========================================================================

bits 16

mov cx, bx
mov ch, ah
mov dx, bx
mov si, bx
mov bx, di
mov al, cl
mov ch, ch
mov bx, ax
mov bx, si
mov sp, di
mov bp, ax

You can get them from the github or cut-and-paste them from this article. However, if you copy them like this, you\u2019ll have to assemble them first using an assembler. If you\u2019d like to skip that step, the github has preassembled versions of the files for you \u2014 it\u2019s just the same name as the listing file, but without the .asm extension.

A few things to note: first, the \u201cbits 16\u201d directive is just a note to the assembler that we are trying to generate old-school 8086 machine code. Without it, it might assume that we wanted 32-bit x86 machine code, or modern 64-bit x64 machine code. That\u2019s for later in the course! For now, we just want good old-fashioned 16-bit machine code.

Second, if you\u2019d like to assemble the asm files yourself, you can download an assembler. I assembled these files with the Netwide Assembler, NASM, which you can download for a variety of platforms:

Once you have NASM downloaded, you can feed it any ASM file you write and it will produce the binary for you. For example, if we invoke NASM on listing thirty-seven, it will produce a binary file with the same name but no extension:

Looking at the listing, you can see that it\u2019s two bytes long. Why is it so small? Well, remember, it\u2019s just a single register-to-register mov instruction. And how many bytes does that take to encode? Two! So the assembler produced exactly the number of bytes we expect.

For your homework, you have to write something that will load those binary files and decode the instructions. My homework was that sim8086.exe you see there, and if we run it on the binary we just assembled, here\u2019s what we get:

Luckily for me, my program works! That\u2019s the correct disassembly. So that's the goal. That's what you should try to do for your homework.

Optionally, you can also do what I did here and put in a little extra print-out at the beginning. I put in a comment, just so I could see which file it was, but also I put the \u201cbits 16\u201d in there. That obviously isn\u2019t in the binary \u2014 it\u2019s just implicit. But I put it in the disassembly dump because that way I can reassemble the output of my homework into a binary, too!

Why would I want to do that? Well, in order to test if I disassembled the code correctly, I could do a diff of the source asm file with the disassembly. But, what if the formatting was different? What if there were comments? It seems like a hassle.

However, the assembled versions should always match exactly. So by making my disassembly ready to be reassembled, I can automate the testing of my disassembler just by assembling its output and diffing the binaries:

This helps speed up testing, so I highly recommend it! But it\u2019s optional for the homework. It\u2019s up to you if you think that trick will be useful for you or not.

Once you\u2019ve successfully disassembled the binaries from both listings thirty-seven and thirty-eight, you\u2019d done! If you want to keep experimenting, and add more instruction decoding using the details in the 8086 manual, by all means go for it. But for today you only have to do the register-to-register mov.

Alright, that\u2019s the entire assignment. Give it your best shot, and I\u2019ll see you back here for the next installment when we'll try some more complex instruction decoding!
1

Although according to the history books, the 8086 itself was not the chip used in those machines. Rather, it was the cost-reduced 8088, which was the same architecture but with an 8-bit data bus instead of a 16-bit database. Since I was only a wee tot at the time, and had neither chip in any computer at home, I will take Wikipedia\u2019s word for this!
2

This does not consider coprocessors and other aspects of the IBM PC design, of course. When I say everything worked by moving things into registers and then back again, I mean specifically the things the CPU did. Coprocessors might obviously do other things in other ways depending on the architecture!
3

Believe it or not, I had already decided on doing mov first before I ever downloaded the manual. So I guess there must be something about the fundamental nature of mov that makes people think they should talk about it first!
