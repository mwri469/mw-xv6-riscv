
user/_pingpong:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int main(int argc, char *argv[])
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	1800                	addi	s0,sp,48
    int pipe_pc[2], pipe_cp[2];
    char buff[5];
    int pid;

    // Init pipes
    if (pipe(pipe_pc) < 0 || pipe(pipe_cp) < 0) {
   8:	fe840513          	addi	a0,s0,-24
   c:	3d6000ef          	jal	ra,3e2 <pipe>
  10:	00054863          	bltz	a0,20 <main+0x20>
  14:	fe040513          	addi	a0,s0,-32
  18:	3ca000ef          	jal	ra,3e2 <pipe>
  1c:	00055c63          	bgez	a0,34 <main+0x34>
        fprintf(2, "Error opening pipe\n");
  20:	00001597          	auipc	a1,0x1
  24:	95058593          	addi	a1,a1,-1712 # 970 <malloc+0xde>
  28:	4509                	li	a0,2
  2a:	78a000ef          	jal	ra,7b4 <fprintf>
        exit(1);
  2e:	4505                	li	a0,1
  30:	3a2000ef          	jal	ra,3d2 <exit>
    }

    pid = fork();
  34:	396000ef          	jal	ra,3ca <fork>
    if (pid == 0) {
  38:	c511                	beqz	a0,44 <main+0x44>
        if (write(pipe_cp[1], "ping", 5) < 5) {
            fprintf(2, "%d: error writing in child process\n", getpid());
        }
        close(pipe_cp[1]);

    } else if (pid > 0) {
  3a:	08a04e63          	bgtz	a0,d6 <main+0xd6>
            fprintf(2, "%d: error reading in parent process\n", getpid());
        }
        close(pipe_cp[0]);
    }

    exit(0);
  3e:	4501                	li	a0,0
  40:	392000ef          	jal	ra,3d2 <exit>
        close(pipe_pc[1]); // Close write end of parent-to-child pipe
  44:	fec42503          	lw	a0,-20(s0)
  48:	3b2000ef          	jal	ra,3fa <close>
        close(pipe_cp[0]); // Close read end of child-to-parent pipe
  4c:	fe042503          	lw	a0,-32(s0)
  50:	3aa000ef          	jal	ra,3fa <close>
        if (read(pipe_pc[0], buff, 5) == 5) {
  54:	4615                	li	a2,5
  56:	fd840593          	addi	a1,s0,-40
  5a:	fe842503          	lw	a0,-24(s0)
  5e:	38c000ef          	jal	ra,3ea <read>
  62:	4795                	li	a5,5
  64:	04f50163          	beq	a0,a5,a6 <main+0xa6>
            fprintf(2, "%d: error reading in child process\n", getpid());
  68:	3ea000ef          	jal	ra,452 <getpid>
  6c:	862a                	mv	a2,a0
  6e:	00001597          	auipc	a1,0x1
  72:	93258593          	addi	a1,a1,-1742 # 9a0 <malloc+0x10e>
  76:	4509                	li	a0,2
  78:	73c000ef          	jal	ra,7b4 <fprintf>
        close(pipe_pc[0]);
  7c:	fe842503          	lw	a0,-24(s0)
  80:	37a000ef          	jal	ra,3fa <close>
        if (write(pipe_cp[1], "ping", 5) < 5) {
  84:	4615                	li	a2,5
  86:	00001597          	auipc	a1,0x1
  8a:	94258593          	addi	a1,a1,-1726 # 9c8 <malloc+0x136>
  8e:	fe442503          	lw	a0,-28(s0)
  92:	360000ef          	jal	ra,3f2 <write>
  96:	4791                	li	a5,4
  98:	02a7d463          	bge	a5,a0,c0 <main+0xc0>
        close(pipe_cp[1]);
  9c:	fe442503          	lw	a0,-28(s0)
  a0:	35a000ef          	jal	ra,3fa <close>
  a4:	bf69                	j	3e <main+0x3e>
            fprintf(1, "%d: received %s\n", getpid(), buff);
  a6:	3ac000ef          	jal	ra,452 <getpid>
  aa:	862a                	mv	a2,a0
  ac:	fd840693          	addi	a3,s0,-40
  b0:	00001597          	auipc	a1,0x1
  b4:	8d858593          	addi	a1,a1,-1832 # 988 <malloc+0xf6>
  b8:	4505                	li	a0,1
  ba:	6fa000ef          	jal	ra,7b4 <fprintf>
  be:	bf7d                	j	7c <main+0x7c>
            fprintf(2, "%d: error writing in child process\n", getpid());
  c0:	392000ef          	jal	ra,452 <getpid>
  c4:	862a                	mv	a2,a0
  c6:	00001597          	auipc	a1,0x1
  ca:	90a58593          	addi	a1,a1,-1782 # 9d0 <malloc+0x13e>
  ce:	4509                	li	a0,2
  d0:	6e4000ef          	jal	ra,7b4 <fprintf>
  d4:	b7e1                	j	9c <main+0x9c>
        close(pipe_pc[0]); // Close read end of parent-to-child pipe
  d6:	fe842503          	lw	a0,-24(s0)
  da:	320000ef          	jal	ra,3fa <close>
        close(pipe_cp[1]); // Close write end of child-to-parent pipe
  de:	fe442503          	lw	a0,-28(s0)
  e2:	318000ef          	jal	ra,3fa <close>
        if (write(pipe_pc[1], "pong", 5) < 5) {
  e6:	4615                	li	a2,5
  e8:	00001597          	auipc	a1,0x1
  ec:	91058593          	addi	a1,a1,-1776 # 9f8 <malloc+0x166>
  f0:	fec42503          	lw	a0,-20(s0)
  f4:	2fe000ef          	jal	ra,3f2 <write>
  f8:	4791                	li	a5,4
  fa:	02a7df63          	bge	a5,a0,138 <main+0x138>
        close(pipe_pc[1]);
  fe:	fec42503          	lw	a0,-20(s0)
 102:	2f8000ef          	jal	ra,3fa <close>
        if (read(pipe_cp[0], buff, 5) == 5) {
 106:	4615                	li	a2,5
 108:	fd840593          	addi	a1,s0,-40
 10c:	fe042503          	lw	a0,-32(s0)
 110:	2da000ef          	jal	ra,3ea <read>
 114:	4795                	li	a5,5
 116:	02f50c63          	beq	a0,a5,14e <main+0x14e>
            fprintf(2, "%d: error reading in parent process\n", getpid());
 11a:	338000ef          	jal	ra,452 <getpid>
 11e:	862a                	mv	a2,a0
 120:	00001597          	auipc	a1,0x1
 124:	90858593          	addi	a1,a1,-1784 # a28 <malloc+0x196>
 128:	4509                	li	a0,2
 12a:	68a000ef          	jal	ra,7b4 <fprintf>
        close(pipe_cp[0]);
 12e:	fe042503          	lw	a0,-32(s0)
 132:	2c8000ef          	jal	ra,3fa <close>
 136:	b721                	j	3e <main+0x3e>
            fprintf(2, "%d: error writing in parent process\n", getpid());
 138:	31a000ef          	jal	ra,452 <getpid>
 13c:	862a                	mv	a2,a0
 13e:	00001597          	auipc	a1,0x1
 142:	8c258593          	addi	a1,a1,-1854 # a00 <malloc+0x16e>
 146:	4509                	li	a0,2
 148:	66c000ef          	jal	ra,7b4 <fprintf>
 14c:	bf4d                	j	fe <main+0xfe>
            fprintf(1, "%d: received %s\n", getpid(), buff);
 14e:	304000ef          	jal	ra,452 <getpid>
 152:	862a                	mv	a2,a0
 154:	fd840693          	addi	a3,s0,-40
 158:	00001597          	auipc	a1,0x1
 15c:	83058593          	addi	a1,a1,-2000 # 988 <malloc+0xf6>
 160:	4505                	li	a0,1
 162:	652000ef          	jal	ra,7b4 <fprintf>
 166:	b7e1                	j	12e <main+0x12e>

0000000000000168 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 168:	1141                	addi	sp,sp,-16
 16a:	e406                	sd	ra,8(sp)
 16c:	e022                	sd	s0,0(sp)
 16e:	0800                	addi	s0,sp,16
  extern int main();
  main();
 170:	e91ff0ef          	jal	ra,0 <main>
  exit(0);
 174:	4501                	li	a0,0
 176:	25c000ef          	jal	ra,3d2 <exit>

000000000000017a <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 17a:	1141                	addi	sp,sp,-16
 17c:	e422                	sd	s0,8(sp)
 17e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 180:	87aa                	mv	a5,a0
 182:	0585                	addi	a1,a1,1
 184:	0785                	addi	a5,a5,1
 186:	fff5c703          	lbu	a4,-1(a1)
 18a:	fee78fa3          	sb	a4,-1(a5)
 18e:	fb75                	bnez	a4,182 <strcpy+0x8>
    ;
  return os;
}
 190:	6422                	ld	s0,8(sp)
 192:	0141                	addi	sp,sp,16
 194:	8082                	ret

0000000000000196 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 196:	1141                	addi	sp,sp,-16
 198:	e422                	sd	s0,8(sp)
 19a:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 19c:	00054783          	lbu	a5,0(a0)
 1a0:	cb91                	beqz	a5,1b4 <strcmp+0x1e>
 1a2:	0005c703          	lbu	a4,0(a1)
 1a6:	00f71763          	bne	a4,a5,1b4 <strcmp+0x1e>
    p++, q++;
 1aa:	0505                	addi	a0,a0,1
 1ac:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 1ae:	00054783          	lbu	a5,0(a0)
 1b2:	fbe5                	bnez	a5,1a2 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 1b4:	0005c503          	lbu	a0,0(a1)
}
 1b8:	40a7853b          	subw	a0,a5,a0
 1bc:	6422                	ld	s0,8(sp)
 1be:	0141                	addi	sp,sp,16
 1c0:	8082                	ret

00000000000001c2 <strlen>:

uint
strlen(const char *s)
{
 1c2:	1141                	addi	sp,sp,-16
 1c4:	e422                	sd	s0,8(sp)
 1c6:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1c8:	00054783          	lbu	a5,0(a0)
 1cc:	cf91                	beqz	a5,1e8 <strlen+0x26>
 1ce:	0505                	addi	a0,a0,1
 1d0:	87aa                	mv	a5,a0
 1d2:	4685                	li	a3,1
 1d4:	9e89                	subw	a3,a3,a0
 1d6:	00f6853b          	addw	a0,a3,a5
 1da:	0785                	addi	a5,a5,1
 1dc:	fff7c703          	lbu	a4,-1(a5)
 1e0:	fb7d                	bnez	a4,1d6 <strlen+0x14>
    ;
  return n;
}
 1e2:	6422                	ld	s0,8(sp)
 1e4:	0141                	addi	sp,sp,16
 1e6:	8082                	ret
  for(n = 0; s[n]; n++)
 1e8:	4501                	li	a0,0
 1ea:	bfe5                	j	1e2 <strlen+0x20>

00000000000001ec <memset>:

void*
memset(void *dst, int c, uint n)
{
 1ec:	1141                	addi	sp,sp,-16
 1ee:	e422                	sd	s0,8(sp)
 1f0:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1f2:	ca19                	beqz	a2,208 <memset+0x1c>
 1f4:	87aa                	mv	a5,a0
 1f6:	1602                	slli	a2,a2,0x20
 1f8:	9201                	srli	a2,a2,0x20
 1fa:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1fe:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 202:	0785                	addi	a5,a5,1
 204:	fee79de3          	bne	a5,a4,1fe <memset+0x12>
  }
  return dst;
}
 208:	6422                	ld	s0,8(sp)
 20a:	0141                	addi	sp,sp,16
 20c:	8082                	ret

000000000000020e <strchr>:

char*
strchr(const char *s, char c)
{
 20e:	1141                	addi	sp,sp,-16
 210:	e422                	sd	s0,8(sp)
 212:	0800                	addi	s0,sp,16
  for(; *s; s++)
 214:	00054783          	lbu	a5,0(a0)
 218:	cb99                	beqz	a5,22e <strchr+0x20>
    if(*s == c)
 21a:	00f58763          	beq	a1,a5,228 <strchr+0x1a>
  for(; *s; s++)
 21e:	0505                	addi	a0,a0,1
 220:	00054783          	lbu	a5,0(a0)
 224:	fbfd                	bnez	a5,21a <strchr+0xc>
      return (char*)s;
  return 0;
 226:	4501                	li	a0,0
}
 228:	6422                	ld	s0,8(sp)
 22a:	0141                	addi	sp,sp,16
 22c:	8082                	ret
  return 0;
 22e:	4501                	li	a0,0
 230:	bfe5                	j	228 <strchr+0x1a>

0000000000000232 <gets>:

char*
gets(char *buf, int max)
{
 232:	711d                	addi	sp,sp,-96
 234:	ec86                	sd	ra,88(sp)
 236:	e8a2                	sd	s0,80(sp)
 238:	e4a6                	sd	s1,72(sp)
 23a:	e0ca                	sd	s2,64(sp)
 23c:	fc4e                	sd	s3,56(sp)
 23e:	f852                	sd	s4,48(sp)
 240:	f456                	sd	s5,40(sp)
 242:	f05a                	sd	s6,32(sp)
 244:	ec5e                	sd	s7,24(sp)
 246:	1080                	addi	s0,sp,96
 248:	8baa                	mv	s7,a0
 24a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 24c:	892a                	mv	s2,a0
 24e:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 250:	4aa9                	li	s5,10
 252:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 254:	89a6                	mv	s3,s1
 256:	2485                	addiw	s1,s1,1
 258:	0344d663          	bge	s1,s4,284 <gets+0x52>
    cc = read(0, &c, 1);
 25c:	4605                	li	a2,1
 25e:	faf40593          	addi	a1,s0,-81
 262:	4501                	li	a0,0
 264:	186000ef          	jal	ra,3ea <read>
    if(cc < 1)
 268:	00a05e63          	blez	a0,284 <gets+0x52>
    buf[i++] = c;
 26c:	faf44783          	lbu	a5,-81(s0)
 270:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 274:	01578763          	beq	a5,s5,282 <gets+0x50>
 278:	0905                	addi	s2,s2,1
 27a:	fd679de3          	bne	a5,s6,254 <gets+0x22>
  for(i=0; i+1 < max; ){
 27e:	89a6                	mv	s3,s1
 280:	a011                	j	284 <gets+0x52>
 282:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 284:	99de                	add	s3,s3,s7
 286:	00098023          	sb	zero,0(s3)
  return buf;
}
 28a:	855e                	mv	a0,s7
 28c:	60e6                	ld	ra,88(sp)
 28e:	6446                	ld	s0,80(sp)
 290:	64a6                	ld	s1,72(sp)
 292:	6906                	ld	s2,64(sp)
 294:	79e2                	ld	s3,56(sp)
 296:	7a42                	ld	s4,48(sp)
 298:	7aa2                	ld	s5,40(sp)
 29a:	7b02                	ld	s6,32(sp)
 29c:	6be2                	ld	s7,24(sp)
 29e:	6125                	addi	sp,sp,96
 2a0:	8082                	ret

00000000000002a2 <stat>:

int
stat(const char *n, struct stat *st)
{
 2a2:	1101                	addi	sp,sp,-32
 2a4:	ec06                	sd	ra,24(sp)
 2a6:	e822                	sd	s0,16(sp)
 2a8:	e426                	sd	s1,8(sp)
 2aa:	e04a                	sd	s2,0(sp)
 2ac:	1000                	addi	s0,sp,32
 2ae:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2b0:	4581                	li	a1,0
 2b2:	160000ef          	jal	ra,412 <open>
  if(fd < 0)
 2b6:	02054163          	bltz	a0,2d8 <stat+0x36>
 2ba:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2bc:	85ca                	mv	a1,s2
 2be:	16c000ef          	jal	ra,42a <fstat>
 2c2:	892a                	mv	s2,a0
  close(fd);
 2c4:	8526                	mv	a0,s1
 2c6:	134000ef          	jal	ra,3fa <close>
  return r;
}
 2ca:	854a                	mv	a0,s2
 2cc:	60e2                	ld	ra,24(sp)
 2ce:	6442                	ld	s0,16(sp)
 2d0:	64a2                	ld	s1,8(sp)
 2d2:	6902                	ld	s2,0(sp)
 2d4:	6105                	addi	sp,sp,32
 2d6:	8082                	ret
    return -1;
 2d8:	597d                	li	s2,-1
 2da:	bfc5                	j	2ca <stat+0x28>

00000000000002dc <atoi>:

int
atoi(const char *s)
{
 2dc:	1141                	addi	sp,sp,-16
 2de:	e422                	sd	s0,8(sp)
 2e0:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2e2:	00054683          	lbu	a3,0(a0)
 2e6:	fd06879b          	addiw	a5,a3,-48
 2ea:	0ff7f793          	zext.b	a5,a5
 2ee:	4625                	li	a2,9
 2f0:	02f66863          	bltu	a2,a5,320 <atoi+0x44>
 2f4:	872a                	mv	a4,a0
  n = 0;
 2f6:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 2f8:	0705                	addi	a4,a4,1
 2fa:	0025179b          	slliw	a5,a0,0x2
 2fe:	9fa9                	addw	a5,a5,a0
 300:	0017979b          	slliw	a5,a5,0x1
 304:	9fb5                	addw	a5,a5,a3
 306:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 30a:	00074683          	lbu	a3,0(a4)
 30e:	fd06879b          	addiw	a5,a3,-48
 312:	0ff7f793          	zext.b	a5,a5
 316:	fef671e3          	bgeu	a2,a5,2f8 <atoi+0x1c>
  return n;
}
 31a:	6422                	ld	s0,8(sp)
 31c:	0141                	addi	sp,sp,16
 31e:	8082                	ret
  n = 0;
 320:	4501                	li	a0,0
 322:	bfe5                	j	31a <atoi+0x3e>

0000000000000324 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 324:	1141                	addi	sp,sp,-16
 326:	e422                	sd	s0,8(sp)
 328:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 32a:	02b57463          	bgeu	a0,a1,352 <memmove+0x2e>
    while(n-- > 0)
 32e:	00c05f63          	blez	a2,34c <memmove+0x28>
 332:	1602                	slli	a2,a2,0x20
 334:	9201                	srli	a2,a2,0x20
 336:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 33a:	872a                	mv	a4,a0
      *dst++ = *src++;
 33c:	0585                	addi	a1,a1,1
 33e:	0705                	addi	a4,a4,1
 340:	fff5c683          	lbu	a3,-1(a1)
 344:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 348:	fee79ae3          	bne	a5,a4,33c <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 34c:	6422                	ld	s0,8(sp)
 34e:	0141                	addi	sp,sp,16
 350:	8082                	ret
    dst += n;
 352:	00c50733          	add	a4,a0,a2
    src += n;
 356:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 358:	fec05ae3          	blez	a2,34c <memmove+0x28>
 35c:	fff6079b          	addiw	a5,a2,-1
 360:	1782                	slli	a5,a5,0x20
 362:	9381                	srli	a5,a5,0x20
 364:	fff7c793          	not	a5,a5
 368:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 36a:	15fd                	addi	a1,a1,-1
 36c:	177d                	addi	a4,a4,-1
 36e:	0005c683          	lbu	a3,0(a1)
 372:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 376:	fee79ae3          	bne	a5,a4,36a <memmove+0x46>
 37a:	bfc9                	j	34c <memmove+0x28>

000000000000037c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 37c:	1141                	addi	sp,sp,-16
 37e:	e422                	sd	s0,8(sp)
 380:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 382:	ca05                	beqz	a2,3b2 <memcmp+0x36>
 384:	fff6069b          	addiw	a3,a2,-1
 388:	1682                	slli	a3,a3,0x20
 38a:	9281                	srli	a3,a3,0x20
 38c:	0685                	addi	a3,a3,1
 38e:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 390:	00054783          	lbu	a5,0(a0)
 394:	0005c703          	lbu	a4,0(a1)
 398:	00e79863          	bne	a5,a4,3a8 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 39c:	0505                	addi	a0,a0,1
    p2++;
 39e:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 3a0:	fed518e3          	bne	a0,a3,390 <memcmp+0x14>
  }
  return 0;
 3a4:	4501                	li	a0,0
 3a6:	a019                	j	3ac <memcmp+0x30>
      return *p1 - *p2;
 3a8:	40e7853b          	subw	a0,a5,a4
}
 3ac:	6422                	ld	s0,8(sp)
 3ae:	0141                	addi	sp,sp,16
 3b0:	8082                	ret
  return 0;
 3b2:	4501                	li	a0,0
 3b4:	bfe5                	j	3ac <memcmp+0x30>

