
user/_init:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	addi	s0,sp,32
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
   c:	4589                	li	a1,2
   e:	00001517          	auipc	a0,0x1
  12:	8c250513          	addi	a0,a0,-1854 # 8d0 <malloc+0xea>
  16:	350000ef          	jal	ra,366 <open>
  1a:	04054563          	bltz	a0,64 <main+0x64>
    mknod("console", CONSOLE, 0);
    open("console", O_RDWR);
  }
  dup(0);  // stdout
  1e:	4501                	li	a0,0
  20:	37e000ef          	jal	ra,39e <dup>
  dup(0);  // stderr
  24:	4501                	li	a0,0
  26:	378000ef          	jal	ra,39e <dup>

  for(;;){
    printf("init: starting sh\n");
  2a:	00001917          	auipc	s2,0x1
  2e:	8ae90913          	addi	s2,s2,-1874 # 8d8 <malloc+0xf2>
  32:	854a                	mv	a0,s2
  34:	6fe000ef          	jal	ra,732 <printf>
    pid = fork();
  38:	2e6000ef          	jal	ra,31e <fork>
  3c:	84aa                	mv	s1,a0
    if(pid < 0){
  3e:	04054363          	bltz	a0,84 <main+0x84>
      printf("init: fork failed\n");
      exit(1);
    }
    if(pid == 0){
  42:	c931                	beqz	a0,96 <main+0x96>
    }

    for(;;){
      // this call to wait() returns if the shell exits,
      // or if a parentless process exits.
      wpid = wait((int *) 0);
  44:	4501                	li	a0,0
  46:	2e8000ef          	jal	ra,32e <wait>
      if(wpid == pid){
  4a:	fea484e3          	beq	s1,a0,32 <main+0x32>
        // the shell exited; restart it.
        break;
      } else if(wpid < 0){
  4e:	fe055be3          	bgez	a0,44 <main+0x44>
        printf("init: wait returned an error\n");
  52:	00001517          	auipc	a0,0x1
  56:	8d650513          	addi	a0,a0,-1834 # 928 <malloc+0x142>
  5a:	6d8000ef          	jal	ra,732 <printf>
        exit(1);
  5e:	4505                	li	a0,1
  60:	2c6000ef          	jal	ra,326 <exit>
    mknod("console", CONSOLE, 0);
  64:	4601                	li	a2,0
  66:	4585                	li	a1,1
  68:	00001517          	auipc	a0,0x1
  6c:	86850513          	addi	a0,a0,-1944 # 8d0 <malloc+0xea>
  70:	2fe000ef          	jal	ra,36e <mknod>
    open("console", O_RDWR);
  74:	4589                	li	a1,2
  76:	00001517          	auipc	a0,0x1
  7a:	85a50513          	addi	a0,a0,-1958 # 8d0 <malloc+0xea>
  7e:	2e8000ef          	jal	ra,366 <open>
  82:	bf71                	j	1e <main+0x1e>
      printf("init: fork failed\n");
  84:	00001517          	auipc	a0,0x1
  88:	86c50513          	addi	a0,a0,-1940 # 8f0 <malloc+0x10a>
  8c:	6a6000ef          	jal	ra,732 <printf>
      exit(1);
  90:	4505                	li	a0,1
  92:	294000ef          	jal	ra,326 <exit>
      exec("sh", argv);
  96:	00001597          	auipc	a1,0x1
  9a:	f6a58593          	addi	a1,a1,-150 # 1000 <argv>
  9e:	00001517          	auipc	a0,0x1
  a2:	86a50513          	addi	a0,a0,-1942 # 908 <malloc+0x122>
  a6:	2b8000ef          	jal	ra,35e <exec>
      printf("init: exec sh failed\n");
  aa:	00001517          	auipc	a0,0x1
  ae:	86650513          	addi	a0,a0,-1946 # 910 <malloc+0x12a>
  b2:	680000ef          	jal	ra,732 <printf>
      exit(1);
  b6:	4505                	li	a0,1
  b8:	26e000ef          	jal	ra,326 <exit>

00000000000000bc <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  bc:	1141                	addi	sp,sp,-16
  be:	e406                	sd	ra,8(sp)
  c0:	e022                	sd	s0,0(sp)
  c2:	0800                	addi	s0,sp,16
  extern int main();
  main();
  c4:	f3dff0ef          	jal	ra,0 <main>
  exit(0);
  c8:	4501                	li	a0,0
  ca:	25c000ef          	jal	ra,326 <exit>

00000000000000ce <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  ce:	1141                	addi	sp,sp,-16
  d0:	e422                	sd	s0,8(sp)
  d2:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  d4:	87aa                	mv	a5,a0
  d6:	0585                	addi	a1,a1,1
  d8:	0785                	addi	a5,a5,1
  da:	fff5c703          	lbu	a4,-1(a1)
  de:	fee78fa3          	sb	a4,-1(a5)
  e2:	fb75                	bnez	a4,d6 <strcpy+0x8>
    ;
  return os;
}
  e4:	6422                	ld	s0,8(sp)
  e6:	0141                	addi	sp,sp,16
  e8:	8082                	ret

00000000000000ea <strcmp>:

int
strcmp(const char *p, const char *q)
{
  ea:	1141                	addi	sp,sp,-16
  ec:	e422                	sd	s0,8(sp)
  ee:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  f0:	00054783          	lbu	a5,0(a0)
  f4:	cb91                	beqz	a5,108 <strcmp+0x1e>
  f6:	0005c703          	lbu	a4,0(a1)
  fa:	00f71763          	bne	a4,a5,108 <strcmp+0x1e>
    p++, q++;
  fe:	0505                	addi	a0,a0,1
 100:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 102:	00054783          	lbu	a5,0(a0)
 106:	fbe5                	bnez	a5,f6 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 108:	0005c503          	lbu	a0,0(a1)
}
 10c:	40a7853b          	subw	a0,a5,a0
 110:	6422                	ld	s0,8(sp)
 112:	0141                	addi	sp,sp,16
 114:	8082                	ret

0000000000000116 <strlen>:

uint
strlen(const char *s)
{
 116:	1141                	addi	sp,sp,-16
 118:	e422                	sd	s0,8(sp)
 11a:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 11c:	00054783          	lbu	a5,0(a0)
 120:	cf91                	beqz	a5,13c <strlen+0x26>
 122:	0505                	addi	a0,a0,1
 124:	87aa                	mv	a5,a0
 126:	4685                	li	a3,1
 128:	9e89                	subw	a3,a3,a0
 12a:	00f6853b          	addw	a0,a3,a5
 12e:	0785                	addi	a5,a5,1
 130:	fff7c703          	lbu	a4,-1(a5)
 134:	fb7d                	bnez	a4,12a <strlen+0x14>
    ;
  return n;
}
 136:	6422                	ld	s0,8(sp)
 138:	0141                	addi	sp,sp,16
 13a:	8082                	ret
  for(n = 0; s[n]; n++)
 13c:	4501                	li	a0,0
 13e:	bfe5                	j	136 <strlen+0x20>

0000000000000140 <memset>:

void*
memset(void *dst, int c, uint n)
{
 140:	1141                	addi	sp,sp,-16
 142:	e422                	sd	s0,8(sp)
 144:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 146:	ca19                	beqz	a2,15c <memset+0x1c>
 148:	87aa                	mv	a5,a0
 14a:	1602                	slli	a2,a2,0x20
 14c:	9201                	srli	a2,a2,0x20
 14e:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 152:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 156:	0785                	addi	a5,a5,1
 158:	fee79de3          	bne	a5,a4,152 <memset+0x12>
  }
  return dst;
}
 15c:	6422                	ld	s0,8(sp)
 15e:	0141                	addi	sp,sp,16
 160:	8082                	ret

0000000000000162 <strchr>:

char*
strchr(const char *s, char c)
{
 162:	1141                	addi	sp,sp,-16
 164:	e422                	sd	s0,8(sp)
 166:	0800                	addi	s0,sp,16
  for(; *s; s++)
 168:	00054783          	lbu	a5,0(a0)
 16c:	cb99                	beqz	a5,182 <strchr+0x20>
    if(*s == c)
 16e:	00f58763          	beq	a1,a5,17c <strchr+0x1a>
  for(; *s; s++)
 172:	0505                	addi	a0,a0,1
 174:	00054783          	lbu	a5,0(a0)
 178:	fbfd                	bnez	a5,16e <strchr+0xc>
      return (char*)s;
  return 0;
 17a:	4501                	li	a0,0
}
 17c:	6422                	ld	s0,8(sp)
 17e:	0141                	addi	sp,sp,16
 180:	8082                	ret
  return 0;
 182:	4501                	li	a0,0
 184:	bfe5                	j	17c <strchr+0x1a>

0000000000000186 <gets>:

char*
gets(char *buf, int max)
{
 186:	711d                	addi	sp,sp,-96
 188:	ec86                	sd	ra,88(sp)
 18a:	e8a2                	sd	s0,80(sp)
 18c:	e4a6                	sd	s1,72(sp)
 18e:	e0ca                	sd	s2,64(sp)
 190:	fc4e                	sd	s3,56(sp)
 192:	f852                	sd	s4,48(sp)
 194:	f456                	sd	s5,40(sp)
 196:	f05a                	sd	s6,32(sp)
 198:	ec5e                	sd	s7,24(sp)
 19a:	1080                	addi	s0,sp,96
 19c:	8baa                	mv	s7,a0
 19e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1a0:	892a                	mv	s2,a0
 1a2:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1a4:	4aa9                	li	s5,10
 1a6:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 1a8:	89a6                	mv	s3,s1
 1aa:	2485                	addiw	s1,s1,1
 1ac:	0344d663          	bge	s1,s4,1d8 <gets+0x52>
    cc = read(0, &c, 1);
 1b0:	4605                	li	a2,1
 1b2:	faf40593          	addi	a1,s0,-81
 1b6:	4501                	li	a0,0
 1b8:	186000ef          	jal	ra,33e <read>
    if(cc < 1)
 1bc:	00a05e63          	blez	a0,1d8 <gets+0x52>
    buf[i++] = c;
 1c0:	faf44783          	lbu	a5,-81(s0)
 1c4:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1c8:	01578763          	beq	a5,s5,1d6 <gets+0x50>
 1cc:	0905                	addi	s2,s2,1
 1ce:	fd679de3          	bne	a5,s6,1a8 <gets+0x22>
  for(i=0; i+1 < max; ){
 1d2:	89a6                	mv	s3,s1
 1d4:	a011                	j	1d8 <gets+0x52>
 1d6:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 1d8:	99de                	add	s3,s3,s7
 1da:	00098023          	sb	zero,0(s3)
  return buf;
}
 1de:	855e                	mv	a0,s7
 1e0:	60e6                	ld	ra,88(sp)
 1e2:	6446                	ld	s0,80(sp)
 1e4:	64a6                	ld	s1,72(sp)
 1e6:	6906                	ld	s2,64(sp)
 1e8:	79e2                	ld	s3,56(sp)
 1ea:	7a42                	ld	s4,48(sp)
 1ec:	7aa2                	ld	s5,40(sp)
 1ee:	7b02                	ld	s6,32(sp)
 1f0:	6be2                	ld	s7,24(sp)
 1f2:	6125                	addi	sp,sp,96
 1f4:	8082                	ret

00000000000001f6 <stat>:

int
stat(const char *n, struct stat *st)
{
 1f6:	1101                	addi	sp,sp,-32
 1f8:	ec06                	sd	ra,24(sp)
 1fa:	e822                	sd	s0,16(sp)
 1fc:	e426                	sd	s1,8(sp)
 1fe:	e04a                	sd	s2,0(sp)
 200:	1000                	addi	s0,sp,32
 202:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 204:	4581                	li	a1,0
 206:	160000ef          	jal	ra,366 <open>
  if(fd < 0)
 20a:	02054163          	bltz	a0,22c <stat+0x36>
 20e:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 210:	85ca                	mv	a1,s2
 212:	16c000ef          	jal	ra,37e <fstat>
 216:	892a                	mv	s2,a0
  close(fd);
 218:	8526                	mv	a0,s1
 21a:	134000ef          	jal	ra,34e <close>
  return r;
}
 21e:	854a                	mv	a0,s2
 220:	60e2                	ld	ra,24(sp)
 222:	6442                	ld	s0,16(sp)
 224:	64a2                	ld	s1,8(sp)
 226:	6902                	ld	s2,0(sp)
 228:	6105                	addi	sp,sp,32
 22a:	8082                	ret
    return -1;
 22c:	597d                	li	s2,-1
 22e:	bfc5                	j	21e <stat+0x28>

0000000000000230 <atoi>:

int
atoi(const char *s)
{
 230:	1141                	addi	sp,sp,-16
 232:	e422                	sd	s0,8(sp)
 234:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 236:	00054683          	lbu	a3,0(a0)
 23a:	fd06879b          	addiw	a5,a3,-48
 23e:	0ff7f793          	zext.b	a5,a5
 242:	4625                	li	a2,9
 244:	02f66863          	bltu	a2,a5,274 <atoi+0x44>
 248:	872a                	mv	a4,a0
  n = 0;
 24a:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 24c:	0705                	addi	a4,a4,1
 24e:	0025179b          	slliw	a5,a0,0x2
 252:	9fa9                	addw	a5,a5,a0
 254:	0017979b          	slliw	a5,a5,0x1
 258:	9fb5                	addw	a5,a5,a3
 25a:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 25e:	00074683          	lbu	a3,0(a4)
 262:	fd06879b          	addiw	a5,a3,-48
 266:	0ff7f793          	zext.b	a5,a5
 26a:	fef671e3          	bgeu	a2,a5,24c <atoi+0x1c>
  return n;
}
 26e:	6422                	ld	s0,8(sp)
 270:	0141                	addi	sp,sp,16
 272:	8082                	ret
  n = 0;
 274:	4501                	li	a0,0
 276:	bfe5                	j	26e <atoi+0x3e>

0000000000000278 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 278:	1141                	addi	sp,sp,-16
 27a:	e422                	sd	s0,8(sp)
 27c:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 27e:	02b57463          	bgeu	a0,a1,2a6 <memmove+0x2e>
    while(n-- > 0)
 282:	00c05f63          	blez	a2,2a0 <memmove+0x28>
 286:	1602                	slli	a2,a2,0x20
 288:	9201                	srli	a2,a2,0x20
 28a:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 28e:	872a                	mv	a4,a0
      *dst++ = *src++;
 290:	0585                	addi	a1,a1,1
 292:	0705                	addi	a4,a4,1
 294:	fff5c683          	lbu	a3,-1(a1)
 298:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 29c:	fee79ae3          	bne	a5,a4,290 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2a0:	6422                	ld	s0,8(sp)
 2a2:	0141                	addi	sp,sp,16
 2a4:	8082                	ret
    dst += n;
 2a6:	00c50733          	add	a4,a0,a2
    src += n;
 2aa:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2ac:	fec05ae3          	blez	a2,2a0 <memmove+0x28>
 2b0:	fff6079b          	addiw	a5,a2,-1
 2b4:	1782                	slli	a5,a5,0x20
 2b6:	9381                	srli	a5,a5,0x20
 2b8:	fff7c793          	not	a5,a5
 2bc:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2be:	15fd                	addi	a1,a1,-1
 2c0:	177d                	addi	a4,a4,-1
 2c2:	0005c683          	lbu	a3,0(a1)
 2c6:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2ca:	fee79ae3          	bne	a5,a4,2be <memmove+0x46>
 2ce:	bfc9                	j	2a0 <memmove+0x28>

00000000000002d0 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2d0:	1141                	addi	sp,sp,-16
 2d2:	e422                	sd	s0,8(sp)
 2d4:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2d6:	ca05                	beqz	a2,306 <memcmp+0x36>
 2d8:	fff6069b          	addiw	a3,a2,-1
 2dc:	1682                	slli	a3,a3,0x20
 2de:	9281                	srli	a3,a3,0x20
 2e0:	0685                	addi	a3,a3,1
 2e2:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2e4:	00054783          	lbu	a5,0(a0)
 2e8:	0005c703          	lbu	a4,0(a1)
 2ec:	00e79863          	bne	a5,a4,2fc <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 2f0:	0505                	addi	a0,a0,1
    p2++;
 2f2:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2f4:	fed518e3          	bne	a0,a3,2e4 <memcmp+0x14>
  }
  return 0;
 2f8:	4501                	li	a0,0
 2fa:	a019                	j	300 <memcmp+0x30>
      return *p1 - *p2;
 2fc:	40e7853b          	subw	a0,a5,a4
}
 300:	6422                	ld	s0,8(sp)
 302:	0141                	addi	sp,sp,16
 304:	8082                	ret
  return 0;
 306:	4501                	li	a0,0
 308:	bfe5                	j	300 <memcmp+0x30>

