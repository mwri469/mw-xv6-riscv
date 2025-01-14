
user/_primes:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <primes>:
 *   | ... |  | ... |         | ... |
 *   | 0277|--| 0277|--. . .->|print|
 *   | 0278|->| kill|  . . .  |     |
 */
void 
primes(int in_pipe) {
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	1800                	addi	s0,sp,48
   a:	84aa                	mv	s1,a0
    int prime, buff, bytes;
    int out_pipe[2];

    // Read the first number from the pipe, which is the next prime
    bytes = read(in_pipe, &prime, sizeof(prime));
   c:	4611                	li	a2,4
   e:	fdc40593          	addi	a1,s0,-36
  12:	3a6000ef          	jal	ra,3b8 <read>
    if (bytes == 0) {
  16:	cd15                	beqz	a0,52 <primes+0x52>
        close(in_pipe);
        exit(0);
    } else if (bytes < 0) {
  18:	04054363          	bltz	a0,5e <primes+0x5e>
        close(in_pipe);
        exit(1);
    } // EndIf

    // Print the prime number
    fprintf(1, "prime %d\n", prime);
  1c:	fdc42603          	lw	a2,-36(s0)
  20:	00001597          	auipc	a1,0x1
  24:	94058593          	addi	a1,a1,-1728 # 960 <malloc+0x100>
  28:	4505                	li	a0,1
  2a:	758000ef          	jal	ra,782 <fprintf>

    // Create a new pipe for the next stage
    pipe(out_pipe);
  2e:	fd040513          	addi	a0,s0,-48
  32:	37e000ef          	jal	ra,3b0 <pipe>

    if (fork() == 0) {
  36:	362000ef          	jal	ra,398 <fork>
  3a:	ed1d                	bnez	a0,78 <primes+0x78>
        // Child process: close write end and recurse with the read end
        close(out_pipe[1]);
  3c:	fd442503          	lw	a0,-44(s0)
  40:	388000ef          	jal	ra,3c8 <close>
        close(in_pipe);
  44:	8526                	mv	a0,s1
  46:	382000ef          	jal	ra,3c8 <close>
        primes(out_pipe[0]);
  4a:	fd042503          	lw	a0,-48(s0)
  4e:	fb3ff0ef          	jal	ra,0 <primes>
        close(in_pipe);
  52:	8526                	mv	a0,s1
  54:	374000ef          	jal	ra,3c8 <close>
        exit(0);
  58:	4501                	li	a0,0
  5a:	346000ef          	jal	ra,3a0 <exit>
        fprintf(2, "Err: error reading from pipe\n");
  5e:	00001597          	auipc	a1,0x1
  62:	8e258593          	addi	a1,a1,-1822 # 940 <malloc+0xe0>
  66:	4509                	li	a0,2
  68:	71a000ef          	jal	ra,782 <fprintf>
        close(in_pipe);
  6c:	8526                	mv	a0,s1
  6e:	35a000ef          	jal	ra,3c8 <close>
        exit(1);
  72:	4505                	li	a0,1
  74:	32c000ef          	jal	ra,3a0 <exit>
        exit(0);
    } else {
        // Parent process: close read end of the new pipe
        close(out_pipe[0]);
  78:	fd042503          	lw	a0,-48(s0)
  7c:	34c000ef          	jal	ra,3c8 <close>

        // Filter numbers that are not divisible by the current prime
        while (read(in_pipe, &buff, sizeof(buff)) > 0) {
  80:	4611                	li	a2,4
  82:	fd840593          	addi	a1,s0,-40
  86:	8526                	mv	a0,s1
  88:	330000ef          	jal	ra,3b8 <read>
  8c:	02a05163          	blez	a0,ae <primes+0xae>
            if (buff % prime != 0) {
  90:	fd842783          	lw	a5,-40(s0)
  94:	fdc42703          	lw	a4,-36(s0)
  98:	02e7e7bb          	remw	a5,a5,a4
  9c:	d3f5                	beqz	a5,80 <primes+0x80>
                write(out_pipe[1], &buff, sizeof(buff));
  9e:	4611                	li	a2,4
  a0:	fd840593          	addi	a1,s0,-40
  a4:	fd442503          	lw	a0,-44(s0)
  a8:	318000ef          	jal	ra,3c0 <write>
  ac:	bfd1                	j	80 <primes+0x80>
            }
        }

        // Close pipes and wait for the child
        close(out_pipe[1]);
  ae:	fd442503          	lw	a0,-44(s0)
  b2:	316000ef          	jal	ra,3c8 <close>
        close(in_pipe);
  b6:	8526                	mv	a0,s1
  b8:	310000ef          	jal	ra,3c8 <close>
        wait(0);
  bc:	4501                	li	a0,0
  be:	2ea000ef          	jal	ra,3a8 <wait>
        exit(0);
  c2:	4501                	li	a0,0
  c4:	2dc000ef          	jal	ra,3a0 <exit>

00000000000000c8 <main>:
    } // EndIf
} // End