00000000000003b6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3b6:	1141                	addi	sp,sp,-16
 3b8:	e406                	sd	ra,8(sp)
 3ba:	e022                	sd	s0,0(sp)
 3bc:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 3be:	f67ff0ef          	jal	ra,324 <memmove>
}
 3c2:	60a2                	ld	ra,8(sp)
 3c4:	6402                	ld	s0,0(sp)
 3c6:	0141                	addi	sp,sp,16
 3c8:	8082                	ret

00000000000003ca <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3ca:	4885                	li	a7,1
 ecall
 3cc:	00000073          	ecall
 ret
 3d0:	8082                	ret

00000000000003d2 <exit>:
.global exit
exit:
 li a7, SYS_exit
 3d2:	4889                	li	a7,2
 ecall
 3d4:	00000073          	ecall
 ret
 3d8:	8082                	ret

00000000000003da <wait>:
.global wait
wait:
 li a7, SYS_wait
 3da:	488d                	li	a7,3
 ecall
 3dc:	00000073          	ecall
 ret
 3e0:	8082                	ret

00000000000003e2 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3e2:	4891                	li	a7,4
 ecall
 3e4:	00000073          	ecall
 ret
 3e8:	8082                	ret

00000000000003ea <read>:
.global read
read:
 li a7, SYS_read
 3ea:	4895                	li	a7,5
 ecall
 3ec:	00000073          	ecall
 ret
 3f0:	8082                	ret