000000000000030a <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 30a:	1141                	addi	sp,sp,-16
 30c:	e406                	sd	ra,8(sp)
 30e:	e022                	sd	s0,0(sp)
 310:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 312:	f67ff0ef          	jal	ra,278 <memmove>
}
 316:	60a2                	ld	ra,8(sp)
 318:	6402                	ld	s0,0(sp)
 31a:	0141                	addi	sp,sp,16
 31c:	8082                	ret

000000000000031e <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 31e:	4885                	li	a7,1
 ecall
 320:	00000073          	ecall
 ret
 324:	8082                	ret

0000000000000326 <exit>:
.global exit
exit:
 li a7, SYS_exit
 326:	4889                	li	a7,2
 ecall
 328:	00000073          	ecall
 ret
 32c:	8082                	ret

000000000000032e <wait>:
.global wait
wait:
 li a7, SYS_wait
 32e:	488d                	li	a7,3
 ecall
 330:	00000073          	ecall
 ret
 334:	8082                	ret

0000000000000336 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 336:	4891                	li	a7,4
 ecall
 338:	00000073          	ecall
 ret
 33c:	8082                	ret

000000000000033e <read>:
.global read
read:
 li a7, SYS_read
 33e:	4895                	li	a7,5
 ecall
 340:	00000073          	ecall
 ret
 344:	8082                	ret

