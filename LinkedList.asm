myds	SEGMENT PARA 'veri'
		dizi DW 20 DUP(0)
		linkler DW 20 DUP(-1)
		n DW 0
		
		head DW -1
		selection dw 0
		CR	EQU 13
		LF	EQU 10
		HATA	DB CR, LF, 'Dikkat !!! Sayi vermediniz yeniden giris yapiniz.!!!  ', 0
		MSG1	DB '  Dizi olusturmak icin:1 , Linkli liste yazdirmak icin :2 , Linkli listeye eleman ekleme icin :3  , Cikis icin : 4 giriniz  : ',0
		MSG2	DB 'N = ',0
		MSG3	DB 'Sirayla dizi elemanlarini giriniz : ',0
		MSG4	DB 'Eklemek istediginiz elemani giriniz : ',0
		MSG5    DB 'Dizi = ',0
		MSG6    DB '   Linkler = ',0
		MSG7 	DB	',',0
myds	ENDS

myss	SEGMENT PARA STACK 'yigin'
		DW 100 DUP(?)
myss	ENDS

mycs	SEGMENT PARA 'kod'
		ASSUME DS:myds, SS:myss, CS:mycs

ANA 	PROC FAR

		;BERKAY DEMİRHAN 19011075
		
		PUSH DS
		XOR AX,AX
		PUSH AX
		MOV AX,myds
		MOV DS,AX
		
BAS:	MOV AX, OFFSET MSG1;menu iskeletini yazdiriyoruz 
		CALL PUT_STR
		CALL GETN ;menu icin secilen adimi aliyoruz
		CMP AX,2
		JA CHECK
		JE MENU2
		JB CHECK2
		
				
CHECK:	CMP AX,4
		JE final
		JB MENU3
		JA BAS; yanlis deger girildiğinde menüyü tekrar çağırır.
CHECK2:	CMP AX,1
		JE	MENU1	
		JL	BAS;yanlis deger girildiginde menüyü tekrar çağırır.
		
		
		

		
		
MENU1:	
		
		CALL bir ;Menünün birinci adımının fonksiyonunu çağırır.
		JMP BAS
		
		
		
		
MENU2:
		
		CALL iki; Menünün ikinci adımının fonksiyonunu çağırır.
		JMP BAS
	
		
MENU3:
		CALL uc
		JMP BAS
		
final:
		
		RETF
ANA		ENDP

bir		PROC NEAR
;BERKAY DEMİRHAN 19011075
		PUSH AX
		PUSH SI
		PUSH CX
		PUSH DX
		PUSH BX 
		PUSH DI
		
		MOV AX, OFFSET MSG2
		CALL PUT_STR
		CALL GETN; N degerinin girdisini aliyoruz
		MOV N,AX
		
		XOR SI,SI
		MOV CX,N
		
GIR:	MOV AX, OFFSET MSG3;GIR loopunda sirasiyla dizinin elemanlarini aliyoruz
		CALL PUT_STR
		CALL GETN
		MOV dizi[SI],AX
		ADD SI,2; Dizi word tipi olduğu için 2 artırıyoruz.
		LOOP GIR
		
		
		
		

		XOR DX,DX
		XOR SI,SI
		MOV AX,dizi[0]

		MOV CX,n
		DEC CX
		
L1:		CMP AX,dizi[SI+2];L1 döngüsünde dizinin en küçük elemanını bulup , onun indis değerini de head'e aktarıyoruz.
		JL	kucuk
		MOV AX,dizi[SI+2]
		MOV BX,SI
		ADD BX,2
		
kucuk:	ADD SI,2
		LOOP L1
		MOV head,BX
		
		
		
		MOV CX,N
		DEC CX
L2:		PUSH CX;L2 ve L3 döngülerinde dizinin tüm elemanlarını gezip indis değerini almadığımız min elemanın indis değerini alıyoruz.Onun indis değerini ondan bir küçük elemanın ---->
		XOR SI,SI;---->linkler dizisindeki indisine yazıyoruz.Böylece verilen diziyi linked liste çevirmiş oluyoruz.
		
		
		MOV CX,N
		MOV AX,1000
		

L3:		MOV DX,dizi[SI]
		CMP dizi[SI],AX
		JG devam
		CMP DX,dizi[BX]
		JLE devam
		MOV AX,dizi[SI]
		MOV DI,SI
devam:	ADD SI,2
		LOOP L3
		
		MOV linkler[BX],DI
		MOV BX,DI
		POP CX
		LOOP L2
		
		
		POP DI
		POP BX
		POP DX
		
		POP CX
		POP SI
		POP AX
		
		RET
bir		ENDP