00000000000003f2 <write>:
.global write
write:
 li a7, SYS_write
 3f2:	48c1                	li	a7,16
 ecall
 3f4:	00000073          	ecall
 ret
 3f8:	8082                	ret

00000000000003fa <close>:
.global close
close:
 li a7, SYS_close
 3fa:	48d5                	li	a7,21
 ecall
 3fc:	00000073          	ecall
 ret
 400:	8082                	ret

0000000000000402 <kill>:
.global kill
kill:
 li a7, SYS_kill
 402:	4899                	li	a7,6
 ecall
 404:	00000073          	ecall
 ret
 408:	8082                	ret

000000000000040a <exec>:
.global exec
exec:
 li a7, SYS_exec
 40a:	489d                	li	a7,7
 ecall
 40c:	00000073          	ecall
 ret
 410:	8082                	ret

0000000000000412 <open>:
.global open
open:
 li a7, SYS_open
 412:	48bd                	li	a7,15
 ecall
 414:	00000073          	ecall
 ret
 418:	8082                	ret

000000000000041a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 41a:	48c5                	li	a7,17
 ecall
 41c:	00000073          	ecall
 ret
 420:	8082                	ret

0000000000000422 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 422:	48c9                	li	a7,18
 ecall
 424:	00000073          	ecall
 ret
 428:	8082                	ret