0000000000000346 <write>:
.global write
write:
 li a7, SYS_write
 346:	48c1                	li	a7,16
 ecall
 348:	00000073          	ecall
 ret
 34c:	8082                	ret

000000000000034e <close>:
.global close
close:
 li a7, SYS_close
 34e:	48d5                	li	a7,21
 ecall
 350:	00000073          	ecall
 ret
 354:	8082                	ret

0000000000000356 <kill>:
.global kill
kill:
 li a7, SYS_kill
 356:	4899                	li	a7,6
 ecall
 358:	00000073          	ecall
 ret
 35c:	8082                	ret

000000000000035e <exec>:
.global exec
exec:
 li a7, SYS_exec
 35e:	489d                	li	a7,7
 ecall
 360:	00000073          	ecall
 ret
 364:	8082                	ret

0000000000000366 <open>:
.global open
open:
 li a7, SYS_open
 366:	48bd                	li	a7,15
 ecall
 368:	00000073          	ecall
 ret
 36c:	8082                	ret

000000000000036e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 36e:	48c5                	li	a7,17
 ecall
 370:	00000073          	ecall
 ret
 374:	8082                	ret

0000000000000376 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 376:	48c9                	li	a7,18
 ecall
 378:	00000073          	ecall
 ret
 37c:	8082                	ret