int 
main(int argc, char* argv[]) {
  c8:	7179                	addi	sp,sp,-48
  ca:	f406                	sd	ra,40(sp)
  cc:	f022                	sd	s0,32(sp)
  ce:	ec26                	sd	s1,24(sp)
  d0:	1800                	addi	s0,sp,48
    int in_pipe[2];
    int i;

    pipe(in_pipe);
  d2:	fd840513          	addi	a0,s0,-40
  d6:	2da000ef          	jal	ra,3b0 <pipe>

    if (fork() == 0) {
  da:	2be000ef          	jal	ra,398 <fork>
  de:	e909                	bnez	a0,f0 <main+0x28>
        // Child process: start the sieve
        close(in_pipe[1]);
  e0:	fdc42503          	lw	a0,-36(s0)
  e4:	2e4000ef          	jal	ra,3c8 <close>
        primes(in_pipe[0]);
  e8:	fd842503          	lw	a0,-40(s0)
  ec:	f15ff0ef          	jal	ra,0 <primes>
        exit(0);
    } else {
        // Parent process: write numbers into the pipe
        close(in_pipe[0]);
  f0:	fd842503          	lw	a0,-40(s0)
  f4:	2d4000ef          	jal	ra,3c8 <close>
        for (i = 2; i <= TOT_NUMS; i++) {
  f8:	4789                	li	a5,2
  fa:	fcf42a23          	sw	a5,-44(s0)
  fe:	11800493          	li	s1,280
            write(in_pipe[1], &i, sizeof(i));
 102:	4611                	li	a2,4
 104:	fd440593          	addi	a1,s0,-44
 108:	fdc42503          	lw	a0,-36(s0)
 10c:	2b4000ef          	jal	ra,3c0 <write>
        for (i = 2; i <= TOT_NUMS; i++) {
 110:	fd442783          	lw	a5,-44(s0)
 114:	2785                	addiw	a5,a5,1
 116:	0007871b          	sext.w	a4,a5
 11a:	fcf42a23          	sw	a5,-44(s0)
 11e:	fee4d2e3          	bge	s1,a4,102 <main+0x3a>
        }

        // Close write end and wait for the child to finish
        close(in_pipe[1]);
 122:	fdc42503          	lw	a0,-36(s0)
 126:	2a2000ef          	jal	ra,3c8 <close>
        wait(0);
 12a:	4501                	li	a0,0
 12c:	27c000ef          	jal	ra,3a8 <wait>
        exit(0);
 130:	4501                	li	a0,0
 132:	26e000ef          	jal	ra,3a0 <exit>

0000000000000136 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 136:	1141                	addi	sp,sp,-16
 138:	e406                	sd	ra,8(sp)
 13a:	e022                	sd	s0,0(sp)
 13c:	0800                	addi	s0,sp,16
  extern int main();
  main();
 13e:	f8bff0ef          	jal	ra,c8 <main>
  exit(0);
 142:	4501                	li	a0,0
 144:	25c000ef          	jal	ra,3a0 <exit>

0000000000000148 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 148:	1141                	addi	sp,sp,-16
 14a:	e422                	sd	s0,8(sp)
 14c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 14e:	87aa                	mv	a5,a0
 150:	0585                	addi	a1,a1,1
 152:	0785                	addi	a5,a5,1
 154:	fff5c703          	lbu	a4,-1(a1)
 158:	fee78fa3          	sb	a4,-1(a5)
 15c:	fb75                	bnez	a4,150 <strcpy+0x8>
    ;
  return os;
}
 15e:	6422                	ld	s0,8(sp)
 160:	0141                	addi	sp,sp,16
 162:	8082                	ret

0000000000000164 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 164:	1141                	addi	sp,sp,-16
 166:	e422                	sd	s0,8(sp)
 168:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 16a:	00054783          	lbu	a5,0(a0)
 16e:	cb91                	beqz	a5,182 <strcmp+0x1e>
 170:	0005c703          	lbu	a4,0(a1)
 174:	00f71763          	bne	a4,a5,182 <strcmp+0x1e>
    p++, q++;
 178:	0505                	addi	a0,a0,1
 17a:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 17c:	00054783          	lbu	a5,0(a0)
 180:	fbe5                	bnez	a5,170 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 182:	0005c503          	lbu	a0,0(a1)
}
 186:	40a7853b          	subw	a0,a5,a0
 18a:	6422                	ld	s0,8(sp)
 18c:	0141                	addi	sp,sp,16
 18e:	8082                	ret

0000000000000190 <strlen>:

uint
strlen(const char *s)
{
 190:	1141                	addi	sp,sp,-16
 192:	e422                	sd	s0,8(sp)
 194:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 196:	00054783          	lbu	a5,0(a0)
 19a:	cf91                	beqz	a5,1b6 <strlen+0x26>
 19c:	0505                	addi	a0,a0,1
 19e:	87aa                	mv	a5,a0
 1a0:	4685                	li	a3,1
 1a2:	9e89                	subw	a3,a3,a0
 1a4:	00f6853b          	addw	a0,a3,a5
 1a8:	0785                	addi	a5,a5,1
 1aa:	fff7c703          	lbu	a4,-1(a5)
 1ae:	fb7d                	bnez	a4,1a4 <strlen+0x14>
    ;
  return n;
}
 1b0:	6422                	ld	s0,8(sp)
 1b2:	0141                	addi	sp,sp,16
 1b4:	8082                	ret
  for(n = 0; s[n]; n++)
 1b6:	4501                	li	a0,0
 1b8:	bfe5                	j	1b0 <strlen+0x20>

00000000000001ba <memset>:

void*
memset(void *dst, int c, uint n)
{
 1ba:	1141                	addi	sp,sp,-16
 1bc:	e422                	sd	s0,8(sp)
 1be:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1c0:	ca19                	beqz	a2,1d6 <memset+0x1c>
 1c2:	87aa                	mv	a5,a0
 1c4:	1602                	slli	a2,a2,0x20
 1c6:	9201                	srli	a2,a2,0x20
 1c8:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1cc:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1d0:	0785                	addi	a5,a5,1
 1d2:	fee79de3          	bne	a5,a4,1cc <memset+0x12>
  }
  return dst;
}
 1d6:	6422                	ld	s0,8(sp)
 1d8:	0141                	addi	sp,sp,16
 1da:	8082                	ret

00000000000001dc <strchr>:

char*
strchr(const char *s, char c)
{
 1dc:	1141                	addi	sp,sp,-16
 1de:	e422                	sd	s0,8(sp)
 1e0:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1e2:	00054783          	lbu	a5,0(a0)
 1e6:	cb99                	beqz	a5,1fc <strchr+0x20>
    if(*s == c)
 1e8:	00f58763          	beq	a1,a5,1f6 <strchr+0x1a>
  for(; *s; s++)
 1ec:	0505                	addi	a0,a0,1
 1ee:	00054783          	lbu	a5,0(a0)
 1f2:	fbfd                	bnez	a5,1e8 <strchr+0xc>
      return (char*)s;
  return 0;
 1f4:	4501                	li	a0,0
}
 1f6:	6422                	ld	s0,8(sp)
 1f8:	0141                	addi	sp,sp,16
 1fa:	8082                	ret
  return 0;
 1fc:	4501                	li	a0,0
 1fe:	bfe5                	j	1f6 <strchr+0x1a>

0000000000000200 <gets>:

char*
gets(char *buf, int max)
{
 200:	711d                	addi	sp,sp,-96
 202:	ec86                	sd	ra,88(sp)
 204:	e8a2                	sd	s0,80(sp)
 206:	e4a6                	sd	s1,72(sp)
 208:	e0ca                	sd	s2,64(sp)
 20a:	fc4e                	sd	s3,56(sp)
 20c:	f852                	sd	s4,48(sp)
 20e:	f456                	sd	s5,40(sp)
 210:	f05a                	sd	s6,32(sp)
 212:	ec5e                	sd	s7,24(sp)
 214:	1080                	addi	s0,sp,96
 216:	8baa                	mv	s7,a0
 218:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 21a:	892a                	mv	s2,a0
 21c:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 21e:	4aa9                	li	s5,10
 220:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 222:	89a6                	mv	s3,s1
 224:	2485                	addiw	s1,s1,1
 226:	0344d663          	bge	s1,s4,252 <gets+0x52>
    cc = read(0, &c, 1);
 22a:	4605                	li	a2,1
 22c:	faf40593          	addi	a1,s0,-81
 230:	4501                	li	a0,0
 232:	186000ef          	jal	ra,3b8 <read>
    if(cc < 1)
 236:	00a05e63          	blez	a0,252 <gets+0x52>
    buf[i++] = c;
 23a:	faf44783          	lbu	a5,-81(s0)
 23e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 242:	01578763          	beq	a5,s5,250 <gets+0x50>
 246:	0905                	addi	s2,s2,1
 248:	fd679de3          	bne	a5,s6,222 <gets+0x22>
  for(i=0; i+1 < max; ){
 24c:	89a6                	mv	s3,s1
 24e:	a011                	j	252 <gets+0x52>
 250:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 252:	99de                	add	s3,s3,s7
 254:	00098023          	sb	zero,0(s3)
  return buf;
}
 258:	855e                	mv	a0,s7
 25a:	60e6                	ld	ra,88(sp)
 25c:	6446                	ld	s0,80(sp)
 25e:	64a6                	ld	s1,72(sp)
 260:	6906                	ld	s2,64(sp)
 262:	79e2                	ld	s3,56(sp)
 264:	7a42                	ld	s4,48(sp)
 266:	7aa2                	ld	s5,40(sp)
 268:	7b02                	ld	s6,32(sp)
 26a:	6be2                	ld	s7,24(sp)
 26c:	6125                	addi	sp,sp,96
 26e:	8082                	ret

0000000000000270 <stat>:

int
stat(const char *n, struct stat *st)
{
 270:	1101                	addi	sp,sp,-32
 272:	ec06                	sd	ra,24(sp)
 274:	e822                	sd	s0,16(sp)
 276:	e426                	sd	s1,8(sp)
 278:	e04a                	sd	s2,0(sp)
 27a:	1000                	addi	s0,sp,32
 27c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 27e:	4581                	li	a1,0
 280:	160000ef          	jal	ra,3e0 <open>
  if(fd < 0)
 284:	02054163          	bltz	a0,2a6 <stat+0x36>
 288:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 28a:	85ca                	mv	a1,s2
 28c:	16c000ef          	jal	ra,3f8 <fstat>
 290:	892a                	mv	s2,a0
  close(fd);
 292:	8526                	mv	a0,s1
 294:	134000ef          	jal	ra,3c8 <close>
  return r;
}
 298:	854a                	mv	a0,s2
 29a:	60e2                	ld	ra,24(sp)
 29c:	6442                	ld	s0,16(sp)
 29e:	64a2                	ld	s1,8(sp)
 2a0:	6902                	ld	s2,0(sp)
 2a2:	6105                	addi	sp,sp,32
 2a4:	8082                	ret
    return -1;
 2a6:	597d                	li	s2,-1
 2a8:	bfc5                	j	298 <stat+0x28>

00000000000002aa <atoi>:

int
atoi(const char *s)
{
 2aa:	1141                	addi	sp,sp,-16
 2ac:	e422                	sd	s0,8(sp)
 2ae:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2b0:	00054683          	lbu	a3,0(a0)
 2b4:	fd06879b          	addiw	a5,a3,-48
 2b8:	0ff7f793          	zext.b	a5,a5
 2bc:	4625                	li	a2,9
 2be:	02f66863          	bltu	a2,a5,2ee <atoi+0x44>
 2c2:	872a                	mv	a4,a0
  n = 0;
 2c4:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 2c6:	0705                	addi	a4,a4,1
 2c8:	0025179b          	slliw	a5,a0,0x2
 2cc:	9fa9                	addw	a5,a5,a0
 2ce:	0017979b          	slliw	a5,a5,0x1
 2d2:	9fb5                	addw	a5,a5,a3
 2d4:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2d8:	00074683          	lbu	a3,0(a4)
 2dc:	fd06879b          	addiw	a5,a3,-48
 2e0:	0ff7f793          	zext.b	a5,a5
 2e4:	fef671e3          	bgeu	a2,a5,2c6 <atoi+0x1c>
  return n;
}
 2e8:	6422                	ld	s0,8(sp)
 2ea:	0141                	addi	sp,sp,16
 2ec:	8082                	ret
  n = 0;
 2ee:	4501                	li	a0,0
 2f0:	bfe5                	j	2e8 <atoi+0x3e>

00000000000002f2 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2f2:	1141                	addi	sp,sp,-16
 2f4:	e422                	sd	s0,8(sp)
 2f6:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2f8:	02b57463          	bgeu	a0,a1,320 <memmove+0x2e>
    while(n-- > 0)
 2fc:	00c05f63          	blez	a2,31a <memmove+0x28>
 300:	1602                	slli	a2,a2,0x20
 302:	9201                	srli	a2,a2,0x20
 304:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 308:	872a                	mv	a4,a0
      *dst++ = *src++;
 30a:	0585                	addi	a1,a1,1
 30c:	0705                	addi	a4,a4,1
 30e:	fff5c683          	lbu	a3,-1(a1)
 312:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 316:	fee79ae3          	bne	a5,a4,30a <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 31a:	6422                	ld	s0,8(sp)
 31c:	0141                	addi	sp,sp,16
 31e:	8082                	ret
    dst += n;
 320:	00c50733          	add	a4,a0,a2
    src += n;
 324:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 326:	fec05ae3          	blez	a2,31a <memmove+0x28>
 32a:	fff6079b          	addiw	a5,a2,-1
 32e:	1782                	slli	a5,a5,0x20
 330:	9381                	srli	a5,a5,0x20
 332:	fff7c793          	not	a5,a5
 336:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 338:	15fd                	addi	a1,a1,-1
 33a:	177d                	addi	a4,a4,-1
 33c:	0005c683          	lbu	a3,0(a1)
 340:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 344:	fee79ae3          	bne	a5,a4,338 <memmove+0x46>
 348:	bfc9                	j	31a <memmove+0x28>

000000000000034a <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 34a:	1141                	addi	sp,sp,-16
 34c:	e422                	sd	s0,8(sp)
 34e:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 350:	ca05                	beqz	a2,380 <memcmp+0x36>
 352:	fff6069b          	addiw	a3,a2,-1
 356:	1682                	slli	a3,a3,0x20
 358:	9281                	srli	a3,a3,0x20
 35a:	0685                	addi	a3,a3,1
 35c:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 35e:	00054783          	lbu	a5,0(a0)
 362:	0005c703          	lbu	a4,0(a1)
 366:	00e79863          	bne	a5,a4,376 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 36a:	0505                	addi	a0,a0,1
    p2++;
 36c:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 36e:	fed518e3          	bne	a0,a3,35e <memcmp+0x14>
  }
  return 0;
 372:	4501                	li	a0,0
 374:	a019                	j	37a <memcmp+0x30>
      return *p1 - *p2;
 376:	40e7853b          	subw	a0,a5,a4
}
 37a:	6422                	ld	s0,8(sp)
 37c:	0141                	addi	sp,sp,16
 37e:	8082                	ret
  return 0;
 380:	4501                	li	a0,0
 382:	bfe5                	j	37a <memcmp+0x30>