000000000000042a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 42a:	48a1                	li	a7,8
 ecall
 42c:	00000073          	ecall
 ret
 430:	8082                	ret

0000000000000432 <link>:
.global link
link:
 li a7, SYS_link
 432:	48cd                	li	a7,19
 ecall
 434:	00000073          	ecall
 ret
 438:	8082                	ret

000000000000043a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 43a:	48d1                	li	a7,20
 ecall
 43c:	00000073          	ecall
 ret
 440:	8082                	ret

0000000000000442 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 442:	48a5                	li	a7,9
 ecall
 444:	00000073          	ecall
 ret
 448:	8082                	ret

000000000000044a <dup>:
.global dup
dup:
 li a7, SYS_dup
 44a:	48a9                	li	a7,10
 ecall
 44c:	00000073          	ecall
 ret
 450:	8082                	ret

0000000000000452 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 452:	48ad                	li	a7,11
 ecall
 454:	00000073          	ecall
 ret
 458:	8082                	ret

000000000000045a <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 45a:	48b1                	li	a7,12
 ecall
 45c:	00000073          	ecall
 ret
 460:	8082                	ret

0000000000000462 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 462:	48b5                	li	a7,13
 ecall
 464:	00000073          	ecall
 ret
 468:	8082                	ret

000000000000046a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 46a:	48b9                	li	a7,14
 ecall
 46c:	00000073          	ecall
 ret
 470:	8082                	ret

