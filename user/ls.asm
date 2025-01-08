
user/_ls:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <fmtname>:
#include "kernel/fs.h"
#include "kernel/fcntl.h"

char*
fmtname(char *path)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	addi	s0,sp,48
   e:	84aa                	mv	s1,a0
  static char buf[DIRSIZ+1];
  char *p;

  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
  10:	2ac000ef          	jal	ra,2bc <strlen>
  14:	02051793          	slli	a5,a0,0x20
  18:	9381                	srli	a5,a5,0x20
  1a:	97a6                	add	a5,a5,s1
  1c:	02f00693          	li	a3,47
  20:	0097e963          	bltu	a5,s1,32 <fmtname+0x32>
  24:	0007c703          	lbu	a4,0(a5)
  28:	00d70563          	beq	a4,a3,32 <fmtname+0x32>
  2c:	17fd                	addi	a5,a5,-1
  2e:	fe97fbe3          	bgeu	a5,s1,24 <fmtname+0x24>
    ;
  p++;
  32:	00178493          	addi	s1,a5,1

  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
  36:	8526                	mv	a0,s1
  38:	284000ef          	jal	ra,2bc <strlen>
  3c:	2501                	sext.w	a0,a0
  3e:	47b5                	li	a5,13
  40:	00a7fa63          	bgeu	a5,a0,54 <fmtname+0x54>
    return p;
  memmove(buf, p, strlen(p));
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  return buf;
}
  44:	8526                	mv	a0,s1
  46:	70a2                	ld	ra,40(sp)
  48:	7402                	ld	s0,32(sp)
  4a:	64e2                	ld	s1,24(sp)
  4c:	6942                	ld	s2,16(sp)
  4e:	69a2                	ld	s3,8(sp)
  50:	6145                	addi	sp,sp,48
  52:	8082                	ret
  memmove(buf, p, strlen(p));
  54:	8526                	mv	a0,s1
  56:	266000ef          	jal	ra,2bc <strlen>
  5a:	00001997          	auipc	s3,0x1
  5e:	fb698993          	addi	s3,s3,-74 # 1010 <buf.0>
  62:	0005061b          	sext.w	a2,a0
  66:	85a6                	mv	a1,s1
  68:	854e                	mv	a0,s3
  6a:	3b4000ef          	jal	ra,41e <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  6e:	8526                	mv	a0,s1
  70:	24c000ef          	jal	ra,2bc <strlen>
  74:	0005091b          	sext.w	s2,a0
  78:	8526                	mv	a0,s1
  7a:	242000ef          	jal	ra,2bc <strlen>
  7e:	1902                	slli	s2,s2,0x20
  80:	02095913          	srli	s2,s2,0x20
  84:	4639                	li	a2,14
  86:	9e09                	subw	a2,a2,a0
  88:	02000593          	li	a1,32
  8c:	01298533          	add	a0,s3,s2
  90:	256000ef          	jal	ra,2e6 <memset>
  return buf;
  94:	84ce                	mv	s1,s3
  96:	b77d                	j	44 <fmtname+0x44>

0000000000000098 <ls>:

void
ls(char *path)
{
  98:	d9010113          	addi	sp,sp,-624
  9c:	26113423          	sd	ra,616(sp)
  a0:	26813023          	sd	s0,608(sp)
  a4:	24913c23          	sd	s1,600(sp)
  a8:	25213823          	sd	s2,592(sp)
  ac:	25313423          	sd	s3,584(sp)
  b0:	25413023          	sd	s4,576(sp)
  b4:	23513c23          	sd	s5,568(sp)
  b8:	1c80                	addi	s0,sp,624
  ba:	892a                	mv	s2,a0
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(path, O_RDONLY)) < 0){
  bc:	4581                	li	a1,0
  be:	44e000ef          	jal	ra,50c <open>
  c2:	06054963          	bltz	a0,134 <ls+0x9c>
  c6:	84aa                	mv	s1,a0
    fprintf(2, "ls: cannot open %s\n", path);
    return;
  }

  if(fstat(fd, &st) < 0){
  c8:	d9840593          	addi	a1,s0,-616
  cc:	458000ef          	jal	ra,524 <fstat>
  d0:	06054b63          	bltz	a0,146 <ls+0xae>
    fprintf(2, "ls: cannot stat %s\n", path);
    close(fd);
    return;
  }

  switch(st.type){
  d4:	da041783          	lh	a5,-608(s0)
  d8:	0007869b          	sext.w	a3,a5
  dc:	4705                	li	a4,1
  de:	08e68063          	beq	a3,a4,15e <ls+0xc6>
  e2:	37f9                	addiw	a5,a5,-2
  e4:	17c2                	slli	a5,a5,0x30
  e6:	93c1                	srli	a5,a5,0x30
  e8:	02f76263          	bltu	a4,a5,10c <ls+0x74>
  case T_DEVICE:
  case T_FILE:
    printf("%s %d %d %d\n", fmtname(path), st.type, st.ino, (int) st.size);
  ec:	854a                	mv	a0,s2
  ee:	f13ff0ef          	jal	ra,0 <fmtname>
  f2:	85aa                	mv	a1,a0
  f4:	da842703          	lw	a4,-600(s0)
  f8:	d9c42683          	lw	a3,-612(s0)
  fc:	da041603          	lh	a2,-608(s0)
 100:	00001517          	auipc	a0,0x1
 104:	9a050513          	addi	a0,a0,-1632 # aa0 <malloc+0x114>
 108:	7d0000ef          	jal	ra,8d8 <printf>
      }
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, (int) st.size);
    }
    break;
  }
  close(fd);
 10c:	8526                	mv	a0,s1
 10e:	3e6000ef          	jal	ra,4f4 <close>
}
 112:	26813083          	ld	ra,616(sp)
 116:	26013403          	ld	s0,608(sp)
 11a:	25813483          	ld	s1,600(sp)
 11e:	25013903          	ld	s2,592(sp)
 122:	24813983          	ld	s3,584(sp)
 126:	24013a03          	ld	s4,576(sp)
 12a:	23813a83          	ld	s5,568(sp)
 12e:	27010113          	addi	sp,sp,624
 132:	8082                	ret
    fprintf(2, "ls: cannot open %s\n", path);
 134:	864a                	mv	a2,s2
 136:	00001597          	auipc	a1,0x1
 13a:	93a58593          	addi	a1,a1,-1734 # a70 <malloc+0xe4>
 13e:	4509                	li	a0,2
 140:	76e000ef          	jal	ra,8ae <fprintf>
    return;
 144:	b7f9                	j	112 <ls+0x7a>
    fprintf(2, "ls: cannot stat %s\n", path);
 146:	864a                	mv	a2,s2
 148:	00001597          	auipc	a1,0x1
 14c:	94058593          	addi	a1,a1,-1728 # a88 <malloc+0xfc>
 150:	4509                	li	a0,2
 152:	75c000ef          	jal	ra,8ae <fprintf>
    close(fd);
 156:	8526                	mv	a0,s1
 158:	39c000ef          	jal	ra,4f4 <close>
    return;
 15c:	bf5d                	j	112 <ls+0x7a>
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 15e:	854a                	mv	a0,s2
 160:	15c000ef          	jal	ra,2bc <strlen>
 164:	2541                	addiw	a0,a0,16
 166:	20000793          	li	a5,512
 16a:	00a7f963          	bgeu	a5,a0,17c <ls+0xe4>
      printf("ls: path too long\n");
 16e:	00001517          	auipc	a0,0x1
 172:	94250513          	addi	a0,a0,-1726 # ab0 <malloc+0x124>
 176:	762000ef          	jal	ra,8d8 <printf>
      break;
 17a:	bf49                	j	10c <ls+0x74>
    strcpy(buf, path);
 17c:	85ca                	mv	a1,s2
 17e:	dc040513          	addi	a0,s0,-576
 182:	0f2000ef          	jal	ra,274 <strcpy>
    p = buf+strlen(buf);
 186:	dc040513          	addi	a0,s0,-576
 18a:	132000ef          	jal	ra,2bc <strlen>
 18e:	1502                	slli	a0,a0,0x20
 190:	9101                	srli	a0,a0,0x20
 192:	dc040793          	addi	a5,s0,-576
 196:	00a78933          	add	s2,a5,a0
    *p++ = '/';
 19a:	00190993          	addi	s3,s2,1
 19e:	02f00793          	li	a5,47
 1a2:	00f90023          	sb	a5,0(s2)
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, (int) st.size);
 1a6:	00001a17          	auipc	s4,0x1
 1aa:	8faa0a13          	addi	s4,s4,-1798 # aa0 <malloc+0x114>
        printf("ls: cannot stat %s\n", buf);
 1ae:	00001a97          	auipc	s5,0x1
 1b2:	8daa8a93          	addi	s5,s5,-1830 # a88 <malloc+0xfc>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1b6:	a031                	j	1c2 <ls+0x12a>
        printf("ls: cannot stat %s\n", buf);
 1b8:	dc040593          	addi	a1,s0,-576
 1bc:	8556                	mv	a0,s5
 1be:	71a000ef          	jal	ra,8d8 <printf>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1c2:	4641                	li	a2,16
 1c4:	db040593          	addi	a1,s0,-592
 1c8:	8526                	mv	a0,s1
 1ca:	31a000ef          	jal	ra,4e4 <read>
 1ce:	47c1                	li	a5,16
 1d0:	f2f51ee3          	bne	a0,a5,10c <ls+0x74>
      if(de.inum == 0)
 1d4:	db045783          	lhu	a5,-592(s0)
 1d8:	d7ed                	beqz	a5,1c2 <ls+0x12a>
      memmove(p, de.name, DIRSIZ);
 1da:	4639                	li	a2,14
 1dc:	db240593          	addi	a1,s0,-590
 1e0:	854e                	mv	a0,s3
 1e2:	23c000ef          	jal	ra,41e <memmove>
      p[DIRSIZ] = 0;
 1e6:	000907a3          	sb	zero,15(s2)
      if(stat(buf, &st) < 0){
 1ea:	d9840593          	addi	a1,s0,-616
 1ee:	dc040513          	addi	a0,s0,-576
 1f2:	1aa000ef          	jal	ra,39c <stat>
 1f6:	fc0541e3          	bltz	a0,1b8 <ls+0x120>
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, (int) st.size);
 1fa:	dc040513          	addi	a0,s0,-576
 1fe:	e03ff0ef          	jal	ra,0 <fmtname>
 202:	85aa                	mv	a1,a0
 204:	da842703          	lw	a4,-600(s0)
 208:	d9c42683          	lw	a3,-612(s0)
 20c:	da041603          	lh	a2,-608(s0)
 210:	8552                	mv	a0,s4
 212:	6c6000ef          	jal	ra,8d8 <printf>
 216:	b775                	j	1c2 <ls+0x12a>

0000000000000218 <main>:

int
main(int argc, char *argv[])
{
 218:	1101                	addi	sp,sp,-32
 21a:	ec06                	sd	ra,24(sp)
 21c:	e822                	sd	s0,16(sp)
 21e:	e426                	sd	s1,8(sp)
 220:	e04a                	sd	s2,0(sp)
 222:	1000                	addi	s0,sp,32
  int i;

  if(argc < 2){
 224:	4785                	li	a5,1
 226:	02a7d563          	bge	a5,a0,250 <main+0x38>
 22a:	00858493          	addi	s1,a1,8
 22e:	ffe5091b          	addiw	s2,a0,-2
 232:	02091793          	slli	a5,s2,0x20
 236:	01d7d913          	srli	s2,a5,0x1d
 23a:	05c1                	addi	a1,a1,16
 23c:	992e                	add	s2,s2,a1
    ls(".");
    exit(0);
  }
  for(i=1; i<argc; i++)
    ls(argv[i]);
 23e:	6088                	ld	a0,0(s1)
 240:	e59ff0ef          	jal	ra,98 <ls>
  for(i=1; i<argc; i++)
 244:	04a1                	addi	s1,s1,8
 246:	ff249ce3          	bne	s1,s2,23e <main+0x26>
  exit(0);
 24a:	4501                	li	a0,0
 24c:	280000ef          	jal	ra,4cc <exit>
    ls(".");
 250:	00001517          	auipc	a0,0x1
 254:	87850513          	addi	a0,a0,-1928 # ac8 <malloc+0x13c>
 258:	e41ff0ef          	jal	ra,98 <ls>
    exit(0);
 25c:	4501                	li	a0,0
 25e:	26e000ef          	jal	ra,4cc <exit>

0000000000000262 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 262:	1141                	addi	sp,sp,-16
 264:	e406                	sd	ra,8(sp)
 266:	e022                	sd	s0,0(sp)
 268:	0800                	addi	s0,sp,16
  extern int main();
  main();
 26a:	fafff0ef          	jal	ra,218 <main>
  exit(0);
 26e:	4501                	li	a0,0
 270:	25c000ef          	jal	ra,4cc <exit>

0000000000000274 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 274:	1141                	addi	sp,sp,-16
 276:	e422                	sd	s0,8(sp)
 278:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 27a:	87aa                	mv	a5,a0
 27c:	0585                	addi	a1,a1,1
 27e:	0785                	addi	a5,a5,1
 280:	fff5c703          	lbu	a4,-1(a1)
 284:	fee78fa3          	sb	a4,-1(a5)
 288:	fb75                	bnez	a4,27c <strcpy+0x8>
    ;
  return os;
}
 28a:	6422                	ld	s0,8(sp)
 28c:	0141                	addi	sp,sp,16
 28e:	8082                	ret