0000000000000384 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 384:	1141                	addi	sp,sp,-16
 386:	e406                	sd	ra,8(sp)
 388:	e022                	sd	s0,0(sp)
 38a:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 38c:	f67ff0ef          	jal	ra,2f2 <memmove>
}
 390:	60a2                	ld	ra,8(sp)
 392:	6402                	ld	s0,0(sp)
 394:	0141                	addi	sp,sp,16
 396:	8082                	ret

0000000000000398 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 398:	4885                	li	a7,1
 ecall
 39a:	00000073          	ecall
 ret
 39e:	8082                	ret

00000000000003a0 <exit>:
.global exit
exit:
 li a7, SYS_exit
 3a0:	4889                	li	a7,2
 ecall
 3a2:	00000073          	ecall
 ret
 3a6:	8082                	ret

00000000000003a8 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3a8:	488d                	li	a7,3
 ecall
 3aa:	00000073          	ecall
 ret
 3ae:	8082                	ret

00000000000003b0 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3b0:	4891                	li	a7,4
 ecall
 3b2:	00000073          	ecall
 ret
 3b6:	8082                	ret

00000000000003b8 <read>:
.global read
read:
 li a7, SYS_read
 3b8:	4895                	li	a7,5
 ecall
 3ba:	00000073          	ecall
 ret
 3be:	8082                	ret

00000000000003c0 <write>:
.global write
write:
 li a7, SYS_write
 3c0:	48c1                	li	a7,16
 ecall
 3c2:	00000073          	ecall
 ret
 3c6:	8082                	ret

00000000000003c8 <close>:
.global close
close:
 li a7, SYS_close
 3c8:	48d5                	li	a7,21
 ecall
 3ca:	00000073          	ecall
 ret
 3ce:	8082                	ret

00000000000003d0 <kill>:
.global kill
kill:
 li a7, SYS_kill
 3d0:	4899                	li	a7,6
 ecall
 3d2:	00000073          	ecall
 ret
 3d6:	8082                	ret

00000000000003d8 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3d8:	489d                	li	a7,7
 ecall
 3da:	00000073          	ecall
 ret
 3de:	8082                	ret

00000000000003e0 <open>:
.global open
open:
 li a7, SYS_open
 3e0:	48bd                	li	a7,15
 ecall
 3e2:	00000073          	ecall
 ret
 3e6:	8082                	ret

00000000000003e8 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3e8:	48c5                	li	a7,17
 ecall
 3ea:	00000073          	ecall
 ret
 3ee:	8082                	ret

00000000000003f0 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3f0:	48c9                	li	a7,18
 ecall
 3f2:	00000073          	ecall
 ret
 3f6:	8082                	ret

00000000000003f8 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3f8:	48a1                	li	a7,8
 ecall
 3fa:	00000073          	ecall
 ret
 3fe:	8082                	ret

0000000000000400 <link>:
.global link
link:
 li a7, SYS_link
 400:	48cd                	li	a7,19
 ecall
 402:	00000073          	ecall
 ret
 406:	8082                	ret

0000000000000408 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 408:	48d1                	li	a7,20
 ecall
 40a:	00000073          	ecall
 ret
 40e:	8082                	ret

0000000000000410 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 410:	48a5                	li	a7,9
 ecall
 412:	00000073          	ecall
 ret
 416:	8082                	ret

0000000000000418 <dup>:
.global dup
dup:
 li a7, SYS_dup
 418:	48a9                	li	a7,10
 ecall
 41a:	00000073          	ecall
 ret
 41e:	8082                	ret

0000000000000420 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 420:	48ad                	li	a7,11
 ecall
 422:	00000073          	ecall
 ret
 426:	8082                	ret

0000000000000428 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 428:	48b1                	li	a7,12
 ecall
 42a:	00000073          	ecall
 ret
 42e:	8082                	ret

0000000000000430 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 430:	48b5                	li	a7,13
 ecall
 432:	00000073          	ecall
 ret
 436:	8082                	ret

0000000000000438 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 438:	48b9                	li	a7,14
 ecall
 43a:	00000073          	ecall
 ret
 43e:	8082                	ret

0000000000000440 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 440:	1101                	addi	sp,sp,-32
 442:	ec06                	sd	ra,24(sp)
 444:	e822                	sd	s0,16(sp)
 446:	1000                	addi	s0,sp,32
 448:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 44c:	4605                	li	a2,1
 44e:	fef40593          	addi	a1,s0,-17
 452:	f6fff0ef          	jal	ra,3c0 <write>
}
 456:	60e2                	ld	ra,24(sp)
 458:	6442                	ld	s0,16(sp)
 45a:	6105                	addi	sp,sp,32
 45c:	8082                	ret