0000000000000472 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 472:	1101                	addi	sp,sp,-32
 474:	ec06                	sd	ra,24(sp)
 476:	e822                	sd	s0,16(sp)
 478:	1000                	addi	s0,sp,32
 47a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 47e:	4605                	li	a2,1
 480:	fef40593          	addi	a1,s0,-17
 484:	f6fff0ef          	jal	ra,3f2 <write>
}
 488:	60e2                	ld	ra,24(sp)
 48a:	6442                	ld	s0,16(sp)
 48c:	6105                	addi	sp,sp,32
 48e:	8082                	ret

0000000000000490 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 490:	7139                	addi	sp,sp,-64
 492:	fc06                	sd	ra,56(sp)
 494:	f822                	sd	s0,48(sp)
 496:	f426                	sd	s1,40(sp)
 498:	f04a                	sd	s2,32(sp)
 49a:	ec4e                	sd	s3,24(sp)
 49c:	0080                	addi	s0,sp,64
 49e:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4a0:	c299                	beqz	a3,4a6 <printint+0x16>
 4a2:	0805c763          	bltz	a1,530 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 4a6:	2581                	sext.w	a1,a1
  neg = 0;
 4a8:	4881                	li	a7,0
 4aa:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 4ae:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4b0:	2601                	sext.w	a2,a2
 4b2:	00000517          	auipc	a0,0x0
 4b6:	5a650513          	addi	a0,a0,1446 # a58 <digits>
 4ba:	883a                	mv	a6,a4
 4bc:	2705                	addiw	a4,a4,1
 4be:	02c5f7bb          	remuw	a5,a1,a2
 4c2:	1782                	slli	a5,a5,0x20
 4c4:	9381                	srli	a5,a5,0x20
 4c6:	97aa                	add	a5,a5,a0
 4c8:	0007c783          	lbu	a5,0(a5)
 4cc:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4d0:	0005879b          	sext.w	a5,a1
 4d4:	02c5d5bb          	divuw	a1,a1,a2
 4d8:	0685                	addi	a3,a3,1
 4da:	fec7f0e3          	bgeu	a5,a2,4ba <printint+0x2a>
  if(neg)
 4de:	00088c63          	beqz	a7,4f6 <printint+0x66>
    buf[i++] = '-';
 4e2:	fd070793          	addi	a5,a4,-48
 4e6:	00878733          	add	a4,a5,s0
 4ea:	02d00793          	li	a5,45
 4ee:	fef70823          	sb	a5,-16(a4)
 4f2:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 4f6:	02e05663          	blez	a4,522 <printint+0x92>
 4fa:	fc040793          	addi	a5,s0,-64
 4fe:	00e78933          	add	s2,a5,a4
 502:	fff78993          	addi	s3,a5,-1
 506:	99ba                	add	s3,s3,a4
 508:	377d                	addiw	a4,a4,-1
 50a:	1702                	slli	a4,a4,0x20
 50c:	9301                	srli	a4,a4,0x20
 50e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 512:	fff94583          	lbu	a1,-1(s2)
 516:	8526                	mv	a0,s1
 518:	f5bff0ef          	jal	ra,472 <putc>
  while(--i >= 0)
 51c:	197d                	addi	s2,s2,-1
 51e:	ff391ae3          	bne	s2,s3,512 <printint+0x82>
}
 522:	70e2                	ld	ra,56(sp)
 524:	7442                	ld	s0,48(sp)
 526:	74a2                	ld	s1,40(sp)
 528:	7902                	ld	s2,32(sp)
 52a:	69e2                	ld	s3,24(sp)
 52c:	6121                	addi	sp,sp,64
 52e:	8082                	ret
    x = -xx;
 530:	40b005bb          	negw	a1,a1
    neg = 1;
 534:	4885                	li	a7,1
    x = -xx;
 536:	bf95                	j	4aa <printint+0x1a>