0000000000000290 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 290:	1141                	addi	sp,sp,-16
 292:	e422                	sd	s0,8(sp)
 294:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 296:	00054783          	lbu	a5,0(a0)
 29a:	cb91                	beqz	a5,2ae <strcmp+0x1e>
 29c:	0005c703          	lbu	a4,0(a1)
 2a0:	00f71763          	bne	a4,a5,2ae <strcmp+0x1e>
    p++, q++;
 2a4:	0505                	addi	a0,a0,1
 2a6:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 2a8:	00054783          	lbu	a5,0(a0)
 2ac:	fbe5                	bnez	a5,29c <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 2ae:	0005c503          	lbu	a0,0(a1)
}
 2b2:	40a7853b          	subw	a0,a5,a0
 2b6:	6422                	ld	s0,8(sp)
 2b8:	0141                	addi	sp,sp,16
 2ba:	8082                	ret

00000000000002bc <strlen>:

uint
strlen(const char *s)
{
 2bc:	1141                	addi	sp,sp,-16
 2be:	e422                	sd	s0,8(sp)
 2c0:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 2c2:	00054783          	lbu	a5,0(a0)
 2c6:	cf91                	beqz	a5,2e2 <strlen+0x26>
 2c8:	0505                	addi	a0,a0,1
 2ca:	87aa                	mv	a5,a0
 2cc:	4685                	li	a3,1
 2ce:	9e89                	subw	a3,a3,a0
 2d0:	00f6853b          	addw	a0,a3,a5
 2d4:	0785                	addi	a5,a5,1
 2d6:	fff7c703          	lbu	a4,-1(a5)
 2da:	fb7d                	bnez	a4,2d0 <strlen+0x14>
    ;
  return n;
}
 2dc:	6422                	ld	s0,8(sp)
 2de:	0141                	addi	sp,sp,16
 2e0:	8082                	ret
  for(n = 0; s[n]; n++)
 2e2:	4501                	li	a0,0
 2e4:	bfe5                	j	2dc <strlen+0x20>

00000000000002e6 <memset>:

void*
memset(void *dst, int c, uint n)
{
 2e6:	1141                	addi	sp,sp,-16
 2e8:	e422                	sd	s0,8(sp)
 2ea:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 2ec:	ca19                	beqz	a2,302 <memset+0x1c>
 2ee:	87aa                	mv	a5,a0
 2f0:	1602                	slli	a2,a2,0x20
 2f2:	9201                	srli	a2,a2,0x20
 2f4:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 2f8:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 2fc:	0785                	addi	a5,a5,1
 2fe:	fee79de3          	bne	a5,a4,2f8 <memset+0x12>
  }
  return dst;
}
 302:	6422                	ld	s0,8(sp)
 304:	0141                	addi	sp,sp,16
 306:	8082                	ret

0000000000000308 <strchr>:

char*
strchr(const char *s, char c)
{
 308:	1141                	addi	sp,sp,-16
 30a:	e422                	sd	s0,8(sp)
 30c:	0800                	addi	s0,sp,16
  for(; *s; s++)
 30e:	00054783          	lbu	a5,0(a0)
 312:	cb99                	beqz	a5,328 <strchr+0x20>
    if(*s == c)
 314:	00f58763          	beq	a1,a5,322 <strchr+0x1a>
  for(; *s; s++)
 318:	0505                	addi	a0,a0,1
 31a:	00054783          	lbu	a5,0(a0)
 31e:	fbfd                	bnez	a5,314 <strchr+0xc>
      return (char*)s;
  return 0;
 320:	4501                	li	a0,0
}
 322:	6422                	ld	s0,8(sp)
 324:	0141                	addi	sp,sp,16
 326:	8082                	ret
  return 0;
 328:	4501                	li	a0,0
 32a:	bfe5                	j	322 <strchr+0x1a>

000000000000032c <gets>:

