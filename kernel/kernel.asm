
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00008117          	auipc	sp,0x8
    80000004:	8d013103          	ld	sp,-1840(sp) # 800078d0 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	04a000ef          	jal	ra,80000060 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e422                	sd	s0,8(sp)
    80000020:	0800                	addi	s0,sp,16
#define MIE_STIE (1L << 5)  // supervisor timer
static inline uint64
r_mie()
{
  uint64 x;
  asm volatile("csrr %0, mie" : "=r" (x) );
    80000022:	304027f3          	csrr	a5,mie
  // enable supervisor-mode timer interrupts.
  w_mie(r_mie() | MIE_STIE);
    80000026:	0207e793          	ori	a5,a5,32
}

static inline void 
w_mie(uint64 x)
{
  asm volatile("csrw mie, %0" : : "r" (x));
    8000002a:	30479073          	csrw	mie,a5
static inline uint64
r_menvcfg()
{
  uint64 x;
  // asm volatile("csrr %0, menvcfg" : "=r" (x) );
  asm volatile("csrr %0, 0x30a" : "=r" (x) );
    8000002e:	30a027f3          	csrr	a5,0x30a
  
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | (1L << 63)); 
    80000032:	577d                	li	a4,-1
    80000034:	177e                	slli	a4,a4,0x3f
    80000036:	8fd9                	or	a5,a5,a4

static inline void 
w_menvcfg(uint64 x)
{
  // asm volatile("csrw menvcfg, %0" : : "r" (x));
  asm volatile("csrw 0x30a, %0" : : "r" (x));
    80000038:	30a79073          	csrw	0x30a,a5

static inline uint64
r_mcounteren()
{
  uint64 x;
  asm volatile("csrr %0, mcounteren" : "=r" (x) );
    8000003c:	306027f3          	csrr	a5,mcounteren
  
  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    80000040:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r" (x));
    80000044:	30679073          	csrw	mcounteren,a5
// machine-mode cycle counter
static inline uint64
r_time()
{
  uint64 x;
  asm volatile("csrr %0, time" : "=r" (x) );
    80000048:	c01027f3          	rdtime	a5
  
  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    8000004c:	000f4737          	lui	a4,0xf4
    80000050:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80000054:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80000056:	14d79073          	csrw	0x14d,a5
}
    8000005a:	6422                	ld	s0,8(sp)
    8000005c:	0141                	addi	sp,sp,16
    8000005e:	8082                	ret

0000000080000060 <start>:
{
    80000060:	1141                	addi	sp,sp,-16
    80000062:	e406                	sd	ra,8(sp)
    80000064:	e022                	sd	s0,0(sp)
    80000066:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80000068:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    8000006c:	7779                	lui	a4,0xffffe
    8000006e:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffddb9f>
    80000072:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80000074:	6705                	lui	a4,0x1
    80000076:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    8000007a:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    8000007c:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80000080:	00001797          	auipc	a5,0x1
    80000084:	d8e78793          	addi	a5,a5,-626 # 80000e0e <main>
    80000088:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    8000008c:	4781                	li	a5,0
    8000008e:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80000092:	67c1                	lui	a5,0x10
    80000094:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80000096:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    8000009a:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    8000009e:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800000a2:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800000a6:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800000aa:	57fd                	li	a5,-1
    800000ac:	83a9                	srli	a5,a5,0xa
    800000ae:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800000b2:	47bd                	li	a5,15
    800000b4:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800000b8:	f65ff0ef          	jal	ra,8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800000bc:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000c0:	2781                	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    800000c2:	823e                	mv	tp,a5
  asm volatile("mret");
    800000c4:	30200073          	mret
}
    800000c8:	60a2                	ld	ra,8(sp)
    800000ca:	6402                	ld	s0,0(sp)
    800000cc:	0141                	addi	sp,sp,16
    800000ce:	8082                	ret

00000000800000d0 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800000d0:	715d                	addi	sp,sp,-80
    800000d2:	e486                	sd	ra,72(sp)
    800000d4:	e0a2                	sd	s0,64(sp)
    800000d6:	fc26                	sd	s1,56(sp)
    800000d8:	f84a                	sd	s2,48(sp)
    800000da:	f44e                	sd	s3,40(sp)
    800000dc:	f052                	sd	s4,32(sp)
    800000de:	ec56                	sd	s5,24(sp)
    800000e0:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    800000e2:	04c05363          	blez	a2,80000128 <consolewrite+0x58>
    800000e6:	8a2a                	mv	s4,a0
    800000e8:	84ae                	mv	s1,a1
    800000ea:	89b2                	mv	s3,a2
    800000ec:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    800000ee:	5afd                	li	s5,-1
    800000f0:	4685                	li	a3,1
    800000f2:	8626                	mv	a2,s1
    800000f4:	85d2                	mv	a1,s4
    800000f6:	fbf40513          	addi	a0,s0,-65
    800000fa:	0a2020ef          	jal	ra,8000219c <either_copyin>
    800000fe:	01550b63          	beq	a0,s5,80000114 <consolewrite+0x44>
      break;
    uartputc(c);
    80000102:	fbf44503          	lbu	a0,-65(s0)
    80000106:	7da000ef          	jal	ra,800008e0 <uartputc>
  for(i = 0; i < n; i++){
    8000010a:	2905                	addiw	s2,s2,1
    8000010c:	0485                	addi	s1,s1,1
    8000010e:	ff2991e3          	bne	s3,s2,800000f0 <consolewrite+0x20>
    80000112:	894e                	mv	s2,s3
  }

  return i;
}
    80000114:	854a                	mv	a0,s2
    80000116:	60a6                	ld	ra,72(sp)
    80000118:	6406                	ld	s0,64(sp)
    8000011a:	74e2                	ld	s1,56(sp)
    8000011c:	7942                	ld	s2,48(sp)
    8000011e:	79a2                	ld	s3,40(sp)
    80000120:	7a02                	ld	s4,32(sp)
    80000122:	6ae2                	ld	s5,24(sp)
    80000124:	6161                	addi	sp,sp,80
    80000126:	8082                	ret
  for(i = 0; i < n; i++){
    80000128:	4901                	li	s2,0
    8000012a:	b7ed                	j	80000114 <consolewrite+0x44>

000000008000012c <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    8000012c:	7159                	addi	sp,sp,-112
    8000012e:	f486                	sd	ra,104(sp)
    80000130:	f0a2                	sd	s0,96(sp)
    80000132:	eca6                	sd	s1,88(sp)
    80000134:	e8ca                	sd	s2,80(sp)
    80000136:	e4ce                	sd	s3,72(sp)
    80000138:	e0d2                	sd	s4,64(sp)
    8000013a:	fc56                	sd	s5,56(sp)
    8000013c:	f85a                	sd	s6,48(sp)
    8000013e:	f45e                	sd	s7,40(sp)
    80000140:	f062                	sd	s8,32(sp)
    80000142:	ec66                	sd	s9,24(sp)
    80000144:	e86a                	sd	s10,16(sp)
    80000146:	1880                	addi	s0,sp,112
    80000148:	8aaa                	mv	s5,a0
    8000014a:	8a2e                	mv	s4,a1
    8000014c:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    8000014e:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80000152:	0000f517          	auipc	a0,0xf
    80000156:	7de50513          	addi	a0,a0,2014 # 8000f930 <cons>
    8000015a:	23f000ef          	jal	ra,80000b98 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    8000015e:	0000f497          	auipc	s1,0xf
    80000162:	7d248493          	addi	s1,s1,2002 # 8000f930 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80000166:	00010917          	auipc	s2,0x10
    8000016a:	86290913          	addi	s2,s2,-1950 # 8000f9c8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];

    if(c == C('D')){  // end-of-file
    8000016e:	4b91                	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80000170:	5c7d                	li	s8,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    80000172:	4ca9                	li	s9,10
  while(n > 0){
    80000174:	07305363          	blez	s3,800001da <consoleread+0xae>
    while(cons.r == cons.w){
    80000178:	0984a783          	lw	a5,152(s1)
    8000017c:	09c4a703          	lw	a4,156(s1)
    80000180:	02f71163          	bne	a4,a5,800001a2 <consoleread+0x76>
      if(killed(myproc())){
    80000184:	6a6010ef          	jal	ra,8000182a <myproc>
    80000188:	6a7010ef          	jal	ra,8000202e <killed>
    8000018c:	e125                	bnez	a0,800001ec <consoleread+0xc0>
      sleep(&cons.r, &cons.lock);
    8000018e:	85a6                	mv	a1,s1
    80000190:	854a                	mv	a0,s2
    80000192:	465010ef          	jal	ra,80001df6 <sleep>
    while(cons.r == cons.w){
    80000196:	0984a783          	lw	a5,152(s1)
    8000019a:	09c4a703          	lw	a4,156(s1)
    8000019e:	fef703e3          	beq	a4,a5,80000184 <consoleread+0x58>
    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001a2:	0017871b          	addiw	a4,a5,1
    800001a6:	08e4ac23          	sw	a4,152(s1)
    800001aa:	07f7f713          	andi	a4,a5,127
    800001ae:	9726                	add	a4,a4,s1
    800001b0:	01874703          	lbu	a4,24(a4)
    800001b4:	00070d1b          	sext.w	s10,a4
    if(c == C('D')){  // end-of-file
    800001b8:	057d0f63          	beq	s10,s7,80000216 <consoleread+0xea>
    cbuf = c;
    800001bc:	f8e40fa3          	sb	a4,-97(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800001c0:	4685                	li	a3,1
    800001c2:	f9f40613          	addi	a2,s0,-97
    800001c6:	85d2                	mv	a1,s4
    800001c8:	8556                	mv	a0,s5
    800001ca:	789010ef          	jal	ra,80002152 <either_copyout>
    800001ce:	01850663          	beq	a0,s8,800001da <consoleread+0xae>
    dst++;
    800001d2:	0a05                	addi	s4,s4,1
    --n;
    800001d4:	39fd                	addiw	s3,s3,-1
    if(c == '\n'){
    800001d6:	f99d1fe3          	bne	s10,s9,80000174 <consoleread+0x48>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    800001da:	0000f517          	auipc	a0,0xf
    800001de:	75650513          	addi	a0,a0,1878 # 8000f930 <cons>
    800001e2:	24f000ef          	jal	ra,80000c30 <release>

  return target - n;
    800001e6:	413b053b          	subw	a0,s6,s3
    800001ea:	a801                	j	800001fa <consoleread+0xce>
        release(&cons.lock);
    800001ec:	0000f517          	auipc	a0,0xf
    800001f0:	74450513          	addi	a0,a0,1860 # 8000f930 <cons>
    800001f4:	23d000ef          	jal	ra,80000c30 <release>
        return -1;
    800001f8:	557d                	li	a0,-1
}
    800001fa:	70a6                	ld	ra,104(sp)
    800001fc:	7406                	ld	s0,96(sp)
    800001fe:	64e6                	ld	s1,88(sp)
    80000200:	6946                	ld	s2,80(sp)
    80000202:	69a6                	ld	s3,72(sp)
    80000204:	6a06                	ld	s4,64(sp)
    80000206:	7ae2                	ld	s5,56(sp)
    80000208:	7b42                	ld	s6,48(sp)
    8000020a:	7ba2                	ld	s7,40(sp)
    8000020c:	7c02                	ld	s8,32(sp)
    8000020e:	6ce2                	ld	s9,24(sp)
    80000210:	6d42                	ld	s10,16(sp)
    80000212:	6165                	addi	sp,sp,112
    80000214:	8082                	ret
      if(n < target){
    80000216:	0009871b          	sext.w	a4,s3
    8000021a:	fd6770e3          	bgeu	a4,s6,800001da <consoleread+0xae>
        cons.r--;
    8000021e:	0000f717          	auipc	a4,0xf
    80000222:	7af72523          	sw	a5,1962(a4) # 8000f9c8 <cons+0x98>
    80000226:	bf55                	j	800001da <consoleread+0xae>

0000000080000228 <consputc>:
{
    80000228:	1141                	addi	sp,sp,-16
    8000022a:	e406                	sd	ra,8(sp)
    8000022c:	e022                	sd	s0,0(sp)
    8000022e:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80000230:	10000793          	li	a5,256
    80000234:	00f50863          	beq	a0,a5,80000244 <consputc+0x1c>
    uartputc_sync(c);
    80000238:	5d2000ef          	jal	ra,8000080a <uartputc_sync>
}
    8000023c:	60a2                	ld	ra,8(sp)
    8000023e:	6402                	ld	s0,0(sp)
    80000240:	0141                	addi	sp,sp,16
    80000242:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80000244:	4521                	li	a0,8
    80000246:	5c4000ef          	jal	ra,8000080a <uartputc_sync>
    8000024a:	02000513          	li	a0,32
    8000024e:	5bc000ef          	jal	ra,8000080a <uartputc_sync>
    80000252:	4521                	li	a0,8
    80000254:	5b6000ef          	jal	ra,8000080a <uartputc_sync>
    80000258:	b7d5                	j	8000023c <consputc+0x14>

000000008000025a <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    8000025a:	1101                	addi	sp,sp,-32
    8000025c:	ec06                	sd	ra,24(sp)
    8000025e:	e822                	sd	s0,16(sp)
    80000260:	e426                	sd	s1,8(sp)
    80000262:	e04a                	sd	s2,0(sp)
    80000264:	1000                	addi	s0,sp,32
    80000266:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80000268:	0000f517          	auipc	a0,0xf
    8000026c:	6c850513          	addi	a0,a0,1736 # 8000f930 <cons>
    80000270:	129000ef          	jal	ra,80000b98 <acquire>

  switch(c){
    80000274:	47d5                	li	a5,21
    80000276:	0af48063          	beq	s1,a5,80000316 <consoleintr+0xbc>
    8000027a:	0297c663          	blt	a5,s1,800002a6 <consoleintr+0x4c>
    8000027e:	47a1                	li	a5,8
    80000280:	0cf48f63          	beq	s1,a5,8000035e <consoleintr+0x104>
    80000284:	47c1                	li	a5,16
    80000286:	10f49063          	bne	s1,a5,80000386 <consoleintr+0x12c>
  case C('P'):  // Print process list.
    procdump();
    8000028a:	75d010ef          	jal	ra,800021e6 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    8000028e:	0000f517          	auipc	a0,0xf
    80000292:	6a250513          	addi	a0,a0,1698 # 8000f930 <cons>
    80000296:	19b000ef          	jal	ra,80000c30 <release>
}
    8000029a:	60e2                	ld	ra,24(sp)
    8000029c:	6442                	ld	s0,16(sp)
    8000029e:	64a2                	ld	s1,8(sp)
    800002a0:	6902                	ld	s2,0(sp)
    800002a2:	6105                	addi	sp,sp,32
    800002a4:	8082                	ret
  switch(c){
    800002a6:	07f00793          	li	a5,127
    800002aa:	0af48a63          	beq	s1,a5,8000035e <consoleintr+0x104>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    800002ae:	0000f717          	auipc	a4,0xf
    800002b2:	68270713          	addi	a4,a4,1666 # 8000f930 <cons>
    800002b6:	0a072783          	lw	a5,160(a4)
    800002ba:	09872703          	lw	a4,152(a4)
    800002be:	9f99                	subw	a5,a5,a4
    800002c0:	07f00713          	li	a4,127
    800002c4:	fcf765e3          	bltu	a4,a5,8000028e <consoleintr+0x34>
      c = (c == '\r') ? '\n' : c;
    800002c8:	47b5                	li	a5,13
    800002ca:	0cf48163          	beq	s1,a5,8000038c <consoleintr+0x132>
      consputc(c);
    800002ce:	8526                	mv	a0,s1
    800002d0:	f59ff0ef          	jal	ra,80000228 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    800002d4:	0000f797          	auipc	a5,0xf
    800002d8:	65c78793          	addi	a5,a5,1628 # 8000f930 <cons>
    800002dc:	0a07a683          	lw	a3,160(a5)
    800002e0:	0016871b          	addiw	a4,a3,1
    800002e4:	0007061b          	sext.w	a2,a4
    800002e8:	0ae7a023          	sw	a4,160(a5)
    800002ec:	07f6f693          	andi	a3,a3,127
    800002f0:	97b6                	add	a5,a5,a3
    800002f2:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    800002f6:	47a9                	li	a5,10
    800002f8:	0af48f63          	beq	s1,a5,800003b6 <consoleintr+0x15c>
    800002fc:	4791                	li	a5,4
    800002fe:	0af48c63          	beq	s1,a5,800003b6 <consoleintr+0x15c>
    80000302:	0000f797          	auipc	a5,0xf
    80000306:	6c67a783          	lw	a5,1734(a5) # 8000f9c8 <cons+0x98>
    8000030a:	9f1d                	subw	a4,a4,a5
    8000030c:	08000793          	li	a5,128
    80000310:	f6f71fe3          	bne	a4,a5,8000028e <consoleintr+0x34>
    80000314:	a04d                	j	800003b6 <consoleintr+0x15c>
    while(cons.e != cons.w &&
    80000316:	0000f717          	auipc	a4,0xf
    8000031a:	61a70713          	addi	a4,a4,1562 # 8000f930 <cons>
    8000031e:	0a072783          	lw	a5,160(a4)
    80000322:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80000326:	0000f497          	auipc	s1,0xf
    8000032a:	60a48493          	addi	s1,s1,1546 # 8000f930 <cons>
    while(cons.e != cons.w &&
    8000032e:	4929                	li	s2,10
    80000330:	f4f70fe3          	beq	a4,a5,8000028e <consoleintr+0x34>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80000334:	37fd                	addiw	a5,a5,-1
    80000336:	07f7f713          	andi	a4,a5,127
    8000033a:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    8000033c:	01874703          	lbu	a4,24(a4)
    80000340:	f52707e3          	beq	a4,s2,8000028e <consoleintr+0x34>
      cons.e--;
    80000344:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80000348:	10000513          	li	a0,256
    8000034c:	eddff0ef          	jal	ra,80000228 <consputc>
    while(cons.e != cons.w &&
    80000350:	0a04a783          	lw	a5,160(s1)
    80000354:	09c4a703          	lw	a4,156(s1)
    80000358:	fcf71ee3          	bne	a4,a5,80000334 <consoleintr+0xda>
    8000035c:	bf0d                	j	8000028e <consoleintr+0x34>
    if(cons.e != cons.w){
    8000035e:	0000f717          	auipc	a4,0xf
    80000362:	5d270713          	addi	a4,a4,1490 # 8000f930 <cons>
    80000366:	0a072783          	lw	a5,160(a4)
    8000036a:	09c72703          	lw	a4,156(a4)
    8000036e:	f2f700e3          	beq	a4,a5,8000028e <consoleintr+0x34>
      cons.e--;
    80000372:	37fd                	addiw	a5,a5,-1
    80000374:	0000f717          	auipc	a4,0xf
    80000378:	64f72e23          	sw	a5,1628(a4) # 8000f9d0 <cons+0xa0>
      consputc(BACKSPACE);
    8000037c:	10000513          	li	a0,256
    80000380:	ea9ff0ef          	jal	ra,80000228 <consputc>
    80000384:	b729                	j	8000028e <consoleintr+0x34>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80000386:	f00484e3          	beqz	s1,8000028e <consoleintr+0x34>
    8000038a:	b715                	j	800002ae <consoleintr+0x54>
      consputc(c);
    8000038c:	4529                	li	a0,10
    8000038e:	e9bff0ef          	jal	ra,80000228 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80000392:	0000f797          	auipc	a5,0xf
    80000396:	59e78793          	addi	a5,a5,1438 # 8000f930 <cons>
    8000039a:	0a07a703          	lw	a4,160(a5)
    8000039e:	0017069b          	addiw	a3,a4,1
    800003a2:	0006861b          	sext.w	a2,a3
    800003a6:	0ad7a023          	sw	a3,160(a5)
    800003aa:	07f77713          	andi	a4,a4,127
    800003ae:	97ba                	add	a5,a5,a4
    800003b0:	4729                	li	a4,10
    800003b2:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    800003b6:	0000f797          	auipc	a5,0xf
    800003ba:	60c7ab23          	sw	a2,1558(a5) # 8000f9cc <cons+0x9c>
        wakeup(&cons.r);
    800003be:	0000f517          	auipc	a0,0xf
    800003c2:	60a50513          	addi	a0,a0,1546 # 8000f9c8 <cons+0x98>
    800003c6:	27d010ef          	jal	ra,80001e42 <wakeup>
    800003ca:	b5d1                	j	8000028e <consoleintr+0x34>

00000000800003cc <consoleinit>:

void
consoleinit(void)
{
    800003cc:	1141                	addi	sp,sp,-16
    800003ce:	e406                	sd	ra,8(sp)
    800003d0:	e022                	sd	s0,0(sp)
    800003d2:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    800003d4:	00007597          	auipc	a1,0x7
    800003d8:	c3c58593          	addi	a1,a1,-964 # 80007010 <etext+0x10>
    800003dc:	0000f517          	auipc	a0,0xf
    800003e0:	55450513          	addi	a0,a0,1364 # 8000f930 <cons>
    800003e4:	734000ef          	jal	ra,80000b18 <initlock>

  uartinit();
    800003e8:	3d6000ef          	jal	ra,800007be <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    800003ec:	0001f797          	auipc	a5,0x1f
    800003f0:	6dc78793          	addi	a5,a5,1756 # 8001fac8 <devsw>
    800003f4:	00000717          	auipc	a4,0x0
    800003f8:	d3870713          	addi	a4,a4,-712 # 8000012c <consoleread>
    800003fc:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    800003fe:	00000717          	auipc	a4,0x0
    80000402:	cd270713          	addi	a4,a4,-814 # 800000d0 <consolewrite>
    80000406:	ef98                	sd	a4,24(a5)
}
    80000408:	60a2                	ld	ra,8(sp)
    8000040a:	6402                	ld	s0,0(sp)
    8000040c:	0141                	addi	sp,sp,16
    8000040e:	8082                	ret

0000000080000410 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    80000410:	7179                	addi	sp,sp,-48
    80000412:	f406                	sd	ra,40(sp)
    80000414:	f022                	sd	s0,32(sp)
    80000416:	ec26                	sd	s1,24(sp)
    80000418:	e84a                	sd	s2,16(sp)
    8000041a:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  unsigned long long x;

  if(sign && (sign = (xx < 0)))
    8000041c:	c219                	beqz	a2,80000422 <printint+0x12>
    8000041e:	06054e63          	bltz	a0,8000049a <printint+0x8a>
    x = -xx;
  else
    x = xx;
    80000422:	4881                	li	a7,0
    80000424:	fd040693          	addi	a3,s0,-48

  i = 0;
    80000428:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
    8000042a:	00007617          	auipc	a2,0x7
    8000042e:	c0e60613          	addi	a2,a2,-1010 # 80007038 <digits>
    80000432:	883e                	mv	a6,a5
    80000434:	2785                	addiw	a5,a5,1
    80000436:	02b57733          	remu	a4,a0,a1
    8000043a:	9732                	add	a4,a4,a2
    8000043c:	00074703          	lbu	a4,0(a4)
    80000440:	00e68023          	sb	a4,0(a3)
  } while((x /= base) != 0);
    80000444:	872a                	mv	a4,a0
    80000446:	02b55533          	divu	a0,a0,a1
    8000044a:	0685                	addi	a3,a3,1
    8000044c:	feb773e3          	bgeu	a4,a1,80000432 <printint+0x22>

  if(sign)
    80000450:	00088a63          	beqz	a7,80000464 <printint+0x54>
    buf[i++] = '-';
    80000454:	1781                	addi	a5,a5,-32
    80000456:	97a2                	add	a5,a5,s0
    80000458:	02d00713          	li	a4,45
    8000045c:	fee78823          	sb	a4,-16(a5)
    80000460:	0028079b          	addiw	a5,a6,2

  while(--i >= 0)
    80000464:	02f05563          	blez	a5,8000048e <printint+0x7e>
    80000468:	fd040713          	addi	a4,s0,-48
    8000046c:	00f704b3          	add	s1,a4,a5
    80000470:	fff70913          	addi	s2,a4,-1
    80000474:	993e                	add	s2,s2,a5
    80000476:	37fd                	addiw	a5,a5,-1
    80000478:	1782                	slli	a5,a5,0x20
    8000047a:	9381                	srli	a5,a5,0x20
    8000047c:	40f90933          	sub	s2,s2,a5
    consputc(buf[i]);
    80000480:	fff4c503          	lbu	a0,-1(s1)
    80000484:	da5ff0ef          	jal	ra,80000228 <consputc>
  while(--i >= 0)
    80000488:	14fd                	addi	s1,s1,-1
    8000048a:	ff249be3          	bne	s1,s2,80000480 <printint+0x70>
}
    8000048e:	70a2                	ld	ra,40(sp)
    80000490:	7402                	ld	s0,32(sp)
    80000492:	64e2                	ld	s1,24(sp)
    80000494:	6942                	ld	s2,16(sp)
    80000496:	6145                	addi	sp,sp,48
    80000498:	8082                	ret
    x = -xx;
    8000049a:	40a00533          	neg	a0,a0
  if(sign && (sign = (xx < 0)))
    8000049e:	4885                	li	a7,1
    x = -xx;
    800004a0:	b751                	j	80000424 <printint+0x14>

00000000800004a2 <printf>:
}

// Print to the console.
int
printf(char *fmt, ...)
{
    800004a2:	7155                	addi	sp,sp,-208
    800004a4:	e506                	sd	ra,136(sp)
    800004a6:	e122                	sd	s0,128(sp)
    800004a8:	fca6                	sd	s1,120(sp)
    800004aa:	f8ca                	sd	s2,112(sp)
    800004ac:	f4ce                	sd	s3,104(sp)
    800004ae:	f0d2                	sd	s4,96(sp)
    800004b0:	ecd6                	sd	s5,88(sp)
    800004b2:	e8da                	sd	s6,80(sp)
    800004b4:	e4de                	sd	s7,72(sp)
    800004b6:	e0e2                	sd	s8,64(sp)
    800004b8:	fc66                	sd	s9,56(sp)
    800004ba:	f86a                	sd	s10,48(sp)
    800004bc:	f46e                	sd	s11,40(sp)
    800004be:	0900                	addi	s0,sp,144
    800004c0:	8a2a                	mv	s4,a0
    800004c2:	e40c                	sd	a1,8(s0)
    800004c4:	e810                	sd	a2,16(s0)
    800004c6:	ec14                	sd	a3,24(s0)
    800004c8:	f018                	sd	a4,32(s0)
    800004ca:	f41c                	sd	a5,40(s0)
    800004cc:	03043823          	sd	a6,48(s0)
    800004d0:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2, locking;
  char *s;

  locking = pr.locking;
    800004d4:	0000f797          	auipc	a5,0xf
    800004d8:	51c7a783          	lw	a5,1308(a5) # 8000f9f0 <pr+0x18>
    800004dc:	f6f43c23          	sd	a5,-136(s0)
  if(locking)
    800004e0:	eb9d                	bnez	a5,80000516 <printf+0x74>
    acquire(&pr.lock);

  va_start(ap, fmt);
    800004e2:	00840793          	addi	a5,s0,8
    800004e6:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    800004ea:	00054503          	lbu	a0,0(a0)
    800004ee:	24050463          	beqz	a0,80000736 <printf+0x294>
    800004f2:	4981                	li	s3,0
    if(cx != '%'){
    800004f4:	02500a93          	li	s5,37
    i++;
    c0 = fmt[i+0] & 0xff;
    c1 = c2 = 0;
    if(c0) c1 = fmt[i+1] & 0xff;
    if(c1) c2 = fmt[i+2] & 0xff;
    if(c0 == 'd'){
    800004f8:	06400b13          	li	s6,100
      printint(va_arg(ap, int), 10, 1);
    } else if(c0 == 'l' && c1 == 'd'){
    800004fc:	06c00c13          	li	s8,108
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
    80000500:	07500c93          	li	s9,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
    80000504:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
    80000508:	07000d93          	li	s11,112
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    8000050c:	00007b97          	auipc	s7,0x7
    80000510:	b2cb8b93          	addi	s7,s7,-1236 # 80007038 <digits>
    80000514:	a081                	j	80000554 <printf+0xb2>
    acquire(&pr.lock);
    80000516:	0000f517          	auipc	a0,0xf
    8000051a:	4c250513          	addi	a0,a0,1218 # 8000f9d8 <pr>
    8000051e:	67a000ef          	jal	ra,80000b98 <acquire>
  va_start(ap, fmt);
    80000522:	00840793          	addi	a5,s0,8
    80000526:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    8000052a:	000a4503          	lbu	a0,0(s4)
    8000052e:	f171                	bnez	a0,800004f2 <printf+0x50>
#endif
  }
  va_end(ap);

  if(locking)
    release(&pr.lock);
    80000530:	0000f517          	auipc	a0,0xf
    80000534:	4a850513          	addi	a0,a0,1192 # 8000f9d8 <pr>
    80000538:	6f8000ef          	jal	ra,80000c30 <release>
    8000053c:	aaed                	j	80000736 <printf+0x294>
      consputc(cx);
    8000053e:	cebff0ef          	jal	ra,80000228 <consputc>
      continue;
    80000542:	84ce                	mv	s1,s3
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    80000544:	0014899b          	addiw	s3,s1,1
    80000548:	013a07b3          	add	a5,s4,s3
    8000054c:	0007c503          	lbu	a0,0(a5)
    80000550:	1c050f63          	beqz	a0,8000072e <printf+0x28c>
    if(cx != '%'){
    80000554:	ff5515e3          	bne	a0,s5,8000053e <printf+0x9c>
    i++;
    80000558:	0019849b          	addiw	s1,s3,1
    c0 = fmt[i+0] & 0xff;
    8000055c:	009a07b3          	add	a5,s4,s1
    80000560:	0007c903          	lbu	s2,0(a5)
    if(c0) c1 = fmt[i+1] & 0xff;
    80000564:	1c090563          	beqz	s2,8000072e <printf+0x28c>
    80000568:	0017c783          	lbu	a5,1(a5)
    c1 = c2 = 0;
    8000056c:	86be                	mv	a3,a5
    if(c1) c2 = fmt[i+2] & 0xff;
    8000056e:	c789                	beqz	a5,80000578 <printf+0xd6>
    80000570:	009a0733          	add	a4,s4,s1
    80000574:	00274683          	lbu	a3,2(a4)
    if(c0 == 'd'){
    80000578:	03690463          	beq	s2,s6,800005a0 <printf+0xfe>
    } else if(c0 == 'l' && c1 == 'd'){
    8000057c:	03890e63          	beq	s2,s8,800005b8 <printf+0x116>
    } else if(c0 == 'u'){
    80000580:	0b990d63          	beq	s2,s9,8000063a <printf+0x198>
    } else if(c0 == 'x'){
    80000584:	11a90363          	beq	s2,s10,8000068a <printf+0x1e8>
    } else if(c0 == 'p'){
    80000588:	13b90b63          	beq	s2,s11,800006be <printf+0x21c>
    } else if(c0 == 's'){
    8000058c:	07300793          	li	a5,115
    80000590:	16f90363          	beq	s2,a5,800006f6 <printf+0x254>
    } else if(c0 == '%'){
    80000594:	03591c63          	bne	s2,s5,800005cc <printf+0x12a>
      consputc('%');
    80000598:	8556                	mv	a0,s5
    8000059a:	c8fff0ef          	jal	ra,80000228 <consputc>
    8000059e:	b75d                	j	80000544 <printf+0xa2>
      printint(va_arg(ap, int), 10, 1);
    800005a0:	f8843783          	ld	a5,-120(s0)
    800005a4:	00878713          	addi	a4,a5,8
    800005a8:	f8e43423          	sd	a4,-120(s0)
    800005ac:	4605                	li	a2,1
    800005ae:	45a9                	li	a1,10
    800005b0:	4388                	lw	a0,0(a5)
    800005b2:	e5fff0ef          	jal	ra,80000410 <printint>
    800005b6:	b779                	j	80000544 <printf+0xa2>
    } else if(c0 == 'l' && c1 == 'd'){
    800005b8:	03678163          	beq	a5,s6,800005da <printf+0x138>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    800005bc:	03878d63          	beq	a5,s8,800005f6 <printf+0x154>
    } else if(c0 == 'l' && c1 == 'u'){
    800005c0:	09978963          	beq	a5,s9,80000652 <printf+0x1b0>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    800005c4:	03878b63          	beq	a5,s8,800005fa <printf+0x158>
    } else if(c0 == 'l' && c1 == 'x'){
    800005c8:	0da78d63          	beq	a5,s10,800006a2 <printf+0x200>
      consputc('%');
    800005cc:	8556                	mv	a0,s5
    800005ce:	c5bff0ef          	jal	ra,80000228 <consputc>
      consputc(c0);
    800005d2:	854a                	mv	a0,s2
    800005d4:	c55ff0ef          	jal	ra,80000228 <consputc>
    800005d8:	b7b5                	j	80000544 <printf+0xa2>
      printint(va_arg(ap, uint64), 10, 1);
    800005da:	f8843783          	ld	a5,-120(s0)
    800005de:	00878713          	addi	a4,a5,8
    800005e2:	f8e43423          	sd	a4,-120(s0)
    800005e6:	4605                	li	a2,1
    800005e8:	45a9                	li	a1,10
    800005ea:	6388                	ld	a0,0(a5)
    800005ec:	e25ff0ef          	jal	ra,80000410 <printint>
      i += 1;
    800005f0:	0029849b          	addiw	s1,s3,2
    800005f4:	bf81                	j	80000544 <printf+0xa2>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    800005f6:	03668463          	beq	a3,s6,8000061e <printf+0x17c>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    800005fa:	07968a63          	beq	a3,s9,8000066e <printf+0x1cc>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    800005fe:	fda697e3          	bne	a3,s10,800005cc <printf+0x12a>
      printint(va_arg(ap, uint64), 16, 0);
    80000602:	f8843783          	ld	a5,-120(s0)
    80000606:	00878713          	addi	a4,a5,8
    8000060a:	f8e43423          	sd	a4,-120(s0)
    8000060e:	4601                	li	a2,0
    80000610:	45c1                	li	a1,16
    80000612:	6388                	ld	a0,0(a5)
    80000614:	dfdff0ef          	jal	ra,80000410 <printint>
      i += 2;
    80000618:	0039849b          	addiw	s1,s3,3
    8000061c:	b725                	j	80000544 <printf+0xa2>
      printint(va_arg(ap, uint64), 10, 1);
    8000061e:	f8843783          	ld	a5,-120(s0)
    80000622:	00878713          	addi	a4,a5,8
    80000626:	f8e43423          	sd	a4,-120(s0)
    8000062a:	4605                	li	a2,1
    8000062c:	45a9                	li	a1,10
    8000062e:	6388                	ld	a0,0(a5)
    80000630:	de1ff0ef          	jal	ra,80000410 <printint>
      i += 2;
    80000634:	0039849b          	addiw	s1,s3,3
    80000638:	b731                	j	80000544 <printf+0xa2>
      printint(va_arg(ap, int), 10, 0);
    8000063a:	f8843783          	ld	a5,-120(s0)
    8000063e:	00878713          	addi	a4,a5,8
    80000642:	f8e43423          	sd	a4,-120(s0)
    80000646:	4601                	li	a2,0
    80000648:	45a9                	li	a1,10
    8000064a:	4388                	lw	a0,0(a5)
    8000064c:	dc5ff0ef          	jal	ra,80000410 <printint>
    80000650:	bdd5                	j	80000544 <printf+0xa2>
      printint(va_arg(ap, uint64), 10, 0);
    80000652:	f8843783          	ld	a5,-120(s0)
    80000656:	00878713          	addi	a4,a5,8
    8000065a:	f8e43423          	sd	a4,-120(s0)
    8000065e:	4601                	li	a2,0
    80000660:	45a9                	li	a1,10
    80000662:	6388                	ld	a0,0(a5)
    80000664:	dadff0ef          	jal	ra,80000410 <printint>
      i += 1;
    80000668:	0029849b          	addiw	s1,s3,2
    8000066c:	bde1                	j	80000544 <printf+0xa2>
      printint(va_arg(ap, uint64), 10, 0);
    8000066e:	f8843783          	ld	a5,-120(s0)
    80000672:	00878713          	addi	a4,a5,8
    80000676:	f8e43423          	sd	a4,-120(s0)
    8000067a:	4601                	li	a2,0
    8000067c:	45a9                	li	a1,10
    8000067e:	6388                	ld	a0,0(a5)
    80000680:	d91ff0ef          	jal	ra,80000410 <printint>
      i += 2;
    80000684:	0039849b          	addiw	s1,s3,3
    80000688:	bd75                	j	80000544 <printf+0xa2>
      printint(va_arg(ap, int), 16, 0);
    8000068a:	f8843783          	ld	a5,-120(s0)
    8000068e:	00878713          	addi	a4,a5,8
    80000692:	f8e43423          	sd	a4,-120(s0)
    80000696:	4601                	li	a2,0
    80000698:	45c1                	li	a1,16
    8000069a:	4388                	lw	a0,0(a5)
    8000069c:	d75ff0ef          	jal	ra,80000410 <printint>
    800006a0:	b555                	j	80000544 <printf+0xa2>
      printint(va_arg(ap, uint64), 16, 0);
    800006a2:	f8843783          	ld	a5,-120(s0)
    800006a6:	00878713          	addi	a4,a5,8
    800006aa:	f8e43423          	sd	a4,-120(s0)
    800006ae:	4601                	li	a2,0
    800006b0:	45c1                	li	a1,16
    800006b2:	6388                	ld	a0,0(a5)
    800006b4:	d5dff0ef          	jal	ra,80000410 <printint>
      i += 1;
    800006b8:	0029849b          	addiw	s1,s3,2
    800006bc:	b561                	j	80000544 <printf+0xa2>
      printptr(va_arg(ap, uint64));
    800006be:	f8843783          	ld	a5,-120(s0)
    800006c2:	00878713          	addi	a4,a5,8
    800006c6:	f8e43423          	sd	a4,-120(s0)
    800006ca:	0007b983          	ld	s3,0(a5)
  consputc('0');
    800006ce:	03000513          	li	a0,48
    800006d2:	b57ff0ef          	jal	ra,80000228 <consputc>
  consputc('x');
    800006d6:	856a                	mv	a0,s10
    800006d8:	b51ff0ef          	jal	ra,80000228 <consputc>
    800006dc:	4941                	li	s2,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800006de:	03c9d793          	srli	a5,s3,0x3c
    800006e2:	97de                	add	a5,a5,s7
    800006e4:	0007c503          	lbu	a0,0(a5)
    800006e8:	b41ff0ef          	jal	ra,80000228 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800006ec:	0992                	slli	s3,s3,0x4
    800006ee:	397d                	addiw	s2,s2,-1
    800006f0:	fe0917e3          	bnez	s2,800006de <printf+0x23c>
    800006f4:	bd81                	j	80000544 <printf+0xa2>
      if((s = va_arg(ap, char*)) == 0)
    800006f6:	f8843783          	ld	a5,-120(s0)
    800006fa:	00878713          	addi	a4,a5,8
    800006fe:	f8e43423          	sd	a4,-120(s0)
    80000702:	0007b903          	ld	s2,0(a5)
    80000706:	00090d63          	beqz	s2,80000720 <printf+0x27e>
      for(; *s; s++)
    8000070a:	00094503          	lbu	a0,0(s2)
    8000070e:	e2050be3          	beqz	a0,80000544 <printf+0xa2>
        consputc(*s);
    80000712:	b17ff0ef          	jal	ra,80000228 <consputc>
      for(; *s; s++)
    80000716:	0905                	addi	s2,s2,1
    80000718:	00094503          	lbu	a0,0(s2)
    8000071c:	f97d                	bnez	a0,80000712 <printf+0x270>
    8000071e:	b51d                	j	80000544 <printf+0xa2>
        s = "(null)";
    80000720:	00007917          	auipc	s2,0x7
    80000724:	8f890913          	addi	s2,s2,-1800 # 80007018 <etext+0x18>
      for(; *s; s++)
    80000728:	02800513          	li	a0,40
    8000072c:	b7dd                	j	80000712 <printf+0x270>
  if(locking)
    8000072e:	f7843783          	ld	a5,-136(s0)
    80000732:	de079fe3          	bnez	a5,80000530 <printf+0x8e>

  return 0;
}
    80000736:	4501                	li	a0,0
    80000738:	60aa                	ld	ra,136(sp)
    8000073a:	640a                	ld	s0,128(sp)
    8000073c:	74e6                	ld	s1,120(sp)
    8000073e:	7946                	ld	s2,112(sp)
    80000740:	79a6                	ld	s3,104(sp)
    80000742:	7a06                	ld	s4,96(sp)
    80000744:	6ae6                	ld	s5,88(sp)
    80000746:	6b46                	ld	s6,80(sp)
    80000748:	6ba6                	ld	s7,72(sp)
    8000074a:	6c06                	ld	s8,64(sp)
    8000074c:	7ce2                	ld	s9,56(sp)
    8000074e:	7d42                	ld	s10,48(sp)
    80000750:	7da2                	ld	s11,40(sp)
    80000752:	6169                	addi	sp,sp,208
    80000754:	8082                	ret

0000000080000756 <panic>:

void
panic(char *s)
{
    80000756:	1101                	addi	sp,sp,-32
    80000758:	ec06                	sd	ra,24(sp)
    8000075a:	e822                	sd	s0,16(sp)
    8000075c:	e426                	sd	s1,8(sp)
    8000075e:	1000                	addi	s0,sp,32
    80000760:	84aa                	mv	s1,a0
  pr.locking = 0;
    80000762:	0000f797          	auipc	a5,0xf
    80000766:	2807a723          	sw	zero,654(a5) # 8000f9f0 <pr+0x18>
  printf("panic: ");
    8000076a:	00007517          	auipc	a0,0x7
    8000076e:	8b650513          	addi	a0,a0,-1866 # 80007020 <etext+0x20>
    80000772:	d31ff0ef          	jal	ra,800004a2 <printf>
  printf("%s\n", s);
    80000776:	85a6                	mv	a1,s1
    80000778:	00007517          	auipc	a0,0x7
    8000077c:	8b050513          	addi	a0,a0,-1872 # 80007028 <etext+0x28>
    80000780:	d23ff0ef          	jal	ra,800004a2 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80000784:	4785                	li	a5,1
    80000786:	00007717          	auipc	a4,0x7
    8000078a:	16f72523          	sw	a5,362(a4) # 800078f0 <panicked>
  for(;;)
    8000078e:	a001                	j	8000078e <panic+0x38>

0000000080000790 <printfinit>:
    ;
}

void
printfinit(void)
{
    80000790:	1101                	addi	sp,sp,-32
    80000792:	ec06                	sd	ra,24(sp)
    80000794:	e822                	sd	s0,16(sp)
    80000796:	e426                	sd	s1,8(sp)
    80000798:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    8000079a:	0000f497          	auipc	s1,0xf
    8000079e:	23e48493          	addi	s1,s1,574 # 8000f9d8 <pr>
    800007a2:	00007597          	auipc	a1,0x7
    800007a6:	88e58593          	addi	a1,a1,-1906 # 80007030 <etext+0x30>
    800007aa:	8526                	mv	a0,s1
    800007ac:	36c000ef          	jal	ra,80000b18 <initlock>
  pr.locking = 1;
    800007b0:	4785                	li	a5,1
    800007b2:	cc9c                	sw	a5,24(s1)
}
    800007b4:	60e2                	ld	ra,24(sp)
    800007b6:	6442                	ld	s0,16(sp)
    800007b8:	64a2                	ld	s1,8(sp)
    800007ba:	6105                	addi	sp,sp,32
    800007bc:	8082                	ret

00000000800007be <uartinit>:

void uartstart();

void
uartinit(void)
{
    800007be:	1141                	addi	sp,sp,-16
    800007c0:	e406                	sd	ra,8(sp)
    800007c2:	e022                	sd	s0,0(sp)
    800007c4:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800007c6:	100007b7          	lui	a5,0x10000
    800007ca:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800007ce:	f8000713          	li	a4,-128
    800007d2:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800007d6:	470d                	li	a4,3
    800007d8:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800007dc:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800007e0:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800007e4:	469d                	li	a3,7
    800007e6:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800007ea:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    800007ee:	00007597          	auipc	a1,0x7
    800007f2:	86258593          	addi	a1,a1,-1950 # 80007050 <digits+0x18>
    800007f6:	0000f517          	auipc	a0,0xf
    800007fa:	20250513          	addi	a0,a0,514 # 8000f9f8 <uart_tx_lock>
    800007fe:	31a000ef          	jal	ra,80000b18 <initlock>
}
    80000802:	60a2                	ld	ra,8(sp)
    80000804:	6402                	ld	s0,0(sp)
    80000806:	0141                	addi	sp,sp,16
    80000808:	8082                	ret

000000008000080a <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    8000080a:	1101                	addi	sp,sp,-32
    8000080c:	ec06                	sd	ra,24(sp)
    8000080e:	e822                	sd	s0,16(sp)
    80000810:	e426                	sd	s1,8(sp)
    80000812:	1000                	addi	s0,sp,32
    80000814:	84aa                	mv	s1,a0
  push_off();
    80000816:	342000ef          	jal	ra,80000b58 <push_off>

  if(panicked){
    8000081a:	00007797          	auipc	a5,0x7
    8000081e:	0d67a783          	lw	a5,214(a5) # 800078f0 <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80000822:	10000737          	lui	a4,0x10000
  if(panicked){
    80000826:	c391                	beqz	a5,8000082a <uartputc_sync+0x20>
    for(;;)
    80000828:	a001                	j	80000828 <uartputc_sync+0x1e>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000082a:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    8000082e:	0207f793          	andi	a5,a5,32
    80000832:	dfe5                	beqz	a5,8000082a <uartputc_sync+0x20>
    ;
  WriteReg(THR, c);
    80000834:	0ff4f513          	zext.b	a0,s1
    80000838:	100007b7          	lui	a5,0x10000
    8000083c:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80000840:	39c000ef          	jal	ra,80000bdc <pop_off>
}
    80000844:	60e2                	ld	ra,24(sp)
    80000846:	6442                	ld	s0,16(sp)
    80000848:	64a2                	ld	s1,8(sp)
    8000084a:	6105                	addi	sp,sp,32
    8000084c:	8082                	ret

000000008000084e <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    8000084e:	00007797          	auipc	a5,0x7
    80000852:	0aa7b783          	ld	a5,170(a5) # 800078f8 <uart_tx_r>
    80000856:	00007717          	auipc	a4,0x7
    8000085a:	0aa73703          	ld	a4,170(a4) # 80007900 <uart_tx_w>
    8000085e:	06f70c63          	beq	a4,a5,800008d6 <uartstart+0x88>
{
    80000862:	7139                	addi	sp,sp,-64
    80000864:	fc06                	sd	ra,56(sp)
    80000866:	f822                	sd	s0,48(sp)
    80000868:	f426                	sd	s1,40(sp)
    8000086a:	f04a                	sd	s2,32(sp)
    8000086c:	ec4e                	sd	s3,24(sp)
    8000086e:	e852                	sd	s4,16(sp)
    80000870:	e456                	sd	s5,8(sp)
    80000872:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      ReadReg(ISR);
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80000874:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80000878:	0000fa17          	auipc	s4,0xf
    8000087c:	180a0a13          	addi	s4,s4,384 # 8000f9f8 <uart_tx_lock>
    uart_tx_r += 1;
    80000880:	00007497          	auipc	s1,0x7
    80000884:	07848493          	addi	s1,s1,120 # 800078f8 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80000888:	00007997          	auipc	s3,0x7
    8000088c:	07898993          	addi	s3,s3,120 # 80007900 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80000890:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    80000894:	02077713          	andi	a4,a4,32
    80000898:	c715                	beqz	a4,800008c4 <uartstart+0x76>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000089a:	01f7f713          	andi	a4,a5,31
    8000089e:	9752                	add	a4,a4,s4
    800008a0:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    800008a4:	0785                	addi	a5,a5,1
    800008a6:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    800008a8:	8526                	mv	a0,s1
    800008aa:	598010ef          	jal	ra,80001e42 <wakeup>
    
    WriteReg(THR, c);
    800008ae:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    800008b2:	609c                	ld	a5,0(s1)
    800008b4:	0009b703          	ld	a4,0(s3)
    800008b8:	fcf71ce3          	bne	a4,a5,80000890 <uartstart+0x42>
      ReadReg(ISR);
    800008bc:	100007b7          	lui	a5,0x10000
    800008c0:	0027c783          	lbu	a5,2(a5) # 10000002 <_entry-0x6ffffffe>
  }
}
    800008c4:	70e2                	ld	ra,56(sp)
    800008c6:	7442                	ld	s0,48(sp)
    800008c8:	74a2                	ld	s1,40(sp)
    800008ca:	7902                	ld	s2,32(sp)
    800008cc:	69e2                	ld	s3,24(sp)
    800008ce:	6a42                	ld	s4,16(sp)
    800008d0:	6aa2                	ld	s5,8(sp)
    800008d2:	6121                	addi	sp,sp,64
    800008d4:	8082                	ret
      ReadReg(ISR);
    800008d6:	100007b7          	lui	a5,0x10000
    800008da:	0027c783          	lbu	a5,2(a5) # 10000002 <_entry-0x6ffffffe>
      return;
    800008de:	8082                	ret

00000000800008e0 <uartputc>:
{
    800008e0:	7179                	addi	sp,sp,-48
    800008e2:	f406                	sd	ra,40(sp)
    800008e4:	f022                	sd	s0,32(sp)
    800008e6:	ec26                	sd	s1,24(sp)
    800008e8:	e84a                	sd	s2,16(sp)
    800008ea:	e44e                	sd	s3,8(sp)
    800008ec:	e052                	sd	s4,0(sp)
    800008ee:	1800                	addi	s0,sp,48
    800008f0:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    800008f2:	0000f517          	auipc	a0,0xf
    800008f6:	10650513          	addi	a0,a0,262 # 8000f9f8 <uart_tx_lock>
    800008fa:	29e000ef          	jal	ra,80000b98 <acquire>
  if(panicked){
    800008fe:	00007797          	auipc	a5,0x7
    80000902:	ff27a783          	lw	a5,-14(a5) # 800078f0 <panicked>
    80000906:	efbd                	bnez	a5,80000984 <uartputc+0xa4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000908:	00007717          	auipc	a4,0x7
    8000090c:	ff873703          	ld	a4,-8(a4) # 80007900 <uart_tx_w>
    80000910:	00007797          	auipc	a5,0x7
    80000914:	fe87b783          	ld	a5,-24(a5) # 800078f8 <uart_tx_r>
    80000918:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    8000091c:	0000f997          	auipc	s3,0xf
    80000920:	0dc98993          	addi	s3,s3,220 # 8000f9f8 <uart_tx_lock>
    80000924:	00007497          	auipc	s1,0x7
    80000928:	fd448493          	addi	s1,s1,-44 # 800078f8 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000092c:	00007917          	auipc	s2,0x7
    80000930:	fd490913          	addi	s2,s2,-44 # 80007900 <uart_tx_w>
    80000934:	00e79d63          	bne	a5,a4,8000094e <uartputc+0x6e>
    sleep(&uart_tx_r, &uart_tx_lock);
    80000938:	85ce                	mv	a1,s3
    8000093a:	8526                	mv	a0,s1
    8000093c:	4ba010ef          	jal	ra,80001df6 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000940:	00093703          	ld	a4,0(s2)
    80000944:	609c                	ld	a5,0(s1)
    80000946:	02078793          	addi	a5,a5,32
    8000094a:	fee787e3          	beq	a5,a4,80000938 <uartputc+0x58>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    8000094e:	0000f497          	auipc	s1,0xf
    80000952:	0aa48493          	addi	s1,s1,170 # 8000f9f8 <uart_tx_lock>
    80000956:	01f77793          	andi	a5,a4,31
    8000095a:	97a6                	add	a5,a5,s1
    8000095c:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    80000960:	0705                	addi	a4,a4,1
    80000962:	00007797          	auipc	a5,0x7
    80000966:	f8e7bf23          	sd	a4,-98(a5) # 80007900 <uart_tx_w>
  uartstart();
    8000096a:	ee5ff0ef          	jal	ra,8000084e <uartstart>
  release(&uart_tx_lock);
    8000096e:	8526                	mv	a0,s1
    80000970:	2c0000ef          	jal	ra,80000c30 <release>
}
    80000974:	70a2                	ld	ra,40(sp)
    80000976:	7402                	ld	s0,32(sp)
    80000978:	64e2                	ld	s1,24(sp)
    8000097a:	6942                	ld	s2,16(sp)
    8000097c:	69a2                	ld	s3,8(sp)
    8000097e:	6a02                	ld	s4,0(sp)
    80000980:	6145                	addi	sp,sp,48
    80000982:	8082                	ret
    for(;;)
    80000984:	a001                	j	80000984 <uartputc+0xa4>

0000000080000986 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80000986:	1141                	addi	sp,sp,-16
    80000988:	e422                	sd	s0,8(sp)
    8000098a:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    8000098c:	100007b7          	lui	a5,0x10000
    80000990:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80000994:	8b85                	andi	a5,a5,1
    80000996:	cb81                	beqz	a5,800009a6 <uartgetc+0x20>
    // input data is ready.
    return ReadReg(RHR);
    80000998:	100007b7          	lui	a5,0x10000
    8000099c:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    800009a0:	6422                	ld	s0,8(sp)
    800009a2:	0141                	addi	sp,sp,16
    800009a4:	8082                	ret
    return -1;
    800009a6:	557d                	li	a0,-1
    800009a8:	bfe5                	j	800009a0 <uartgetc+0x1a>

00000000800009aa <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    800009aa:	1101                	addi	sp,sp,-32
    800009ac:	ec06                	sd	ra,24(sp)
    800009ae:	e822                	sd	s0,16(sp)
    800009b0:	e426                	sd	s1,8(sp)
    800009b2:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800009b4:	54fd                	li	s1,-1
    800009b6:	a019                	j	800009bc <uartintr+0x12>
      break;
    consoleintr(c);
    800009b8:	8a3ff0ef          	jal	ra,8000025a <consoleintr>
    int c = uartgetc();
    800009bc:	fcbff0ef          	jal	ra,80000986 <uartgetc>
    if(c == -1)
    800009c0:	fe951ce3          	bne	a0,s1,800009b8 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800009c4:	0000f497          	auipc	s1,0xf
    800009c8:	03448493          	addi	s1,s1,52 # 8000f9f8 <uart_tx_lock>
    800009cc:	8526                	mv	a0,s1
    800009ce:	1ca000ef          	jal	ra,80000b98 <acquire>
  uartstart();
    800009d2:	e7dff0ef          	jal	ra,8000084e <uartstart>
  release(&uart_tx_lock);
    800009d6:	8526                	mv	a0,s1
    800009d8:	258000ef          	jal	ra,80000c30 <release>
}
    800009dc:	60e2                	ld	ra,24(sp)
    800009de:	6442                	ld	s0,16(sp)
    800009e0:	64a2                	ld	s1,8(sp)
    800009e2:	6105                	addi	sp,sp,32
    800009e4:	8082                	ret

00000000800009e6 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    800009e6:	1101                	addi	sp,sp,-32
    800009e8:	ec06                	sd	ra,24(sp)
    800009ea:	e822                	sd	s0,16(sp)
    800009ec:	e426                	sd	s1,8(sp)
    800009ee:	e04a                	sd	s2,0(sp)
    800009f0:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    800009f2:	03451793          	slli	a5,a0,0x34
    800009f6:	e7a9                	bnez	a5,80000a40 <kfree+0x5a>
    800009f8:	84aa                	mv	s1,a0
    800009fa:	00020797          	auipc	a5,0x20
    800009fe:	26678793          	addi	a5,a5,614 # 80020c60 <end>
    80000a02:	02f56f63          	bltu	a0,a5,80000a40 <kfree+0x5a>
    80000a06:	47c5                	li	a5,17
    80000a08:	07ee                	slli	a5,a5,0x1b
    80000a0a:	02f57b63          	bgeu	a0,a5,80000a40 <kfree+0x5a>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000a0e:	6605                	lui	a2,0x1
    80000a10:	4585                	li	a1,1
    80000a12:	25a000ef          	jal	ra,80000c6c <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000a16:	0000f917          	auipc	s2,0xf
    80000a1a:	01a90913          	addi	s2,s2,26 # 8000fa30 <kmem>
    80000a1e:	854a                	mv	a0,s2
    80000a20:	178000ef          	jal	ra,80000b98 <acquire>
  r->next = kmem.freelist;
    80000a24:	01893783          	ld	a5,24(s2)
    80000a28:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000a2a:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000a2e:	854a                	mv	a0,s2
    80000a30:	200000ef          	jal	ra,80000c30 <release>
}
    80000a34:	60e2                	ld	ra,24(sp)
    80000a36:	6442                	ld	s0,16(sp)
    80000a38:	64a2                	ld	s1,8(sp)
    80000a3a:	6902                	ld	s2,0(sp)
    80000a3c:	6105                	addi	sp,sp,32
    80000a3e:	8082                	ret
    panic("kfree");
    80000a40:	00006517          	auipc	a0,0x6
    80000a44:	61850513          	addi	a0,a0,1560 # 80007058 <digits+0x20>
    80000a48:	d0fff0ef          	jal	ra,80000756 <panic>

0000000080000a4c <freerange>:
{
    80000a4c:	7179                	addi	sp,sp,-48
    80000a4e:	f406                	sd	ra,40(sp)
    80000a50:	f022                	sd	s0,32(sp)
    80000a52:	ec26                	sd	s1,24(sp)
    80000a54:	e84a                	sd	s2,16(sp)
    80000a56:	e44e                	sd	s3,8(sp)
    80000a58:	e052                	sd	s4,0(sp)
    80000a5a:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000a5c:	6785                	lui	a5,0x1
    80000a5e:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000a62:	00e504b3          	add	s1,a0,a4
    80000a66:	777d                	lui	a4,0xfffff
    80000a68:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000a6a:	94be                	add	s1,s1,a5
    80000a6c:	0095ec63          	bltu	a1,s1,80000a84 <freerange+0x38>
    80000a70:	892e                	mv	s2,a1
    kfree(p);
    80000a72:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000a74:	6985                	lui	s3,0x1
    kfree(p);
    80000a76:	01448533          	add	a0,s1,s4
    80000a7a:	f6dff0ef          	jal	ra,800009e6 <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000a7e:	94ce                	add	s1,s1,s3
    80000a80:	fe997be3          	bgeu	s2,s1,80000a76 <freerange+0x2a>
}
    80000a84:	70a2                	ld	ra,40(sp)
    80000a86:	7402                	ld	s0,32(sp)
    80000a88:	64e2                	ld	s1,24(sp)
    80000a8a:	6942                	ld	s2,16(sp)
    80000a8c:	69a2                	ld	s3,8(sp)
    80000a8e:	6a02                	ld	s4,0(sp)
    80000a90:	6145                	addi	sp,sp,48
    80000a92:	8082                	ret

0000000080000a94 <kinit>:
{
    80000a94:	1141                	addi	sp,sp,-16
    80000a96:	e406                	sd	ra,8(sp)
    80000a98:	e022                	sd	s0,0(sp)
    80000a9a:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000a9c:	00006597          	auipc	a1,0x6
    80000aa0:	5c458593          	addi	a1,a1,1476 # 80007060 <digits+0x28>
    80000aa4:	0000f517          	auipc	a0,0xf
    80000aa8:	f8c50513          	addi	a0,a0,-116 # 8000fa30 <kmem>
    80000aac:	06c000ef          	jal	ra,80000b18 <initlock>
  freerange(end, (void*)PHYSTOP);
    80000ab0:	45c5                	li	a1,17
    80000ab2:	05ee                	slli	a1,a1,0x1b
    80000ab4:	00020517          	auipc	a0,0x20
    80000ab8:	1ac50513          	addi	a0,a0,428 # 80020c60 <end>
    80000abc:	f91ff0ef          	jal	ra,80000a4c <freerange>
}
    80000ac0:	60a2                	ld	ra,8(sp)
    80000ac2:	6402                	ld	s0,0(sp)
    80000ac4:	0141                	addi	sp,sp,16
    80000ac6:	8082                	ret

0000000080000ac8 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000ac8:	1101                	addi	sp,sp,-32
    80000aca:	ec06                	sd	ra,24(sp)
    80000acc:	e822                	sd	s0,16(sp)
    80000ace:	e426                	sd	s1,8(sp)
    80000ad0:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000ad2:	0000f497          	auipc	s1,0xf
    80000ad6:	f5e48493          	addi	s1,s1,-162 # 8000fa30 <kmem>
    80000ada:	8526                	mv	a0,s1
    80000adc:	0bc000ef          	jal	ra,80000b98 <acquire>
  r = kmem.freelist;
    80000ae0:	6c84                	ld	s1,24(s1)
  if(r)
    80000ae2:	c485                	beqz	s1,80000b0a <kalloc+0x42>
    kmem.freelist = r->next;
    80000ae4:	609c                	ld	a5,0(s1)
    80000ae6:	0000f517          	auipc	a0,0xf
    80000aea:	f4a50513          	addi	a0,a0,-182 # 8000fa30 <kmem>
    80000aee:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000af0:	140000ef          	jal	ra,80000c30 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000af4:	6605                	lui	a2,0x1
    80000af6:	4595                	li	a1,5
    80000af8:	8526                	mv	a0,s1
    80000afa:	172000ef          	jal	ra,80000c6c <memset>
  return (void*)r;
}
    80000afe:	8526                	mv	a0,s1
    80000b00:	60e2                	ld	ra,24(sp)
    80000b02:	6442                	ld	s0,16(sp)
    80000b04:	64a2                	ld	s1,8(sp)
    80000b06:	6105                	addi	sp,sp,32
    80000b08:	8082                	ret
  release(&kmem.lock);
    80000b0a:	0000f517          	auipc	a0,0xf
    80000b0e:	f2650513          	addi	a0,a0,-218 # 8000fa30 <kmem>
    80000b12:	11e000ef          	jal	ra,80000c30 <release>
  if(r)
    80000b16:	b7e5                	j	80000afe <kalloc+0x36>

0000000080000b18 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000b18:	1141                	addi	sp,sp,-16
    80000b1a:	e422                	sd	s0,8(sp)
    80000b1c:	0800                	addi	s0,sp,16
  lk->name = name;
    80000b1e:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000b20:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000b24:	00053823          	sd	zero,16(a0)
}
    80000b28:	6422                	ld	s0,8(sp)
    80000b2a:	0141                	addi	sp,sp,16
    80000b2c:	8082                	ret

0000000080000b2e <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000b2e:	411c                	lw	a5,0(a0)
    80000b30:	e399                	bnez	a5,80000b36 <holding+0x8>
    80000b32:	4501                	li	a0,0
  return r;
}
    80000b34:	8082                	ret
{
    80000b36:	1101                	addi	sp,sp,-32
    80000b38:	ec06                	sd	ra,24(sp)
    80000b3a:	e822                	sd	s0,16(sp)
    80000b3c:	e426                	sd	s1,8(sp)
    80000b3e:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000b40:	6904                	ld	s1,16(a0)
    80000b42:	4cd000ef          	jal	ra,8000180e <mycpu>
    80000b46:	40a48533          	sub	a0,s1,a0
    80000b4a:	00153513          	seqz	a0,a0
}
    80000b4e:	60e2                	ld	ra,24(sp)
    80000b50:	6442                	ld	s0,16(sp)
    80000b52:	64a2                	ld	s1,8(sp)
    80000b54:	6105                	addi	sp,sp,32
    80000b56:	8082                	ret

0000000080000b58 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000b58:	1101                	addi	sp,sp,-32
    80000b5a:	ec06                	sd	ra,24(sp)
    80000b5c:	e822                	sd	s0,16(sp)
    80000b5e:	e426                	sd	s1,8(sp)
    80000b60:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000b62:	100024f3          	csrr	s1,sstatus
    80000b66:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000b6a:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000b6c:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80000b70:	49f000ef          	jal	ra,8000180e <mycpu>
    80000b74:	5d3c                	lw	a5,120(a0)
    80000b76:	cb99                	beqz	a5,80000b8c <push_off+0x34>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000b78:	497000ef          	jal	ra,8000180e <mycpu>
    80000b7c:	5d3c                	lw	a5,120(a0)
    80000b7e:	2785                	addiw	a5,a5,1
    80000b80:	dd3c                	sw	a5,120(a0)
}
    80000b82:	60e2                	ld	ra,24(sp)
    80000b84:	6442                	ld	s0,16(sp)
    80000b86:	64a2                	ld	s1,8(sp)
    80000b88:	6105                	addi	sp,sp,32
    80000b8a:	8082                	ret
    mycpu()->intena = old;
    80000b8c:	483000ef          	jal	ra,8000180e <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000b90:	8085                	srli	s1,s1,0x1
    80000b92:	8885                	andi	s1,s1,1
    80000b94:	dd64                	sw	s1,124(a0)
    80000b96:	b7cd                	j	80000b78 <push_off+0x20>

0000000080000b98 <acquire>:
{
    80000b98:	1101                	addi	sp,sp,-32
    80000b9a:	ec06                	sd	ra,24(sp)
    80000b9c:	e822                	sd	s0,16(sp)
    80000b9e:	e426                	sd	s1,8(sp)
    80000ba0:	1000                	addi	s0,sp,32
    80000ba2:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000ba4:	fb5ff0ef          	jal	ra,80000b58 <push_off>
  if(holding(lk))
    80000ba8:	8526                	mv	a0,s1
    80000baa:	f85ff0ef          	jal	ra,80000b2e <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000bae:	4705                	li	a4,1
  if(holding(lk))
    80000bb0:	e105                	bnez	a0,80000bd0 <acquire+0x38>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000bb2:	87ba                	mv	a5,a4
    80000bb4:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000bb8:	2781                	sext.w	a5,a5
    80000bba:	ffe5                	bnez	a5,80000bb2 <acquire+0x1a>
  __sync_synchronize();
    80000bbc:	0ff0000f          	fence
  lk->cpu = mycpu();
    80000bc0:	44f000ef          	jal	ra,8000180e <mycpu>
    80000bc4:	e888                	sd	a0,16(s1)
}
    80000bc6:	60e2                	ld	ra,24(sp)
    80000bc8:	6442                	ld	s0,16(sp)
    80000bca:	64a2                	ld	s1,8(sp)
    80000bcc:	6105                	addi	sp,sp,32
    80000bce:	8082                	ret
    panic("acquire");
    80000bd0:	00006517          	auipc	a0,0x6
    80000bd4:	49850513          	addi	a0,a0,1176 # 80007068 <digits+0x30>
    80000bd8:	b7fff0ef          	jal	ra,80000756 <panic>

0000000080000bdc <pop_off>:

void
pop_off(void)
{
    80000bdc:	1141                	addi	sp,sp,-16
    80000bde:	e406                	sd	ra,8(sp)
    80000be0:	e022                	sd	s0,0(sp)
    80000be2:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000be4:	42b000ef          	jal	ra,8000180e <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000be8:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000bec:	8b89                	andi	a5,a5,2
  if(intr_get())
    80000bee:	e78d                	bnez	a5,80000c18 <pop_off+0x3c>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000bf0:	5d3c                	lw	a5,120(a0)
    80000bf2:	02f05963          	blez	a5,80000c24 <pop_off+0x48>
    panic("pop_off");
  c->noff -= 1;
    80000bf6:	37fd                	addiw	a5,a5,-1
    80000bf8:	0007871b          	sext.w	a4,a5
    80000bfc:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000bfe:	eb09                	bnez	a4,80000c10 <pop_off+0x34>
    80000c00:	5d7c                	lw	a5,124(a0)
    80000c02:	c799                	beqz	a5,80000c10 <pop_off+0x34>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c04:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000c08:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000c0c:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000c10:	60a2                	ld	ra,8(sp)
    80000c12:	6402                	ld	s0,0(sp)
    80000c14:	0141                	addi	sp,sp,16
    80000c16:	8082                	ret
    panic("pop_off - interruptible");
    80000c18:	00006517          	auipc	a0,0x6
    80000c1c:	45850513          	addi	a0,a0,1112 # 80007070 <digits+0x38>
    80000c20:	b37ff0ef          	jal	ra,80000756 <panic>
    panic("pop_off");
    80000c24:	00006517          	auipc	a0,0x6
    80000c28:	46450513          	addi	a0,a0,1124 # 80007088 <digits+0x50>
    80000c2c:	b2bff0ef          	jal	ra,80000756 <panic>

0000000080000c30 <release>:
{
    80000c30:	1101                	addi	sp,sp,-32
    80000c32:	ec06                	sd	ra,24(sp)
    80000c34:	e822                	sd	s0,16(sp)
    80000c36:	e426                	sd	s1,8(sp)
    80000c38:	1000                	addi	s0,sp,32
    80000c3a:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000c3c:	ef3ff0ef          	jal	ra,80000b2e <holding>
    80000c40:	c105                	beqz	a0,80000c60 <release+0x30>
  lk->cpu = 0;
    80000c42:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000c46:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80000c4a:	0f50000f          	fence	iorw,ow
    80000c4e:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80000c52:	f8bff0ef          	jal	ra,80000bdc <pop_off>
}
    80000c56:	60e2                	ld	ra,24(sp)
    80000c58:	6442                	ld	s0,16(sp)
    80000c5a:	64a2                	ld	s1,8(sp)
    80000c5c:	6105                	addi	sp,sp,32
    80000c5e:	8082                	ret
    panic("release");
    80000c60:	00006517          	auipc	a0,0x6
    80000c64:	43050513          	addi	a0,a0,1072 # 80007090 <digits+0x58>
    80000c68:	aefff0ef          	jal	ra,80000756 <panic>

0000000080000c6c <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000c6c:	1141                	addi	sp,sp,-16
    80000c6e:	e422                	sd	s0,8(sp)
    80000c70:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000c72:	ca19                	beqz	a2,80000c88 <memset+0x1c>
    80000c74:	87aa                	mv	a5,a0
    80000c76:	1602                	slli	a2,a2,0x20
    80000c78:	9201                	srli	a2,a2,0x20
    80000c7a:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000c7e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000c82:	0785                	addi	a5,a5,1
    80000c84:	fee79de3          	bne	a5,a4,80000c7e <memset+0x12>
  }
  return dst;
}
    80000c88:	6422                	ld	s0,8(sp)
    80000c8a:	0141                	addi	sp,sp,16
    80000c8c:	8082                	ret

0000000080000c8e <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000c8e:	1141                	addi	sp,sp,-16
    80000c90:	e422                	sd	s0,8(sp)
    80000c92:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000c94:	ca05                	beqz	a2,80000cc4 <memcmp+0x36>
    80000c96:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    80000c9a:	1682                	slli	a3,a3,0x20
    80000c9c:	9281                	srli	a3,a3,0x20
    80000c9e:	0685                	addi	a3,a3,1
    80000ca0:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000ca2:	00054783          	lbu	a5,0(a0)
    80000ca6:	0005c703          	lbu	a4,0(a1)
    80000caa:	00e79863          	bne	a5,a4,80000cba <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000cae:	0505                	addi	a0,a0,1
    80000cb0:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000cb2:	fed518e3          	bne	a0,a3,80000ca2 <memcmp+0x14>
  }

  return 0;
    80000cb6:	4501                	li	a0,0
    80000cb8:	a019                	j	80000cbe <memcmp+0x30>
      return *s1 - *s2;
    80000cba:	40e7853b          	subw	a0,a5,a4
}
    80000cbe:	6422                	ld	s0,8(sp)
    80000cc0:	0141                	addi	sp,sp,16
    80000cc2:	8082                	ret
  return 0;
    80000cc4:	4501                	li	a0,0
    80000cc6:	bfe5                	j	80000cbe <memcmp+0x30>

0000000080000cc8 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000cc8:	1141                	addi	sp,sp,-16
    80000cca:	e422                	sd	s0,8(sp)
    80000ccc:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000cce:	c205                	beqz	a2,80000cee <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000cd0:	02a5e263          	bltu	a1,a0,80000cf4 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000cd4:	1602                	slli	a2,a2,0x20
    80000cd6:	9201                	srli	a2,a2,0x20
    80000cd8:	00c587b3          	add	a5,a1,a2
{
    80000cdc:	872a                	mv	a4,a0
      *d++ = *s++;
    80000cde:	0585                	addi	a1,a1,1
    80000ce0:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffde3a1>
    80000ce2:	fff5c683          	lbu	a3,-1(a1)
    80000ce6:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000cea:	fef59ae3          	bne	a1,a5,80000cde <memmove+0x16>

  return dst;
}
    80000cee:	6422                	ld	s0,8(sp)
    80000cf0:	0141                	addi	sp,sp,16
    80000cf2:	8082                	ret
  if(s < d && s + n > d){
    80000cf4:	02061693          	slli	a3,a2,0x20
    80000cf8:	9281                	srli	a3,a3,0x20
    80000cfa:	00d58733          	add	a4,a1,a3
    80000cfe:	fce57be3          	bgeu	a0,a4,80000cd4 <memmove+0xc>
    d += n;
    80000d02:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000d04:	fff6079b          	addiw	a5,a2,-1
    80000d08:	1782                	slli	a5,a5,0x20
    80000d0a:	9381                	srli	a5,a5,0x20
    80000d0c:	fff7c793          	not	a5,a5
    80000d10:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000d12:	177d                	addi	a4,a4,-1
    80000d14:	16fd                	addi	a3,a3,-1
    80000d16:	00074603          	lbu	a2,0(a4)
    80000d1a:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000d1e:	fee79ae3          	bne	a5,a4,80000d12 <memmove+0x4a>
    80000d22:	b7f1                	j	80000cee <memmove+0x26>

0000000080000d24 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000d24:	1141                	addi	sp,sp,-16
    80000d26:	e406                	sd	ra,8(sp)
    80000d28:	e022                	sd	s0,0(sp)
    80000d2a:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000d2c:	f9dff0ef          	jal	ra,80000cc8 <memmove>
}
    80000d30:	60a2                	ld	ra,8(sp)
    80000d32:	6402                	ld	s0,0(sp)
    80000d34:	0141                	addi	sp,sp,16
    80000d36:	8082                	ret

0000000080000d38 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000d38:	1141                	addi	sp,sp,-16
    80000d3a:	e422                	sd	s0,8(sp)
    80000d3c:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000d3e:	ce11                	beqz	a2,80000d5a <strncmp+0x22>
    80000d40:	00054783          	lbu	a5,0(a0)
    80000d44:	cf89                	beqz	a5,80000d5e <strncmp+0x26>
    80000d46:	0005c703          	lbu	a4,0(a1)
    80000d4a:	00f71a63          	bne	a4,a5,80000d5e <strncmp+0x26>
    n--, p++, q++;
    80000d4e:	367d                	addiw	a2,a2,-1
    80000d50:	0505                	addi	a0,a0,1
    80000d52:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000d54:	f675                	bnez	a2,80000d40 <strncmp+0x8>
  if(n == 0)
    return 0;
    80000d56:	4501                	li	a0,0
    80000d58:	a809                	j	80000d6a <strncmp+0x32>
    80000d5a:	4501                	li	a0,0
    80000d5c:	a039                	j	80000d6a <strncmp+0x32>
  if(n == 0)
    80000d5e:	ca09                	beqz	a2,80000d70 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000d60:	00054503          	lbu	a0,0(a0)
    80000d64:	0005c783          	lbu	a5,0(a1)
    80000d68:	9d1d                	subw	a0,a0,a5
}
    80000d6a:	6422                	ld	s0,8(sp)
    80000d6c:	0141                	addi	sp,sp,16
    80000d6e:	8082                	ret
    return 0;
    80000d70:	4501                	li	a0,0
    80000d72:	bfe5                	j	80000d6a <strncmp+0x32>

0000000080000d74 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000d74:	1141                	addi	sp,sp,-16
    80000d76:	e422                	sd	s0,8(sp)
    80000d78:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000d7a:	872a                	mv	a4,a0
    80000d7c:	8832                	mv	a6,a2
    80000d7e:	367d                	addiw	a2,a2,-1
    80000d80:	01005963          	blez	a6,80000d92 <strncpy+0x1e>
    80000d84:	0705                	addi	a4,a4,1
    80000d86:	0005c783          	lbu	a5,0(a1)
    80000d8a:	fef70fa3          	sb	a5,-1(a4)
    80000d8e:	0585                	addi	a1,a1,1
    80000d90:	f7f5                	bnez	a5,80000d7c <strncpy+0x8>
    ;
  while(n-- > 0)
    80000d92:	86ba                	mv	a3,a4
    80000d94:	00c05c63          	blez	a2,80000dac <strncpy+0x38>
    *s++ = 0;
    80000d98:	0685                	addi	a3,a3,1
    80000d9a:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    80000d9e:	40d707bb          	subw	a5,a4,a3
    80000da2:	37fd                	addiw	a5,a5,-1
    80000da4:	010787bb          	addw	a5,a5,a6
    80000da8:	fef048e3          	bgtz	a5,80000d98 <strncpy+0x24>
  return os;
}
    80000dac:	6422                	ld	s0,8(sp)
    80000dae:	0141                	addi	sp,sp,16
    80000db0:	8082                	ret

0000000080000db2 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000db2:	1141                	addi	sp,sp,-16
    80000db4:	e422                	sd	s0,8(sp)
    80000db6:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000db8:	02c05363          	blez	a2,80000dde <safestrcpy+0x2c>
    80000dbc:	fff6069b          	addiw	a3,a2,-1
    80000dc0:	1682                	slli	a3,a3,0x20
    80000dc2:	9281                	srli	a3,a3,0x20
    80000dc4:	96ae                	add	a3,a3,a1
    80000dc6:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000dc8:	00d58963          	beq	a1,a3,80000dda <safestrcpy+0x28>
    80000dcc:	0585                	addi	a1,a1,1
    80000dce:	0785                	addi	a5,a5,1
    80000dd0:	fff5c703          	lbu	a4,-1(a1)
    80000dd4:	fee78fa3          	sb	a4,-1(a5)
    80000dd8:	fb65                	bnez	a4,80000dc8 <safestrcpy+0x16>
    ;
  *s = 0;
    80000dda:	00078023          	sb	zero,0(a5)
  return os;
}
    80000dde:	6422                	ld	s0,8(sp)
    80000de0:	0141                	addi	sp,sp,16
    80000de2:	8082                	ret

0000000080000de4 <strlen>:

int
strlen(const char *s)
{
    80000de4:	1141                	addi	sp,sp,-16
    80000de6:	e422                	sd	s0,8(sp)
    80000de8:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000dea:	00054783          	lbu	a5,0(a0)
    80000dee:	cf91                	beqz	a5,80000e0a <strlen+0x26>
    80000df0:	0505                	addi	a0,a0,1
    80000df2:	87aa                	mv	a5,a0
    80000df4:	4685                	li	a3,1
    80000df6:	9e89                	subw	a3,a3,a0
    80000df8:	00f6853b          	addw	a0,a3,a5
    80000dfc:	0785                	addi	a5,a5,1
    80000dfe:	fff7c703          	lbu	a4,-1(a5)
    80000e02:	fb7d                	bnez	a4,80000df8 <strlen+0x14>
    ;
  return n;
}
    80000e04:	6422                	ld	s0,8(sp)
    80000e06:	0141                	addi	sp,sp,16
    80000e08:	8082                	ret
  for(n = 0; s[n]; n++)
    80000e0a:	4501                	li	a0,0
    80000e0c:	bfe5                	j	80000e04 <strlen+0x20>

0000000080000e0e <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000e0e:	1141                	addi	sp,sp,-16
    80000e10:	e406                	sd	ra,8(sp)
    80000e12:	e022                	sd	s0,0(sp)
    80000e14:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000e16:	1e9000ef          	jal	ra,800017fe <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000e1a:	00007717          	auipc	a4,0x7
    80000e1e:	aee70713          	addi	a4,a4,-1298 # 80007908 <started>
  if(cpuid() == 0){
    80000e22:	c51d                	beqz	a0,80000e50 <main+0x42>
    while(started == 0)
    80000e24:	431c                	lw	a5,0(a4)
    80000e26:	2781                	sext.w	a5,a5
    80000e28:	dff5                	beqz	a5,80000e24 <main+0x16>
      ;
    __sync_synchronize();
    80000e2a:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000e2e:	1d1000ef          	jal	ra,800017fe <cpuid>
    80000e32:	85aa                	mv	a1,a0
    80000e34:	00006517          	auipc	a0,0x6
    80000e38:	27c50513          	addi	a0,a0,636 # 800070b0 <digits+0x78>
    80000e3c:	e66ff0ef          	jal	ra,800004a2 <printf>
    kvminithart();    // turn on paging
    80000e40:	080000ef          	jal	ra,80000ec0 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000e44:	4d4010ef          	jal	ra,80002318 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000e48:	27c040ef          	jal	ra,800050c4 <plicinithart>
  }

  scheduler();        
    80000e4c:	611000ef          	jal	ra,80001c5c <scheduler>
    consoleinit();
    80000e50:	d7cff0ef          	jal	ra,800003cc <consoleinit>
    printfinit();
    80000e54:	93dff0ef          	jal	ra,80000790 <printfinit>
    printf("\n");
    80000e58:	00006517          	auipc	a0,0x6
    80000e5c:	26850513          	addi	a0,a0,616 # 800070c0 <digits+0x88>
    80000e60:	e42ff0ef          	jal	ra,800004a2 <printf>
    printf("xv6 kernel is booting\n");
    80000e64:	00006517          	auipc	a0,0x6
    80000e68:	23450513          	addi	a0,a0,564 # 80007098 <digits+0x60>
    80000e6c:	e36ff0ef          	jal	ra,800004a2 <printf>
    printf("\n");
    80000e70:	00006517          	auipc	a0,0x6
    80000e74:	25050513          	addi	a0,a0,592 # 800070c0 <digits+0x88>
    80000e78:	e2aff0ef          	jal	ra,800004a2 <printf>
    kinit();         // physical page allocator
    80000e7c:	c19ff0ef          	jal	ra,80000a94 <kinit>
    kvminit();       // create kernel page table
    80000e80:	2ca000ef          	jal	ra,8000114a <kvminit>
    kvminithart();   // turn on paging
    80000e84:	03c000ef          	jal	ra,80000ec0 <kvminithart>
    procinit();      // process table
    80000e88:	0cf000ef          	jal	ra,80001756 <procinit>
    trapinit();      // trap vectors
    80000e8c:	468010ef          	jal	ra,800022f4 <trapinit>
    trapinithart();  // install kernel trap vector
    80000e90:	488010ef          	jal	ra,80002318 <trapinithart>
    plicinit();      // set up interrupt controller
    80000e94:	21a040ef          	jal	ra,800050ae <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000e98:	22c040ef          	jal	ra,800050c4 <plicinithart>
    binit();         // buffer cache
    80000e9c:	2a7010ef          	jal	ra,80002942 <binit>
    iinit();         // inode table
    80000ea0:	082020ef          	jal	ra,80002f22 <iinit>
    fileinit();      // file table
    80000ea4:	625020ef          	jal	ra,80003cc8 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000ea8:	30c040ef          	jal	ra,800051b4 <virtio_disk_init>
    userinit();      // first user process
    80000eac:	3e7000ef          	jal	ra,80001a92 <userinit>
    __sync_synchronize();
    80000eb0:	0ff0000f          	fence
    started = 1;
    80000eb4:	4785                	li	a5,1
    80000eb6:	00007717          	auipc	a4,0x7
    80000eba:	a4f72923          	sw	a5,-1454(a4) # 80007908 <started>
    80000ebe:	b779                	j	80000e4c <main+0x3e>

0000000080000ec0 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000ec0:	1141                	addi	sp,sp,-16
    80000ec2:	e422                	sd	s0,8(sp)
    80000ec4:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000ec6:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80000eca:	00007797          	auipc	a5,0x7
    80000ece:	a467b783          	ld	a5,-1466(a5) # 80007910 <kernel_pagetable>
    80000ed2:	83b1                	srli	a5,a5,0xc
    80000ed4:	577d                	li	a4,-1
    80000ed6:	177e                	slli	a4,a4,0x3f
    80000ed8:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000eda:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    80000ede:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80000ee2:	6422                	ld	s0,8(sp)
    80000ee4:	0141                	addi	sp,sp,16
    80000ee6:	8082                	ret

0000000080000ee8 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000ee8:	7139                	addi	sp,sp,-64
    80000eea:	fc06                	sd	ra,56(sp)
    80000eec:	f822                	sd	s0,48(sp)
    80000eee:	f426                	sd	s1,40(sp)
    80000ef0:	f04a                	sd	s2,32(sp)
    80000ef2:	ec4e                	sd	s3,24(sp)
    80000ef4:	e852                	sd	s4,16(sp)
    80000ef6:	e456                	sd	s5,8(sp)
    80000ef8:	e05a                	sd	s6,0(sp)
    80000efa:	0080                	addi	s0,sp,64
    80000efc:	84aa                	mv	s1,a0
    80000efe:	89ae                	mv	s3,a1
    80000f00:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000f02:	57fd                	li	a5,-1
    80000f04:	83e9                	srli	a5,a5,0x1a
    80000f06:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000f08:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000f0a:	02b7fc63          	bgeu	a5,a1,80000f42 <walk+0x5a>
    panic("walk");
    80000f0e:	00006517          	auipc	a0,0x6
    80000f12:	1ba50513          	addi	a0,a0,442 # 800070c8 <digits+0x90>
    80000f16:	841ff0ef          	jal	ra,80000756 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000f1a:	060a8263          	beqz	s5,80000f7e <walk+0x96>
    80000f1e:	babff0ef          	jal	ra,80000ac8 <kalloc>
    80000f22:	84aa                	mv	s1,a0
    80000f24:	c139                	beqz	a0,80000f6a <walk+0x82>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80000f26:	6605                	lui	a2,0x1
    80000f28:	4581                	li	a1,0
    80000f2a:	d43ff0ef          	jal	ra,80000c6c <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80000f2e:	00c4d793          	srli	a5,s1,0xc
    80000f32:	07aa                	slli	a5,a5,0xa
    80000f34:	0017e793          	ori	a5,a5,1
    80000f38:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80000f3c:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffde397>
    80000f3e:	036a0063          	beq	s4,s6,80000f5e <walk+0x76>
    pte_t *pte = &pagetable[PX(level, va)];
    80000f42:	0149d933          	srl	s2,s3,s4
    80000f46:	1ff97913          	andi	s2,s2,511
    80000f4a:	090e                	slli	s2,s2,0x3
    80000f4c:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80000f4e:	00093483          	ld	s1,0(s2)
    80000f52:	0014f793          	andi	a5,s1,1
    80000f56:	d3f1                	beqz	a5,80000f1a <walk+0x32>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000f58:	80a9                	srli	s1,s1,0xa
    80000f5a:	04b2                	slli	s1,s1,0xc
    80000f5c:	b7c5                	j	80000f3c <walk+0x54>
    }
  }
  return &pagetable[PX(0, va)];
    80000f5e:	00c9d513          	srli	a0,s3,0xc
    80000f62:	1ff57513          	andi	a0,a0,511
    80000f66:	050e                	slli	a0,a0,0x3
    80000f68:	9526                	add	a0,a0,s1
}
    80000f6a:	70e2                	ld	ra,56(sp)
    80000f6c:	7442                	ld	s0,48(sp)
    80000f6e:	74a2                	ld	s1,40(sp)
    80000f70:	7902                	ld	s2,32(sp)
    80000f72:	69e2                	ld	s3,24(sp)
    80000f74:	6a42                	ld	s4,16(sp)
    80000f76:	6aa2                	ld	s5,8(sp)
    80000f78:	6b02                	ld	s6,0(sp)
    80000f7a:	6121                	addi	sp,sp,64
    80000f7c:	8082                	ret
        return 0;
    80000f7e:	4501                	li	a0,0
    80000f80:	b7ed                	j	80000f6a <walk+0x82>

0000000080000f82 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000f82:	57fd                	li	a5,-1
    80000f84:	83e9                	srli	a5,a5,0x1a
    80000f86:	00b7f463          	bgeu	a5,a1,80000f8e <walkaddr+0xc>
    return 0;
    80000f8a:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000f8c:	8082                	ret
{
    80000f8e:	1141                	addi	sp,sp,-16
    80000f90:	e406                	sd	ra,8(sp)
    80000f92:	e022                	sd	s0,0(sp)
    80000f94:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000f96:	4601                	li	a2,0
    80000f98:	f51ff0ef          	jal	ra,80000ee8 <walk>
  if(pte == 0)
    80000f9c:	c105                	beqz	a0,80000fbc <walkaddr+0x3a>
  if((*pte & PTE_V) == 0)
    80000f9e:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000fa0:	0117f693          	andi	a3,a5,17
    80000fa4:	4745                	li	a4,17
    return 0;
    80000fa6:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000fa8:	00e68663          	beq	a3,a4,80000fb4 <walkaddr+0x32>
}
    80000fac:	60a2                	ld	ra,8(sp)
    80000fae:	6402                	ld	s0,0(sp)
    80000fb0:	0141                	addi	sp,sp,16
    80000fb2:	8082                	ret
  pa = PTE2PA(*pte);
    80000fb4:	83a9                	srli	a5,a5,0xa
    80000fb6:	00c79513          	slli	a0,a5,0xc
  return pa;
    80000fba:	bfcd                	j	80000fac <walkaddr+0x2a>
    return 0;
    80000fbc:	4501                	li	a0,0
    80000fbe:	b7fd                	j	80000fac <walkaddr+0x2a>

0000000080000fc0 <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000fc0:	715d                	addi	sp,sp,-80
    80000fc2:	e486                	sd	ra,72(sp)
    80000fc4:	e0a2                	sd	s0,64(sp)
    80000fc6:	fc26                	sd	s1,56(sp)
    80000fc8:	f84a                	sd	s2,48(sp)
    80000fca:	f44e                	sd	s3,40(sp)
    80000fcc:	f052                	sd	s4,32(sp)
    80000fce:	ec56                	sd	s5,24(sp)
    80000fd0:	e85a                	sd	s6,16(sp)
    80000fd2:	e45e                	sd	s7,8(sp)
    80000fd4:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000fd6:	03459793          	slli	a5,a1,0x34
    80000fda:	e7a9                	bnez	a5,80001024 <mappages+0x64>
    80000fdc:	8aaa                	mv	s5,a0
    80000fde:	8b3a                	mv	s6,a4
    panic("mappages: va not aligned");

  if((size % PGSIZE) != 0)
    80000fe0:	03461793          	slli	a5,a2,0x34
    80000fe4:	e7b1                	bnez	a5,80001030 <mappages+0x70>
    panic("mappages: size not aligned");

  if(size == 0)
    80000fe6:	ca39                	beqz	a2,8000103c <mappages+0x7c>
    panic("mappages: size");
  
  a = va;
  last = va + size - PGSIZE;
    80000fe8:	77fd                	lui	a5,0xfffff
    80000fea:	963e                	add	a2,a2,a5
    80000fec:	00b609b3          	add	s3,a2,a1
  a = va;
    80000ff0:	892e                	mv	s2,a1
    80000ff2:	40b68a33          	sub	s4,a3,a1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80000ff6:	6b85                	lui	s7,0x1
    80000ff8:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    80000ffc:	4605                	li	a2,1
    80000ffe:	85ca                	mv	a1,s2
    80001000:	8556                	mv	a0,s5
    80001002:	ee7ff0ef          	jal	ra,80000ee8 <walk>
    80001006:	c539                	beqz	a0,80001054 <mappages+0x94>
    if(*pte & PTE_V)
    80001008:	611c                	ld	a5,0(a0)
    8000100a:	8b85                	andi	a5,a5,1
    8000100c:	ef95                	bnez	a5,80001048 <mappages+0x88>
    *pte = PA2PTE(pa) | perm | PTE_V;
    8000100e:	80b1                	srli	s1,s1,0xc
    80001010:	04aa                	slli	s1,s1,0xa
    80001012:	0164e4b3          	or	s1,s1,s6
    80001016:	0014e493          	ori	s1,s1,1
    8000101a:	e104                	sd	s1,0(a0)
    if(a == last)
    8000101c:	05390863          	beq	s2,s3,8000106c <mappages+0xac>
    a += PGSIZE;
    80001020:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    80001022:	bfd9                	j	80000ff8 <mappages+0x38>
    panic("mappages: va not aligned");
    80001024:	00006517          	auipc	a0,0x6
    80001028:	0ac50513          	addi	a0,a0,172 # 800070d0 <digits+0x98>
    8000102c:	f2aff0ef          	jal	ra,80000756 <panic>
    panic("mappages: size not aligned");
    80001030:	00006517          	auipc	a0,0x6
    80001034:	0c050513          	addi	a0,a0,192 # 800070f0 <digits+0xb8>
    80001038:	f1eff0ef          	jal	ra,80000756 <panic>
    panic("mappages: size");
    8000103c:	00006517          	auipc	a0,0x6
    80001040:	0d450513          	addi	a0,a0,212 # 80007110 <digits+0xd8>
    80001044:	f12ff0ef          	jal	ra,80000756 <panic>
      panic("mappages: remap");
    80001048:	00006517          	auipc	a0,0x6
    8000104c:	0d850513          	addi	a0,a0,216 # 80007120 <digits+0xe8>
    80001050:	f06ff0ef          	jal	ra,80000756 <panic>
      return -1;
    80001054:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    80001056:	60a6                	ld	ra,72(sp)
    80001058:	6406                	ld	s0,64(sp)
    8000105a:	74e2                	ld	s1,56(sp)
    8000105c:	7942                	ld	s2,48(sp)
    8000105e:	79a2                	ld	s3,40(sp)
    80001060:	7a02                	ld	s4,32(sp)
    80001062:	6ae2                	ld	s5,24(sp)
    80001064:	6b42                	ld	s6,16(sp)
    80001066:	6ba2                	ld	s7,8(sp)
    80001068:	6161                	addi	sp,sp,80
    8000106a:	8082                	ret
  return 0;
    8000106c:	4501                	li	a0,0
    8000106e:	b7e5                	j	80001056 <mappages+0x96>

0000000080001070 <kvmmap>:
{
    80001070:	1141                	addi	sp,sp,-16
    80001072:	e406                	sd	ra,8(sp)
    80001074:	e022                	sd	s0,0(sp)
    80001076:	0800                	addi	s0,sp,16
    80001078:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    8000107a:	86b2                	mv	a3,a2
    8000107c:	863e                	mv	a2,a5
    8000107e:	f43ff0ef          	jal	ra,80000fc0 <mappages>
    80001082:	e509                	bnez	a0,8000108c <kvmmap+0x1c>
}
    80001084:	60a2                	ld	ra,8(sp)
    80001086:	6402                	ld	s0,0(sp)
    80001088:	0141                	addi	sp,sp,16
    8000108a:	8082                	ret
    panic("kvmmap");
    8000108c:	00006517          	auipc	a0,0x6
    80001090:	0a450513          	addi	a0,a0,164 # 80007130 <digits+0xf8>
    80001094:	ec2ff0ef          	jal	ra,80000756 <panic>

0000000080001098 <kvmmake>:
{
    80001098:	1101                	addi	sp,sp,-32
    8000109a:	ec06                	sd	ra,24(sp)
    8000109c:	e822                	sd	s0,16(sp)
    8000109e:	e426                	sd	s1,8(sp)
    800010a0:	e04a                	sd	s2,0(sp)
    800010a2:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    800010a4:	a25ff0ef          	jal	ra,80000ac8 <kalloc>
    800010a8:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    800010aa:	6605                	lui	a2,0x1
    800010ac:	4581                	li	a1,0
    800010ae:	bbfff0ef          	jal	ra,80000c6c <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    800010b2:	4719                	li	a4,6
    800010b4:	6685                	lui	a3,0x1
    800010b6:	10000637          	lui	a2,0x10000
    800010ba:	100005b7          	lui	a1,0x10000
    800010be:	8526                	mv	a0,s1
    800010c0:	fb1ff0ef          	jal	ra,80001070 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    800010c4:	4719                	li	a4,6
    800010c6:	6685                	lui	a3,0x1
    800010c8:	10001637          	lui	a2,0x10001
    800010cc:	100015b7          	lui	a1,0x10001
    800010d0:	8526                	mv	a0,s1
    800010d2:	f9fff0ef          	jal	ra,80001070 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    800010d6:	4719                	li	a4,6
    800010d8:	040006b7          	lui	a3,0x4000
    800010dc:	0c000637          	lui	a2,0xc000
    800010e0:	0c0005b7          	lui	a1,0xc000
    800010e4:	8526                	mv	a0,s1
    800010e6:	f8bff0ef          	jal	ra,80001070 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800010ea:	00006917          	auipc	s2,0x6
    800010ee:	f1690913          	addi	s2,s2,-234 # 80007000 <etext>
    800010f2:	4729                	li	a4,10
    800010f4:	80006697          	auipc	a3,0x80006
    800010f8:	f0c68693          	addi	a3,a3,-244 # 7000 <_entry-0x7fff9000>
    800010fc:	4605                	li	a2,1
    800010fe:	067e                	slli	a2,a2,0x1f
    80001100:	85b2                	mv	a1,a2
    80001102:	8526                	mv	a0,s1
    80001104:	f6dff0ef          	jal	ra,80001070 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    80001108:	4719                	li	a4,6
    8000110a:	46c5                	li	a3,17
    8000110c:	06ee                	slli	a3,a3,0x1b
    8000110e:	412686b3          	sub	a3,a3,s2
    80001112:	864a                	mv	a2,s2
    80001114:	85ca                	mv	a1,s2
    80001116:	8526                	mv	a0,s1
    80001118:	f59ff0ef          	jal	ra,80001070 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    8000111c:	4729                	li	a4,10
    8000111e:	6685                	lui	a3,0x1
    80001120:	00005617          	auipc	a2,0x5
    80001124:	ee060613          	addi	a2,a2,-288 # 80006000 <_trampoline>
    80001128:	040005b7          	lui	a1,0x4000
    8000112c:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    8000112e:	05b2                	slli	a1,a1,0xc
    80001130:	8526                	mv	a0,s1
    80001132:	f3fff0ef          	jal	ra,80001070 <kvmmap>
  proc_mapstacks(kpgtbl);
    80001136:	8526                	mv	a0,s1
    80001138:	594000ef          	jal	ra,800016cc <proc_mapstacks>
}
    8000113c:	8526                	mv	a0,s1
    8000113e:	60e2                	ld	ra,24(sp)
    80001140:	6442                	ld	s0,16(sp)
    80001142:	64a2                	ld	s1,8(sp)
    80001144:	6902                	ld	s2,0(sp)
    80001146:	6105                	addi	sp,sp,32
    80001148:	8082                	ret

000000008000114a <kvminit>:
{
    8000114a:	1141                	addi	sp,sp,-16
    8000114c:	e406                	sd	ra,8(sp)
    8000114e:	e022                	sd	s0,0(sp)
    80001150:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    80001152:	f47ff0ef          	jal	ra,80001098 <kvmmake>
    80001156:	00006797          	auipc	a5,0x6
    8000115a:	7aa7bd23          	sd	a0,1978(a5) # 80007910 <kernel_pagetable>
}
    8000115e:	60a2                	ld	ra,8(sp)
    80001160:	6402                	ld	s0,0(sp)
    80001162:	0141                	addi	sp,sp,16
    80001164:	8082                	ret

0000000080001166 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80001166:	715d                	addi	sp,sp,-80
    80001168:	e486                	sd	ra,72(sp)
    8000116a:	e0a2                	sd	s0,64(sp)
    8000116c:	fc26                	sd	s1,56(sp)
    8000116e:	f84a                	sd	s2,48(sp)
    80001170:	f44e                	sd	s3,40(sp)
    80001172:	f052                	sd	s4,32(sp)
    80001174:	ec56                	sd	s5,24(sp)
    80001176:	e85a                	sd	s6,16(sp)
    80001178:	e45e                	sd	s7,8(sp)
    8000117a:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    8000117c:	03459793          	slli	a5,a1,0x34
    80001180:	e795                	bnez	a5,800011ac <uvmunmap+0x46>
    80001182:	8a2a                	mv	s4,a0
    80001184:	892e                	mv	s2,a1
    80001186:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001188:	0632                	slli	a2,a2,0xc
    8000118a:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    8000118e:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001190:	6b05                	lui	s6,0x1
    80001192:	0535ea63          	bltu	a1,s3,800011e6 <uvmunmap+0x80>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    80001196:	60a6                	ld	ra,72(sp)
    80001198:	6406                	ld	s0,64(sp)
    8000119a:	74e2                	ld	s1,56(sp)
    8000119c:	7942                	ld	s2,48(sp)
    8000119e:	79a2                	ld	s3,40(sp)
    800011a0:	7a02                	ld	s4,32(sp)
    800011a2:	6ae2                	ld	s5,24(sp)
    800011a4:	6b42                	ld	s6,16(sp)
    800011a6:	6ba2                	ld	s7,8(sp)
    800011a8:	6161                	addi	sp,sp,80
    800011aa:	8082                	ret
    panic("uvmunmap: not aligned");
    800011ac:	00006517          	auipc	a0,0x6
    800011b0:	f8c50513          	addi	a0,a0,-116 # 80007138 <digits+0x100>
    800011b4:	da2ff0ef          	jal	ra,80000756 <panic>
      panic("uvmunmap: walk");
    800011b8:	00006517          	auipc	a0,0x6
    800011bc:	f9850513          	addi	a0,a0,-104 # 80007150 <digits+0x118>
    800011c0:	d96ff0ef          	jal	ra,80000756 <panic>
      panic("uvmunmap: not mapped");
    800011c4:	00006517          	auipc	a0,0x6
    800011c8:	f9c50513          	addi	a0,a0,-100 # 80007160 <digits+0x128>
    800011cc:	d8aff0ef          	jal	ra,80000756 <panic>
      panic("uvmunmap: not a leaf");
    800011d0:	00006517          	auipc	a0,0x6
    800011d4:	fa850513          	addi	a0,a0,-88 # 80007178 <digits+0x140>
    800011d8:	d7eff0ef          	jal	ra,80000756 <panic>
    *pte = 0;
    800011dc:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800011e0:	995a                	add	s2,s2,s6
    800011e2:	fb397ae3          	bgeu	s2,s3,80001196 <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    800011e6:	4601                	li	a2,0
    800011e8:	85ca                	mv	a1,s2
    800011ea:	8552                	mv	a0,s4
    800011ec:	cfdff0ef          	jal	ra,80000ee8 <walk>
    800011f0:	84aa                	mv	s1,a0
    800011f2:	d179                	beqz	a0,800011b8 <uvmunmap+0x52>
    if((*pte & PTE_V) == 0)
    800011f4:	6108                	ld	a0,0(a0)
    800011f6:	00157793          	andi	a5,a0,1
    800011fa:	d7e9                	beqz	a5,800011c4 <uvmunmap+0x5e>
    if(PTE_FLAGS(*pte) == PTE_V)
    800011fc:	3ff57793          	andi	a5,a0,1023
    80001200:	fd7788e3          	beq	a5,s7,800011d0 <uvmunmap+0x6a>
    if(do_free){
    80001204:	fc0a8ce3          	beqz	s5,800011dc <uvmunmap+0x76>
      uint64 pa = PTE2PA(*pte);
    80001208:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    8000120a:	0532                	slli	a0,a0,0xc
    8000120c:	fdaff0ef          	jal	ra,800009e6 <kfree>
    80001210:	b7f1                	j	800011dc <uvmunmap+0x76>

0000000080001212 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80001212:	1101                	addi	sp,sp,-32
    80001214:	ec06                	sd	ra,24(sp)
    80001216:	e822                	sd	s0,16(sp)
    80001218:	e426                	sd	s1,8(sp)
    8000121a:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    8000121c:	8adff0ef          	jal	ra,80000ac8 <kalloc>
    80001220:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001222:	c509                	beqz	a0,8000122c <uvmcreate+0x1a>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80001224:	6605                	lui	a2,0x1
    80001226:	4581                	li	a1,0
    80001228:	a45ff0ef          	jal	ra,80000c6c <memset>
  return pagetable;
}
    8000122c:	8526                	mv	a0,s1
    8000122e:	60e2                	ld	ra,24(sp)
    80001230:	6442                	ld	s0,16(sp)
    80001232:	64a2                	ld	s1,8(sp)
    80001234:	6105                	addi	sp,sp,32
    80001236:	8082                	ret

0000000080001238 <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    80001238:	7179                	addi	sp,sp,-48
    8000123a:	f406                	sd	ra,40(sp)
    8000123c:	f022                	sd	s0,32(sp)
    8000123e:	ec26                	sd	s1,24(sp)
    80001240:	e84a                	sd	s2,16(sp)
    80001242:	e44e                	sd	s3,8(sp)
    80001244:	e052                	sd	s4,0(sp)
    80001246:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80001248:	6785                	lui	a5,0x1
    8000124a:	04f67063          	bgeu	a2,a5,8000128a <uvmfirst+0x52>
    8000124e:	8a2a                	mv	s4,a0
    80001250:	89ae                	mv	s3,a1
    80001252:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    80001254:	875ff0ef          	jal	ra,80000ac8 <kalloc>
    80001258:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    8000125a:	6605                	lui	a2,0x1
    8000125c:	4581                	li	a1,0
    8000125e:	a0fff0ef          	jal	ra,80000c6c <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80001262:	4779                	li	a4,30
    80001264:	86ca                	mv	a3,s2
    80001266:	6605                	lui	a2,0x1
    80001268:	4581                	li	a1,0
    8000126a:	8552                	mv	a0,s4
    8000126c:	d55ff0ef          	jal	ra,80000fc0 <mappages>
  memmove(mem, src, sz);
    80001270:	8626                	mv	a2,s1
    80001272:	85ce                	mv	a1,s3
    80001274:	854a                	mv	a0,s2
    80001276:	a53ff0ef          	jal	ra,80000cc8 <memmove>
}
    8000127a:	70a2                	ld	ra,40(sp)
    8000127c:	7402                	ld	s0,32(sp)
    8000127e:	64e2                	ld	s1,24(sp)
    80001280:	6942                	ld	s2,16(sp)
    80001282:	69a2                	ld	s3,8(sp)
    80001284:	6a02                	ld	s4,0(sp)
    80001286:	6145                	addi	sp,sp,48
    80001288:	8082                	ret
    panic("uvmfirst: more than a page");
    8000128a:	00006517          	auipc	a0,0x6
    8000128e:	f0650513          	addi	a0,a0,-250 # 80007190 <digits+0x158>
    80001292:	cc4ff0ef          	jal	ra,80000756 <panic>

0000000080001296 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80001296:	1101                	addi	sp,sp,-32
    80001298:	ec06                	sd	ra,24(sp)
    8000129a:	e822                	sd	s0,16(sp)
    8000129c:	e426                	sd	s1,8(sp)
    8000129e:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800012a0:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800012a2:	00b67d63          	bgeu	a2,a1,800012bc <uvmdealloc+0x26>
    800012a6:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800012a8:	6785                	lui	a5,0x1
    800012aa:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800012ac:	00f60733          	add	a4,a2,a5
    800012b0:	76fd                	lui	a3,0xfffff
    800012b2:	8f75                	and	a4,a4,a3
    800012b4:	97ae                	add	a5,a5,a1
    800012b6:	8ff5                	and	a5,a5,a3
    800012b8:	00f76863          	bltu	a4,a5,800012c8 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800012bc:	8526                	mv	a0,s1
    800012be:	60e2                	ld	ra,24(sp)
    800012c0:	6442                	ld	s0,16(sp)
    800012c2:	64a2                	ld	s1,8(sp)
    800012c4:	6105                	addi	sp,sp,32
    800012c6:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800012c8:	8f99                	sub	a5,a5,a4
    800012ca:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800012cc:	4685                	li	a3,1
    800012ce:	0007861b          	sext.w	a2,a5
    800012d2:	85ba                	mv	a1,a4
    800012d4:	e93ff0ef          	jal	ra,80001166 <uvmunmap>
    800012d8:	b7d5                	j	800012bc <uvmdealloc+0x26>

00000000800012da <uvmalloc>:
  if(newsz < oldsz)
    800012da:	08b66963          	bltu	a2,a1,8000136c <uvmalloc+0x92>
{
    800012de:	7139                	addi	sp,sp,-64
    800012e0:	fc06                	sd	ra,56(sp)
    800012e2:	f822                	sd	s0,48(sp)
    800012e4:	f426                	sd	s1,40(sp)
    800012e6:	f04a                	sd	s2,32(sp)
    800012e8:	ec4e                	sd	s3,24(sp)
    800012ea:	e852                	sd	s4,16(sp)
    800012ec:	e456                	sd	s5,8(sp)
    800012ee:	e05a                	sd	s6,0(sp)
    800012f0:	0080                	addi	s0,sp,64
    800012f2:	8aaa                	mv	s5,a0
    800012f4:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800012f6:	6785                	lui	a5,0x1
    800012f8:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800012fa:	95be                	add	a1,a1,a5
    800012fc:	77fd                	lui	a5,0xfffff
    800012fe:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001302:	06c9f763          	bgeu	s3,a2,80001370 <uvmalloc+0x96>
    80001306:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80001308:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    8000130c:	fbcff0ef          	jal	ra,80000ac8 <kalloc>
    80001310:	84aa                	mv	s1,a0
    if(mem == 0){
    80001312:	c11d                	beqz	a0,80001338 <uvmalloc+0x5e>
    memset(mem, 0, PGSIZE);
    80001314:	6605                	lui	a2,0x1
    80001316:	4581                	li	a1,0
    80001318:	955ff0ef          	jal	ra,80000c6c <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    8000131c:	875a                	mv	a4,s6
    8000131e:	86a6                	mv	a3,s1
    80001320:	6605                	lui	a2,0x1
    80001322:	85ca                	mv	a1,s2
    80001324:	8556                	mv	a0,s5
    80001326:	c9bff0ef          	jal	ra,80000fc0 <mappages>
    8000132a:	e51d                	bnez	a0,80001358 <uvmalloc+0x7e>
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000132c:	6785                	lui	a5,0x1
    8000132e:	993e                	add	s2,s2,a5
    80001330:	fd496ee3          	bltu	s2,s4,8000130c <uvmalloc+0x32>
  return newsz;
    80001334:	8552                	mv	a0,s4
    80001336:	a039                	j	80001344 <uvmalloc+0x6a>
      uvmdealloc(pagetable, a, oldsz);
    80001338:	864e                	mv	a2,s3
    8000133a:	85ca                	mv	a1,s2
    8000133c:	8556                	mv	a0,s5
    8000133e:	f59ff0ef          	jal	ra,80001296 <uvmdealloc>
      return 0;
    80001342:	4501                	li	a0,0
}
    80001344:	70e2                	ld	ra,56(sp)
    80001346:	7442                	ld	s0,48(sp)
    80001348:	74a2                	ld	s1,40(sp)
    8000134a:	7902                	ld	s2,32(sp)
    8000134c:	69e2                	ld	s3,24(sp)
    8000134e:	6a42                	ld	s4,16(sp)
    80001350:	6aa2                	ld	s5,8(sp)
    80001352:	6b02                	ld	s6,0(sp)
    80001354:	6121                	addi	sp,sp,64
    80001356:	8082                	ret
      kfree(mem);
    80001358:	8526                	mv	a0,s1
    8000135a:	e8cff0ef          	jal	ra,800009e6 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    8000135e:	864e                	mv	a2,s3
    80001360:	85ca                	mv	a1,s2
    80001362:	8556                	mv	a0,s5
    80001364:	f33ff0ef          	jal	ra,80001296 <uvmdealloc>
      return 0;
    80001368:	4501                	li	a0,0
    8000136a:	bfe9                	j	80001344 <uvmalloc+0x6a>
    return oldsz;
    8000136c:	852e                	mv	a0,a1
}
    8000136e:	8082                	ret
  return newsz;
    80001370:	8532                	mv	a0,a2
    80001372:	bfc9                	j	80001344 <uvmalloc+0x6a>

0000000080001374 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80001374:	7179                	addi	sp,sp,-48
    80001376:	f406                	sd	ra,40(sp)
    80001378:	f022                	sd	s0,32(sp)
    8000137a:	ec26                	sd	s1,24(sp)
    8000137c:	e84a                	sd	s2,16(sp)
    8000137e:	e44e                	sd	s3,8(sp)
    80001380:	e052                	sd	s4,0(sp)
    80001382:	1800                	addi	s0,sp,48
    80001384:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80001386:	84aa                	mv	s1,a0
    80001388:	6905                	lui	s2,0x1
    8000138a:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    8000138c:	4985                	li	s3,1
    8000138e:	a819                	j	800013a4 <freewalk+0x30>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80001390:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    80001392:	00c79513          	slli	a0,a5,0xc
    80001396:	fdfff0ef          	jal	ra,80001374 <freewalk>
      pagetable[i] = 0;
    8000139a:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    8000139e:	04a1                	addi	s1,s1,8
    800013a0:	01248f63          	beq	s1,s2,800013be <freewalk+0x4a>
    pte_t pte = pagetable[i];
    800013a4:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800013a6:	00f7f713          	andi	a4,a5,15
    800013aa:	ff3703e3          	beq	a4,s3,80001390 <freewalk+0x1c>
    } else if(pte & PTE_V){
    800013ae:	8b85                	andi	a5,a5,1
    800013b0:	d7fd                	beqz	a5,8000139e <freewalk+0x2a>
      panic("freewalk: leaf");
    800013b2:	00006517          	auipc	a0,0x6
    800013b6:	dfe50513          	addi	a0,a0,-514 # 800071b0 <digits+0x178>
    800013ba:	b9cff0ef          	jal	ra,80000756 <panic>
    }
  }
  kfree((void*)pagetable);
    800013be:	8552                	mv	a0,s4
    800013c0:	e26ff0ef          	jal	ra,800009e6 <kfree>
}
    800013c4:	70a2                	ld	ra,40(sp)
    800013c6:	7402                	ld	s0,32(sp)
    800013c8:	64e2                	ld	s1,24(sp)
    800013ca:	6942                	ld	s2,16(sp)
    800013cc:	69a2                	ld	s3,8(sp)
    800013ce:	6a02                	ld	s4,0(sp)
    800013d0:	6145                	addi	sp,sp,48
    800013d2:	8082                	ret

00000000800013d4 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800013d4:	1101                	addi	sp,sp,-32
    800013d6:	ec06                	sd	ra,24(sp)
    800013d8:	e822                	sd	s0,16(sp)
    800013da:	e426                	sd	s1,8(sp)
    800013dc:	1000                	addi	s0,sp,32
    800013de:	84aa                	mv	s1,a0
  if(sz > 0)
    800013e0:	e989                	bnez	a1,800013f2 <uvmfree+0x1e>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800013e2:	8526                	mv	a0,s1
    800013e4:	f91ff0ef          	jal	ra,80001374 <freewalk>
}
    800013e8:	60e2                	ld	ra,24(sp)
    800013ea:	6442                	ld	s0,16(sp)
    800013ec:	64a2                	ld	s1,8(sp)
    800013ee:	6105                	addi	sp,sp,32
    800013f0:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800013f2:	6785                	lui	a5,0x1
    800013f4:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800013f6:	95be                	add	a1,a1,a5
    800013f8:	4685                	li	a3,1
    800013fa:	00c5d613          	srli	a2,a1,0xc
    800013fe:	4581                	li	a1,0
    80001400:	d67ff0ef          	jal	ra,80001166 <uvmunmap>
    80001404:	bff9                	j	800013e2 <uvmfree+0xe>

0000000080001406 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80001406:	c65d                	beqz	a2,800014b4 <uvmcopy+0xae>
{
    80001408:	715d                	addi	sp,sp,-80
    8000140a:	e486                	sd	ra,72(sp)
    8000140c:	e0a2                	sd	s0,64(sp)
    8000140e:	fc26                	sd	s1,56(sp)
    80001410:	f84a                	sd	s2,48(sp)
    80001412:	f44e                	sd	s3,40(sp)
    80001414:	f052                	sd	s4,32(sp)
    80001416:	ec56                	sd	s5,24(sp)
    80001418:	e85a                	sd	s6,16(sp)
    8000141a:	e45e                	sd	s7,8(sp)
    8000141c:	0880                	addi	s0,sp,80
    8000141e:	8b2a                	mv	s6,a0
    80001420:	8aae                	mv	s5,a1
    80001422:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80001424:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80001426:	4601                	li	a2,0
    80001428:	85ce                	mv	a1,s3
    8000142a:	855a                	mv	a0,s6
    8000142c:	abdff0ef          	jal	ra,80000ee8 <walk>
    80001430:	c121                	beqz	a0,80001470 <uvmcopy+0x6a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80001432:	6118                	ld	a4,0(a0)
    80001434:	00177793          	andi	a5,a4,1
    80001438:	c3b1                	beqz	a5,8000147c <uvmcopy+0x76>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    8000143a:	00a75593          	srli	a1,a4,0xa
    8000143e:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80001442:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80001446:	e82ff0ef          	jal	ra,80000ac8 <kalloc>
    8000144a:	892a                	mv	s2,a0
    8000144c:	c129                	beqz	a0,8000148e <uvmcopy+0x88>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    8000144e:	6605                	lui	a2,0x1
    80001450:	85de                	mv	a1,s7
    80001452:	877ff0ef          	jal	ra,80000cc8 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80001456:	8726                	mv	a4,s1
    80001458:	86ca                	mv	a3,s2
    8000145a:	6605                	lui	a2,0x1
    8000145c:	85ce                	mv	a1,s3
    8000145e:	8556                	mv	a0,s5
    80001460:	b61ff0ef          	jal	ra,80000fc0 <mappages>
    80001464:	e115                	bnez	a0,80001488 <uvmcopy+0x82>
  for(i = 0; i < sz; i += PGSIZE){
    80001466:	6785                	lui	a5,0x1
    80001468:	99be                	add	s3,s3,a5
    8000146a:	fb49eee3          	bltu	s3,s4,80001426 <uvmcopy+0x20>
    8000146e:	a805                	j	8000149e <uvmcopy+0x98>
      panic("uvmcopy: pte should exist");
    80001470:	00006517          	auipc	a0,0x6
    80001474:	d5050513          	addi	a0,a0,-688 # 800071c0 <digits+0x188>
    80001478:	adeff0ef          	jal	ra,80000756 <panic>
      panic("uvmcopy: page not present");
    8000147c:	00006517          	auipc	a0,0x6
    80001480:	d6450513          	addi	a0,a0,-668 # 800071e0 <digits+0x1a8>
    80001484:	ad2ff0ef          	jal	ra,80000756 <panic>
      kfree(mem);
    80001488:	854a                	mv	a0,s2
    8000148a:	d5cff0ef          	jal	ra,800009e6 <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    8000148e:	4685                	li	a3,1
    80001490:	00c9d613          	srli	a2,s3,0xc
    80001494:	4581                	li	a1,0
    80001496:	8556                	mv	a0,s5
    80001498:	ccfff0ef          	jal	ra,80001166 <uvmunmap>
  return -1;
    8000149c:	557d                	li	a0,-1
}
    8000149e:	60a6                	ld	ra,72(sp)
    800014a0:	6406                	ld	s0,64(sp)
    800014a2:	74e2                	ld	s1,56(sp)
    800014a4:	7942                	ld	s2,48(sp)
    800014a6:	79a2                	ld	s3,40(sp)
    800014a8:	7a02                	ld	s4,32(sp)
    800014aa:	6ae2                	ld	s5,24(sp)
    800014ac:	6b42                	ld	s6,16(sp)
    800014ae:	6ba2                	ld	s7,8(sp)
    800014b0:	6161                	addi	sp,sp,80
    800014b2:	8082                	ret
  return 0;
    800014b4:	4501                	li	a0,0
}
    800014b6:	8082                	ret

00000000800014b8 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    800014b8:	1141                	addi	sp,sp,-16
    800014ba:	e406                	sd	ra,8(sp)
    800014bc:	e022                	sd	s0,0(sp)
    800014be:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    800014c0:	4601                	li	a2,0
    800014c2:	a27ff0ef          	jal	ra,80000ee8 <walk>
  if(pte == 0)
    800014c6:	c901                	beqz	a0,800014d6 <uvmclear+0x1e>
    panic("uvmclear");
  *pte &= ~PTE_U;
    800014c8:	611c                	ld	a5,0(a0)
    800014ca:	9bbd                	andi	a5,a5,-17
    800014cc:	e11c                	sd	a5,0(a0)
}
    800014ce:	60a2                	ld	ra,8(sp)
    800014d0:	6402                	ld	s0,0(sp)
    800014d2:	0141                	addi	sp,sp,16
    800014d4:	8082                	ret
    panic("uvmclear");
    800014d6:	00006517          	auipc	a0,0x6
    800014da:	d2a50513          	addi	a0,a0,-726 # 80007200 <digits+0x1c8>
    800014de:	a78ff0ef          	jal	ra,80000756 <panic>

00000000800014e2 <copyout>:
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;
  pte_t *pte;

  while(len > 0){
    800014e2:	c6c9                	beqz	a3,8000156c <copyout+0x8a>
{
    800014e4:	711d                	addi	sp,sp,-96
    800014e6:	ec86                	sd	ra,88(sp)
    800014e8:	e8a2                	sd	s0,80(sp)
    800014ea:	e4a6                	sd	s1,72(sp)
    800014ec:	e0ca                	sd	s2,64(sp)
    800014ee:	fc4e                	sd	s3,56(sp)
    800014f0:	f852                	sd	s4,48(sp)
    800014f2:	f456                	sd	s5,40(sp)
    800014f4:	f05a                	sd	s6,32(sp)
    800014f6:	ec5e                	sd	s7,24(sp)
    800014f8:	e862                	sd	s8,16(sp)
    800014fa:	e466                	sd	s9,8(sp)
    800014fc:	e06a                	sd	s10,0(sp)
    800014fe:	1080                	addi	s0,sp,96
    80001500:	8baa                	mv	s7,a0
    80001502:	8aae                	mv	s5,a1
    80001504:	8b32                	mv	s6,a2
    80001506:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80001508:	74fd                	lui	s1,0xfffff
    8000150a:	8ced                	and	s1,s1,a1
    if(va0 >= MAXVA)
    8000150c:	57fd                	li	a5,-1
    8000150e:	83e9                	srli	a5,a5,0x1a
    80001510:	0697e063          	bltu	a5,s1,80001570 <copyout+0x8e>
      return -1;
    pte = walk(pagetable, va0, 0);
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    80001514:	4cd5                	li	s9,21
    80001516:	6d05                	lui	s10,0x1
    if(va0 >= MAXVA)
    80001518:	8c3e                	mv	s8,a5
    8000151a:	a025                	j	80001542 <copyout+0x60>
       (*pte & PTE_W) == 0)
      return -1;
    pa0 = PTE2PA(*pte);
    8000151c:	83a9                	srli	a5,a5,0xa
    8000151e:	07b2                	slli	a5,a5,0xc
    n = PGSIZE - (dstva - va0);
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80001520:	409a8533          	sub	a0,s5,s1
    80001524:	0009061b          	sext.w	a2,s2
    80001528:	85da                	mv	a1,s6
    8000152a:	953e                	add	a0,a0,a5
    8000152c:	f9cff0ef          	jal	ra,80000cc8 <memmove>

    len -= n;
    80001530:	412989b3          	sub	s3,s3,s2
    src += n;
    80001534:	9b4a                	add	s6,s6,s2
  while(len > 0){
    80001536:	02098963          	beqz	s3,80001568 <copyout+0x86>
    if(va0 >= MAXVA)
    8000153a:	034c6d63          	bltu	s8,s4,80001574 <copyout+0x92>
    va0 = PGROUNDDOWN(dstva);
    8000153e:	84d2                	mv	s1,s4
    dstva = va0 + PGSIZE;
    80001540:	8ad2                	mv	s5,s4
    pte = walk(pagetable, va0, 0);
    80001542:	4601                	li	a2,0
    80001544:	85a6                	mv	a1,s1
    80001546:	855e                	mv	a0,s7
    80001548:	9a1ff0ef          	jal	ra,80000ee8 <walk>
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    8000154c:	c515                	beqz	a0,80001578 <copyout+0x96>
    8000154e:	611c                	ld	a5,0(a0)
    80001550:	0157f713          	andi	a4,a5,21
    80001554:	05971163          	bne	a4,s9,80001596 <copyout+0xb4>
    n = PGSIZE - (dstva - va0);
    80001558:	01a48a33          	add	s4,s1,s10
    8000155c:	415a0933          	sub	s2,s4,s5
    80001560:	fb29fee3          	bgeu	s3,s2,8000151c <copyout+0x3a>
    80001564:	894e                	mv	s2,s3
    80001566:	bf5d                	j	8000151c <copyout+0x3a>
  }
  return 0;
    80001568:	4501                	li	a0,0
    8000156a:	a801                	j	8000157a <copyout+0x98>
    8000156c:	4501                	li	a0,0
}
    8000156e:	8082                	ret
      return -1;
    80001570:	557d                	li	a0,-1
    80001572:	a021                	j	8000157a <copyout+0x98>
    80001574:	557d                	li	a0,-1
    80001576:	a011                	j	8000157a <copyout+0x98>
      return -1;
    80001578:	557d                	li	a0,-1
}
    8000157a:	60e6                	ld	ra,88(sp)
    8000157c:	6446                	ld	s0,80(sp)
    8000157e:	64a6                	ld	s1,72(sp)
    80001580:	6906                	ld	s2,64(sp)
    80001582:	79e2                	ld	s3,56(sp)
    80001584:	7a42                	ld	s4,48(sp)
    80001586:	7aa2                	ld	s5,40(sp)
    80001588:	7b02                	ld	s6,32(sp)
    8000158a:	6be2                	ld	s7,24(sp)
    8000158c:	6c42                	ld	s8,16(sp)
    8000158e:	6ca2                	ld	s9,8(sp)
    80001590:	6d02                	ld	s10,0(sp)
    80001592:	6125                	addi	sp,sp,96
    80001594:	8082                	ret
      return -1;
    80001596:	557d                	li	a0,-1
    80001598:	b7cd                	j	8000157a <copyout+0x98>

000000008000159a <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    8000159a:	c6a5                	beqz	a3,80001602 <copyin+0x68>
{
    8000159c:	715d                	addi	sp,sp,-80
    8000159e:	e486                	sd	ra,72(sp)
    800015a0:	e0a2                	sd	s0,64(sp)
    800015a2:	fc26                	sd	s1,56(sp)
    800015a4:	f84a                	sd	s2,48(sp)
    800015a6:	f44e                	sd	s3,40(sp)
    800015a8:	f052                	sd	s4,32(sp)
    800015aa:	ec56                	sd	s5,24(sp)
    800015ac:	e85a                	sd	s6,16(sp)
    800015ae:	e45e                	sd	s7,8(sp)
    800015b0:	e062                	sd	s8,0(sp)
    800015b2:	0880                	addi	s0,sp,80
    800015b4:	8b2a                	mv	s6,a0
    800015b6:	8a2e                	mv	s4,a1
    800015b8:	8c32                	mv	s8,a2
    800015ba:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    800015bc:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    800015be:	6a85                	lui	s5,0x1
    800015c0:	a00d                	j	800015e2 <copyin+0x48>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    800015c2:	018505b3          	add	a1,a0,s8
    800015c6:	0004861b          	sext.w	a2,s1
    800015ca:	412585b3          	sub	a1,a1,s2
    800015ce:	8552                	mv	a0,s4
    800015d0:	ef8ff0ef          	jal	ra,80000cc8 <memmove>

    len -= n;
    800015d4:	409989b3          	sub	s3,s3,s1
    dst += n;
    800015d8:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    800015da:	01590c33          	add	s8,s2,s5
  while(len > 0){
    800015de:	02098063          	beqz	s3,800015fe <copyin+0x64>
    va0 = PGROUNDDOWN(srcva);
    800015e2:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    800015e6:	85ca                	mv	a1,s2
    800015e8:	855a                	mv	a0,s6
    800015ea:	999ff0ef          	jal	ra,80000f82 <walkaddr>
    if(pa0 == 0)
    800015ee:	cd01                	beqz	a0,80001606 <copyin+0x6c>
    n = PGSIZE - (srcva - va0);
    800015f0:	418904b3          	sub	s1,s2,s8
    800015f4:	94d6                	add	s1,s1,s5
    800015f6:	fc99f6e3          	bgeu	s3,s1,800015c2 <copyin+0x28>
    800015fa:	84ce                	mv	s1,s3
    800015fc:	b7d9                	j	800015c2 <copyin+0x28>
  }
  return 0;
    800015fe:	4501                	li	a0,0
    80001600:	a021                	j	80001608 <copyin+0x6e>
    80001602:	4501                	li	a0,0
}
    80001604:	8082                	ret
      return -1;
    80001606:	557d                	li	a0,-1
}
    80001608:	60a6                	ld	ra,72(sp)
    8000160a:	6406                	ld	s0,64(sp)
    8000160c:	74e2                	ld	s1,56(sp)
    8000160e:	7942                	ld	s2,48(sp)
    80001610:	79a2                	ld	s3,40(sp)
    80001612:	7a02                	ld	s4,32(sp)
    80001614:	6ae2                	ld	s5,24(sp)
    80001616:	6b42                	ld	s6,16(sp)
    80001618:	6ba2                	ld	s7,8(sp)
    8000161a:	6c02                	ld	s8,0(sp)
    8000161c:	6161                	addi	sp,sp,80
    8000161e:	8082                	ret

0000000080001620 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80001620:	c2cd                	beqz	a3,800016c2 <copyinstr+0xa2>
{
    80001622:	715d                	addi	sp,sp,-80
    80001624:	e486                	sd	ra,72(sp)
    80001626:	e0a2                	sd	s0,64(sp)
    80001628:	fc26                	sd	s1,56(sp)
    8000162a:	f84a                	sd	s2,48(sp)
    8000162c:	f44e                	sd	s3,40(sp)
    8000162e:	f052                	sd	s4,32(sp)
    80001630:	ec56                	sd	s5,24(sp)
    80001632:	e85a                	sd	s6,16(sp)
    80001634:	e45e                	sd	s7,8(sp)
    80001636:	0880                	addi	s0,sp,80
    80001638:	8a2a                	mv	s4,a0
    8000163a:	8b2e                	mv	s6,a1
    8000163c:	8bb2                	mv	s7,a2
    8000163e:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80001640:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80001642:	6985                	lui	s3,0x1
    80001644:	a02d                	j	8000166e <copyinstr+0x4e>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80001646:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    8000164a:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    8000164c:	37fd                	addiw	a5,a5,-1
    8000164e:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80001652:	60a6                	ld	ra,72(sp)
    80001654:	6406                	ld	s0,64(sp)
    80001656:	74e2                	ld	s1,56(sp)
    80001658:	7942                	ld	s2,48(sp)
    8000165a:	79a2                	ld	s3,40(sp)
    8000165c:	7a02                	ld	s4,32(sp)
    8000165e:	6ae2                	ld	s5,24(sp)
    80001660:	6b42                	ld	s6,16(sp)
    80001662:	6ba2                	ld	s7,8(sp)
    80001664:	6161                	addi	sp,sp,80
    80001666:	8082                	ret
    srcva = va0 + PGSIZE;
    80001668:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    8000166c:	c4b9                	beqz	s1,800016ba <copyinstr+0x9a>
    va0 = PGROUNDDOWN(srcva);
    8000166e:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80001672:	85ca                	mv	a1,s2
    80001674:	8552                	mv	a0,s4
    80001676:	90dff0ef          	jal	ra,80000f82 <walkaddr>
    if(pa0 == 0)
    8000167a:	c131                	beqz	a0,800016be <copyinstr+0x9e>
    n = PGSIZE - (srcva - va0);
    8000167c:	417906b3          	sub	a3,s2,s7
    80001680:	96ce                	add	a3,a3,s3
    80001682:	00d4f363          	bgeu	s1,a3,80001688 <copyinstr+0x68>
    80001686:	86a6                	mv	a3,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80001688:	955e                	add	a0,a0,s7
    8000168a:	41250533          	sub	a0,a0,s2
    while(n > 0){
    8000168e:	dee9                	beqz	a3,80001668 <copyinstr+0x48>
    80001690:	87da                	mv	a5,s6
      if(*p == '\0'){
    80001692:	41650633          	sub	a2,a0,s6
    80001696:	fff48593          	addi	a1,s1,-1 # ffffffffffffefff <end+0xffffffff7ffde39f>
    8000169a:	95da                	add	a1,a1,s6
    while(n > 0){
    8000169c:	96da                	add	a3,a3,s6
      if(*p == '\0'){
    8000169e:	00f60733          	add	a4,a2,a5
    800016a2:	00074703          	lbu	a4,0(a4)
    800016a6:	d345                	beqz	a4,80001646 <copyinstr+0x26>
        *dst = *p;
    800016a8:	00e78023          	sb	a4,0(a5)
      --max;
    800016ac:	40f584b3          	sub	s1,a1,a5
      dst++;
    800016b0:	0785                	addi	a5,a5,1
    while(n > 0){
    800016b2:	fed796e3          	bne	a5,a3,8000169e <copyinstr+0x7e>
      dst++;
    800016b6:	8b3e                	mv	s6,a5
    800016b8:	bf45                	j	80001668 <copyinstr+0x48>
    800016ba:	4781                	li	a5,0
    800016bc:	bf41                	j	8000164c <copyinstr+0x2c>
      return -1;
    800016be:	557d                	li	a0,-1
    800016c0:	bf49                	j	80001652 <copyinstr+0x32>
  int got_null = 0;
    800016c2:	4781                	li	a5,0
  if(got_null){
    800016c4:	37fd                	addiw	a5,a5,-1
    800016c6:	0007851b          	sext.w	a0,a5
}
    800016ca:	8082                	ret

00000000800016cc <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    800016cc:	7139                	addi	sp,sp,-64
    800016ce:	fc06                	sd	ra,56(sp)
    800016d0:	f822                	sd	s0,48(sp)
    800016d2:	f426                	sd	s1,40(sp)
    800016d4:	f04a                	sd	s2,32(sp)
    800016d6:	ec4e                	sd	s3,24(sp)
    800016d8:	e852                	sd	s4,16(sp)
    800016da:	e456                	sd	s5,8(sp)
    800016dc:	e05a                	sd	s6,0(sp)
    800016de:	0080                	addi	s0,sp,64
    800016e0:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    800016e2:	0000e497          	auipc	s1,0xe
    800016e6:	79e48493          	addi	s1,s1,1950 # 8000fe80 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    800016ea:	8b26                	mv	s6,s1
    800016ec:	00006a97          	auipc	s5,0x6
    800016f0:	914a8a93          	addi	s5,s5,-1772 # 80007000 <etext>
    800016f4:	04000937          	lui	s2,0x4000
    800016f8:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    800016fa:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    800016fc:	00014a17          	auipc	s4,0x14
    80001700:	184a0a13          	addi	s4,s4,388 # 80015880 <tickslock>
    char *pa = kalloc();
    80001704:	bc4ff0ef          	jal	ra,80000ac8 <kalloc>
    80001708:	862a                	mv	a2,a0
    if(pa == 0)
    8000170a:	c121                	beqz	a0,8000174a <proc_mapstacks+0x7e>
    uint64 va = KSTACK((int) (p - proc));
    8000170c:	416485b3          	sub	a1,s1,s6
    80001710:	858d                	srai	a1,a1,0x3
    80001712:	000ab783          	ld	a5,0(s5)
    80001716:	02f585b3          	mul	a1,a1,a5
    8000171a:	2585                	addiw	a1,a1,1
    8000171c:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80001720:	4719                	li	a4,6
    80001722:	6685                	lui	a3,0x1
    80001724:	40b905b3          	sub	a1,s2,a1
    80001728:	854e                	mv	a0,s3
    8000172a:	947ff0ef          	jal	ra,80001070 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000172e:	16848493          	addi	s1,s1,360
    80001732:	fd4499e3          	bne	s1,s4,80001704 <proc_mapstacks+0x38>
  }
}
    80001736:	70e2                	ld	ra,56(sp)
    80001738:	7442                	ld	s0,48(sp)
    8000173a:	74a2                	ld	s1,40(sp)
    8000173c:	7902                	ld	s2,32(sp)
    8000173e:	69e2                	ld	s3,24(sp)
    80001740:	6a42                	ld	s4,16(sp)
    80001742:	6aa2                	ld	s5,8(sp)
    80001744:	6b02                	ld	s6,0(sp)
    80001746:	6121                	addi	sp,sp,64
    80001748:	8082                	ret
      panic("kalloc");
    8000174a:	00006517          	auipc	a0,0x6
    8000174e:	ac650513          	addi	a0,a0,-1338 # 80007210 <digits+0x1d8>
    80001752:	804ff0ef          	jal	ra,80000756 <panic>

0000000080001756 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80001756:	7139                	addi	sp,sp,-64
    80001758:	fc06                	sd	ra,56(sp)
    8000175a:	f822                	sd	s0,48(sp)
    8000175c:	f426                	sd	s1,40(sp)
    8000175e:	f04a                	sd	s2,32(sp)
    80001760:	ec4e                	sd	s3,24(sp)
    80001762:	e852                	sd	s4,16(sp)
    80001764:	e456                	sd	s5,8(sp)
    80001766:	e05a                	sd	s6,0(sp)
    80001768:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    8000176a:	00006597          	auipc	a1,0x6
    8000176e:	aae58593          	addi	a1,a1,-1362 # 80007218 <digits+0x1e0>
    80001772:	0000e517          	auipc	a0,0xe
    80001776:	2de50513          	addi	a0,a0,734 # 8000fa50 <pid_lock>
    8000177a:	b9eff0ef          	jal	ra,80000b18 <initlock>
  initlock(&wait_lock, "wait_lock");
    8000177e:	00006597          	auipc	a1,0x6
    80001782:	aa258593          	addi	a1,a1,-1374 # 80007220 <digits+0x1e8>
    80001786:	0000e517          	auipc	a0,0xe
    8000178a:	2e250513          	addi	a0,a0,738 # 8000fa68 <wait_lock>
    8000178e:	b8aff0ef          	jal	ra,80000b18 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001792:	0000e497          	auipc	s1,0xe
    80001796:	6ee48493          	addi	s1,s1,1774 # 8000fe80 <proc>
      initlock(&p->lock, "proc");
    8000179a:	00006b17          	auipc	s6,0x6
    8000179e:	a96b0b13          	addi	s6,s6,-1386 # 80007230 <digits+0x1f8>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    800017a2:	8aa6                	mv	s5,s1
    800017a4:	00006a17          	auipc	s4,0x6
    800017a8:	85ca0a13          	addi	s4,s4,-1956 # 80007000 <etext>
    800017ac:	04000937          	lui	s2,0x4000
    800017b0:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    800017b2:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    800017b4:	00014997          	auipc	s3,0x14
    800017b8:	0cc98993          	addi	s3,s3,204 # 80015880 <tickslock>
      initlock(&p->lock, "proc");
    800017bc:	85da                	mv	a1,s6
    800017be:	8526                	mv	a0,s1
    800017c0:	b58ff0ef          	jal	ra,80000b18 <initlock>
      p->state = UNUSED;
    800017c4:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    800017c8:	415487b3          	sub	a5,s1,s5
    800017cc:	878d                	srai	a5,a5,0x3
    800017ce:	000a3703          	ld	a4,0(s4)
    800017d2:	02e787b3          	mul	a5,a5,a4
    800017d6:	2785                	addiw	a5,a5,1
    800017d8:	00d7979b          	slliw	a5,a5,0xd
    800017dc:	40f907b3          	sub	a5,s2,a5
    800017e0:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    800017e2:	16848493          	addi	s1,s1,360
    800017e6:	fd349be3          	bne	s1,s3,800017bc <procinit+0x66>
  }
}
    800017ea:	70e2                	ld	ra,56(sp)
    800017ec:	7442                	ld	s0,48(sp)
    800017ee:	74a2                	ld	s1,40(sp)
    800017f0:	7902                	ld	s2,32(sp)
    800017f2:	69e2                	ld	s3,24(sp)
    800017f4:	6a42                	ld	s4,16(sp)
    800017f6:	6aa2                	ld	s5,8(sp)
    800017f8:	6b02                	ld	s6,0(sp)
    800017fa:	6121                	addi	sp,sp,64
    800017fc:	8082                	ret

00000000800017fe <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    800017fe:	1141                	addi	sp,sp,-16
    80001800:	e422                	sd	s0,8(sp)
    80001802:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80001804:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80001806:	2501                	sext.w	a0,a0
    80001808:	6422                	ld	s0,8(sp)
    8000180a:	0141                	addi	sp,sp,16
    8000180c:	8082                	ret

000000008000180e <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    8000180e:	1141                	addi	sp,sp,-16
    80001810:	e422                	sd	s0,8(sp)
    80001812:	0800                	addi	s0,sp,16
    80001814:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80001816:	2781                	sext.w	a5,a5
    80001818:	079e                	slli	a5,a5,0x7
  return c;
}
    8000181a:	0000e517          	auipc	a0,0xe
    8000181e:	26650513          	addi	a0,a0,614 # 8000fa80 <cpus>
    80001822:	953e                	add	a0,a0,a5
    80001824:	6422                	ld	s0,8(sp)
    80001826:	0141                	addi	sp,sp,16
    80001828:	8082                	ret

000000008000182a <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    8000182a:	1101                	addi	sp,sp,-32
    8000182c:	ec06                	sd	ra,24(sp)
    8000182e:	e822                	sd	s0,16(sp)
    80001830:	e426                	sd	s1,8(sp)
    80001832:	1000                	addi	s0,sp,32
  push_off();
    80001834:	b24ff0ef          	jal	ra,80000b58 <push_off>
    80001838:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    8000183a:	2781                	sext.w	a5,a5
    8000183c:	079e                	slli	a5,a5,0x7
    8000183e:	0000e717          	auipc	a4,0xe
    80001842:	21270713          	addi	a4,a4,530 # 8000fa50 <pid_lock>
    80001846:	97ba                	add	a5,a5,a4
    80001848:	7b84                	ld	s1,48(a5)
  pop_off();
    8000184a:	b92ff0ef          	jal	ra,80000bdc <pop_off>
  return p;
}
    8000184e:	8526                	mv	a0,s1
    80001850:	60e2                	ld	ra,24(sp)
    80001852:	6442                	ld	s0,16(sp)
    80001854:	64a2                	ld	s1,8(sp)
    80001856:	6105                	addi	sp,sp,32
    80001858:	8082                	ret

000000008000185a <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    8000185a:	1141                	addi	sp,sp,-16
    8000185c:	e406                	sd	ra,8(sp)
    8000185e:	e022                	sd	s0,0(sp)
    80001860:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80001862:	fc9ff0ef          	jal	ra,8000182a <myproc>
    80001866:	bcaff0ef          	jal	ra,80000c30 <release>

  if (first) {
    8000186a:	00006797          	auipc	a5,0x6
    8000186e:	0167a783          	lw	a5,22(a5) # 80007880 <first.1>
    80001872:	e799                	bnez	a5,80001880 <forkret+0x26>
    first = 0;
    // ensure other cores see first=0.
    __sync_synchronize();
  }

  usertrapret();
    80001874:	2bd000ef          	jal	ra,80002330 <usertrapret>
}
    80001878:	60a2                	ld	ra,8(sp)
    8000187a:	6402                	ld	s0,0(sp)
    8000187c:	0141                	addi	sp,sp,16
    8000187e:	8082                	ret
    fsinit(ROOTDEV);
    80001880:	4505                	li	a0,1
    80001882:	634010ef          	jal	ra,80002eb6 <fsinit>
    first = 0;
    80001886:	00006797          	auipc	a5,0x6
    8000188a:	fe07ad23          	sw	zero,-6(a5) # 80007880 <first.1>
    __sync_synchronize();
    8000188e:	0ff0000f          	fence
    80001892:	b7cd                	j	80001874 <forkret+0x1a>

0000000080001894 <allocpid>:
{
    80001894:	1101                	addi	sp,sp,-32
    80001896:	ec06                	sd	ra,24(sp)
    80001898:	e822                	sd	s0,16(sp)
    8000189a:	e426                	sd	s1,8(sp)
    8000189c:	e04a                	sd	s2,0(sp)
    8000189e:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    800018a0:	0000e917          	auipc	s2,0xe
    800018a4:	1b090913          	addi	s2,s2,432 # 8000fa50 <pid_lock>
    800018a8:	854a                	mv	a0,s2
    800018aa:	aeeff0ef          	jal	ra,80000b98 <acquire>
  pid = nextpid;
    800018ae:	00006797          	auipc	a5,0x6
    800018b2:	fd678793          	addi	a5,a5,-42 # 80007884 <nextpid>
    800018b6:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    800018b8:	0014871b          	addiw	a4,s1,1
    800018bc:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    800018be:	854a                	mv	a0,s2
    800018c0:	b70ff0ef          	jal	ra,80000c30 <release>
}
    800018c4:	8526                	mv	a0,s1
    800018c6:	60e2                	ld	ra,24(sp)
    800018c8:	6442                	ld	s0,16(sp)
    800018ca:	64a2                	ld	s1,8(sp)
    800018cc:	6902                	ld	s2,0(sp)
    800018ce:	6105                	addi	sp,sp,32
    800018d0:	8082                	ret

00000000800018d2 <proc_pagetable>:
{
    800018d2:	1101                	addi	sp,sp,-32
    800018d4:	ec06                	sd	ra,24(sp)
    800018d6:	e822                	sd	s0,16(sp)
    800018d8:	e426                	sd	s1,8(sp)
    800018da:	e04a                	sd	s2,0(sp)
    800018dc:	1000                	addi	s0,sp,32
    800018de:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    800018e0:	933ff0ef          	jal	ra,80001212 <uvmcreate>
    800018e4:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800018e6:	cd05                	beqz	a0,8000191e <proc_pagetable+0x4c>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    800018e8:	4729                	li	a4,10
    800018ea:	00004697          	auipc	a3,0x4
    800018ee:	71668693          	addi	a3,a3,1814 # 80006000 <_trampoline>
    800018f2:	6605                	lui	a2,0x1
    800018f4:	040005b7          	lui	a1,0x4000
    800018f8:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800018fa:	05b2                	slli	a1,a1,0xc
    800018fc:	ec4ff0ef          	jal	ra,80000fc0 <mappages>
    80001900:	02054663          	bltz	a0,8000192c <proc_pagetable+0x5a>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001904:	4719                	li	a4,6
    80001906:	05893683          	ld	a3,88(s2)
    8000190a:	6605                	lui	a2,0x1
    8000190c:	020005b7          	lui	a1,0x2000
    80001910:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001912:	05b6                	slli	a1,a1,0xd
    80001914:	8526                	mv	a0,s1
    80001916:	eaaff0ef          	jal	ra,80000fc0 <mappages>
    8000191a:	00054f63          	bltz	a0,80001938 <proc_pagetable+0x66>
}
    8000191e:	8526                	mv	a0,s1
    80001920:	60e2                	ld	ra,24(sp)
    80001922:	6442                	ld	s0,16(sp)
    80001924:	64a2                	ld	s1,8(sp)
    80001926:	6902                	ld	s2,0(sp)
    80001928:	6105                	addi	sp,sp,32
    8000192a:	8082                	ret
    uvmfree(pagetable, 0);
    8000192c:	4581                	li	a1,0
    8000192e:	8526                	mv	a0,s1
    80001930:	aa5ff0ef          	jal	ra,800013d4 <uvmfree>
    return 0;
    80001934:	4481                	li	s1,0
    80001936:	b7e5                	j	8000191e <proc_pagetable+0x4c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001938:	4681                	li	a3,0
    8000193a:	4605                	li	a2,1
    8000193c:	040005b7          	lui	a1,0x4000
    80001940:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001942:	05b2                	slli	a1,a1,0xc
    80001944:	8526                	mv	a0,s1
    80001946:	821ff0ef          	jal	ra,80001166 <uvmunmap>
    uvmfree(pagetable, 0);
    8000194a:	4581                	li	a1,0
    8000194c:	8526                	mv	a0,s1
    8000194e:	a87ff0ef          	jal	ra,800013d4 <uvmfree>
    return 0;
    80001952:	4481                	li	s1,0
    80001954:	b7e9                	j	8000191e <proc_pagetable+0x4c>

0000000080001956 <proc_freepagetable>:
{
    80001956:	1101                	addi	sp,sp,-32
    80001958:	ec06                	sd	ra,24(sp)
    8000195a:	e822                	sd	s0,16(sp)
    8000195c:	e426                	sd	s1,8(sp)
    8000195e:	e04a                	sd	s2,0(sp)
    80001960:	1000                	addi	s0,sp,32
    80001962:	84aa                	mv	s1,a0
    80001964:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001966:	4681                	li	a3,0
    80001968:	4605                	li	a2,1
    8000196a:	040005b7          	lui	a1,0x4000
    8000196e:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001970:	05b2                	slli	a1,a1,0xc
    80001972:	ff4ff0ef          	jal	ra,80001166 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001976:	4681                	li	a3,0
    80001978:	4605                	li	a2,1
    8000197a:	020005b7          	lui	a1,0x2000
    8000197e:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001980:	05b6                	slli	a1,a1,0xd
    80001982:	8526                	mv	a0,s1
    80001984:	fe2ff0ef          	jal	ra,80001166 <uvmunmap>
  uvmfree(pagetable, sz);
    80001988:	85ca                	mv	a1,s2
    8000198a:	8526                	mv	a0,s1
    8000198c:	a49ff0ef          	jal	ra,800013d4 <uvmfree>
}
    80001990:	60e2                	ld	ra,24(sp)
    80001992:	6442                	ld	s0,16(sp)
    80001994:	64a2                	ld	s1,8(sp)
    80001996:	6902                	ld	s2,0(sp)
    80001998:	6105                	addi	sp,sp,32
    8000199a:	8082                	ret

000000008000199c <freeproc>:
{
    8000199c:	1101                	addi	sp,sp,-32
    8000199e:	ec06                	sd	ra,24(sp)
    800019a0:	e822                	sd	s0,16(sp)
    800019a2:	e426                	sd	s1,8(sp)
    800019a4:	1000                	addi	s0,sp,32
    800019a6:	84aa                	mv	s1,a0
  if(p->trapframe)
    800019a8:	6d28                	ld	a0,88(a0)
    800019aa:	c119                	beqz	a0,800019b0 <freeproc+0x14>
    kfree((void*)p->trapframe);
    800019ac:	83aff0ef          	jal	ra,800009e6 <kfree>
  p->trapframe = 0;
    800019b0:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    800019b4:	68a8                	ld	a0,80(s1)
    800019b6:	c501                	beqz	a0,800019be <freeproc+0x22>
    proc_freepagetable(p->pagetable, p->sz);
    800019b8:	64ac                	ld	a1,72(s1)
    800019ba:	f9dff0ef          	jal	ra,80001956 <proc_freepagetable>
  p->pagetable = 0;
    800019be:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    800019c2:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    800019c6:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    800019ca:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    800019ce:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    800019d2:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    800019d6:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    800019da:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    800019de:	0004ac23          	sw	zero,24(s1)
}
    800019e2:	60e2                	ld	ra,24(sp)
    800019e4:	6442                	ld	s0,16(sp)
    800019e6:	64a2                	ld	s1,8(sp)
    800019e8:	6105                	addi	sp,sp,32
    800019ea:	8082                	ret

00000000800019ec <allocproc>:
{
    800019ec:	1101                	addi	sp,sp,-32
    800019ee:	ec06                	sd	ra,24(sp)
    800019f0:	e822                	sd	s0,16(sp)
    800019f2:	e426                	sd	s1,8(sp)
    800019f4:	e04a                	sd	s2,0(sp)
    800019f6:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    800019f8:	0000e497          	auipc	s1,0xe
    800019fc:	48848493          	addi	s1,s1,1160 # 8000fe80 <proc>
    80001a00:	00014917          	auipc	s2,0x14
    80001a04:	e8090913          	addi	s2,s2,-384 # 80015880 <tickslock>
    acquire(&p->lock);
    80001a08:	8526                	mv	a0,s1
    80001a0a:	98eff0ef          	jal	ra,80000b98 <acquire>
    if(p->state == UNUSED) {
    80001a0e:	4c9c                	lw	a5,24(s1)
    80001a10:	cb91                	beqz	a5,80001a24 <allocproc+0x38>
      release(&p->lock);
    80001a12:	8526                	mv	a0,s1
    80001a14:	a1cff0ef          	jal	ra,80000c30 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001a18:	16848493          	addi	s1,s1,360
    80001a1c:	ff2496e3          	bne	s1,s2,80001a08 <allocproc+0x1c>
  return 0;
    80001a20:	4481                	li	s1,0
    80001a22:	a089                	j	80001a64 <allocproc+0x78>
  p->pid = allocpid();
    80001a24:	e71ff0ef          	jal	ra,80001894 <allocpid>
    80001a28:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001a2a:	4785                	li	a5,1
    80001a2c:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001a2e:	89aff0ef          	jal	ra,80000ac8 <kalloc>
    80001a32:	892a                	mv	s2,a0
    80001a34:	eca8                	sd	a0,88(s1)
    80001a36:	cd15                	beqz	a0,80001a72 <allocproc+0x86>
  p->pagetable = proc_pagetable(p);
    80001a38:	8526                	mv	a0,s1
    80001a3a:	e99ff0ef          	jal	ra,800018d2 <proc_pagetable>
    80001a3e:	892a                	mv	s2,a0
    80001a40:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001a42:	c121                	beqz	a0,80001a82 <allocproc+0x96>
  memset(&p->context, 0, sizeof(p->context));
    80001a44:	07000613          	li	a2,112
    80001a48:	4581                	li	a1,0
    80001a4a:	06048513          	addi	a0,s1,96
    80001a4e:	a1eff0ef          	jal	ra,80000c6c <memset>
  p->context.ra = (uint64)forkret;
    80001a52:	00000797          	auipc	a5,0x0
    80001a56:	e0878793          	addi	a5,a5,-504 # 8000185a <forkret>
    80001a5a:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001a5c:	60bc                	ld	a5,64(s1)
    80001a5e:	6705                	lui	a4,0x1
    80001a60:	97ba                	add	a5,a5,a4
    80001a62:	f4bc                	sd	a5,104(s1)
}
    80001a64:	8526                	mv	a0,s1
    80001a66:	60e2                	ld	ra,24(sp)
    80001a68:	6442                	ld	s0,16(sp)
    80001a6a:	64a2                	ld	s1,8(sp)
    80001a6c:	6902                	ld	s2,0(sp)
    80001a6e:	6105                	addi	sp,sp,32
    80001a70:	8082                	ret
    freeproc(p);
    80001a72:	8526                	mv	a0,s1
    80001a74:	f29ff0ef          	jal	ra,8000199c <freeproc>
    release(&p->lock);
    80001a78:	8526                	mv	a0,s1
    80001a7a:	9b6ff0ef          	jal	ra,80000c30 <release>
    return 0;
    80001a7e:	84ca                	mv	s1,s2
    80001a80:	b7d5                	j	80001a64 <allocproc+0x78>
    freeproc(p);
    80001a82:	8526                	mv	a0,s1
    80001a84:	f19ff0ef          	jal	ra,8000199c <freeproc>
    release(&p->lock);
    80001a88:	8526                	mv	a0,s1
    80001a8a:	9a6ff0ef          	jal	ra,80000c30 <release>
    return 0;
    80001a8e:	84ca                	mv	s1,s2
    80001a90:	bfd1                	j	80001a64 <allocproc+0x78>

0000000080001a92 <userinit>:
{
    80001a92:	1101                	addi	sp,sp,-32
    80001a94:	ec06                	sd	ra,24(sp)
    80001a96:	e822                	sd	s0,16(sp)
    80001a98:	e426                	sd	s1,8(sp)
    80001a9a:	1000                	addi	s0,sp,32
  p = allocproc();
    80001a9c:	f51ff0ef          	jal	ra,800019ec <allocproc>
    80001aa0:	84aa                	mv	s1,a0
  initproc = p;
    80001aa2:	00006797          	auipc	a5,0x6
    80001aa6:	e6a7bb23          	sd	a0,-394(a5) # 80007918 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001aaa:	03400613          	li	a2,52
    80001aae:	00006597          	auipc	a1,0x6
    80001ab2:	de258593          	addi	a1,a1,-542 # 80007890 <initcode>
    80001ab6:	6928                	ld	a0,80(a0)
    80001ab8:	f80ff0ef          	jal	ra,80001238 <uvmfirst>
  p->sz = PGSIZE;
    80001abc:	6785                	lui	a5,0x1
    80001abe:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001ac0:	6cb8                	ld	a4,88(s1)
    80001ac2:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001ac6:	6cb8                	ld	a4,88(s1)
    80001ac8:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001aca:	4641                	li	a2,16
    80001acc:	00005597          	auipc	a1,0x5
    80001ad0:	76c58593          	addi	a1,a1,1900 # 80007238 <digits+0x200>
    80001ad4:	15848513          	addi	a0,s1,344
    80001ad8:	adaff0ef          	jal	ra,80000db2 <safestrcpy>
  p->cwd = namei("/");
    80001adc:	00005517          	auipc	a0,0x5
    80001ae0:	76c50513          	addi	a0,a0,1900 # 80007248 <digits+0x210>
    80001ae4:	4b9010ef          	jal	ra,8000379c <namei>
    80001ae8:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001aec:	478d                	li	a5,3
    80001aee:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001af0:	8526                	mv	a0,s1
    80001af2:	93eff0ef          	jal	ra,80000c30 <release>
}
    80001af6:	60e2                	ld	ra,24(sp)
    80001af8:	6442                	ld	s0,16(sp)
    80001afa:	64a2                	ld	s1,8(sp)
    80001afc:	6105                	addi	sp,sp,32
    80001afe:	8082                	ret

0000000080001b00 <growproc>:
{
    80001b00:	1101                	addi	sp,sp,-32
    80001b02:	ec06                	sd	ra,24(sp)
    80001b04:	e822                	sd	s0,16(sp)
    80001b06:	e426                	sd	s1,8(sp)
    80001b08:	e04a                	sd	s2,0(sp)
    80001b0a:	1000                	addi	s0,sp,32
    80001b0c:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001b0e:	d1dff0ef          	jal	ra,8000182a <myproc>
    80001b12:	84aa                	mv	s1,a0
  sz = p->sz;
    80001b14:	652c                	ld	a1,72(a0)
  if(n > 0){
    80001b16:	01204c63          	bgtz	s2,80001b2e <growproc+0x2e>
  } else if(n < 0){
    80001b1a:	02094463          	bltz	s2,80001b42 <growproc+0x42>
  p->sz = sz;
    80001b1e:	e4ac                	sd	a1,72(s1)
  return 0;
    80001b20:	4501                	li	a0,0
}
    80001b22:	60e2                	ld	ra,24(sp)
    80001b24:	6442                	ld	s0,16(sp)
    80001b26:	64a2                	ld	s1,8(sp)
    80001b28:	6902                	ld	s2,0(sp)
    80001b2a:	6105                	addi	sp,sp,32
    80001b2c:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001b2e:	4691                	li	a3,4
    80001b30:	00b90633          	add	a2,s2,a1
    80001b34:	6928                	ld	a0,80(a0)
    80001b36:	fa4ff0ef          	jal	ra,800012da <uvmalloc>
    80001b3a:	85aa                	mv	a1,a0
    80001b3c:	f16d                	bnez	a0,80001b1e <growproc+0x1e>
      return -1;
    80001b3e:	557d                	li	a0,-1
    80001b40:	b7cd                	j	80001b22 <growproc+0x22>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001b42:	00b90633          	add	a2,s2,a1
    80001b46:	6928                	ld	a0,80(a0)
    80001b48:	f4eff0ef          	jal	ra,80001296 <uvmdealloc>
    80001b4c:	85aa                	mv	a1,a0
    80001b4e:	bfc1                	j	80001b1e <growproc+0x1e>

0000000080001b50 <fork>:
{
    80001b50:	7139                	addi	sp,sp,-64
    80001b52:	fc06                	sd	ra,56(sp)
    80001b54:	f822                	sd	s0,48(sp)
    80001b56:	f426                	sd	s1,40(sp)
    80001b58:	f04a                	sd	s2,32(sp)
    80001b5a:	ec4e                	sd	s3,24(sp)
    80001b5c:	e852                	sd	s4,16(sp)
    80001b5e:	e456                	sd	s5,8(sp)
    80001b60:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001b62:	cc9ff0ef          	jal	ra,8000182a <myproc>
    80001b66:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001b68:	e85ff0ef          	jal	ra,800019ec <allocproc>
    80001b6c:	0e050663          	beqz	a0,80001c58 <fork+0x108>
    80001b70:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001b72:	048ab603          	ld	a2,72(s5)
    80001b76:	692c                	ld	a1,80(a0)
    80001b78:	050ab503          	ld	a0,80(s5)
    80001b7c:	88bff0ef          	jal	ra,80001406 <uvmcopy>
    80001b80:	04054863          	bltz	a0,80001bd0 <fork+0x80>
  np->sz = p->sz;
    80001b84:	048ab783          	ld	a5,72(s5)
    80001b88:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    80001b8c:	058ab683          	ld	a3,88(s5)
    80001b90:	87b6                	mv	a5,a3
    80001b92:	058a3703          	ld	a4,88(s4)
    80001b96:	12068693          	addi	a3,a3,288
    80001b9a:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001b9e:	6788                	ld	a0,8(a5)
    80001ba0:	6b8c                	ld	a1,16(a5)
    80001ba2:	6f90                	ld	a2,24(a5)
    80001ba4:	01073023          	sd	a6,0(a4)
    80001ba8:	e708                	sd	a0,8(a4)
    80001baa:	eb0c                	sd	a1,16(a4)
    80001bac:	ef10                	sd	a2,24(a4)
    80001bae:	02078793          	addi	a5,a5,32
    80001bb2:	02070713          	addi	a4,a4,32
    80001bb6:	fed792e3          	bne	a5,a3,80001b9a <fork+0x4a>
  np->trapframe->a0 = 0;
    80001bba:	058a3783          	ld	a5,88(s4)
    80001bbe:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001bc2:	0d0a8493          	addi	s1,s5,208
    80001bc6:	0d0a0913          	addi	s2,s4,208
    80001bca:	150a8993          	addi	s3,s5,336
    80001bce:	a829                	j	80001be8 <fork+0x98>
    freeproc(np);
    80001bd0:	8552                	mv	a0,s4
    80001bd2:	dcbff0ef          	jal	ra,8000199c <freeproc>
    release(&np->lock);
    80001bd6:	8552                	mv	a0,s4
    80001bd8:	858ff0ef          	jal	ra,80000c30 <release>
    return -1;
    80001bdc:	597d                	li	s2,-1
    80001bde:	a09d                	j	80001c44 <fork+0xf4>
  for(i = 0; i < NOFILE; i++)
    80001be0:	04a1                	addi	s1,s1,8
    80001be2:	0921                	addi	s2,s2,8
    80001be4:	01348963          	beq	s1,s3,80001bf6 <fork+0xa6>
    if(p->ofile[i])
    80001be8:	6088                	ld	a0,0(s1)
    80001bea:	d97d                	beqz	a0,80001be0 <fork+0x90>
      np->ofile[i] = filedup(p->ofile[i]);
    80001bec:	15e020ef          	jal	ra,80003d4a <filedup>
    80001bf0:	00a93023          	sd	a0,0(s2)
    80001bf4:	b7f5                	j	80001be0 <fork+0x90>
  np->cwd = idup(p->cwd);
    80001bf6:	150ab503          	ld	a0,336(s5)
    80001bfa:	4b4010ef          	jal	ra,800030ae <idup>
    80001bfe:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001c02:	4641                	li	a2,16
    80001c04:	158a8593          	addi	a1,s5,344
    80001c08:	158a0513          	addi	a0,s4,344
    80001c0c:	9a6ff0ef          	jal	ra,80000db2 <safestrcpy>
  pid = np->pid;
    80001c10:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    80001c14:	8552                	mv	a0,s4
    80001c16:	81aff0ef          	jal	ra,80000c30 <release>
  acquire(&wait_lock);
    80001c1a:	0000e497          	auipc	s1,0xe
    80001c1e:	e4e48493          	addi	s1,s1,-434 # 8000fa68 <wait_lock>
    80001c22:	8526                	mv	a0,s1
    80001c24:	f75fe0ef          	jal	ra,80000b98 <acquire>
  np->parent = p;
    80001c28:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    80001c2c:	8526                	mv	a0,s1
    80001c2e:	802ff0ef          	jal	ra,80000c30 <release>
  acquire(&np->lock);
    80001c32:	8552                	mv	a0,s4
    80001c34:	f65fe0ef          	jal	ra,80000b98 <acquire>
  np->state = RUNNABLE;
    80001c38:	478d                	li	a5,3
    80001c3a:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001c3e:	8552                	mv	a0,s4
    80001c40:	ff1fe0ef          	jal	ra,80000c30 <release>
}
    80001c44:	854a                	mv	a0,s2
    80001c46:	70e2                	ld	ra,56(sp)
    80001c48:	7442                	ld	s0,48(sp)
    80001c4a:	74a2                	ld	s1,40(sp)
    80001c4c:	7902                	ld	s2,32(sp)
    80001c4e:	69e2                	ld	s3,24(sp)
    80001c50:	6a42                	ld	s4,16(sp)
    80001c52:	6aa2                	ld	s5,8(sp)
    80001c54:	6121                	addi	sp,sp,64
    80001c56:	8082                	ret
    return -1;
    80001c58:	597d                	li	s2,-1
    80001c5a:	b7ed                	j	80001c44 <fork+0xf4>

0000000080001c5c <scheduler>:
{
    80001c5c:	715d                	addi	sp,sp,-80
    80001c5e:	e486                	sd	ra,72(sp)
    80001c60:	e0a2                	sd	s0,64(sp)
    80001c62:	fc26                	sd	s1,56(sp)
    80001c64:	f84a                	sd	s2,48(sp)
    80001c66:	f44e                	sd	s3,40(sp)
    80001c68:	f052                	sd	s4,32(sp)
    80001c6a:	ec56                	sd	s5,24(sp)
    80001c6c:	e85a                	sd	s6,16(sp)
    80001c6e:	e45e                	sd	s7,8(sp)
    80001c70:	e062                	sd	s8,0(sp)
    80001c72:	0880                	addi	s0,sp,80
    80001c74:	8792                	mv	a5,tp
  int id = r_tp();
    80001c76:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001c78:	00779b13          	slli	s6,a5,0x7
    80001c7c:	0000e717          	auipc	a4,0xe
    80001c80:	dd470713          	addi	a4,a4,-556 # 8000fa50 <pid_lock>
    80001c84:	975a                	add	a4,a4,s6
    80001c86:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001c8a:	0000e717          	auipc	a4,0xe
    80001c8e:	dfe70713          	addi	a4,a4,-514 # 8000fa88 <cpus+0x8>
    80001c92:	9b3a                	add	s6,s6,a4
        p->state = RUNNING;
    80001c94:	4c11                	li	s8,4
        c->proc = p;
    80001c96:	079e                	slli	a5,a5,0x7
    80001c98:	0000ea17          	auipc	s4,0xe
    80001c9c:	db8a0a13          	addi	s4,s4,-584 # 8000fa50 <pid_lock>
    80001ca0:	9a3e                	add	s4,s4,a5
        found = 1;
    80001ca2:	4b85                	li	s7,1
    for(p = proc; p < &proc[NPROC]; p++) {
    80001ca4:	00014997          	auipc	s3,0x14
    80001ca8:	bdc98993          	addi	s3,s3,-1060 # 80015880 <tickslock>
    80001cac:	a0a9                	j	80001cf6 <scheduler+0x9a>
      release(&p->lock);
    80001cae:	8526                	mv	a0,s1
    80001cb0:	f81fe0ef          	jal	ra,80000c30 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001cb4:	16848493          	addi	s1,s1,360
    80001cb8:	03348563          	beq	s1,s3,80001ce2 <scheduler+0x86>
      acquire(&p->lock);
    80001cbc:	8526                	mv	a0,s1
    80001cbe:	edbfe0ef          	jal	ra,80000b98 <acquire>
      if(p->state == RUNNABLE) {
    80001cc2:	4c9c                	lw	a5,24(s1)
    80001cc4:	ff2795e3          	bne	a5,s2,80001cae <scheduler+0x52>
        p->state = RUNNING;
    80001cc8:	0184ac23          	sw	s8,24(s1)
        c->proc = p;
    80001ccc:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001cd0:	06048593          	addi	a1,s1,96
    80001cd4:	855a                	mv	a0,s6
    80001cd6:	5b4000ef          	jal	ra,8000228a <swtch>
        c->proc = 0;
    80001cda:	020a3823          	sd	zero,48(s4)
        found = 1;
    80001cde:	8ade                	mv	s5,s7
    80001ce0:	b7f9                	j	80001cae <scheduler+0x52>
    if(found == 0) {
    80001ce2:	000a9a63          	bnez	s5,80001cf6 <scheduler+0x9a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ce6:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001cea:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001cee:	10079073          	csrw	sstatus,a5
      asm volatile("wfi");
    80001cf2:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001cf6:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001cfa:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001cfe:	10079073          	csrw	sstatus,a5
    int found = 0;
    80001d02:	4a81                	li	s5,0
    for(p = proc; p < &proc[NPROC]; p++) {
    80001d04:	0000e497          	auipc	s1,0xe
    80001d08:	17c48493          	addi	s1,s1,380 # 8000fe80 <proc>
      if(p->state == RUNNABLE) {
    80001d0c:	490d                	li	s2,3
    80001d0e:	b77d                	j	80001cbc <scheduler+0x60>

0000000080001d10 <sched>:
{
    80001d10:	7179                	addi	sp,sp,-48
    80001d12:	f406                	sd	ra,40(sp)
    80001d14:	f022                	sd	s0,32(sp)
    80001d16:	ec26                	sd	s1,24(sp)
    80001d18:	e84a                	sd	s2,16(sp)
    80001d1a:	e44e                	sd	s3,8(sp)
    80001d1c:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001d1e:	b0dff0ef          	jal	ra,8000182a <myproc>
    80001d22:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001d24:	e0bfe0ef          	jal	ra,80000b2e <holding>
    80001d28:	c92d                	beqz	a0,80001d9a <sched+0x8a>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001d2a:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001d2c:	2781                	sext.w	a5,a5
    80001d2e:	079e                	slli	a5,a5,0x7
    80001d30:	0000e717          	auipc	a4,0xe
    80001d34:	d2070713          	addi	a4,a4,-736 # 8000fa50 <pid_lock>
    80001d38:	97ba                	add	a5,a5,a4
    80001d3a:	0a87a703          	lw	a4,168(a5)
    80001d3e:	4785                	li	a5,1
    80001d40:	06f71363          	bne	a4,a5,80001da6 <sched+0x96>
  if(p->state == RUNNING)
    80001d44:	4c98                	lw	a4,24(s1)
    80001d46:	4791                	li	a5,4
    80001d48:	06f70563          	beq	a4,a5,80001db2 <sched+0xa2>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d4c:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001d50:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001d52:	e7b5                	bnez	a5,80001dbe <sched+0xae>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001d54:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001d56:	0000e917          	auipc	s2,0xe
    80001d5a:	cfa90913          	addi	s2,s2,-774 # 8000fa50 <pid_lock>
    80001d5e:	2781                	sext.w	a5,a5
    80001d60:	079e                	slli	a5,a5,0x7
    80001d62:	97ca                	add	a5,a5,s2
    80001d64:	0ac7a983          	lw	s3,172(a5)
    80001d68:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001d6a:	2781                	sext.w	a5,a5
    80001d6c:	079e                	slli	a5,a5,0x7
    80001d6e:	0000e597          	auipc	a1,0xe
    80001d72:	d1a58593          	addi	a1,a1,-742 # 8000fa88 <cpus+0x8>
    80001d76:	95be                	add	a1,a1,a5
    80001d78:	06048513          	addi	a0,s1,96
    80001d7c:	50e000ef          	jal	ra,8000228a <swtch>
    80001d80:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001d82:	2781                	sext.w	a5,a5
    80001d84:	079e                	slli	a5,a5,0x7
    80001d86:	993e                	add	s2,s2,a5
    80001d88:	0b392623          	sw	s3,172(s2)
}
    80001d8c:	70a2                	ld	ra,40(sp)
    80001d8e:	7402                	ld	s0,32(sp)
    80001d90:	64e2                	ld	s1,24(sp)
    80001d92:	6942                	ld	s2,16(sp)
    80001d94:	69a2                	ld	s3,8(sp)
    80001d96:	6145                	addi	sp,sp,48
    80001d98:	8082                	ret
    panic("sched p->lock");
    80001d9a:	00005517          	auipc	a0,0x5
    80001d9e:	4b650513          	addi	a0,a0,1206 # 80007250 <digits+0x218>
    80001da2:	9b5fe0ef          	jal	ra,80000756 <panic>
    panic("sched locks");
    80001da6:	00005517          	auipc	a0,0x5
    80001daa:	4ba50513          	addi	a0,a0,1210 # 80007260 <digits+0x228>
    80001dae:	9a9fe0ef          	jal	ra,80000756 <panic>
    panic("sched running");
    80001db2:	00005517          	auipc	a0,0x5
    80001db6:	4be50513          	addi	a0,a0,1214 # 80007270 <digits+0x238>
    80001dba:	99dfe0ef          	jal	ra,80000756 <panic>
    panic("sched interruptible");
    80001dbe:	00005517          	auipc	a0,0x5
    80001dc2:	4c250513          	addi	a0,a0,1218 # 80007280 <digits+0x248>
    80001dc6:	991fe0ef          	jal	ra,80000756 <panic>

0000000080001dca <yield>:
{
    80001dca:	1101                	addi	sp,sp,-32
    80001dcc:	ec06                	sd	ra,24(sp)
    80001dce:	e822                	sd	s0,16(sp)
    80001dd0:	e426                	sd	s1,8(sp)
    80001dd2:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001dd4:	a57ff0ef          	jal	ra,8000182a <myproc>
    80001dd8:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001dda:	dbffe0ef          	jal	ra,80000b98 <acquire>
  p->state = RUNNABLE;
    80001dde:	478d                	li	a5,3
    80001de0:	cc9c                	sw	a5,24(s1)
  sched();
    80001de2:	f2fff0ef          	jal	ra,80001d10 <sched>
  release(&p->lock);
    80001de6:	8526                	mv	a0,s1
    80001de8:	e49fe0ef          	jal	ra,80000c30 <release>
}
    80001dec:	60e2                	ld	ra,24(sp)
    80001dee:	6442                	ld	s0,16(sp)
    80001df0:	64a2                	ld	s1,8(sp)
    80001df2:	6105                	addi	sp,sp,32
    80001df4:	8082                	ret

0000000080001df6 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001df6:	7179                	addi	sp,sp,-48
    80001df8:	f406                	sd	ra,40(sp)
    80001dfa:	f022                	sd	s0,32(sp)
    80001dfc:	ec26                	sd	s1,24(sp)
    80001dfe:	e84a                	sd	s2,16(sp)
    80001e00:	e44e                	sd	s3,8(sp)
    80001e02:	1800                	addi	s0,sp,48
    80001e04:	89aa                	mv	s3,a0
    80001e06:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001e08:	a23ff0ef          	jal	ra,8000182a <myproc>
    80001e0c:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001e0e:	d8bfe0ef          	jal	ra,80000b98 <acquire>
  release(lk);
    80001e12:	854a                	mv	a0,s2
    80001e14:	e1dfe0ef          	jal	ra,80000c30 <release>

  // Go to sleep.
  p->chan = chan;
    80001e18:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001e1c:	4789                	li	a5,2
    80001e1e:	cc9c                	sw	a5,24(s1)

  sched();
    80001e20:	ef1ff0ef          	jal	ra,80001d10 <sched>

  // Tidy up.
  p->chan = 0;
    80001e24:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001e28:	8526                	mv	a0,s1
    80001e2a:	e07fe0ef          	jal	ra,80000c30 <release>
  acquire(lk);
    80001e2e:	854a                	mv	a0,s2
    80001e30:	d69fe0ef          	jal	ra,80000b98 <acquire>
}
    80001e34:	70a2                	ld	ra,40(sp)
    80001e36:	7402                	ld	s0,32(sp)
    80001e38:	64e2                	ld	s1,24(sp)
    80001e3a:	6942                	ld	s2,16(sp)
    80001e3c:	69a2                	ld	s3,8(sp)
    80001e3e:	6145                	addi	sp,sp,48
    80001e40:	8082                	ret

0000000080001e42 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80001e42:	7139                	addi	sp,sp,-64
    80001e44:	fc06                	sd	ra,56(sp)
    80001e46:	f822                	sd	s0,48(sp)
    80001e48:	f426                	sd	s1,40(sp)
    80001e4a:	f04a                	sd	s2,32(sp)
    80001e4c:	ec4e                	sd	s3,24(sp)
    80001e4e:	e852                	sd	s4,16(sp)
    80001e50:	e456                	sd	s5,8(sp)
    80001e52:	0080                	addi	s0,sp,64
    80001e54:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001e56:	0000e497          	auipc	s1,0xe
    80001e5a:	02a48493          	addi	s1,s1,42 # 8000fe80 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001e5e:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001e60:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001e62:	00014917          	auipc	s2,0x14
    80001e66:	a1e90913          	addi	s2,s2,-1506 # 80015880 <tickslock>
    80001e6a:	a801                	j	80001e7a <wakeup+0x38>
      }
      release(&p->lock);
    80001e6c:	8526                	mv	a0,s1
    80001e6e:	dc3fe0ef          	jal	ra,80000c30 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001e72:	16848493          	addi	s1,s1,360
    80001e76:	03248263          	beq	s1,s2,80001e9a <wakeup+0x58>
    if(p != myproc()){
    80001e7a:	9b1ff0ef          	jal	ra,8000182a <myproc>
    80001e7e:	fea48ae3          	beq	s1,a0,80001e72 <wakeup+0x30>
      acquire(&p->lock);
    80001e82:	8526                	mv	a0,s1
    80001e84:	d15fe0ef          	jal	ra,80000b98 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001e88:	4c9c                	lw	a5,24(s1)
    80001e8a:	ff3791e3          	bne	a5,s3,80001e6c <wakeup+0x2a>
    80001e8e:	709c                	ld	a5,32(s1)
    80001e90:	fd479ee3          	bne	a5,s4,80001e6c <wakeup+0x2a>
        p->state = RUNNABLE;
    80001e94:	0154ac23          	sw	s5,24(s1)
    80001e98:	bfd1                	j	80001e6c <wakeup+0x2a>
    }
  }
}
    80001e9a:	70e2                	ld	ra,56(sp)
    80001e9c:	7442                	ld	s0,48(sp)
    80001e9e:	74a2                	ld	s1,40(sp)
    80001ea0:	7902                	ld	s2,32(sp)
    80001ea2:	69e2                	ld	s3,24(sp)
    80001ea4:	6a42                	ld	s4,16(sp)
    80001ea6:	6aa2                	ld	s5,8(sp)
    80001ea8:	6121                	addi	sp,sp,64
    80001eaa:	8082                	ret

0000000080001eac <reparent>:
{
    80001eac:	7179                	addi	sp,sp,-48
    80001eae:	f406                	sd	ra,40(sp)
    80001eb0:	f022                	sd	s0,32(sp)
    80001eb2:	ec26                	sd	s1,24(sp)
    80001eb4:	e84a                	sd	s2,16(sp)
    80001eb6:	e44e                	sd	s3,8(sp)
    80001eb8:	e052                	sd	s4,0(sp)
    80001eba:	1800                	addi	s0,sp,48
    80001ebc:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001ebe:	0000e497          	auipc	s1,0xe
    80001ec2:	fc248493          	addi	s1,s1,-62 # 8000fe80 <proc>
      pp->parent = initproc;
    80001ec6:	00006a17          	auipc	s4,0x6
    80001eca:	a52a0a13          	addi	s4,s4,-1454 # 80007918 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001ece:	00014997          	auipc	s3,0x14
    80001ed2:	9b298993          	addi	s3,s3,-1614 # 80015880 <tickslock>
    80001ed6:	a029                	j	80001ee0 <reparent+0x34>
    80001ed8:	16848493          	addi	s1,s1,360
    80001edc:	01348b63          	beq	s1,s3,80001ef2 <reparent+0x46>
    if(pp->parent == p){
    80001ee0:	7c9c                	ld	a5,56(s1)
    80001ee2:	ff279be3          	bne	a5,s2,80001ed8 <reparent+0x2c>
      pp->parent = initproc;
    80001ee6:	000a3503          	ld	a0,0(s4)
    80001eea:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001eec:	f57ff0ef          	jal	ra,80001e42 <wakeup>
    80001ef0:	b7e5                	j	80001ed8 <reparent+0x2c>
}
    80001ef2:	70a2                	ld	ra,40(sp)
    80001ef4:	7402                	ld	s0,32(sp)
    80001ef6:	64e2                	ld	s1,24(sp)
    80001ef8:	6942                	ld	s2,16(sp)
    80001efa:	69a2                	ld	s3,8(sp)
    80001efc:	6a02                	ld	s4,0(sp)
    80001efe:	6145                	addi	sp,sp,48
    80001f00:	8082                	ret

0000000080001f02 <exit>:
{
    80001f02:	7179                	addi	sp,sp,-48
    80001f04:	f406                	sd	ra,40(sp)
    80001f06:	f022                	sd	s0,32(sp)
    80001f08:	ec26                	sd	s1,24(sp)
    80001f0a:	e84a                	sd	s2,16(sp)
    80001f0c:	e44e                	sd	s3,8(sp)
    80001f0e:	e052                	sd	s4,0(sp)
    80001f10:	1800                	addi	s0,sp,48
    80001f12:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001f14:	917ff0ef          	jal	ra,8000182a <myproc>
    80001f18:	89aa                	mv	s3,a0
  if(p == initproc)
    80001f1a:	00006797          	auipc	a5,0x6
    80001f1e:	9fe7b783          	ld	a5,-1538(a5) # 80007918 <initproc>
    80001f22:	0d050493          	addi	s1,a0,208
    80001f26:	15050913          	addi	s2,a0,336
    80001f2a:	00a79f63          	bne	a5,a0,80001f48 <exit+0x46>
    panic("init exiting");
    80001f2e:	00005517          	auipc	a0,0x5
    80001f32:	36a50513          	addi	a0,a0,874 # 80007298 <digits+0x260>
    80001f36:	821fe0ef          	jal	ra,80000756 <panic>
      fileclose(f);
    80001f3a:	657010ef          	jal	ra,80003d90 <fileclose>
      p->ofile[fd] = 0;
    80001f3e:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001f42:	04a1                	addi	s1,s1,8
    80001f44:	01248563          	beq	s1,s2,80001f4e <exit+0x4c>
    if(p->ofile[fd]){
    80001f48:	6088                	ld	a0,0(s1)
    80001f4a:	f965                	bnez	a0,80001f3a <exit+0x38>
    80001f4c:	bfdd                	j	80001f42 <exit+0x40>
  begin_op();
    80001f4e:	22b010ef          	jal	ra,80003978 <begin_op>
  iput(p->cwd);
    80001f52:	1509b503          	ld	a0,336(s3)
    80001f56:	30c010ef          	jal	ra,80003262 <iput>
  end_op();
    80001f5a:	28d010ef          	jal	ra,800039e6 <end_op>
  p->cwd = 0;
    80001f5e:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80001f62:	0000e497          	auipc	s1,0xe
    80001f66:	b0648493          	addi	s1,s1,-1274 # 8000fa68 <wait_lock>
    80001f6a:	8526                	mv	a0,s1
    80001f6c:	c2dfe0ef          	jal	ra,80000b98 <acquire>
  reparent(p);
    80001f70:	854e                	mv	a0,s3
    80001f72:	f3bff0ef          	jal	ra,80001eac <reparent>
  wakeup(p->parent);
    80001f76:	0389b503          	ld	a0,56(s3)
    80001f7a:	ec9ff0ef          	jal	ra,80001e42 <wakeup>
  acquire(&p->lock);
    80001f7e:	854e                	mv	a0,s3
    80001f80:	c19fe0ef          	jal	ra,80000b98 <acquire>
  p->xstate = status;
    80001f84:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001f88:	4795                	li	a5,5
    80001f8a:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001f8e:	8526                	mv	a0,s1
    80001f90:	ca1fe0ef          	jal	ra,80000c30 <release>
  sched();
    80001f94:	d7dff0ef          	jal	ra,80001d10 <sched>
  panic("zombie exit");
    80001f98:	00005517          	auipc	a0,0x5
    80001f9c:	31050513          	addi	a0,a0,784 # 800072a8 <digits+0x270>
    80001fa0:	fb6fe0ef          	jal	ra,80000756 <panic>

0000000080001fa4 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001fa4:	7179                	addi	sp,sp,-48
    80001fa6:	f406                	sd	ra,40(sp)
    80001fa8:	f022                	sd	s0,32(sp)
    80001faa:	ec26                	sd	s1,24(sp)
    80001fac:	e84a                	sd	s2,16(sp)
    80001fae:	e44e                	sd	s3,8(sp)
    80001fb0:	1800                	addi	s0,sp,48
    80001fb2:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001fb4:	0000e497          	auipc	s1,0xe
    80001fb8:	ecc48493          	addi	s1,s1,-308 # 8000fe80 <proc>
    80001fbc:	00014997          	auipc	s3,0x14
    80001fc0:	8c498993          	addi	s3,s3,-1852 # 80015880 <tickslock>
    acquire(&p->lock);
    80001fc4:	8526                	mv	a0,s1
    80001fc6:	bd3fe0ef          	jal	ra,80000b98 <acquire>
    if(p->pid == pid){
    80001fca:	589c                	lw	a5,48(s1)
    80001fcc:	01278b63          	beq	a5,s2,80001fe2 <kill+0x3e>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001fd0:	8526                	mv	a0,s1
    80001fd2:	c5ffe0ef          	jal	ra,80000c30 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001fd6:	16848493          	addi	s1,s1,360
    80001fda:	ff3495e3          	bne	s1,s3,80001fc4 <kill+0x20>
  }
  return -1;
    80001fde:	557d                	li	a0,-1
    80001fe0:	a819                	j	80001ff6 <kill+0x52>
      p->killed = 1;
    80001fe2:	4785                	li	a5,1
    80001fe4:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001fe6:	4c98                	lw	a4,24(s1)
    80001fe8:	4789                	li	a5,2
    80001fea:	00f70d63          	beq	a4,a5,80002004 <kill+0x60>
      release(&p->lock);
    80001fee:	8526                	mv	a0,s1
    80001ff0:	c41fe0ef          	jal	ra,80000c30 <release>
      return 0;
    80001ff4:	4501                	li	a0,0
}
    80001ff6:	70a2                	ld	ra,40(sp)
    80001ff8:	7402                	ld	s0,32(sp)
    80001ffa:	64e2                	ld	s1,24(sp)
    80001ffc:	6942                	ld	s2,16(sp)
    80001ffe:	69a2                	ld	s3,8(sp)
    80002000:	6145                	addi	sp,sp,48
    80002002:	8082                	ret
        p->state = RUNNABLE;
    80002004:	478d                	li	a5,3
    80002006:	cc9c                	sw	a5,24(s1)
    80002008:	b7dd                	j	80001fee <kill+0x4a>

000000008000200a <setkilled>:

void
setkilled(struct proc *p)
{
    8000200a:	1101                	addi	sp,sp,-32
    8000200c:	ec06                	sd	ra,24(sp)
    8000200e:	e822                	sd	s0,16(sp)
    80002010:	e426                	sd	s1,8(sp)
    80002012:	1000                	addi	s0,sp,32
    80002014:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80002016:	b83fe0ef          	jal	ra,80000b98 <acquire>
  p->killed = 1;
    8000201a:	4785                	li	a5,1
    8000201c:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    8000201e:	8526                	mv	a0,s1
    80002020:	c11fe0ef          	jal	ra,80000c30 <release>
}
    80002024:	60e2                	ld	ra,24(sp)
    80002026:	6442                	ld	s0,16(sp)
    80002028:	64a2                	ld	s1,8(sp)
    8000202a:	6105                	addi	sp,sp,32
    8000202c:	8082                	ret

000000008000202e <killed>:

int
killed(struct proc *p)
{
    8000202e:	1101                	addi	sp,sp,-32
    80002030:	ec06                	sd	ra,24(sp)
    80002032:	e822                	sd	s0,16(sp)
    80002034:	e426                	sd	s1,8(sp)
    80002036:	e04a                	sd	s2,0(sp)
    80002038:	1000                	addi	s0,sp,32
    8000203a:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    8000203c:	b5dfe0ef          	jal	ra,80000b98 <acquire>
  k = p->killed;
    80002040:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    80002044:	8526                	mv	a0,s1
    80002046:	bebfe0ef          	jal	ra,80000c30 <release>
  return k;
}
    8000204a:	854a                	mv	a0,s2
    8000204c:	60e2                	ld	ra,24(sp)
    8000204e:	6442                	ld	s0,16(sp)
    80002050:	64a2                	ld	s1,8(sp)
    80002052:	6902                	ld	s2,0(sp)
    80002054:	6105                	addi	sp,sp,32
    80002056:	8082                	ret

0000000080002058 <wait>:
{
    80002058:	715d                	addi	sp,sp,-80
    8000205a:	e486                	sd	ra,72(sp)
    8000205c:	e0a2                	sd	s0,64(sp)
    8000205e:	fc26                	sd	s1,56(sp)
    80002060:	f84a                	sd	s2,48(sp)
    80002062:	f44e                	sd	s3,40(sp)
    80002064:	f052                	sd	s4,32(sp)
    80002066:	ec56                	sd	s5,24(sp)
    80002068:	e85a                	sd	s6,16(sp)
    8000206a:	e45e                	sd	s7,8(sp)
    8000206c:	e062                	sd	s8,0(sp)
    8000206e:	0880                	addi	s0,sp,80
    80002070:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80002072:	fb8ff0ef          	jal	ra,8000182a <myproc>
    80002076:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80002078:	0000e517          	auipc	a0,0xe
    8000207c:	9f050513          	addi	a0,a0,-1552 # 8000fa68 <wait_lock>
    80002080:	b19fe0ef          	jal	ra,80000b98 <acquire>
    havekids = 0;
    80002084:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    80002086:	4a15                	li	s4,5
        havekids = 1;
    80002088:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000208a:	00013997          	auipc	s3,0x13
    8000208e:	7f698993          	addi	s3,s3,2038 # 80015880 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80002092:	0000ec17          	auipc	s8,0xe
    80002096:	9d6c0c13          	addi	s8,s8,-1578 # 8000fa68 <wait_lock>
    havekids = 0;
    8000209a:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000209c:	0000e497          	auipc	s1,0xe
    800020a0:	de448493          	addi	s1,s1,-540 # 8000fe80 <proc>
    800020a4:	a899                	j	800020fa <wait+0xa2>
          pid = pp->pid;
    800020a6:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    800020aa:	000b0c63          	beqz	s6,800020c2 <wait+0x6a>
    800020ae:	4691                	li	a3,4
    800020b0:	02c48613          	addi	a2,s1,44
    800020b4:	85da                	mv	a1,s6
    800020b6:	05093503          	ld	a0,80(s2)
    800020ba:	c28ff0ef          	jal	ra,800014e2 <copyout>
    800020be:	00054f63          	bltz	a0,800020dc <wait+0x84>
          freeproc(pp);
    800020c2:	8526                	mv	a0,s1
    800020c4:	8d9ff0ef          	jal	ra,8000199c <freeproc>
          release(&pp->lock);
    800020c8:	8526                	mv	a0,s1
    800020ca:	b67fe0ef          	jal	ra,80000c30 <release>
          release(&wait_lock);
    800020ce:	0000e517          	auipc	a0,0xe
    800020d2:	99a50513          	addi	a0,a0,-1638 # 8000fa68 <wait_lock>
    800020d6:	b5bfe0ef          	jal	ra,80000c30 <release>
          return pid;
    800020da:	a891                	j	8000212e <wait+0xd6>
            release(&pp->lock);
    800020dc:	8526                	mv	a0,s1
    800020de:	b53fe0ef          	jal	ra,80000c30 <release>
            release(&wait_lock);
    800020e2:	0000e517          	auipc	a0,0xe
    800020e6:	98650513          	addi	a0,a0,-1658 # 8000fa68 <wait_lock>
    800020ea:	b47fe0ef          	jal	ra,80000c30 <release>
            return -1;
    800020ee:	59fd                	li	s3,-1
    800020f0:	a83d                	j	8000212e <wait+0xd6>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800020f2:	16848493          	addi	s1,s1,360
    800020f6:	03348063          	beq	s1,s3,80002116 <wait+0xbe>
      if(pp->parent == p){
    800020fa:	7c9c                	ld	a5,56(s1)
    800020fc:	ff279be3          	bne	a5,s2,800020f2 <wait+0x9a>
        acquire(&pp->lock);
    80002100:	8526                	mv	a0,s1
    80002102:	a97fe0ef          	jal	ra,80000b98 <acquire>
        if(pp->state == ZOMBIE){
    80002106:	4c9c                	lw	a5,24(s1)
    80002108:	f9478fe3          	beq	a5,s4,800020a6 <wait+0x4e>
        release(&pp->lock);
    8000210c:	8526                	mv	a0,s1
    8000210e:	b23fe0ef          	jal	ra,80000c30 <release>
        havekids = 1;
    80002112:	8756                	mv	a4,s5
    80002114:	bff9                	j	800020f2 <wait+0x9a>
    if(!havekids || killed(p)){
    80002116:	c709                	beqz	a4,80002120 <wait+0xc8>
    80002118:	854a                	mv	a0,s2
    8000211a:	f15ff0ef          	jal	ra,8000202e <killed>
    8000211e:	c50d                	beqz	a0,80002148 <wait+0xf0>
      release(&wait_lock);
    80002120:	0000e517          	auipc	a0,0xe
    80002124:	94850513          	addi	a0,a0,-1720 # 8000fa68 <wait_lock>
    80002128:	b09fe0ef          	jal	ra,80000c30 <release>
      return -1;
    8000212c:	59fd                	li	s3,-1
}
    8000212e:	854e                	mv	a0,s3
    80002130:	60a6                	ld	ra,72(sp)
    80002132:	6406                	ld	s0,64(sp)
    80002134:	74e2                	ld	s1,56(sp)
    80002136:	7942                	ld	s2,48(sp)
    80002138:	79a2                	ld	s3,40(sp)
    8000213a:	7a02                	ld	s4,32(sp)
    8000213c:	6ae2                	ld	s5,24(sp)
    8000213e:	6b42                	ld	s6,16(sp)
    80002140:	6ba2                	ld	s7,8(sp)
    80002142:	6c02                	ld	s8,0(sp)
    80002144:	6161                	addi	sp,sp,80
    80002146:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80002148:	85e2                	mv	a1,s8
    8000214a:	854a                	mv	a0,s2
    8000214c:	cabff0ef          	jal	ra,80001df6 <sleep>
    havekids = 0;
    80002150:	b7a9                	j	8000209a <wait+0x42>

0000000080002152 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80002152:	7179                	addi	sp,sp,-48
    80002154:	f406                	sd	ra,40(sp)
    80002156:	f022                	sd	s0,32(sp)
    80002158:	ec26                	sd	s1,24(sp)
    8000215a:	e84a                	sd	s2,16(sp)
    8000215c:	e44e                	sd	s3,8(sp)
    8000215e:	e052                	sd	s4,0(sp)
    80002160:	1800                	addi	s0,sp,48
    80002162:	84aa                	mv	s1,a0
    80002164:	892e                	mv	s2,a1
    80002166:	89b2                	mv	s3,a2
    80002168:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000216a:	ec0ff0ef          	jal	ra,8000182a <myproc>
  if(user_dst){
    8000216e:	cc99                	beqz	s1,8000218c <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    80002170:	86d2                	mv	a3,s4
    80002172:	864e                	mv	a2,s3
    80002174:	85ca                	mv	a1,s2
    80002176:	6928                	ld	a0,80(a0)
    80002178:	b6aff0ef          	jal	ra,800014e2 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    8000217c:	70a2                	ld	ra,40(sp)
    8000217e:	7402                	ld	s0,32(sp)
    80002180:	64e2                	ld	s1,24(sp)
    80002182:	6942                	ld	s2,16(sp)
    80002184:	69a2                	ld	s3,8(sp)
    80002186:	6a02                	ld	s4,0(sp)
    80002188:	6145                	addi	sp,sp,48
    8000218a:	8082                	ret
    memmove((char *)dst, src, len);
    8000218c:	000a061b          	sext.w	a2,s4
    80002190:	85ce                	mv	a1,s3
    80002192:	854a                	mv	a0,s2
    80002194:	b35fe0ef          	jal	ra,80000cc8 <memmove>
    return 0;
    80002198:	8526                	mv	a0,s1
    8000219a:	b7cd                	j	8000217c <either_copyout+0x2a>

000000008000219c <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    8000219c:	7179                	addi	sp,sp,-48
    8000219e:	f406                	sd	ra,40(sp)
    800021a0:	f022                	sd	s0,32(sp)
    800021a2:	ec26                	sd	s1,24(sp)
    800021a4:	e84a                	sd	s2,16(sp)
    800021a6:	e44e                	sd	s3,8(sp)
    800021a8:	e052                	sd	s4,0(sp)
    800021aa:	1800                	addi	s0,sp,48
    800021ac:	892a                	mv	s2,a0
    800021ae:	84ae                	mv	s1,a1
    800021b0:	89b2                	mv	s3,a2
    800021b2:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800021b4:	e76ff0ef          	jal	ra,8000182a <myproc>
  if(user_src){
    800021b8:	cc99                	beqz	s1,800021d6 <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    800021ba:	86d2                	mv	a3,s4
    800021bc:	864e                	mv	a2,s3
    800021be:	85ca                	mv	a1,s2
    800021c0:	6928                	ld	a0,80(a0)
    800021c2:	bd8ff0ef          	jal	ra,8000159a <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    800021c6:	70a2                	ld	ra,40(sp)
    800021c8:	7402                	ld	s0,32(sp)
    800021ca:	64e2                	ld	s1,24(sp)
    800021cc:	6942                	ld	s2,16(sp)
    800021ce:	69a2                	ld	s3,8(sp)
    800021d0:	6a02                	ld	s4,0(sp)
    800021d2:	6145                	addi	sp,sp,48
    800021d4:	8082                	ret
    memmove(dst, (char*)src, len);
    800021d6:	000a061b          	sext.w	a2,s4
    800021da:	85ce                	mv	a1,s3
    800021dc:	854a                	mv	a0,s2
    800021de:	aebfe0ef          	jal	ra,80000cc8 <memmove>
    return 0;
    800021e2:	8526                	mv	a0,s1
    800021e4:	b7cd                	j	800021c6 <either_copyin+0x2a>

00000000800021e6 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    800021e6:	715d                	addi	sp,sp,-80
    800021e8:	e486                	sd	ra,72(sp)
    800021ea:	e0a2                	sd	s0,64(sp)
    800021ec:	fc26                	sd	s1,56(sp)
    800021ee:	f84a                	sd	s2,48(sp)
    800021f0:	f44e                	sd	s3,40(sp)
    800021f2:	f052                	sd	s4,32(sp)
    800021f4:	ec56                	sd	s5,24(sp)
    800021f6:	e85a                	sd	s6,16(sp)
    800021f8:	e45e                	sd	s7,8(sp)
    800021fa:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    800021fc:	00005517          	auipc	a0,0x5
    80002200:	ec450513          	addi	a0,a0,-316 # 800070c0 <digits+0x88>
    80002204:	a9efe0ef          	jal	ra,800004a2 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002208:	0000e497          	auipc	s1,0xe
    8000220c:	dd048493          	addi	s1,s1,-560 # 8000ffd8 <proc+0x158>
    80002210:	00013917          	auipc	s2,0x13
    80002214:	7c890913          	addi	s2,s2,1992 # 800159d8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002218:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    8000221a:	00005997          	auipc	s3,0x5
    8000221e:	09e98993          	addi	s3,s3,158 # 800072b8 <digits+0x280>
    printf("%d %s %s", p->pid, state, p->name);
    80002222:	00005a97          	auipc	s5,0x5
    80002226:	09ea8a93          	addi	s5,s5,158 # 800072c0 <digits+0x288>
    printf("\n");
    8000222a:	00005a17          	auipc	s4,0x5
    8000222e:	e96a0a13          	addi	s4,s4,-362 # 800070c0 <digits+0x88>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002232:	00005b97          	auipc	s7,0x5
    80002236:	0ceb8b93          	addi	s7,s7,206 # 80007300 <states.0>
    8000223a:	a829                	j	80002254 <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    8000223c:	ed86a583          	lw	a1,-296(a3)
    80002240:	8556                	mv	a0,s5
    80002242:	a60fe0ef          	jal	ra,800004a2 <printf>
    printf("\n");
    80002246:	8552                	mv	a0,s4
    80002248:	a5afe0ef          	jal	ra,800004a2 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    8000224c:	16848493          	addi	s1,s1,360
    80002250:	03248263          	beq	s1,s2,80002274 <procdump+0x8e>
    if(p->state == UNUSED)
    80002254:	86a6                	mv	a3,s1
    80002256:	ec04a783          	lw	a5,-320(s1)
    8000225a:	dbed                	beqz	a5,8000224c <procdump+0x66>
      state = "???";
    8000225c:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000225e:	fcfb6fe3          	bltu	s6,a5,8000223c <procdump+0x56>
    80002262:	02079713          	slli	a4,a5,0x20
    80002266:	01d75793          	srli	a5,a4,0x1d
    8000226a:	97de                	add	a5,a5,s7
    8000226c:	6390                	ld	a2,0(a5)
    8000226e:	f679                	bnez	a2,8000223c <procdump+0x56>
      state = "???";
    80002270:	864e                	mv	a2,s3
    80002272:	b7e9                	j	8000223c <procdump+0x56>
  }
}
    80002274:	60a6                	ld	ra,72(sp)
    80002276:	6406                	ld	s0,64(sp)
    80002278:	74e2                	ld	s1,56(sp)
    8000227a:	7942                	ld	s2,48(sp)
    8000227c:	79a2                	ld	s3,40(sp)
    8000227e:	7a02                	ld	s4,32(sp)
    80002280:	6ae2                	ld	s5,24(sp)
    80002282:	6b42                	ld	s6,16(sp)
    80002284:	6ba2                	ld	s7,8(sp)
    80002286:	6161                	addi	sp,sp,80
    80002288:	8082                	ret

000000008000228a <swtch>:
    8000228a:	00153023          	sd	ra,0(a0)
    8000228e:	00253423          	sd	sp,8(a0)
    80002292:	e900                	sd	s0,16(a0)
    80002294:	ed04                	sd	s1,24(a0)
    80002296:	03253023          	sd	s2,32(a0)
    8000229a:	03353423          	sd	s3,40(a0)
    8000229e:	03453823          	sd	s4,48(a0)
    800022a2:	03553c23          	sd	s5,56(a0)
    800022a6:	05653023          	sd	s6,64(a0)
    800022aa:	05753423          	sd	s7,72(a0)
    800022ae:	05853823          	sd	s8,80(a0)
    800022b2:	05953c23          	sd	s9,88(a0)
    800022b6:	07a53023          	sd	s10,96(a0)
    800022ba:	07b53423          	sd	s11,104(a0)
    800022be:	0005b083          	ld	ra,0(a1)
    800022c2:	0085b103          	ld	sp,8(a1)
    800022c6:	6980                	ld	s0,16(a1)
    800022c8:	6d84                	ld	s1,24(a1)
    800022ca:	0205b903          	ld	s2,32(a1)
    800022ce:	0285b983          	ld	s3,40(a1)
    800022d2:	0305ba03          	ld	s4,48(a1)
    800022d6:	0385ba83          	ld	s5,56(a1)
    800022da:	0405bb03          	ld	s6,64(a1)
    800022de:	0485bb83          	ld	s7,72(a1)
    800022e2:	0505bc03          	ld	s8,80(a1)
    800022e6:	0585bc83          	ld	s9,88(a1)
    800022ea:	0605bd03          	ld	s10,96(a1)
    800022ee:	0685bd83          	ld	s11,104(a1)
    800022f2:	8082                	ret

00000000800022f4 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    800022f4:	1141                	addi	sp,sp,-16
    800022f6:	e406                	sd	ra,8(sp)
    800022f8:	e022                	sd	s0,0(sp)
    800022fa:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    800022fc:	00005597          	auipc	a1,0x5
    80002300:	03458593          	addi	a1,a1,52 # 80007330 <states.0+0x30>
    80002304:	00013517          	auipc	a0,0x13
    80002308:	57c50513          	addi	a0,a0,1404 # 80015880 <tickslock>
    8000230c:	80dfe0ef          	jal	ra,80000b18 <initlock>
}
    80002310:	60a2                	ld	ra,8(sp)
    80002312:	6402                	ld	s0,0(sp)
    80002314:	0141                	addi	sp,sp,16
    80002316:	8082                	ret

0000000080002318 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80002318:	1141                	addi	sp,sp,-16
    8000231a:	e422                	sd	s0,8(sp)
    8000231c:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000231e:	00003797          	auipc	a5,0x3
    80002322:	d3278793          	addi	a5,a5,-718 # 80005050 <kernelvec>
    80002326:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    8000232a:	6422                	ld	s0,8(sp)
    8000232c:	0141                	addi	sp,sp,16
    8000232e:	8082                	ret

0000000080002330 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80002330:	1141                	addi	sp,sp,-16
    80002332:	e406                	sd	ra,8(sp)
    80002334:	e022                	sd	s0,0(sp)
    80002336:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80002338:	cf2ff0ef          	jal	ra,8000182a <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000233c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80002340:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002342:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80002346:	00004697          	auipc	a3,0x4
    8000234a:	cba68693          	addi	a3,a3,-838 # 80006000 <_trampoline>
    8000234e:	00004717          	auipc	a4,0x4
    80002352:	cb270713          	addi	a4,a4,-846 # 80006000 <_trampoline>
    80002356:	8f15                	sub	a4,a4,a3
    80002358:	040007b7          	lui	a5,0x4000
    8000235c:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    8000235e:	07b2                	slli	a5,a5,0xc
    80002360:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002362:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80002366:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80002368:	18002673          	csrr	a2,satp
    8000236c:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    8000236e:	6d30                	ld	a2,88(a0)
    80002370:	6138                	ld	a4,64(a0)
    80002372:	6585                	lui	a1,0x1
    80002374:	972e                	add	a4,a4,a1
    80002376:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80002378:	6d38                	ld	a4,88(a0)
    8000237a:	00000617          	auipc	a2,0x0
    8000237e:	10c60613          	addi	a2,a2,268 # 80002486 <usertrap>
    80002382:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80002384:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80002386:	8612                	mv	a2,tp
    80002388:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000238a:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    8000238e:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002392:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002396:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    8000239a:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    8000239c:	6f18                	ld	a4,24(a4)
    8000239e:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    800023a2:	6928                	ld	a0,80(a0)
    800023a4:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    800023a6:	00004717          	auipc	a4,0x4
    800023aa:	cf670713          	addi	a4,a4,-778 # 8000609c <userret>
    800023ae:	8f15                	sub	a4,a4,a3
    800023b0:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    800023b2:	577d                	li	a4,-1
    800023b4:	177e                	slli	a4,a4,0x3f
    800023b6:	8d59                	or	a0,a0,a4
    800023b8:	9782                	jalr	a5
}
    800023ba:	60a2                	ld	ra,8(sp)
    800023bc:	6402                	ld	s0,0(sp)
    800023be:	0141                	addi	sp,sp,16
    800023c0:	8082                	ret

00000000800023c2 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    800023c2:	1101                	addi	sp,sp,-32
    800023c4:	ec06                	sd	ra,24(sp)
    800023c6:	e822                	sd	s0,16(sp)
    800023c8:	e426                	sd	s1,8(sp)
    800023ca:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    800023cc:	c32ff0ef          	jal	ra,800017fe <cpuid>
    800023d0:	cd19                	beqz	a0,800023ee <clockintr+0x2c>
  asm volatile("csrr %0, time" : "=r" (x) );
    800023d2:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    800023d6:	000f4737          	lui	a4,0xf4
    800023da:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    800023de:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    800023e0:	14d79073          	csrw	0x14d,a5
}
    800023e4:	60e2                	ld	ra,24(sp)
    800023e6:	6442                	ld	s0,16(sp)
    800023e8:	64a2                	ld	s1,8(sp)
    800023ea:	6105                	addi	sp,sp,32
    800023ec:	8082                	ret
    acquire(&tickslock);
    800023ee:	00013497          	auipc	s1,0x13
    800023f2:	49248493          	addi	s1,s1,1170 # 80015880 <tickslock>
    800023f6:	8526                	mv	a0,s1
    800023f8:	fa0fe0ef          	jal	ra,80000b98 <acquire>
    ticks++;
    800023fc:	00005517          	auipc	a0,0x5
    80002400:	52450513          	addi	a0,a0,1316 # 80007920 <ticks>
    80002404:	411c                	lw	a5,0(a0)
    80002406:	2785                	addiw	a5,a5,1
    80002408:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    8000240a:	a39ff0ef          	jal	ra,80001e42 <wakeup>
    release(&tickslock);
    8000240e:	8526                	mv	a0,s1
    80002410:	821fe0ef          	jal	ra,80000c30 <release>
    80002414:	bf7d                	j	800023d2 <clockintr+0x10>

0000000080002416 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80002416:	1101                	addi	sp,sp,-32
    80002418:	ec06                	sd	ra,24(sp)
    8000241a:	e822                	sd	s0,16(sp)
    8000241c:	e426                	sd	s1,8(sp)
    8000241e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002420:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    80002424:	57fd                	li	a5,-1
    80002426:	17fe                	slli	a5,a5,0x3f
    80002428:	07a5                	addi	a5,a5,9
    8000242a:	00f70d63          	beq	a4,a5,80002444 <devintr+0x2e>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    8000242e:	57fd                	li	a5,-1
    80002430:	17fe                	slli	a5,a5,0x3f
    80002432:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    80002434:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    80002436:	04f70463          	beq	a4,a5,8000247e <devintr+0x68>
  }
}
    8000243a:	60e2                	ld	ra,24(sp)
    8000243c:	6442                	ld	s0,16(sp)
    8000243e:	64a2                	ld	s1,8(sp)
    80002440:	6105                	addi	sp,sp,32
    80002442:	8082                	ret
    int irq = plic_claim();
    80002444:	4b5020ef          	jal	ra,800050f8 <plic_claim>
    80002448:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    8000244a:	47a9                	li	a5,10
    8000244c:	02f50363          	beq	a0,a5,80002472 <devintr+0x5c>
    } else if(irq == VIRTIO0_IRQ){
    80002450:	4785                	li	a5,1
    80002452:	02f50363          	beq	a0,a5,80002478 <devintr+0x62>
    return 1;
    80002456:	4505                	li	a0,1
    } else if(irq){
    80002458:	d0ed                	beqz	s1,8000243a <devintr+0x24>
      printf("unexpected interrupt irq=%d\n", irq);
    8000245a:	85a6                	mv	a1,s1
    8000245c:	00005517          	auipc	a0,0x5
    80002460:	edc50513          	addi	a0,a0,-292 # 80007338 <states.0+0x38>
    80002464:	83efe0ef          	jal	ra,800004a2 <printf>
      plic_complete(irq);
    80002468:	8526                	mv	a0,s1
    8000246a:	4af020ef          	jal	ra,80005118 <plic_complete>
    return 1;
    8000246e:	4505                	li	a0,1
    80002470:	b7e9                	j	8000243a <devintr+0x24>
      uartintr();
    80002472:	d38fe0ef          	jal	ra,800009aa <uartintr>
    80002476:	bfcd                	j	80002468 <devintr+0x52>
      virtio_disk_intr();
    80002478:	10c030ef          	jal	ra,80005584 <virtio_disk_intr>
    8000247c:	b7f5                	j	80002468 <devintr+0x52>
    clockintr();
    8000247e:	f45ff0ef          	jal	ra,800023c2 <clockintr>
    return 2;
    80002482:	4509                	li	a0,2
    80002484:	bf5d                	j	8000243a <devintr+0x24>

0000000080002486 <usertrap>:
{
    80002486:	1101                	addi	sp,sp,-32
    80002488:	ec06                	sd	ra,24(sp)
    8000248a:	e822                	sd	s0,16(sp)
    8000248c:	e426                	sd	s1,8(sp)
    8000248e:	e04a                	sd	s2,0(sp)
    80002490:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002492:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80002496:	1007f793          	andi	a5,a5,256
    8000249a:	ef85                	bnez	a5,800024d2 <usertrap+0x4c>
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000249c:	00003797          	auipc	a5,0x3
    800024a0:	bb478793          	addi	a5,a5,-1100 # 80005050 <kernelvec>
    800024a4:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    800024a8:	b82ff0ef          	jal	ra,8000182a <myproc>
    800024ac:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    800024ae:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800024b0:	14102773          	csrr	a4,sepc
    800024b4:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    800024b6:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    800024ba:	47a1                	li	a5,8
    800024bc:	02f70163          	beq	a4,a5,800024de <usertrap+0x58>
  } else if((which_dev = devintr()) != 0){
    800024c0:	f57ff0ef          	jal	ra,80002416 <devintr>
    800024c4:	892a                	mv	s2,a0
    800024c6:	c135                	beqz	a0,8000252a <usertrap+0xa4>
  if(killed(p))
    800024c8:	8526                	mv	a0,s1
    800024ca:	b65ff0ef          	jal	ra,8000202e <killed>
    800024ce:	cd1d                	beqz	a0,8000250c <usertrap+0x86>
    800024d0:	a81d                	j	80002506 <usertrap+0x80>
    panic("usertrap: not from user mode");
    800024d2:	00005517          	auipc	a0,0x5
    800024d6:	e8650513          	addi	a0,a0,-378 # 80007358 <states.0+0x58>
    800024da:	a7cfe0ef          	jal	ra,80000756 <panic>
    if(killed(p))
    800024de:	b51ff0ef          	jal	ra,8000202e <killed>
    800024e2:	e121                	bnez	a0,80002522 <usertrap+0x9c>
    p->trapframe->epc += 4;
    800024e4:	6cb8                	ld	a4,88(s1)
    800024e6:	6f1c                	ld	a5,24(a4)
    800024e8:	0791                	addi	a5,a5,4
    800024ea:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800024ec:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800024f0:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800024f4:	10079073          	csrw	sstatus,a5
    syscall();
    800024f8:	248000ef          	jal	ra,80002740 <syscall>
  if(killed(p))
    800024fc:	8526                	mv	a0,s1
    800024fe:	b31ff0ef          	jal	ra,8000202e <killed>
    80002502:	c901                	beqz	a0,80002512 <usertrap+0x8c>
    80002504:	4901                	li	s2,0
    exit(-1);
    80002506:	557d                	li	a0,-1
    80002508:	9fbff0ef          	jal	ra,80001f02 <exit>
  if(which_dev == 2)
    8000250c:	4789                	li	a5,2
    8000250e:	04f90563          	beq	s2,a5,80002558 <usertrap+0xd2>
  usertrapret();
    80002512:	e1fff0ef          	jal	ra,80002330 <usertrapret>
}
    80002516:	60e2                	ld	ra,24(sp)
    80002518:	6442                	ld	s0,16(sp)
    8000251a:	64a2                	ld	s1,8(sp)
    8000251c:	6902                	ld	s2,0(sp)
    8000251e:	6105                	addi	sp,sp,32
    80002520:	8082                	ret
      exit(-1);
    80002522:	557d                	li	a0,-1
    80002524:	9dfff0ef          	jal	ra,80001f02 <exit>
    80002528:	bf75                	j	800024e4 <usertrap+0x5e>
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000252a:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    8000252e:	5890                	lw	a2,48(s1)
    80002530:	00005517          	auipc	a0,0x5
    80002534:	e4850513          	addi	a0,a0,-440 # 80007378 <states.0+0x78>
    80002538:	f6bfd0ef          	jal	ra,800004a2 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000253c:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002540:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    80002544:	00005517          	auipc	a0,0x5
    80002548:	e6450513          	addi	a0,a0,-412 # 800073a8 <states.0+0xa8>
    8000254c:	f57fd0ef          	jal	ra,800004a2 <printf>
    setkilled(p);
    80002550:	8526                	mv	a0,s1
    80002552:	ab9ff0ef          	jal	ra,8000200a <setkilled>
    80002556:	b75d                	j	800024fc <usertrap+0x76>
    yield();
    80002558:	873ff0ef          	jal	ra,80001dca <yield>
    8000255c:	bf5d                	j	80002512 <usertrap+0x8c>

000000008000255e <kerneltrap>:
{
    8000255e:	7179                	addi	sp,sp,-48
    80002560:	f406                	sd	ra,40(sp)
    80002562:	f022                	sd	s0,32(sp)
    80002564:	ec26                	sd	s1,24(sp)
    80002566:	e84a                	sd	s2,16(sp)
    80002568:	e44e                	sd	s3,8(sp)
    8000256a:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000256c:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002570:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002574:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80002578:	1004f793          	andi	a5,s1,256
    8000257c:	c795                	beqz	a5,800025a8 <kerneltrap+0x4a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000257e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002582:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80002584:	eb85                	bnez	a5,800025b4 <kerneltrap+0x56>
  if((which_dev = devintr()) == 0){
    80002586:	e91ff0ef          	jal	ra,80002416 <devintr>
    8000258a:	c91d                	beqz	a0,800025c0 <kerneltrap+0x62>
  if(which_dev == 2 && myproc() != 0)
    8000258c:	4789                	li	a5,2
    8000258e:	04f50a63          	beq	a0,a5,800025e2 <kerneltrap+0x84>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002592:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002596:	10049073          	csrw	sstatus,s1
}
    8000259a:	70a2                	ld	ra,40(sp)
    8000259c:	7402                	ld	s0,32(sp)
    8000259e:	64e2                	ld	s1,24(sp)
    800025a0:	6942                	ld	s2,16(sp)
    800025a2:	69a2                	ld	s3,8(sp)
    800025a4:	6145                	addi	sp,sp,48
    800025a6:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    800025a8:	00005517          	auipc	a0,0x5
    800025ac:	e2850513          	addi	a0,a0,-472 # 800073d0 <states.0+0xd0>
    800025b0:	9a6fe0ef          	jal	ra,80000756 <panic>
    panic("kerneltrap: interrupts enabled");
    800025b4:	00005517          	auipc	a0,0x5
    800025b8:	e4450513          	addi	a0,a0,-444 # 800073f8 <states.0+0xf8>
    800025bc:	99afe0ef          	jal	ra,80000756 <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800025c0:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    800025c4:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    800025c8:	85ce                	mv	a1,s3
    800025ca:	00005517          	auipc	a0,0x5
    800025ce:	e4e50513          	addi	a0,a0,-434 # 80007418 <states.0+0x118>
    800025d2:	ed1fd0ef          	jal	ra,800004a2 <printf>
    panic("kerneltrap");
    800025d6:	00005517          	auipc	a0,0x5
    800025da:	e6a50513          	addi	a0,a0,-406 # 80007440 <states.0+0x140>
    800025de:	978fe0ef          	jal	ra,80000756 <panic>
  if(which_dev == 2 && myproc() != 0)
    800025e2:	a48ff0ef          	jal	ra,8000182a <myproc>
    800025e6:	d555                	beqz	a0,80002592 <kerneltrap+0x34>
    yield();
    800025e8:	fe2ff0ef          	jal	ra,80001dca <yield>
    800025ec:	b75d                	j	80002592 <kerneltrap+0x34>

00000000800025ee <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    800025ee:	1101                	addi	sp,sp,-32
    800025f0:	ec06                	sd	ra,24(sp)
    800025f2:	e822                	sd	s0,16(sp)
    800025f4:	e426                	sd	s1,8(sp)
    800025f6:	1000                	addi	s0,sp,32
    800025f8:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800025fa:	a30ff0ef          	jal	ra,8000182a <myproc>
  switch (n) {
    800025fe:	4795                	li	a5,5
    80002600:	0497e163          	bltu	a5,s1,80002642 <argraw+0x54>
    80002604:	048a                	slli	s1,s1,0x2
    80002606:	00005717          	auipc	a4,0x5
    8000260a:	e7270713          	addi	a4,a4,-398 # 80007478 <states.0+0x178>
    8000260e:	94ba                	add	s1,s1,a4
    80002610:	409c                	lw	a5,0(s1)
    80002612:	97ba                	add	a5,a5,a4
    80002614:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002616:	6d3c                	ld	a5,88(a0)
    80002618:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    8000261a:	60e2                	ld	ra,24(sp)
    8000261c:	6442                	ld	s0,16(sp)
    8000261e:	64a2                	ld	s1,8(sp)
    80002620:	6105                	addi	sp,sp,32
    80002622:	8082                	ret
    return p->trapframe->a1;
    80002624:	6d3c                	ld	a5,88(a0)
    80002626:	7fa8                	ld	a0,120(a5)
    80002628:	bfcd                	j	8000261a <argraw+0x2c>
    return p->trapframe->a2;
    8000262a:	6d3c                	ld	a5,88(a0)
    8000262c:	63c8                	ld	a0,128(a5)
    8000262e:	b7f5                	j	8000261a <argraw+0x2c>
    return p->trapframe->a3;
    80002630:	6d3c                	ld	a5,88(a0)
    80002632:	67c8                	ld	a0,136(a5)
    80002634:	b7dd                	j	8000261a <argraw+0x2c>
    return p->trapframe->a4;
    80002636:	6d3c                	ld	a5,88(a0)
    80002638:	6bc8                	ld	a0,144(a5)
    8000263a:	b7c5                	j	8000261a <argraw+0x2c>
    return p->trapframe->a5;
    8000263c:	6d3c                	ld	a5,88(a0)
    8000263e:	6fc8                	ld	a0,152(a5)
    80002640:	bfe9                	j	8000261a <argraw+0x2c>
  panic("argraw");
    80002642:	00005517          	auipc	a0,0x5
    80002646:	e0e50513          	addi	a0,a0,-498 # 80007450 <states.0+0x150>
    8000264a:	90cfe0ef          	jal	ra,80000756 <panic>

000000008000264e <fetchaddr>:
{
    8000264e:	1101                	addi	sp,sp,-32
    80002650:	ec06                	sd	ra,24(sp)
    80002652:	e822                	sd	s0,16(sp)
    80002654:	e426                	sd	s1,8(sp)
    80002656:	e04a                	sd	s2,0(sp)
    80002658:	1000                	addi	s0,sp,32
    8000265a:	84aa                	mv	s1,a0
    8000265c:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000265e:	9ccff0ef          	jal	ra,8000182a <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80002662:	653c                	ld	a5,72(a0)
    80002664:	02f4f663          	bgeu	s1,a5,80002690 <fetchaddr+0x42>
    80002668:	00848713          	addi	a4,s1,8
    8000266c:	02e7e463          	bltu	a5,a4,80002694 <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002670:	46a1                	li	a3,8
    80002672:	8626                	mv	a2,s1
    80002674:	85ca                	mv	a1,s2
    80002676:	6928                	ld	a0,80(a0)
    80002678:	f23fe0ef          	jal	ra,8000159a <copyin>
    8000267c:	00a03533          	snez	a0,a0
    80002680:	40a00533          	neg	a0,a0
}
    80002684:	60e2                	ld	ra,24(sp)
    80002686:	6442                	ld	s0,16(sp)
    80002688:	64a2                	ld	s1,8(sp)
    8000268a:	6902                	ld	s2,0(sp)
    8000268c:	6105                	addi	sp,sp,32
    8000268e:	8082                	ret
    return -1;
    80002690:	557d                	li	a0,-1
    80002692:	bfcd                	j	80002684 <fetchaddr+0x36>
    80002694:	557d                	li	a0,-1
    80002696:	b7fd                	j	80002684 <fetchaddr+0x36>

0000000080002698 <fetchstr>:
{
    80002698:	7179                	addi	sp,sp,-48
    8000269a:	f406                	sd	ra,40(sp)
    8000269c:	f022                	sd	s0,32(sp)
    8000269e:	ec26                	sd	s1,24(sp)
    800026a0:	e84a                	sd	s2,16(sp)
    800026a2:	e44e                	sd	s3,8(sp)
    800026a4:	1800                	addi	s0,sp,48
    800026a6:	892a                	mv	s2,a0
    800026a8:	84ae                	mv	s1,a1
    800026aa:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    800026ac:	97eff0ef          	jal	ra,8000182a <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    800026b0:	86ce                	mv	a3,s3
    800026b2:	864a                	mv	a2,s2
    800026b4:	85a6                	mv	a1,s1
    800026b6:	6928                	ld	a0,80(a0)
    800026b8:	f69fe0ef          	jal	ra,80001620 <copyinstr>
    800026bc:	00054c63          	bltz	a0,800026d4 <fetchstr+0x3c>
  return strlen(buf);
    800026c0:	8526                	mv	a0,s1
    800026c2:	f22fe0ef          	jal	ra,80000de4 <strlen>
}
    800026c6:	70a2                	ld	ra,40(sp)
    800026c8:	7402                	ld	s0,32(sp)
    800026ca:	64e2                	ld	s1,24(sp)
    800026cc:	6942                	ld	s2,16(sp)
    800026ce:	69a2                	ld	s3,8(sp)
    800026d0:	6145                	addi	sp,sp,48
    800026d2:	8082                	ret
    return -1;
    800026d4:	557d                	li	a0,-1
    800026d6:	bfc5                	j	800026c6 <fetchstr+0x2e>

00000000800026d8 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    800026d8:	1101                	addi	sp,sp,-32
    800026da:	ec06                	sd	ra,24(sp)
    800026dc:	e822                	sd	s0,16(sp)
    800026de:	e426                	sd	s1,8(sp)
    800026e0:	1000                	addi	s0,sp,32
    800026e2:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800026e4:	f0bff0ef          	jal	ra,800025ee <argraw>
    800026e8:	c088                	sw	a0,0(s1)
}
    800026ea:	60e2                	ld	ra,24(sp)
    800026ec:	6442                	ld	s0,16(sp)
    800026ee:	64a2                	ld	s1,8(sp)
    800026f0:	6105                	addi	sp,sp,32
    800026f2:	8082                	ret

00000000800026f4 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    800026f4:	1101                	addi	sp,sp,-32
    800026f6:	ec06                	sd	ra,24(sp)
    800026f8:	e822                	sd	s0,16(sp)
    800026fa:	e426                	sd	s1,8(sp)
    800026fc:	1000                	addi	s0,sp,32
    800026fe:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002700:	eefff0ef          	jal	ra,800025ee <argraw>
    80002704:	e088                	sd	a0,0(s1)
}
    80002706:	60e2                	ld	ra,24(sp)
    80002708:	6442                	ld	s0,16(sp)
    8000270a:	64a2                	ld	s1,8(sp)
    8000270c:	6105                	addi	sp,sp,32
    8000270e:	8082                	ret

0000000080002710 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002710:	7179                	addi	sp,sp,-48
    80002712:	f406                	sd	ra,40(sp)
    80002714:	f022                	sd	s0,32(sp)
    80002716:	ec26                	sd	s1,24(sp)
    80002718:	e84a                	sd	s2,16(sp)
    8000271a:	1800                	addi	s0,sp,48
    8000271c:	84ae                	mv	s1,a1
    8000271e:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80002720:	fd840593          	addi	a1,s0,-40
    80002724:	fd1ff0ef          	jal	ra,800026f4 <argaddr>
  return fetchstr(addr, buf, max);
    80002728:	864a                	mv	a2,s2
    8000272a:	85a6                	mv	a1,s1
    8000272c:	fd843503          	ld	a0,-40(s0)
    80002730:	f69ff0ef          	jal	ra,80002698 <fetchstr>
}
    80002734:	70a2                	ld	ra,40(sp)
    80002736:	7402                	ld	s0,32(sp)
    80002738:	64e2                	ld	s1,24(sp)
    8000273a:	6942                	ld	s2,16(sp)
    8000273c:	6145                	addi	sp,sp,48
    8000273e:	8082                	ret

0000000080002740 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    80002740:	1101                	addi	sp,sp,-32
    80002742:	ec06                	sd	ra,24(sp)
    80002744:	e822                	sd	s0,16(sp)
    80002746:	e426                	sd	s1,8(sp)
    80002748:	e04a                	sd	s2,0(sp)
    8000274a:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    8000274c:	8deff0ef          	jal	ra,8000182a <myproc>
    80002750:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002752:	05853903          	ld	s2,88(a0)
    80002756:	0a893783          	ld	a5,168(s2)
    8000275a:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    8000275e:	37fd                	addiw	a5,a5,-1
    80002760:	4751                	li	a4,20
    80002762:	00f76f63          	bltu	a4,a5,80002780 <syscall+0x40>
    80002766:	00369713          	slli	a4,a3,0x3
    8000276a:	00005797          	auipc	a5,0x5
    8000276e:	d2678793          	addi	a5,a5,-730 # 80007490 <syscalls>
    80002772:	97ba                	add	a5,a5,a4
    80002774:	639c                	ld	a5,0(a5)
    80002776:	c789                	beqz	a5,80002780 <syscall+0x40>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80002778:	9782                	jalr	a5
    8000277a:	06a93823          	sd	a0,112(s2)
    8000277e:	a829                	j	80002798 <syscall+0x58>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002780:	15848613          	addi	a2,s1,344
    80002784:	588c                	lw	a1,48(s1)
    80002786:	00005517          	auipc	a0,0x5
    8000278a:	cd250513          	addi	a0,a0,-814 # 80007458 <states.0+0x158>
    8000278e:	d15fd0ef          	jal	ra,800004a2 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002792:	6cbc                	ld	a5,88(s1)
    80002794:	577d                	li	a4,-1
    80002796:	fbb8                	sd	a4,112(a5)
  }
}
    80002798:	60e2                	ld	ra,24(sp)
    8000279a:	6442                	ld	s0,16(sp)
    8000279c:	64a2                	ld	s1,8(sp)
    8000279e:	6902                	ld	s2,0(sp)
    800027a0:	6105                	addi	sp,sp,32
    800027a2:	8082                	ret

00000000800027a4 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    800027a4:	1101                	addi	sp,sp,-32
    800027a6:	ec06                	sd	ra,24(sp)
    800027a8:	e822                	sd	s0,16(sp)
    800027aa:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    800027ac:	fec40593          	addi	a1,s0,-20
    800027b0:	4501                	li	a0,0
    800027b2:	f27ff0ef          	jal	ra,800026d8 <argint>
  exit(n);
    800027b6:	fec42503          	lw	a0,-20(s0)
    800027ba:	f48ff0ef          	jal	ra,80001f02 <exit>
  return 0;  // not reached
}
    800027be:	4501                	li	a0,0
    800027c0:	60e2                	ld	ra,24(sp)
    800027c2:	6442                	ld	s0,16(sp)
    800027c4:	6105                	addi	sp,sp,32
    800027c6:	8082                	ret

00000000800027c8 <sys_getpid>:

uint64
sys_getpid(void)
{
    800027c8:	1141                	addi	sp,sp,-16
    800027ca:	e406                	sd	ra,8(sp)
    800027cc:	e022                	sd	s0,0(sp)
    800027ce:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800027d0:	85aff0ef          	jal	ra,8000182a <myproc>
}
    800027d4:	5908                	lw	a0,48(a0)
    800027d6:	60a2                	ld	ra,8(sp)
    800027d8:	6402                	ld	s0,0(sp)
    800027da:	0141                	addi	sp,sp,16
    800027dc:	8082                	ret

00000000800027de <sys_fork>:

uint64
sys_fork(void)
{
    800027de:	1141                	addi	sp,sp,-16
    800027e0:	e406                	sd	ra,8(sp)
    800027e2:	e022                	sd	s0,0(sp)
    800027e4:	0800                	addi	s0,sp,16
  return fork();
    800027e6:	b6aff0ef          	jal	ra,80001b50 <fork>
}
    800027ea:	60a2                	ld	ra,8(sp)
    800027ec:	6402                	ld	s0,0(sp)
    800027ee:	0141                	addi	sp,sp,16
    800027f0:	8082                	ret

00000000800027f2 <sys_wait>:

uint64
sys_wait(void)
{
    800027f2:	1101                	addi	sp,sp,-32
    800027f4:	ec06                	sd	ra,24(sp)
    800027f6:	e822                	sd	s0,16(sp)
    800027f8:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    800027fa:	fe840593          	addi	a1,s0,-24
    800027fe:	4501                	li	a0,0
    80002800:	ef5ff0ef          	jal	ra,800026f4 <argaddr>
  return wait(p);
    80002804:	fe843503          	ld	a0,-24(s0)
    80002808:	851ff0ef          	jal	ra,80002058 <wait>
}
    8000280c:	60e2                	ld	ra,24(sp)
    8000280e:	6442                	ld	s0,16(sp)
    80002810:	6105                	addi	sp,sp,32
    80002812:	8082                	ret

0000000080002814 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002814:	7179                	addi	sp,sp,-48
    80002816:	f406                	sd	ra,40(sp)
    80002818:	f022                	sd	s0,32(sp)
    8000281a:	ec26                	sd	s1,24(sp)
    8000281c:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    8000281e:	fdc40593          	addi	a1,s0,-36
    80002822:	4501                	li	a0,0
    80002824:	eb5ff0ef          	jal	ra,800026d8 <argint>
  addr = myproc()->sz;
    80002828:	802ff0ef          	jal	ra,8000182a <myproc>
    8000282c:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    8000282e:	fdc42503          	lw	a0,-36(s0)
    80002832:	aceff0ef          	jal	ra,80001b00 <growproc>
    80002836:	00054863          	bltz	a0,80002846 <sys_sbrk+0x32>
    return -1;
  return addr;
}
    8000283a:	8526                	mv	a0,s1
    8000283c:	70a2                	ld	ra,40(sp)
    8000283e:	7402                	ld	s0,32(sp)
    80002840:	64e2                	ld	s1,24(sp)
    80002842:	6145                	addi	sp,sp,48
    80002844:	8082                	ret
    return -1;
    80002846:	54fd                	li	s1,-1
    80002848:	bfcd                	j	8000283a <sys_sbrk+0x26>

000000008000284a <sys_sleep>:

uint64
sys_sleep(void)
{
    8000284a:	7139                	addi	sp,sp,-64
    8000284c:	fc06                	sd	ra,56(sp)
    8000284e:	f822                	sd	s0,48(sp)
    80002850:	f426                	sd	s1,40(sp)
    80002852:	f04a                	sd	s2,32(sp)
    80002854:	ec4e                	sd	s3,24(sp)
    80002856:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80002858:	fcc40593          	addi	a1,s0,-52
    8000285c:	4501                	li	a0,0
    8000285e:	e7bff0ef          	jal	ra,800026d8 <argint>
  if(n < 0)
    80002862:	fcc42783          	lw	a5,-52(s0)
    80002866:	0607c563          	bltz	a5,800028d0 <sys_sleep+0x86>
    n = 0;
  acquire(&tickslock);
    8000286a:	00013517          	auipc	a0,0x13
    8000286e:	01650513          	addi	a0,a0,22 # 80015880 <tickslock>
    80002872:	b26fe0ef          	jal	ra,80000b98 <acquire>
  ticks0 = ticks;
    80002876:	00005917          	auipc	s2,0x5
    8000287a:	0aa92903          	lw	s2,170(s2) # 80007920 <ticks>
  while(ticks - ticks0 < n){
    8000287e:	fcc42783          	lw	a5,-52(s0)
    80002882:	cb8d                	beqz	a5,800028b4 <sys_sleep+0x6a>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002884:	00013997          	auipc	s3,0x13
    80002888:	ffc98993          	addi	s3,s3,-4 # 80015880 <tickslock>
    8000288c:	00005497          	auipc	s1,0x5
    80002890:	09448493          	addi	s1,s1,148 # 80007920 <ticks>
    if(killed(myproc())){
    80002894:	f97fe0ef          	jal	ra,8000182a <myproc>
    80002898:	f96ff0ef          	jal	ra,8000202e <killed>
    8000289c:	ed0d                	bnez	a0,800028d6 <sys_sleep+0x8c>
    sleep(&ticks, &tickslock);
    8000289e:	85ce                	mv	a1,s3
    800028a0:	8526                	mv	a0,s1
    800028a2:	d54ff0ef          	jal	ra,80001df6 <sleep>
  while(ticks - ticks0 < n){
    800028a6:	409c                	lw	a5,0(s1)
    800028a8:	412787bb          	subw	a5,a5,s2
    800028ac:	fcc42703          	lw	a4,-52(s0)
    800028b0:	fee7e2e3          	bltu	a5,a4,80002894 <sys_sleep+0x4a>
  }
  release(&tickslock);
    800028b4:	00013517          	auipc	a0,0x13
    800028b8:	fcc50513          	addi	a0,a0,-52 # 80015880 <tickslock>
    800028bc:	b74fe0ef          	jal	ra,80000c30 <release>
  return 0;
    800028c0:	4501                	li	a0,0
}
    800028c2:	70e2                	ld	ra,56(sp)
    800028c4:	7442                	ld	s0,48(sp)
    800028c6:	74a2                	ld	s1,40(sp)
    800028c8:	7902                	ld	s2,32(sp)
    800028ca:	69e2                	ld	s3,24(sp)
    800028cc:	6121                	addi	sp,sp,64
    800028ce:	8082                	ret
    n = 0;
    800028d0:	fc042623          	sw	zero,-52(s0)
    800028d4:	bf59                	j	8000286a <sys_sleep+0x20>
      release(&tickslock);
    800028d6:	00013517          	auipc	a0,0x13
    800028da:	faa50513          	addi	a0,a0,-86 # 80015880 <tickslock>
    800028de:	b52fe0ef          	jal	ra,80000c30 <release>
      return -1;
    800028e2:	557d                	li	a0,-1
    800028e4:	bff9                	j	800028c2 <sys_sleep+0x78>

00000000800028e6 <sys_kill>:

uint64
sys_kill(void)
{
    800028e6:	1101                	addi	sp,sp,-32
    800028e8:	ec06                	sd	ra,24(sp)
    800028ea:	e822                	sd	s0,16(sp)
    800028ec:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    800028ee:	fec40593          	addi	a1,s0,-20
    800028f2:	4501                	li	a0,0
    800028f4:	de5ff0ef          	jal	ra,800026d8 <argint>
  return kill(pid);
    800028f8:	fec42503          	lw	a0,-20(s0)
    800028fc:	ea8ff0ef          	jal	ra,80001fa4 <kill>
}
    80002900:	60e2                	ld	ra,24(sp)
    80002902:	6442                	ld	s0,16(sp)
    80002904:	6105                	addi	sp,sp,32
    80002906:	8082                	ret

0000000080002908 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002908:	1101                	addi	sp,sp,-32
    8000290a:	ec06                	sd	ra,24(sp)
    8000290c:	e822                	sd	s0,16(sp)
    8000290e:	e426                	sd	s1,8(sp)
    80002910:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002912:	00013517          	auipc	a0,0x13
    80002916:	f6e50513          	addi	a0,a0,-146 # 80015880 <tickslock>
    8000291a:	a7efe0ef          	jal	ra,80000b98 <acquire>
  xticks = ticks;
    8000291e:	00005497          	auipc	s1,0x5
    80002922:	0024a483          	lw	s1,2(s1) # 80007920 <ticks>
  release(&tickslock);
    80002926:	00013517          	auipc	a0,0x13
    8000292a:	f5a50513          	addi	a0,a0,-166 # 80015880 <tickslock>
    8000292e:	b02fe0ef          	jal	ra,80000c30 <release>
  return xticks;
}
    80002932:	02049513          	slli	a0,s1,0x20
    80002936:	9101                	srli	a0,a0,0x20
    80002938:	60e2                	ld	ra,24(sp)
    8000293a:	6442                	ld	s0,16(sp)
    8000293c:	64a2                	ld	s1,8(sp)
    8000293e:	6105                	addi	sp,sp,32
    80002940:	8082                	ret

0000000080002942 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002942:	7179                	addi	sp,sp,-48
    80002944:	f406                	sd	ra,40(sp)
    80002946:	f022                	sd	s0,32(sp)
    80002948:	ec26                	sd	s1,24(sp)
    8000294a:	e84a                	sd	s2,16(sp)
    8000294c:	e44e                	sd	s3,8(sp)
    8000294e:	e052                	sd	s4,0(sp)
    80002950:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002952:	00005597          	auipc	a1,0x5
    80002956:	bee58593          	addi	a1,a1,-1042 # 80007540 <syscalls+0xb0>
    8000295a:	00013517          	auipc	a0,0x13
    8000295e:	f3e50513          	addi	a0,a0,-194 # 80015898 <bcache>
    80002962:	9b6fe0ef          	jal	ra,80000b18 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002966:	0001b797          	auipc	a5,0x1b
    8000296a:	f3278793          	addi	a5,a5,-206 # 8001d898 <bcache+0x8000>
    8000296e:	0001b717          	auipc	a4,0x1b
    80002972:	19270713          	addi	a4,a4,402 # 8001db00 <bcache+0x8268>
    80002976:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    8000297a:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000297e:	00013497          	auipc	s1,0x13
    80002982:	f3248493          	addi	s1,s1,-206 # 800158b0 <bcache+0x18>
    b->next = bcache.head.next;
    80002986:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002988:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    8000298a:	00005a17          	auipc	s4,0x5
    8000298e:	bbea0a13          	addi	s4,s4,-1090 # 80007548 <syscalls+0xb8>
    b->next = bcache.head.next;
    80002992:	2b893783          	ld	a5,696(s2)
    80002996:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002998:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    8000299c:	85d2                	mv	a1,s4
    8000299e:	01048513          	addi	a0,s1,16
    800029a2:	228010ef          	jal	ra,80003bca <initsleeplock>
    bcache.head.next->prev = b;
    800029a6:	2b893783          	ld	a5,696(s2)
    800029aa:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800029ac:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800029b0:	45848493          	addi	s1,s1,1112
    800029b4:	fd349fe3          	bne	s1,s3,80002992 <binit+0x50>
  }
}
    800029b8:	70a2                	ld	ra,40(sp)
    800029ba:	7402                	ld	s0,32(sp)
    800029bc:	64e2                	ld	s1,24(sp)
    800029be:	6942                	ld	s2,16(sp)
    800029c0:	69a2                	ld	s3,8(sp)
    800029c2:	6a02                	ld	s4,0(sp)
    800029c4:	6145                	addi	sp,sp,48
    800029c6:	8082                	ret

00000000800029c8 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800029c8:	7179                	addi	sp,sp,-48
    800029ca:	f406                	sd	ra,40(sp)
    800029cc:	f022                	sd	s0,32(sp)
    800029ce:	ec26                	sd	s1,24(sp)
    800029d0:	e84a                	sd	s2,16(sp)
    800029d2:	e44e                	sd	s3,8(sp)
    800029d4:	1800                	addi	s0,sp,48
    800029d6:	892a                	mv	s2,a0
    800029d8:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    800029da:	00013517          	auipc	a0,0x13
    800029de:	ebe50513          	addi	a0,a0,-322 # 80015898 <bcache>
    800029e2:	9b6fe0ef          	jal	ra,80000b98 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800029e6:	0001b497          	auipc	s1,0x1b
    800029ea:	16a4b483          	ld	s1,362(s1) # 8001db50 <bcache+0x82b8>
    800029ee:	0001b797          	auipc	a5,0x1b
    800029f2:	11278793          	addi	a5,a5,274 # 8001db00 <bcache+0x8268>
    800029f6:	02f48b63          	beq	s1,a5,80002a2c <bread+0x64>
    800029fa:	873e                	mv	a4,a5
    800029fc:	a021                	j	80002a04 <bread+0x3c>
    800029fe:	68a4                	ld	s1,80(s1)
    80002a00:	02e48663          	beq	s1,a4,80002a2c <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    80002a04:	449c                	lw	a5,8(s1)
    80002a06:	ff279ce3          	bne	a5,s2,800029fe <bread+0x36>
    80002a0a:	44dc                	lw	a5,12(s1)
    80002a0c:	ff3799e3          	bne	a5,s3,800029fe <bread+0x36>
      b->refcnt++;
    80002a10:	40bc                	lw	a5,64(s1)
    80002a12:	2785                	addiw	a5,a5,1
    80002a14:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002a16:	00013517          	auipc	a0,0x13
    80002a1a:	e8250513          	addi	a0,a0,-382 # 80015898 <bcache>
    80002a1e:	a12fe0ef          	jal	ra,80000c30 <release>
      acquiresleep(&b->lock);
    80002a22:	01048513          	addi	a0,s1,16
    80002a26:	1da010ef          	jal	ra,80003c00 <acquiresleep>
      return b;
    80002a2a:	a889                	j	80002a7c <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002a2c:	0001b497          	auipc	s1,0x1b
    80002a30:	11c4b483          	ld	s1,284(s1) # 8001db48 <bcache+0x82b0>
    80002a34:	0001b797          	auipc	a5,0x1b
    80002a38:	0cc78793          	addi	a5,a5,204 # 8001db00 <bcache+0x8268>
    80002a3c:	00f48863          	beq	s1,a5,80002a4c <bread+0x84>
    80002a40:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002a42:	40bc                	lw	a5,64(s1)
    80002a44:	cb91                	beqz	a5,80002a58 <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002a46:	64a4                	ld	s1,72(s1)
    80002a48:	fee49de3          	bne	s1,a4,80002a42 <bread+0x7a>
  panic("bget: no buffers");
    80002a4c:	00005517          	auipc	a0,0x5
    80002a50:	b0450513          	addi	a0,a0,-1276 # 80007550 <syscalls+0xc0>
    80002a54:	d03fd0ef          	jal	ra,80000756 <panic>
      b->dev = dev;
    80002a58:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002a5c:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002a60:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002a64:	4785                	li	a5,1
    80002a66:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002a68:	00013517          	auipc	a0,0x13
    80002a6c:	e3050513          	addi	a0,a0,-464 # 80015898 <bcache>
    80002a70:	9c0fe0ef          	jal	ra,80000c30 <release>
      acquiresleep(&b->lock);
    80002a74:	01048513          	addi	a0,s1,16
    80002a78:	188010ef          	jal	ra,80003c00 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002a7c:	409c                	lw	a5,0(s1)
    80002a7e:	cb89                	beqz	a5,80002a90 <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002a80:	8526                	mv	a0,s1
    80002a82:	70a2                	ld	ra,40(sp)
    80002a84:	7402                	ld	s0,32(sp)
    80002a86:	64e2                	ld	s1,24(sp)
    80002a88:	6942                	ld	s2,16(sp)
    80002a8a:	69a2                	ld	s3,8(sp)
    80002a8c:	6145                	addi	sp,sp,48
    80002a8e:	8082                	ret
    virtio_disk_rw(b, 0);
    80002a90:	4581                	li	a1,0
    80002a92:	8526                	mv	a0,s1
    80002a94:	0d7020ef          	jal	ra,8000536a <virtio_disk_rw>
    b->valid = 1;
    80002a98:	4785                	li	a5,1
    80002a9a:	c09c                	sw	a5,0(s1)
  return b;
    80002a9c:	b7d5                	j	80002a80 <bread+0xb8>

0000000080002a9e <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002a9e:	1101                	addi	sp,sp,-32
    80002aa0:	ec06                	sd	ra,24(sp)
    80002aa2:	e822                	sd	s0,16(sp)
    80002aa4:	e426                	sd	s1,8(sp)
    80002aa6:	1000                	addi	s0,sp,32
    80002aa8:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002aaa:	0541                	addi	a0,a0,16
    80002aac:	1d2010ef          	jal	ra,80003c7e <holdingsleep>
    80002ab0:	c911                	beqz	a0,80002ac4 <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002ab2:	4585                	li	a1,1
    80002ab4:	8526                	mv	a0,s1
    80002ab6:	0b5020ef          	jal	ra,8000536a <virtio_disk_rw>
}
    80002aba:	60e2                	ld	ra,24(sp)
    80002abc:	6442                	ld	s0,16(sp)
    80002abe:	64a2                	ld	s1,8(sp)
    80002ac0:	6105                	addi	sp,sp,32
    80002ac2:	8082                	ret
    panic("bwrite");
    80002ac4:	00005517          	auipc	a0,0x5
    80002ac8:	aa450513          	addi	a0,a0,-1372 # 80007568 <syscalls+0xd8>
    80002acc:	c8bfd0ef          	jal	ra,80000756 <panic>

0000000080002ad0 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002ad0:	1101                	addi	sp,sp,-32
    80002ad2:	ec06                	sd	ra,24(sp)
    80002ad4:	e822                	sd	s0,16(sp)
    80002ad6:	e426                	sd	s1,8(sp)
    80002ad8:	e04a                	sd	s2,0(sp)
    80002ada:	1000                	addi	s0,sp,32
    80002adc:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002ade:	01050913          	addi	s2,a0,16
    80002ae2:	854a                	mv	a0,s2
    80002ae4:	19a010ef          	jal	ra,80003c7e <holdingsleep>
    80002ae8:	c13d                	beqz	a0,80002b4e <brelse+0x7e>
    panic("brelse");

  releasesleep(&b->lock);
    80002aea:	854a                	mv	a0,s2
    80002aec:	15a010ef          	jal	ra,80003c46 <releasesleep>

  acquire(&bcache.lock);
    80002af0:	00013517          	auipc	a0,0x13
    80002af4:	da850513          	addi	a0,a0,-600 # 80015898 <bcache>
    80002af8:	8a0fe0ef          	jal	ra,80000b98 <acquire>
  b->refcnt--;
    80002afc:	40bc                	lw	a5,64(s1)
    80002afe:	37fd                	addiw	a5,a5,-1
    80002b00:	0007871b          	sext.w	a4,a5
    80002b04:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002b06:	eb05                	bnez	a4,80002b36 <brelse+0x66>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002b08:	68bc                	ld	a5,80(s1)
    80002b0a:	64b8                	ld	a4,72(s1)
    80002b0c:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80002b0e:	64bc                	ld	a5,72(s1)
    80002b10:	68b8                	ld	a4,80(s1)
    80002b12:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002b14:	0001b797          	auipc	a5,0x1b
    80002b18:	d8478793          	addi	a5,a5,-636 # 8001d898 <bcache+0x8000>
    80002b1c:	2b87b703          	ld	a4,696(a5)
    80002b20:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002b22:	0001b717          	auipc	a4,0x1b
    80002b26:	fde70713          	addi	a4,a4,-34 # 8001db00 <bcache+0x8268>
    80002b2a:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002b2c:	2b87b703          	ld	a4,696(a5)
    80002b30:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002b32:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002b36:	00013517          	auipc	a0,0x13
    80002b3a:	d6250513          	addi	a0,a0,-670 # 80015898 <bcache>
    80002b3e:	8f2fe0ef          	jal	ra,80000c30 <release>
}
    80002b42:	60e2                	ld	ra,24(sp)
    80002b44:	6442                	ld	s0,16(sp)
    80002b46:	64a2                	ld	s1,8(sp)
    80002b48:	6902                	ld	s2,0(sp)
    80002b4a:	6105                	addi	sp,sp,32
    80002b4c:	8082                	ret
    panic("brelse");
    80002b4e:	00005517          	auipc	a0,0x5
    80002b52:	a2250513          	addi	a0,a0,-1502 # 80007570 <syscalls+0xe0>
    80002b56:	c01fd0ef          	jal	ra,80000756 <panic>

0000000080002b5a <bpin>:

void
bpin(struct buf *b) {
    80002b5a:	1101                	addi	sp,sp,-32
    80002b5c:	ec06                	sd	ra,24(sp)
    80002b5e:	e822                	sd	s0,16(sp)
    80002b60:	e426                	sd	s1,8(sp)
    80002b62:	1000                	addi	s0,sp,32
    80002b64:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002b66:	00013517          	auipc	a0,0x13
    80002b6a:	d3250513          	addi	a0,a0,-718 # 80015898 <bcache>
    80002b6e:	82afe0ef          	jal	ra,80000b98 <acquire>
  b->refcnt++;
    80002b72:	40bc                	lw	a5,64(s1)
    80002b74:	2785                	addiw	a5,a5,1
    80002b76:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002b78:	00013517          	auipc	a0,0x13
    80002b7c:	d2050513          	addi	a0,a0,-736 # 80015898 <bcache>
    80002b80:	8b0fe0ef          	jal	ra,80000c30 <release>
}
    80002b84:	60e2                	ld	ra,24(sp)
    80002b86:	6442                	ld	s0,16(sp)
    80002b88:	64a2                	ld	s1,8(sp)
    80002b8a:	6105                	addi	sp,sp,32
    80002b8c:	8082                	ret

0000000080002b8e <bunpin>:

void
bunpin(struct buf *b) {
    80002b8e:	1101                	addi	sp,sp,-32
    80002b90:	ec06                	sd	ra,24(sp)
    80002b92:	e822                	sd	s0,16(sp)
    80002b94:	e426                	sd	s1,8(sp)
    80002b96:	1000                	addi	s0,sp,32
    80002b98:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002b9a:	00013517          	auipc	a0,0x13
    80002b9e:	cfe50513          	addi	a0,a0,-770 # 80015898 <bcache>
    80002ba2:	ff7fd0ef          	jal	ra,80000b98 <acquire>
  b->refcnt--;
    80002ba6:	40bc                	lw	a5,64(s1)
    80002ba8:	37fd                	addiw	a5,a5,-1
    80002baa:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002bac:	00013517          	auipc	a0,0x13
    80002bb0:	cec50513          	addi	a0,a0,-788 # 80015898 <bcache>
    80002bb4:	87cfe0ef          	jal	ra,80000c30 <release>
}
    80002bb8:	60e2                	ld	ra,24(sp)
    80002bba:	6442                	ld	s0,16(sp)
    80002bbc:	64a2                	ld	s1,8(sp)
    80002bbe:	6105                	addi	sp,sp,32
    80002bc0:	8082                	ret

0000000080002bc2 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002bc2:	1101                	addi	sp,sp,-32
    80002bc4:	ec06                	sd	ra,24(sp)
    80002bc6:	e822                	sd	s0,16(sp)
    80002bc8:	e426                	sd	s1,8(sp)
    80002bca:	e04a                	sd	s2,0(sp)
    80002bcc:	1000                	addi	s0,sp,32
    80002bce:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002bd0:	00d5d59b          	srliw	a1,a1,0xd
    80002bd4:	0001b797          	auipc	a5,0x1b
    80002bd8:	3a07a783          	lw	a5,928(a5) # 8001df74 <sb+0x1c>
    80002bdc:	9dbd                	addw	a1,a1,a5
    80002bde:	debff0ef          	jal	ra,800029c8 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002be2:	0074f713          	andi	a4,s1,7
    80002be6:	4785                	li	a5,1
    80002be8:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002bec:	14ce                	slli	s1,s1,0x33
    80002bee:	90d9                	srli	s1,s1,0x36
    80002bf0:	00950733          	add	a4,a0,s1
    80002bf4:	05874703          	lbu	a4,88(a4)
    80002bf8:	00e7f6b3          	and	a3,a5,a4
    80002bfc:	c29d                	beqz	a3,80002c22 <bfree+0x60>
    80002bfe:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002c00:	94aa                	add	s1,s1,a0
    80002c02:	fff7c793          	not	a5,a5
    80002c06:	8f7d                	and	a4,a4,a5
    80002c08:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80002c0c:	6ef000ef          	jal	ra,80003afa <log_write>
  brelse(bp);
    80002c10:	854a                	mv	a0,s2
    80002c12:	ebfff0ef          	jal	ra,80002ad0 <brelse>
}
    80002c16:	60e2                	ld	ra,24(sp)
    80002c18:	6442                	ld	s0,16(sp)
    80002c1a:	64a2                	ld	s1,8(sp)
    80002c1c:	6902                	ld	s2,0(sp)
    80002c1e:	6105                	addi	sp,sp,32
    80002c20:	8082                	ret
    panic("freeing free block");
    80002c22:	00005517          	auipc	a0,0x5
    80002c26:	95650513          	addi	a0,a0,-1706 # 80007578 <syscalls+0xe8>
    80002c2a:	b2dfd0ef          	jal	ra,80000756 <panic>

0000000080002c2e <balloc>:
{
    80002c2e:	711d                	addi	sp,sp,-96
    80002c30:	ec86                	sd	ra,88(sp)
    80002c32:	e8a2                	sd	s0,80(sp)
    80002c34:	e4a6                	sd	s1,72(sp)
    80002c36:	e0ca                	sd	s2,64(sp)
    80002c38:	fc4e                	sd	s3,56(sp)
    80002c3a:	f852                	sd	s4,48(sp)
    80002c3c:	f456                	sd	s5,40(sp)
    80002c3e:	f05a                	sd	s6,32(sp)
    80002c40:	ec5e                	sd	s7,24(sp)
    80002c42:	e862                	sd	s8,16(sp)
    80002c44:	e466                	sd	s9,8(sp)
    80002c46:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002c48:	0001b797          	auipc	a5,0x1b
    80002c4c:	3147a783          	lw	a5,788(a5) # 8001df5c <sb+0x4>
    80002c50:	cff1                	beqz	a5,80002d2c <balloc+0xfe>
    80002c52:	8baa                	mv	s7,a0
    80002c54:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002c56:	0001bb17          	auipc	s6,0x1b
    80002c5a:	302b0b13          	addi	s6,s6,770 # 8001df58 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002c5e:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002c60:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002c62:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002c64:	6c89                	lui	s9,0x2
    80002c66:	a0b5                	j	80002cd2 <balloc+0xa4>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002c68:	97ca                	add	a5,a5,s2
    80002c6a:	8e55                	or	a2,a2,a3
    80002c6c:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80002c70:	854a                	mv	a0,s2
    80002c72:	689000ef          	jal	ra,80003afa <log_write>
        brelse(bp);
    80002c76:	854a                	mv	a0,s2
    80002c78:	e59ff0ef          	jal	ra,80002ad0 <brelse>
  bp = bread(dev, bno);
    80002c7c:	85a6                	mv	a1,s1
    80002c7e:	855e                	mv	a0,s7
    80002c80:	d49ff0ef          	jal	ra,800029c8 <bread>
    80002c84:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002c86:	40000613          	li	a2,1024
    80002c8a:	4581                	li	a1,0
    80002c8c:	05850513          	addi	a0,a0,88
    80002c90:	fddfd0ef          	jal	ra,80000c6c <memset>
  log_write(bp);
    80002c94:	854a                	mv	a0,s2
    80002c96:	665000ef          	jal	ra,80003afa <log_write>
  brelse(bp);
    80002c9a:	854a                	mv	a0,s2
    80002c9c:	e35ff0ef          	jal	ra,80002ad0 <brelse>
}
    80002ca0:	8526                	mv	a0,s1
    80002ca2:	60e6                	ld	ra,88(sp)
    80002ca4:	6446                	ld	s0,80(sp)
    80002ca6:	64a6                	ld	s1,72(sp)
    80002ca8:	6906                	ld	s2,64(sp)
    80002caa:	79e2                	ld	s3,56(sp)
    80002cac:	7a42                	ld	s4,48(sp)
    80002cae:	7aa2                	ld	s5,40(sp)
    80002cb0:	7b02                	ld	s6,32(sp)
    80002cb2:	6be2                	ld	s7,24(sp)
    80002cb4:	6c42                	ld	s8,16(sp)
    80002cb6:	6ca2                	ld	s9,8(sp)
    80002cb8:	6125                	addi	sp,sp,96
    80002cba:	8082                	ret
    brelse(bp);
    80002cbc:	854a                	mv	a0,s2
    80002cbe:	e13ff0ef          	jal	ra,80002ad0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002cc2:	015c87bb          	addw	a5,s9,s5
    80002cc6:	00078a9b          	sext.w	s5,a5
    80002cca:	004b2703          	lw	a4,4(s6)
    80002cce:	04eaff63          	bgeu	s5,a4,80002d2c <balloc+0xfe>
    bp = bread(dev, BBLOCK(b, sb));
    80002cd2:	41fad79b          	sraiw	a5,s5,0x1f
    80002cd6:	0137d79b          	srliw	a5,a5,0x13
    80002cda:	015787bb          	addw	a5,a5,s5
    80002cde:	40d7d79b          	sraiw	a5,a5,0xd
    80002ce2:	01cb2583          	lw	a1,28(s6)
    80002ce6:	9dbd                	addw	a1,a1,a5
    80002ce8:	855e                	mv	a0,s7
    80002cea:	cdfff0ef          	jal	ra,800029c8 <bread>
    80002cee:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002cf0:	004b2503          	lw	a0,4(s6)
    80002cf4:	000a849b          	sext.w	s1,s5
    80002cf8:	8762                	mv	a4,s8
    80002cfa:	fca4f1e3          	bgeu	s1,a0,80002cbc <balloc+0x8e>
      m = 1 << (bi % 8);
    80002cfe:	00777693          	andi	a3,a4,7
    80002d02:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002d06:	41f7579b          	sraiw	a5,a4,0x1f
    80002d0a:	01d7d79b          	srliw	a5,a5,0x1d
    80002d0e:	9fb9                	addw	a5,a5,a4
    80002d10:	4037d79b          	sraiw	a5,a5,0x3
    80002d14:	00f90633          	add	a2,s2,a5
    80002d18:	05864603          	lbu	a2,88(a2)
    80002d1c:	00c6f5b3          	and	a1,a3,a2
    80002d20:	d5a1                	beqz	a1,80002c68 <balloc+0x3a>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002d22:	2705                	addiw	a4,a4,1
    80002d24:	2485                	addiw	s1,s1,1
    80002d26:	fd471ae3          	bne	a4,s4,80002cfa <balloc+0xcc>
    80002d2a:	bf49                	j	80002cbc <balloc+0x8e>
  printf("balloc: out of blocks\n");
    80002d2c:	00005517          	auipc	a0,0x5
    80002d30:	86450513          	addi	a0,a0,-1948 # 80007590 <syscalls+0x100>
    80002d34:	f6efd0ef          	jal	ra,800004a2 <printf>
  return 0;
    80002d38:	4481                	li	s1,0
    80002d3a:	b79d                	j	80002ca0 <balloc+0x72>

0000000080002d3c <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80002d3c:	7179                	addi	sp,sp,-48
    80002d3e:	f406                	sd	ra,40(sp)
    80002d40:	f022                	sd	s0,32(sp)
    80002d42:	ec26                	sd	s1,24(sp)
    80002d44:	e84a                	sd	s2,16(sp)
    80002d46:	e44e                	sd	s3,8(sp)
    80002d48:	e052                	sd	s4,0(sp)
    80002d4a:	1800                	addi	s0,sp,48
    80002d4c:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002d4e:	47ad                	li	a5,11
    80002d50:	02b7e663          	bltu	a5,a1,80002d7c <bmap+0x40>
    if((addr = ip->addrs[bn]) == 0){
    80002d54:	02059793          	slli	a5,a1,0x20
    80002d58:	01e7d593          	srli	a1,a5,0x1e
    80002d5c:	00b504b3          	add	s1,a0,a1
    80002d60:	0504a903          	lw	s2,80(s1)
    80002d64:	06091663          	bnez	s2,80002dd0 <bmap+0x94>
      addr = balloc(ip->dev);
    80002d68:	4108                	lw	a0,0(a0)
    80002d6a:	ec5ff0ef          	jal	ra,80002c2e <balloc>
    80002d6e:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002d72:	04090f63          	beqz	s2,80002dd0 <bmap+0x94>
        return 0;
      ip->addrs[bn] = addr;
    80002d76:	0524a823          	sw	s2,80(s1)
    80002d7a:	a899                	j	80002dd0 <bmap+0x94>
    }
    return addr;
  }
  bn -= NDIRECT;
    80002d7c:	ff45849b          	addiw	s1,a1,-12
    80002d80:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002d84:	0ff00793          	li	a5,255
    80002d88:	06e7eb63          	bltu	a5,a4,80002dfe <bmap+0xc2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80002d8c:	08052903          	lw	s2,128(a0)
    80002d90:	00091b63          	bnez	s2,80002da6 <bmap+0x6a>
      addr = balloc(ip->dev);
    80002d94:	4108                	lw	a0,0(a0)
    80002d96:	e99ff0ef          	jal	ra,80002c2e <balloc>
    80002d9a:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002d9e:	02090963          	beqz	s2,80002dd0 <bmap+0x94>
        return 0;
      ip->addrs[NDIRECT] = addr;
    80002da2:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    80002da6:	85ca                	mv	a1,s2
    80002da8:	0009a503          	lw	a0,0(s3)
    80002dac:	c1dff0ef          	jal	ra,800029c8 <bread>
    80002db0:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002db2:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002db6:	02049713          	slli	a4,s1,0x20
    80002dba:	01e75593          	srli	a1,a4,0x1e
    80002dbe:	00b784b3          	add	s1,a5,a1
    80002dc2:	0004a903          	lw	s2,0(s1)
    80002dc6:	00090e63          	beqz	s2,80002de2 <bmap+0xa6>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80002dca:	8552                	mv	a0,s4
    80002dcc:	d05ff0ef          	jal	ra,80002ad0 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80002dd0:	854a                	mv	a0,s2
    80002dd2:	70a2                	ld	ra,40(sp)
    80002dd4:	7402                	ld	s0,32(sp)
    80002dd6:	64e2                	ld	s1,24(sp)
    80002dd8:	6942                	ld	s2,16(sp)
    80002dda:	69a2                	ld	s3,8(sp)
    80002ddc:	6a02                	ld	s4,0(sp)
    80002dde:	6145                	addi	sp,sp,48
    80002de0:	8082                	ret
      addr = balloc(ip->dev);
    80002de2:	0009a503          	lw	a0,0(s3)
    80002de6:	e49ff0ef          	jal	ra,80002c2e <balloc>
    80002dea:	0005091b          	sext.w	s2,a0
      if(addr){
    80002dee:	fc090ee3          	beqz	s2,80002dca <bmap+0x8e>
        a[bn] = addr;
    80002df2:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80002df6:	8552                	mv	a0,s4
    80002df8:	503000ef          	jal	ra,80003afa <log_write>
    80002dfc:	b7f9                	j	80002dca <bmap+0x8e>
  panic("bmap: out of range");
    80002dfe:	00004517          	auipc	a0,0x4
    80002e02:	7aa50513          	addi	a0,a0,1962 # 800075a8 <syscalls+0x118>
    80002e06:	951fd0ef          	jal	ra,80000756 <panic>

0000000080002e0a <iget>:
{
    80002e0a:	7179                	addi	sp,sp,-48
    80002e0c:	f406                	sd	ra,40(sp)
    80002e0e:	f022                	sd	s0,32(sp)
    80002e10:	ec26                	sd	s1,24(sp)
    80002e12:	e84a                	sd	s2,16(sp)
    80002e14:	e44e                	sd	s3,8(sp)
    80002e16:	e052                	sd	s4,0(sp)
    80002e18:	1800                	addi	s0,sp,48
    80002e1a:	89aa                	mv	s3,a0
    80002e1c:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002e1e:	0001b517          	auipc	a0,0x1b
    80002e22:	15a50513          	addi	a0,a0,346 # 8001df78 <itable>
    80002e26:	d73fd0ef          	jal	ra,80000b98 <acquire>
  empty = 0;
    80002e2a:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002e2c:	0001b497          	auipc	s1,0x1b
    80002e30:	16448493          	addi	s1,s1,356 # 8001df90 <itable+0x18>
    80002e34:	0001d697          	auipc	a3,0x1d
    80002e38:	bec68693          	addi	a3,a3,-1044 # 8001fa20 <log>
    80002e3c:	a039                	j	80002e4a <iget+0x40>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002e3e:	02090963          	beqz	s2,80002e70 <iget+0x66>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002e42:	08848493          	addi	s1,s1,136
    80002e46:	02d48863          	beq	s1,a3,80002e76 <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002e4a:	449c                	lw	a5,8(s1)
    80002e4c:	fef059e3          	blez	a5,80002e3e <iget+0x34>
    80002e50:	4098                	lw	a4,0(s1)
    80002e52:	ff3716e3          	bne	a4,s3,80002e3e <iget+0x34>
    80002e56:	40d8                	lw	a4,4(s1)
    80002e58:	ff4713e3          	bne	a4,s4,80002e3e <iget+0x34>
      ip->ref++;
    80002e5c:	2785                	addiw	a5,a5,1
    80002e5e:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002e60:	0001b517          	auipc	a0,0x1b
    80002e64:	11850513          	addi	a0,a0,280 # 8001df78 <itable>
    80002e68:	dc9fd0ef          	jal	ra,80000c30 <release>
      return ip;
    80002e6c:	8926                	mv	s2,s1
    80002e6e:	a02d                	j	80002e98 <iget+0x8e>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002e70:	fbe9                	bnez	a5,80002e42 <iget+0x38>
    80002e72:	8926                	mv	s2,s1
    80002e74:	b7f9                	j	80002e42 <iget+0x38>
  if(empty == 0)
    80002e76:	02090a63          	beqz	s2,80002eaa <iget+0xa0>
  ip->dev = dev;
    80002e7a:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002e7e:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002e82:	4785                	li	a5,1
    80002e84:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002e88:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002e8c:	0001b517          	auipc	a0,0x1b
    80002e90:	0ec50513          	addi	a0,a0,236 # 8001df78 <itable>
    80002e94:	d9dfd0ef          	jal	ra,80000c30 <release>
}
    80002e98:	854a                	mv	a0,s2
    80002e9a:	70a2                	ld	ra,40(sp)
    80002e9c:	7402                	ld	s0,32(sp)
    80002e9e:	64e2                	ld	s1,24(sp)
    80002ea0:	6942                	ld	s2,16(sp)
    80002ea2:	69a2                	ld	s3,8(sp)
    80002ea4:	6a02                	ld	s4,0(sp)
    80002ea6:	6145                	addi	sp,sp,48
    80002ea8:	8082                	ret
    panic("iget: no inodes");
    80002eaa:	00004517          	auipc	a0,0x4
    80002eae:	71650513          	addi	a0,a0,1814 # 800075c0 <syscalls+0x130>
    80002eb2:	8a5fd0ef          	jal	ra,80000756 <panic>

0000000080002eb6 <fsinit>:
fsinit(int dev) {
    80002eb6:	7179                	addi	sp,sp,-48
    80002eb8:	f406                	sd	ra,40(sp)
    80002eba:	f022                	sd	s0,32(sp)
    80002ebc:	ec26                	sd	s1,24(sp)
    80002ebe:	e84a                	sd	s2,16(sp)
    80002ec0:	e44e                	sd	s3,8(sp)
    80002ec2:	1800                	addi	s0,sp,48
    80002ec4:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002ec6:	4585                	li	a1,1
    80002ec8:	b01ff0ef          	jal	ra,800029c8 <bread>
    80002ecc:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002ece:	0001b997          	auipc	s3,0x1b
    80002ed2:	08a98993          	addi	s3,s3,138 # 8001df58 <sb>
    80002ed6:	02000613          	li	a2,32
    80002eda:	05850593          	addi	a1,a0,88
    80002ede:	854e                	mv	a0,s3
    80002ee0:	de9fd0ef          	jal	ra,80000cc8 <memmove>
  brelse(bp);
    80002ee4:	8526                	mv	a0,s1
    80002ee6:	bebff0ef          	jal	ra,80002ad0 <brelse>
  if(sb.magic != FSMAGIC)
    80002eea:	0009a703          	lw	a4,0(s3)
    80002eee:	102037b7          	lui	a5,0x10203
    80002ef2:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002ef6:	02f71063          	bne	a4,a5,80002f16 <fsinit+0x60>
  initlog(dev, &sb);
    80002efa:	0001b597          	auipc	a1,0x1b
    80002efe:	05e58593          	addi	a1,a1,94 # 8001df58 <sb>
    80002f02:	854a                	mv	a0,s2
    80002f04:	1e3000ef          	jal	ra,800038e6 <initlog>
}
    80002f08:	70a2                	ld	ra,40(sp)
    80002f0a:	7402                	ld	s0,32(sp)
    80002f0c:	64e2                	ld	s1,24(sp)
    80002f0e:	6942                	ld	s2,16(sp)
    80002f10:	69a2                	ld	s3,8(sp)
    80002f12:	6145                	addi	sp,sp,48
    80002f14:	8082                	ret
    panic("invalid file system");
    80002f16:	00004517          	auipc	a0,0x4
    80002f1a:	6ba50513          	addi	a0,a0,1722 # 800075d0 <syscalls+0x140>
    80002f1e:	839fd0ef          	jal	ra,80000756 <panic>

0000000080002f22 <iinit>:
{
    80002f22:	7179                	addi	sp,sp,-48
    80002f24:	f406                	sd	ra,40(sp)
    80002f26:	f022                	sd	s0,32(sp)
    80002f28:	ec26                	sd	s1,24(sp)
    80002f2a:	e84a                	sd	s2,16(sp)
    80002f2c:	e44e                	sd	s3,8(sp)
    80002f2e:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002f30:	00004597          	auipc	a1,0x4
    80002f34:	6b858593          	addi	a1,a1,1720 # 800075e8 <syscalls+0x158>
    80002f38:	0001b517          	auipc	a0,0x1b
    80002f3c:	04050513          	addi	a0,a0,64 # 8001df78 <itable>
    80002f40:	bd9fd0ef          	jal	ra,80000b18 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002f44:	0001b497          	auipc	s1,0x1b
    80002f48:	05c48493          	addi	s1,s1,92 # 8001dfa0 <itable+0x28>
    80002f4c:	0001d997          	auipc	s3,0x1d
    80002f50:	ae498993          	addi	s3,s3,-1308 # 8001fa30 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002f54:	00004917          	auipc	s2,0x4
    80002f58:	69c90913          	addi	s2,s2,1692 # 800075f0 <syscalls+0x160>
    80002f5c:	85ca                	mv	a1,s2
    80002f5e:	8526                	mv	a0,s1
    80002f60:	46b000ef          	jal	ra,80003bca <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002f64:	08848493          	addi	s1,s1,136
    80002f68:	ff349ae3          	bne	s1,s3,80002f5c <iinit+0x3a>
}
    80002f6c:	70a2                	ld	ra,40(sp)
    80002f6e:	7402                	ld	s0,32(sp)
    80002f70:	64e2                	ld	s1,24(sp)
    80002f72:	6942                	ld	s2,16(sp)
    80002f74:	69a2                	ld	s3,8(sp)
    80002f76:	6145                	addi	sp,sp,48
    80002f78:	8082                	ret

0000000080002f7a <ialloc>:
{
    80002f7a:	715d                	addi	sp,sp,-80
    80002f7c:	e486                	sd	ra,72(sp)
    80002f7e:	e0a2                	sd	s0,64(sp)
    80002f80:	fc26                	sd	s1,56(sp)
    80002f82:	f84a                	sd	s2,48(sp)
    80002f84:	f44e                	sd	s3,40(sp)
    80002f86:	f052                	sd	s4,32(sp)
    80002f88:	ec56                	sd	s5,24(sp)
    80002f8a:	e85a                	sd	s6,16(sp)
    80002f8c:	e45e                	sd	s7,8(sp)
    80002f8e:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002f90:	0001b717          	auipc	a4,0x1b
    80002f94:	fd472703          	lw	a4,-44(a4) # 8001df64 <sb+0xc>
    80002f98:	4785                	li	a5,1
    80002f9a:	04e7f663          	bgeu	a5,a4,80002fe6 <ialloc+0x6c>
    80002f9e:	8aaa                	mv	s5,a0
    80002fa0:	8bae                	mv	s7,a1
    80002fa2:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002fa4:	0001ba17          	auipc	s4,0x1b
    80002fa8:	fb4a0a13          	addi	s4,s4,-76 # 8001df58 <sb>
    80002fac:	00048b1b          	sext.w	s6,s1
    80002fb0:	0044d593          	srli	a1,s1,0x4
    80002fb4:	018a2783          	lw	a5,24(s4)
    80002fb8:	9dbd                	addw	a1,a1,a5
    80002fba:	8556                	mv	a0,s5
    80002fbc:	a0dff0ef          	jal	ra,800029c8 <bread>
    80002fc0:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002fc2:	05850993          	addi	s3,a0,88
    80002fc6:	00f4f793          	andi	a5,s1,15
    80002fca:	079a                	slli	a5,a5,0x6
    80002fcc:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002fce:	00099783          	lh	a5,0(s3)
    80002fd2:	cf85                	beqz	a5,8000300a <ialloc+0x90>
    brelse(bp);
    80002fd4:	afdff0ef          	jal	ra,80002ad0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002fd8:	0485                	addi	s1,s1,1
    80002fda:	00ca2703          	lw	a4,12(s4)
    80002fde:	0004879b          	sext.w	a5,s1
    80002fe2:	fce7e5e3          	bltu	a5,a4,80002fac <ialloc+0x32>
  printf("ialloc: no inodes\n");
    80002fe6:	00004517          	auipc	a0,0x4
    80002fea:	61250513          	addi	a0,a0,1554 # 800075f8 <syscalls+0x168>
    80002fee:	cb4fd0ef          	jal	ra,800004a2 <printf>
  return 0;
    80002ff2:	4501                	li	a0,0
}
    80002ff4:	60a6                	ld	ra,72(sp)
    80002ff6:	6406                	ld	s0,64(sp)
    80002ff8:	74e2                	ld	s1,56(sp)
    80002ffa:	7942                	ld	s2,48(sp)
    80002ffc:	79a2                	ld	s3,40(sp)
    80002ffe:	7a02                	ld	s4,32(sp)
    80003000:	6ae2                	ld	s5,24(sp)
    80003002:	6b42                	ld	s6,16(sp)
    80003004:	6ba2                	ld	s7,8(sp)
    80003006:	6161                	addi	sp,sp,80
    80003008:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    8000300a:	04000613          	li	a2,64
    8000300e:	4581                	li	a1,0
    80003010:	854e                	mv	a0,s3
    80003012:	c5bfd0ef          	jal	ra,80000c6c <memset>
      dip->type = type;
    80003016:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    8000301a:	854a                	mv	a0,s2
    8000301c:	2df000ef          	jal	ra,80003afa <log_write>
      brelse(bp);
    80003020:	854a                	mv	a0,s2
    80003022:	aafff0ef          	jal	ra,80002ad0 <brelse>
      return iget(dev, inum);
    80003026:	85da                	mv	a1,s6
    80003028:	8556                	mv	a0,s5
    8000302a:	de1ff0ef          	jal	ra,80002e0a <iget>
    8000302e:	b7d9                	j	80002ff4 <ialloc+0x7a>

0000000080003030 <iupdate>:
{
    80003030:	1101                	addi	sp,sp,-32
    80003032:	ec06                	sd	ra,24(sp)
    80003034:	e822                	sd	s0,16(sp)
    80003036:	e426                	sd	s1,8(sp)
    80003038:	e04a                	sd	s2,0(sp)
    8000303a:	1000                	addi	s0,sp,32
    8000303c:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    8000303e:	415c                	lw	a5,4(a0)
    80003040:	0047d79b          	srliw	a5,a5,0x4
    80003044:	0001b597          	auipc	a1,0x1b
    80003048:	f2c5a583          	lw	a1,-212(a1) # 8001df70 <sb+0x18>
    8000304c:	9dbd                	addw	a1,a1,a5
    8000304e:	4108                	lw	a0,0(a0)
    80003050:	979ff0ef          	jal	ra,800029c8 <bread>
    80003054:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003056:	05850793          	addi	a5,a0,88
    8000305a:	40d8                	lw	a4,4(s1)
    8000305c:	8b3d                	andi	a4,a4,15
    8000305e:	071a                	slli	a4,a4,0x6
    80003060:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80003062:	04449703          	lh	a4,68(s1)
    80003066:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    8000306a:	04649703          	lh	a4,70(s1)
    8000306e:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80003072:	04849703          	lh	a4,72(s1)
    80003076:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    8000307a:	04a49703          	lh	a4,74(s1)
    8000307e:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80003082:	44f8                	lw	a4,76(s1)
    80003084:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80003086:	03400613          	li	a2,52
    8000308a:	05048593          	addi	a1,s1,80
    8000308e:	00c78513          	addi	a0,a5,12
    80003092:	c37fd0ef          	jal	ra,80000cc8 <memmove>
  log_write(bp);
    80003096:	854a                	mv	a0,s2
    80003098:	263000ef          	jal	ra,80003afa <log_write>
  brelse(bp);
    8000309c:	854a                	mv	a0,s2
    8000309e:	a33ff0ef          	jal	ra,80002ad0 <brelse>
}
    800030a2:	60e2                	ld	ra,24(sp)
    800030a4:	6442                	ld	s0,16(sp)
    800030a6:	64a2                	ld	s1,8(sp)
    800030a8:	6902                	ld	s2,0(sp)
    800030aa:	6105                	addi	sp,sp,32
    800030ac:	8082                	ret

00000000800030ae <idup>:
{
    800030ae:	1101                	addi	sp,sp,-32
    800030b0:	ec06                	sd	ra,24(sp)
    800030b2:	e822                	sd	s0,16(sp)
    800030b4:	e426                	sd	s1,8(sp)
    800030b6:	1000                	addi	s0,sp,32
    800030b8:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800030ba:	0001b517          	auipc	a0,0x1b
    800030be:	ebe50513          	addi	a0,a0,-322 # 8001df78 <itable>
    800030c2:	ad7fd0ef          	jal	ra,80000b98 <acquire>
  ip->ref++;
    800030c6:	449c                	lw	a5,8(s1)
    800030c8:	2785                	addiw	a5,a5,1
    800030ca:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800030cc:	0001b517          	auipc	a0,0x1b
    800030d0:	eac50513          	addi	a0,a0,-340 # 8001df78 <itable>
    800030d4:	b5dfd0ef          	jal	ra,80000c30 <release>
}
    800030d8:	8526                	mv	a0,s1
    800030da:	60e2                	ld	ra,24(sp)
    800030dc:	6442                	ld	s0,16(sp)
    800030de:	64a2                	ld	s1,8(sp)
    800030e0:	6105                	addi	sp,sp,32
    800030e2:	8082                	ret

00000000800030e4 <ilock>:
{
    800030e4:	1101                	addi	sp,sp,-32
    800030e6:	ec06                	sd	ra,24(sp)
    800030e8:	e822                	sd	s0,16(sp)
    800030ea:	e426                	sd	s1,8(sp)
    800030ec:	e04a                	sd	s2,0(sp)
    800030ee:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    800030f0:	c105                	beqz	a0,80003110 <ilock+0x2c>
    800030f2:	84aa                	mv	s1,a0
    800030f4:	451c                	lw	a5,8(a0)
    800030f6:	00f05d63          	blez	a5,80003110 <ilock+0x2c>
  acquiresleep(&ip->lock);
    800030fa:	0541                	addi	a0,a0,16
    800030fc:	305000ef          	jal	ra,80003c00 <acquiresleep>
  if(ip->valid == 0){
    80003100:	40bc                	lw	a5,64(s1)
    80003102:	cf89                	beqz	a5,8000311c <ilock+0x38>
}
    80003104:	60e2                	ld	ra,24(sp)
    80003106:	6442                	ld	s0,16(sp)
    80003108:	64a2                	ld	s1,8(sp)
    8000310a:	6902                	ld	s2,0(sp)
    8000310c:	6105                	addi	sp,sp,32
    8000310e:	8082                	ret
    panic("ilock");
    80003110:	00004517          	auipc	a0,0x4
    80003114:	50050513          	addi	a0,a0,1280 # 80007610 <syscalls+0x180>
    80003118:	e3efd0ef          	jal	ra,80000756 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    8000311c:	40dc                	lw	a5,4(s1)
    8000311e:	0047d79b          	srliw	a5,a5,0x4
    80003122:	0001b597          	auipc	a1,0x1b
    80003126:	e4e5a583          	lw	a1,-434(a1) # 8001df70 <sb+0x18>
    8000312a:	9dbd                	addw	a1,a1,a5
    8000312c:	4088                	lw	a0,0(s1)
    8000312e:	89bff0ef          	jal	ra,800029c8 <bread>
    80003132:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003134:	05850593          	addi	a1,a0,88
    80003138:	40dc                	lw	a5,4(s1)
    8000313a:	8bbd                	andi	a5,a5,15
    8000313c:	079a                	slli	a5,a5,0x6
    8000313e:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003140:	00059783          	lh	a5,0(a1)
    80003144:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80003148:	00259783          	lh	a5,2(a1)
    8000314c:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003150:	00459783          	lh	a5,4(a1)
    80003154:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80003158:	00659783          	lh	a5,6(a1)
    8000315c:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003160:	459c                	lw	a5,8(a1)
    80003162:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80003164:	03400613          	li	a2,52
    80003168:	05b1                	addi	a1,a1,12
    8000316a:	05048513          	addi	a0,s1,80
    8000316e:	b5bfd0ef          	jal	ra,80000cc8 <memmove>
    brelse(bp);
    80003172:	854a                	mv	a0,s2
    80003174:	95dff0ef          	jal	ra,80002ad0 <brelse>
    ip->valid = 1;
    80003178:	4785                	li	a5,1
    8000317a:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    8000317c:	04449783          	lh	a5,68(s1)
    80003180:	f3d1                	bnez	a5,80003104 <ilock+0x20>
      panic("ilock: no type");
    80003182:	00004517          	auipc	a0,0x4
    80003186:	49650513          	addi	a0,a0,1174 # 80007618 <syscalls+0x188>
    8000318a:	dccfd0ef          	jal	ra,80000756 <panic>

000000008000318e <iunlock>:
{
    8000318e:	1101                	addi	sp,sp,-32
    80003190:	ec06                	sd	ra,24(sp)
    80003192:	e822                	sd	s0,16(sp)
    80003194:	e426                	sd	s1,8(sp)
    80003196:	e04a                	sd	s2,0(sp)
    80003198:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    8000319a:	c505                	beqz	a0,800031c2 <iunlock+0x34>
    8000319c:	84aa                	mv	s1,a0
    8000319e:	01050913          	addi	s2,a0,16
    800031a2:	854a                	mv	a0,s2
    800031a4:	2db000ef          	jal	ra,80003c7e <holdingsleep>
    800031a8:	cd09                	beqz	a0,800031c2 <iunlock+0x34>
    800031aa:	449c                	lw	a5,8(s1)
    800031ac:	00f05b63          	blez	a5,800031c2 <iunlock+0x34>
  releasesleep(&ip->lock);
    800031b0:	854a                	mv	a0,s2
    800031b2:	295000ef          	jal	ra,80003c46 <releasesleep>
}
    800031b6:	60e2                	ld	ra,24(sp)
    800031b8:	6442                	ld	s0,16(sp)
    800031ba:	64a2                	ld	s1,8(sp)
    800031bc:	6902                	ld	s2,0(sp)
    800031be:	6105                	addi	sp,sp,32
    800031c0:	8082                	ret
    panic("iunlock");
    800031c2:	00004517          	auipc	a0,0x4
    800031c6:	46650513          	addi	a0,a0,1126 # 80007628 <syscalls+0x198>
    800031ca:	d8cfd0ef          	jal	ra,80000756 <panic>

00000000800031ce <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    800031ce:	7179                	addi	sp,sp,-48
    800031d0:	f406                	sd	ra,40(sp)
    800031d2:	f022                	sd	s0,32(sp)
    800031d4:	ec26                	sd	s1,24(sp)
    800031d6:	e84a                	sd	s2,16(sp)
    800031d8:	e44e                	sd	s3,8(sp)
    800031da:	e052                	sd	s4,0(sp)
    800031dc:	1800                	addi	s0,sp,48
    800031de:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    800031e0:	05050493          	addi	s1,a0,80
    800031e4:	08050913          	addi	s2,a0,128
    800031e8:	a021                	j	800031f0 <itrunc+0x22>
    800031ea:	0491                	addi	s1,s1,4
    800031ec:	01248b63          	beq	s1,s2,80003202 <itrunc+0x34>
    if(ip->addrs[i]){
    800031f0:	408c                	lw	a1,0(s1)
    800031f2:	dde5                	beqz	a1,800031ea <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    800031f4:	0009a503          	lw	a0,0(s3)
    800031f8:	9cbff0ef          	jal	ra,80002bc2 <bfree>
      ip->addrs[i] = 0;
    800031fc:	0004a023          	sw	zero,0(s1)
    80003200:	b7ed                	j	800031ea <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003202:	0809a583          	lw	a1,128(s3)
    80003206:	ed91                	bnez	a1,80003222 <itrunc+0x54>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80003208:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    8000320c:	854e                	mv	a0,s3
    8000320e:	e23ff0ef          	jal	ra,80003030 <iupdate>
}
    80003212:	70a2                	ld	ra,40(sp)
    80003214:	7402                	ld	s0,32(sp)
    80003216:	64e2                	ld	s1,24(sp)
    80003218:	6942                	ld	s2,16(sp)
    8000321a:	69a2                	ld	s3,8(sp)
    8000321c:	6a02                	ld	s4,0(sp)
    8000321e:	6145                	addi	sp,sp,48
    80003220:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003222:	0009a503          	lw	a0,0(s3)
    80003226:	fa2ff0ef          	jal	ra,800029c8 <bread>
    8000322a:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    8000322c:	05850493          	addi	s1,a0,88
    80003230:	45850913          	addi	s2,a0,1112
    80003234:	a021                	j	8000323c <itrunc+0x6e>
    80003236:	0491                	addi	s1,s1,4
    80003238:	01248963          	beq	s1,s2,8000324a <itrunc+0x7c>
      if(a[j])
    8000323c:	408c                	lw	a1,0(s1)
    8000323e:	dde5                	beqz	a1,80003236 <itrunc+0x68>
        bfree(ip->dev, a[j]);
    80003240:	0009a503          	lw	a0,0(s3)
    80003244:	97fff0ef          	jal	ra,80002bc2 <bfree>
    80003248:	b7fd                	j	80003236 <itrunc+0x68>
    brelse(bp);
    8000324a:	8552                	mv	a0,s4
    8000324c:	885ff0ef          	jal	ra,80002ad0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003250:	0809a583          	lw	a1,128(s3)
    80003254:	0009a503          	lw	a0,0(s3)
    80003258:	96bff0ef          	jal	ra,80002bc2 <bfree>
    ip->addrs[NDIRECT] = 0;
    8000325c:	0809a023          	sw	zero,128(s3)
    80003260:	b765                	j	80003208 <itrunc+0x3a>

0000000080003262 <iput>:
{
    80003262:	1101                	addi	sp,sp,-32
    80003264:	ec06                	sd	ra,24(sp)
    80003266:	e822                	sd	s0,16(sp)
    80003268:	e426                	sd	s1,8(sp)
    8000326a:	e04a                	sd	s2,0(sp)
    8000326c:	1000                	addi	s0,sp,32
    8000326e:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003270:	0001b517          	auipc	a0,0x1b
    80003274:	d0850513          	addi	a0,a0,-760 # 8001df78 <itable>
    80003278:	921fd0ef          	jal	ra,80000b98 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    8000327c:	4498                	lw	a4,8(s1)
    8000327e:	4785                	li	a5,1
    80003280:	02f70163          	beq	a4,a5,800032a2 <iput+0x40>
  ip->ref--;
    80003284:	449c                	lw	a5,8(s1)
    80003286:	37fd                	addiw	a5,a5,-1
    80003288:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    8000328a:	0001b517          	auipc	a0,0x1b
    8000328e:	cee50513          	addi	a0,a0,-786 # 8001df78 <itable>
    80003292:	99ffd0ef          	jal	ra,80000c30 <release>
}
    80003296:	60e2                	ld	ra,24(sp)
    80003298:	6442                	ld	s0,16(sp)
    8000329a:	64a2                	ld	s1,8(sp)
    8000329c:	6902                	ld	s2,0(sp)
    8000329e:	6105                	addi	sp,sp,32
    800032a0:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800032a2:	40bc                	lw	a5,64(s1)
    800032a4:	d3e5                	beqz	a5,80003284 <iput+0x22>
    800032a6:	04a49783          	lh	a5,74(s1)
    800032aa:	ffe9                	bnez	a5,80003284 <iput+0x22>
    acquiresleep(&ip->lock);
    800032ac:	01048913          	addi	s2,s1,16
    800032b0:	854a                	mv	a0,s2
    800032b2:	14f000ef          	jal	ra,80003c00 <acquiresleep>
    release(&itable.lock);
    800032b6:	0001b517          	auipc	a0,0x1b
    800032ba:	cc250513          	addi	a0,a0,-830 # 8001df78 <itable>
    800032be:	973fd0ef          	jal	ra,80000c30 <release>
    itrunc(ip);
    800032c2:	8526                	mv	a0,s1
    800032c4:	f0bff0ef          	jal	ra,800031ce <itrunc>
    ip->type = 0;
    800032c8:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    800032cc:	8526                	mv	a0,s1
    800032ce:	d63ff0ef          	jal	ra,80003030 <iupdate>
    ip->valid = 0;
    800032d2:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    800032d6:	854a                	mv	a0,s2
    800032d8:	16f000ef          	jal	ra,80003c46 <releasesleep>
    acquire(&itable.lock);
    800032dc:	0001b517          	auipc	a0,0x1b
    800032e0:	c9c50513          	addi	a0,a0,-868 # 8001df78 <itable>
    800032e4:	8b5fd0ef          	jal	ra,80000b98 <acquire>
    800032e8:	bf71                	j	80003284 <iput+0x22>

00000000800032ea <iunlockput>:
{
    800032ea:	1101                	addi	sp,sp,-32
    800032ec:	ec06                	sd	ra,24(sp)
    800032ee:	e822                	sd	s0,16(sp)
    800032f0:	e426                	sd	s1,8(sp)
    800032f2:	1000                	addi	s0,sp,32
    800032f4:	84aa                	mv	s1,a0
  iunlock(ip);
    800032f6:	e99ff0ef          	jal	ra,8000318e <iunlock>
  iput(ip);
    800032fa:	8526                	mv	a0,s1
    800032fc:	f67ff0ef          	jal	ra,80003262 <iput>
}
    80003300:	60e2                	ld	ra,24(sp)
    80003302:	6442                	ld	s0,16(sp)
    80003304:	64a2                	ld	s1,8(sp)
    80003306:	6105                	addi	sp,sp,32
    80003308:	8082                	ret

000000008000330a <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    8000330a:	1141                	addi	sp,sp,-16
    8000330c:	e422                	sd	s0,8(sp)
    8000330e:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003310:	411c                	lw	a5,0(a0)
    80003312:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003314:	415c                	lw	a5,4(a0)
    80003316:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003318:	04451783          	lh	a5,68(a0)
    8000331c:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003320:	04a51783          	lh	a5,74(a0)
    80003324:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003328:	04c56783          	lwu	a5,76(a0)
    8000332c:	e99c                	sd	a5,16(a1)
}
    8000332e:	6422                	ld	s0,8(sp)
    80003330:	0141                	addi	sp,sp,16
    80003332:	8082                	ret

0000000080003334 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003334:	457c                	lw	a5,76(a0)
    80003336:	0cd7ef63          	bltu	a5,a3,80003414 <readi+0xe0>
{
    8000333a:	7159                	addi	sp,sp,-112
    8000333c:	f486                	sd	ra,104(sp)
    8000333e:	f0a2                	sd	s0,96(sp)
    80003340:	eca6                	sd	s1,88(sp)
    80003342:	e8ca                	sd	s2,80(sp)
    80003344:	e4ce                	sd	s3,72(sp)
    80003346:	e0d2                	sd	s4,64(sp)
    80003348:	fc56                	sd	s5,56(sp)
    8000334a:	f85a                	sd	s6,48(sp)
    8000334c:	f45e                	sd	s7,40(sp)
    8000334e:	f062                	sd	s8,32(sp)
    80003350:	ec66                	sd	s9,24(sp)
    80003352:	e86a                	sd	s10,16(sp)
    80003354:	e46e                	sd	s11,8(sp)
    80003356:	1880                	addi	s0,sp,112
    80003358:	8b2a                	mv	s6,a0
    8000335a:	8bae                	mv	s7,a1
    8000335c:	8a32                	mv	s4,a2
    8000335e:	84b6                	mv	s1,a3
    80003360:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80003362:	9f35                	addw	a4,a4,a3
    return 0;
    80003364:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003366:	08d76663          	bltu	a4,a3,800033f2 <readi+0xbe>
  if(off + n > ip->size)
    8000336a:	00e7f463          	bgeu	a5,a4,80003372 <readi+0x3e>
    n = ip->size - off;
    8000336e:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003372:	080a8f63          	beqz	s5,80003410 <readi+0xdc>
    80003376:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003378:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    8000337c:	5c7d                	li	s8,-1
    8000337e:	a80d                	j	800033b0 <readi+0x7c>
    80003380:	020d1d93          	slli	s11,s10,0x20
    80003384:	020ddd93          	srli	s11,s11,0x20
    80003388:	05890613          	addi	a2,s2,88
    8000338c:	86ee                	mv	a3,s11
    8000338e:	963a                	add	a2,a2,a4
    80003390:	85d2                	mv	a1,s4
    80003392:	855e                	mv	a0,s7
    80003394:	dbffe0ef          	jal	ra,80002152 <either_copyout>
    80003398:	05850763          	beq	a0,s8,800033e6 <readi+0xb2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    8000339c:	854a                	mv	a0,s2
    8000339e:	f32ff0ef          	jal	ra,80002ad0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800033a2:	013d09bb          	addw	s3,s10,s3
    800033a6:	009d04bb          	addw	s1,s10,s1
    800033aa:	9a6e                	add	s4,s4,s11
    800033ac:	0559f163          	bgeu	s3,s5,800033ee <readi+0xba>
    uint addr = bmap(ip, off/BSIZE);
    800033b0:	00a4d59b          	srliw	a1,s1,0xa
    800033b4:	855a                	mv	a0,s6
    800033b6:	987ff0ef          	jal	ra,80002d3c <bmap>
    800033ba:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    800033be:	c985                	beqz	a1,800033ee <readi+0xba>
    bp = bread(ip->dev, addr);
    800033c0:	000b2503          	lw	a0,0(s6)
    800033c4:	e04ff0ef          	jal	ra,800029c8 <bread>
    800033c8:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800033ca:	3ff4f713          	andi	a4,s1,1023
    800033ce:	40ec87bb          	subw	a5,s9,a4
    800033d2:	413a86bb          	subw	a3,s5,s3
    800033d6:	8d3e                	mv	s10,a5
    800033d8:	2781                	sext.w	a5,a5
    800033da:	0006861b          	sext.w	a2,a3
    800033de:	faf671e3          	bgeu	a2,a5,80003380 <readi+0x4c>
    800033e2:	8d36                	mv	s10,a3
    800033e4:	bf71                	j	80003380 <readi+0x4c>
      brelse(bp);
    800033e6:	854a                	mv	a0,s2
    800033e8:	ee8ff0ef          	jal	ra,80002ad0 <brelse>
      tot = -1;
    800033ec:	59fd                	li	s3,-1
  }
  return tot;
    800033ee:	0009851b          	sext.w	a0,s3
}
    800033f2:	70a6                	ld	ra,104(sp)
    800033f4:	7406                	ld	s0,96(sp)
    800033f6:	64e6                	ld	s1,88(sp)
    800033f8:	6946                	ld	s2,80(sp)
    800033fa:	69a6                	ld	s3,72(sp)
    800033fc:	6a06                	ld	s4,64(sp)
    800033fe:	7ae2                	ld	s5,56(sp)
    80003400:	7b42                	ld	s6,48(sp)
    80003402:	7ba2                	ld	s7,40(sp)
    80003404:	7c02                	ld	s8,32(sp)
    80003406:	6ce2                	ld	s9,24(sp)
    80003408:	6d42                	ld	s10,16(sp)
    8000340a:	6da2                	ld	s11,8(sp)
    8000340c:	6165                	addi	sp,sp,112
    8000340e:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003410:	89d6                	mv	s3,s5
    80003412:	bff1                	j	800033ee <readi+0xba>
    return 0;
    80003414:	4501                	li	a0,0
}
    80003416:	8082                	ret

0000000080003418 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003418:	457c                	lw	a5,76(a0)
    8000341a:	0ed7ea63          	bltu	a5,a3,8000350e <writei+0xf6>
{
    8000341e:	7159                	addi	sp,sp,-112
    80003420:	f486                	sd	ra,104(sp)
    80003422:	f0a2                	sd	s0,96(sp)
    80003424:	eca6                	sd	s1,88(sp)
    80003426:	e8ca                	sd	s2,80(sp)
    80003428:	e4ce                	sd	s3,72(sp)
    8000342a:	e0d2                	sd	s4,64(sp)
    8000342c:	fc56                	sd	s5,56(sp)
    8000342e:	f85a                	sd	s6,48(sp)
    80003430:	f45e                	sd	s7,40(sp)
    80003432:	f062                	sd	s8,32(sp)
    80003434:	ec66                	sd	s9,24(sp)
    80003436:	e86a                	sd	s10,16(sp)
    80003438:	e46e                	sd	s11,8(sp)
    8000343a:	1880                	addi	s0,sp,112
    8000343c:	8aaa                	mv	s5,a0
    8000343e:	8bae                	mv	s7,a1
    80003440:	8a32                	mv	s4,a2
    80003442:	8936                	mv	s2,a3
    80003444:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003446:	00e687bb          	addw	a5,a3,a4
    8000344a:	0cd7e463          	bltu	a5,a3,80003512 <writei+0xfa>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    8000344e:	00043737          	lui	a4,0x43
    80003452:	0cf76263          	bltu	a4,a5,80003516 <writei+0xfe>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003456:	0a0b0a63          	beqz	s6,8000350a <writei+0xf2>
    8000345a:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    8000345c:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003460:	5c7d                	li	s8,-1
    80003462:	a825                	j	8000349a <writei+0x82>
    80003464:	020d1d93          	slli	s11,s10,0x20
    80003468:	020ddd93          	srli	s11,s11,0x20
    8000346c:	05848513          	addi	a0,s1,88
    80003470:	86ee                	mv	a3,s11
    80003472:	8652                	mv	a2,s4
    80003474:	85de                	mv	a1,s7
    80003476:	953a                	add	a0,a0,a4
    80003478:	d25fe0ef          	jal	ra,8000219c <either_copyin>
    8000347c:	05850a63          	beq	a0,s8,800034d0 <writei+0xb8>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003480:	8526                	mv	a0,s1
    80003482:	678000ef          	jal	ra,80003afa <log_write>
    brelse(bp);
    80003486:	8526                	mv	a0,s1
    80003488:	e48ff0ef          	jal	ra,80002ad0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000348c:	013d09bb          	addw	s3,s10,s3
    80003490:	012d093b          	addw	s2,s10,s2
    80003494:	9a6e                	add	s4,s4,s11
    80003496:	0569f063          	bgeu	s3,s6,800034d6 <writei+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    8000349a:	00a9559b          	srliw	a1,s2,0xa
    8000349e:	8556                	mv	a0,s5
    800034a0:	89dff0ef          	jal	ra,80002d3c <bmap>
    800034a4:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    800034a8:	c59d                	beqz	a1,800034d6 <writei+0xbe>
    bp = bread(ip->dev, addr);
    800034aa:	000aa503          	lw	a0,0(s5)
    800034ae:	d1aff0ef          	jal	ra,800029c8 <bread>
    800034b2:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800034b4:	3ff97713          	andi	a4,s2,1023
    800034b8:	40ec87bb          	subw	a5,s9,a4
    800034bc:	413b06bb          	subw	a3,s6,s3
    800034c0:	8d3e                	mv	s10,a5
    800034c2:	2781                	sext.w	a5,a5
    800034c4:	0006861b          	sext.w	a2,a3
    800034c8:	f8f67ee3          	bgeu	a2,a5,80003464 <writei+0x4c>
    800034cc:	8d36                	mv	s10,a3
    800034ce:	bf59                	j	80003464 <writei+0x4c>
      brelse(bp);
    800034d0:	8526                	mv	a0,s1
    800034d2:	dfeff0ef          	jal	ra,80002ad0 <brelse>
  }

  if(off > ip->size)
    800034d6:	04caa783          	lw	a5,76(s5)
    800034da:	0127f463          	bgeu	a5,s2,800034e2 <writei+0xca>
    ip->size = off;
    800034de:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800034e2:	8556                	mv	a0,s5
    800034e4:	b4dff0ef          	jal	ra,80003030 <iupdate>

  return tot;
    800034e8:	0009851b          	sext.w	a0,s3
}
    800034ec:	70a6                	ld	ra,104(sp)
    800034ee:	7406                	ld	s0,96(sp)
    800034f0:	64e6                	ld	s1,88(sp)
    800034f2:	6946                	ld	s2,80(sp)
    800034f4:	69a6                	ld	s3,72(sp)
    800034f6:	6a06                	ld	s4,64(sp)
    800034f8:	7ae2                	ld	s5,56(sp)
    800034fa:	7b42                	ld	s6,48(sp)
    800034fc:	7ba2                	ld	s7,40(sp)
    800034fe:	7c02                	ld	s8,32(sp)
    80003500:	6ce2                	ld	s9,24(sp)
    80003502:	6d42                	ld	s10,16(sp)
    80003504:	6da2                	ld	s11,8(sp)
    80003506:	6165                	addi	sp,sp,112
    80003508:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000350a:	89da                	mv	s3,s6
    8000350c:	bfd9                	j	800034e2 <writei+0xca>
    return -1;
    8000350e:	557d                	li	a0,-1
}
    80003510:	8082                	ret
    return -1;
    80003512:	557d                	li	a0,-1
    80003514:	bfe1                	j	800034ec <writei+0xd4>
    return -1;
    80003516:	557d                	li	a0,-1
    80003518:	bfd1                	j	800034ec <writei+0xd4>

000000008000351a <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    8000351a:	1141                	addi	sp,sp,-16
    8000351c:	e406                	sd	ra,8(sp)
    8000351e:	e022                	sd	s0,0(sp)
    80003520:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003522:	4639                	li	a2,14
    80003524:	815fd0ef          	jal	ra,80000d38 <strncmp>
}
    80003528:	60a2                	ld	ra,8(sp)
    8000352a:	6402                	ld	s0,0(sp)
    8000352c:	0141                	addi	sp,sp,16
    8000352e:	8082                	ret

0000000080003530 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003530:	7139                	addi	sp,sp,-64
    80003532:	fc06                	sd	ra,56(sp)
    80003534:	f822                	sd	s0,48(sp)
    80003536:	f426                	sd	s1,40(sp)
    80003538:	f04a                	sd	s2,32(sp)
    8000353a:	ec4e                	sd	s3,24(sp)
    8000353c:	e852                	sd	s4,16(sp)
    8000353e:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003540:	04451703          	lh	a4,68(a0)
    80003544:	4785                	li	a5,1
    80003546:	00f71a63          	bne	a4,a5,8000355a <dirlookup+0x2a>
    8000354a:	892a                	mv	s2,a0
    8000354c:	89ae                	mv	s3,a1
    8000354e:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003550:	457c                	lw	a5,76(a0)
    80003552:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003554:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003556:	e39d                	bnez	a5,8000357c <dirlookup+0x4c>
    80003558:	a095                	j	800035bc <dirlookup+0x8c>
    panic("dirlookup not DIR");
    8000355a:	00004517          	auipc	a0,0x4
    8000355e:	0d650513          	addi	a0,a0,214 # 80007630 <syscalls+0x1a0>
    80003562:	9f4fd0ef          	jal	ra,80000756 <panic>
      panic("dirlookup read");
    80003566:	00004517          	auipc	a0,0x4
    8000356a:	0e250513          	addi	a0,a0,226 # 80007648 <syscalls+0x1b8>
    8000356e:	9e8fd0ef          	jal	ra,80000756 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003572:	24c1                	addiw	s1,s1,16
    80003574:	04c92783          	lw	a5,76(s2)
    80003578:	04f4f163          	bgeu	s1,a5,800035ba <dirlookup+0x8a>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000357c:	4741                	li	a4,16
    8000357e:	86a6                	mv	a3,s1
    80003580:	fc040613          	addi	a2,s0,-64
    80003584:	4581                	li	a1,0
    80003586:	854a                	mv	a0,s2
    80003588:	dadff0ef          	jal	ra,80003334 <readi>
    8000358c:	47c1                	li	a5,16
    8000358e:	fcf51ce3          	bne	a0,a5,80003566 <dirlookup+0x36>
    if(de.inum == 0)
    80003592:	fc045783          	lhu	a5,-64(s0)
    80003596:	dff1                	beqz	a5,80003572 <dirlookup+0x42>
    if(namecmp(name, de.name) == 0){
    80003598:	fc240593          	addi	a1,s0,-62
    8000359c:	854e                	mv	a0,s3
    8000359e:	f7dff0ef          	jal	ra,8000351a <namecmp>
    800035a2:	f961                	bnez	a0,80003572 <dirlookup+0x42>
      if(poff)
    800035a4:	000a0463          	beqz	s4,800035ac <dirlookup+0x7c>
        *poff = off;
    800035a8:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    800035ac:	fc045583          	lhu	a1,-64(s0)
    800035b0:	00092503          	lw	a0,0(s2)
    800035b4:	857ff0ef          	jal	ra,80002e0a <iget>
    800035b8:	a011                	j	800035bc <dirlookup+0x8c>
  return 0;
    800035ba:	4501                	li	a0,0
}
    800035bc:	70e2                	ld	ra,56(sp)
    800035be:	7442                	ld	s0,48(sp)
    800035c0:	74a2                	ld	s1,40(sp)
    800035c2:	7902                	ld	s2,32(sp)
    800035c4:	69e2                	ld	s3,24(sp)
    800035c6:	6a42                	ld	s4,16(sp)
    800035c8:	6121                	addi	sp,sp,64
    800035ca:	8082                	ret

00000000800035cc <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800035cc:	711d                	addi	sp,sp,-96
    800035ce:	ec86                	sd	ra,88(sp)
    800035d0:	e8a2                	sd	s0,80(sp)
    800035d2:	e4a6                	sd	s1,72(sp)
    800035d4:	e0ca                	sd	s2,64(sp)
    800035d6:	fc4e                	sd	s3,56(sp)
    800035d8:	f852                	sd	s4,48(sp)
    800035da:	f456                	sd	s5,40(sp)
    800035dc:	f05a                	sd	s6,32(sp)
    800035de:	ec5e                	sd	s7,24(sp)
    800035e0:	e862                	sd	s8,16(sp)
    800035e2:	e466                	sd	s9,8(sp)
    800035e4:	e06a                	sd	s10,0(sp)
    800035e6:	1080                	addi	s0,sp,96
    800035e8:	84aa                	mv	s1,a0
    800035ea:	8b2e                	mv	s6,a1
    800035ec:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    800035ee:	00054703          	lbu	a4,0(a0)
    800035f2:	02f00793          	li	a5,47
    800035f6:	00f70f63          	beq	a4,a5,80003614 <namex+0x48>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800035fa:	a30fe0ef          	jal	ra,8000182a <myproc>
    800035fe:	15053503          	ld	a0,336(a0)
    80003602:	aadff0ef          	jal	ra,800030ae <idup>
    80003606:	8a2a                	mv	s4,a0
  while(*path == '/')
    80003608:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    8000360c:	4cb5                	li	s9,13
  len = path - s;
    8000360e:	4b81                	li	s7,0

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003610:	4c05                	li	s8,1
    80003612:	a879                	j	800036b0 <namex+0xe4>
    ip = iget(ROOTDEV, ROOTINO);
    80003614:	4585                	li	a1,1
    80003616:	4505                	li	a0,1
    80003618:	ff2ff0ef          	jal	ra,80002e0a <iget>
    8000361c:	8a2a                	mv	s4,a0
    8000361e:	b7ed                	j	80003608 <namex+0x3c>
      iunlockput(ip);
    80003620:	8552                	mv	a0,s4
    80003622:	cc9ff0ef          	jal	ra,800032ea <iunlockput>
      return 0;
    80003626:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003628:	8552                	mv	a0,s4
    8000362a:	60e6                	ld	ra,88(sp)
    8000362c:	6446                	ld	s0,80(sp)
    8000362e:	64a6                	ld	s1,72(sp)
    80003630:	6906                	ld	s2,64(sp)
    80003632:	79e2                	ld	s3,56(sp)
    80003634:	7a42                	ld	s4,48(sp)
    80003636:	7aa2                	ld	s5,40(sp)
    80003638:	7b02                	ld	s6,32(sp)
    8000363a:	6be2                	ld	s7,24(sp)
    8000363c:	6c42                	ld	s8,16(sp)
    8000363e:	6ca2                	ld	s9,8(sp)
    80003640:	6d02                	ld	s10,0(sp)
    80003642:	6125                	addi	sp,sp,96
    80003644:	8082                	ret
      iunlock(ip);
    80003646:	8552                	mv	a0,s4
    80003648:	b47ff0ef          	jal	ra,8000318e <iunlock>
      return ip;
    8000364c:	bff1                	j	80003628 <namex+0x5c>
      iunlockput(ip);
    8000364e:	8552                	mv	a0,s4
    80003650:	c9bff0ef          	jal	ra,800032ea <iunlockput>
      return 0;
    80003654:	8a4e                	mv	s4,s3
    80003656:	bfc9                	j	80003628 <namex+0x5c>
  len = path - s;
    80003658:	40998633          	sub	a2,s3,s1
    8000365c:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    80003660:	09acd063          	bge	s9,s10,800036e0 <namex+0x114>
    memmove(name, s, DIRSIZ);
    80003664:	4639                	li	a2,14
    80003666:	85a6                	mv	a1,s1
    80003668:	8556                	mv	a0,s5
    8000366a:	e5efd0ef          	jal	ra,80000cc8 <memmove>
    8000366e:	84ce                	mv	s1,s3
  while(*path == '/')
    80003670:	0004c783          	lbu	a5,0(s1)
    80003674:	01279763          	bne	a5,s2,80003682 <namex+0xb6>
    path++;
    80003678:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000367a:	0004c783          	lbu	a5,0(s1)
    8000367e:	ff278de3          	beq	a5,s2,80003678 <namex+0xac>
    ilock(ip);
    80003682:	8552                	mv	a0,s4
    80003684:	a61ff0ef          	jal	ra,800030e4 <ilock>
    if(ip->type != T_DIR){
    80003688:	044a1783          	lh	a5,68(s4)
    8000368c:	f9879ae3          	bne	a5,s8,80003620 <namex+0x54>
    if(nameiparent && *path == '\0'){
    80003690:	000b0563          	beqz	s6,8000369a <namex+0xce>
    80003694:	0004c783          	lbu	a5,0(s1)
    80003698:	d7dd                	beqz	a5,80003646 <namex+0x7a>
    if((next = dirlookup(ip, name, 0)) == 0){
    8000369a:	865e                	mv	a2,s7
    8000369c:	85d6                	mv	a1,s5
    8000369e:	8552                	mv	a0,s4
    800036a0:	e91ff0ef          	jal	ra,80003530 <dirlookup>
    800036a4:	89aa                	mv	s3,a0
    800036a6:	d545                	beqz	a0,8000364e <namex+0x82>
    iunlockput(ip);
    800036a8:	8552                	mv	a0,s4
    800036aa:	c41ff0ef          	jal	ra,800032ea <iunlockput>
    ip = next;
    800036ae:	8a4e                	mv	s4,s3
  while(*path == '/')
    800036b0:	0004c783          	lbu	a5,0(s1)
    800036b4:	01279763          	bne	a5,s2,800036c2 <namex+0xf6>
    path++;
    800036b8:	0485                	addi	s1,s1,1
  while(*path == '/')
    800036ba:	0004c783          	lbu	a5,0(s1)
    800036be:	ff278de3          	beq	a5,s2,800036b8 <namex+0xec>
  if(*path == 0)
    800036c2:	cb8d                	beqz	a5,800036f4 <namex+0x128>
  while(*path != '/' && *path != 0)
    800036c4:	0004c783          	lbu	a5,0(s1)
    800036c8:	89a6                	mv	s3,s1
  len = path - s;
    800036ca:	8d5e                	mv	s10,s7
    800036cc:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    800036ce:	01278963          	beq	a5,s2,800036e0 <namex+0x114>
    800036d2:	d3d9                	beqz	a5,80003658 <namex+0x8c>
    path++;
    800036d4:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    800036d6:	0009c783          	lbu	a5,0(s3)
    800036da:	ff279ce3          	bne	a5,s2,800036d2 <namex+0x106>
    800036de:	bfad                	j	80003658 <namex+0x8c>
    memmove(name, s, len);
    800036e0:	2601                	sext.w	a2,a2
    800036e2:	85a6                	mv	a1,s1
    800036e4:	8556                	mv	a0,s5
    800036e6:	de2fd0ef          	jal	ra,80000cc8 <memmove>
    name[len] = 0;
    800036ea:	9d56                	add	s10,s10,s5
    800036ec:	000d0023          	sb	zero,0(s10) # 1000 <_entry-0x7ffff000>
    800036f0:	84ce                	mv	s1,s3
    800036f2:	bfbd                	j	80003670 <namex+0xa4>
  if(nameiparent){
    800036f4:	f20b0ae3          	beqz	s6,80003628 <namex+0x5c>
    iput(ip);
    800036f8:	8552                	mv	a0,s4
    800036fa:	b69ff0ef          	jal	ra,80003262 <iput>
    return 0;
    800036fe:	4a01                	li	s4,0
    80003700:	b725                	j	80003628 <namex+0x5c>

0000000080003702 <dirlink>:
{
    80003702:	7139                	addi	sp,sp,-64
    80003704:	fc06                	sd	ra,56(sp)
    80003706:	f822                	sd	s0,48(sp)
    80003708:	f426                	sd	s1,40(sp)
    8000370a:	f04a                	sd	s2,32(sp)
    8000370c:	ec4e                	sd	s3,24(sp)
    8000370e:	e852                	sd	s4,16(sp)
    80003710:	0080                	addi	s0,sp,64
    80003712:	892a                	mv	s2,a0
    80003714:	8a2e                	mv	s4,a1
    80003716:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003718:	4601                	li	a2,0
    8000371a:	e17ff0ef          	jal	ra,80003530 <dirlookup>
    8000371e:	e52d                	bnez	a0,80003788 <dirlink+0x86>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003720:	04c92483          	lw	s1,76(s2)
    80003724:	c48d                	beqz	s1,8000374e <dirlink+0x4c>
    80003726:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003728:	4741                	li	a4,16
    8000372a:	86a6                	mv	a3,s1
    8000372c:	fc040613          	addi	a2,s0,-64
    80003730:	4581                	li	a1,0
    80003732:	854a                	mv	a0,s2
    80003734:	c01ff0ef          	jal	ra,80003334 <readi>
    80003738:	47c1                	li	a5,16
    8000373a:	04f51b63          	bne	a0,a5,80003790 <dirlink+0x8e>
    if(de.inum == 0)
    8000373e:	fc045783          	lhu	a5,-64(s0)
    80003742:	c791                	beqz	a5,8000374e <dirlink+0x4c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003744:	24c1                	addiw	s1,s1,16
    80003746:	04c92783          	lw	a5,76(s2)
    8000374a:	fcf4efe3          	bltu	s1,a5,80003728 <dirlink+0x26>
  strncpy(de.name, name, DIRSIZ);
    8000374e:	4639                	li	a2,14
    80003750:	85d2                	mv	a1,s4
    80003752:	fc240513          	addi	a0,s0,-62
    80003756:	e1efd0ef          	jal	ra,80000d74 <strncpy>
  de.inum = inum;
    8000375a:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000375e:	4741                	li	a4,16
    80003760:	86a6                	mv	a3,s1
    80003762:	fc040613          	addi	a2,s0,-64
    80003766:	4581                	li	a1,0
    80003768:	854a                	mv	a0,s2
    8000376a:	cafff0ef          	jal	ra,80003418 <writei>
    8000376e:	1541                	addi	a0,a0,-16
    80003770:	00a03533          	snez	a0,a0
    80003774:	40a00533          	neg	a0,a0
}
    80003778:	70e2                	ld	ra,56(sp)
    8000377a:	7442                	ld	s0,48(sp)
    8000377c:	74a2                	ld	s1,40(sp)
    8000377e:	7902                	ld	s2,32(sp)
    80003780:	69e2                	ld	s3,24(sp)
    80003782:	6a42                	ld	s4,16(sp)
    80003784:	6121                	addi	sp,sp,64
    80003786:	8082                	ret
    iput(ip);
    80003788:	adbff0ef          	jal	ra,80003262 <iput>
    return -1;
    8000378c:	557d                	li	a0,-1
    8000378e:	b7ed                	j	80003778 <dirlink+0x76>
      panic("dirlink read");
    80003790:	00004517          	auipc	a0,0x4
    80003794:	ec850513          	addi	a0,a0,-312 # 80007658 <syscalls+0x1c8>
    80003798:	fbffc0ef          	jal	ra,80000756 <panic>

000000008000379c <namei>:

struct inode*
namei(char *path)
{
    8000379c:	1101                	addi	sp,sp,-32
    8000379e:	ec06                	sd	ra,24(sp)
    800037a0:	e822                	sd	s0,16(sp)
    800037a2:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800037a4:	fe040613          	addi	a2,s0,-32
    800037a8:	4581                	li	a1,0
    800037aa:	e23ff0ef          	jal	ra,800035cc <namex>
}
    800037ae:	60e2                	ld	ra,24(sp)
    800037b0:	6442                	ld	s0,16(sp)
    800037b2:	6105                	addi	sp,sp,32
    800037b4:	8082                	ret

00000000800037b6 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800037b6:	1141                	addi	sp,sp,-16
    800037b8:	e406                	sd	ra,8(sp)
    800037ba:	e022                	sd	s0,0(sp)
    800037bc:	0800                	addi	s0,sp,16
    800037be:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800037c0:	4585                	li	a1,1
    800037c2:	e0bff0ef          	jal	ra,800035cc <namex>
}
    800037c6:	60a2                	ld	ra,8(sp)
    800037c8:	6402                	ld	s0,0(sp)
    800037ca:	0141                	addi	sp,sp,16
    800037cc:	8082                	ret

00000000800037ce <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800037ce:	1101                	addi	sp,sp,-32
    800037d0:	ec06                	sd	ra,24(sp)
    800037d2:	e822                	sd	s0,16(sp)
    800037d4:	e426                	sd	s1,8(sp)
    800037d6:	e04a                	sd	s2,0(sp)
    800037d8:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800037da:	0001c917          	auipc	s2,0x1c
    800037de:	24690913          	addi	s2,s2,582 # 8001fa20 <log>
    800037e2:	01892583          	lw	a1,24(s2)
    800037e6:	02892503          	lw	a0,40(s2)
    800037ea:	9deff0ef          	jal	ra,800029c8 <bread>
    800037ee:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800037f0:	02c92683          	lw	a3,44(s2)
    800037f4:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800037f6:	02d05863          	blez	a3,80003826 <write_head+0x58>
    800037fa:	0001c797          	auipc	a5,0x1c
    800037fe:	25678793          	addi	a5,a5,598 # 8001fa50 <log+0x30>
    80003802:	05c50713          	addi	a4,a0,92
    80003806:	36fd                	addiw	a3,a3,-1
    80003808:	02069613          	slli	a2,a3,0x20
    8000380c:	01e65693          	srli	a3,a2,0x1e
    80003810:	0001c617          	auipc	a2,0x1c
    80003814:	24460613          	addi	a2,a2,580 # 8001fa54 <log+0x34>
    80003818:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    8000381a:	4390                	lw	a2,0(a5)
    8000381c:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000381e:	0791                	addi	a5,a5,4
    80003820:	0711                	addi	a4,a4,4 # 43004 <_entry-0x7ffbcffc>
    80003822:	fed79ce3          	bne	a5,a3,8000381a <write_head+0x4c>
  }
  bwrite(buf);
    80003826:	8526                	mv	a0,s1
    80003828:	a76ff0ef          	jal	ra,80002a9e <bwrite>
  brelse(buf);
    8000382c:	8526                	mv	a0,s1
    8000382e:	aa2ff0ef          	jal	ra,80002ad0 <brelse>
}
    80003832:	60e2                	ld	ra,24(sp)
    80003834:	6442                	ld	s0,16(sp)
    80003836:	64a2                	ld	s1,8(sp)
    80003838:	6902                	ld	s2,0(sp)
    8000383a:	6105                	addi	sp,sp,32
    8000383c:	8082                	ret

000000008000383e <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    8000383e:	0001c797          	auipc	a5,0x1c
    80003842:	20e7a783          	lw	a5,526(a5) # 8001fa4c <log+0x2c>
    80003846:	08f05f63          	blez	a5,800038e4 <install_trans+0xa6>
{
    8000384a:	7139                	addi	sp,sp,-64
    8000384c:	fc06                	sd	ra,56(sp)
    8000384e:	f822                	sd	s0,48(sp)
    80003850:	f426                	sd	s1,40(sp)
    80003852:	f04a                	sd	s2,32(sp)
    80003854:	ec4e                	sd	s3,24(sp)
    80003856:	e852                	sd	s4,16(sp)
    80003858:	e456                	sd	s5,8(sp)
    8000385a:	e05a                	sd	s6,0(sp)
    8000385c:	0080                	addi	s0,sp,64
    8000385e:	8b2a                	mv	s6,a0
    80003860:	0001ca97          	auipc	s5,0x1c
    80003864:	1f0a8a93          	addi	s5,s5,496 # 8001fa50 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003868:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000386a:	0001c997          	auipc	s3,0x1c
    8000386e:	1b698993          	addi	s3,s3,438 # 8001fa20 <log>
    80003872:	a829                	j	8000388c <install_trans+0x4e>
    brelse(lbuf);
    80003874:	854a                	mv	a0,s2
    80003876:	a5aff0ef          	jal	ra,80002ad0 <brelse>
    brelse(dbuf);
    8000387a:	8526                	mv	a0,s1
    8000387c:	a54ff0ef          	jal	ra,80002ad0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003880:	2a05                	addiw	s4,s4,1
    80003882:	0a91                	addi	s5,s5,4
    80003884:	02c9a783          	lw	a5,44(s3)
    80003888:	04fa5463          	bge	s4,a5,800038d0 <install_trans+0x92>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000388c:	0189a583          	lw	a1,24(s3)
    80003890:	014585bb          	addw	a1,a1,s4
    80003894:	2585                	addiw	a1,a1,1
    80003896:	0289a503          	lw	a0,40(s3)
    8000389a:	92eff0ef          	jal	ra,800029c8 <bread>
    8000389e:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800038a0:	000aa583          	lw	a1,0(s5)
    800038a4:	0289a503          	lw	a0,40(s3)
    800038a8:	920ff0ef          	jal	ra,800029c8 <bread>
    800038ac:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800038ae:	40000613          	li	a2,1024
    800038b2:	05890593          	addi	a1,s2,88
    800038b6:	05850513          	addi	a0,a0,88
    800038ba:	c0efd0ef          	jal	ra,80000cc8 <memmove>
    bwrite(dbuf);  // write dst to disk
    800038be:	8526                	mv	a0,s1
    800038c0:	9deff0ef          	jal	ra,80002a9e <bwrite>
    if(recovering == 0)
    800038c4:	fa0b18e3          	bnez	s6,80003874 <install_trans+0x36>
      bunpin(dbuf);
    800038c8:	8526                	mv	a0,s1
    800038ca:	ac4ff0ef          	jal	ra,80002b8e <bunpin>
    800038ce:	b75d                	j	80003874 <install_trans+0x36>
}
    800038d0:	70e2                	ld	ra,56(sp)
    800038d2:	7442                	ld	s0,48(sp)
    800038d4:	74a2                	ld	s1,40(sp)
    800038d6:	7902                	ld	s2,32(sp)
    800038d8:	69e2                	ld	s3,24(sp)
    800038da:	6a42                	ld	s4,16(sp)
    800038dc:	6aa2                	ld	s5,8(sp)
    800038de:	6b02                	ld	s6,0(sp)
    800038e0:	6121                	addi	sp,sp,64
    800038e2:	8082                	ret
    800038e4:	8082                	ret

00000000800038e6 <initlog>:
{
    800038e6:	7179                	addi	sp,sp,-48
    800038e8:	f406                	sd	ra,40(sp)
    800038ea:	f022                	sd	s0,32(sp)
    800038ec:	ec26                	sd	s1,24(sp)
    800038ee:	e84a                	sd	s2,16(sp)
    800038f0:	e44e                	sd	s3,8(sp)
    800038f2:	1800                	addi	s0,sp,48
    800038f4:	892a                	mv	s2,a0
    800038f6:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800038f8:	0001c497          	auipc	s1,0x1c
    800038fc:	12848493          	addi	s1,s1,296 # 8001fa20 <log>
    80003900:	00004597          	auipc	a1,0x4
    80003904:	d6858593          	addi	a1,a1,-664 # 80007668 <syscalls+0x1d8>
    80003908:	8526                	mv	a0,s1
    8000390a:	a0efd0ef          	jal	ra,80000b18 <initlock>
  log.start = sb->logstart;
    8000390e:	0149a583          	lw	a1,20(s3)
    80003912:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003914:	0109a783          	lw	a5,16(s3)
    80003918:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    8000391a:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    8000391e:	854a                	mv	a0,s2
    80003920:	8a8ff0ef          	jal	ra,800029c8 <bread>
  log.lh.n = lh->n;
    80003924:	4d34                	lw	a3,88(a0)
    80003926:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003928:	02d05663          	blez	a3,80003954 <initlog+0x6e>
    8000392c:	05c50793          	addi	a5,a0,92
    80003930:	0001c717          	auipc	a4,0x1c
    80003934:	12070713          	addi	a4,a4,288 # 8001fa50 <log+0x30>
    80003938:	36fd                	addiw	a3,a3,-1
    8000393a:	02069613          	slli	a2,a3,0x20
    8000393e:	01e65693          	srli	a3,a2,0x1e
    80003942:	06050613          	addi	a2,a0,96
    80003946:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    80003948:	4390                	lw	a2,0(a5)
    8000394a:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000394c:	0791                	addi	a5,a5,4
    8000394e:	0711                	addi	a4,a4,4
    80003950:	fed79ce3          	bne	a5,a3,80003948 <initlog+0x62>
  brelse(buf);
    80003954:	97cff0ef          	jal	ra,80002ad0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003958:	4505                	li	a0,1
    8000395a:	ee5ff0ef          	jal	ra,8000383e <install_trans>
  log.lh.n = 0;
    8000395e:	0001c797          	auipc	a5,0x1c
    80003962:	0e07a723          	sw	zero,238(a5) # 8001fa4c <log+0x2c>
  write_head(); // clear the log
    80003966:	e69ff0ef          	jal	ra,800037ce <write_head>
}
    8000396a:	70a2                	ld	ra,40(sp)
    8000396c:	7402                	ld	s0,32(sp)
    8000396e:	64e2                	ld	s1,24(sp)
    80003970:	6942                	ld	s2,16(sp)
    80003972:	69a2                	ld	s3,8(sp)
    80003974:	6145                	addi	sp,sp,48
    80003976:	8082                	ret

0000000080003978 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003978:	1101                	addi	sp,sp,-32
    8000397a:	ec06                	sd	ra,24(sp)
    8000397c:	e822                	sd	s0,16(sp)
    8000397e:	e426                	sd	s1,8(sp)
    80003980:	e04a                	sd	s2,0(sp)
    80003982:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003984:	0001c517          	auipc	a0,0x1c
    80003988:	09c50513          	addi	a0,a0,156 # 8001fa20 <log>
    8000398c:	a0cfd0ef          	jal	ra,80000b98 <acquire>
  while(1){
    if(log.committing){
    80003990:	0001c497          	auipc	s1,0x1c
    80003994:	09048493          	addi	s1,s1,144 # 8001fa20 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003998:	4979                	li	s2,30
    8000399a:	a029                	j	800039a4 <begin_op+0x2c>
      sleep(&log, &log.lock);
    8000399c:	85a6                	mv	a1,s1
    8000399e:	8526                	mv	a0,s1
    800039a0:	c56fe0ef          	jal	ra,80001df6 <sleep>
    if(log.committing){
    800039a4:	50dc                	lw	a5,36(s1)
    800039a6:	fbfd                	bnez	a5,8000399c <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800039a8:	5098                	lw	a4,32(s1)
    800039aa:	2705                	addiw	a4,a4,1
    800039ac:	0007069b          	sext.w	a3,a4
    800039b0:	0027179b          	slliw	a5,a4,0x2
    800039b4:	9fb9                	addw	a5,a5,a4
    800039b6:	0017979b          	slliw	a5,a5,0x1
    800039ba:	54d8                	lw	a4,44(s1)
    800039bc:	9fb9                	addw	a5,a5,a4
    800039be:	00f95763          	bge	s2,a5,800039cc <begin_op+0x54>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800039c2:	85a6                	mv	a1,s1
    800039c4:	8526                	mv	a0,s1
    800039c6:	c30fe0ef          	jal	ra,80001df6 <sleep>
    800039ca:	bfe9                	j	800039a4 <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    800039cc:	0001c517          	auipc	a0,0x1c
    800039d0:	05450513          	addi	a0,a0,84 # 8001fa20 <log>
    800039d4:	d114                	sw	a3,32(a0)
      release(&log.lock);
    800039d6:	a5afd0ef          	jal	ra,80000c30 <release>
      break;
    }
  }
}
    800039da:	60e2                	ld	ra,24(sp)
    800039dc:	6442                	ld	s0,16(sp)
    800039de:	64a2                	ld	s1,8(sp)
    800039e0:	6902                	ld	s2,0(sp)
    800039e2:	6105                	addi	sp,sp,32
    800039e4:	8082                	ret

00000000800039e6 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800039e6:	7139                	addi	sp,sp,-64
    800039e8:	fc06                	sd	ra,56(sp)
    800039ea:	f822                	sd	s0,48(sp)
    800039ec:	f426                	sd	s1,40(sp)
    800039ee:	f04a                	sd	s2,32(sp)
    800039f0:	ec4e                	sd	s3,24(sp)
    800039f2:	e852                	sd	s4,16(sp)
    800039f4:	e456                	sd	s5,8(sp)
    800039f6:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800039f8:	0001c497          	auipc	s1,0x1c
    800039fc:	02848493          	addi	s1,s1,40 # 8001fa20 <log>
    80003a00:	8526                	mv	a0,s1
    80003a02:	996fd0ef          	jal	ra,80000b98 <acquire>
  log.outstanding -= 1;
    80003a06:	509c                	lw	a5,32(s1)
    80003a08:	37fd                	addiw	a5,a5,-1
    80003a0a:	0007891b          	sext.w	s2,a5
    80003a0e:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003a10:	50dc                	lw	a5,36(s1)
    80003a12:	ef9d                	bnez	a5,80003a50 <end_op+0x6a>
    panic("log.committing");
  if(log.outstanding == 0){
    80003a14:	04091463          	bnez	s2,80003a5c <end_op+0x76>
    do_commit = 1;
    log.committing = 1;
    80003a18:	0001c497          	auipc	s1,0x1c
    80003a1c:	00848493          	addi	s1,s1,8 # 8001fa20 <log>
    80003a20:	4785                	li	a5,1
    80003a22:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003a24:	8526                	mv	a0,s1
    80003a26:	a0afd0ef          	jal	ra,80000c30 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003a2a:	54dc                	lw	a5,44(s1)
    80003a2c:	04f04b63          	bgtz	a5,80003a82 <end_op+0x9c>
    acquire(&log.lock);
    80003a30:	0001c497          	auipc	s1,0x1c
    80003a34:	ff048493          	addi	s1,s1,-16 # 8001fa20 <log>
    80003a38:	8526                	mv	a0,s1
    80003a3a:	95efd0ef          	jal	ra,80000b98 <acquire>
    log.committing = 0;
    80003a3e:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003a42:	8526                	mv	a0,s1
    80003a44:	bfefe0ef          	jal	ra,80001e42 <wakeup>
    release(&log.lock);
    80003a48:	8526                	mv	a0,s1
    80003a4a:	9e6fd0ef          	jal	ra,80000c30 <release>
}
    80003a4e:	a00d                	j	80003a70 <end_op+0x8a>
    panic("log.committing");
    80003a50:	00004517          	auipc	a0,0x4
    80003a54:	c2050513          	addi	a0,a0,-992 # 80007670 <syscalls+0x1e0>
    80003a58:	cfffc0ef          	jal	ra,80000756 <panic>
    wakeup(&log);
    80003a5c:	0001c497          	auipc	s1,0x1c
    80003a60:	fc448493          	addi	s1,s1,-60 # 8001fa20 <log>
    80003a64:	8526                	mv	a0,s1
    80003a66:	bdcfe0ef          	jal	ra,80001e42 <wakeup>
  release(&log.lock);
    80003a6a:	8526                	mv	a0,s1
    80003a6c:	9c4fd0ef          	jal	ra,80000c30 <release>
}
    80003a70:	70e2                	ld	ra,56(sp)
    80003a72:	7442                	ld	s0,48(sp)
    80003a74:	74a2                	ld	s1,40(sp)
    80003a76:	7902                	ld	s2,32(sp)
    80003a78:	69e2                	ld	s3,24(sp)
    80003a7a:	6a42                	ld	s4,16(sp)
    80003a7c:	6aa2                	ld	s5,8(sp)
    80003a7e:	6121                	addi	sp,sp,64
    80003a80:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    80003a82:	0001ca97          	auipc	s5,0x1c
    80003a86:	fcea8a93          	addi	s5,s5,-50 # 8001fa50 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003a8a:	0001ca17          	auipc	s4,0x1c
    80003a8e:	f96a0a13          	addi	s4,s4,-106 # 8001fa20 <log>
    80003a92:	018a2583          	lw	a1,24(s4)
    80003a96:	012585bb          	addw	a1,a1,s2
    80003a9a:	2585                	addiw	a1,a1,1
    80003a9c:	028a2503          	lw	a0,40(s4)
    80003aa0:	f29fe0ef          	jal	ra,800029c8 <bread>
    80003aa4:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003aa6:	000aa583          	lw	a1,0(s5)
    80003aaa:	028a2503          	lw	a0,40(s4)
    80003aae:	f1bfe0ef          	jal	ra,800029c8 <bread>
    80003ab2:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003ab4:	40000613          	li	a2,1024
    80003ab8:	05850593          	addi	a1,a0,88
    80003abc:	05848513          	addi	a0,s1,88
    80003ac0:	a08fd0ef          	jal	ra,80000cc8 <memmove>
    bwrite(to);  // write the log
    80003ac4:	8526                	mv	a0,s1
    80003ac6:	fd9fe0ef          	jal	ra,80002a9e <bwrite>
    brelse(from);
    80003aca:	854e                	mv	a0,s3
    80003acc:	804ff0ef          	jal	ra,80002ad0 <brelse>
    brelse(to);
    80003ad0:	8526                	mv	a0,s1
    80003ad2:	ffffe0ef          	jal	ra,80002ad0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003ad6:	2905                	addiw	s2,s2,1
    80003ad8:	0a91                	addi	s5,s5,4
    80003ada:	02ca2783          	lw	a5,44(s4)
    80003ade:	faf94ae3          	blt	s2,a5,80003a92 <end_op+0xac>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003ae2:	cedff0ef          	jal	ra,800037ce <write_head>
    install_trans(0); // Now install writes to home locations
    80003ae6:	4501                	li	a0,0
    80003ae8:	d57ff0ef          	jal	ra,8000383e <install_trans>
    log.lh.n = 0;
    80003aec:	0001c797          	auipc	a5,0x1c
    80003af0:	f607a023          	sw	zero,-160(a5) # 8001fa4c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003af4:	cdbff0ef          	jal	ra,800037ce <write_head>
    80003af8:	bf25                	j	80003a30 <end_op+0x4a>

0000000080003afa <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003afa:	1101                	addi	sp,sp,-32
    80003afc:	ec06                	sd	ra,24(sp)
    80003afe:	e822                	sd	s0,16(sp)
    80003b00:	e426                	sd	s1,8(sp)
    80003b02:	e04a                	sd	s2,0(sp)
    80003b04:	1000                	addi	s0,sp,32
    80003b06:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003b08:	0001c917          	auipc	s2,0x1c
    80003b0c:	f1890913          	addi	s2,s2,-232 # 8001fa20 <log>
    80003b10:	854a                	mv	a0,s2
    80003b12:	886fd0ef          	jal	ra,80000b98 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003b16:	02c92603          	lw	a2,44(s2)
    80003b1a:	47f5                	li	a5,29
    80003b1c:	06c7c363          	blt	a5,a2,80003b82 <log_write+0x88>
    80003b20:	0001c797          	auipc	a5,0x1c
    80003b24:	f1c7a783          	lw	a5,-228(a5) # 8001fa3c <log+0x1c>
    80003b28:	37fd                	addiw	a5,a5,-1
    80003b2a:	04f65c63          	bge	a2,a5,80003b82 <log_write+0x88>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003b2e:	0001c797          	auipc	a5,0x1c
    80003b32:	f127a783          	lw	a5,-238(a5) # 8001fa40 <log+0x20>
    80003b36:	04f05c63          	blez	a5,80003b8e <log_write+0x94>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003b3a:	4781                	li	a5,0
    80003b3c:	04c05f63          	blez	a2,80003b9a <log_write+0xa0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003b40:	44cc                	lw	a1,12(s1)
    80003b42:	0001c717          	auipc	a4,0x1c
    80003b46:	f0e70713          	addi	a4,a4,-242 # 8001fa50 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003b4a:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003b4c:	4314                	lw	a3,0(a4)
    80003b4e:	04b68663          	beq	a3,a1,80003b9a <log_write+0xa0>
  for (i = 0; i < log.lh.n; i++) {
    80003b52:	2785                	addiw	a5,a5,1
    80003b54:	0711                	addi	a4,a4,4
    80003b56:	fef61be3          	bne	a2,a5,80003b4c <log_write+0x52>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003b5a:	0621                	addi	a2,a2,8
    80003b5c:	060a                	slli	a2,a2,0x2
    80003b5e:	0001c797          	auipc	a5,0x1c
    80003b62:	ec278793          	addi	a5,a5,-318 # 8001fa20 <log>
    80003b66:	97b2                	add	a5,a5,a2
    80003b68:	44d8                	lw	a4,12(s1)
    80003b6a:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003b6c:	8526                	mv	a0,s1
    80003b6e:	fedfe0ef          	jal	ra,80002b5a <bpin>
    log.lh.n++;
    80003b72:	0001c717          	auipc	a4,0x1c
    80003b76:	eae70713          	addi	a4,a4,-338 # 8001fa20 <log>
    80003b7a:	575c                	lw	a5,44(a4)
    80003b7c:	2785                	addiw	a5,a5,1
    80003b7e:	d75c                	sw	a5,44(a4)
    80003b80:	a80d                	j	80003bb2 <log_write+0xb8>
    panic("too big a transaction");
    80003b82:	00004517          	auipc	a0,0x4
    80003b86:	afe50513          	addi	a0,a0,-1282 # 80007680 <syscalls+0x1f0>
    80003b8a:	bcdfc0ef          	jal	ra,80000756 <panic>
    panic("log_write outside of trans");
    80003b8e:	00004517          	auipc	a0,0x4
    80003b92:	b0a50513          	addi	a0,a0,-1270 # 80007698 <syscalls+0x208>
    80003b96:	bc1fc0ef          	jal	ra,80000756 <panic>
  log.lh.block[i] = b->blockno;
    80003b9a:	00878693          	addi	a3,a5,8
    80003b9e:	068a                	slli	a3,a3,0x2
    80003ba0:	0001c717          	auipc	a4,0x1c
    80003ba4:	e8070713          	addi	a4,a4,-384 # 8001fa20 <log>
    80003ba8:	9736                	add	a4,a4,a3
    80003baa:	44d4                	lw	a3,12(s1)
    80003bac:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003bae:	faf60fe3          	beq	a2,a5,80003b6c <log_write+0x72>
  }
  release(&log.lock);
    80003bb2:	0001c517          	auipc	a0,0x1c
    80003bb6:	e6e50513          	addi	a0,a0,-402 # 8001fa20 <log>
    80003bba:	876fd0ef          	jal	ra,80000c30 <release>
}
    80003bbe:	60e2                	ld	ra,24(sp)
    80003bc0:	6442                	ld	s0,16(sp)
    80003bc2:	64a2                	ld	s1,8(sp)
    80003bc4:	6902                	ld	s2,0(sp)
    80003bc6:	6105                	addi	sp,sp,32
    80003bc8:	8082                	ret

0000000080003bca <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003bca:	1101                	addi	sp,sp,-32
    80003bcc:	ec06                	sd	ra,24(sp)
    80003bce:	e822                	sd	s0,16(sp)
    80003bd0:	e426                	sd	s1,8(sp)
    80003bd2:	e04a                	sd	s2,0(sp)
    80003bd4:	1000                	addi	s0,sp,32
    80003bd6:	84aa                	mv	s1,a0
    80003bd8:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003bda:	00004597          	auipc	a1,0x4
    80003bde:	ade58593          	addi	a1,a1,-1314 # 800076b8 <syscalls+0x228>
    80003be2:	0521                	addi	a0,a0,8
    80003be4:	f35fc0ef          	jal	ra,80000b18 <initlock>
  lk->name = name;
    80003be8:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003bec:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003bf0:	0204a423          	sw	zero,40(s1)
}
    80003bf4:	60e2                	ld	ra,24(sp)
    80003bf6:	6442                	ld	s0,16(sp)
    80003bf8:	64a2                	ld	s1,8(sp)
    80003bfa:	6902                	ld	s2,0(sp)
    80003bfc:	6105                	addi	sp,sp,32
    80003bfe:	8082                	ret

0000000080003c00 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003c00:	1101                	addi	sp,sp,-32
    80003c02:	ec06                	sd	ra,24(sp)
    80003c04:	e822                	sd	s0,16(sp)
    80003c06:	e426                	sd	s1,8(sp)
    80003c08:	e04a                	sd	s2,0(sp)
    80003c0a:	1000                	addi	s0,sp,32
    80003c0c:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003c0e:	00850913          	addi	s2,a0,8
    80003c12:	854a                	mv	a0,s2
    80003c14:	f85fc0ef          	jal	ra,80000b98 <acquire>
  while (lk->locked) {
    80003c18:	409c                	lw	a5,0(s1)
    80003c1a:	c799                	beqz	a5,80003c28 <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    80003c1c:	85ca                	mv	a1,s2
    80003c1e:	8526                	mv	a0,s1
    80003c20:	9d6fe0ef          	jal	ra,80001df6 <sleep>
  while (lk->locked) {
    80003c24:	409c                	lw	a5,0(s1)
    80003c26:	fbfd                	bnez	a5,80003c1c <acquiresleep+0x1c>
  }
  lk->locked = 1;
    80003c28:	4785                	li	a5,1
    80003c2a:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003c2c:	bfffd0ef          	jal	ra,8000182a <myproc>
    80003c30:	591c                	lw	a5,48(a0)
    80003c32:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003c34:	854a                	mv	a0,s2
    80003c36:	ffbfc0ef          	jal	ra,80000c30 <release>
}
    80003c3a:	60e2                	ld	ra,24(sp)
    80003c3c:	6442                	ld	s0,16(sp)
    80003c3e:	64a2                	ld	s1,8(sp)
    80003c40:	6902                	ld	s2,0(sp)
    80003c42:	6105                	addi	sp,sp,32
    80003c44:	8082                	ret

0000000080003c46 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003c46:	1101                	addi	sp,sp,-32
    80003c48:	ec06                	sd	ra,24(sp)
    80003c4a:	e822                	sd	s0,16(sp)
    80003c4c:	e426                	sd	s1,8(sp)
    80003c4e:	e04a                	sd	s2,0(sp)
    80003c50:	1000                	addi	s0,sp,32
    80003c52:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003c54:	00850913          	addi	s2,a0,8
    80003c58:	854a                	mv	a0,s2
    80003c5a:	f3ffc0ef          	jal	ra,80000b98 <acquire>
  lk->locked = 0;
    80003c5e:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003c62:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003c66:	8526                	mv	a0,s1
    80003c68:	9dafe0ef          	jal	ra,80001e42 <wakeup>
  release(&lk->lk);
    80003c6c:	854a                	mv	a0,s2
    80003c6e:	fc3fc0ef          	jal	ra,80000c30 <release>
}
    80003c72:	60e2                	ld	ra,24(sp)
    80003c74:	6442                	ld	s0,16(sp)
    80003c76:	64a2                	ld	s1,8(sp)
    80003c78:	6902                	ld	s2,0(sp)
    80003c7a:	6105                	addi	sp,sp,32
    80003c7c:	8082                	ret

0000000080003c7e <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003c7e:	7179                	addi	sp,sp,-48
    80003c80:	f406                	sd	ra,40(sp)
    80003c82:	f022                	sd	s0,32(sp)
    80003c84:	ec26                	sd	s1,24(sp)
    80003c86:	e84a                	sd	s2,16(sp)
    80003c88:	e44e                	sd	s3,8(sp)
    80003c8a:	1800                	addi	s0,sp,48
    80003c8c:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003c8e:	00850913          	addi	s2,a0,8
    80003c92:	854a                	mv	a0,s2
    80003c94:	f05fc0ef          	jal	ra,80000b98 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003c98:	409c                	lw	a5,0(s1)
    80003c9a:	ef89                	bnez	a5,80003cb4 <holdingsleep+0x36>
    80003c9c:	4481                	li	s1,0
  release(&lk->lk);
    80003c9e:	854a                	mv	a0,s2
    80003ca0:	f91fc0ef          	jal	ra,80000c30 <release>
  return r;
}
    80003ca4:	8526                	mv	a0,s1
    80003ca6:	70a2                	ld	ra,40(sp)
    80003ca8:	7402                	ld	s0,32(sp)
    80003caa:	64e2                	ld	s1,24(sp)
    80003cac:	6942                	ld	s2,16(sp)
    80003cae:	69a2                	ld	s3,8(sp)
    80003cb0:	6145                	addi	sp,sp,48
    80003cb2:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003cb4:	0284a983          	lw	s3,40(s1)
    80003cb8:	b73fd0ef          	jal	ra,8000182a <myproc>
    80003cbc:	5904                	lw	s1,48(a0)
    80003cbe:	413484b3          	sub	s1,s1,s3
    80003cc2:	0014b493          	seqz	s1,s1
    80003cc6:	bfe1                	j	80003c9e <holdingsleep+0x20>

0000000080003cc8 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003cc8:	1141                	addi	sp,sp,-16
    80003cca:	e406                	sd	ra,8(sp)
    80003ccc:	e022                	sd	s0,0(sp)
    80003cce:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003cd0:	00004597          	auipc	a1,0x4
    80003cd4:	9f858593          	addi	a1,a1,-1544 # 800076c8 <syscalls+0x238>
    80003cd8:	0001c517          	auipc	a0,0x1c
    80003cdc:	e9050513          	addi	a0,a0,-368 # 8001fb68 <ftable>
    80003ce0:	e39fc0ef          	jal	ra,80000b18 <initlock>
}
    80003ce4:	60a2                	ld	ra,8(sp)
    80003ce6:	6402                	ld	s0,0(sp)
    80003ce8:	0141                	addi	sp,sp,16
    80003cea:	8082                	ret

0000000080003cec <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003cec:	1101                	addi	sp,sp,-32
    80003cee:	ec06                	sd	ra,24(sp)
    80003cf0:	e822                	sd	s0,16(sp)
    80003cf2:	e426                	sd	s1,8(sp)
    80003cf4:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003cf6:	0001c517          	auipc	a0,0x1c
    80003cfa:	e7250513          	addi	a0,a0,-398 # 8001fb68 <ftable>
    80003cfe:	e9bfc0ef          	jal	ra,80000b98 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003d02:	0001c497          	auipc	s1,0x1c
    80003d06:	e7e48493          	addi	s1,s1,-386 # 8001fb80 <ftable+0x18>
    80003d0a:	0001d717          	auipc	a4,0x1d
    80003d0e:	e1670713          	addi	a4,a4,-490 # 80020b20 <disk>
    if(f->ref == 0){
    80003d12:	40dc                	lw	a5,4(s1)
    80003d14:	cf89                	beqz	a5,80003d2e <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003d16:	02848493          	addi	s1,s1,40
    80003d1a:	fee49ce3          	bne	s1,a4,80003d12 <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003d1e:	0001c517          	auipc	a0,0x1c
    80003d22:	e4a50513          	addi	a0,a0,-438 # 8001fb68 <ftable>
    80003d26:	f0bfc0ef          	jal	ra,80000c30 <release>
  return 0;
    80003d2a:	4481                	li	s1,0
    80003d2c:	a809                	j	80003d3e <filealloc+0x52>
      f->ref = 1;
    80003d2e:	4785                	li	a5,1
    80003d30:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003d32:	0001c517          	auipc	a0,0x1c
    80003d36:	e3650513          	addi	a0,a0,-458 # 8001fb68 <ftable>
    80003d3a:	ef7fc0ef          	jal	ra,80000c30 <release>
}
    80003d3e:	8526                	mv	a0,s1
    80003d40:	60e2                	ld	ra,24(sp)
    80003d42:	6442                	ld	s0,16(sp)
    80003d44:	64a2                	ld	s1,8(sp)
    80003d46:	6105                	addi	sp,sp,32
    80003d48:	8082                	ret

0000000080003d4a <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003d4a:	1101                	addi	sp,sp,-32
    80003d4c:	ec06                	sd	ra,24(sp)
    80003d4e:	e822                	sd	s0,16(sp)
    80003d50:	e426                	sd	s1,8(sp)
    80003d52:	1000                	addi	s0,sp,32
    80003d54:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003d56:	0001c517          	auipc	a0,0x1c
    80003d5a:	e1250513          	addi	a0,a0,-494 # 8001fb68 <ftable>
    80003d5e:	e3bfc0ef          	jal	ra,80000b98 <acquire>
  if(f->ref < 1)
    80003d62:	40dc                	lw	a5,4(s1)
    80003d64:	02f05063          	blez	a5,80003d84 <filedup+0x3a>
    panic("filedup");
  f->ref++;
    80003d68:	2785                	addiw	a5,a5,1
    80003d6a:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003d6c:	0001c517          	auipc	a0,0x1c
    80003d70:	dfc50513          	addi	a0,a0,-516 # 8001fb68 <ftable>
    80003d74:	ebdfc0ef          	jal	ra,80000c30 <release>
  return f;
}
    80003d78:	8526                	mv	a0,s1
    80003d7a:	60e2                	ld	ra,24(sp)
    80003d7c:	6442                	ld	s0,16(sp)
    80003d7e:	64a2                	ld	s1,8(sp)
    80003d80:	6105                	addi	sp,sp,32
    80003d82:	8082                	ret
    panic("filedup");
    80003d84:	00004517          	auipc	a0,0x4
    80003d88:	94c50513          	addi	a0,a0,-1716 # 800076d0 <syscalls+0x240>
    80003d8c:	9cbfc0ef          	jal	ra,80000756 <panic>

0000000080003d90 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003d90:	7139                	addi	sp,sp,-64
    80003d92:	fc06                	sd	ra,56(sp)
    80003d94:	f822                	sd	s0,48(sp)
    80003d96:	f426                	sd	s1,40(sp)
    80003d98:	f04a                	sd	s2,32(sp)
    80003d9a:	ec4e                	sd	s3,24(sp)
    80003d9c:	e852                	sd	s4,16(sp)
    80003d9e:	e456                	sd	s5,8(sp)
    80003da0:	0080                	addi	s0,sp,64
    80003da2:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003da4:	0001c517          	auipc	a0,0x1c
    80003da8:	dc450513          	addi	a0,a0,-572 # 8001fb68 <ftable>
    80003dac:	dedfc0ef          	jal	ra,80000b98 <acquire>
  if(f->ref < 1)
    80003db0:	40dc                	lw	a5,4(s1)
    80003db2:	04f05963          	blez	a5,80003e04 <fileclose+0x74>
    panic("fileclose");
  if(--f->ref > 0){
    80003db6:	37fd                	addiw	a5,a5,-1
    80003db8:	0007871b          	sext.w	a4,a5
    80003dbc:	c0dc                	sw	a5,4(s1)
    80003dbe:	04e04963          	bgtz	a4,80003e10 <fileclose+0x80>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003dc2:	0004a903          	lw	s2,0(s1)
    80003dc6:	0094ca83          	lbu	s5,9(s1)
    80003dca:	0104ba03          	ld	s4,16(s1)
    80003dce:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003dd2:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003dd6:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003dda:	0001c517          	auipc	a0,0x1c
    80003dde:	d8e50513          	addi	a0,a0,-626 # 8001fb68 <ftable>
    80003de2:	e4ffc0ef          	jal	ra,80000c30 <release>

  if(ff.type == FD_PIPE){
    80003de6:	4785                	li	a5,1
    80003de8:	04f90363          	beq	s2,a5,80003e2e <fileclose+0x9e>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003dec:	3979                	addiw	s2,s2,-2
    80003dee:	4785                	li	a5,1
    80003df0:	0327e663          	bltu	a5,s2,80003e1c <fileclose+0x8c>
    begin_op();
    80003df4:	b85ff0ef          	jal	ra,80003978 <begin_op>
    iput(ff.ip);
    80003df8:	854e                	mv	a0,s3
    80003dfa:	c68ff0ef          	jal	ra,80003262 <iput>
    end_op();
    80003dfe:	be9ff0ef          	jal	ra,800039e6 <end_op>
    80003e02:	a829                	j	80003e1c <fileclose+0x8c>
    panic("fileclose");
    80003e04:	00004517          	auipc	a0,0x4
    80003e08:	8d450513          	addi	a0,a0,-1836 # 800076d8 <syscalls+0x248>
    80003e0c:	94bfc0ef          	jal	ra,80000756 <panic>
    release(&ftable.lock);
    80003e10:	0001c517          	auipc	a0,0x1c
    80003e14:	d5850513          	addi	a0,a0,-680 # 8001fb68 <ftable>
    80003e18:	e19fc0ef          	jal	ra,80000c30 <release>
  }
}
    80003e1c:	70e2                	ld	ra,56(sp)
    80003e1e:	7442                	ld	s0,48(sp)
    80003e20:	74a2                	ld	s1,40(sp)
    80003e22:	7902                	ld	s2,32(sp)
    80003e24:	69e2                	ld	s3,24(sp)
    80003e26:	6a42                	ld	s4,16(sp)
    80003e28:	6aa2                	ld	s5,8(sp)
    80003e2a:	6121                	addi	sp,sp,64
    80003e2c:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003e2e:	85d6                	mv	a1,s5
    80003e30:	8552                	mv	a0,s4
    80003e32:	2ec000ef          	jal	ra,8000411e <pipeclose>
    80003e36:	b7dd                	j	80003e1c <fileclose+0x8c>

0000000080003e38 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003e38:	715d                	addi	sp,sp,-80
    80003e3a:	e486                	sd	ra,72(sp)
    80003e3c:	e0a2                	sd	s0,64(sp)
    80003e3e:	fc26                	sd	s1,56(sp)
    80003e40:	f84a                	sd	s2,48(sp)
    80003e42:	f44e                	sd	s3,40(sp)
    80003e44:	0880                	addi	s0,sp,80
    80003e46:	84aa                	mv	s1,a0
    80003e48:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003e4a:	9e1fd0ef          	jal	ra,8000182a <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003e4e:	409c                	lw	a5,0(s1)
    80003e50:	37f9                	addiw	a5,a5,-2
    80003e52:	4705                	li	a4,1
    80003e54:	02f76f63          	bltu	a4,a5,80003e92 <filestat+0x5a>
    80003e58:	892a                	mv	s2,a0
    ilock(f->ip);
    80003e5a:	6c88                	ld	a0,24(s1)
    80003e5c:	a88ff0ef          	jal	ra,800030e4 <ilock>
    stati(f->ip, &st);
    80003e60:	fb840593          	addi	a1,s0,-72
    80003e64:	6c88                	ld	a0,24(s1)
    80003e66:	ca4ff0ef          	jal	ra,8000330a <stati>
    iunlock(f->ip);
    80003e6a:	6c88                	ld	a0,24(s1)
    80003e6c:	b22ff0ef          	jal	ra,8000318e <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003e70:	46e1                	li	a3,24
    80003e72:	fb840613          	addi	a2,s0,-72
    80003e76:	85ce                	mv	a1,s3
    80003e78:	05093503          	ld	a0,80(s2)
    80003e7c:	e66fd0ef          	jal	ra,800014e2 <copyout>
    80003e80:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003e84:	60a6                	ld	ra,72(sp)
    80003e86:	6406                	ld	s0,64(sp)
    80003e88:	74e2                	ld	s1,56(sp)
    80003e8a:	7942                	ld	s2,48(sp)
    80003e8c:	79a2                	ld	s3,40(sp)
    80003e8e:	6161                	addi	sp,sp,80
    80003e90:	8082                	ret
  return -1;
    80003e92:	557d                	li	a0,-1
    80003e94:	bfc5                	j	80003e84 <filestat+0x4c>

0000000080003e96 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003e96:	7179                	addi	sp,sp,-48
    80003e98:	f406                	sd	ra,40(sp)
    80003e9a:	f022                	sd	s0,32(sp)
    80003e9c:	ec26                	sd	s1,24(sp)
    80003e9e:	e84a                	sd	s2,16(sp)
    80003ea0:	e44e                	sd	s3,8(sp)
    80003ea2:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003ea4:	00854783          	lbu	a5,8(a0)
    80003ea8:	cbc1                	beqz	a5,80003f38 <fileread+0xa2>
    80003eaa:	84aa                	mv	s1,a0
    80003eac:	89ae                	mv	s3,a1
    80003eae:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003eb0:	411c                	lw	a5,0(a0)
    80003eb2:	4705                	li	a4,1
    80003eb4:	04e78363          	beq	a5,a4,80003efa <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003eb8:	470d                	li	a4,3
    80003eba:	04e78563          	beq	a5,a4,80003f04 <fileread+0x6e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003ebe:	4709                	li	a4,2
    80003ec0:	06e79663          	bne	a5,a4,80003f2c <fileread+0x96>
    ilock(f->ip);
    80003ec4:	6d08                	ld	a0,24(a0)
    80003ec6:	a1eff0ef          	jal	ra,800030e4 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003eca:	874a                	mv	a4,s2
    80003ecc:	5094                	lw	a3,32(s1)
    80003ece:	864e                	mv	a2,s3
    80003ed0:	4585                	li	a1,1
    80003ed2:	6c88                	ld	a0,24(s1)
    80003ed4:	c60ff0ef          	jal	ra,80003334 <readi>
    80003ed8:	892a                	mv	s2,a0
    80003eda:	00a05563          	blez	a0,80003ee4 <fileread+0x4e>
      f->off += r;
    80003ede:	509c                	lw	a5,32(s1)
    80003ee0:	9fa9                	addw	a5,a5,a0
    80003ee2:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003ee4:	6c88                	ld	a0,24(s1)
    80003ee6:	aa8ff0ef          	jal	ra,8000318e <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003eea:	854a                	mv	a0,s2
    80003eec:	70a2                	ld	ra,40(sp)
    80003eee:	7402                	ld	s0,32(sp)
    80003ef0:	64e2                	ld	s1,24(sp)
    80003ef2:	6942                	ld	s2,16(sp)
    80003ef4:	69a2                	ld	s3,8(sp)
    80003ef6:	6145                	addi	sp,sp,48
    80003ef8:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003efa:	6908                	ld	a0,16(a0)
    80003efc:	34e000ef          	jal	ra,8000424a <piperead>
    80003f00:	892a                	mv	s2,a0
    80003f02:	b7e5                	j	80003eea <fileread+0x54>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003f04:	02451783          	lh	a5,36(a0)
    80003f08:	03079693          	slli	a3,a5,0x30
    80003f0c:	92c1                	srli	a3,a3,0x30
    80003f0e:	4725                	li	a4,9
    80003f10:	02d76663          	bltu	a4,a3,80003f3c <fileread+0xa6>
    80003f14:	0792                	slli	a5,a5,0x4
    80003f16:	0001c717          	auipc	a4,0x1c
    80003f1a:	bb270713          	addi	a4,a4,-1102 # 8001fac8 <devsw>
    80003f1e:	97ba                	add	a5,a5,a4
    80003f20:	639c                	ld	a5,0(a5)
    80003f22:	cf99                	beqz	a5,80003f40 <fileread+0xaa>
    r = devsw[f->major].read(1, addr, n);
    80003f24:	4505                	li	a0,1
    80003f26:	9782                	jalr	a5
    80003f28:	892a                	mv	s2,a0
    80003f2a:	b7c1                	j	80003eea <fileread+0x54>
    panic("fileread");
    80003f2c:	00003517          	auipc	a0,0x3
    80003f30:	7bc50513          	addi	a0,a0,1980 # 800076e8 <syscalls+0x258>
    80003f34:	823fc0ef          	jal	ra,80000756 <panic>
    return -1;
    80003f38:	597d                	li	s2,-1
    80003f3a:	bf45                	j	80003eea <fileread+0x54>
      return -1;
    80003f3c:	597d                	li	s2,-1
    80003f3e:	b775                	j	80003eea <fileread+0x54>
    80003f40:	597d                	li	s2,-1
    80003f42:	b765                	j	80003eea <fileread+0x54>

0000000080003f44 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003f44:	715d                	addi	sp,sp,-80
    80003f46:	e486                	sd	ra,72(sp)
    80003f48:	e0a2                	sd	s0,64(sp)
    80003f4a:	fc26                	sd	s1,56(sp)
    80003f4c:	f84a                	sd	s2,48(sp)
    80003f4e:	f44e                	sd	s3,40(sp)
    80003f50:	f052                	sd	s4,32(sp)
    80003f52:	ec56                	sd	s5,24(sp)
    80003f54:	e85a                	sd	s6,16(sp)
    80003f56:	e45e                	sd	s7,8(sp)
    80003f58:	e062                	sd	s8,0(sp)
    80003f5a:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003f5c:	00954783          	lbu	a5,9(a0)
    80003f60:	0e078863          	beqz	a5,80004050 <filewrite+0x10c>
    80003f64:	892a                	mv	s2,a0
    80003f66:	8b2e                	mv	s6,a1
    80003f68:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003f6a:	411c                	lw	a5,0(a0)
    80003f6c:	4705                	li	a4,1
    80003f6e:	02e78263          	beq	a5,a4,80003f92 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003f72:	470d                	li	a4,3
    80003f74:	02e78463          	beq	a5,a4,80003f9c <filewrite+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003f78:	4709                	li	a4,2
    80003f7a:	0ce79563          	bne	a5,a4,80004044 <filewrite+0x100>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003f7e:	0ac05163          	blez	a2,80004020 <filewrite+0xdc>
    int i = 0;
    80003f82:	4981                	li	s3,0
    80003f84:	6b85                	lui	s7,0x1
    80003f86:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003f8a:	6c05                	lui	s8,0x1
    80003f8c:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003f90:	a041                	j	80004010 <filewrite+0xcc>
    ret = pipewrite(f->pipe, addr, n);
    80003f92:	6908                	ld	a0,16(a0)
    80003f94:	1e2000ef          	jal	ra,80004176 <pipewrite>
    80003f98:	8a2a                	mv	s4,a0
    80003f9a:	a071                	j	80004026 <filewrite+0xe2>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003f9c:	02451783          	lh	a5,36(a0)
    80003fa0:	03079693          	slli	a3,a5,0x30
    80003fa4:	92c1                	srli	a3,a3,0x30
    80003fa6:	4725                	li	a4,9
    80003fa8:	0ad76663          	bltu	a4,a3,80004054 <filewrite+0x110>
    80003fac:	0792                	slli	a5,a5,0x4
    80003fae:	0001c717          	auipc	a4,0x1c
    80003fb2:	b1a70713          	addi	a4,a4,-1254 # 8001fac8 <devsw>
    80003fb6:	97ba                	add	a5,a5,a4
    80003fb8:	679c                	ld	a5,8(a5)
    80003fba:	cfd9                	beqz	a5,80004058 <filewrite+0x114>
    ret = devsw[f->major].write(1, addr, n);
    80003fbc:	4505                	li	a0,1
    80003fbe:	9782                	jalr	a5
    80003fc0:	8a2a                	mv	s4,a0
    80003fc2:	a095                	j	80004026 <filewrite+0xe2>
    80003fc4:	00048a9b          	sext.w	s5,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003fc8:	9b1ff0ef          	jal	ra,80003978 <begin_op>
      ilock(f->ip);
    80003fcc:	01893503          	ld	a0,24(s2)
    80003fd0:	914ff0ef          	jal	ra,800030e4 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003fd4:	8756                	mv	a4,s5
    80003fd6:	02092683          	lw	a3,32(s2)
    80003fda:	01698633          	add	a2,s3,s6
    80003fde:	4585                	li	a1,1
    80003fe0:	01893503          	ld	a0,24(s2)
    80003fe4:	c34ff0ef          	jal	ra,80003418 <writei>
    80003fe8:	84aa                	mv	s1,a0
    80003fea:	00a05763          	blez	a0,80003ff8 <filewrite+0xb4>
        f->off += r;
    80003fee:	02092783          	lw	a5,32(s2)
    80003ff2:	9fa9                	addw	a5,a5,a0
    80003ff4:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003ff8:	01893503          	ld	a0,24(s2)
    80003ffc:	992ff0ef          	jal	ra,8000318e <iunlock>
      end_op();
    80004000:	9e7ff0ef          	jal	ra,800039e6 <end_op>

      if(r != n1){
    80004004:	009a9f63          	bne	s5,s1,80004022 <filewrite+0xde>
        // error from writei
        break;
      }
      i += r;
    80004008:	013489bb          	addw	s3,s1,s3
    while(i < n){
    8000400c:	0149db63          	bge	s3,s4,80004022 <filewrite+0xde>
      int n1 = n - i;
    80004010:	413a04bb          	subw	s1,s4,s3
    80004014:	0004879b          	sext.w	a5,s1
    80004018:	fafbd6e3          	bge	s7,a5,80003fc4 <filewrite+0x80>
    8000401c:	84e2                	mv	s1,s8
    8000401e:	b75d                	j	80003fc4 <filewrite+0x80>
    int i = 0;
    80004020:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80004022:	013a1f63          	bne	s4,s3,80004040 <filewrite+0xfc>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80004026:	8552                	mv	a0,s4
    80004028:	60a6                	ld	ra,72(sp)
    8000402a:	6406                	ld	s0,64(sp)
    8000402c:	74e2                	ld	s1,56(sp)
    8000402e:	7942                	ld	s2,48(sp)
    80004030:	79a2                	ld	s3,40(sp)
    80004032:	7a02                	ld	s4,32(sp)
    80004034:	6ae2                	ld	s5,24(sp)
    80004036:	6b42                	ld	s6,16(sp)
    80004038:	6ba2                	ld	s7,8(sp)
    8000403a:	6c02                	ld	s8,0(sp)
    8000403c:	6161                	addi	sp,sp,80
    8000403e:	8082                	ret
    ret = (i == n ? n : -1);
    80004040:	5a7d                	li	s4,-1
    80004042:	b7d5                	j	80004026 <filewrite+0xe2>
    panic("filewrite");
    80004044:	00003517          	auipc	a0,0x3
    80004048:	6b450513          	addi	a0,a0,1716 # 800076f8 <syscalls+0x268>
    8000404c:	f0afc0ef          	jal	ra,80000756 <panic>
    return -1;
    80004050:	5a7d                	li	s4,-1
    80004052:	bfd1                	j	80004026 <filewrite+0xe2>
      return -1;
    80004054:	5a7d                	li	s4,-1
    80004056:	bfc1                	j	80004026 <filewrite+0xe2>
    80004058:	5a7d                	li	s4,-1
    8000405a:	b7f1                	j	80004026 <filewrite+0xe2>

000000008000405c <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    8000405c:	7179                	addi	sp,sp,-48
    8000405e:	f406                	sd	ra,40(sp)
    80004060:	f022                	sd	s0,32(sp)
    80004062:	ec26                	sd	s1,24(sp)
    80004064:	e84a                	sd	s2,16(sp)
    80004066:	e44e                	sd	s3,8(sp)
    80004068:	e052                	sd	s4,0(sp)
    8000406a:	1800                	addi	s0,sp,48
    8000406c:	84aa                	mv	s1,a0
    8000406e:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80004070:	0005b023          	sd	zero,0(a1)
    80004074:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004078:	c75ff0ef          	jal	ra,80003cec <filealloc>
    8000407c:	e088                	sd	a0,0(s1)
    8000407e:	cd35                	beqz	a0,800040fa <pipealloc+0x9e>
    80004080:	c6dff0ef          	jal	ra,80003cec <filealloc>
    80004084:	00aa3023          	sd	a0,0(s4)
    80004088:	c52d                	beqz	a0,800040f2 <pipealloc+0x96>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    8000408a:	a3ffc0ef          	jal	ra,80000ac8 <kalloc>
    8000408e:	892a                	mv	s2,a0
    80004090:	cd31                	beqz	a0,800040ec <pipealloc+0x90>
    goto bad;
  pi->readopen = 1;
    80004092:	4985                	li	s3,1
    80004094:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80004098:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    8000409c:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    800040a0:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    800040a4:	00003597          	auipc	a1,0x3
    800040a8:	66458593          	addi	a1,a1,1636 # 80007708 <syscalls+0x278>
    800040ac:	a6dfc0ef          	jal	ra,80000b18 <initlock>
  (*f0)->type = FD_PIPE;
    800040b0:	609c                	ld	a5,0(s1)
    800040b2:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    800040b6:	609c                	ld	a5,0(s1)
    800040b8:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    800040bc:	609c                	ld	a5,0(s1)
    800040be:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    800040c2:	609c                	ld	a5,0(s1)
    800040c4:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    800040c8:	000a3783          	ld	a5,0(s4)
    800040cc:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    800040d0:	000a3783          	ld	a5,0(s4)
    800040d4:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    800040d8:	000a3783          	ld	a5,0(s4)
    800040dc:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    800040e0:	000a3783          	ld	a5,0(s4)
    800040e4:	0127b823          	sd	s2,16(a5)
  return 0;
    800040e8:	4501                	li	a0,0
    800040ea:	a005                	j	8000410a <pipealloc+0xae>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    800040ec:	6088                	ld	a0,0(s1)
    800040ee:	e501                	bnez	a0,800040f6 <pipealloc+0x9a>
    800040f0:	a029                	j	800040fa <pipealloc+0x9e>
    800040f2:	6088                	ld	a0,0(s1)
    800040f4:	c11d                	beqz	a0,8000411a <pipealloc+0xbe>
    fileclose(*f0);
    800040f6:	c9bff0ef          	jal	ra,80003d90 <fileclose>
  if(*f1)
    800040fa:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    800040fe:	557d                	li	a0,-1
  if(*f1)
    80004100:	c789                	beqz	a5,8000410a <pipealloc+0xae>
    fileclose(*f1);
    80004102:	853e                	mv	a0,a5
    80004104:	c8dff0ef          	jal	ra,80003d90 <fileclose>
  return -1;
    80004108:	557d                	li	a0,-1
}
    8000410a:	70a2                	ld	ra,40(sp)
    8000410c:	7402                	ld	s0,32(sp)
    8000410e:	64e2                	ld	s1,24(sp)
    80004110:	6942                	ld	s2,16(sp)
    80004112:	69a2                	ld	s3,8(sp)
    80004114:	6a02                	ld	s4,0(sp)
    80004116:	6145                	addi	sp,sp,48
    80004118:	8082                	ret
  return -1;
    8000411a:	557d                	li	a0,-1
    8000411c:	b7fd                	j	8000410a <pipealloc+0xae>

000000008000411e <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    8000411e:	1101                	addi	sp,sp,-32
    80004120:	ec06                	sd	ra,24(sp)
    80004122:	e822                	sd	s0,16(sp)
    80004124:	e426                	sd	s1,8(sp)
    80004126:	e04a                	sd	s2,0(sp)
    80004128:	1000                	addi	s0,sp,32
    8000412a:	84aa                	mv	s1,a0
    8000412c:	892e                	mv	s2,a1
  acquire(&pi->lock);
    8000412e:	a6bfc0ef          	jal	ra,80000b98 <acquire>
  if(writable){
    80004132:	02090763          	beqz	s2,80004160 <pipeclose+0x42>
    pi->writeopen = 0;
    80004136:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    8000413a:	21848513          	addi	a0,s1,536
    8000413e:	d05fd0ef          	jal	ra,80001e42 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004142:	2204b783          	ld	a5,544(s1)
    80004146:	e785                	bnez	a5,8000416e <pipeclose+0x50>
    release(&pi->lock);
    80004148:	8526                	mv	a0,s1
    8000414a:	ae7fc0ef          	jal	ra,80000c30 <release>
    kfree((char*)pi);
    8000414e:	8526                	mv	a0,s1
    80004150:	897fc0ef          	jal	ra,800009e6 <kfree>
  } else
    release(&pi->lock);
}
    80004154:	60e2                	ld	ra,24(sp)
    80004156:	6442                	ld	s0,16(sp)
    80004158:	64a2                	ld	s1,8(sp)
    8000415a:	6902                	ld	s2,0(sp)
    8000415c:	6105                	addi	sp,sp,32
    8000415e:	8082                	ret
    pi->readopen = 0;
    80004160:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004164:	21c48513          	addi	a0,s1,540
    80004168:	cdbfd0ef          	jal	ra,80001e42 <wakeup>
    8000416c:	bfd9                	j	80004142 <pipeclose+0x24>
    release(&pi->lock);
    8000416e:	8526                	mv	a0,s1
    80004170:	ac1fc0ef          	jal	ra,80000c30 <release>
}
    80004174:	b7c5                	j	80004154 <pipeclose+0x36>

0000000080004176 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004176:	711d                	addi	sp,sp,-96
    80004178:	ec86                	sd	ra,88(sp)
    8000417a:	e8a2                	sd	s0,80(sp)
    8000417c:	e4a6                	sd	s1,72(sp)
    8000417e:	e0ca                	sd	s2,64(sp)
    80004180:	fc4e                	sd	s3,56(sp)
    80004182:	f852                	sd	s4,48(sp)
    80004184:	f456                	sd	s5,40(sp)
    80004186:	f05a                	sd	s6,32(sp)
    80004188:	ec5e                	sd	s7,24(sp)
    8000418a:	e862                	sd	s8,16(sp)
    8000418c:	1080                	addi	s0,sp,96
    8000418e:	84aa                	mv	s1,a0
    80004190:	8aae                	mv	s5,a1
    80004192:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004194:	e96fd0ef          	jal	ra,8000182a <myproc>
    80004198:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    8000419a:	8526                	mv	a0,s1
    8000419c:	9fdfc0ef          	jal	ra,80000b98 <acquire>
  while(i < n){
    800041a0:	09405c63          	blez	s4,80004238 <pipewrite+0xc2>
  int i = 0;
    800041a4:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800041a6:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    800041a8:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    800041ac:	21c48b93          	addi	s7,s1,540
    800041b0:	a81d                	j	800041e6 <pipewrite+0x70>
      release(&pi->lock);
    800041b2:	8526                	mv	a0,s1
    800041b4:	a7dfc0ef          	jal	ra,80000c30 <release>
      return -1;
    800041b8:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    800041ba:	854a                	mv	a0,s2
    800041bc:	60e6                	ld	ra,88(sp)
    800041be:	6446                	ld	s0,80(sp)
    800041c0:	64a6                	ld	s1,72(sp)
    800041c2:	6906                	ld	s2,64(sp)
    800041c4:	79e2                	ld	s3,56(sp)
    800041c6:	7a42                	ld	s4,48(sp)
    800041c8:	7aa2                	ld	s5,40(sp)
    800041ca:	7b02                	ld	s6,32(sp)
    800041cc:	6be2                	ld	s7,24(sp)
    800041ce:	6c42                	ld	s8,16(sp)
    800041d0:	6125                	addi	sp,sp,96
    800041d2:	8082                	ret
      wakeup(&pi->nread);
    800041d4:	8562                	mv	a0,s8
    800041d6:	c6dfd0ef          	jal	ra,80001e42 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    800041da:	85a6                	mv	a1,s1
    800041dc:	855e                	mv	a0,s7
    800041de:	c19fd0ef          	jal	ra,80001df6 <sleep>
  while(i < n){
    800041e2:	05495c63          	bge	s2,s4,8000423a <pipewrite+0xc4>
    if(pi->readopen == 0 || killed(pr)){
    800041e6:	2204a783          	lw	a5,544(s1)
    800041ea:	d7e1                	beqz	a5,800041b2 <pipewrite+0x3c>
    800041ec:	854e                	mv	a0,s3
    800041ee:	e41fd0ef          	jal	ra,8000202e <killed>
    800041f2:	f161                	bnez	a0,800041b2 <pipewrite+0x3c>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    800041f4:	2184a783          	lw	a5,536(s1)
    800041f8:	21c4a703          	lw	a4,540(s1)
    800041fc:	2007879b          	addiw	a5,a5,512
    80004200:	fcf70ae3          	beq	a4,a5,800041d4 <pipewrite+0x5e>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004204:	4685                	li	a3,1
    80004206:	01590633          	add	a2,s2,s5
    8000420a:	faf40593          	addi	a1,s0,-81
    8000420e:	0509b503          	ld	a0,80(s3)
    80004212:	b88fd0ef          	jal	ra,8000159a <copyin>
    80004216:	03650263          	beq	a0,s6,8000423a <pipewrite+0xc4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    8000421a:	21c4a783          	lw	a5,540(s1)
    8000421e:	0017871b          	addiw	a4,a5,1
    80004222:	20e4ae23          	sw	a4,540(s1)
    80004226:	1ff7f793          	andi	a5,a5,511
    8000422a:	97a6                	add	a5,a5,s1
    8000422c:	faf44703          	lbu	a4,-81(s0)
    80004230:	00e78c23          	sb	a4,24(a5)
      i++;
    80004234:	2905                	addiw	s2,s2,1
    80004236:	b775                	j	800041e2 <pipewrite+0x6c>
  int i = 0;
    80004238:	4901                	li	s2,0
  wakeup(&pi->nread);
    8000423a:	21848513          	addi	a0,s1,536
    8000423e:	c05fd0ef          	jal	ra,80001e42 <wakeup>
  release(&pi->lock);
    80004242:	8526                	mv	a0,s1
    80004244:	9edfc0ef          	jal	ra,80000c30 <release>
  return i;
    80004248:	bf8d                	j	800041ba <pipewrite+0x44>

000000008000424a <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    8000424a:	715d                	addi	sp,sp,-80
    8000424c:	e486                	sd	ra,72(sp)
    8000424e:	e0a2                	sd	s0,64(sp)
    80004250:	fc26                	sd	s1,56(sp)
    80004252:	f84a                	sd	s2,48(sp)
    80004254:	f44e                	sd	s3,40(sp)
    80004256:	f052                	sd	s4,32(sp)
    80004258:	ec56                	sd	s5,24(sp)
    8000425a:	e85a                	sd	s6,16(sp)
    8000425c:	0880                	addi	s0,sp,80
    8000425e:	84aa                	mv	s1,a0
    80004260:	892e                	mv	s2,a1
    80004262:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004264:	dc6fd0ef          	jal	ra,8000182a <myproc>
    80004268:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    8000426a:	8526                	mv	a0,s1
    8000426c:	92dfc0ef          	jal	ra,80000b98 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004270:	2184a703          	lw	a4,536(s1)
    80004274:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004278:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000427c:	02f71363          	bne	a4,a5,800042a2 <piperead+0x58>
    80004280:	2244a783          	lw	a5,548(s1)
    80004284:	cf99                	beqz	a5,800042a2 <piperead+0x58>
    if(killed(pr)){
    80004286:	8552                	mv	a0,s4
    80004288:	da7fd0ef          	jal	ra,8000202e <killed>
    8000428c:	e149                	bnez	a0,8000430e <piperead+0xc4>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000428e:	85a6                	mv	a1,s1
    80004290:	854e                	mv	a0,s3
    80004292:	b65fd0ef          	jal	ra,80001df6 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004296:	2184a703          	lw	a4,536(s1)
    8000429a:	21c4a783          	lw	a5,540(s1)
    8000429e:	fef701e3          	beq	a4,a5,80004280 <piperead+0x36>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800042a2:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800042a4:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800042a6:	05505263          	blez	s5,800042ea <piperead+0xa0>
    if(pi->nread == pi->nwrite)
    800042aa:	2184a783          	lw	a5,536(s1)
    800042ae:	21c4a703          	lw	a4,540(s1)
    800042b2:	02f70c63          	beq	a4,a5,800042ea <piperead+0xa0>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800042b6:	0017871b          	addiw	a4,a5,1
    800042ba:	20e4ac23          	sw	a4,536(s1)
    800042be:	1ff7f793          	andi	a5,a5,511
    800042c2:	97a6                	add	a5,a5,s1
    800042c4:	0187c783          	lbu	a5,24(a5)
    800042c8:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800042cc:	4685                	li	a3,1
    800042ce:	fbf40613          	addi	a2,s0,-65
    800042d2:	85ca                	mv	a1,s2
    800042d4:	050a3503          	ld	a0,80(s4)
    800042d8:	a0afd0ef          	jal	ra,800014e2 <copyout>
    800042dc:	01650763          	beq	a0,s6,800042ea <piperead+0xa0>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800042e0:	2985                	addiw	s3,s3,1
    800042e2:	0905                	addi	s2,s2,1
    800042e4:	fd3a93e3          	bne	s5,s3,800042aa <piperead+0x60>
    800042e8:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800042ea:	21c48513          	addi	a0,s1,540
    800042ee:	b55fd0ef          	jal	ra,80001e42 <wakeup>
  release(&pi->lock);
    800042f2:	8526                	mv	a0,s1
    800042f4:	93dfc0ef          	jal	ra,80000c30 <release>
  return i;
}
    800042f8:	854e                	mv	a0,s3
    800042fa:	60a6                	ld	ra,72(sp)
    800042fc:	6406                	ld	s0,64(sp)
    800042fe:	74e2                	ld	s1,56(sp)
    80004300:	7942                	ld	s2,48(sp)
    80004302:	79a2                	ld	s3,40(sp)
    80004304:	7a02                	ld	s4,32(sp)
    80004306:	6ae2                	ld	s5,24(sp)
    80004308:	6b42                	ld	s6,16(sp)
    8000430a:	6161                	addi	sp,sp,80
    8000430c:	8082                	ret
      release(&pi->lock);
    8000430e:	8526                	mv	a0,s1
    80004310:	921fc0ef          	jal	ra,80000c30 <release>
      return -1;
    80004314:	59fd                	li	s3,-1
    80004316:	b7cd                	j	800042f8 <piperead+0xae>

0000000080004318 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80004318:	1141                	addi	sp,sp,-16
    8000431a:	e422                	sd	s0,8(sp)
    8000431c:	0800                	addi	s0,sp,16
    8000431e:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80004320:	8905                	andi	a0,a0,1
    80004322:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    80004324:	8b89                	andi	a5,a5,2
    80004326:	c399                	beqz	a5,8000432c <flags2perm+0x14>
      perm |= PTE_W;
    80004328:	00456513          	ori	a0,a0,4
    return perm;
}
    8000432c:	6422                	ld	s0,8(sp)
    8000432e:	0141                	addi	sp,sp,16
    80004330:	8082                	ret

0000000080004332 <exec>:

int
exec(char *path, char **argv)
{
    80004332:	de010113          	addi	sp,sp,-544
    80004336:	20113c23          	sd	ra,536(sp)
    8000433a:	20813823          	sd	s0,528(sp)
    8000433e:	20913423          	sd	s1,520(sp)
    80004342:	21213023          	sd	s2,512(sp)
    80004346:	ffce                	sd	s3,504(sp)
    80004348:	fbd2                	sd	s4,496(sp)
    8000434a:	f7d6                	sd	s5,488(sp)
    8000434c:	f3da                	sd	s6,480(sp)
    8000434e:	efde                	sd	s7,472(sp)
    80004350:	ebe2                	sd	s8,464(sp)
    80004352:	e7e6                	sd	s9,456(sp)
    80004354:	e3ea                	sd	s10,448(sp)
    80004356:	ff6e                	sd	s11,440(sp)
    80004358:	1400                	addi	s0,sp,544
    8000435a:	892a                	mv	s2,a0
    8000435c:	dea43423          	sd	a0,-536(s0)
    80004360:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004364:	cc6fd0ef          	jal	ra,8000182a <myproc>
    80004368:	84aa                	mv	s1,a0

  begin_op();
    8000436a:	e0eff0ef          	jal	ra,80003978 <begin_op>

  if((ip = namei(path)) == 0){
    8000436e:	854a                	mv	a0,s2
    80004370:	c2cff0ef          	jal	ra,8000379c <namei>
    80004374:	c13d                	beqz	a0,800043da <exec+0xa8>
    80004376:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004378:	d6dfe0ef          	jal	ra,800030e4 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    8000437c:	04000713          	li	a4,64
    80004380:	4681                	li	a3,0
    80004382:	e5040613          	addi	a2,s0,-432
    80004386:	4581                	li	a1,0
    80004388:	8556                	mv	a0,s5
    8000438a:	fabfe0ef          	jal	ra,80003334 <readi>
    8000438e:	04000793          	li	a5,64
    80004392:	00f51a63          	bne	a0,a5,800043a6 <exec+0x74>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80004396:	e5042703          	lw	a4,-432(s0)
    8000439a:	464c47b7          	lui	a5,0x464c4
    8000439e:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800043a2:	04f70063          	beq	a4,a5,800043e2 <exec+0xb0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800043a6:	8556                	mv	a0,s5
    800043a8:	f43fe0ef          	jal	ra,800032ea <iunlockput>
    end_op();
    800043ac:	e3aff0ef          	jal	ra,800039e6 <end_op>
  }
  return -1;
    800043b0:	557d                	li	a0,-1
}
    800043b2:	21813083          	ld	ra,536(sp)
    800043b6:	21013403          	ld	s0,528(sp)
    800043ba:	20813483          	ld	s1,520(sp)
    800043be:	20013903          	ld	s2,512(sp)
    800043c2:	79fe                	ld	s3,504(sp)
    800043c4:	7a5e                	ld	s4,496(sp)
    800043c6:	7abe                	ld	s5,488(sp)
    800043c8:	7b1e                	ld	s6,480(sp)
    800043ca:	6bfe                	ld	s7,472(sp)
    800043cc:	6c5e                	ld	s8,464(sp)
    800043ce:	6cbe                	ld	s9,456(sp)
    800043d0:	6d1e                	ld	s10,448(sp)
    800043d2:	7dfa                	ld	s11,440(sp)
    800043d4:	22010113          	addi	sp,sp,544
    800043d8:	8082                	ret
    end_op();
    800043da:	e0cff0ef          	jal	ra,800039e6 <end_op>
    return -1;
    800043de:	557d                	li	a0,-1
    800043e0:	bfc9                	j	800043b2 <exec+0x80>
  if((pagetable = proc_pagetable(p)) == 0)
    800043e2:	8526                	mv	a0,s1
    800043e4:	ceefd0ef          	jal	ra,800018d2 <proc_pagetable>
    800043e8:	8b2a                	mv	s6,a0
    800043ea:	dd55                	beqz	a0,800043a6 <exec+0x74>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800043ec:	e7042783          	lw	a5,-400(s0)
    800043f0:	e8845703          	lhu	a4,-376(s0)
    800043f4:	c325                	beqz	a4,80004454 <exec+0x122>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800043f6:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800043f8:	e0043423          	sd	zero,-504(s0)
    if(ph.vaddr % PGSIZE != 0)
    800043fc:	6a05                	lui	s4,0x1
    800043fe:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    80004402:	dee43023          	sd	a4,-544(s0)
loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz)
{
  uint i, n;
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    80004406:	6d85                	lui	s11,0x1
    80004408:	7d7d                	lui	s10,0xfffff
    8000440a:	a409                	j	8000460c <exec+0x2da>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    8000440c:	00003517          	auipc	a0,0x3
    80004410:	30450513          	addi	a0,a0,772 # 80007710 <syscalls+0x280>
    80004414:	b42fc0ef          	jal	ra,80000756 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004418:	874a                	mv	a4,s2
    8000441a:	009c86bb          	addw	a3,s9,s1
    8000441e:	4581                	li	a1,0
    80004420:	8556                	mv	a0,s5
    80004422:	f13fe0ef          	jal	ra,80003334 <readi>
    80004426:	2501                	sext.w	a0,a0
    80004428:	18a91163          	bne	s2,a0,800045aa <exec+0x278>
  for(i = 0; i < sz; i += PGSIZE){
    8000442c:	009d84bb          	addw	s1,s11,s1
    80004430:	013d09bb          	addw	s3,s10,s3
    80004434:	1b74fc63          	bgeu	s1,s7,800045ec <exec+0x2ba>
    pa = walkaddr(pagetable, va + i);
    80004438:	02049593          	slli	a1,s1,0x20
    8000443c:	9181                	srli	a1,a1,0x20
    8000443e:	95e2                	add	a1,a1,s8
    80004440:	855a                	mv	a0,s6
    80004442:	b41fc0ef          	jal	ra,80000f82 <walkaddr>
    80004446:	862a                	mv	a2,a0
    if(pa == 0)
    80004448:	d171                	beqz	a0,8000440c <exec+0xda>
      n = PGSIZE;
    8000444a:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    8000444c:	fd49f6e3          	bgeu	s3,s4,80004418 <exec+0xe6>
      n = sz - i;
    80004450:	894e                	mv	s2,s3
    80004452:	b7d9                	j	80004418 <exec+0xe6>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004454:	4901                	li	s2,0
  iunlockput(ip);
    80004456:	8556                	mv	a0,s5
    80004458:	e93fe0ef          	jal	ra,800032ea <iunlockput>
  end_op();
    8000445c:	d8aff0ef          	jal	ra,800039e6 <end_op>
  p = myproc();
    80004460:	bcafd0ef          	jal	ra,8000182a <myproc>
    80004464:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    80004466:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    8000446a:	6785                	lui	a5,0x1
    8000446c:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000446e:	97ca                	add	a5,a5,s2
    80004470:	777d                	lui	a4,0xfffff
    80004472:	8ff9                	and	a5,a5,a4
    80004474:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    80004478:	4691                	li	a3,4
    8000447a:	6609                	lui	a2,0x2
    8000447c:	963e                	add	a2,a2,a5
    8000447e:	85be                	mv	a1,a5
    80004480:	855a                	mv	a0,s6
    80004482:	e59fc0ef          	jal	ra,800012da <uvmalloc>
    80004486:	8c2a                	mv	s8,a0
  ip = 0;
    80004488:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    8000448a:	12050063          	beqz	a0,800045aa <exec+0x278>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    8000448e:	75f9                	lui	a1,0xffffe
    80004490:	95aa                	add	a1,a1,a0
    80004492:	855a                	mv	a0,s6
    80004494:	824fd0ef          	jal	ra,800014b8 <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    80004498:	7afd                	lui	s5,0xfffff
    8000449a:	9ae2                	add	s5,s5,s8
  for(argc = 0; argv[argc]; argc++) {
    8000449c:	df043783          	ld	a5,-528(s0)
    800044a0:	6388                	ld	a0,0(a5)
    800044a2:	c135                	beqz	a0,80004506 <exec+0x1d4>
    800044a4:	e9040993          	addi	s3,s0,-368
    800044a8:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    800044ac:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    800044ae:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    800044b0:	935fc0ef          	jal	ra,80000de4 <strlen>
    800044b4:	0015079b          	addiw	a5,a0,1
    800044b8:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800044bc:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    800044c0:	11596a63          	bltu	s2,s5,800045d4 <exec+0x2a2>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800044c4:	df043d83          	ld	s11,-528(s0)
    800044c8:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    800044cc:	8552                	mv	a0,s4
    800044ce:	917fc0ef          	jal	ra,80000de4 <strlen>
    800044d2:	0015069b          	addiw	a3,a0,1
    800044d6:	8652                	mv	a2,s4
    800044d8:	85ca                	mv	a1,s2
    800044da:	855a                	mv	a0,s6
    800044dc:	806fd0ef          	jal	ra,800014e2 <copyout>
    800044e0:	0e054e63          	bltz	a0,800045dc <exec+0x2aa>
    ustack[argc] = sp;
    800044e4:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800044e8:	0485                	addi	s1,s1,1
    800044ea:	008d8793          	addi	a5,s11,8
    800044ee:	def43823          	sd	a5,-528(s0)
    800044f2:	008db503          	ld	a0,8(s11)
    800044f6:	c911                	beqz	a0,8000450a <exec+0x1d8>
    if(argc >= MAXARG)
    800044f8:	09a1                	addi	s3,s3,8
    800044fa:	fb3c9be3          	bne	s9,s3,800044b0 <exec+0x17e>
  sz = sz1;
    800044fe:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004502:	4a81                	li	s5,0
    80004504:	a05d                	j	800045aa <exec+0x278>
  sp = sz;
    80004506:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80004508:	4481                	li	s1,0
  ustack[argc] = 0;
    8000450a:	00349793          	slli	a5,s1,0x3
    8000450e:	f9078793          	addi	a5,a5,-112
    80004512:	97a2                	add	a5,a5,s0
    80004514:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80004518:	00148693          	addi	a3,s1,1
    8000451c:	068e                	slli	a3,a3,0x3
    8000451e:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004522:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    80004526:	01597663          	bgeu	s2,s5,80004532 <exec+0x200>
  sz = sz1;
    8000452a:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000452e:	4a81                	li	s5,0
    80004530:	a8ad                	j	800045aa <exec+0x278>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004532:	e9040613          	addi	a2,s0,-368
    80004536:	85ca                	mv	a1,s2
    80004538:	855a                	mv	a0,s6
    8000453a:	fa9fc0ef          	jal	ra,800014e2 <copyout>
    8000453e:	0a054363          	bltz	a0,800045e4 <exec+0x2b2>
  p->trapframe->a1 = sp;
    80004542:	058bb783          	ld	a5,88(s7)
    80004546:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    8000454a:	de843783          	ld	a5,-536(s0)
    8000454e:	0007c703          	lbu	a4,0(a5)
    80004552:	cf11                	beqz	a4,8000456e <exec+0x23c>
    80004554:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004556:	02f00693          	li	a3,47
    8000455a:	a039                	j	80004568 <exec+0x236>
      last = s+1;
    8000455c:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    80004560:	0785                	addi	a5,a5,1
    80004562:	fff7c703          	lbu	a4,-1(a5)
    80004566:	c701                	beqz	a4,8000456e <exec+0x23c>
    if(*s == '/')
    80004568:	fed71ce3          	bne	a4,a3,80004560 <exec+0x22e>
    8000456c:	bfc5                	j	8000455c <exec+0x22a>
  safestrcpy(p->name, last, sizeof(p->name));
    8000456e:	4641                	li	a2,16
    80004570:	de843583          	ld	a1,-536(s0)
    80004574:	158b8513          	addi	a0,s7,344
    80004578:	83bfc0ef          	jal	ra,80000db2 <safestrcpy>
  oldpagetable = p->pagetable;
    8000457c:	050bb503          	ld	a0,80(s7)
  p->pagetable = pagetable;
    80004580:	056bb823          	sd	s6,80(s7)
  p->sz = sz;
    80004584:	058bb423          	sd	s8,72(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004588:	058bb783          	ld	a5,88(s7)
    8000458c:	e6843703          	ld	a4,-408(s0)
    80004590:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004592:	058bb783          	ld	a5,88(s7)
    80004596:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    8000459a:	85ea                	mv	a1,s10
    8000459c:	bbafd0ef          	jal	ra,80001956 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800045a0:	0004851b          	sext.w	a0,s1
    800045a4:	b539                	j	800043b2 <exec+0x80>
    800045a6:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    800045aa:	df843583          	ld	a1,-520(s0)
    800045ae:	855a                	mv	a0,s6
    800045b0:	ba6fd0ef          	jal	ra,80001956 <proc_freepagetable>
  if(ip){
    800045b4:	de0a99e3          	bnez	s5,800043a6 <exec+0x74>
  return -1;
    800045b8:	557d                	li	a0,-1
    800045ba:	bbe5                	j	800043b2 <exec+0x80>
    800045bc:	df243c23          	sd	s2,-520(s0)
    800045c0:	b7ed                	j	800045aa <exec+0x278>
    800045c2:	df243c23          	sd	s2,-520(s0)
    800045c6:	b7d5                	j	800045aa <exec+0x278>
    800045c8:	df243c23          	sd	s2,-520(s0)
    800045cc:	bff9                	j	800045aa <exec+0x278>
    800045ce:	df243c23          	sd	s2,-520(s0)
    800045d2:	bfe1                	j	800045aa <exec+0x278>
  sz = sz1;
    800045d4:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800045d8:	4a81                	li	s5,0
    800045da:	bfc1                	j	800045aa <exec+0x278>
  sz = sz1;
    800045dc:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800045e0:	4a81                	li	s5,0
    800045e2:	b7e1                	j	800045aa <exec+0x278>
  sz = sz1;
    800045e4:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800045e8:	4a81                	li	s5,0
    800045ea:	b7c1                	j	800045aa <exec+0x278>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800045ec:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800045f0:	e0843783          	ld	a5,-504(s0)
    800045f4:	0017869b          	addiw	a3,a5,1
    800045f8:	e0d43423          	sd	a3,-504(s0)
    800045fc:	e0043783          	ld	a5,-512(s0)
    80004600:	0387879b          	addiw	a5,a5,56
    80004604:	e8845703          	lhu	a4,-376(s0)
    80004608:	e4e6d7e3          	bge	a3,a4,80004456 <exec+0x124>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    8000460c:	2781                	sext.w	a5,a5
    8000460e:	e0f43023          	sd	a5,-512(s0)
    80004612:	03800713          	li	a4,56
    80004616:	86be                	mv	a3,a5
    80004618:	e1840613          	addi	a2,s0,-488
    8000461c:	4581                	li	a1,0
    8000461e:	8556                	mv	a0,s5
    80004620:	d15fe0ef          	jal	ra,80003334 <readi>
    80004624:	03800793          	li	a5,56
    80004628:	f6f51fe3          	bne	a0,a5,800045a6 <exec+0x274>
    if(ph.type != ELF_PROG_LOAD)
    8000462c:	e1842783          	lw	a5,-488(s0)
    80004630:	4705                	li	a4,1
    80004632:	fae79fe3          	bne	a5,a4,800045f0 <exec+0x2be>
    if(ph.memsz < ph.filesz)
    80004636:	e4043483          	ld	s1,-448(s0)
    8000463a:	e3843783          	ld	a5,-456(s0)
    8000463e:	f6f4efe3          	bltu	s1,a5,800045bc <exec+0x28a>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004642:	e2843783          	ld	a5,-472(s0)
    80004646:	94be                	add	s1,s1,a5
    80004648:	f6f4ede3          	bltu	s1,a5,800045c2 <exec+0x290>
    if(ph.vaddr % PGSIZE != 0)
    8000464c:	de043703          	ld	a4,-544(s0)
    80004650:	8ff9                	and	a5,a5,a4
    80004652:	fbbd                	bnez	a5,800045c8 <exec+0x296>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004654:	e1c42503          	lw	a0,-484(s0)
    80004658:	cc1ff0ef          	jal	ra,80004318 <flags2perm>
    8000465c:	86aa                	mv	a3,a0
    8000465e:	8626                	mv	a2,s1
    80004660:	85ca                	mv	a1,s2
    80004662:	855a                	mv	a0,s6
    80004664:	c77fc0ef          	jal	ra,800012da <uvmalloc>
    80004668:	dea43c23          	sd	a0,-520(s0)
    8000466c:	d12d                	beqz	a0,800045ce <exec+0x29c>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000466e:	e2843c03          	ld	s8,-472(s0)
    80004672:	e2042c83          	lw	s9,-480(s0)
    80004676:	e3842b83          	lw	s7,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    8000467a:	f60b89e3          	beqz	s7,800045ec <exec+0x2ba>
    8000467e:	89de                	mv	s3,s7
    80004680:	4481                	li	s1,0
    80004682:	bb5d                	j	80004438 <exec+0x106>

0000000080004684 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004684:	7179                	addi	sp,sp,-48
    80004686:	f406                	sd	ra,40(sp)
    80004688:	f022                	sd	s0,32(sp)
    8000468a:	ec26                	sd	s1,24(sp)
    8000468c:	e84a                	sd	s2,16(sp)
    8000468e:	1800                	addi	s0,sp,48
    80004690:	892e                	mv	s2,a1
    80004692:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80004694:	fdc40593          	addi	a1,s0,-36
    80004698:	840fe0ef          	jal	ra,800026d8 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    8000469c:	fdc42703          	lw	a4,-36(s0)
    800046a0:	47bd                	li	a5,15
    800046a2:	02e7e963          	bltu	a5,a4,800046d4 <argfd+0x50>
    800046a6:	984fd0ef          	jal	ra,8000182a <myproc>
    800046aa:	fdc42703          	lw	a4,-36(s0)
    800046ae:	01a70793          	addi	a5,a4,26 # fffffffffffff01a <end+0xffffffff7ffde3ba>
    800046b2:	078e                	slli	a5,a5,0x3
    800046b4:	953e                	add	a0,a0,a5
    800046b6:	611c                	ld	a5,0(a0)
    800046b8:	c385                	beqz	a5,800046d8 <argfd+0x54>
    return -1;
  if(pfd)
    800046ba:	00090463          	beqz	s2,800046c2 <argfd+0x3e>
    *pfd = fd;
    800046be:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800046c2:	4501                	li	a0,0
  if(pf)
    800046c4:	c091                	beqz	s1,800046c8 <argfd+0x44>
    *pf = f;
    800046c6:	e09c                	sd	a5,0(s1)
}
    800046c8:	70a2                	ld	ra,40(sp)
    800046ca:	7402                	ld	s0,32(sp)
    800046cc:	64e2                	ld	s1,24(sp)
    800046ce:	6942                	ld	s2,16(sp)
    800046d0:	6145                	addi	sp,sp,48
    800046d2:	8082                	ret
    return -1;
    800046d4:	557d                	li	a0,-1
    800046d6:	bfcd                	j	800046c8 <argfd+0x44>
    800046d8:	557d                	li	a0,-1
    800046da:	b7fd                	j	800046c8 <argfd+0x44>

00000000800046dc <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800046dc:	1101                	addi	sp,sp,-32
    800046de:	ec06                	sd	ra,24(sp)
    800046e0:	e822                	sd	s0,16(sp)
    800046e2:	e426                	sd	s1,8(sp)
    800046e4:	1000                	addi	s0,sp,32
    800046e6:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800046e8:	942fd0ef          	jal	ra,8000182a <myproc>
    800046ec:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800046ee:	0d050793          	addi	a5,a0,208
    800046f2:	4501                	li	a0,0
    800046f4:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800046f6:	6398                	ld	a4,0(a5)
    800046f8:	cb19                	beqz	a4,8000470e <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    800046fa:	2505                	addiw	a0,a0,1
    800046fc:	07a1                	addi	a5,a5,8
    800046fe:	fed51ce3          	bne	a0,a3,800046f6 <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004702:	557d                	li	a0,-1
}
    80004704:	60e2                	ld	ra,24(sp)
    80004706:	6442                	ld	s0,16(sp)
    80004708:	64a2                	ld	s1,8(sp)
    8000470a:	6105                	addi	sp,sp,32
    8000470c:	8082                	ret
      p->ofile[fd] = f;
    8000470e:	01a50793          	addi	a5,a0,26
    80004712:	078e                	slli	a5,a5,0x3
    80004714:	963e                	add	a2,a2,a5
    80004716:	e204                	sd	s1,0(a2)
      return fd;
    80004718:	b7f5                	j	80004704 <fdalloc+0x28>

000000008000471a <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    8000471a:	715d                	addi	sp,sp,-80
    8000471c:	e486                	sd	ra,72(sp)
    8000471e:	e0a2                	sd	s0,64(sp)
    80004720:	fc26                	sd	s1,56(sp)
    80004722:	f84a                	sd	s2,48(sp)
    80004724:	f44e                	sd	s3,40(sp)
    80004726:	f052                	sd	s4,32(sp)
    80004728:	ec56                	sd	s5,24(sp)
    8000472a:	e85a                	sd	s6,16(sp)
    8000472c:	0880                	addi	s0,sp,80
    8000472e:	8b2e                	mv	s6,a1
    80004730:	89b2                	mv	s3,a2
    80004732:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004734:	fb040593          	addi	a1,s0,-80
    80004738:	87eff0ef          	jal	ra,800037b6 <nameiparent>
    8000473c:	84aa                	mv	s1,a0
    8000473e:	10050b63          	beqz	a0,80004854 <create+0x13a>
    return 0;

  ilock(dp);
    80004742:	9a3fe0ef          	jal	ra,800030e4 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004746:	4601                	li	a2,0
    80004748:	fb040593          	addi	a1,s0,-80
    8000474c:	8526                	mv	a0,s1
    8000474e:	de3fe0ef          	jal	ra,80003530 <dirlookup>
    80004752:	8aaa                	mv	s5,a0
    80004754:	c521                	beqz	a0,8000479c <create+0x82>
    iunlockput(dp);
    80004756:	8526                	mv	a0,s1
    80004758:	b93fe0ef          	jal	ra,800032ea <iunlockput>
    ilock(ip);
    8000475c:	8556                	mv	a0,s5
    8000475e:	987fe0ef          	jal	ra,800030e4 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004762:	000b059b          	sext.w	a1,s6
    80004766:	4789                	li	a5,2
    80004768:	02f59563          	bne	a1,a5,80004792 <create+0x78>
    8000476c:	044ad783          	lhu	a5,68(s5) # fffffffffffff044 <end+0xffffffff7ffde3e4>
    80004770:	37f9                	addiw	a5,a5,-2
    80004772:	17c2                	slli	a5,a5,0x30
    80004774:	93c1                	srli	a5,a5,0x30
    80004776:	4705                	li	a4,1
    80004778:	00f76d63          	bltu	a4,a5,80004792 <create+0x78>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    8000477c:	8556                	mv	a0,s5
    8000477e:	60a6                	ld	ra,72(sp)
    80004780:	6406                	ld	s0,64(sp)
    80004782:	74e2                	ld	s1,56(sp)
    80004784:	7942                	ld	s2,48(sp)
    80004786:	79a2                	ld	s3,40(sp)
    80004788:	7a02                	ld	s4,32(sp)
    8000478a:	6ae2                	ld	s5,24(sp)
    8000478c:	6b42                	ld	s6,16(sp)
    8000478e:	6161                	addi	sp,sp,80
    80004790:	8082                	ret
    iunlockput(ip);
    80004792:	8556                	mv	a0,s5
    80004794:	b57fe0ef          	jal	ra,800032ea <iunlockput>
    return 0;
    80004798:	4a81                	li	s5,0
    8000479a:	b7cd                	j	8000477c <create+0x62>
  if((ip = ialloc(dp->dev, type)) == 0){
    8000479c:	85da                	mv	a1,s6
    8000479e:	4088                	lw	a0,0(s1)
    800047a0:	fdafe0ef          	jal	ra,80002f7a <ialloc>
    800047a4:	8a2a                	mv	s4,a0
    800047a6:	cd1d                	beqz	a0,800047e4 <create+0xca>
  ilock(ip);
    800047a8:	93dfe0ef          	jal	ra,800030e4 <ilock>
  ip->major = major;
    800047ac:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    800047b0:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    800047b4:	4905                	li	s2,1
    800047b6:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    800047ba:	8552                	mv	a0,s4
    800047bc:	875fe0ef          	jal	ra,80003030 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800047c0:	000b059b          	sext.w	a1,s6
    800047c4:	03258563          	beq	a1,s2,800047ee <create+0xd4>
  if(dirlink(dp, name, ip->inum) < 0)
    800047c8:	004a2603          	lw	a2,4(s4)
    800047cc:	fb040593          	addi	a1,s0,-80
    800047d0:	8526                	mv	a0,s1
    800047d2:	f31fe0ef          	jal	ra,80003702 <dirlink>
    800047d6:	06054363          	bltz	a0,8000483c <create+0x122>
  iunlockput(dp);
    800047da:	8526                	mv	a0,s1
    800047dc:	b0ffe0ef          	jal	ra,800032ea <iunlockput>
  return ip;
    800047e0:	8ad2                	mv	s5,s4
    800047e2:	bf69                	j	8000477c <create+0x62>
    iunlockput(dp);
    800047e4:	8526                	mv	a0,s1
    800047e6:	b05fe0ef          	jal	ra,800032ea <iunlockput>
    return 0;
    800047ea:	8ad2                	mv	s5,s4
    800047ec:	bf41                	j	8000477c <create+0x62>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800047ee:	004a2603          	lw	a2,4(s4)
    800047f2:	00003597          	auipc	a1,0x3
    800047f6:	f3e58593          	addi	a1,a1,-194 # 80007730 <syscalls+0x2a0>
    800047fa:	8552                	mv	a0,s4
    800047fc:	f07fe0ef          	jal	ra,80003702 <dirlink>
    80004800:	02054e63          	bltz	a0,8000483c <create+0x122>
    80004804:	40d0                	lw	a2,4(s1)
    80004806:	00003597          	auipc	a1,0x3
    8000480a:	f3258593          	addi	a1,a1,-206 # 80007738 <syscalls+0x2a8>
    8000480e:	8552                	mv	a0,s4
    80004810:	ef3fe0ef          	jal	ra,80003702 <dirlink>
    80004814:	02054463          	bltz	a0,8000483c <create+0x122>
  if(dirlink(dp, name, ip->inum) < 0)
    80004818:	004a2603          	lw	a2,4(s4)
    8000481c:	fb040593          	addi	a1,s0,-80
    80004820:	8526                	mv	a0,s1
    80004822:	ee1fe0ef          	jal	ra,80003702 <dirlink>
    80004826:	00054b63          	bltz	a0,8000483c <create+0x122>
    dp->nlink++;  // for ".."
    8000482a:	04a4d783          	lhu	a5,74(s1)
    8000482e:	2785                	addiw	a5,a5,1
    80004830:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004834:	8526                	mv	a0,s1
    80004836:	ffafe0ef          	jal	ra,80003030 <iupdate>
    8000483a:	b745                	j	800047da <create+0xc0>
  ip->nlink = 0;
    8000483c:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80004840:	8552                	mv	a0,s4
    80004842:	feefe0ef          	jal	ra,80003030 <iupdate>
  iunlockput(ip);
    80004846:	8552                	mv	a0,s4
    80004848:	aa3fe0ef          	jal	ra,800032ea <iunlockput>
  iunlockput(dp);
    8000484c:	8526                	mv	a0,s1
    8000484e:	a9dfe0ef          	jal	ra,800032ea <iunlockput>
  return 0;
    80004852:	b72d                	j	8000477c <create+0x62>
    return 0;
    80004854:	8aaa                	mv	s5,a0
    80004856:	b71d                	j	8000477c <create+0x62>

0000000080004858 <sys_dup>:
{
    80004858:	7179                	addi	sp,sp,-48
    8000485a:	f406                	sd	ra,40(sp)
    8000485c:	f022                	sd	s0,32(sp)
    8000485e:	ec26                	sd	s1,24(sp)
    80004860:	e84a                	sd	s2,16(sp)
    80004862:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004864:	fd840613          	addi	a2,s0,-40
    80004868:	4581                	li	a1,0
    8000486a:	4501                	li	a0,0
    8000486c:	e19ff0ef          	jal	ra,80004684 <argfd>
    return -1;
    80004870:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004872:	00054f63          	bltz	a0,80004890 <sys_dup+0x38>
  if((fd=fdalloc(f)) < 0)
    80004876:	fd843903          	ld	s2,-40(s0)
    8000487a:	854a                	mv	a0,s2
    8000487c:	e61ff0ef          	jal	ra,800046dc <fdalloc>
    80004880:	84aa                	mv	s1,a0
    return -1;
    80004882:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004884:	00054663          	bltz	a0,80004890 <sys_dup+0x38>
  filedup(f);
    80004888:	854a                	mv	a0,s2
    8000488a:	cc0ff0ef          	jal	ra,80003d4a <filedup>
  return fd;
    8000488e:	87a6                	mv	a5,s1
}
    80004890:	853e                	mv	a0,a5
    80004892:	70a2                	ld	ra,40(sp)
    80004894:	7402                	ld	s0,32(sp)
    80004896:	64e2                	ld	s1,24(sp)
    80004898:	6942                	ld	s2,16(sp)
    8000489a:	6145                	addi	sp,sp,48
    8000489c:	8082                	ret

000000008000489e <sys_read>:
{
    8000489e:	7179                	addi	sp,sp,-48
    800048a0:	f406                	sd	ra,40(sp)
    800048a2:	f022                	sd	s0,32(sp)
    800048a4:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800048a6:	fd840593          	addi	a1,s0,-40
    800048aa:	4505                	li	a0,1
    800048ac:	e49fd0ef          	jal	ra,800026f4 <argaddr>
  argint(2, &n);
    800048b0:	fe440593          	addi	a1,s0,-28
    800048b4:	4509                	li	a0,2
    800048b6:	e23fd0ef          	jal	ra,800026d8 <argint>
  if(argfd(0, 0, &f) < 0)
    800048ba:	fe840613          	addi	a2,s0,-24
    800048be:	4581                	li	a1,0
    800048c0:	4501                	li	a0,0
    800048c2:	dc3ff0ef          	jal	ra,80004684 <argfd>
    800048c6:	87aa                	mv	a5,a0
    return -1;
    800048c8:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800048ca:	0007ca63          	bltz	a5,800048de <sys_read+0x40>
  return fileread(f, p, n);
    800048ce:	fe442603          	lw	a2,-28(s0)
    800048d2:	fd843583          	ld	a1,-40(s0)
    800048d6:	fe843503          	ld	a0,-24(s0)
    800048da:	dbcff0ef          	jal	ra,80003e96 <fileread>
}
    800048de:	70a2                	ld	ra,40(sp)
    800048e0:	7402                	ld	s0,32(sp)
    800048e2:	6145                	addi	sp,sp,48
    800048e4:	8082                	ret

00000000800048e6 <sys_write>:
{
    800048e6:	7179                	addi	sp,sp,-48
    800048e8:	f406                	sd	ra,40(sp)
    800048ea:	f022                	sd	s0,32(sp)
    800048ec:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800048ee:	fd840593          	addi	a1,s0,-40
    800048f2:	4505                	li	a0,1
    800048f4:	e01fd0ef          	jal	ra,800026f4 <argaddr>
  argint(2, &n);
    800048f8:	fe440593          	addi	a1,s0,-28
    800048fc:	4509                	li	a0,2
    800048fe:	ddbfd0ef          	jal	ra,800026d8 <argint>
  if(argfd(0, 0, &f) < 0)
    80004902:	fe840613          	addi	a2,s0,-24
    80004906:	4581                	li	a1,0
    80004908:	4501                	li	a0,0
    8000490a:	d7bff0ef          	jal	ra,80004684 <argfd>
    8000490e:	87aa                	mv	a5,a0
    return -1;
    80004910:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004912:	0007ca63          	bltz	a5,80004926 <sys_write+0x40>
  return filewrite(f, p, n);
    80004916:	fe442603          	lw	a2,-28(s0)
    8000491a:	fd843583          	ld	a1,-40(s0)
    8000491e:	fe843503          	ld	a0,-24(s0)
    80004922:	e22ff0ef          	jal	ra,80003f44 <filewrite>
}
    80004926:	70a2                	ld	ra,40(sp)
    80004928:	7402                	ld	s0,32(sp)
    8000492a:	6145                	addi	sp,sp,48
    8000492c:	8082                	ret

000000008000492e <sys_close>:
{
    8000492e:	1101                	addi	sp,sp,-32
    80004930:	ec06                	sd	ra,24(sp)
    80004932:	e822                	sd	s0,16(sp)
    80004934:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004936:	fe040613          	addi	a2,s0,-32
    8000493a:	fec40593          	addi	a1,s0,-20
    8000493e:	4501                	li	a0,0
    80004940:	d45ff0ef          	jal	ra,80004684 <argfd>
    return -1;
    80004944:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004946:	02054063          	bltz	a0,80004966 <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    8000494a:	ee1fc0ef          	jal	ra,8000182a <myproc>
    8000494e:	fec42783          	lw	a5,-20(s0)
    80004952:	07e9                	addi	a5,a5,26
    80004954:	078e                	slli	a5,a5,0x3
    80004956:	953e                	add	a0,a0,a5
    80004958:	00053023          	sd	zero,0(a0)
  fileclose(f);
    8000495c:	fe043503          	ld	a0,-32(s0)
    80004960:	c30ff0ef          	jal	ra,80003d90 <fileclose>
  return 0;
    80004964:	4781                	li	a5,0
}
    80004966:	853e                	mv	a0,a5
    80004968:	60e2                	ld	ra,24(sp)
    8000496a:	6442                	ld	s0,16(sp)
    8000496c:	6105                	addi	sp,sp,32
    8000496e:	8082                	ret

0000000080004970 <sys_fstat>:
{
    80004970:	1101                	addi	sp,sp,-32
    80004972:	ec06                	sd	ra,24(sp)
    80004974:	e822                	sd	s0,16(sp)
    80004976:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004978:	fe040593          	addi	a1,s0,-32
    8000497c:	4505                	li	a0,1
    8000497e:	d77fd0ef          	jal	ra,800026f4 <argaddr>
  if(argfd(0, 0, &f) < 0)
    80004982:	fe840613          	addi	a2,s0,-24
    80004986:	4581                	li	a1,0
    80004988:	4501                	li	a0,0
    8000498a:	cfbff0ef          	jal	ra,80004684 <argfd>
    8000498e:	87aa                	mv	a5,a0
    return -1;
    80004990:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004992:	0007c863          	bltz	a5,800049a2 <sys_fstat+0x32>
  return filestat(f, st);
    80004996:	fe043583          	ld	a1,-32(s0)
    8000499a:	fe843503          	ld	a0,-24(s0)
    8000499e:	c9aff0ef          	jal	ra,80003e38 <filestat>
}
    800049a2:	60e2                	ld	ra,24(sp)
    800049a4:	6442                	ld	s0,16(sp)
    800049a6:	6105                	addi	sp,sp,32
    800049a8:	8082                	ret

00000000800049aa <sys_link>:
{
    800049aa:	7169                	addi	sp,sp,-304
    800049ac:	f606                	sd	ra,296(sp)
    800049ae:	f222                	sd	s0,288(sp)
    800049b0:	ee26                	sd	s1,280(sp)
    800049b2:	ea4a                	sd	s2,272(sp)
    800049b4:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800049b6:	08000613          	li	a2,128
    800049ba:	ed040593          	addi	a1,s0,-304
    800049be:	4501                	li	a0,0
    800049c0:	d51fd0ef          	jal	ra,80002710 <argstr>
    return -1;
    800049c4:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800049c6:	0c054663          	bltz	a0,80004a92 <sys_link+0xe8>
    800049ca:	08000613          	li	a2,128
    800049ce:	f5040593          	addi	a1,s0,-176
    800049d2:	4505                	li	a0,1
    800049d4:	d3dfd0ef          	jal	ra,80002710 <argstr>
    return -1;
    800049d8:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800049da:	0a054c63          	bltz	a0,80004a92 <sys_link+0xe8>
  begin_op();
    800049de:	f9bfe0ef          	jal	ra,80003978 <begin_op>
  if((ip = namei(old)) == 0){
    800049e2:	ed040513          	addi	a0,s0,-304
    800049e6:	db7fe0ef          	jal	ra,8000379c <namei>
    800049ea:	84aa                	mv	s1,a0
    800049ec:	c525                	beqz	a0,80004a54 <sys_link+0xaa>
  ilock(ip);
    800049ee:	ef6fe0ef          	jal	ra,800030e4 <ilock>
  if(ip->type == T_DIR){
    800049f2:	04449703          	lh	a4,68(s1)
    800049f6:	4785                	li	a5,1
    800049f8:	06f70263          	beq	a4,a5,80004a5c <sys_link+0xb2>
  ip->nlink++;
    800049fc:	04a4d783          	lhu	a5,74(s1)
    80004a00:	2785                	addiw	a5,a5,1
    80004a02:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004a06:	8526                	mv	a0,s1
    80004a08:	e28fe0ef          	jal	ra,80003030 <iupdate>
  iunlock(ip);
    80004a0c:	8526                	mv	a0,s1
    80004a0e:	f80fe0ef          	jal	ra,8000318e <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004a12:	fd040593          	addi	a1,s0,-48
    80004a16:	f5040513          	addi	a0,s0,-176
    80004a1a:	d9dfe0ef          	jal	ra,800037b6 <nameiparent>
    80004a1e:	892a                	mv	s2,a0
    80004a20:	c921                	beqz	a0,80004a70 <sys_link+0xc6>
  ilock(dp);
    80004a22:	ec2fe0ef          	jal	ra,800030e4 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004a26:	00092703          	lw	a4,0(s2)
    80004a2a:	409c                	lw	a5,0(s1)
    80004a2c:	02f71f63          	bne	a4,a5,80004a6a <sys_link+0xc0>
    80004a30:	40d0                	lw	a2,4(s1)
    80004a32:	fd040593          	addi	a1,s0,-48
    80004a36:	854a                	mv	a0,s2
    80004a38:	ccbfe0ef          	jal	ra,80003702 <dirlink>
    80004a3c:	02054763          	bltz	a0,80004a6a <sys_link+0xc0>
  iunlockput(dp);
    80004a40:	854a                	mv	a0,s2
    80004a42:	8a9fe0ef          	jal	ra,800032ea <iunlockput>
  iput(ip);
    80004a46:	8526                	mv	a0,s1
    80004a48:	81bfe0ef          	jal	ra,80003262 <iput>
  end_op();
    80004a4c:	f9bfe0ef          	jal	ra,800039e6 <end_op>
  return 0;
    80004a50:	4781                	li	a5,0
    80004a52:	a081                	j	80004a92 <sys_link+0xe8>
    end_op();
    80004a54:	f93fe0ef          	jal	ra,800039e6 <end_op>
    return -1;
    80004a58:	57fd                	li	a5,-1
    80004a5a:	a825                	j	80004a92 <sys_link+0xe8>
    iunlockput(ip);
    80004a5c:	8526                	mv	a0,s1
    80004a5e:	88dfe0ef          	jal	ra,800032ea <iunlockput>
    end_op();
    80004a62:	f85fe0ef          	jal	ra,800039e6 <end_op>
    return -1;
    80004a66:	57fd                	li	a5,-1
    80004a68:	a02d                	j	80004a92 <sys_link+0xe8>
    iunlockput(dp);
    80004a6a:	854a                	mv	a0,s2
    80004a6c:	87ffe0ef          	jal	ra,800032ea <iunlockput>
  ilock(ip);
    80004a70:	8526                	mv	a0,s1
    80004a72:	e72fe0ef          	jal	ra,800030e4 <ilock>
  ip->nlink--;
    80004a76:	04a4d783          	lhu	a5,74(s1)
    80004a7a:	37fd                	addiw	a5,a5,-1
    80004a7c:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004a80:	8526                	mv	a0,s1
    80004a82:	daefe0ef          	jal	ra,80003030 <iupdate>
  iunlockput(ip);
    80004a86:	8526                	mv	a0,s1
    80004a88:	863fe0ef          	jal	ra,800032ea <iunlockput>
  end_op();
    80004a8c:	f5bfe0ef          	jal	ra,800039e6 <end_op>
  return -1;
    80004a90:	57fd                	li	a5,-1
}
    80004a92:	853e                	mv	a0,a5
    80004a94:	70b2                	ld	ra,296(sp)
    80004a96:	7412                	ld	s0,288(sp)
    80004a98:	64f2                	ld	s1,280(sp)
    80004a9a:	6952                	ld	s2,272(sp)
    80004a9c:	6155                	addi	sp,sp,304
    80004a9e:	8082                	ret

0000000080004aa0 <sys_unlink>:
{
    80004aa0:	7151                	addi	sp,sp,-240
    80004aa2:	f586                	sd	ra,232(sp)
    80004aa4:	f1a2                	sd	s0,224(sp)
    80004aa6:	eda6                	sd	s1,216(sp)
    80004aa8:	e9ca                	sd	s2,208(sp)
    80004aaa:	e5ce                	sd	s3,200(sp)
    80004aac:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004aae:	08000613          	li	a2,128
    80004ab2:	f3040593          	addi	a1,s0,-208
    80004ab6:	4501                	li	a0,0
    80004ab8:	c59fd0ef          	jal	ra,80002710 <argstr>
    80004abc:	12054b63          	bltz	a0,80004bf2 <sys_unlink+0x152>
  begin_op();
    80004ac0:	eb9fe0ef          	jal	ra,80003978 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004ac4:	fb040593          	addi	a1,s0,-80
    80004ac8:	f3040513          	addi	a0,s0,-208
    80004acc:	cebfe0ef          	jal	ra,800037b6 <nameiparent>
    80004ad0:	84aa                	mv	s1,a0
    80004ad2:	c54d                	beqz	a0,80004b7c <sys_unlink+0xdc>
  ilock(dp);
    80004ad4:	e10fe0ef          	jal	ra,800030e4 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004ad8:	00003597          	auipc	a1,0x3
    80004adc:	c5858593          	addi	a1,a1,-936 # 80007730 <syscalls+0x2a0>
    80004ae0:	fb040513          	addi	a0,s0,-80
    80004ae4:	a37fe0ef          	jal	ra,8000351a <namecmp>
    80004ae8:	10050a63          	beqz	a0,80004bfc <sys_unlink+0x15c>
    80004aec:	00003597          	auipc	a1,0x3
    80004af0:	c4c58593          	addi	a1,a1,-948 # 80007738 <syscalls+0x2a8>
    80004af4:	fb040513          	addi	a0,s0,-80
    80004af8:	a23fe0ef          	jal	ra,8000351a <namecmp>
    80004afc:	10050063          	beqz	a0,80004bfc <sys_unlink+0x15c>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004b00:	f2c40613          	addi	a2,s0,-212
    80004b04:	fb040593          	addi	a1,s0,-80
    80004b08:	8526                	mv	a0,s1
    80004b0a:	a27fe0ef          	jal	ra,80003530 <dirlookup>
    80004b0e:	892a                	mv	s2,a0
    80004b10:	0e050663          	beqz	a0,80004bfc <sys_unlink+0x15c>
  ilock(ip);
    80004b14:	dd0fe0ef          	jal	ra,800030e4 <ilock>
  if(ip->nlink < 1)
    80004b18:	04a91783          	lh	a5,74(s2)
    80004b1c:	06f05463          	blez	a5,80004b84 <sys_unlink+0xe4>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004b20:	04491703          	lh	a4,68(s2)
    80004b24:	4785                	li	a5,1
    80004b26:	06f70563          	beq	a4,a5,80004b90 <sys_unlink+0xf0>
  memset(&de, 0, sizeof(de));
    80004b2a:	4641                	li	a2,16
    80004b2c:	4581                	li	a1,0
    80004b2e:	fc040513          	addi	a0,s0,-64
    80004b32:	93afc0ef          	jal	ra,80000c6c <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004b36:	4741                	li	a4,16
    80004b38:	f2c42683          	lw	a3,-212(s0)
    80004b3c:	fc040613          	addi	a2,s0,-64
    80004b40:	4581                	li	a1,0
    80004b42:	8526                	mv	a0,s1
    80004b44:	8d5fe0ef          	jal	ra,80003418 <writei>
    80004b48:	47c1                	li	a5,16
    80004b4a:	08f51563          	bne	a0,a5,80004bd4 <sys_unlink+0x134>
  if(ip->type == T_DIR){
    80004b4e:	04491703          	lh	a4,68(s2)
    80004b52:	4785                	li	a5,1
    80004b54:	08f70663          	beq	a4,a5,80004be0 <sys_unlink+0x140>
  iunlockput(dp);
    80004b58:	8526                	mv	a0,s1
    80004b5a:	f90fe0ef          	jal	ra,800032ea <iunlockput>
  ip->nlink--;
    80004b5e:	04a95783          	lhu	a5,74(s2)
    80004b62:	37fd                	addiw	a5,a5,-1
    80004b64:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004b68:	854a                	mv	a0,s2
    80004b6a:	cc6fe0ef          	jal	ra,80003030 <iupdate>
  iunlockput(ip);
    80004b6e:	854a                	mv	a0,s2
    80004b70:	f7afe0ef          	jal	ra,800032ea <iunlockput>
  end_op();
    80004b74:	e73fe0ef          	jal	ra,800039e6 <end_op>
  return 0;
    80004b78:	4501                	li	a0,0
    80004b7a:	a079                	j	80004c08 <sys_unlink+0x168>
    end_op();
    80004b7c:	e6bfe0ef          	jal	ra,800039e6 <end_op>
    return -1;
    80004b80:	557d                	li	a0,-1
    80004b82:	a059                	j	80004c08 <sys_unlink+0x168>
    panic("unlink: nlink < 1");
    80004b84:	00003517          	auipc	a0,0x3
    80004b88:	bbc50513          	addi	a0,a0,-1092 # 80007740 <syscalls+0x2b0>
    80004b8c:	bcbfb0ef          	jal	ra,80000756 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004b90:	04c92703          	lw	a4,76(s2)
    80004b94:	02000793          	li	a5,32
    80004b98:	f8e7f9e3          	bgeu	a5,a4,80004b2a <sys_unlink+0x8a>
    80004b9c:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004ba0:	4741                	li	a4,16
    80004ba2:	86ce                	mv	a3,s3
    80004ba4:	f1840613          	addi	a2,s0,-232
    80004ba8:	4581                	li	a1,0
    80004baa:	854a                	mv	a0,s2
    80004bac:	f88fe0ef          	jal	ra,80003334 <readi>
    80004bb0:	47c1                	li	a5,16
    80004bb2:	00f51b63          	bne	a0,a5,80004bc8 <sys_unlink+0x128>
    if(de.inum != 0)
    80004bb6:	f1845783          	lhu	a5,-232(s0)
    80004bba:	ef95                	bnez	a5,80004bf6 <sys_unlink+0x156>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004bbc:	29c1                	addiw	s3,s3,16
    80004bbe:	04c92783          	lw	a5,76(s2)
    80004bc2:	fcf9efe3          	bltu	s3,a5,80004ba0 <sys_unlink+0x100>
    80004bc6:	b795                	j	80004b2a <sys_unlink+0x8a>
      panic("isdirempty: readi");
    80004bc8:	00003517          	auipc	a0,0x3
    80004bcc:	b9050513          	addi	a0,a0,-1136 # 80007758 <syscalls+0x2c8>
    80004bd0:	b87fb0ef          	jal	ra,80000756 <panic>
    panic("unlink: writei");
    80004bd4:	00003517          	auipc	a0,0x3
    80004bd8:	b9c50513          	addi	a0,a0,-1124 # 80007770 <syscalls+0x2e0>
    80004bdc:	b7bfb0ef          	jal	ra,80000756 <panic>
    dp->nlink--;
    80004be0:	04a4d783          	lhu	a5,74(s1)
    80004be4:	37fd                	addiw	a5,a5,-1
    80004be6:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004bea:	8526                	mv	a0,s1
    80004bec:	c44fe0ef          	jal	ra,80003030 <iupdate>
    80004bf0:	b7a5                	j	80004b58 <sys_unlink+0xb8>
    return -1;
    80004bf2:	557d                	li	a0,-1
    80004bf4:	a811                	j	80004c08 <sys_unlink+0x168>
    iunlockput(ip);
    80004bf6:	854a                	mv	a0,s2
    80004bf8:	ef2fe0ef          	jal	ra,800032ea <iunlockput>
  iunlockput(dp);
    80004bfc:	8526                	mv	a0,s1
    80004bfe:	eecfe0ef          	jal	ra,800032ea <iunlockput>
  end_op();
    80004c02:	de5fe0ef          	jal	ra,800039e6 <end_op>
  return -1;
    80004c06:	557d                	li	a0,-1
}
    80004c08:	70ae                	ld	ra,232(sp)
    80004c0a:	740e                	ld	s0,224(sp)
    80004c0c:	64ee                	ld	s1,216(sp)
    80004c0e:	694e                	ld	s2,208(sp)
    80004c10:	69ae                	ld	s3,200(sp)
    80004c12:	616d                	addi	sp,sp,240
    80004c14:	8082                	ret

0000000080004c16 <sys_open>:

uint64
sys_open(void)
{
    80004c16:	7131                	addi	sp,sp,-192
    80004c18:	fd06                	sd	ra,184(sp)
    80004c1a:	f922                	sd	s0,176(sp)
    80004c1c:	f526                	sd	s1,168(sp)
    80004c1e:	f14a                	sd	s2,160(sp)
    80004c20:	ed4e                	sd	s3,152(sp)
    80004c22:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004c24:	f4c40593          	addi	a1,s0,-180
    80004c28:	4505                	li	a0,1
    80004c2a:	aaffd0ef          	jal	ra,800026d8 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004c2e:	08000613          	li	a2,128
    80004c32:	f5040593          	addi	a1,s0,-176
    80004c36:	4501                	li	a0,0
    80004c38:	ad9fd0ef          	jal	ra,80002710 <argstr>
    80004c3c:	87aa                	mv	a5,a0
    return -1;
    80004c3e:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004c40:	0807cd63          	bltz	a5,80004cda <sys_open+0xc4>

  begin_op();
    80004c44:	d35fe0ef          	jal	ra,80003978 <begin_op>

  if(omode & O_CREATE){
    80004c48:	f4c42783          	lw	a5,-180(s0)
    80004c4c:	2007f793          	andi	a5,a5,512
    80004c50:	c3c5                	beqz	a5,80004cf0 <sys_open+0xda>
    ip = create(path, T_FILE, 0, 0);
    80004c52:	4681                	li	a3,0
    80004c54:	4601                	li	a2,0
    80004c56:	4589                	li	a1,2
    80004c58:	f5040513          	addi	a0,s0,-176
    80004c5c:	abfff0ef          	jal	ra,8000471a <create>
    80004c60:	84aa                	mv	s1,a0
    if(ip == 0){
    80004c62:	c159                	beqz	a0,80004ce8 <sys_open+0xd2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004c64:	04449703          	lh	a4,68(s1)
    80004c68:	478d                	li	a5,3
    80004c6a:	00f71763          	bne	a4,a5,80004c78 <sys_open+0x62>
    80004c6e:	0464d703          	lhu	a4,70(s1)
    80004c72:	47a5                	li	a5,9
    80004c74:	0ae7e963          	bltu	a5,a4,80004d26 <sys_open+0x110>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004c78:	874ff0ef          	jal	ra,80003cec <filealloc>
    80004c7c:	89aa                	mv	s3,a0
    80004c7e:	0c050963          	beqz	a0,80004d50 <sys_open+0x13a>
    80004c82:	a5bff0ef          	jal	ra,800046dc <fdalloc>
    80004c86:	892a                	mv	s2,a0
    80004c88:	0c054163          	bltz	a0,80004d4a <sys_open+0x134>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004c8c:	04449703          	lh	a4,68(s1)
    80004c90:	478d                	li	a5,3
    80004c92:	0af70163          	beq	a4,a5,80004d34 <sys_open+0x11e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004c96:	4789                	li	a5,2
    80004c98:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004c9c:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004ca0:	0099bc23          	sd	s1,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004ca4:	f4c42783          	lw	a5,-180(s0)
    80004ca8:	0017c713          	xori	a4,a5,1
    80004cac:	8b05                	andi	a4,a4,1
    80004cae:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004cb2:	0037f713          	andi	a4,a5,3
    80004cb6:	00e03733          	snez	a4,a4
    80004cba:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004cbe:	4007f793          	andi	a5,a5,1024
    80004cc2:	c791                	beqz	a5,80004cce <sys_open+0xb8>
    80004cc4:	04449703          	lh	a4,68(s1)
    80004cc8:	4789                	li	a5,2
    80004cca:	06f70c63          	beq	a4,a5,80004d42 <sys_open+0x12c>
    itrunc(ip);
  }

  iunlock(ip);
    80004cce:	8526                	mv	a0,s1
    80004cd0:	cbefe0ef          	jal	ra,8000318e <iunlock>
  end_op();
    80004cd4:	d13fe0ef          	jal	ra,800039e6 <end_op>

  return fd;
    80004cd8:	854a                	mv	a0,s2
}
    80004cda:	70ea                	ld	ra,184(sp)
    80004cdc:	744a                	ld	s0,176(sp)
    80004cde:	74aa                	ld	s1,168(sp)
    80004ce0:	790a                	ld	s2,160(sp)
    80004ce2:	69ea                	ld	s3,152(sp)
    80004ce4:	6129                	addi	sp,sp,192
    80004ce6:	8082                	ret
      end_op();
    80004ce8:	cfffe0ef          	jal	ra,800039e6 <end_op>
      return -1;
    80004cec:	557d                	li	a0,-1
    80004cee:	b7f5                	j	80004cda <sys_open+0xc4>
    if((ip = namei(path)) == 0){
    80004cf0:	f5040513          	addi	a0,s0,-176
    80004cf4:	aa9fe0ef          	jal	ra,8000379c <namei>
    80004cf8:	84aa                	mv	s1,a0
    80004cfa:	c115                	beqz	a0,80004d1e <sys_open+0x108>
    ilock(ip);
    80004cfc:	be8fe0ef          	jal	ra,800030e4 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004d00:	04449703          	lh	a4,68(s1)
    80004d04:	4785                	li	a5,1
    80004d06:	f4f71fe3          	bne	a4,a5,80004c64 <sys_open+0x4e>
    80004d0a:	f4c42783          	lw	a5,-180(s0)
    80004d0e:	d7ad                	beqz	a5,80004c78 <sys_open+0x62>
      iunlockput(ip);
    80004d10:	8526                	mv	a0,s1
    80004d12:	dd8fe0ef          	jal	ra,800032ea <iunlockput>
      end_op();
    80004d16:	cd1fe0ef          	jal	ra,800039e6 <end_op>
      return -1;
    80004d1a:	557d                	li	a0,-1
    80004d1c:	bf7d                	j	80004cda <sys_open+0xc4>
      end_op();
    80004d1e:	cc9fe0ef          	jal	ra,800039e6 <end_op>
      return -1;
    80004d22:	557d                	li	a0,-1
    80004d24:	bf5d                	j	80004cda <sys_open+0xc4>
    iunlockput(ip);
    80004d26:	8526                	mv	a0,s1
    80004d28:	dc2fe0ef          	jal	ra,800032ea <iunlockput>
    end_op();
    80004d2c:	cbbfe0ef          	jal	ra,800039e6 <end_op>
    return -1;
    80004d30:	557d                	li	a0,-1
    80004d32:	b765                	j	80004cda <sys_open+0xc4>
    f->type = FD_DEVICE;
    80004d34:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004d38:	04649783          	lh	a5,70(s1)
    80004d3c:	02f99223          	sh	a5,36(s3)
    80004d40:	b785                	j	80004ca0 <sys_open+0x8a>
    itrunc(ip);
    80004d42:	8526                	mv	a0,s1
    80004d44:	c8afe0ef          	jal	ra,800031ce <itrunc>
    80004d48:	b759                	j	80004cce <sys_open+0xb8>
      fileclose(f);
    80004d4a:	854e                	mv	a0,s3
    80004d4c:	844ff0ef          	jal	ra,80003d90 <fileclose>
    iunlockput(ip);
    80004d50:	8526                	mv	a0,s1
    80004d52:	d98fe0ef          	jal	ra,800032ea <iunlockput>
    end_op();
    80004d56:	c91fe0ef          	jal	ra,800039e6 <end_op>
    return -1;
    80004d5a:	557d                	li	a0,-1
    80004d5c:	bfbd                	j	80004cda <sys_open+0xc4>

0000000080004d5e <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004d5e:	7175                	addi	sp,sp,-144
    80004d60:	e506                	sd	ra,136(sp)
    80004d62:	e122                	sd	s0,128(sp)
    80004d64:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004d66:	c13fe0ef          	jal	ra,80003978 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004d6a:	08000613          	li	a2,128
    80004d6e:	f7040593          	addi	a1,s0,-144
    80004d72:	4501                	li	a0,0
    80004d74:	99dfd0ef          	jal	ra,80002710 <argstr>
    80004d78:	02054363          	bltz	a0,80004d9e <sys_mkdir+0x40>
    80004d7c:	4681                	li	a3,0
    80004d7e:	4601                	li	a2,0
    80004d80:	4585                	li	a1,1
    80004d82:	f7040513          	addi	a0,s0,-144
    80004d86:	995ff0ef          	jal	ra,8000471a <create>
    80004d8a:	c911                	beqz	a0,80004d9e <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004d8c:	d5efe0ef          	jal	ra,800032ea <iunlockput>
  end_op();
    80004d90:	c57fe0ef          	jal	ra,800039e6 <end_op>
  return 0;
    80004d94:	4501                	li	a0,0
}
    80004d96:	60aa                	ld	ra,136(sp)
    80004d98:	640a                	ld	s0,128(sp)
    80004d9a:	6149                	addi	sp,sp,144
    80004d9c:	8082                	ret
    end_op();
    80004d9e:	c49fe0ef          	jal	ra,800039e6 <end_op>
    return -1;
    80004da2:	557d                	li	a0,-1
    80004da4:	bfcd                	j	80004d96 <sys_mkdir+0x38>

0000000080004da6 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004da6:	7135                	addi	sp,sp,-160
    80004da8:	ed06                	sd	ra,152(sp)
    80004daa:	e922                	sd	s0,144(sp)
    80004dac:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004dae:	bcbfe0ef          	jal	ra,80003978 <begin_op>
  argint(1, &major);
    80004db2:	f6c40593          	addi	a1,s0,-148
    80004db6:	4505                	li	a0,1
    80004db8:	921fd0ef          	jal	ra,800026d8 <argint>
  argint(2, &minor);
    80004dbc:	f6840593          	addi	a1,s0,-152
    80004dc0:	4509                	li	a0,2
    80004dc2:	917fd0ef          	jal	ra,800026d8 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004dc6:	08000613          	li	a2,128
    80004dca:	f7040593          	addi	a1,s0,-144
    80004dce:	4501                	li	a0,0
    80004dd0:	941fd0ef          	jal	ra,80002710 <argstr>
    80004dd4:	02054563          	bltz	a0,80004dfe <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004dd8:	f6841683          	lh	a3,-152(s0)
    80004ddc:	f6c41603          	lh	a2,-148(s0)
    80004de0:	458d                	li	a1,3
    80004de2:	f7040513          	addi	a0,s0,-144
    80004de6:	935ff0ef          	jal	ra,8000471a <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004dea:	c911                	beqz	a0,80004dfe <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004dec:	cfefe0ef          	jal	ra,800032ea <iunlockput>
  end_op();
    80004df0:	bf7fe0ef          	jal	ra,800039e6 <end_op>
  return 0;
    80004df4:	4501                	li	a0,0
}
    80004df6:	60ea                	ld	ra,152(sp)
    80004df8:	644a                	ld	s0,144(sp)
    80004dfa:	610d                	addi	sp,sp,160
    80004dfc:	8082                	ret
    end_op();
    80004dfe:	be9fe0ef          	jal	ra,800039e6 <end_op>
    return -1;
    80004e02:	557d                	li	a0,-1
    80004e04:	bfcd                	j	80004df6 <sys_mknod+0x50>

0000000080004e06 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004e06:	7135                	addi	sp,sp,-160
    80004e08:	ed06                	sd	ra,152(sp)
    80004e0a:	e922                	sd	s0,144(sp)
    80004e0c:	e526                	sd	s1,136(sp)
    80004e0e:	e14a                	sd	s2,128(sp)
    80004e10:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004e12:	a19fc0ef          	jal	ra,8000182a <myproc>
    80004e16:	892a                	mv	s2,a0
  
  begin_op();
    80004e18:	b61fe0ef          	jal	ra,80003978 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004e1c:	08000613          	li	a2,128
    80004e20:	f6040593          	addi	a1,s0,-160
    80004e24:	4501                	li	a0,0
    80004e26:	8ebfd0ef          	jal	ra,80002710 <argstr>
    80004e2a:	04054163          	bltz	a0,80004e6c <sys_chdir+0x66>
    80004e2e:	f6040513          	addi	a0,s0,-160
    80004e32:	96bfe0ef          	jal	ra,8000379c <namei>
    80004e36:	84aa                	mv	s1,a0
    80004e38:	c915                	beqz	a0,80004e6c <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    80004e3a:	aaafe0ef          	jal	ra,800030e4 <ilock>
  if(ip->type != T_DIR){
    80004e3e:	04449703          	lh	a4,68(s1)
    80004e42:	4785                	li	a5,1
    80004e44:	02f71863          	bne	a4,a5,80004e74 <sys_chdir+0x6e>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004e48:	8526                	mv	a0,s1
    80004e4a:	b44fe0ef          	jal	ra,8000318e <iunlock>
  iput(p->cwd);
    80004e4e:	15093503          	ld	a0,336(s2)
    80004e52:	c10fe0ef          	jal	ra,80003262 <iput>
  end_op();
    80004e56:	b91fe0ef          	jal	ra,800039e6 <end_op>
  p->cwd = ip;
    80004e5a:	14993823          	sd	s1,336(s2)
  return 0;
    80004e5e:	4501                	li	a0,0
}
    80004e60:	60ea                	ld	ra,152(sp)
    80004e62:	644a                	ld	s0,144(sp)
    80004e64:	64aa                	ld	s1,136(sp)
    80004e66:	690a                	ld	s2,128(sp)
    80004e68:	610d                	addi	sp,sp,160
    80004e6a:	8082                	ret
    end_op();
    80004e6c:	b7bfe0ef          	jal	ra,800039e6 <end_op>
    return -1;
    80004e70:	557d                	li	a0,-1
    80004e72:	b7fd                	j	80004e60 <sys_chdir+0x5a>
    iunlockput(ip);
    80004e74:	8526                	mv	a0,s1
    80004e76:	c74fe0ef          	jal	ra,800032ea <iunlockput>
    end_op();
    80004e7a:	b6dfe0ef          	jal	ra,800039e6 <end_op>
    return -1;
    80004e7e:	557d                	li	a0,-1
    80004e80:	b7c5                	j	80004e60 <sys_chdir+0x5a>

0000000080004e82 <sys_exec>:

uint64
sys_exec(void)
{
    80004e82:	7145                	addi	sp,sp,-464
    80004e84:	e786                	sd	ra,456(sp)
    80004e86:	e3a2                	sd	s0,448(sp)
    80004e88:	ff26                	sd	s1,440(sp)
    80004e8a:	fb4a                	sd	s2,432(sp)
    80004e8c:	f74e                	sd	s3,424(sp)
    80004e8e:	f352                	sd	s4,416(sp)
    80004e90:	ef56                	sd	s5,408(sp)
    80004e92:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80004e94:	e3840593          	addi	a1,s0,-456
    80004e98:	4505                	li	a0,1
    80004e9a:	85bfd0ef          	jal	ra,800026f4 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80004e9e:	08000613          	li	a2,128
    80004ea2:	f4040593          	addi	a1,s0,-192
    80004ea6:	4501                	li	a0,0
    80004ea8:	869fd0ef          	jal	ra,80002710 <argstr>
    80004eac:	87aa                	mv	a5,a0
    return -1;
    80004eae:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80004eb0:	0a07c563          	bltz	a5,80004f5a <sys_exec+0xd8>
  }
  memset(argv, 0, sizeof(argv));
    80004eb4:	10000613          	li	a2,256
    80004eb8:	4581                	li	a1,0
    80004eba:	e4040513          	addi	a0,s0,-448
    80004ebe:	daffb0ef          	jal	ra,80000c6c <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004ec2:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80004ec6:	89a6                	mv	s3,s1
    80004ec8:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004eca:	02000a13          	li	s4,32
    80004ece:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004ed2:	00391513          	slli	a0,s2,0x3
    80004ed6:	e3040593          	addi	a1,s0,-464
    80004eda:	e3843783          	ld	a5,-456(s0)
    80004ede:	953e                	add	a0,a0,a5
    80004ee0:	f6efd0ef          	jal	ra,8000264e <fetchaddr>
    80004ee4:	02054663          	bltz	a0,80004f10 <sys_exec+0x8e>
      goto bad;
    }
    if(uarg == 0){
    80004ee8:	e3043783          	ld	a5,-464(s0)
    80004eec:	cf8d                	beqz	a5,80004f26 <sys_exec+0xa4>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004eee:	bdbfb0ef          	jal	ra,80000ac8 <kalloc>
    80004ef2:	85aa                	mv	a1,a0
    80004ef4:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004ef8:	cd01                	beqz	a0,80004f10 <sys_exec+0x8e>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004efa:	6605                	lui	a2,0x1
    80004efc:	e3043503          	ld	a0,-464(s0)
    80004f00:	f98fd0ef          	jal	ra,80002698 <fetchstr>
    80004f04:	00054663          	bltz	a0,80004f10 <sys_exec+0x8e>
    if(i >= NELEM(argv)){
    80004f08:	0905                	addi	s2,s2,1
    80004f0a:	09a1                	addi	s3,s3,8
    80004f0c:	fd4911e3          	bne	s2,s4,80004ece <sys_exec+0x4c>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f10:	f4040913          	addi	s2,s0,-192
    80004f14:	6088                	ld	a0,0(s1)
    80004f16:	c129                	beqz	a0,80004f58 <sys_exec+0xd6>
    kfree(argv[i]);
    80004f18:	acffb0ef          	jal	ra,800009e6 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f1c:	04a1                	addi	s1,s1,8
    80004f1e:	ff249be3          	bne	s1,s2,80004f14 <sys_exec+0x92>
  return -1;
    80004f22:	557d                	li	a0,-1
    80004f24:	a81d                	j	80004f5a <sys_exec+0xd8>
      argv[i] = 0;
    80004f26:	0a8e                	slli	s5,s5,0x3
    80004f28:	fc0a8793          	addi	a5,s5,-64
    80004f2c:	00878ab3          	add	s5,a5,s0
    80004f30:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80004f34:	e4040593          	addi	a1,s0,-448
    80004f38:	f4040513          	addi	a0,s0,-192
    80004f3c:	bf6ff0ef          	jal	ra,80004332 <exec>
    80004f40:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f42:	f4040993          	addi	s3,s0,-192
    80004f46:	6088                	ld	a0,0(s1)
    80004f48:	c511                	beqz	a0,80004f54 <sys_exec+0xd2>
    kfree(argv[i]);
    80004f4a:	a9dfb0ef          	jal	ra,800009e6 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f4e:	04a1                	addi	s1,s1,8
    80004f50:	ff349be3          	bne	s1,s3,80004f46 <sys_exec+0xc4>
  return ret;
    80004f54:	854a                	mv	a0,s2
    80004f56:	a011                	j	80004f5a <sys_exec+0xd8>
  return -1;
    80004f58:	557d                	li	a0,-1
}
    80004f5a:	60be                	ld	ra,456(sp)
    80004f5c:	641e                	ld	s0,448(sp)
    80004f5e:	74fa                	ld	s1,440(sp)
    80004f60:	795a                	ld	s2,432(sp)
    80004f62:	79ba                	ld	s3,424(sp)
    80004f64:	7a1a                	ld	s4,416(sp)
    80004f66:	6afa                	ld	s5,408(sp)
    80004f68:	6179                	addi	sp,sp,464
    80004f6a:	8082                	ret

0000000080004f6c <sys_pipe>:

uint64
sys_pipe(void)
{
    80004f6c:	7139                	addi	sp,sp,-64
    80004f6e:	fc06                	sd	ra,56(sp)
    80004f70:	f822                	sd	s0,48(sp)
    80004f72:	f426                	sd	s1,40(sp)
    80004f74:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004f76:	8b5fc0ef          	jal	ra,8000182a <myproc>
    80004f7a:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80004f7c:	fd840593          	addi	a1,s0,-40
    80004f80:	4501                	li	a0,0
    80004f82:	f72fd0ef          	jal	ra,800026f4 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80004f86:	fc840593          	addi	a1,s0,-56
    80004f8a:	fd040513          	addi	a0,s0,-48
    80004f8e:	8ceff0ef          	jal	ra,8000405c <pipealloc>
    return -1;
    80004f92:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004f94:	0a054463          	bltz	a0,8000503c <sys_pipe+0xd0>
  fd0 = -1;
    80004f98:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80004f9c:	fd043503          	ld	a0,-48(s0)
    80004fa0:	f3cff0ef          	jal	ra,800046dc <fdalloc>
    80004fa4:	fca42223          	sw	a0,-60(s0)
    80004fa8:	08054163          	bltz	a0,8000502a <sys_pipe+0xbe>
    80004fac:	fc843503          	ld	a0,-56(s0)
    80004fb0:	f2cff0ef          	jal	ra,800046dc <fdalloc>
    80004fb4:	fca42023          	sw	a0,-64(s0)
    80004fb8:	06054063          	bltz	a0,80005018 <sys_pipe+0xac>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004fbc:	4691                	li	a3,4
    80004fbe:	fc440613          	addi	a2,s0,-60
    80004fc2:	fd843583          	ld	a1,-40(s0)
    80004fc6:	68a8                	ld	a0,80(s1)
    80004fc8:	d1afc0ef          	jal	ra,800014e2 <copyout>
    80004fcc:	00054e63          	bltz	a0,80004fe8 <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80004fd0:	4691                	li	a3,4
    80004fd2:	fc040613          	addi	a2,s0,-64
    80004fd6:	fd843583          	ld	a1,-40(s0)
    80004fda:	0591                	addi	a1,a1,4
    80004fdc:	68a8                	ld	a0,80(s1)
    80004fde:	d04fc0ef          	jal	ra,800014e2 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80004fe2:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004fe4:	04055c63          	bgez	a0,8000503c <sys_pipe+0xd0>
    p->ofile[fd0] = 0;
    80004fe8:	fc442783          	lw	a5,-60(s0)
    80004fec:	07e9                	addi	a5,a5,26
    80004fee:	078e                	slli	a5,a5,0x3
    80004ff0:	97a6                	add	a5,a5,s1
    80004ff2:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80004ff6:	fc042783          	lw	a5,-64(s0)
    80004ffa:	07e9                	addi	a5,a5,26
    80004ffc:	078e                	slli	a5,a5,0x3
    80004ffe:	94be                	add	s1,s1,a5
    80005000:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80005004:	fd043503          	ld	a0,-48(s0)
    80005008:	d89fe0ef          	jal	ra,80003d90 <fileclose>
    fileclose(wf);
    8000500c:	fc843503          	ld	a0,-56(s0)
    80005010:	d81fe0ef          	jal	ra,80003d90 <fileclose>
    return -1;
    80005014:	57fd                	li	a5,-1
    80005016:	a01d                	j	8000503c <sys_pipe+0xd0>
    if(fd0 >= 0)
    80005018:	fc442783          	lw	a5,-60(s0)
    8000501c:	0007c763          	bltz	a5,8000502a <sys_pipe+0xbe>
      p->ofile[fd0] = 0;
    80005020:	07e9                	addi	a5,a5,26
    80005022:	078e                	slli	a5,a5,0x3
    80005024:	97a6                	add	a5,a5,s1
    80005026:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    8000502a:	fd043503          	ld	a0,-48(s0)
    8000502e:	d63fe0ef          	jal	ra,80003d90 <fileclose>
    fileclose(wf);
    80005032:	fc843503          	ld	a0,-56(s0)
    80005036:	d5bfe0ef          	jal	ra,80003d90 <fileclose>
    return -1;
    8000503a:	57fd                	li	a5,-1
}
    8000503c:	853e                	mv	a0,a5
    8000503e:	70e2                	ld	ra,56(sp)
    80005040:	7442                	ld	s0,48(sp)
    80005042:	74a2                	ld	s1,40(sp)
    80005044:	6121                	addi	sp,sp,64
    80005046:	8082                	ret
	...

0000000080005050 <kernelvec>:
    80005050:	7111                	addi	sp,sp,-256
    80005052:	e006                	sd	ra,0(sp)
    80005054:	e40a                	sd	sp,8(sp)
    80005056:	e80e                	sd	gp,16(sp)
    80005058:	ec12                	sd	tp,24(sp)
    8000505a:	f016                	sd	t0,32(sp)
    8000505c:	f41a                	sd	t1,40(sp)
    8000505e:	f81e                	sd	t2,48(sp)
    80005060:	e4aa                	sd	a0,72(sp)
    80005062:	e8ae                	sd	a1,80(sp)
    80005064:	ecb2                	sd	a2,88(sp)
    80005066:	f0b6                	sd	a3,96(sp)
    80005068:	f4ba                	sd	a4,104(sp)
    8000506a:	f8be                	sd	a5,112(sp)
    8000506c:	fcc2                	sd	a6,120(sp)
    8000506e:	e146                	sd	a7,128(sp)
    80005070:	edf2                	sd	t3,216(sp)
    80005072:	f1f6                	sd	t4,224(sp)
    80005074:	f5fa                	sd	t5,232(sp)
    80005076:	f9fe                	sd	t6,240(sp)
    80005078:	ce6fd0ef          	jal	ra,8000255e <kerneltrap>
    8000507c:	6082                	ld	ra,0(sp)
    8000507e:	6122                	ld	sp,8(sp)
    80005080:	61c2                	ld	gp,16(sp)
    80005082:	7282                	ld	t0,32(sp)
    80005084:	7322                	ld	t1,40(sp)
    80005086:	73c2                	ld	t2,48(sp)
    80005088:	6526                	ld	a0,72(sp)
    8000508a:	65c6                	ld	a1,80(sp)
    8000508c:	6666                	ld	a2,88(sp)
    8000508e:	7686                	ld	a3,96(sp)
    80005090:	7726                	ld	a4,104(sp)
    80005092:	77c6                	ld	a5,112(sp)
    80005094:	7866                	ld	a6,120(sp)
    80005096:	688a                	ld	a7,128(sp)
    80005098:	6e6e                	ld	t3,216(sp)
    8000509a:	7e8e                	ld	t4,224(sp)
    8000509c:	7f2e                	ld	t5,232(sp)
    8000509e:	7fce                	ld	t6,240(sp)
    800050a0:	6111                	addi	sp,sp,256
    800050a2:	10200073          	sret
	...

00000000800050ae <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800050ae:	1141                	addi	sp,sp,-16
    800050b0:	e422                	sd	s0,8(sp)
    800050b2:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800050b4:	0c0007b7          	lui	a5,0xc000
    800050b8:	4705                	li	a4,1
    800050ba:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800050bc:	c3d8                	sw	a4,4(a5)
}
    800050be:	6422                	ld	s0,8(sp)
    800050c0:	0141                	addi	sp,sp,16
    800050c2:	8082                	ret

00000000800050c4 <plicinithart>:

void
plicinithart(void)
{
    800050c4:	1141                	addi	sp,sp,-16
    800050c6:	e406                	sd	ra,8(sp)
    800050c8:	e022                	sd	s0,0(sp)
    800050ca:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800050cc:	f32fc0ef          	jal	ra,800017fe <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800050d0:	0085171b          	slliw	a4,a0,0x8
    800050d4:	0c0027b7          	lui	a5,0xc002
    800050d8:	97ba                	add	a5,a5,a4
    800050da:	40200713          	li	a4,1026
    800050de:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800050e2:	00d5151b          	slliw	a0,a0,0xd
    800050e6:	0c2017b7          	lui	a5,0xc201
    800050ea:	97aa                	add	a5,a5,a0
    800050ec:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800050f0:	60a2                	ld	ra,8(sp)
    800050f2:	6402                	ld	s0,0(sp)
    800050f4:	0141                	addi	sp,sp,16
    800050f6:	8082                	ret

00000000800050f8 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800050f8:	1141                	addi	sp,sp,-16
    800050fa:	e406                	sd	ra,8(sp)
    800050fc:	e022                	sd	s0,0(sp)
    800050fe:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005100:	efefc0ef          	jal	ra,800017fe <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005104:	00d5151b          	slliw	a0,a0,0xd
    80005108:	0c2017b7          	lui	a5,0xc201
    8000510c:	97aa                	add	a5,a5,a0
  return irq;
}
    8000510e:	43c8                	lw	a0,4(a5)
    80005110:	60a2                	ld	ra,8(sp)
    80005112:	6402                	ld	s0,0(sp)
    80005114:	0141                	addi	sp,sp,16
    80005116:	8082                	ret

0000000080005118 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80005118:	1101                	addi	sp,sp,-32
    8000511a:	ec06                	sd	ra,24(sp)
    8000511c:	e822                	sd	s0,16(sp)
    8000511e:	e426                	sd	s1,8(sp)
    80005120:	1000                	addi	s0,sp,32
    80005122:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005124:	edafc0ef          	jal	ra,800017fe <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005128:	00d5151b          	slliw	a0,a0,0xd
    8000512c:	0c2017b7          	lui	a5,0xc201
    80005130:	97aa                	add	a5,a5,a0
    80005132:	c3c4                	sw	s1,4(a5)
}
    80005134:	60e2                	ld	ra,24(sp)
    80005136:	6442                	ld	s0,16(sp)
    80005138:	64a2                	ld	s1,8(sp)
    8000513a:	6105                	addi	sp,sp,32
    8000513c:	8082                	ret

000000008000513e <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    8000513e:	1141                	addi	sp,sp,-16
    80005140:	e406                	sd	ra,8(sp)
    80005142:	e022                	sd	s0,0(sp)
    80005144:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80005146:	479d                	li	a5,7
    80005148:	04a7ca63          	blt	a5,a0,8000519c <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    8000514c:	0001c797          	auipc	a5,0x1c
    80005150:	9d478793          	addi	a5,a5,-1580 # 80020b20 <disk>
    80005154:	97aa                	add	a5,a5,a0
    80005156:	0187c783          	lbu	a5,24(a5)
    8000515a:	e7b9                	bnez	a5,800051a8 <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    8000515c:	00451693          	slli	a3,a0,0x4
    80005160:	0001c797          	auipc	a5,0x1c
    80005164:	9c078793          	addi	a5,a5,-1600 # 80020b20 <disk>
    80005168:	6398                	ld	a4,0(a5)
    8000516a:	9736                	add	a4,a4,a3
    8000516c:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    80005170:	6398                	ld	a4,0(a5)
    80005172:	9736                	add	a4,a4,a3
    80005174:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80005178:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    8000517c:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005180:	97aa                	add	a5,a5,a0
    80005182:	4705                	li	a4,1
    80005184:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80005188:	0001c517          	auipc	a0,0x1c
    8000518c:	9b050513          	addi	a0,a0,-1616 # 80020b38 <disk+0x18>
    80005190:	cb3fc0ef          	jal	ra,80001e42 <wakeup>
}
    80005194:	60a2                	ld	ra,8(sp)
    80005196:	6402                	ld	s0,0(sp)
    80005198:	0141                	addi	sp,sp,16
    8000519a:	8082                	ret
    panic("free_desc 1");
    8000519c:	00002517          	auipc	a0,0x2
    800051a0:	5e450513          	addi	a0,a0,1508 # 80007780 <syscalls+0x2f0>
    800051a4:	db2fb0ef          	jal	ra,80000756 <panic>
    panic("free_desc 2");
    800051a8:	00002517          	auipc	a0,0x2
    800051ac:	5e850513          	addi	a0,a0,1512 # 80007790 <syscalls+0x300>
    800051b0:	da6fb0ef          	jal	ra,80000756 <panic>

00000000800051b4 <virtio_disk_init>:
{
    800051b4:	1101                	addi	sp,sp,-32
    800051b6:	ec06                	sd	ra,24(sp)
    800051b8:	e822                	sd	s0,16(sp)
    800051ba:	e426                	sd	s1,8(sp)
    800051bc:	e04a                	sd	s2,0(sp)
    800051be:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800051c0:	00002597          	auipc	a1,0x2
    800051c4:	5e058593          	addi	a1,a1,1504 # 800077a0 <syscalls+0x310>
    800051c8:	0001c517          	auipc	a0,0x1c
    800051cc:	a8050513          	addi	a0,a0,-1408 # 80020c48 <disk+0x128>
    800051d0:	949fb0ef          	jal	ra,80000b18 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800051d4:	100017b7          	lui	a5,0x10001
    800051d8:	4398                	lw	a4,0(a5)
    800051da:	2701                	sext.w	a4,a4
    800051dc:	747277b7          	lui	a5,0x74727
    800051e0:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800051e4:	12f71f63          	bne	a4,a5,80005322 <virtio_disk_init+0x16e>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800051e8:	100017b7          	lui	a5,0x10001
    800051ec:	43dc                	lw	a5,4(a5)
    800051ee:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800051f0:	4709                	li	a4,2
    800051f2:	12e79863          	bne	a5,a4,80005322 <virtio_disk_init+0x16e>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800051f6:	100017b7          	lui	a5,0x10001
    800051fa:	479c                	lw	a5,8(a5)
    800051fc:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800051fe:	12e79263          	bne	a5,a4,80005322 <virtio_disk_init+0x16e>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005202:	100017b7          	lui	a5,0x10001
    80005206:	47d8                	lw	a4,12(a5)
    80005208:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000520a:	554d47b7          	lui	a5,0x554d4
    8000520e:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005212:	10f71863          	bne	a4,a5,80005322 <virtio_disk_init+0x16e>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005216:	100017b7          	lui	a5,0x10001
    8000521a:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000521e:	4705                	li	a4,1
    80005220:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005222:	470d                	li	a4,3
    80005224:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005226:	4b98                	lw	a4,16(a5)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005228:	c7ffe6b7          	lui	a3,0xc7ffe
    8000522c:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fddaff>
    80005230:	8f75                	and	a4,a4,a3
    80005232:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005234:	472d                	li	a4,11
    80005236:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    80005238:	5bbc                	lw	a5,112(a5)
    8000523a:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    8000523e:	8ba1                	andi	a5,a5,8
    80005240:	0e078763          	beqz	a5,8000532e <virtio_disk_init+0x17a>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005244:	100017b7          	lui	a5,0x10001
    80005248:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    8000524c:	43fc                	lw	a5,68(a5)
    8000524e:	2781                	sext.w	a5,a5
    80005250:	0e079563          	bnez	a5,8000533a <virtio_disk_init+0x186>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005254:	100017b7          	lui	a5,0x10001
    80005258:	5bdc                	lw	a5,52(a5)
    8000525a:	2781                	sext.w	a5,a5
  if(max == 0)
    8000525c:	0e078563          	beqz	a5,80005346 <virtio_disk_init+0x192>
  if(max < NUM)
    80005260:	471d                	li	a4,7
    80005262:	0ef77863          	bgeu	a4,a5,80005352 <virtio_disk_init+0x19e>
  disk.desc = kalloc();
    80005266:	863fb0ef          	jal	ra,80000ac8 <kalloc>
    8000526a:	0001c497          	auipc	s1,0x1c
    8000526e:	8b648493          	addi	s1,s1,-1866 # 80020b20 <disk>
    80005272:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005274:	855fb0ef          	jal	ra,80000ac8 <kalloc>
    80005278:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000527a:	84ffb0ef          	jal	ra,80000ac8 <kalloc>
    8000527e:	87aa                	mv	a5,a0
    80005280:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80005282:	6088                	ld	a0,0(s1)
    80005284:	cd69                	beqz	a0,8000535e <virtio_disk_init+0x1aa>
    80005286:	0001c717          	auipc	a4,0x1c
    8000528a:	8a273703          	ld	a4,-1886(a4) # 80020b28 <disk+0x8>
    8000528e:	cb61                	beqz	a4,8000535e <virtio_disk_init+0x1aa>
    80005290:	c7f9                	beqz	a5,8000535e <virtio_disk_init+0x1aa>
  memset(disk.desc, 0, PGSIZE);
    80005292:	6605                	lui	a2,0x1
    80005294:	4581                	li	a1,0
    80005296:	9d7fb0ef          	jal	ra,80000c6c <memset>
  memset(disk.avail, 0, PGSIZE);
    8000529a:	0001c497          	auipc	s1,0x1c
    8000529e:	88648493          	addi	s1,s1,-1914 # 80020b20 <disk>
    800052a2:	6605                	lui	a2,0x1
    800052a4:	4581                	li	a1,0
    800052a6:	6488                	ld	a0,8(s1)
    800052a8:	9c5fb0ef          	jal	ra,80000c6c <memset>
  memset(disk.used, 0, PGSIZE);
    800052ac:	6605                	lui	a2,0x1
    800052ae:	4581                	li	a1,0
    800052b0:	6888                	ld	a0,16(s1)
    800052b2:	9bbfb0ef          	jal	ra,80000c6c <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800052b6:	100017b7          	lui	a5,0x10001
    800052ba:	4721                	li	a4,8
    800052bc:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    800052be:	4098                	lw	a4,0(s1)
    800052c0:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    800052c4:	40d8                	lw	a4,4(s1)
    800052c6:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    800052ca:	6498                	ld	a4,8(s1)
    800052cc:	0007069b          	sext.w	a3,a4
    800052d0:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    800052d4:	9701                	srai	a4,a4,0x20
    800052d6:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    800052da:	6898                	ld	a4,16(s1)
    800052dc:	0007069b          	sext.w	a3,a4
    800052e0:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    800052e4:	9701                	srai	a4,a4,0x20
    800052e6:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    800052ea:	4705                	li	a4,1
    800052ec:	c3f8                	sw	a4,68(a5)
    disk.free[i] = 1;
    800052ee:	00e48c23          	sb	a4,24(s1)
    800052f2:	00e48ca3          	sb	a4,25(s1)
    800052f6:	00e48d23          	sb	a4,26(s1)
    800052fa:	00e48da3          	sb	a4,27(s1)
    800052fe:	00e48e23          	sb	a4,28(s1)
    80005302:	00e48ea3          	sb	a4,29(s1)
    80005306:	00e48f23          	sb	a4,30(s1)
    8000530a:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    8000530e:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005312:	0727a823          	sw	s2,112(a5)
}
    80005316:	60e2                	ld	ra,24(sp)
    80005318:	6442                	ld	s0,16(sp)
    8000531a:	64a2                	ld	s1,8(sp)
    8000531c:	6902                	ld	s2,0(sp)
    8000531e:	6105                	addi	sp,sp,32
    80005320:	8082                	ret
    panic("could not find virtio disk");
    80005322:	00002517          	auipc	a0,0x2
    80005326:	48e50513          	addi	a0,a0,1166 # 800077b0 <syscalls+0x320>
    8000532a:	c2cfb0ef          	jal	ra,80000756 <panic>
    panic("virtio disk FEATURES_OK unset");
    8000532e:	00002517          	auipc	a0,0x2
    80005332:	4a250513          	addi	a0,a0,1186 # 800077d0 <syscalls+0x340>
    80005336:	c20fb0ef          	jal	ra,80000756 <panic>
    panic("virtio disk should not be ready");
    8000533a:	00002517          	auipc	a0,0x2
    8000533e:	4b650513          	addi	a0,a0,1206 # 800077f0 <syscalls+0x360>
    80005342:	c14fb0ef          	jal	ra,80000756 <panic>
    panic("virtio disk has no queue 0");
    80005346:	00002517          	auipc	a0,0x2
    8000534a:	4ca50513          	addi	a0,a0,1226 # 80007810 <syscalls+0x380>
    8000534e:	c08fb0ef          	jal	ra,80000756 <panic>
    panic("virtio disk max queue too short");
    80005352:	00002517          	auipc	a0,0x2
    80005356:	4de50513          	addi	a0,a0,1246 # 80007830 <syscalls+0x3a0>
    8000535a:	bfcfb0ef          	jal	ra,80000756 <panic>
    panic("virtio disk kalloc");
    8000535e:	00002517          	auipc	a0,0x2
    80005362:	4f250513          	addi	a0,a0,1266 # 80007850 <syscalls+0x3c0>
    80005366:	bf0fb0ef          	jal	ra,80000756 <panic>

000000008000536a <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    8000536a:	7119                	addi	sp,sp,-128
    8000536c:	fc86                	sd	ra,120(sp)
    8000536e:	f8a2                	sd	s0,112(sp)
    80005370:	f4a6                	sd	s1,104(sp)
    80005372:	f0ca                	sd	s2,96(sp)
    80005374:	ecce                	sd	s3,88(sp)
    80005376:	e8d2                	sd	s4,80(sp)
    80005378:	e4d6                	sd	s5,72(sp)
    8000537a:	e0da                	sd	s6,64(sp)
    8000537c:	fc5e                	sd	s7,56(sp)
    8000537e:	f862                	sd	s8,48(sp)
    80005380:	f466                	sd	s9,40(sp)
    80005382:	f06a                	sd	s10,32(sp)
    80005384:	ec6e                	sd	s11,24(sp)
    80005386:	0100                	addi	s0,sp,128
    80005388:	8aaa                	mv	s5,a0
    8000538a:	8c2e                	mv	s8,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    8000538c:	00c52d03          	lw	s10,12(a0)
    80005390:	001d1d1b          	slliw	s10,s10,0x1
    80005394:	1d02                	slli	s10,s10,0x20
    80005396:	020d5d13          	srli	s10,s10,0x20

  acquire(&disk.vdisk_lock);
    8000539a:	0001c517          	auipc	a0,0x1c
    8000539e:	8ae50513          	addi	a0,a0,-1874 # 80020c48 <disk+0x128>
    800053a2:	ff6fb0ef          	jal	ra,80000b98 <acquire>
  for(int i = 0; i < 3; i++){
    800053a6:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    800053a8:	44a1                	li	s1,8
      disk.free[i] = 0;
    800053aa:	0001bb97          	auipc	s7,0x1b
    800053ae:	776b8b93          	addi	s7,s7,1910 # 80020b20 <disk>
  for(int i = 0; i < 3; i++){
    800053b2:	4b0d                	li	s6,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800053b4:	0001cc97          	auipc	s9,0x1c
    800053b8:	894c8c93          	addi	s9,s9,-1900 # 80020c48 <disk+0x128>
    800053bc:	a8a9                	j	80005416 <virtio_disk_rw+0xac>
      disk.free[i] = 0;
    800053be:	00fb8733          	add	a4,s7,a5
    800053c2:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    800053c6:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    800053c8:	0207c563          	bltz	a5,800053f2 <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    800053cc:	2905                	addiw	s2,s2,1
    800053ce:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    800053d0:	05690863          	beq	s2,s6,80005420 <virtio_disk_rw+0xb6>
    idx[i] = alloc_desc();
    800053d4:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    800053d6:	0001b717          	auipc	a4,0x1b
    800053da:	74a70713          	addi	a4,a4,1866 # 80020b20 <disk>
    800053de:	87ce                	mv	a5,s3
    if(disk.free[i]){
    800053e0:	01874683          	lbu	a3,24(a4)
    800053e4:	fee9                	bnez	a3,800053be <virtio_disk_rw+0x54>
  for(int i = 0; i < NUM; i++){
    800053e6:	2785                	addiw	a5,a5,1
    800053e8:	0705                	addi	a4,a4,1
    800053ea:	fe979be3          	bne	a5,s1,800053e0 <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    800053ee:	57fd                	li	a5,-1
    800053f0:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    800053f2:	01205b63          	blez	s2,80005408 <virtio_disk_rw+0x9e>
    800053f6:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    800053f8:	000a2503          	lw	a0,0(s4)
    800053fc:	d43ff0ef          	jal	ra,8000513e <free_desc>
      for(int j = 0; j < i; j++)
    80005400:	2d85                	addiw	s11,s11,1
    80005402:	0a11                	addi	s4,s4,4
    80005404:	ff2d9ae3          	bne	s11,s2,800053f8 <virtio_disk_rw+0x8e>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005408:	85e6                	mv	a1,s9
    8000540a:	0001b517          	auipc	a0,0x1b
    8000540e:	72e50513          	addi	a0,a0,1838 # 80020b38 <disk+0x18>
    80005412:	9e5fc0ef          	jal	ra,80001df6 <sleep>
  for(int i = 0; i < 3; i++){
    80005416:	f8040a13          	addi	s4,s0,-128
{
    8000541a:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    8000541c:	894e                	mv	s2,s3
    8000541e:	bf5d                	j	800053d4 <virtio_disk_rw+0x6a>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005420:	f8042503          	lw	a0,-128(s0)
    80005424:	00a50713          	addi	a4,a0,10
    80005428:	0712                	slli	a4,a4,0x4

  if(write)
    8000542a:	0001b797          	auipc	a5,0x1b
    8000542e:	6f678793          	addi	a5,a5,1782 # 80020b20 <disk>
    80005432:	00e786b3          	add	a3,a5,a4
    80005436:	01803633          	snez	a2,s8
    8000543a:	c690                	sw	a2,8(a3)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    8000543c:	0006a623          	sw	zero,12(a3)
  buf0->sector = sector;
    80005440:	01a6b823          	sd	s10,16(a3)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005444:	f6070613          	addi	a2,a4,-160
    80005448:	6394                	ld	a3,0(a5)
    8000544a:	96b2                	add	a3,a3,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000544c:	00870593          	addi	a1,a4,8
    80005450:	95be                	add	a1,a1,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005452:	e28c                	sd	a1,0(a3)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005454:	0007b803          	ld	a6,0(a5)
    80005458:	9642                	add	a2,a2,a6
    8000545a:	46c1                	li	a3,16
    8000545c:	c614                	sw	a3,8(a2)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    8000545e:	4585                	li	a1,1
    80005460:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[0]].next = idx[1];
    80005464:	f8442683          	lw	a3,-124(s0)
    80005468:	00d61723          	sh	a3,14(a2)

  disk.desc[idx[1]].addr = (uint64) b->data;
    8000546c:	0692                	slli	a3,a3,0x4
    8000546e:	9836                	add	a6,a6,a3
    80005470:	058a8613          	addi	a2,s5,88
    80005474:	00c83023          	sd	a2,0(a6)
  disk.desc[idx[1]].len = BSIZE;
    80005478:	0007b803          	ld	a6,0(a5)
    8000547c:	96c2                	add	a3,a3,a6
    8000547e:	40000613          	li	a2,1024
    80005482:	c690                	sw	a2,8(a3)
  if(write)
    80005484:	001c3613          	seqz	a2,s8
    80005488:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000548c:	00166613          	ori	a2,a2,1
    80005490:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    80005494:	f8842603          	lw	a2,-120(s0)
    80005498:	00c69723          	sh	a2,14(a3)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    8000549c:	00250693          	addi	a3,a0,2
    800054a0:	0692                	slli	a3,a3,0x4
    800054a2:	96be                	add	a3,a3,a5
    800054a4:	58fd                	li	a7,-1
    800054a6:	01168823          	sb	a7,16(a3)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800054aa:	0612                	slli	a2,a2,0x4
    800054ac:	9832                	add	a6,a6,a2
    800054ae:	f9070713          	addi	a4,a4,-112
    800054b2:	973e                	add	a4,a4,a5
    800054b4:	00e83023          	sd	a4,0(a6)
  disk.desc[idx[2]].len = 1;
    800054b8:	6398                	ld	a4,0(a5)
    800054ba:	9732                	add	a4,a4,a2
    800054bc:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800054be:	4609                	li	a2,2
    800054c0:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[2]].next = 0;
    800054c4:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800054c8:	00baa223          	sw	a1,4(s5)
  disk.info[idx[0]].b = b;
    800054cc:	0156b423          	sd	s5,8(a3)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800054d0:	6794                	ld	a3,8(a5)
    800054d2:	0026d703          	lhu	a4,2(a3)
    800054d6:	8b1d                	andi	a4,a4,7
    800054d8:	0706                	slli	a4,a4,0x1
    800054da:	96ba                	add	a3,a3,a4
    800054dc:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    800054e0:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800054e4:	6798                	ld	a4,8(a5)
    800054e6:	00275783          	lhu	a5,2(a4)
    800054ea:	2785                	addiw	a5,a5,1
    800054ec:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800054f0:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800054f4:	100017b7          	lui	a5,0x10001
    800054f8:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800054fc:	004aa783          	lw	a5,4(s5)
    sleep(b, &disk.vdisk_lock);
    80005500:	0001b917          	auipc	s2,0x1b
    80005504:	74890913          	addi	s2,s2,1864 # 80020c48 <disk+0x128>
  while(b->disk == 1) {
    80005508:	4485                	li	s1,1
    8000550a:	00b79a63          	bne	a5,a1,8000551e <virtio_disk_rw+0x1b4>
    sleep(b, &disk.vdisk_lock);
    8000550e:	85ca                	mv	a1,s2
    80005510:	8556                	mv	a0,s5
    80005512:	8e5fc0ef          	jal	ra,80001df6 <sleep>
  while(b->disk == 1) {
    80005516:	004aa783          	lw	a5,4(s5)
    8000551a:	fe978ae3          	beq	a5,s1,8000550e <virtio_disk_rw+0x1a4>
  }

  disk.info[idx[0]].b = 0;
    8000551e:	f8042903          	lw	s2,-128(s0)
    80005522:	00290713          	addi	a4,s2,2
    80005526:	0712                	slli	a4,a4,0x4
    80005528:	0001b797          	auipc	a5,0x1b
    8000552c:	5f878793          	addi	a5,a5,1528 # 80020b20 <disk>
    80005530:	97ba                	add	a5,a5,a4
    80005532:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80005536:	0001b997          	auipc	s3,0x1b
    8000553a:	5ea98993          	addi	s3,s3,1514 # 80020b20 <disk>
    8000553e:	00491713          	slli	a4,s2,0x4
    80005542:	0009b783          	ld	a5,0(s3)
    80005546:	97ba                	add	a5,a5,a4
    80005548:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    8000554c:	854a                	mv	a0,s2
    8000554e:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005552:	bedff0ef          	jal	ra,8000513e <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005556:	8885                	andi	s1,s1,1
    80005558:	f0fd                	bnez	s1,8000553e <virtio_disk_rw+0x1d4>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000555a:	0001b517          	auipc	a0,0x1b
    8000555e:	6ee50513          	addi	a0,a0,1774 # 80020c48 <disk+0x128>
    80005562:	ecefb0ef          	jal	ra,80000c30 <release>
}
    80005566:	70e6                	ld	ra,120(sp)
    80005568:	7446                	ld	s0,112(sp)
    8000556a:	74a6                	ld	s1,104(sp)
    8000556c:	7906                	ld	s2,96(sp)
    8000556e:	69e6                	ld	s3,88(sp)
    80005570:	6a46                	ld	s4,80(sp)
    80005572:	6aa6                	ld	s5,72(sp)
    80005574:	6b06                	ld	s6,64(sp)
    80005576:	7be2                	ld	s7,56(sp)
    80005578:	7c42                	ld	s8,48(sp)
    8000557a:	7ca2                	ld	s9,40(sp)
    8000557c:	7d02                	ld	s10,32(sp)
    8000557e:	6de2                	ld	s11,24(sp)
    80005580:	6109                	addi	sp,sp,128
    80005582:	8082                	ret

0000000080005584 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005584:	1101                	addi	sp,sp,-32
    80005586:	ec06                	sd	ra,24(sp)
    80005588:	e822                	sd	s0,16(sp)
    8000558a:	e426                	sd	s1,8(sp)
    8000558c:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    8000558e:	0001b497          	auipc	s1,0x1b
    80005592:	59248493          	addi	s1,s1,1426 # 80020b20 <disk>
    80005596:	0001b517          	auipc	a0,0x1b
    8000559a:	6b250513          	addi	a0,a0,1714 # 80020c48 <disk+0x128>
    8000559e:	dfafb0ef          	jal	ra,80000b98 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800055a2:	10001737          	lui	a4,0x10001
    800055a6:	533c                	lw	a5,96(a4)
    800055a8:	8b8d                	andi	a5,a5,3
    800055aa:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    800055ac:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800055b0:	689c                	ld	a5,16(s1)
    800055b2:	0204d703          	lhu	a4,32(s1)
    800055b6:	0027d783          	lhu	a5,2(a5)
    800055ba:	04f70663          	beq	a4,a5,80005606 <virtio_disk_intr+0x82>
    __sync_synchronize();
    800055be:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800055c2:	6898                	ld	a4,16(s1)
    800055c4:	0204d783          	lhu	a5,32(s1)
    800055c8:	8b9d                	andi	a5,a5,7
    800055ca:	078e                	slli	a5,a5,0x3
    800055cc:	97ba                	add	a5,a5,a4
    800055ce:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800055d0:	00278713          	addi	a4,a5,2
    800055d4:	0712                	slli	a4,a4,0x4
    800055d6:	9726                	add	a4,a4,s1
    800055d8:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    800055dc:	e321                	bnez	a4,8000561c <virtio_disk_intr+0x98>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800055de:	0789                	addi	a5,a5,2
    800055e0:	0792                	slli	a5,a5,0x4
    800055e2:	97a6                	add	a5,a5,s1
    800055e4:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    800055e6:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800055ea:	859fc0ef          	jal	ra,80001e42 <wakeup>

    disk.used_idx += 1;
    800055ee:	0204d783          	lhu	a5,32(s1)
    800055f2:	2785                	addiw	a5,a5,1
    800055f4:	17c2                	slli	a5,a5,0x30
    800055f6:	93c1                	srli	a5,a5,0x30
    800055f8:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800055fc:	6898                	ld	a4,16(s1)
    800055fe:	00275703          	lhu	a4,2(a4)
    80005602:	faf71ee3          	bne	a4,a5,800055be <virtio_disk_intr+0x3a>
  }

  release(&disk.vdisk_lock);
    80005606:	0001b517          	auipc	a0,0x1b
    8000560a:	64250513          	addi	a0,a0,1602 # 80020c48 <disk+0x128>
    8000560e:	e22fb0ef          	jal	ra,80000c30 <release>
}
    80005612:	60e2                	ld	ra,24(sp)
    80005614:	6442                	ld	s0,16(sp)
    80005616:	64a2                	ld	s1,8(sp)
    80005618:	6105                	addi	sp,sp,32
    8000561a:	8082                	ret
      panic("virtio_disk_intr status");
    8000561c:	00002517          	auipc	a0,0x2
    80005620:	24c50513          	addi	a0,a0,588 # 80007868 <syscalls+0x3d8>
    80005624:	932fb0ef          	jal	ra,80000756 <panic>
	...

0000000080006000 <_trampoline>:
    80006000:	14051073          	csrw	sscratch,a0
    80006004:	02000537          	lui	a0,0x2000
    80006008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000600a:	0536                	slli	a0,a0,0xd
    8000600c:	02153423          	sd	ra,40(a0)
    80006010:	02253823          	sd	sp,48(a0)
    80006014:	02353c23          	sd	gp,56(a0)
    80006018:	04453023          	sd	tp,64(a0)
    8000601c:	04553423          	sd	t0,72(a0)
    80006020:	04653823          	sd	t1,80(a0)
    80006024:	04753c23          	sd	t2,88(a0)
    80006028:	f120                	sd	s0,96(a0)
    8000602a:	f524                	sd	s1,104(a0)
    8000602c:	fd2c                	sd	a1,120(a0)
    8000602e:	e150                	sd	a2,128(a0)
    80006030:	e554                	sd	a3,136(a0)
    80006032:	e958                	sd	a4,144(a0)
    80006034:	ed5c                	sd	a5,152(a0)
    80006036:	0b053023          	sd	a6,160(a0)
    8000603a:	0b153423          	sd	a7,168(a0)
    8000603e:	0b253823          	sd	s2,176(a0)
    80006042:	0b353c23          	sd	s3,184(a0)
    80006046:	0d453023          	sd	s4,192(a0)
    8000604a:	0d553423          	sd	s5,200(a0)
    8000604e:	0d653823          	sd	s6,208(a0)
    80006052:	0d753c23          	sd	s7,216(a0)
    80006056:	0f853023          	sd	s8,224(a0)
    8000605a:	0f953423          	sd	s9,232(a0)
    8000605e:	0fa53823          	sd	s10,240(a0)
    80006062:	0fb53c23          	sd	s11,248(a0)
    80006066:	11c53023          	sd	t3,256(a0)
    8000606a:	11d53423          	sd	t4,264(a0)
    8000606e:	11e53823          	sd	t5,272(a0)
    80006072:	11f53c23          	sd	t6,280(a0)
    80006076:	140022f3          	csrr	t0,sscratch
    8000607a:	06553823          	sd	t0,112(a0)
    8000607e:	00853103          	ld	sp,8(a0)
    80006082:	02053203          	ld	tp,32(a0)
    80006086:	01053283          	ld	t0,16(a0)
    8000608a:	00053303          	ld	t1,0(a0)
    8000608e:	12000073          	sfence.vma
    80006092:	18031073          	csrw	satp,t1
    80006096:	12000073          	sfence.vma
    8000609a:	8282                	jr	t0

000000008000609c <userret>:
    8000609c:	12000073          	sfence.vma
    800060a0:	18051073          	csrw	satp,a0
    800060a4:	12000073          	sfence.vma
    800060a8:	02000537          	lui	a0,0x2000
    800060ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800060ae:	0536                	slli	a0,a0,0xd
    800060b0:	02853083          	ld	ra,40(a0)
    800060b4:	03053103          	ld	sp,48(a0)
    800060b8:	03853183          	ld	gp,56(a0)
    800060bc:	04053203          	ld	tp,64(a0)
    800060c0:	04853283          	ld	t0,72(a0)
    800060c4:	05053303          	ld	t1,80(a0)
    800060c8:	05853383          	ld	t2,88(a0)
    800060cc:	7120                	ld	s0,96(a0)
    800060ce:	7524                	ld	s1,104(a0)
    800060d0:	7d2c                	ld	a1,120(a0)
    800060d2:	6150                	ld	a2,128(a0)
    800060d4:	6554                	ld	a3,136(a0)
    800060d6:	6958                	ld	a4,144(a0)
    800060d8:	6d5c                	ld	a5,152(a0)
    800060da:	0a053803          	ld	a6,160(a0)
    800060de:	0a853883          	ld	a7,168(a0)
    800060e2:	0b053903          	ld	s2,176(a0)
    800060e6:	0b853983          	ld	s3,184(a0)
    800060ea:	0c053a03          	ld	s4,192(a0)
    800060ee:	0c853a83          	ld	s5,200(a0)
    800060f2:	0d053b03          	ld	s6,208(a0)
    800060f6:	0d853b83          	ld	s7,216(a0)
    800060fa:	0e053c03          	ld	s8,224(a0)
    800060fe:	0e853c83          	ld	s9,232(a0)
    80006102:	0f053d03          	ld	s10,240(a0)
    80006106:	0f853d83          	ld	s11,248(a0)
    8000610a:	10053e03          	ld	t3,256(a0)
    8000610e:	10853e83          	ld	t4,264(a0)
    80006112:	11053f03          	ld	t5,272(a0)
    80006116:	11853f83          	ld	t6,280(a0)
    8000611a:	7928                	ld	a0,112(a0)
    8000611c:	10200073          	sret
	...