000000000000037e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 37e:	48a1                	li	a7,8
 ecall
 380:	00000073          	ecall
 ret
 384:	8082                	ret

0000000000000386 <link>:
.global link
link:
 li a7, SYS_link
 386:	48cd                	li	a7,19
 ecall
 388:	00000073          	ecall
 ret
 38c:	8082                	ret

000000000000038e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 38e:	48d1                	li	a7,20
 ecall
 390:	00000073          	ecall
 ret
 394:	8082                	ret

0000000000000396 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 396:	48a5                	li	a7,9
 ecall
 398:	00000073          	ecall
 ret
 39c:	8082                	ret

000000000000039e <dup>:
.global dup
dup:
 li a7, SYS_dup
 39e:	48a9                	li	a7,10
 ecall
 3a0:	00000073          	ecall
 ret
 3a4:	8082                	ret

00000000000003a6 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3a6:	48ad                	li	a7,11
 ecall
 3a8:	00000073          	ecall
 ret
 3ac:	8082                	ret

00000000000003ae <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 3ae:	48b1                	li	a7,12
 ecall
 3b0:	00000073          	ecall
 ret
 3b4:	8082                	ret

00000000000003b6 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3b6:	48b5                	li	a7,13
 ecall
 3b8:	00000073          	ecall
 ret
 3bc:	8082                	ret

00000000000003be <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3be:	48b9                	li	a7,14
 ecall
 3c0:	00000073          	ecall
 ret
 3c4:	8082                	ret

00000000000003c6 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3c6:	1101                	addi	sp,sp,-32
 3c8:	ec06                	sd	ra,24(sp)
 3ca:	e822                	sd	s0,16(sp)
 3cc:	1000                	addi	s0,sp,32
 3ce:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3d2:	4605                	li	a2,1
 3d4:	fef40593          	addi	a1,s0,-17
 3d8:	f6fff0ef          	jal	ra,346 <write>
}
 3dc:	60e2                	ld	ra,24(sp)
 3de:	6442                	ld	s0,16(sp)
 3e0:	6105                	addi	sp,sp,32
 3e2:	8082                	ret

00000000000003e4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3e4:	7139                	addi	sp,sp,-64
 3e6:	fc06                	sd	ra,56(sp)
 3e8:	f822                	sd	s0,48(sp)
 3ea:	f426                	sd	s1,40(sp)
 3ec:	f04a                	sd	s2,32(sp)
 3ee:	ec4e                	sd	s3,24(sp)
 3f0:	0080                	addi	s0,sp,64
 3f2:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3f4:	c299                	beqz	a3,3fa <printint+0x16>
 3f6:	0805c763          	bltz	a1,484 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3fa:	2581                	sext.w	a1,a1
  neg = 0;
 3fc:	4881                	li	a7,0
 3fe:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 402:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 404:	2601                	sext.w	a2,a2
 406:	00000517          	auipc	a0,0x0
 40a:	54a50513          	addi	a0,a0,1354 # 950 <digits>
 40e:	883a                	mv	a6,a4
 410:	2705                	addiw	a4,a4,1
 412:	02c5f7bb          	remuw	a5,a1,a2
 416:	1782                	slli	a5,a5,0x20
 418:	9381                	srli	a5,a5,0x20
 41a:	97aa                	add	a5,a5,a0
 41c:	0007c783          	lbu	a5,0(a5)
 420:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 424:	0005879b          	sext.w	a5,a1
 428:	02c5d5bb          	divuw	a1,a1,a2
 42c:	0685                	addi	a3,a3,1
 42e:	fec7f0e3          	bgeu	a5,a2,40e <printint+0x2a>
  if(neg)
 432:	00088c63          	beqz	a7,44a <printint+0x66>
    buf[i++] = '-';
 436:	fd070793          	addi	a5,a4,-48
 43a:	00878733          	add	a4,a5,s0
 43e:	02d00793          	li	a5,45
 442:	fef70823          	sb	a5,-16(a4)
 446:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 44a:	02e05663          	blez	a4,476 <printint+0x92>
 44e:	fc040793          	addi	a5,s0,-64
 452:	00e78933          	add	s2,a5,a4
 456:	fff78993          	addi	s3,a5,-1
 45a:	99ba                	add	s3,s3,a4
 45c:	377d                	addiw	a4,a4,-1
 45e:	1702                	slli	a4,a4,0x20
 460:	9301                	srli	a4,a4,0x20
 462:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 466:	fff94583          	lbu	a1,-1(s2)
 46a:	8526                	mv	a0,s1
 46c:	f5bff0ef          	jal	ra,3c6 <putc>
  while(--i >= 0)
 470:	197d                	addi	s2,s2,-1
 472:	ff391ae3          	bne	s2,s3,466 <printint+0x82>
}
 476:	70e2                	ld	ra,56(sp)
 478:	7442                	ld	s0,48(sp)
 47a:	74a2                	ld	s1,40(sp)
 47c:	7902                	ld	s2,32(sp)
 47e:	69e2                	ld	s3,24(sp)
 480:	6121                	addi	sp,sp,64
 482:	8082                	ret
    x = -xx;
 484:	40b005bb          	negw	a1,a1
    neg = 1;
 488:	4885                	li	a7,1
    x = -xx;
 48a:	bf95                	j	3fe <printint+0x1a>