char*
gets(char *buf, int max)
{
 32c:	711d                	addi	sp,sp,-96
 32e:	ec86                	sd	ra,88(sp)
 330:	e8a2                	sd	s0,80(sp)
 332:	e4a6                	sd	s1,72(sp)
 334:	e0ca                	sd	s2,64(sp)
 336:	fc4e                	sd	s3,56(sp)
 338:	f852                	sd	s4,48(sp)
 33a:	f456                	sd	s5,40(sp)
 33c:	f05a                	sd	s6,32(sp)
 33e:	ec5e                	sd	s7,24(sp)
 340:	1080                	addi	s0,sp,96
 342:	8baa                	mv	s7,a0
 344:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 346:	892a                	mv	s2,a0
 348:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 34a:	4aa9                	li	s5,10
 34c:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 34e:	89a6                	mv	s3,s1
 350:	2485                	addiw	s1,s1,1
 352:	0344d663          	bge	s1,s4,37e <gets+0x52>
    cc = read(0, &c, 1);
 356:	4605                	li	a2,1
 358:	faf40593          	addi	a1,s0,-81
 35c:	4501                	li	a0,0
 35e:	186000ef          	jal	ra,4e4 <read>
    if(cc < 1)
 362:	00a05e63          	blez	a0,37e <gets+0x52>
    buf[i++] = c;
 366:	faf44783          	lbu	a5,-81(s0)
 36a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 36e:	01578763          	beq	a5,s5,37c <gets+0x50>
 372:	0905                	addi	s2,s2,1
 374:	fd679de3          	bne	a5,s6,34e <gets+0x22>
  for(i=0; i+1 < max; ){
 378:	89a6                	mv	s3,s1
 37a:	a011                	j	37e <gets+0x52>
 37c:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 37e:	99de                	add	s3,s3,s7
 380:	00098023          	sb	zero,0(s3)
  return buf;
}
 384:	855e                	mv	a0,s7
 386:	60e6                	ld	ra,88(sp)
 388:	6446                	ld	s0,80(sp)
 38a:	64a6                	ld	s1,72(sp)
 38c:	6906                	ld	s2,64(sp)
 38e:	79e2                	ld	s3,56(sp)
 390:	7a42                	ld	s4,48(sp)
 392:	7aa2                	ld	s5,40(sp)
 394:	7b02                	ld	s6,32(sp)
 396:	6be2                	ld	s7,24(sp)
 398:	6125                	addi	sp,sp,96
 39a:	8082                	ret

000000000000039c <stat>:

int
stat(const char *n, struct stat *st)
{
 39c:	1101                	addi	sp,sp,-32
 39e:	ec06                	sd	ra,24(sp)
 3a0:	e822                	sd	s0,16(sp)
 3a2:	e426                	sd	s1,8(sp)
 3a4:	e04a                	sd	s2,0(sp)
 3a6:	1000                	addi	s0,sp,32
 3a8:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3aa:	4581                	li	a1,0
 3ac:	160000ef          	jal	ra,50c <open>
  if(fd < 0)
 3b0:	02054163          	bltz	a0,3d2 <stat+0x36>
 3b4:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 3b6:	85ca                	mv	a1,s2
 3b8:	16c000ef          	jal	ra,524 <fstat>
 3bc:	892a                	mv	s2,a0
  close(fd);
 3be:	8526                	mv	a0,s1
 3c0:	134000ef          	jal	ra,4f4 <close>
  return r;
}
 3c4:	854a                	mv	a0,s2
 3c6:	60e2                	ld	ra,24(sp)
 3c8:	6442                	ld	s0,16(sp)
 3ca:	64a2                	ld	s1,8(sp)
 3cc:	6902                	ld	s2,0(sp)
 3ce:	6105                	addi	sp,sp,32
 3d0:	8082                	ret
    return -1;
 3d2:	597d                	li	s2,-1
 3d4:	bfc5                	j	3c4 <stat+0x28>

00000000000003d6 <atoi>:

int
atoi(const char *s)
{
 3d6:	1141                	addi	sp,sp,-16
 3d8:	e422                	sd	s0,8(sp)
 3da:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3dc:	00054683          	lbu	a3,0(a0)
 3e0:	fd06879b          	addiw	a5,a3,-48
 3e4:	0ff7f793          	zext.b	a5,a5
 3e8:	4625                	li	a2,9
 3ea:	02f66863          	bltu	a2,a5,41a <atoi+0x44>
 3ee:	872a                	mv	a4,a0
  n = 0;
 3f0:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 3f2:	0705                	addi	a4,a4,1
 3f4:	0025179b          	slliw	a5,a0,0x2
 3f8:	9fa9                	addw	a5,a5,a0
 3fa:	0017979b          	slliw	a5,a5,0x1
 3fe:	9fb5                	addw	a5,a5,a3
 400:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 404:	00074683          	lbu	a3,0(a4)
 408:	fd06879b          	addiw	a5,a3,-48
 40c:	0ff7f793          	zext.b	a5,a5
 410:	fef671e3          	bgeu	a2,a5,3f2 <atoi+0x1c>
  return n;
}
 414:	6422                	ld	s0,8(sp)
 416:	0141                	addi	sp,sp,16
 418:	8082                	ret
  n = 0;
 41a:	4501                	li	a0,0
 41c:	bfe5                	j	414 <atoi+0x3e>

000000000000041e <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 41e:	1141                	addi	sp,sp,-16
 420:	e422                	sd	s0,8(sp)
 422:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 424:	02b57463          	bgeu	a0,a1,44c <memmove+0x2e>
    while(n-- > 0)
 428:	00c05f63          	blez	a2,446 <memmove+0x28>
 42c:	1602                	slli	a2,a2,0x20
 42e:	9201                	srli	a2,a2,0x20
 430:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 434:	872a                	mv	a4,a0
      *dst++ = *src++;
 436:	0585                	addi	a1,a1,1
 438:	0705                	addi	a4,a4,1
 43a:	fff5c683          	lbu	a3,-1(a1)
 43e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 442:	fee79ae3          	bne	a5,a4,436 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 446:	6422                	ld	s0,8(sp)
 448:	0141                	addi	sp,sp,16
 44a:	8082                	ret
    dst += n;
 44c:	00c50733          	add	a4,a0,a2
    src += n;
 450:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 452:	fec05ae3          	blez	a2,446 <memmove+0x28>
 456:	fff6079b          	addiw	a5,a2,-1
 45a:	1782                	slli	a5,a5,0x20
 45c:	9381                	srli	a5,a5,0x20
 45e:	fff7c793          	not	a5,a5
 462:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 464:	15fd                	addi	a1,a1,-1
 466:	177d                	addi	a4,a4,-1
 468:	0005c683          	lbu	a3,0(a1)
 46c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 470:	fee79ae3          	bne	a5,a4,464 <memmove+0x46>
 474:	bfc9                	j	446 <memmove+0x28>

0000000000000476 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 476:	1141                	addi	sp,sp,-16
 478:	e422                	sd	s0,8(sp)
 47a:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 47c:	ca05                	beqz	a2,4ac <memcmp+0x36>
 47e:	fff6069b          	addiw	a3,a2,-1
 482:	1682                	slli	a3,a3,0x20
 484:	9281                	srli	a3,a3,0x20
 486:	0685                	addi	a3,a3,1
 488:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 48a:	00054783          	lbu	a5,0(a0)
 48e:	0005c703          	lbu	a4,0(a1)
 492:	00e79863          	bne	a5,a4,4a2 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 496:	0505                	addi	a0,a0,1
    p2++;
 498:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 49a:	fed518e3          	bne	a0,a3,48a <memcmp+0x14>
  }
  return 0;
 49e:	4501                	li	a0,0
 4a0:	a019                	j	4a6 <memcmp+0x30>
      return *p1 - *p2;
 4a2:	40e7853b          	subw	a0,a5,a4
}
 4a6:	6422                	ld	s0,8(sp)
 4a8:	0141                	addi	sp,sp,16
 4aa:	8082                	ret
  return 0;
 4ac:	4501                	li	a0,0
 4ae:	bfe5                	j	4a6 <memcmp+0x30>

00000000000004b0 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 4b0:	1141                	addi	sp,sp,-16
 4b2:	e406                	sd	ra,8(sp)
 4b4:	e022                	sd	s0,0(sp)
 4b6:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 4b8:	f67ff0ef          	jal	ra,41e <memmove>
}
 4bc:	60a2                	ld	ra,8(sp)
 4be:	6402                	ld	s0,0(sp)
 4c0:	0141                	addi	sp,sp,16
 4c2:	8082                	ret

00000000000004c4 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 4c4:	4885                	li	a7,1
 ecall
 4c6:	00000073          	ecall
 ret
 4ca:	8082                	ret

00000000000004cc <exit>:
.global exit
exit:
 li a7, SYS_exit
 4cc:	4889                	li	a7,2
 ecall
 4ce:	00000073          	ecall
 ret
 4d2:	8082                	ret

00000000000004d4 <wait>:
.global wait
wait:
 li a7, SYS_wait
 4d4:	488d                	li	a7,3
 ecall
 4d6:	00000073          	ecall
 ret
 4da:	8082                	ret

00000000000004dc <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 4dc:	4891                	li	a7,4
 ecall
 4de:	00000073          	ecall
 ret
 4e2:	8082                	ret

00000000000004e4 <read>:
.global read
read:
 li a7, SYS_read
 4e4:	4895                	li	a7,5
 ecall
 4e6:	00000073          	ecall
 ret
 4ea:	8082                	ret

00000000000004ec <write>:
.global write
write:
 li a7, SYS_write
 4ec:	48c1                	li	a7,16
 ecall
 4ee:	00000073          	ecall
 ret
 4f2:	8082                	ret

00000000000004f4 <close>:
.global close
close:
 li a7, SYS_close
 4f4:	48d5                	li	a7,21
 ecall
 4f6:	00000073          	ecall
 ret
 4fa:	8082                	ret

00000000000004fc <kill>:
.global kill
kill:
 li a7, SYS_kill
 4fc:	4899                	li	a7,6
 ecall
 4fe:	00000073          	ecall
 ret
 502:	8082                	ret