0000000000000538 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 538:	7119                	addi	sp,sp,-128
 53a:	fc86                	sd	ra,120(sp)
 53c:	f8a2                	sd	s0,112(sp)
 53e:	f4a6                	sd	s1,104(sp)
 540:	f0ca                	sd	s2,96(sp)
 542:	ecce                	sd	s3,88(sp)
 544:	e8d2                	sd	s4,80(sp)
 546:	e4d6                	sd	s5,72(sp)
 548:	e0da                	sd	s6,64(sp)
 54a:	fc5e                	sd	s7,56(sp)
 54c:	f862                	sd	s8,48(sp)
 54e:	f466                	sd	s9,40(sp)
 550:	f06a                	sd	s10,32(sp)
 552:	ec6e                	sd	s11,24(sp)
 554:	0100                	addi	s0,sp,128
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 556:	0005c903          	lbu	s2,0(a1)
 55a:	22090e63          	beqz	s2,796 <vprintf+0x25e>
 55e:	8b2a                	mv	s6,a0
 560:	8a2e                	mv	s4,a1
 562:	8bb2                	mv	s7,a2
  state = 0;
 564:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 566:	4481                	li	s1,0
 568:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 56a:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 56e:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 572:	06c00d13          	li	s10,108
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 576:	07500d93          	li	s11,117
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 57a:	00000c97          	auipc	s9,0x0
 57e:	4dec8c93          	addi	s9,s9,1246 # a58 <digits>
 582:	a005                	j	5a2 <vprintf+0x6a>
        putc(fd, c0);
 584:	85ca                	mv	a1,s2
 586:	855a                	mv	a0,s6
 588:	eebff0ef          	jal	ra,472 <putc>
 58c:	a019                	j	592 <vprintf+0x5a>
    } else if(state == '%'){
 58e:	03598263          	beq	s3,s5,5b2 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 592:	2485                	addiw	s1,s1,1
 594:	8726                	mv	a4,s1
 596:	009a07b3          	add	a5,s4,s1
 59a:	0007c903          	lbu	s2,0(a5)
 59e:	1e090c63          	beqz	s2,796 <vprintf+0x25e>
    c0 = fmt[i] & 0xff;
 5a2:	0009079b          	sext.w	a5,s2
    if(state == 0){
 5a6:	fe0994e3          	bnez	s3,58e <vprintf+0x56>
      if(c0 == '%'){
 5aa:	fd579de3          	bne	a5,s5,584 <vprintf+0x4c>
        state = '%';
 5ae:	89be                	mv	s3,a5
 5b0:	b7cd                	j	592 <vprintf+0x5a>
      if(c0) c1 = fmt[i+1] & 0xff;
 5b2:	cfa5                	beqz	a5,62a <vprintf+0xf2>
 5b4:	00ea06b3          	add	a3,s4,a4
 5b8:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 5bc:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 5be:	c681                	beqz	a3,5c6 <vprintf+0x8e>
 5c0:	9752                	add	a4,a4,s4
 5c2:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 5c6:	03878a63          	beq	a5,s8,5fa <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 5ca:	05a78463          	beq	a5,s10,612 <vprintf+0xda>
      } else if(c0 == 'u'){
 5ce:	0db78763          	beq	a5,s11,69c <vprintf+0x164>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 5d2:	07800713          	li	a4,120
 5d6:	10e78963          	beq	a5,a4,6e8 <vprintf+0x1b0>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 5da:	07000713          	li	a4,112
 5de:	12e78e63          	beq	a5,a4,71a <vprintf+0x1e2>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 5e2:	07300713          	li	a4,115
 5e6:	16e78b63          	beq	a5,a4,75c <vprintf+0x224>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 5ea:	05579063          	bne	a5,s5,62a <vprintf+0xf2>
        putc(fd, '%');
 5ee:	85d6                	mv	a1,s5
 5f0:	855a                	mv	a0,s6
 5f2:	e81ff0ef          	jal	ra,472 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 5f6:	4981                	li	s3,0
 5f8:	bf69                	j	592 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 1);
 5fa:	008b8913          	addi	s2,s7,8
 5fe:	4685                	li	a3,1
 600:	4629                	li	a2,10
 602:	000ba583          	lw	a1,0(s7)
 606:	855a                	mv	a0,s6
 608:	e89ff0ef          	jal	ra,490 <printint>
 60c:	8bca                	mv	s7,s2
      state = 0;
 60e:	4981                	li	s3,0
 610:	b749                	j	592 <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'd'){
 612:	03868663          	beq	a3,s8,63e <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 616:	05a68163          	beq	a3,s10,658 <vprintf+0x120>
      } else if(c0 == 'l' && c1 == 'u'){
 61a:	09b68d63          	beq	a3,s11,6b4 <vprintf+0x17c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 61e:	03a68f63          	beq	a3,s10,65c <vprintf+0x124>
      } else if(c0 == 'l' && c1 == 'x'){
 622:	07800793          	li	a5,120
 626:	0cf68d63          	beq	a3,a5,700 <vprintf+0x1c8>
        putc(fd, '%');
 62a:	85d6                	mv	a1,s5
 62c:	855a                	mv	a0,s6
 62e:	e45ff0ef          	jal	ra,472 <putc>
        putc(fd, c0);
 632:	85ca                	mv	a1,s2
 634:	855a                	mv	a0,s6
 636:	e3dff0ef          	jal	ra,472 <putc>
      state = 0;
 63a:	4981                	li	s3,0
 63c:	bf99                	j	592 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 63e:	008b8913          	addi	s2,s7,8
 642:	4685                	li	a3,1
 644:	4629                	li	a2,10
 646:	000ba583          	lw	a1,0(s7)
 64a:	855a                	mv	a0,s6
 64c:	e45ff0ef          	jal	ra,490 <printint>
        i += 1;
 650:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 652:	8bca                	mv	s7,s2
      state = 0;
 654:	4981                	li	s3,0
        i += 1;
 656:	bf35                	j	592 <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 658:	03860563          	beq	a2,s8,682 <vprintf+0x14a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 65c:	07b60963          	beq	a2,s11,6ce <vprintf+0x196>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 660:	07800793          	li	a5,120
 664:	fcf613e3          	bne	a2,a5,62a <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 668:	008b8913          	addi	s2,s7,8
 66c:	4681                	li	a3,0
 66e:	4641                	li	a2,16
 670:	000ba583          	lw	a1,0(s7)
 674:	855a                	mv	a0,s6
 676:	e1bff0ef          	jal	ra,490 <printint>
        i += 2;
 67a:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 67c:	8bca                	mv	s7,s2
      state = 0;
 67e:	4981                	li	s3,0
        i += 2;
 680:	bf09                	j	592 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 682:	008b8913          	addi	s2,s7,8
 686:	4685                	li	a3,1
 688:	4629                	li	a2,10
 68a:	000ba583          	lw	a1,0(s7)
 68e:	855a                	mv	a0,s6
 690:	e01ff0ef          	jal	ra,490 <printint>
        i += 2;
 694:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 696:	8bca                	mv	s7,s2
      state = 0;
 698:	4981                	li	s3,0
        i += 2;
 69a:	bde5                	j	592 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 0);
 69c:	008b8913          	addi	s2,s7,8
 6a0:	4681                	li	a3,0
 6a2:	4629                	li	a2,10
 6a4:	000ba583          	lw	a1,0(s7)
 6a8:	855a                	mv	a0,s6
 6aa:	de7ff0ef          	jal	ra,490 <printint>
 6ae:	8bca                	mv	s7,s2
      state = 0;
 6b0:	4981                	li	s3,0
 6b2:	b5c5                	j	592 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6b4:	008b8913          	addi	s2,s7,8
 6b8:	4681                	li	a3,0
 6ba:	4629                	li	a2,10
 6bc:	000ba583          	lw	a1,0(s7)
 6c0:	855a                	mv	a0,s6
 6c2:	dcfff0ef          	jal	ra,490 <printint>
        i += 1;
 6c6:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 6c8:	8bca                	mv	s7,s2
      state = 0;
 6ca:	4981                	li	s3,0
        i += 1;
 6cc:	b5d9                	j	592 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6ce:	008b8913          	addi	s2,s7,8
 6d2:	4681                	li	a3,0
 6d4:	4629                	li	a2,10
 6d6:	000ba583          	lw	a1,0(s7)
 6da:	855a                	mv	a0,s6
 6dc:	db5ff0ef          	jal	ra,490 <printint>
        i += 2;
 6e0:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 6e2:	8bca                	mv	s7,s2
      state = 0;
 6e4:	4981                	li	s3,0
        i += 2;
 6e6:	b575                	j	592 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 16, 0);
 6e8:	008b8913          	addi	s2,s7,8
 6ec:	4681                	li	a3,0
 6ee:	4641                	li	a2,16
 6f0:	000ba583          	lw	a1,0(s7)
 6f4:	855a                	mv	a0,s6
 6f6:	d9bff0ef          	jal	ra,490 <printint>
 6fa:	8bca                	mv	s7,s2
      state = 0;
 6fc:	4981                	li	s3,0
 6fe:	bd51                	j	592 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 700:	008b8913          	addi	s2,s7,8
 704:	4681                	li	a3,0
 706:	4641                	li	a2,16
 708:	000ba583          	lw	a1,0(s7)
 70c:	855a                	mv	a0,s6
 70e:	d83ff0ef          	jal	ra,490 <printint>
        i += 1;
 712:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 714:	8bca                	mv	s7,s2
      state = 0;
 716:	4981                	li	s3,0
        i += 1;
 718:	bdad                	j	592 <vprintf+0x5a>
        printptr(fd, va_arg(ap, uint64));
 71a:	008b8793          	addi	a5,s7,8
 71e:	f8f43423          	sd	a5,-120(s0)
 722:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 726:	03000593          	li	a1,48
 72a:	855a                	mv	a0,s6
 72c:	d47ff0ef          	jal	ra,472 <putc>
  putc(fd, 'x');
 730:	07800593          	li	a1,120
 734:	855a                	mv	a0,s6
 736:	d3dff0ef          	jal	ra,472 <putc>
 73a:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 73c:	03c9d793          	srli	a5,s3,0x3c
 740:	97e6                	add	a5,a5,s9
 742:	0007c583          	lbu	a1,0(a5)
 746:	855a                	mv	a0,s6
 748:	d2bff0ef          	jal	ra,472 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 74c:	0992                	slli	s3,s3,0x4
 74e:	397d                	addiw	s2,s2,-1
 750:	fe0916e3          	bnez	s2,73c <vprintf+0x204>
        printptr(fd, va_arg(ap, uint64));
 754:	f8843b83          	ld	s7,-120(s0)
      state = 0;
 758:	4981                	li	s3,0
 75a:	bd25                	j	592 <vprintf+0x5a>
        if((s = va_arg(ap, char*)) == 0)
 75c:	008b8993          	addi	s3,s7,8
 760:	000bb903          	ld	s2,0(s7)
 764:	00090f63          	beqz	s2,782 <vprintf+0x24a>
        for(; *s; s++)
 768:	00094583          	lbu	a1,0(s2)
 76c:	c195                	beqz	a1,790 <vprintf+0x258>
          putc(fd, *s);
 76e:	855a                	mv	a0,s6
 770:	d03ff0ef          	jal	ra,472 <putc>
        for(; *s; s++)
 774:	0905                	addi	s2,s2,1
 776:	00094583          	lbu	a1,0(s2)
 77a:	f9f5                	bnez	a1,76e <vprintf+0x236>
        if((s = va_arg(ap, char*)) == 0)
 77c:	8bce                	mv	s7,s3
      state = 0;
 77e:	4981                	li	s3,0
 780:	bd09                	j	592 <vprintf+0x5a>
          s = "(null)";
 782:	00000917          	auipc	s2,0x0
 786:	2ce90913          	addi	s2,s2,718 # a50 <malloc+0x1be>
        for(; *s; s++)
 78a:	02800593          	li	a1,40
 78e:	b7c5                	j	76e <vprintf+0x236>
        if((s = va_arg(ap, char*)) == 0)
 790:	8bce                	mv	s7,s3
      state = 0;
 792:	4981                	li	s3,0
 794:	bbfd                	j	592 <vprintf+0x5a>
    }
  }
}
 796:	70e6                	ld	ra,120(sp)
 798:	7446                	ld	s0,112(sp)
 79a:	74a6                	ld	s1,104(sp)
 79c:	7906                	ld	s2,96(sp)
 79e:	69e6                	ld	s3,88(sp)
 7a0:	6a46                	ld	s4,80(sp)
 7a2:	6aa6                	ld	s5,72(sp)
 7a4:	6b06                	ld	s6,64(sp)
 7a6:	7be2                	ld	s7,56(sp)
 7a8:	7c42                	ld	s8,48(sp)
 7aa:	7ca2                	ld	s9,40(sp)
 7ac:	7d02                	ld	s10,32(sp)
 7ae:	6de2                	ld	s11,24(sp)
 7b0:	6109                	addi	sp,sp,128
 7b2:	8082                	ret