000000000000045e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 45e:	7139                	addi	sp,sp,-64
 460:	fc06                	sd	ra,56(sp)
 462:	f822                	sd	s0,48(sp)
 464:	f426                	sd	s1,40(sp)
 466:	f04a                	sd	s2,32(sp)
 468:	ec4e                	sd	s3,24(sp)
 46a:	0080                	addi	s0,sp,64
 46c:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 46e:	c299                	beqz	a3,474 <printint+0x16>
 470:	0805c763          	bltz	a1,4fe <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 474:	2581                	sext.w	a1,a1
  neg = 0;
 476:	4881                	li	a7,0
 478:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 47c:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 47e:	2601                	sext.w	a2,a2
 480:	00000517          	auipc	a0,0x0
 484:	4f850513          	addi	a0,a0,1272 # 978 <digits>
 488:	883a                	mv	a6,a4
 48a:	2705                	addiw	a4,a4,1
 48c:	02c5f7bb          	remuw	a5,a1,a2
 490:	1782                	slli	a5,a5,0x20
 492:	9381                	srli	a5,a5,0x20
 494:	97aa                	add	a5,a5,a0
 496:	0007c783          	lbu	a5,0(a5)
 49a:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 49e:	0005879b          	sext.w	a5,a1
 4a2:	02c5d5bb          	divuw	a1,a1,a2
 4a6:	0685                	addi	a3,a3,1
 4a8:	fec7f0e3          	bgeu	a5,a2,488 <printint+0x2a>
  if(neg)
 4ac:	00088c63          	beqz	a7,4c4 <printint+0x66>
    buf[i++] = '-';
 4b0:	fd070793          	addi	a5,a4,-48
 4b4:	00878733          	add	a4,a5,s0
 4b8:	02d00793          	li	a5,45
 4bc:	fef70823          	sb	a5,-16(a4)
 4c0:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 4c4:	02e05663          	blez	a4,4f0 <printint+0x92>
 4c8:	fc040793          	addi	a5,s0,-64
 4cc:	00e78933          	add	s2,a5,a4
 4d0:	fff78993          	addi	s3,a5,-1
 4d4:	99ba                	add	s3,s3,a4
 4d6:	377d                	addiw	a4,a4,-1
 4d8:	1702                	slli	a4,a4,0x20
 4da:	9301                	srli	a4,a4,0x20
 4dc:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4e0:	fff94583          	lbu	a1,-1(s2)
 4e4:	8526                	mv	a0,s1
 4e6:	f5bff0ef          	jal	ra,440 <putc>
  while(--i >= 0)
 4ea:	197d                	addi	s2,s2,-1
 4ec:	ff391ae3          	bne	s2,s3,4e0 <printint+0x82>
}
 4f0:	70e2                	ld	ra,56(sp)
 4f2:	7442                	ld	s0,48(sp)
 4f4:	74a2                	ld	s1,40(sp)
 4f6:	7902                	ld	s2,32(sp)
 4f8:	69e2                	ld	s3,24(sp)
 4fa:	6121                	addi	sp,sp,64
 4fc:	8082                	ret
    x = -xx;
 4fe:	40b005bb          	negw	a1,a1
    neg = 1;
 502:	4885                	li	a7,1
    x = -xx;
 504:	bf95                	j	478 <printint+0x1a>