0000000000000504 <exec>:
.global exec
exec:
 li a7, SYS_exec
 504:	489d                	li	a7,7
 ecall
 506:	00000073          	ecall
 ret
 50a:	8082                	ret

000000000000050c <open>:
.global open
open:
 li a7, SYS_open
 50c:	48bd                	li	a7,15
 ecall
 50e:	00000073          	ecall
 ret
 512:	8082                	ret

0000000000000514 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 514:	48c5                	li	a7,17
 ecall
 516:	00000073          	ecall
 ret
 51a:	8082                	ret

000000000000051c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 51c:	48c9                	li	a7,18
 ecall
 51e:	00000073          	ecall
 ret
 522:	8082                	ret

0000000000000524 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 524:	48a1                	li	a7,8
 ecall
 526:	00000073          	ecall
 ret
 52a:	8082                	ret

000000000000052c <link>:
.global link
link:
 li a7, SYS_link
 52c:	48cd                	li	a7,19
 ecall
 52e:	00000073          	ecall
 ret
 532:	8082                	ret

0000000000000534 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 534:	48d1                	li	a7,20
 ecall
 536:	00000073          	ecall
 ret
 53a:	8082                	ret

000000000000053c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 53c:	48a5                	li	a7,9
 ecall
 53e:	00000073          	ecall
 ret
 542:	8082                	ret

0000000000000544 <dup>:
.global dup
dup:
 li a7, SYS_dup
 544:	48a9                	li	a7,10
 ecall
 546:	00000073          	ecall
 ret
 54a:	8082                	ret

000000000000054c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 54c:	48ad                	li	a7,11
 ecall
 54e:	00000073          	ecall
 ret
 552:	8082                	ret

0000000000000554 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 554:	48b1                	li	a7,12
 ecall
 556:	00000073          	ecall
 ret
 55a:	8082                	ret

000000000000055c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 55c:	48b5                	li	a7,13
 ecall
 55e:	00000073          	ecall
 ret
 562:	8082                	ret

0000000000000564 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 564:	48b9                	li	a7,14
 ecall
 566:	00000073          	ecall
 ret
 56a:	8082                	ret

000000000000056c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 56c:	1101                	addi	sp,sp,-32
 56e:	ec06                	sd	ra,24(sp)
 570:	e822                	sd	s0,16(sp)
 572:	1000                	addi	s0,sp,32
 574:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 578:	4605                	li	a2,1
 57a:	fef40593          	addi	a1,s0,-17
 57e:	f6fff0ef          	jal	ra,4ec <write>
}
 582:	60e2                	ld	ra,24(sp)
 584:	6442                	ld	s0,16(sp)
 586:	6105                	addi	sp,sp,32
 588:	8082                	ret

000000000000058a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 58a:	7139                	addi	sp,sp,-64
 58c:	fc06                	sd	ra,56(sp)
 58e:	f822                	sd	s0,48(sp)
 590:	f426                	sd	s1,40(sp)
 592:	f04a                	sd	s2,32(sp)
 594:	ec4e                	sd	s3,24(sp)
 596:	0080                	addi	s0,sp,64
 598:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 59a:	c299                	beqz	a3,5a0 <printint+0x16>
 59c:	0805c763          	bltz	a1,62a <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 5a0:	2581                	sext.w	a1,a1
  neg = 0;
 5a2:	4881                	li	a7,0
 5a4:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 5a8:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 5aa:	2601                	sext.w	a2,a2
 5ac:	00000517          	auipc	a0,0x0
 5b0:	52c50513          	addi	a0,a0,1324 # ad8 <digits>
 5b4:	883a                	mv	a6,a4
 5b6:	2705                	addiw	a4,a4,1
 5b8:	02c5f7bb          	remuw	a5,a1,a2
 5bc:	1782                	slli	a5,a5,0x20
 5be:	9381                	srli	a5,a5,0x20
 5c0:	97aa                	add	a5,a5,a0
 5c2:	0007c783          	lbu	a5,0(a5)
 5c6:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 5ca:	0005879b          	sext.w	a5,a1
 5ce:	02c5d5bb          	divuw	a1,a1,a2
 5d2:	0685                	addi	a3,a3,1
 5d4:	fec7f0e3          	bgeu	a5,a2,5b4 <printint+0x2a>
  if(neg)
 5d8:	00088c63          	beqz	a7,5f0 <printint+0x66>
    buf[i++] = '-';
 5dc:	fd070793          	addi	a5,a4,-48
 5e0:	00878733          	add	a4,a5,s0
 5e4:	02d00793          	li	a5,45
 5e8:	fef70823          	sb	a5,-16(a4)
 5ec:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 5f0:	02e05663          	blez	a4,61c <printint+0x92>
 5f4:	fc040793          	addi	a5,s0,-64
 5f8:	00e78933          	add	s2,a5,a4
 5fc:	fff78993          	addi	s3,a5,-1
 600:	99ba                	add	s3,s3,a4
 602:	377d                	addiw	a4,a4,-1
 604:	1702                	slli	a4,a4,0x20
 606:	9301                	srli	a4,a4,0x20
 608:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 60c:	fff94583          	lbu	a1,-1(s2)
 610:	8526                	mv	a0,s1
 612:	f5bff0ef          	jal	ra,56c <putc>
  while(--i >= 0)
 616:	197d                	addi	s2,s2,-1
 618:	ff391ae3          	bne	s2,s3,60c <printint+0x82>
}
 61c:	70e2                	ld	ra,56(sp)
 61e:	7442                	ld	s0,48(sp)
 620:	74a2                	ld	s1,40(sp)
 622:	7902                	ld	s2,32(sp)
 624:	69e2                	ld	s3,24(sp)
 626:	6121                	addi	sp,sp,64
 628:	8082                	ret
    x = -xx;
 62a:	40b005bb          	negw	a1,a1
    neg = 1;
 62e:	4885                	li	a7,1
    x = -xx;
 630:	bf95                	j	5a4 <printint+0x1a>