00000000000007b4 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7b4:	715d                	addi	sp,sp,-80
 7b6:	ec06                	sd	ra,24(sp)
 7b8:	e822                	sd	s0,16(sp)
 7ba:	1000                	addi	s0,sp,32
 7bc:	e010                	sd	a2,0(s0)
 7be:	e414                	sd	a3,8(s0)
 7c0:	e818                	sd	a4,16(s0)
 7c2:	ec1c                	sd	a5,24(s0)
 7c4:	03043023          	sd	a6,32(s0)
 7c8:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7cc:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7d0:	8622                	mv	a2,s0
 7d2:	d67ff0ef          	jal	ra,538 <vprintf>
}
 7d6:	60e2                	ld	ra,24(sp)
 7d8:	6442                	ld	s0,16(sp)
 7da:	6161                	addi	sp,sp,80
 7dc:	8082                	ret

00000000000007de <printf>:

void
printf(const char *fmt, ...)
{
 7de:	711d                	addi	sp,sp,-96
 7e0:	ec06                	sd	ra,24(sp)
 7e2:	e822                	sd	s0,16(sp)
 7e4:	1000                	addi	s0,sp,32
 7e6:	e40c                	sd	a1,8(s0)
 7e8:	e810                	sd	a2,16(s0)
 7ea:	ec14                	sd	a3,24(s0)
 7ec:	f018                	sd	a4,32(s0)
 7ee:	f41c                	sd	a5,40(s0)
 7f0:	03043823          	sd	a6,48(s0)
 7f4:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7f8:	00840613          	addi	a2,s0,8
 7fc:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 800:	85aa                	mv	a1,a0
 802:	4505                	li	a0,1
 804:	d35ff0ef          	jal	ra,538 <vprintf>
}
 808:	60e2                	ld	ra,24(sp)
 80a:	6442                	ld	s0,16(sp)
 80c:	6125                	addi	sp,sp,96
 80e:	8082                	ret