000000000000048c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 48c:	7119                	addi	sp,sp,-128
 48e:	fc86                	sd	ra,120(sp)
 490:	f8a2                	sd	s0,112(sp)
 492:	f4a6                	sd	s1,104(sp)
 494:	f0ca                	sd	s2,96(sp)
 496:	ecce                	sd	s3,88(sp)
 498:	e8d2                	sd	s4,80(sp)
 49a:	e4d6                	sd	s5,72(sp)
 49c:	e0da                	sd	s6,64(sp)
 49e:	fc5e                	sd	s7,56(sp)
 4a0:	f862                	sd	s8,48(sp)
 4a2:	f466                	sd	s9,40(sp)
 4a4:	f06a                	sd	s10,32(sp)
 4a6:	ec6e                	sd	s11,24(sp)
 4a8:	0100                	addi	s0,sp,128
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4aa:	0005c903          	lbu	s2,0(a1)
 4ae:	22090e63          	beqz	s2,6ea <vprintf+0x25e>
 4b2:	8b2a                	mv	s6,a0
 4b4:	8a2e                	mv	s4,a1
 4b6:	8bb2                	mv	s7,a2
  state = 0;
 4b8:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 4ba:	4481                	li	s1,0
 4bc:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 4be:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 4c2:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 4c6:	06c00d13          	li	s10,108
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 4ca:	07500d93          	li	s11,117
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 4ce:	00000c97          	auipc	s9,0x0
 4d2:	482c8c93          	addi	s9,s9,1154 # 950 <digits>
 4d6:	a005                	j	4f6 <vprintf+0x6a>
        putc(fd, c0);
 4d8:	85ca                	mv	a1,s2
 4da:	855a                	mv	a0,s6
 4dc:	eebff0ef          	jal	ra,3c6 <putc>
 4e0:	a019                	j	4e6 <vprintf+0x5a>
    } else if(state == '%'){
 4e2:	03598263          	beq	s3,s5,506 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 4e6:	2485                	addiw	s1,s1,1
 4e8:	8726                	mv	a4,s1
 4ea:	009a07b3          	add	a5,s4,s1
 4ee:	0007c903          	lbu	s2,0(a5)
 4f2:	1e090c63          	beqz	s2,6ea <vprintf+0x25e>
    c0 = fmt[i] & 0xff;
 4f6:	0009079b          	sext.w	a5,s2
    if(state == 0){
 4fa:	fe0994e3          	bnez	s3,4e2 <vprintf+0x56>
      if(c0 == '%'){
 4fe:	fd579de3          	bne	a5,s5,4d8 <vprintf+0x4c>
        state = '%';
 502:	89be                	mv	s3,a5
 504:	b7cd                	j	4e6 <vprintf+0x5a>
      if(c0) c1 = fmt[i+1] & 0xff;
 506:	cfa5                	beqz	a5,57e <vprintf+0xf2>
 508:	00ea06b3          	add	a3,s4,a4
 50c:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 510:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 512:	c681                	beqz	a3,51a <vprintf+0x8e>
 514:	9752                	add	a4,a4,s4
 516:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 51a:	03878a63          	beq	a5,s8,54e <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 51e:	05a78463          	beq	a5,s10,566 <vprintf+0xda>
      } else if(c0 == 'u'){
 522:	0db78763          	beq	a5,s11,5f0 <vprintf+0x164>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 526:	07800713          	li	a4,120
 52a:	10e78963          	beq	a5,a4,63c <vprintf+0x1b0>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 52e:	07000713          	li	a4,112
 532:	12e78e63          	beq	a5,a4,66e <vprintf+0x1e2>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 536:	07300713          	li	a4,115
 53a:	16e78b63          	beq	a5,a4,6b0 <vprintf+0x224>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 53e:	05579063          	bne	a5,s5,57e <vprintf+0xf2>
        putc(fd, '%');
 542:	85d6                	mv	a1,s5
 544:	855a                	mv	a0,s6
 546:	e81ff0ef          	jal	ra,3c6 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 54a:	4981                	li	s3,0
 54c:	bf69                	j	4e6 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 1);
 54e:	008b8913          	addi	s2,s7,8
 552:	4685                	li	a3,1
 554:	4629                	li	a2,10
 556:	000ba583          	lw	a1,0(s7)
 55a:	855a                	mv	a0,s6
 55c:	e89ff0ef          	jal	ra,3e4 <printint>
 560:	8bca                	mv	s7,s2
      state = 0;
 562:	4981                	li	s3,0
 564:	b749                	j	4e6 <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'd'){
 566:	03868663          	beq	a3,s8,592 <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 56a:	05a68163          	beq	a3,s10,5ac <vprintf+0x120>
      } else if(c0 == 'l' && c1 == 'u'){
 56e:	09b68d63          	beq	a3,s11,608 <vprintf+0x17c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 572:	03a68f63          	beq	a3,s10,5b0 <vprintf+0x124>
      } else if(c0 == 'l' && c1 == 'x'){
 576:	07800793          	li	a5,120
 57a:	0cf68d63          	beq	a3,a5,654 <vprintf+0x1c8>
        putc(fd, '%');
 57e:	85d6                	mv	a1,s5
 580:	855a                	mv	a0,s6
 582:	e45ff0ef          	jal	ra,3c6 <putc>
        putc(fd, c0);
 586:	85ca                	mv	a1,s2
 588:	855a                	mv	a0,s6
 58a:	e3dff0ef          	jal	ra,3c6 <putc>
      state = 0;
 58e:	4981                	li	s3,0
 590:	bf99                	j	4e6 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 592:	008b8913          	addi	s2,s7,8
 596:	4685                	li	a3,1
 598:	4629                	li	a2,10
 59a:	000ba583          	lw	a1,0(s7)
 59e:	855a                	mv	a0,s6
 5a0:	e45ff0ef          	jal	ra,3e4 <printint>
        i += 1;
 5a4:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 5a6:	8bca                	mv	s7,s2
      state = 0;
 5a8:	4981                	li	s3,0
        i += 1;
 5aa:	bf35                	j	4e6 <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5ac:	03860563          	beq	a2,s8,5d6 <vprintf+0x14a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 5b0:	07b60963          	beq	a2,s11,622 <vprintf+0x196>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 5b4:	07800793          	li	a5,120
 5b8:	fcf613e3          	bne	a2,a5,57e <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5bc:	008b8913          	addi	s2,s7,8
 5c0:	4681                	li	a3,0
 5c2:	4641                	li	a2,16
 5c4:	000ba583          	lw	a1,0(s7)
 5c8:	855a                	mv	a0,s6
 5ca:	e1bff0ef          	jal	ra,3e4 <printint>
        i += 2;
 5ce:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 5d0:	8bca                	mv	s7,s2
      state = 0;
 5d2:	4981                	li	s3,0
        i += 2;
 5d4:	bf09                	j	4e6 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5d6:	008b8913          	addi	s2,s7,8
 5da:	4685                	li	a3,1
 5dc:	4629                	li	a2,10
 5de:	000ba583          	lw	a1,0(s7)
 5e2:	855a                	mv	a0,s6
 5e4:	e01ff0ef          	jal	ra,3e4 <printint>
        i += 2;
 5e8:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 5ea:	8bca                	mv	s7,s2
      state = 0;
 5ec:	4981                	li	s3,0
        i += 2;
 5ee:	bde5                	j	4e6 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 0);
 5f0:	008b8913          	addi	s2,s7,8
 5f4:	4681                	li	a3,0
 5f6:	4629                	li	a2,10
 5f8:	000ba583          	lw	a1,0(s7)
 5fc:	855a                	mv	a0,s6
 5fe:	de7ff0ef          	jal	ra,3e4 <printint>
 602:	8bca                	mv	s7,s2
      state = 0;
 604:	4981                	li	s3,0
 606:	b5c5                	j	4e6 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 608:	008b8913          	addi	s2,s7,8
 60c:	4681                	li	a3,0
 60e:	4629                	li	a2,10
 610:	000ba583          	lw	a1,0(s7)
 614:	855a                	mv	a0,s6
 616:	dcfff0ef          	jal	ra,3e4 <printint>
        i += 1;
 61a:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 61c:	8bca                	mv	s7,s2
      state = 0;
 61e:	4981                	li	s3,0
        i += 1;
 620:	b5d9                	j	4e6 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 622:	008b8913          	addi	s2,s7,8
 626:	4681                	li	a3,0
 628:	4629                	li	a2,10
 62a:	000ba583          	lw	a1,0(s7)
 62e:	855a                	mv	a0,s6
 630:	db5ff0ef          	jal	ra,3e4 <printint>
        i += 2;
 634:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 636:	8bca                	mv	s7,s2
      state = 0;
 638:	4981                	li	s3,0
        i += 2;
 63a:	b575                	j	4e6 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 16, 0);
 63c:	008b8913          	addi	s2,s7,8
 640:	4681                	li	a3,0
 642:	4641                	li	a2,16
 644:	000ba583          	lw	a1,0(s7)
 648:	855a                	mv	a0,s6
 64a:	d9bff0ef          	jal	ra,3e4 <printint>
 64e:	8bca                	mv	s7,s2
      state = 0;
 650:	4981                	li	s3,0
 652:	bd51                	j	4e6 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 654:	008b8913          	addi	s2,s7,8
 658:	4681                	li	a3,0
 65a:	4641                	li	a2,16
 65c:	000ba583          	lw	a1,0(s7)
 660:	855a                	mv	a0,s6
 662:	d83ff0ef          	jal	ra,3e4 <printint>
        i += 1;
 666:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 668:	8bca                	mv	s7,s2
      state = 0;
 66a:	4981                	li	s3,0
        i += 1;
 66c:	bdad                	j	4e6 <vprintf+0x5a>
        printptr(fd, va_arg(ap, uint64));
 66e:	008b8793          	addi	a5,s7,8
 672:	f8f43423          	sd	a5,-120(s0)
 676:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 67a:	03000593          	li	a1,48
 67e:	855a                	mv	a0,s6
 680:	d47ff0ef          	jal	ra,3c6 <putc>
  putc(fd, 'x');
 684:	07800593          	li	a1,120
 688:	855a                	mv	a0,s6
 68a:	d3dff0ef          	jal	ra,3c6 <putc>
 68e:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 690:	03c9d793          	srli	a5,s3,0x3c
 694:	97e6                	add	a5,a5,s9
 696:	0007c583          	lbu	a1,0(a5)
 69a:	855a                	mv	a0,s6
 69c:	d2bff0ef          	jal	ra,3c6 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6a0:	0992                	slli	s3,s3,0x4
 6a2:	397d                	addiw	s2,s2,-1
 6a4:	fe0916e3          	bnez	s2,690 <vprintf+0x204>
        printptr(fd, va_arg(ap, uint64));
 6a8:	f8843b83          	ld	s7,-120(s0)
      state = 0;
 6ac:	4981                	li	s3,0
 6ae:	bd25                	j	4e6 <vprintf+0x5a>
        if((s = va_arg(ap, char*)) == 0)
 6b0:	008b8993          	addi	s3,s7,8
 6b4:	000bb903          	ld	s2,0(s7)
 6b8:	00090f63          	beqz	s2,6d6 <vprintf+0x24a>
        for(; *s; s++)
 6bc:	00094583          	lbu	a1,0(s2)
 6c0:	c195                	beqz	a1,6e4 <vprintf+0x258>
          putc(fd, *s);
 6c2:	855a                	mv	a0,s6
 6c4:	d03ff0ef          	jal	ra,3c6 <putc>
        for(; *s; s++)
 6c8:	0905                	addi	s2,s2,1
 6ca:	00094583          	lbu	a1,0(s2)
 6ce:	f9f5                	bnez	a1,6c2 <vprintf+0x236>
        if((s = va_arg(ap, char*)) == 0)
 6d0:	8bce                	mv	s7,s3
      state = 0;
 6d2:	4981                	li	s3,0
 6d4:	bd09                	j	4e6 <vprintf+0x5a>
          s = "(null)";
 6d6:	00000917          	auipc	s2,0x0
 6da:	27290913          	addi	s2,s2,626 # 948 <malloc+0x162>
        for(; *s; s++)
 6de:	02800593          	li	a1,40
 6e2:	b7c5                	j	6c2 <vprintf+0x236>
        if((s = va_arg(ap, char*)) == 0)
 6e4:	8bce                	mv	s7,s3
      state = 0;
 6e6:	4981                	li	s3,0
 6e8:	bbfd                	j	4e6 <vprintf+0x5a>
    }
  }
}
 6ea:	70e6                	ld	ra,120(sp)
 6ec:	7446                	ld	s0,112(sp)
 6ee:	74a6                	ld	s1,104(sp)
 6f0:	7906                	ld	s2,96(sp)
 6f2:	69e6                	ld	s3,88(sp)
 6f4:	6a46                	ld	s4,80(sp)
 6f6:	6aa6                	ld	s5,72(sp)
 6f8:	6b06                	ld	s6,64(sp)
 6fa:	7be2                	ld	s7,56(sp)
 6fc:	7c42                	ld	s8,48(sp)
 6fe:	7ca2                	ld	s9,40(sp)
 700:	7d02                	ld	s10,32(sp)
 702:	6de2                	ld	s11,24(sp)
 704:	6109                	addi	sp,sp,128
 706:	8082                	ret