0000000000000632 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 632:	7119                	addi	sp,sp,-128
 634:	fc86                	sd	ra,120(sp)
 636:	f8a2                	sd	s0,112(sp)
 638:	f4a6                	sd	s1,104(sp)
 63a:	f0ca                	sd	s2,96(sp)
 63c:	ecce                	sd	s3,88(sp)
 63e:	e8d2                	sd	s4,80(sp)
 640:	e4d6                	sd	s5,72(sp)
 642:	e0da                	sd	s6,64(sp)
 644:	fc5e                	sd	s7,56(sp)
 646:	f862                	sd	s8,48(sp)
 648:	f466                	sd	s9,40(sp)
 64a:	f06a                	sd	s10,32(sp)
 64c:	ec6e                	sd	s11,24(sp)
 64e:	0100                	addi	s0,sp,128
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 650:	0005c903          	lbu	s2,0(a1)
 654:	22090e63          	beqz	s2,890 <vprintf+0x25e>
 658:	8b2a                	mv	s6,a0
 65a:	8a2e                	mv	s4,a1
 65c:	8bb2                	mv	s7,a2
  state = 0;
 65e:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 660:	4481                	li	s1,0
 662:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 664:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 668:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 66c:	06c00d13          	li	s10,108
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 670:	07500d93          	li	s11,117
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 674:	00000c97          	auipc	s9,0x0
 678:	464c8c93          	addi	s9,s9,1124 # ad8 <digits>
 67c:	a005                	j	69c <vprintf+0x6a>
        putc(fd, c0);
 67e:	85ca                	mv	a1,s2
 680:	855a                	mv	a0,s6
 682:	eebff0ef          	jal	ra,56c <putc>
 686:	a019                	j	68c <vprintf+0x5a>
    } else if(state == '%'){
 688:	03598263          	beq	s3,s5,6ac <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 68c:	2485                	addiw	s1,s1,1
 68e:	8726                	mv	a4,s1
 690:	009a07b3          	add	a5,s4,s1
 694:	0007c903          	lbu	s2,0(a5)
 698:	1e090c63          	beqz	s2,890 <vprintf+0x25e>
    c0 = fmt[i] & 0xff;
 69c:	0009079b          	sext.w	a5,s2
    if(state == 0){
 6a0:	fe0994e3          	bnez	s3,688 <vprintf+0x56>
      if(c0 == '%'){
 6a4:	fd579de3          	bne	a5,s5,67e <vprintf+0x4c>
        state = '%';
 6a8:	89be                	mv	s3,a5
 6aa:	b7cd                	j	68c <vprintf+0x5a>
      if(c0) c1 = fmt[i+1] & 0xff;
 6ac:	cfa5                	beqz	a5,724 <vprintf+0xf2>
 6ae:	00ea06b3          	add	a3,s4,a4
 6b2:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 6b6:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 6b8:	c681                	beqz	a3,6c0 <vprintf+0x8e>
 6ba:	9752                	add	a4,a4,s4
 6bc:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 6c0:	03878a63          	beq	a5,s8,6f4 <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 6c4:	05a78463          	beq	a5,s10,70c <vprintf+0xda>
      } else if(c0 == 'u'){
 6c8:	0db78763          	beq	a5,s11,796 <vprintf+0x164>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 6cc:	07800713          	li	a4,120
 6d0:	10e78963          	beq	a5,a4,7e2 <vprintf+0x1b0>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 6d4:	07000713          	li	a4,112
 6d8:	12e78e63          	beq	a5,a4,814 <vprintf+0x1e2>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 6dc:	07300713          	li	a4,115
 6e0:	16e78b63          	beq	a5,a4,856 <vprintf+0x224>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 6e4:	05579063          	bne	a5,s5,724 <vprintf+0xf2>
        putc(fd, '%');
 6e8:	85d6                	mv	a1,s5
 6ea:	855a                	mv	a0,s6
 6ec:	e81ff0ef          	jal	ra,56c <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 6f0:	4981                	li	s3,0
 6f2:	bf69                	j	68c <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 1);
 6f4:	008b8913          	addi	s2,s7,8
 6f8:	4685                	li	a3,1
 6fa:	4629                	li	a2,10
 6fc:	000ba583          	lw	a1,0(s7)
 700:	855a                	mv	a0,s6
 702:	e89ff0ef          	jal	ra,58a <printint>
 706:	8bca                	mv	s7,s2
      state = 0;
 708:	4981                	li	s3,0
 70a:	b749                	j	68c <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'd'){
 70c:	03868663          	beq	a3,s8,738 <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 710:	05a68163          	beq	a3,s10,752 <vprintf+0x120>
      } else if(c0 == 'l' && c1 == 'u'){
 714:	09b68d63          	beq	a3,s11,7ae <vprintf+0x17c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 718:	03a68f63          	beq	a3,s10,756 <vprintf+0x124>
      } else if(c0 == 'l' && c1 == 'x'){
 71c:	07800793          	li	a5,120
 720:	0cf68d63          	beq	a3,a5,7fa <vprintf+0x1c8>
        putc(fd, '%');
 724:	85d6                	mv	a1,s5
 726:	855a                	mv	a0,s6
 728:	e45ff0ef          	jal	ra,56c <putc>
        putc(fd, c0);
 72c:	85ca                	mv	a1,s2
 72e:	855a                	mv	a0,s6
 730:	e3dff0ef          	jal	ra,56c <putc>
      state = 0;
 734:	4981                	li	s3,0
 736:	bf99                	j	68c <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 738:	008b8913          	addi	s2,s7,8
 73c:	4685                	li	a3,1
 73e:	4629                	li	a2,10
 740:	000ba583          	lw	a1,0(s7)
 744:	855a                	mv	a0,s6
 746:	e45ff0ef          	jal	ra,58a <printint>
        i += 1;
 74a:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 74c:	8bca                	mv	s7,s2
      state = 0;
 74e:	4981                	li	s3,0
        i += 1;
 750:	bf35                	j	68c <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 752:	03860563          	beq	a2,s8,77c <vprintf+0x14a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 756:	07b60963          	beq	a2,s11,7c8 <vprintf+0x196>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 75a:	07800793          	li	a5,120
 75e:	fcf613e3          	bne	a2,a5,724 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 762:	008b8913          	addi	s2,s7,8
 766:	4681                	li	a3,0
 768:	4641                	li	a2,16
 76a:	000ba583          	lw	a1,0(s7)
 76e:	855a                	mv	a0,s6
 770:	e1bff0ef          	jal	ra,58a <printint>
        i += 2;
 774:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 776:	8bca                	mv	s7,s2
      state = 0;
 778:	4981                	li	s3,0
        i += 2;
 77a:	bf09                	j	68c <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 77c:	008b8913          	addi	s2,s7,8
 780:	4685                	li	a3,1
 782:	4629                	li	a2,10
 784:	000ba583          	lw	a1,0(s7)
 788:	855a                	mv	a0,s6
 78a:	e01ff0ef          	jal	ra,58a <printint>
        i += 2;
 78e:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 790:	8bca                	mv	s7,s2
      state = 0;
 792:	4981                	li	s3,0
        i += 2;
 794:	bde5                	j	68c <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 0);
 796:	008b8913          	addi	s2,s7,8
 79a:	4681                	li	a3,0
 79c:	4629                	li	a2,10
 79e:	000ba583          	lw	a1,0(s7)
 7a2:	855a                	mv	a0,s6
 7a4:	de7ff0ef          	jal	ra,58a <printint>
 7a8:	8bca                	mv	s7,s2
      state = 0;
 7aa:	4981                	li	s3,0
 7ac:	b5c5                	j	68c <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7ae:	008b8913          	addi	s2,s7,8
 7b2:	4681                	li	a3,0
 7b4:	4629                	li	a2,10
 7b6:	000ba583          	lw	a1,0(s7)
 7ba:	855a                	mv	a0,s6
 7bc:	dcfff0ef          	jal	ra,58a <printint>
        i += 1;
 7c0:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 7c2:	8bca                	mv	s7,s2
      state = 0;
 7c4:	4981                	li	s3,0
        i += 1;
 7c6:	b5d9                	j	68c <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7c8:	008b8913          	addi	s2,s7,8
 7cc:	4681                	li	a3,0
 7ce:	4629                	li	a2,10
 7d0:	000ba583          	lw	a1,0(s7)
 7d4:	855a                	mv	a0,s6
 7d6:	db5ff0ef          	jal	ra,58a <printint>
        i += 2;
 7da:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 7dc:	8bca                	mv	s7,s2
      state = 0;
 7de:	4981                	li	s3,0
        i += 2;
 7e0:	b575                	j	68c <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 16, 0);
 7e2:	008b8913          	addi	s2,s7,8
 7e6:	4681                	li	a3,0
 7e8:	4641                	li	a2,16
 7ea:	000ba583          	lw	a1,0(s7)
 7ee:	855a                	mv	a0,s6
 7f0:	d9bff0ef          	jal	ra,58a <printint>
 7f4:	8bca                	mv	s7,s2
      state = 0;
 7f6:	4981                	li	s3,0
 7f8:	bd51                	j	68c <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 7fa:	008b8913          	addi	s2,s7,8
 7fe:	4681                	li	a3,0
 800:	4641                	li	a2,16
 802:	000ba583          	lw	a1,0(s7)
 806:	855a                	mv	a0,s6
 808:	d83ff0ef          	jal	ra,58a <printint>
        i += 1;
 80c:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 80e:	8bca                	mv	s7,s2
      state = 0;
 810:	4981                	li	s3,0
        i += 1;
 812:	bdad                	j	68c <vprintf+0x5a>
        printptr(fd, va_arg(ap, uint64));
 814:	008b8793          	addi	a5,s7,8
 818:	f8f43423          	sd	a5,-120(s0)
 81c:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 820:	03000593          	li	a1,48
 824:	855a                	mv	a0,s6
 826:	d47ff0ef          	jal	ra,56c <putc>
  putc(fd, 'x');
 82a:	07800593          	li	a1,120
 82e:	855a                	mv	a0,s6
 830:	d3dff0ef          	jal	ra,56c <putc>
 834:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 836:	03c9d793          	srli	a5,s3,0x3c
 83a:	97e6                	add	a5,a5,s9
 83c:	0007c583          	lbu	a1,0(a5)
 840:	855a                	mv	a0,s6
 842:	d2bff0ef          	jal	ra,56c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 846:	0992                	slli	s3,s3,0x4
 848:	397d                	addiw	s2,s2,-1
 84a:	fe0916e3          	bnez	s2,836 <vprintf+0x204>
        printptr(fd, va_arg(ap, uint64));
 84e:	f8843b83          	ld	s7,-120(s0)
      state = 0;
 852:	4981                	li	s3,0
 854:	bd25                	j	68c <vprintf+0x5a>
        if((s = va_arg(ap, char*)) == 0)
 856:	008b8993          	addi	s3,s7,8
 85a:	000bb903          	ld	s2,0(s7)
 85e:	00090f63          	beqz	s2,87c <vprintf+0x24a>
        for(; *s; s++)
 862:	00094583          	lbu	a1,0(s2)
 866:	c195                	beqz	a1,88a <vprintf+0x258>
          putc(fd, *s);
 868:	855a                	mv	a0,s6
 86a:	d03ff0ef          	jal	ra,56c <putc>
        for(; *s; s++)
 86e:	0905                	addi	s2,s2,1
 870:	00094583          	lbu	a1,0(s2)
 874:	f9f5                	bnez	a1,868 <vprintf+0x236>
        if((s = va_arg(ap, char*)) == 0)
 876:	8bce                	mv	s7,s3
      state = 0;
 878:	4981                	li	s3,0
 87a:	bd09                	j	68c <vprintf+0x5a>
          s = "(null)";
 87c:	00000917          	auipc	s2,0x0
 880:	25490913          	addi	s2,s2,596 # ad0 <malloc+0x144>
        for(; *s; s++)
 884:	02800593          	li	a1,40
 888:	b7c5                	j	868 <vprintf+0x236>
        if((s = va_arg(ap, char*)) == 0)
 88a:	8bce                	mv	s7,s3
      state = 0;
 88c:	4981                	li	s3,0
 88e:	bbfd                	j	68c <vprintf+0x5a>
    }
  }
}
 890:	70e6                	ld	ra,120(sp)
 892:	7446                	ld	s0,112(sp)
 894:	74a6                	ld	s1,104(sp)
 896:	7906                	ld	s2,96(sp)
 898:	69e6                	ld	s3,88(sp)
 89a:	6a46                	ld	s4,80(sp)
 89c:	6aa6                	ld	s5,72(sp)
 89e:	6b06                	ld	s6,64(sp)
 8a0:	7be2                	ld	s7,56(sp)
 8a2:	7c42                	ld	s8,48(sp)
 8a4:	7ca2                	ld	s9,40(sp)
 8a6:	7d02                	ld	s10,32(sp)
 8a8:	6de2                	ld	s11,24(sp)
 8aa:	6109                	addi	sp,sp,128
 8ac:	8082                	ret