iki 	PROC NEAR

		;BERKAY DEMİRHAN 19011075
		PUSH CX
		PUSH SI
		PUSH AX
		
		MOV CX,N
		XOR SI,SI
		MOV AX, OFFSET MSG5
		CALL PUT_STR
		
yazma:	MOV AX,dizi[SI]; yazma title'ında sırasıyla dizinin elemanlarını yazıyoruz ve yanına virgül yazıyoruz.
		CALL PUTN
		MOV AX, OFFSET MSG7
		CALL PUT_STR
		
		ADD SI,2
		LOOP yazma
		
		
		MOV CX,N
		XOR SI,SI
		MOV AX, OFFSET MSG6
		CALL PUT_STR
		
yazma2:	MOV AX,linkler[SI];yazma2 title'ında sırasıyla linkler dizisinin elemanlarını yazıyoruz ve yanına virgül yazıyoruz.
		SAR AX,1;Ben word tipi dizi kullandığım için daha anlaşılabilir yapmak için indis değerini 2'ye bölüyoruz.
		CALL PUTN
		MOV AX, OFFSET MSG7
		CALL PUT_STR
		
		ADD SI,2
		LOOP yazma2
		POP AX
		POP SI
		POP CX
	
		RET
iki		ENDP

uc		PROC NEAR
;BERKAY DEMİRHAN 19011075
		MOV AX, OFFSET MSG4
		CALL PUT_STR
		CALL GETN 
		MOV DX,AX;input alınan değeri DX e yazıyoruz
		
		MOV AX,N
		SHL AX,1;linkler dizisi word tipi olduğu için 2'yle çarpıyoruz
		MOV SI,AX;input alınan değerin dizideki indisini SI 'ya aktarıyoruz.
	
		
		
		
		CMP head,-1;Dizide henüz eleman eklenmemişse bu adım çalışacak ve eklenen değerin indisi head'de tutulacak.
		JNE ilkmi
		MOV head,0
		JMP bitti
		

		
		
ilkmi:	
		
		MOV BX,head;İnput alınan değer dizinin en küçük elemanından küçükse bu adım çalışır
		CMP DX,dizi[BX]
		
		JG	ilkdegil
		MOV BX,head
		MOV linkler[SI],BX;yeni eklenin değerin indisine head'in gösteriği değer yazılır.
		MOV head,SI;Daha sonra head'e de bu değerin indisi yazılır.
		JMP bitti
ilkdegil:

		MOV BX,head
		MOV DI,BX
		MOV BX,linkler[DI]

		
ortaya:	
		CMP linkler[DI],-1;linkler dizisinde elemanların biri -1'i gösterdiği zaman eleman sona aktarılacağı için 'sona' labelına zıplar.
		JE sona
		CMP DX,dizi[BX];Eklenecek değer dizinin herhangi bir elemanında küçüksa orada durur.
		JG	bulmadik
		MOV linkler[SI],BX;Eklenecek sayının linkler dizisindeki indisi ondan bir sonraki büyük sayının indisine eşitlenir.
		MOV linkler[DI],SI;Ondan bir küçük sayının linkler dizisindeki indisine de yeni eklenen değerin indisine eşitlenir.
		JMP bitti
bulmadik:
		
		MOV DI,BX
		
		
		MOV BX,linkler[DI]
		
		JMP ortaya
		
		
		
		
sona:	
		
		MOV linkler[DI],SI;Eğer yeni eklenecek değer dizideki tüm elemanlardan büyükse , dizideki ondan bir küçük elemanın linkler listesindeki indisine yeni eklenen sayının indisi yazılır.
		



		
bitti:	MOV dizi[SI],DX;Adım sayısını kısaltacağı için yeni sayıyı diziye ekleme ve dizinin eleman sayısını artırma işlemlerini en sonda yapıyoruz.
		INC N
		RET
uc		ENDP

GETC	PROC NEAR
    
        MOV AH, 1h
        INT 21H
        RET 
GETC	ENDP 

PUTC	PROC NEAR
       
        PUSH AX
        PUSH DX
        MOV DL, AL
        MOV AH,2
        INT 21H
        POP DX
        POP AX
        RET 
PUTC 	ENDP 

GETN 	PROC NEAR
        
        PUSH BX
        PUSH CX
        PUSH DX
GETN_START:
        MOV DX, 1	                      
        XOR BX, BX 	                     
        XOR CX,CX	                        
NEW:
        CALL GETC	                        
        CMP AL,CR 
        JE FIN_READ	                        
        CMP  AL, '-'	                        
        JNE  CTRL_NUM	                       
NEGATIVE:
        MOV DX, -1	                        
        JMP NEW		                        