0000000000000506 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 506:	7119                	addi	sp,sp,-128
 508:	fc86                	sd	ra,120(sp)
 50a:	f8a2                	sd	s0,112(sp)
 50c:	f4a6                	sd	s1,104(sp)
 50e:	f0ca                	sd	s2,96(sp)
 510:	ecce                	sd	s3,88(sp)
 512:	e8d2                	sd	s4,80(sp)
 514:	e4d6                	sd	s5,72(sp)
 516:	e0da                	sd	s6,64(sp)
 518:	fc5e                	sd	s7,56(sp)
 51a:	f862                	sd	s8,48(sp)
 51c:	f466                	sd	s9,40(sp)
 51e:	f06a                	sd	s10,32(sp)
 520:	ec6e                	sd	s11,24(sp)
 522:	0100                	addi	s0,sp,128
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 524:	0005c903          	lbu	s2,0(a1)
 528:	22090e63          	beqz	s2,764 <vprintf+0x25e>
 52c:	8b2a                	mv	s6,a0
 52e:	8a2e                	mv	s4,a1
 530:	8bb2                	mv	s7,a2
  state = 0;
 532:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 534:	4481                	li	s1,0
 536:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 538:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 53c:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 540:	06c00d13          	li	s10,108
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 544:	07500d93          	li	s11,117
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 548:	00000c97          	auipc	s9,0x0
 54c:	430c8c93          	addi	s9,s9,1072 # 978 <digits>
 550:	a005                	j	570 <vprintf+0x6a>
        putc(fd, c0);
 552:	85ca                	mv	a1,s2
 554:	855a                	mv	a0,s6
 556:	eebff0ef          	jal	ra,440 <putc>
 55a:	a019                	j	560 <vprintf+0x5a>
    } else if(state == '%'){
 55c:	03598263          	beq	s3,s5,580 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 560:	2485                	addiw	s1,s1,1
 562:	8726                	mv	a4,s1
 564:	009a07b3          	add	a5,s4,s1
 568:	0007c903          	lbu	s2,0(a5)
 56c:	1e090c63          	beqz	s2,764 <vprintf+0x25e>
    c0 = fmt[i] & 0xff;
 570:	0009079b          	sext.w	a5,s2
    if(state == 0){
 574:	fe0994e3          	bnez	s3,55c <vprintf+0x56>
      if(c0 == '%'){
 578:	fd579de3          	bne	a5,s5,552 <vprintf+0x4c>
        state = '%';
 57c:	89be                	mv	s3,a5
 57e:	b7cd                	j	560 <vprintf+0x5a>
      if(c0) c1 = fmt[i+1] & 0xff;
 580:	cfa5                	beqz	a5,5f8 <vprintf+0xf2>
 582:	00ea06b3          	add	a3,s4,a4
 586:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 58a:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 58c:	c681                	beqz	a3,594 <vprintf+0x8e>
 58e:	9752                	add	a4,a4,s4
 590:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 594:	03878a63          	beq	a5,s8,5c8 <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 598:	05a78463          	beq	a5,s10,5e0 <vprintf+0xda>
      } else if(c0 == 'u'){
 59c:	0db78763          	beq	a5,s11,66a <vprintf+0x164>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 5a0:	07800713          	li	a4,120
 5a4:	10e78963          	beq	a5,a4,6b6 <vprintf+0x1b0>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 5a8:	07000713          	li	a4,112
 5ac:	12e78e63          	beq	a5,a4,6e8 <vprintf+0x1e2>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 5b0:	07300713          	li	a4,115
 5b4:	16e78b63          	beq	a5,a4,72a <vprintf+0x224>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 5b8:	05579063          	bne	a5,s5,5f8 <vprintf+0xf2>
        putc(fd, '%');
 5bc:	85d6                	mv	a1,s5
 5be:	855a                	mv	a0,s6
 5c0:	e81ff0ef          	jal	ra,440 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 5c4:	4981                	li	s3,0
 5c6:	bf69                	j	560 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 1);
 5c8:	008b8913          	addi	s2,s7,8
 5cc:	4685                	li	a3,1
 5ce:	4629                	li	a2,10
 5d0:	000ba583          	lw	a1,0(s7)
 5d4:	855a                	mv	a0,s6
 5d6:	e89ff0ef          	jal	ra,45e <printint>
 5da:	8bca                	mv	s7,s2
      state = 0;
 5dc:	4981                	li	s3,0
 5de:	b749                	j	560 <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'd'){
 5e0:	03868663          	beq	a3,s8,60c <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5e4:	05a68163          	beq	a3,s10,626 <vprintf+0x120>
      } else if(c0 == 'l' && c1 == 'u'){
 5e8:	09b68d63          	beq	a3,s11,682 <vprintf+0x17c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 5ec:	03a68f63          	beq	a3,s10,62a <vprintf+0x124>
      } else if(c0 == 'l' && c1 == 'x'){
 5f0:	07800793          	li	a5,120
 5f4:	0cf68d63          	beq	a3,a5,6ce <vprintf+0x1c8>
        putc(fd, '%');
 5f8:	85d6                	mv	a1,s5
 5fa:	855a                	mv	a0,s6
 5fc:	e45ff0ef          	jal	ra,440 <putc>
        putc(fd, c0);
 600:	85ca                	mv	a1,s2
 602:	855a                	mv	a0,s6
 604:	e3dff0ef          	jal	ra,440 <putc>
      state = 0;
 608:	4981                	li	s3,0
 60a:	bf99                	j	560 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 60c:	008b8913          	addi	s2,s7,8
 610:	4685                	li	a3,1
 612:	4629                	li	a2,10
 614:	000ba583          	lw	a1,0(s7)
 618:	855a                	mv	a0,s6
 61a:	e45ff0ef          	jal	ra,45e <printint>
        i += 1;
 61e:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 620:	8bca                	mv	s7,s2
      state = 0;
 622:	4981                	li	s3,0
        i += 1;
 624:	bf35                	j	560 <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 626:	03860563          	beq	a2,s8,650 <vprintf+0x14a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 62a:	07b60963          	beq	a2,s11,69c <vprintf+0x196>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 62e:	07800793          	li	a5,120
 632:	fcf613e3          	bne	a2,a5,5f8 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 636:	008b8913          	addi	s2,s7,8
 63a:	4681                	li	a3,0
 63c:	4641                	li	a2,16
 63e:	000ba583          	lw	a1,0(s7)
 642:	855a                	mv	a0,s6
 644:	e1bff0ef          	jal	ra,45e <printint>
        i += 2;
 648:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 64a:	8bca                	mv	s7,s2
      state = 0;
 64c:	4981                	li	s3,0
        i += 2;
 64e:	bf09                	j	560 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 650:	008b8913          	addi	s2,s7,8
 654:	4685                	li	a3,1
 656:	4629                	li	a2,10
 658:	000ba583          	lw	a1,0(s7)
 65c:	855a                	mv	a0,s6
 65e:	e01ff0ef          	jal	ra,45e <printint>
        i += 2;
 662:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 664:	8bca                	mv	s7,s2
      state = 0;
 666:	4981                	li	s3,0
        i += 2;
 668:	bde5                	j	560 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 0);
 66a:	008b8913          	addi	s2,s7,8
 66e:	4681                	li	a3,0
 670:	4629                	li	a2,10
 672:	000ba583          	lw	a1,0(s7)
 676:	855a                	mv	a0,s6
 678:	de7ff0ef          	jal	ra,45e <printint>
 67c:	8bca                	mv	s7,s2
      state = 0;
 67e:	4981                	li	s3,0
 680:	b5c5                	j	560 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 682:	008b8913          	addi	s2,s7,8
 686:	4681                	li	a3,0
 688:	4629                	li	a2,10
 68a:	000ba583          	lw	a1,0(s7)
 68e:	855a                	mv	a0,s6
 690:	dcfff0ef          	jal	ra,45e <printint>
        i += 1;
 694:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 696:	8bca                	mv	s7,s2
      state = 0;
 698:	4981                	li	s3,0
        i += 1;
 69a:	b5d9                	j	560 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 69c:	008b8913          	addi	s2,s7,8
 6a0:	4681                	li	a3,0
 6a2:	4629                	li	a2,10
 6a4:	000ba583          	lw	a1,0(s7)
 6a8:	855a                	mv	a0,s6
 6aa:	db5ff0ef          	jal	ra,45e <printint>
        i += 2;
 6ae:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 6b0:	8bca                	mv	s7,s2
      state = 0;
 6b2:	4981                	li	s3,0
        i += 2;
 6b4:	b575                	j	560 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 16, 0);
 6b6:	008b8913          	addi	s2,s7,8
 6ba:	4681                	li	a3,0
 6bc:	4641                	li	a2,16
 6be:	000ba583          	lw	a1,0(s7)
 6c2:	855a                	mv	a0,s6
 6c4:	d9bff0ef          	jal	ra,45e <printint>
 6c8:	8bca                	mv	s7,s2
      state = 0;
 6ca:	4981                	li	s3,0
 6cc:	bd51                	j	560 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6ce:	008b8913          	addi	s2,s7,8
 6d2:	4681                	li	a3,0
 6d4:	4641                	li	a2,16
 6d6:	000ba583          	lw	a1,0(s7)
 6da:	855a                	mv	a0,s6
 6dc:	d83ff0ef          	jal	ra,45e <printint>
        i += 1;
 6e0:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 6e2:	8bca                	mv	s7,s2
      state = 0;
 6e4:	4981                	li	s3,0
        i += 1;
 6e6:	bdad                	j	560 <vprintf+0x5a>
        printptr(fd, va_arg(ap, uint64));
 6e8:	008b8793          	addi	a5,s7,8
 6ec:	f8f43423          	sd	a5,-120(s0)
 6f0:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6f4:	03000593          	li	a1,48
 6f8:	855a                	mv	a0,s6
 6fa:	d47ff0ef          	jal	ra,440 <putc>
  putc(fd, 'x');
 6fe:	07800593          	li	a1,120
 702:	855a                	mv	a0,s6
 704:	d3dff0ef          	jal	ra,440 <putc>
 708:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 70a:	03c9d793          	srli	a5,s3,0x3c
 70e:	97e6                	add	a5,a5,s9
 710:	0007c583          	lbu	a1,0(a5)
 714:	855a                	mv	a0,s6
 716:	d2bff0ef          	jal	ra,440 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 71a:	0992                	slli	s3,s3,0x4
 71c:	397d                	addiw	s2,s2,-1
 71e:	fe0916e3          	bnez	s2,70a <vprintf+0x204>
        printptr(fd, va_arg(ap, uint64));
 722:	f8843b83          	ld	s7,-120(s0)
      state = 0;
 726:	4981                	li	s3,0
 728:	bd25                	j	560 <vprintf+0x5a>
        if((s = va_arg(ap, char*)) == 0)
 72a:	008b8993          	addi	s3,s7,8
 72e:	000bb903          	ld	s2,0(s7)
 732:	00090f63          	beqz	s2,750 <vprintf+0x24a>
        for(; *s; s++)
 736:	00094583          	lbu	a1,0(s2)
 73a:	c195                	beqz	a1,75e <vprintf+0x258>
          putc(fd, *s);
 73c:	855a                	mv	a0,s6
 73e:	d03ff0ef          	jal	ra,440 <putc>
        for(; *s; s++)
 742:	0905                	addi	s2,s2,1
 744:	00094583          	lbu	a1,0(s2)
 748:	f9f5                	bnez	a1,73c <vprintf+0x236>
        if((s = va_arg(ap, char*)) == 0)
 74a:	8bce                	mv	s7,s3
      state = 0;
 74c:	4981                	li	s3,0
 74e:	bd09                	j	560 <vprintf+0x5a>
          s = "(null)";
 750:	00000917          	auipc	s2,0x0
 754:	22090913          	addi	s2,s2,544 # 970 <malloc+0x110>
        for(; *s; s++)
 758:	02800593          	li	a1,40
 75c:	b7c5                	j	73c <vprintf+0x236>
        if((s = va_arg(ap, char*)) == 0)
 75e:	8bce                	mv	s7,s3
      state = 0;
 760:	4981                	li	s3,0
 762:	bbfd                	j	560 <vprintf+0x5a>
    }
  }
}
 764:	70e6                	ld	ra,120(sp)
 766:	7446                	ld	s0,112(sp)
 768:	74a6                	ld	s1,104(sp)
 76a:	7906                	ld	s2,96(sp)
 76c:	69e6                	ld	s3,88(sp)
 76e:	6a46                	ld	s4,80(sp)
 770:	6aa6                	ld	s5,72(sp)
 772:	6b06                	ld	s6,64(sp)
 774:	7be2                	ld	s7,56(sp)
 776:	7c42                	ld	s8,48(sp)
 778:	7ca2                	ld	s9,40(sp)
 77a:	7d02                	ld	s10,32(sp)
 77c:	6de2                	ld	s11,24(sp)
 77e:	6109                	addi	sp,sp,128
 780:	8082                	ret