00000000000008ae <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 8ae:	715d                	addi	sp,sp,-80
 8b0:	ec06                	sd	ra,24(sp)
 8b2:	e822                	sd	s0,16(sp)
 8b4:	1000                	addi	s0,sp,32
 8b6:	e010                	sd	a2,0(s0)
 8b8:	e414                	sd	a3,8(s0)
 8ba:	e818                	sd	a4,16(s0)
 8bc:	ec1c                	sd	a5,24(s0)
 8be:	03043023          	sd	a6,32(s0)
 8c2:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 8c6:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 8ca:	8622                	mv	a2,s0
 8cc:	d67ff0ef          	jal	ra,632 <vprintf>
}
 8d0:	60e2                	ld	ra,24(sp)
 8d2:	6442                	ld	s0,16(sp)
 8d4:	6161                	addi	sp,sp,80
 8d6:	8082                	ret

00000000000008d8 <printf>:

void
printf(const char *fmt, ...)
{
 8d8:	711d                	addi	sp,sp,-96
 8da:	ec06                	sd	ra,24(sp)
 8dc:	e822                	sd	s0,16(sp)
 8de:	1000                	addi	s0,sp,32
 8e0:	e40c                	sd	a1,8(s0)
 8e2:	e810                	sd	a2,16(s0)
 8e4:	ec14                	sd	a3,24(s0)
 8e6:	f018                	sd	a4,32(s0)
 8e8:	f41c                	sd	a5,40(s0)
 8ea:	03043823          	sd	a6,48(s0)
 8ee:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 8f2:	00840613          	addi	a2,s0,8
 8f6:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 8fa:	85aa                	mv	a1,a0
 8fc:	4505                	li	a0,1
 8fe:	d35ff0ef          	jal	ra,632 <vprintf>
}
 902:	60e2                	ld	ra,24(sp)
 904:	6442                	ld	s0,16(sp)
 906:	6125                	addi	sp,sp,96
 908:	8082                	ret