CTRL_NUM:
        CMP AL, '0'	                        ; sayının 0-9 arasında olduğunu kontrol et.
        JB error 
        CMP AL, '9'
        JA error		                ; değil ise HATA mesajı verilecek
        SUB AL,'0'	                        ; rakam alındı, haneyi toplama dâhil et 
        MOV BL, AL	                        ; BL’ye okunan haneyi koy 
        MOV AX, 10 	                        ; Haneyi eklerken *10 yapılacak 
        PUSH DX		                        ; MUL komutu DX’i bozar işaret için saklanmalı
        MUL CX		                        ; DX:AX = AX * CX
        POP DX		                        ; işareti geri al 
        MOV CX, AX	                        ; CX deki ara değer *10 yapıldı 
        ADD CX, BX 	                        ; okunan haneyi ara değere ekle 
        JMP NEW 		                ; klavyeden yeni basılan değeri al 
ERROR:
        MOV AX, OFFSET HATA 
        CALL PUT_STR	                        ; HATA mesajını göster 
        JMP GETN_START                          ; o ana kadar okunanları unut yeniden sayı almaya başla 
FIN_READ:
        MOV AX, CX	                        ; sonuç AX üzerinden dönecek 
        CMP DX, 1	                        ; İşarete göre sayıyı ayarlamak lazım 
        JE FIN_GETN
        NEG AX		                        ; AX = -AX
FIN_GETN:
        POP DX
        POP CX
        POP DX
        RET 
GETN 	ENDP 

PUTN 	PROC NEAR
        ;------------------------------------------------------------------------
        ; AX de bulunan sayiyi onluk tabanda hane hane yazdırır. 
        ; CX: haneleri 10’a bölerek bulacağız, CX=10 olacak
        ; DX: 32 bölmede işleme dâhil olacak. Soncu etkilemesin diye 0 olmalı 
        ;------------------------------------------------------------------------
        PUSH CX
        PUSH DX 	
        XOR DX,	DX 	                        ; DX 32 bit bölmede soncu etkilemesin diye 0 olmalı 
        PUSH DX		                        ; haneleri ASCII karakter olarak yığında saklayacağız.
                                                ; Kaç haneyi alacağımızı bilmediğimiz için yığına 0 
                                                ; değeri koyup onu alana kadar devam edelim.
        MOV CX, 10	                        ; CX = 10
        CMP AX, 0
        JGE CALC_DIGITS	
        NEG AX 		                        ; sayı negatif ise AX pozitif yapılır. 
        PUSH AX		                        ; AX sakla 
        MOV AL, '-'	                        ; işareti ekrana yazdır. 
        CALL PUTC
        POP AX		                        ; AX’i geri al 
        
CALC_DIGITS:
        DIV CX  		                ; DX:AX = AX/CX  AX = bölüm DX = kalan 
        ADD DX, '0'	                        ; kalan değerini ASCII olarak bul 
        PUSH DX		                        ; yığına sakla 
        XOR DX,DX	                        ; DX = 0
        CMP AX, 0	                        ; bölen 0 kaldı ise sayının işlenmesi bitti demek
        JNE CALC_DIGITS	                        ; işlemi tekrarla 
        
DISP_LOOP:
                                                ; yazılacak tüm haneler yığında. En anlamlı hane üstte 
                                                ; en az anlamlı hane en alta ve onu altında da 
                                                ; sona vardığımızı anlamak için konan 0 değeri var. 
        POP AX		                        ; sırayla değerleri yığından alalım
        CMP AX, 0 	                        ; AX=0 olursa sona geldik demek 
        JE END_DISP_LOOP 
        CALL PUTC 	                        ; AL deki ASCII değeri yaz
        JMP DISP_LOOP                           ; işleme devam
        
END_DISP_LOOP:
        POP DX 
        POP CX
        RET
PUTN 	ENDP 

PUT_STR	PROC NEAR
        ;------------------------------------------------------------------------
        ; AX de adresi verilen sonunda 0 olan dizgeyi karakter karakter yazdırır.
        ; BX dizgeye indis olarak kullanılır. Önceki değeri saklanmalıdır. 
        ;------------------------------------------------------------------------
	PUSH BX 
        MOV BX,	AX			        ; Adresi BX’e al 
        MOV AL, BYTE PTR [BX]	                ; AL’de ilk karakter var 
PUT_LOOP:   
        CMP AL,0		
        JE  PUT_FIN 			        ; 0 geldi ise dizge sona erdi demek
        CALL PUTC 			        ; AL’deki karakteri ekrana yazar
        INC BX 				        ; bir sonraki karaktere geç
        MOV AL, BYTE PTR [BX]
        JMP PUT_LOOP			        ; yazdırmaya devam 
PUT_FIN:
	POP BX
	RET 
PUT_STR	ENDP


mycs	ENDS
		END ANA
		
		
		