0000000000000782 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 782:	715d                	addi	sp,sp,-80
 784:	ec06                	sd	ra,24(sp)
 786:	e822                	sd	s0,16(sp)
 788:	1000                	addi	s0,sp,32
 78a:	e010                	sd	a2,0(s0)
 78c:	e414                	sd	a3,8(s0)
 78e:	e818                	sd	a4,16(s0)
 790:	ec1c                	sd	a5,24(s0)
 792:	03043023          	sd	a6,32(s0)
 796:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 79a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 79e:	8622                	mv	a2,s0
 7a0:	d67ff0ef          	jal	ra,506 <vprintf>
}
 7a4:	60e2                	ld	ra,24(sp)
 7a6:	6442                	ld	s0,16(sp)
 7a8:	6161                	addi	sp,sp,80
 7aa:	8082                	ret

00000000000007ac <printf>:

void
printf(const char *fmt, ...)
{
 7ac:	711d                	addi	sp,sp,-96
 7ae:	ec06                	sd	ra,24(sp)
 7b0:	e822                	sd	s0,16(sp)
 7b2:	1000                	addi	s0,sp,32
 7b4:	e40c                	sd	a1,8(s0)
 7b6:	e810                	sd	a2,16(s0)
 7b8:	ec14                	sd	a3,24(s0)
 7ba:	f018                	sd	a4,32(s0)
 7bc:	f41c                	sd	a5,40(s0)
 7be:	03043823          	sd	a6,48(s0)
 7c2:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7c6:	00840613          	addi	a2,s0,8
 7ca:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7ce:	85aa                	mv	a1,a0
 7d0:	4505                	li	a0,1
 7d2:	d35ff0ef          	jal	ra,506 <vprintf>
}
 7d6:	60e2                	ld	ra,24(sp)
 7d8:	6442                	ld	s0,16(sp)
 7da:	6125                	addi	sp,sp,96
 7dc:	8082                	ret