0000000000000708 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 708:	715d                	addi	sp,sp,-80
 70a:	ec06                	sd	ra,24(sp)
 70c:	e822                	sd	s0,16(sp)
 70e:	1000                	addi	s0,sp,32
 710:	e010                	sd	a2,0(s0)
 712:	e414                	sd	a3,8(s0)
 714:	e818                	sd	a4,16(s0)
 716:	ec1c                	sd	a5,24(s0)
 718:	03043023          	sd	a6,32(s0)
 71c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 720:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 724:	8622                	mv	a2,s0
 726:	d67ff0ef          	jal	ra,48c <vprintf>
}
 72a:	60e2                	ld	ra,24(sp)
 72c:	6442                	ld	s0,16(sp)
 72e:	6161                	addi	sp,sp,80
 730:	8082                	ret

0000000000000732 <printf>:

void
printf(const char *fmt, ...)
{
 732:	711d                	addi	sp,sp,-96
 734:	ec06                	sd	ra,24(sp)
 736:	e822                	sd	s0,16(sp)
 738:	1000                	addi	s0,sp,32
 73a:	e40c                	sd	a1,8(s0)
 73c:	e810                	sd	a2,16(s0)
 73e:	ec14                	sd	a3,24(s0)
 740:	f018                	sd	a4,32(s0)
 742:	f41c                	sd	a5,40(s0)
 744:	03043823          	sd	a6,48(s0)
 748:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 74c:	00840613          	addi	a2,s0,8
 750:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 754:	85aa                	mv	a1,a0
 756:	4505                	li	a0,1
 758:	d35ff0ef          	jal	ra,48c <vprintf>
}
 75c:	60e2                	ld	ra,24(sp)
 75e:	6442                	ld	s0,16(sp)
 760:	6125                	addi	sp,sp,96
 762:	8082                	ret