000000000000090a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 90a:	1141                	addi	sp,sp,-16
 90c:	e422                	sd	s0,8(sp)
 90e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 910:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 914:	00000797          	auipc	a5,0x0
 918:	6ec7b783          	ld	a5,1772(a5) # 1000 <freep>
 91c:	a02d                	j	946 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 91e:	4618                	lw	a4,8(a2)
 920:	9f2d                	addw	a4,a4,a1
 922:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 926:	6398                	ld	a4,0(a5)
 928:	6310                	ld	a2,0(a4)
 92a:	a83d                	j	968 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 92c:	ff852703          	lw	a4,-8(a0)
 930:	9f31                	addw	a4,a4,a2
 932:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 934:	ff053683          	ld	a3,-16(a0)
 938:	a091                	j	97c <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 93a:	6398                	ld	a4,0(a5)
 93c:	00e7e463          	bltu	a5,a4,944 <free+0x3a>
 940:	00e6ea63          	bltu	a3,a4,954 <free+0x4a>
{
 944:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 946:	fed7fae3          	bgeu	a5,a3,93a <free+0x30>
 94a:	6398                	ld	a4,0(a5)
 94c:	00e6e463          	bltu	a3,a4,954 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 950:	fee7eae3          	bltu	a5,a4,944 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 954:	ff852583          	lw	a1,-8(a0)
 958:	6390                	ld	a2,0(a5)
 95a:	02059813          	slli	a6,a1,0x20
 95e:	01c85713          	srli	a4,a6,0x1c
 962:	9736                	add	a4,a4,a3
 964:	fae60de3          	beq	a2,a4,91e <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 968:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 96c:	4790                	lw	a2,8(a5)
 96e:	02061593          	slli	a1,a2,0x20
 972:	01c5d713          	srli	a4,a1,0x1c
 976:	973e                	add	a4,a4,a5
 978:	fae68ae3          	beq	a3,a4,92c <free+0x22>
    p->s.ptr = bp->s.ptr;
 97c:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 97e:	00000717          	auipc	a4,0x0
 982:	68f73123          	sd	a5,1666(a4) # 1000 <freep>
}
 986:	6422                	ld	s0,8(sp)
 988:	0141                	addi	sp,sp,16
 98a:	8082                	ret

000000000000098c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 98c:	7139                	addi	sp,sp,-64
 98e:	fc06                	sd	ra,56(sp)
 990:	f822                	sd	s0,48(sp)
 992:	f426                	sd	s1,40(sp)
 994:	f04a                	sd	s2,32(sp)
 996:	ec4e                	sd	s3,24(sp)
 998:	e852                	sd	s4,16(sp)
 99a:	e456                	sd	s5,8(sp)
 99c:	e05a                	sd	s6,0(sp)
 99e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9a0:	02051493          	slli	s1,a0,0x20
 9a4:	9081                	srli	s1,s1,0x20
 9a6:	04bd                	addi	s1,s1,15
 9a8:	8091                	srli	s1,s1,0x4
 9aa:	0014899b          	addiw	s3,s1,1
 9ae:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 9b0:	00000517          	auipc	a0,0x0
 9b4:	65053503          	ld	a0,1616(a0) # 1000 <freep>
 9b8:	c515                	beqz	a0,9e4 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9ba:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9bc:	4798                	lw	a4,8(a5)
 9be:	02977f63          	bgeu	a4,s1,9fc <malloc+0x70>
 9c2:	8a4e                	mv	s4,s3
 9c4:	0009871b          	sext.w	a4,s3
 9c8:	6685                	lui	a3,0x1
 9ca:	00d77363          	bgeu	a4,a3,9d0 <malloc+0x44>
 9ce:	6a05                	lui	s4,0x1
 9d0:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 9d4:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 9d8:	00000917          	auipc	s2,0x0
 9dc:	62890913          	addi	s2,s2,1576 # 1000 <freep>
  if(p == (char*)-1)
 9e0:	5afd                	li	s5,-1
 9e2:	a885                	j	a52 <malloc+0xc6>
    base.s.ptr = freep = prevp = &base;
 9e4:	00000797          	auipc	a5,0x0
 9e8:	63c78793          	addi	a5,a5,1596 # 1020 <base>
 9ec:	00000717          	auipc	a4,0x0
 9f0:	60f73a23          	sd	a5,1556(a4) # 1000 <freep>
 9f4:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 9f6:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 9fa:	b7e1                	j	9c2 <malloc+0x36>
      if(p->s.size == nunits)
 9fc:	02e48c63          	beq	s1,a4,a34 <malloc+0xa8>
        p->s.size -= nunits;
 a00:	4137073b          	subw	a4,a4,s3
 a04:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a06:	02071693          	slli	a3,a4,0x20
 a0a:	01c6d713          	srli	a4,a3,0x1c
 a0e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a10:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a14:	00000717          	auipc	a4,0x0
 a18:	5ea73623          	sd	a0,1516(a4) # 1000 <freep>
      return (void*)(p + 1);
 a1c:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 a20:	70e2                	ld	ra,56(sp)
 a22:	7442                	ld	s0,48(sp)
 a24:	74a2                	ld	s1,40(sp)
 a26:	7902                	ld	s2,32(sp)
 a28:	69e2                	ld	s3,24(sp)
 a2a:	6a42                	ld	s4,16(sp)
 a2c:	6aa2                	ld	s5,8(sp)
 a2e:	6b02                	ld	s6,0(sp)
 a30:	6121                	addi	sp,sp,64
 a32:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 a34:	6398                	ld	a4,0(a5)
 a36:	e118                	sd	a4,0(a0)
 a38:	bff1                	j	a14 <malloc+0x88>
  hp->s.size = nu;
 a3a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a3e:	0541                	addi	a0,a0,16
 a40:	ecbff0ef          	jal	ra,90a <free>
  return freep;
 a44:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 a48:	dd61                	beqz	a0,a20 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a4a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a4c:	4798                	lw	a4,8(a5)
 a4e:	fa9777e3          	bgeu	a4,s1,9fc <malloc+0x70>
    if(p == freep)
 a52:	00093703          	ld	a4,0(s2)
 a56:	853e                	mv	a0,a5
 a58:	fef719e3          	bne	a4,a5,a4a <malloc+0xbe>
  p = sbrk(nu * sizeof(Header));
 a5c:	8552                	mv	a0,s4
 a5e:	af7ff0ef          	jal	ra,554 <sbrk>
  if(p == (char*)-1)
 a62:	fd551ce3          	bne	a0,s5,a3a <malloc+0xae>
        return 0;
 a66:	4501                	li	a0,0
 a68:	bf65                	j	a20 <malloc+0x94>