00000000000007de <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7de:	1141                	addi	sp,sp,-16
 7e0:	e422                	sd	s0,8(sp)
 7e2:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7e4:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7e8:	00001797          	auipc	a5,0x1
 7ec:	8187b783          	ld	a5,-2024(a5) # 1000 <freep>
 7f0:	a02d                	j	81a <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7f2:	4618                	lw	a4,8(a2)
 7f4:	9f2d                	addw	a4,a4,a1
 7f6:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7fa:	6398                	ld	a4,0(a5)
 7fc:	6310                	ld	a2,0(a4)
 7fe:	a83d                	j	83c <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 800:	ff852703          	lw	a4,-8(a0)
 804:	9f31                	addw	a4,a4,a2
 806:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 808:	ff053683          	ld	a3,-16(a0)
 80c:	a091                	j	850 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 80e:	6398                	ld	a4,0(a5)
 810:	00e7e463          	bltu	a5,a4,818 <free+0x3a>
 814:	00e6ea63          	bltu	a3,a4,828 <free+0x4a>
{
 818:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 81a:	fed7fae3          	bgeu	a5,a3,80e <free+0x30>
 81e:	6398                	ld	a4,0(a5)
 820:	00e6e463          	bltu	a3,a4,828 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 824:	fee7eae3          	bltu	a5,a4,818 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 828:	ff852583          	lw	a1,-8(a0)
 82c:	6390                	ld	a2,0(a5)
 82e:	02059813          	slli	a6,a1,0x20
 832:	01c85713          	srli	a4,a6,0x1c
 836:	9736                	add	a4,a4,a3
 838:	fae60de3          	beq	a2,a4,7f2 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 83c:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 840:	4790                	lw	a2,8(a5)
 842:	02061593          	slli	a1,a2,0x20
 846:	01c5d713          	srli	a4,a1,0x1c
 84a:	973e                	add	a4,a4,a5
 84c:	fae68ae3          	beq	a3,a4,800 <free+0x22>
    p->s.ptr = bp->s.ptr;
 850:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 852:	00000717          	auipc	a4,0x0
 856:	7af73723          	sd	a5,1966(a4) # 1000 <freep>
}
 85a:	6422                	ld	s0,8(sp)
 85c:	0141                	addi	sp,sp,16
 85e:	8082                	ret

0000000000000860 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 860:	7139                	addi	sp,sp,-64
 862:	fc06                	sd	ra,56(sp)
 864:	f822                	sd	s0,48(sp)
 866:	f426                	sd	s1,40(sp)
 868:	f04a                	sd	s2,32(sp)
 86a:	ec4e                	sd	s3,24(sp)
 86c:	e852                	sd	s4,16(sp)
 86e:	e456                	sd	s5,8(sp)
 870:	e05a                	sd	s6,0(sp)
 872:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 874:	02051493          	slli	s1,a0,0x20
 878:	9081                	srli	s1,s1,0x20
 87a:	04bd                	addi	s1,s1,15
 87c:	8091                	srli	s1,s1,0x4
 87e:	0014899b          	addiw	s3,s1,1
 882:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 884:	00000517          	auipc	a0,0x0
 888:	77c53503          	ld	a0,1916(a0) # 1000 <freep>
 88c:	c515                	beqz	a0,8b8 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 88e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 890:	4798                	lw	a4,8(a5)
 892:	02977f63          	bgeu	a4,s1,8d0 <malloc+0x70>
 896:	8a4e                	mv	s4,s3
 898:	0009871b          	sext.w	a4,s3
 89c:	6685                	lui	a3,0x1
 89e:	00d77363          	bgeu	a4,a3,8a4 <malloc+0x44>
 8a2:	6a05                	lui	s4,0x1
 8a4:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8a8:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8ac:	00000917          	auipc	s2,0x0
 8b0:	75490913          	addi	s2,s2,1876 # 1000 <freep>
  if(p == (char*)-1)
 8b4:	5afd                	li	s5,-1
 8b6:	a885                	j	926 <malloc+0xc6>
    base.s.ptr = freep = prevp = &base;
 8b8:	00000797          	auipc	a5,0x0
 8bc:	75878793          	addi	a5,a5,1880 # 1010 <base>
 8c0:	00000717          	auipc	a4,0x0
 8c4:	74f73023          	sd	a5,1856(a4) # 1000 <freep>
 8c8:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8ca:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8ce:	b7e1                	j	896 <malloc+0x36>
      if(p->s.size == nunits)
 8d0:	02e48c63          	beq	s1,a4,908 <malloc+0xa8>
        p->s.size -= nunits;
 8d4:	4137073b          	subw	a4,a4,s3
 8d8:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8da:	02071693          	slli	a3,a4,0x20
 8de:	01c6d713          	srli	a4,a3,0x1c
 8e2:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8e4:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8e8:	00000717          	auipc	a4,0x0
 8ec:	70a73c23          	sd	a0,1816(a4) # 1000 <freep>
      return (void*)(p + 1);
 8f0:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 8f4:	70e2                	ld	ra,56(sp)
 8f6:	7442                	ld	s0,48(sp)
 8f8:	74a2                	ld	s1,40(sp)
 8fa:	7902                	ld	s2,32(sp)
 8fc:	69e2                	ld	s3,24(sp)
 8fe:	6a42                	ld	s4,16(sp)
 900:	6aa2                	ld	s5,8(sp)
 902:	6b02                	ld	s6,0(sp)
 904:	6121                	addi	sp,sp,64
 906:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 908:	6398                	ld	a4,0(a5)
 90a:	e118                	sd	a4,0(a0)
 90c:	bff1                	j	8e8 <malloc+0x88>
  hp->s.size = nu;
 90e:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 912:	0541                	addi	a0,a0,16
 914:	ecbff0ef          	jal	ra,7de <free>
  return freep;
 918:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 91c:	dd61                	beqz	a0,8f4 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 91e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 920:	4798                	lw	a4,8(a5)
 922:	fa9777e3          	bgeu	a4,s1,8d0 <malloc+0x70>
    if(p == freep)
 926:	00093703          	ld	a4,0(s2)
 92a:	853e                	mv	a0,a5
 92c:	fef719e3          	bne	a4,a5,91e <malloc+0xbe>
  p = sbrk(nu * sizeof(Header));
 930:	8552                	mv	a0,s4
 932:	af7ff0ef          	jal	ra,428 <sbrk>
  if(p == (char*)-1)
 936:	fd551ce3          	bne	a0,s5,90e <malloc+0xae>
        return 0;
 93a:	4501                	li	a0,0
 93c:	bf65                	j	8f4 <malloc+0x94>