0000000000000764 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 764:	1141                	addi	sp,sp,-16
 766:	e422                	sd	s0,8(sp)
 768:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 76a:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 76e:	00001797          	auipc	a5,0x1
 772:	8a27b783          	ld	a5,-1886(a5) # 1010 <freep>
 776:	a02d                	j	7a0 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 778:	4618                	lw	a4,8(a2)
 77a:	9f2d                	addw	a4,a4,a1
 77c:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 780:	6398                	ld	a4,0(a5)
 782:	6310                	ld	a2,0(a4)
 784:	a83d                	j	7c2 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 786:	ff852703          	lw	a4,-8(a0)
 78a:	9f31                	addw	a4,a4,a2
 78c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 78e:	ff053683          	ld	a3,-16(a0)
 792:	a091                	j	7d6 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 794:	6398                	ld	a4,0(a5)
 796:	00e7e463          	bltu	a5,a4,79e <free+0x3a>
 79a:	00e6ea63          	bltu	a3,a4,7ae <free+0x4a>
{
 79e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7a0:	fed7fae3          	bgeu	a5,a3,794 <free+0x30>
 7a4:	6398                	ld	a4,0(a5)
 7a6:	00e6e463          	bltu	a3,a4,7ae <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7aa:	fee7eae3          	bltu	a5,a4,79e <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 7ae:	ff852583          	lw	a1,-8(a0)
 7b2:	6390                	ld	a2,0(a5)
 7b4:	02059813          	slli	a6,a1,0x20
 7b8:	01c85713          	srli	a4,a6,0x1c
 7bc:	9736                	add	a4,a4,a3
 7be:	fae60de3          	beq	a2,a4,778 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 7c2:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7c6:	4790                	lw	a2,8(a5)
 7c8:	02061593          	slli	a1,a2,0x20
 7cc:	01c5d713          	srli	a4,a1,0x1c
 7d0:	973e                	add	a4,a4,a5
 7d2:	fae68ae3          	beq	a3,a4,786 <free+0x22>
    p->s.ptr = bp->s.ptr;
 7d6:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7d8:	00001717          	auipc	a4,0x1
 7dc:	82f73c23          	sd	a5,-1992(a4) # 1010 <freep>
}
 7e0:	6422                	ld	s0,8(sp)
 7e2:	0141                	addi	sp,sp,16
 7e4:	8082                	ret

