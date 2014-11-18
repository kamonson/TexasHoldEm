TITLE MASM Template

; Zeus cs278 EX
;Write a program that 

INCLUDE Irvine32.inc 

.data
word1  WORD  1000h,2000h,3000h,4000h,5000h
dword1 DWORD 10000h,20000h,30000h,40000h
.code
main PROC
mov eax, dword1[8]
mov edx, dword1[4]
xor eax,edx




exit
main ENDP
END main