0000000000000810 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 810:	1141                	addi	sp,sp,-16
 812:	e422                	sd	s0,8(sp)
 814:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 816:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 81a:	00000797          	auipc	a5,0x0
 81e:	7e67b783          	ld	a5,2022(a5) # 1000 <freep>
 822:	a02d                	j	84c <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 824:	4618                	lw	a4,8(a2)
 826:	9f2d                	addw	a4,a4,a1
 828:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 82c:	6398                	ld	a4,0(a5)
 82e:	6310                	ld	a2,0(a4)
 830:	a83d                	j	86e <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 832:	ff852703          	lw	a4,-8(a0)
 836:	9f31                	addw	a4,a4,a2
 838:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 83a:	ff053683          	ld	a3,-16(a0)
 83e:	a091                	j	882 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 840:	6398                	ld	a4,0(a5)
 842:	00e7e463          	bltu	a5,a4,84a <free+0x3a>
 846:	00e6ea63          	bltu	a3,a4,85a <free+0x4a>
{
 84a:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 84c:	fed7fae3          	bgeu	a5,a3,840 <free+0x30>
 850:	6398                	ld	a4,0(a5)
 852:	00e6e463          	bltu	a3,a4,85a <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 856:	fee7eae3          	bltu	a5,a4,84a <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 85a:	ff852583          	lw	a1,-8(a0)
 85e:	6390                	ld	a2,0(a5)
 860:	02059813          	slli	a6,a1,0x20
 864:	01c85713          	srli	a4,a6,0x1c
 868:	9736                	add	a4,a4,a3
 86a:	fae60de3          	beq	a2,a4,824 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 86e:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 872:	4790                	lw	a2,8(a5)
 874:	02061593          	slli	a1,a2,0x20
 878:	01c5d713          	srli	a4,a1,0x1c
 87c:	973e                	add	a4,a4,a5
 87e:	fae68ae3          	beq	a3,a4,832 <free+0x22>
    p->s.ptr = bp->s.ptr;
 882:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 884:	00000717          	auipc	a4,0x0
 888:	76f73e23          	sd	a5,1916(a4) # 1000 <freep>
}
 88c:	6422                	ld	s0,8(sp)
 88e:	0141                	addi	sp,sp,16
 890:	8082                	ret

0000000000000892 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 892:	7139                	addi	sp,sp,-64
 894:	fc06                	sd	ra,56(sp)
 896:	f822                	sd	s0,48(sp)
 898:	f426                	sd	s1,40(sp)
 89a:	f04a                	sd	s2,32(sp)
 89c:	ec4e                	sd	s3,24(sp)
 89e:	e852                	sd	s4,16(sp)
 8a0:	e456                	sd	s5,8(sp)
 8a2:	e05a                	sd	s6,0(sp)
 8a4:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8a6:	02051493          	slli	s1,a0,0x20
 8aa:	9081                	srli	s1,s1,0x20
 8ac:	04bd                	addi	s1,s1,15
 8ae:	8091                	srli	s1,s1,0x4
 8b0:	0014899b          	addiw	s3,s1,1
 8b4:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 8b6:	00000517          	auipc	a0,0x0
 8ba:	74a53503          	ld	a0,1866(a0) # 1000 <freep>
 8be:	c515                	beqz	a0,8ea <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8c0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8c2:	4798                	lw	a4,8(a5)
 8c4:	02977f63          	bgeu	a4,s1,902 <malloc+0x70>
 8c8:	8a4e                	mv	s4,s3
 8ca:	0009871b          	sext.w	a4,s3
 8ce:	6685                	lui	a3,0x1
 8d0:	00d77363          	bgeu	a4,a3,8d6 <malloc+0x44>
 8d4:	6a05                	lui	s4,0x1
 8d6:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8da:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8de:	00000917          	auipc	s2,0x0
 8e2:	72290913          	addi	s2,s2,1826 # 1000 <freep>
  if(p == (char*)-1)
 8e6:	5afd                	li	s5,-1
 8e8:	a885                	j	958 <malloc+0xc6>
    base.s.ptr = freep = prevp = &base;
 8ea:	00000797          	auipc	a5,0x0
 8ee:	72678793          	addi	a5,a5,1830 # 1010 <base>
 8f2:	00000717          	auipc	a4,0x0
 8f6:	70f73723          	sd	a5,1806(a4) # 1000 <freep>
 8fa:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8fc:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 900:	b7e1                	j	8c8 <malloc+0x36>
      if(p->s.size == nunits)
 902:	02e48c63          	beq	s1,a4,93a <malloc+0xa8>
        p->s.size -= nunits;
 906:	4137073b          	subw	a4,a4,s3
 90a:	c798                	sw	a4,8(a5)
        p += p->s.size;
 90c:	02071693          	slli	a3,a4,0x20
 910:	01c6d713          	srli	a4,a3,0x1c
 914:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 916:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 91a:	00000717          	auipc	a4,0x0
 91e:	6ea73323          	sd	a0,1766(a4) # 1000 <freep>
      return (void*)(p + 1);
 922:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 926:	70e2                	ld	ra,56(sp)
 928:	7442                	ld	s0,48(sp)
 92a:	74a2                	ld	s1,40(sp)
 92c:	7902                	ld	s2,32(sp)
 92e:	69e2                	ld	s3,24(sp)
 930:	6a42                	ld	s4,16(sp)
 932:	6aa2                	ld	s5,8(sp)
 934:	6b02                	ld	s6,0(sp)
 936:	6121                	addi	sp,sp,64
 938:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 93a:	6398                	ld	a4,0(a5)
 93c:	e118                	sd	a4,0(a0)
 93e:	bff1                	j	91a <malloc+0x88>
  hp->s.size = nu;
 940:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 944:	0541                	addi	a0,a0,16
 946:	ecbff0ef          	jal	ra,810 <free>
  return freep;
 94a:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 94e:	dd61                	beqz	a0,926 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 950:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 952:	4798                	lw	a4,8(a5)
 954:	fa9777e3          	bgeu	a4,s1,902 <malloc+0x70>
    if(p == freep)
 958:	00093703          	ld	a4,0(s2)
 95c:	853e                	mv	a0,a5
 95e:	fef719e3          	bne	a4,a5,950 <malloc+0xbe>
  p = sbrk(nu * sizeof(Header));
 962:	8552                	mv	a0,s4
 964:	af7ff0ef          	jal	ra,45a <sbrk>
  if(p == (char*)-1)
 968:	fd551ce3          	bne	a0,s5,940 <malloc+0xae>
        return 0;
 96c:	4501                	li	a0,0
 96e:	bf65                	j	926 <malloc+0x94>