00000000000007e6 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7e6:	7139                	addi	sp,sp,-64
 7e8:	fc06                	sd	ra,56(sp)
 7ea:	f822                	sd	s0,48(sp)
 7ec:	f426                	sd	s1,40(sp)
 7ee:	f04a                	sd	s2,32(sp)
 7f0:	ec4e                	sd	s3,24(sp)
 7f2:	e852                	sd	s4,16(sp)
 7f4:	e456                	sd	s5,8(sp)
 7f6:	e05a                	sd	s6,0(sp)
 7f8:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7fa:	02051493          	slli	s1,a0,0x20
 7fe:	9081                	srli	s1,s1,0x20
 800:	04bd                	addi	s1,s1,15
 802:	8091                	srli	s1,s1,0x4
 804:	0014899b          	addiw	s3,s1,1
 808:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 80a:	00001517          	auipc	a0,0x1
 80e:	80653503          	ld	a0,-2042(a0) # 1010 <freep>
 812:	c515                	beqz	a0,83e <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 814:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 816:	4798                	lw	a4,8(a5)
 818:	02977f63          	bgeu	a4,s1,856 <malloc+0x70>
 81c:	8a4e                	mv	s4,s3
 81e:	0009871b          	sext.w	a4,s3
 822:	6685                	lui	a3,0x1
 824:	00d77363          	bgeu	a4,a3,82a <malloc+0x44>
 828:	6a05                	lui	s4,0x1
 82a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 82e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 832:	00000917          	auipc	s2,0x0
 836:	7de90913          	addi	s2,s2,2014 # 1010 <freep>
  if(p == (char*)-1)
 83a:	5afd                	li	s5,-1
 83c:	a885                	j	8ac <malloc+0xc6>
    base.s.ptr = freep = prevp = &base;
 83e:	00000797          	auipc	a5,0x0
 842:	7e278793          	addi	a5,a5,2018 # 1020 <base>
 846:	00000717          	auipc	a4,0x0
 84a:	7cf73523          	sd	a5,1994(a4) # 1010 <freep>
 84e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 850:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 854:	b7e1                	j	81c <malloc+0x36>
      if(p->s.size == nunits)
 856:	02e48c63          	beq	s1,a4,88e <malloc+0xa8>
        p->s.size -= nunits;
 85a:	4137073b          	subw	a4,a4,s3
 85e:	c798                	sw	a4,8(a5)
        p += p->s.size;
 860:	02071693          	slli	a3,a4,0x20
 864:	01c6d713          	srli	a4,a3,0x1c
 868:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 86a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 86e:	00000717          	auipc	a4,0x0
 872:	7aa73123          	sd	a0,1954(a4) # 1010 <freep>
      return (void*)(p + 1);
 876:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 87a:	70e2                	ld	ra,56(sp)
 87c:	7442                	ld	s0,48(sp)
 87e:	74a2                	ld	s1,40(sp)
 880:	7902                	ld	s2,32(sp)
 882:	69e2                	ld	s3,24(sp)
 884:	6a42                	ld	s4,16(sp)
 886:	6aa2                	ld	s5,8(sp)
 888:	6b02                	ld	s6,0(sp)
 88a:	6121                	addi	sp,sp,64
 88c:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 88e:	6398                	ld	a4,0(a5)
 890:	e118                	sd	a4,0(a0)
 892:	bff1                	j	86e <malloc+0x88>
  hp->s.size = nu;
 894:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 898:	0541                	addi	a0,a0,16
 89a:	ecbff0ef          	jal	ra,764 <free>
  return freep;
 89e:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 8a2:	dd61                	beqz	a0,87a <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8a4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8a6:	4798                	lw	a4,8(a5)
 8a8:	fa9777e3          	bgeu	a4,s1,856 <malloc+0x70>
    if(p == freep)
 8ac:	00093703          	ld	a4,0(s2)
 8b0:	853e                	mv	a0,a5
 8b2:	fef719e3          	bne	a4,a5,8a4 <malloc+0xbe>
  p = sbrk(nu * sizeof(Header));
 8b6:	8552                	mv	a0,s4
 8b8:	af7ff0ef          	jal	ra,3ae <sbrk>
  if(p == (char*)-1)
 8bc:	fd551ce3          	bne	a0,s5,894 <malloc+0xae>
        return 0;
 8c0:	4501                	li	a0,0
 8c2:	bf65                	j	87a <malloc+0x94>
