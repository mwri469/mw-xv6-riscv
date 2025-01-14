
user/_find:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <fmtname>:
	exit(0);
}

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
  10:	288000ef          	jal	ra,298 <strlen>
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
  38:	260000ef          	jal	ra,298 <strlen>
  3c:	2501                	sext.w	a0,a0
  3e:	47b5                	li	a5,13
  40:	00a7fa63          	bgeu	a5,a0,54 <fmtname+0x54>
    return p;
  memmove(buf, p, strlen(p));
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  return buf;
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
  56:	242000ef          	jal	ra,298 <strlen>
  5a:	00001997          	auipc	s3,0x1
  5e:	fb698993          	addi	s3,s3,-74 # 1010 <buf.0>
  62:	0005061b          	sext.w	a2,a0
  66:	85a6                	mv	a1,s1
  68:	854e                	mv	a0,s3
  6a:	390000ef          	jal	ra,3fa <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  6e:	8526                	mv	a0,s1
  70:	228000ef          	jal	ra,298 <strlen>
  74:	0005091b          	sext.w	s2,a0
  78:	8526                	mv	a0,s1
  7a:	21e000ef          	jal	ra,298 <strlen>
  7e:	1902                	slli	s2,s2,0x20
  80:	02095913          	srli	s2,s2,0x20
  84:	4639                	li	a2,14
  86:	9e09                	subw	a2,a2,a0
  88:	02000593          	li	a1,32
  8c:	01298533          	add	a0,s3,s2
  90:	232000ef          	jal	ra,2c2 <memset>
  return buf;
  94:	84ce                	mv	s1,s3
  96:	b77d                	j	44 <fmtname+0x44>

0000000000000098 <find>:
find(char* dir, char* fname) {
  98:	d7010113          	addi	sp,sp,-656
  9c:	28113423          	sd	ra,648(sp)
  a0:	28813023          	sd	s0,640(sp)
  a4:	26913c23          	sd	s1,632(sp)
  a8:	27213823          	sd	s2,624(sp)
  ac:	27313423          	sd	s3,616(sp)
  b0:	27413023          	sd	s4,608(sp)
  b4:	25513c23          	sd	s5,600(sp)
  b8:	25613823          	sd	s6,592(sp)
  bc:	0d00                	addi	s0,sp,656
  be:	892a                	mv	s2,a0
  c0:	89ae                	mv	s3,a1
	fd = open(dir, O_RDONLY);
  c2:	4581                	li	a1,0
  c4:	424000ef          	jal	ra,4e8 <open>
	if (fd < 0) {
  c8:	08054263          	bltz	a0,14c <find+0xb4>
  cc:	84aa                	mv	s1,a0
	if (fstat(fd, &st) < 0) {
  ce:	d8840593          	addi	a1,s0,-632
  d2:	42e000ef          	jal	ra,500 <fstat>
  d6:	08054463          	bltz	a0,15e <find+0xc6>
	switch(st.type) {
  da:	d9041783          	lh	a5,-624(s0)
  de:	0007869b          	sext.w	a3,a5
  e2:	4705                	li	a4,1
  e4:	0ae68163          	beq	a3,a4,186 <find+0xee>
  e8:	37f9                	addiw	a5,a5,-2
  ea:	17c2                	slli	a5,a5,0x30
  ec:	93c1                	srli	a5,a5,0x30
  ee:	02f76963          	bltu	a4,a5,120 <find+0x88>
			strcpy(buf1, fmtname(dir));
  f2:	854a                	mv	a0,s2
  f4:	f0dff0ef          	jal	ra,0 <fmtname>
  f8:	85aa                	mv	a1,a0
  fa:	db040513          	addi	a0,s0,-592
  fe:	152000ef          	jal	ra,250 <strcpy>
			strcpy(buf2, fmtname(fname));
 102:	854e                	mv	a0,s3
 104:	efdff0ef          	jal	ra,0 <fmtname>
 108:	85aa                	mv	a1,a0
 10a:	da040513          	addi	a0,s0,-608
 10e:	142000ef          	jal	ra,250 <strcpy>
			if (strcmp(buf1, buf2) == 0) {
 112:	da040593          	addi	a1,s0,-608
 116:	db040513          	addi	a0,s0,-592
 11a:	152000ef          	jal	ra,26c <strcmp>
 11e:	cd21                	beqz	a0,176 <find+0xde>
	close(fd);
 120:	8526                	mv	a0,s1
 122:	3ae000ef          	jal	ra,4d0 <close>
}
 126:	28813083          	ld	ra,648(sp)
 12a:	28013403          	ld	s0,640(sp)
 12e:	27813483          	ld	s1,632(sp)
 132:	27013903          	ld	s2,624(sp)
 136:	26813983          	ld	s3,616(sp)
 13a:	26013a03          	ld	s4,608(sp)
 13e:	25813a83          	ld	s5,600(sp)
 142:	25013b03          	ld	s6,592(sp)
 146:	29010113          	addi	sp,sp,656
 14a:	8082                	ret
		fprintf(2, "find: err cannot open %s\n", dir);
 14c:	864a                	mv	a2,s2
 14e:	00001597          	auipc	a1,0x1
 152:	90258593          	addi	a1,a1,-1790 # a50 <malloc+0xe8>
 156:	4509                	li	a0,2
 158:	732000ef          	jal	ra,88a <fprintf>
		return;
 15c:	b7e9                	j	126 <find+0x8e>
		fprintf(2, "find: err getting dir %s stat\n", dir);
 15e:	864a                	mv	a2,s2
 160:	00001597          	auipc	a1,0x1
 164:	91058593          	addi	a1,a1,-1776 # a70 <malloc+0x108>
 168:	4509                	li	a0,2
 16a:	720000ef          	jal	ra,88a <fprintf>
		close(fd);
 16e:	8526                	mv	a0,s1
 170:	360000ef          	jal	ra,4d0 <close>
		return;
 174:	bf4d                	j	126 <find+0x8e>
				printf("%s\n", dir);
 176:	85ca                	mv	a1,s2
 178:	00001517          	auipc	a0,0x1
 17c:	91850513          	addi	a0,a0,-1768 # a90 <malloc+0x128>
 180:	734000ef          	jal	ra,8b4 <printf>
 184:	bf71                	j	120 <find+0x88>
			strcpy(buff, dir);
 186:	85ca                	mv	a1,s2
 188:	dc040513          	addi	a0,s0,-576
 18c:	0c4000ef          	jal	ra,250 <strcpy>
			p = buff + strlen(buff);
 190:	dc040513          	addi	a0,s0,-576
 194:	104000ef          	jal	ra,298 <strlen>
 198:	1502                	slli	a0,a0,0x20
 19a:	9101                	srli	a0,a0,0x20
 19c:	dc040793          	addi	a5,s0,-576
 1a0:	00a78933          	add	s2,a5,a0
			*p++ = '/';
 1a4:	00190a93          	addi	s5,s2,1
 1a8:	02f00793          	li	a5,47
 1ac:	00f90023          	sb	a5,0(s2)
				if (strcmp(de.name, ".") != 0
 1b0:	00001a17          	auipc	s4,0x1
 1b4:	8e8a0a13          	addi	s4,s4,-1816 # a98 <malloc+0x130>
					&& strcmp(de.name, "..") != 0) {
 1b8:	00001b17          	auipc	s6,0x1
 1bc:	8e8b0b13          	addi	s6,s6,-1816 # aa0 <malloc+0x138>
			while (read(fd, &de, sizeof(de)) == sizeof(de)) {
 1c0:	4641                	li	a2,16
 1c2:	d7840593          	addi	a1,s0,-648
 1c6:	8526                	mv	a0,s1
 1c8:	2f8000ef          	jal	ra,4c0 <read>
 1cc:	47c1                	li	a5,16
 1ce:	f4f519e3          	bne	a0,a5,120 <find+0x88>
				if (de.inum == 0)
 1d2:	d7845783          	lhu	a5,-648(s0)
 1d6:	d7ed                	beqz	a5,1c0 <find+0x128>
				memmove(p, de.name, DIRSIZ);
 1d8:	4639                	li	a2,14
 1da:	d7a40593          	addi	a1,s0,-646
 1de:	8556                	mv	a0,s5
 1e0:	21a000ef          	jal	ra,3fa <memmove>
      			p[DIRSIZ] = 0;
 1e4:	000907a3          	sb	zero,15(s2)
				if (strcmp(de.name, ".") != 0
 1e8:	85d2                	mv	a1,s4
 1ea:	d7a40513          	addi	a0,s0,-646
 1ee:	07e000ef          	jal	ra,26c <strcmp>
 1f2:	d579                	beqz	a0,1c0 <find+0x128>
					&& strcmp(de.name, "..") != 0) {
 1f4:	85da                	mv	a1,s6
 1f6:	d7a40513          	addi	a0,s0,-646
 1fa:	072000ef          	jal	ra,26c <strcmp>
 1fe:	d169                	beqz	a0,1c0 <find+0x128>
						find(buff, fname);
 200:	85ce                	mv	a1,s3
 202:	dc040513          	addi	a0,s0,-576
 206:	e93ff0ef          	jal	ra,98 <find>
 20a:	bf5d                	j	1c0 <find+0x128>

000000000000020c <main>:
main(int argc, char* argv[]) {
 20c:	1141                	addi	sp,sp,-16
 20e:	e406                	sd	ra,8(sp)
 210:	e022                	sd	s0,0(sp)
 212:	0800                	addi	s0,sp,16
	if (argc < 2) {
 214:	4705                	li	a4,1
 216:	00a75a63          	bge	a4,a0,22a <main+0x1e>
 21a:	87ae                	mv	a5,a1
		find(argv[1], argv[2]);
 21c:	698c                	ld	a1,16(a1)
 21e:	6788                	ld	a0,8(a5)
 220:	e79ff0ef          	jal	ra,98 <find>
	exit(0);
 224:	4501                	li	a0,0
 226:	282000ef          	jal	ra,4a8 <exit>
		fprintf(2, "Usage: find <source_dir> <filename>");
 22a:	00001597          	auipc	a1,0x1
 22e:	87e58593          	addi	a1,a1,-1922 # aa8 <malloc+0x140>
 232:	4509                	li	a0,2
 234:	656000ef          	jal	ra,88a <fprintf>
		exit(1);
 238:	4505                	li	a0,1
 23a:	26e000ef          	jal	ra,4a8 <exit>

000000000000023e <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 23e:	1141                	addi	sp,sp,-16
 240:	e406                	sd	ra,8(sp)
 242:	e022                	sd	s0,0(sp)
 244:	0800                	addi	s0,sp,16
  extern int main();
  main();
 246:	fc7ff0ef          	jal	ra,20c <main>
  exit(0);
 24a:	4501                	li	a0,0
 24c:	25c000ef          	jal	ra,4a8 <exit>

0000000000000250 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 250:	1141                	addi	sp,sp,-16
 252:	e422                	sd	s0,8(sp)
 254:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 256:	87aa                	mv	a5,a0
 258:	0585                	addi	a1,a1,1
 25a:	0785                	addi	a5,a5,1
 25c:	fff5c703          	lbu	a4,-1(a1)
 260:	fee78fa3          	sb	a4,-1(a5)
 264:	fb75                	bnez	a4,258 <strcpy+0x8>
    ;
  return os;
}
 266:	6422                	ld	s0,8(sp)
 268:	0141                	addi	sp,sp,16
 26a:	8082                	ret

000000000000026c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 26c:	1141                	addi	sp,sp,-16
 26e:	e422                	sd	s0,8(sp)
 270:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 272:	00054783          	lbu	a5,0(a0)
 276:	cb91                	beqz	a5,28a <strcmp+0x1e>
 278:	0005c703          	lbu	a4,0(a1)
 27c:	00f71763          	bne	a4,a5,28a <strcmp+0x1e>
    p++, q++;
 280:	0505                	addi	a0,a0,1
 282:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 284:	00054783          	lbu	a5,0(a0)
 288:	fbe5                	bnez	a5,278 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 28a:	0005c503          	lbu	a0,0(a1)
}
 28e:	40a7853b          	subw	a0,a5,a0
 292:	6422                	ld	s0,8(sp)
 294:	0141                	addi	sp,sp,16
 296:	8082                	ret

0000000000000298 <strlen>:

uint
strlen(const char *s)
{
 298:	1141                	addi	sp,sp,-16
 29a:	e422                	sd	s0,8(sp)
 29c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 29e:	00054783          	lbu	a5,0(a0)
 2a2:	cf91                	beqz	a5,2be <strlen+0x26>
 2a4:	0505                	addi	a0,a0,1
 2a6:	87aa                	mv	a5,a0
 2a8:	4685                	li	a3,1
 2aa:	9e89                	subw	a3,a3,a0
 2ac:	00f6853b          	addw	a0,a3,a5
 2b0:	0785                	addi	a5,a5,1
 2b2:	fff7c703          	lbu	a4,-1(a5)
 2b6:	fb7d                	bnez	a4,2ac <strlen+0x14>
    ;
  return n;
}
 2b8:	6422                	ld	s0,8(sp)
 2ba:	0141                	addi	sp,sp,16
 2bc:	8082                	ret
  for(n = 0; s[n]; n++)
 2be:	4501                	li	a0,0
 2c0:	bfe5                	j	2b8 <strlen+0x20>

00000000000002c2 <memset>:

void*
memset(void *dst, int c, uint n)
{
 2c2:	1141                	addi	sp,sp,-16
 2c4:	e422                	sd	s0,8(sp)
 2c6:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 2c8:	ca19                	beqz	a2,2de <memset+0x1c>
 2ca:	87aa                	mv	a5,a0
 2cc:	1602                	slli	a2,a2,0x20
 2ce:	9201                	srli	a2,a2,0x20
 2d0:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 2d4:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 2d8:	0785                	addi	a5,a5,1
 2da:	fee79de3          	bne	a5,a4,2d4 <memset+0x12>
  }
  return dst;
}
 2de:	6422                	ld	s0,8(sp)
 2e0:	0141                	addi	sp,sp,16
 2e2:	8082                	ret

00000000000002e4 <strchr>:

char*
strchr(const char *s, char c)
{
 2e4:	1141                	addi	sp,sp,-16
 2e6:	e422                	sd	s0,8(sp)
 2e8:	0800                	addi	s0,sp,16
  for(; *s; s++)
 2ea:	00054783          	lbu	a5,0(a0)
 2ee:	cb99                	beqz	a5,304 <strchr+0x20>
    if(*s == c)
 2f0:	00f58763          	beq	a1,a5,2fe <strchr+0x1a>
  for(; *s; s++)
 2f4:	0505                	addi	a0,a0,1
 2f6:	00054783          	lbu	a5,0(a0)
 2fa:	fbfd                	bnez	a5,2f0 <strchr+0xc>
      return (char*)s;
  return 0;
 2fc:	4501                	li	a0,0
}
 2fe:	6422                	ld	s0,8(sp)
 300:	0141                	addi	sp,sp,16
 302:	8082                	ret
  return 0;
 304:	4501                	li	a0,0
 306:	bfe5                	j	2fe <strchr+0x1a>

0000000000000308 <gets>:

char*
gets(char *buf, int max)
{
 308:	711d                	addi	sp,sp,-96
 30a:	ec86                	sd	ra,88(sp)
 30c:	e8a2                	sd	s0,80(sp)
 30e:	e4a6                	sd	s1,72(sp)
 310:	e0ca                	sd	s2,64(sp)
 312:	fc4e                	sd	s3,56(sp)
 314:	f852                	sd	s4,48(sp)
 316:	f456                	sd	s5,40(sp)
 318:	f05a                	sd	s6,32(sp)
 31a:	ec5e                	sd	s7,24(sp)
 31c:	1080                	addi	s0,sp,96
 31e:	8baa                	mv	s7,a0
 320:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 322:	892a                	mv	s2,a0
 324:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 326:	4aa9                	li	s5,10
 328:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 32a:	89a6                	mv	s3,s1
 32c:	2485                	addiw	s1,s1,1
 32e:	0344d663          	bge	s1,s4,35a <gets+0x52>
    cc = read(0, &c, 1);
 332:	4605                	li	a2,1
 334:	faf40593          	addi	a1,s0,-81
 338:	4501                	li	a0,0
 33a:	186000ef          	jal	ra,4c0 <read>
    if(cc < 1)
 33e:	00a05e63          	blez	a0,35a <gets+0x52>
    buf[i++] = c;
 342:	faf44783          	lbu	a5,-81(s0)
 346:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 34a:	01578763          	beq	a5,s5,358 <gets+0x50>
 34e:	0905                	addi	s2,s2,1
 350:	fd679de3          	bne	a5,s6,32a <gets+0x22>
  for(i=0; i+1 < max; ){
 354:	89a6                	mv	s3,s1
 356:	a011                	j	35a <gets+0x52>
 358:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 35a:	99de                	add	s3,s3,s7
 35c:	00098023          	sb	zero,0(s3)
  return buf;
}
 360:	855e                	mv	a0,s7
 362:	60e6                	ld	ra,88(sp)
 364:	6446                	ld	s0,80(sp)
 366:	64a6                	ld	s1,72(sp)
 368:	6906                	ld	s2,64(sp)
 36a:	79e2                	ld	s3,56(sp)
 36c:	7a42                	ld	s4,48(sp)
 36e:	7aa2                	ld	s5,40(sp)
 370:	7b02                	ld	s6,32(sp)
 372:	6be2                	ld	s7,24(sp)
 374:	6125                	addi	sp,sp,96
 376:	8082                	ret

0000000000000378 <stat>:

int
stat(const char *n, struct stat *st)
{
 378:	1101                	addi	sp,sp,-32
 37a:	ec06                	sd	ra,24(sp)
 37c:	e822                	sd	s0,16(sp)
 37e:	e426                	sd	s1,8(sp)
 380:	e04a                	sd	s2,0(sp)
 382:	1000                	addi	s0,sp,32
 384:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 386:	4581                	li	a1,0
 388:	160000ef          	jal	ra,4e8 <open>
  if(fd < 0)
 38c:	02054163          	bltz	a0,3ae <stat+0x36>
 390:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 392:	85ca                	mv	a1,s2
 394:	16c000ef          	jal	ra,500 <fstat>
 398:	892a                	mv	s2,a0
  close(fd);
 39a:	8526                	mv	a0,s1
 39c:	134000ef          	jal	ra,4d0 <close>
  return r;
}
 3a0:	854a                	mv	a0,s2
 3a2:	60e2                	ld	ra,24(sp)
 3a4:	6442                	ld	s0,16(sp)
 3a6:	64a2                	ld	s1,8(sp)
 3a8:	6902                	ld	s2,0(sp)
 3aa:	6105                	addi	sp,sp,32
 3ac:	8082                	ret
    return -1;
 3ae:	597d                	li	s2,-1
 3b0:	bfc5                	j	3a0 <stat+0x28>

00000000000003b2 <atoi>:

int
atoi(const char *s)
{
 3b2:	1141                	addi	sp,sp,-16
 3b4:	e422                	sd	s0,8(sp)
 3b6:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3b8:	00054683          	lbu	a3,0(a0)
 3bc:	fd06879b          	addiw	a5,a3,-48
 3c0:	0ff7f793          	zext.b	a5,a5
 3c4:	4625                	li	a2,9
 3c6:	02f66863          	bltu	a2,a5,3f6 <atoi+0x44>
 3ca:	872a                	mv	a4,a0
  n = 0;
 3cc:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 3ce:	0705                	addi	a4,a4,1
 3d0:	0025179b          	slliw	a5,a0,0x2
 3d4:	9fa9                	addw	a5,a5,a0
 3d6:	0017979b          	slliw	a5,a5,0x1
 3da:	9fb5                	addw	a5,a5,a3
 3dc:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 3e0:	00074683          	lbu	a3,0(a4)
 3e4:	fd06879b          	addiw	a5,a3,-48
 3e8:	0ff7f793          	zext.b	a5,a5
 3ec:	fef671e3          	bgeu	a2,a5,3ce <atoi+0x1c>
  return n;
}
 3f0:	6422                	ld	s0,8(sp)
 3f2:	0141                	addi	sp,sp,16
 3f4:	8082                	ret
  n = 0;
 3f6:	4501                	li	a0,0
 3f8:	bfe5                	j	3f0 <atoi+0x3e>

00000000000003fa <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3fa:	1141                	addi	sp,sp,-16
 3fc:	e422                	sd	s0,8(sp)
 3fe:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 400:	02b57463          	bgeu	a0,a1,428 <memmove+0x2e>
    while(n-- > 0)
 404:	00c05f63          	blez	a2,422 <memmove+0x28>
 408:	1602                	slli	a2,a2,0x20
 40a:	9201                	srli	a2,a2,0x20
 40c:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 410:	872a                	mv	a4,a0
      *dst++ = *src++;
 412:	0585                	addi	a1,a1,1
 414:	0705                	addi	a4,a4,1
 416:	fff5c683          	lbu	a3,-1(a1)
 41a:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 41e:	fee79ae3          	bne	a5,a4,412 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 422:	6422                	ld	s0,8(sp)
 424:	0141                	addi	sp,sp,16
 426:	8082                	ret
    dst += n;
 428:	00c50733          	add	a4,a0,a2
    src += n;
 42c:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 42e:	fec05ae3          	blez	a2,422 <memmove+0x28>
 432:	fff6079b          	addiw	a5,a2,-1
 436:	1782                	slli	a5,a5,0x20
 438:	9381                	srli	a5,a5,0x20
 43a:	fff7c793          	not	a5,a5
 43e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 440:	15fd                	addi	a1,a1,-1
 442:	177d                	addi	a4,a4,-1
 444:	0005c683          	lbu	a3,0(a1)
 448:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 44c:	fee79ae3          	bne	a5,a4,440 <memmove+0x46>
 450:	bfc9                	j	422 <memmove+0x28>

0000000000000452 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 452:	1141                	addi	sp,sp,-16
 454:	e422                	sd	s0,8(sp)
 456:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 458:	ca05                	beqz	a2,488 <memcmp+0x36>
 45a:	fff6069b          	addiw	a3,a2,-1
 45e:	1682                	slli	a3,a3,0x20
 460:	9281                	srli	a3,a3,0x20
 462:	0685                	addi	a3,a3,1
 464:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 466:	00054783          	lbu	a5,0(a0)
 46a:	0005c703          	lbu	a4,0(a1)
 46e:	00e79863          	bne	a5,a4,47e <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 472:	0505                	addi	a0,a0,1
    p2++;
 474:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 476:	fed518e3          	bne	a0,a3,466 <memcmp+0x14>
  }
  return 0;
 47a:	4501                	li	a0,0
 47c:	a019                	j	482 <memcmp+0x30>
      return *p1 - *p2;
 47e:	40e7853b          	subw	a0,a5,a4
}
 482:	6422                	ld	s0,8(sp)
 484:	0141                	addi	sp,sp,16
 486:	8082                	ret
  return 0;
 488:	4501                	li	a0,0
 48a:	bfe5                	j	482 <memcmp+0x30>

000000000000048c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 48c:	1141                	addi	sp,sp,-16
 48e:	e406                	sd	ra,8(sp)
 490:	e022                	sd	s0,0(sp)
 492:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 494:	f67ff0ef          	jal	ra,3fa <memmove>
}
 498:	60a2                	ld	ra,8(sp)
 49a:	6402                	ld	s0,0(sp)
 49c:	0141                	addi	sp,sp,16
 49e:	8082                	ret

00000000000004a0 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 4a0:	4885                	li	a7,1
 ecall
 4a2:	00000073          	ecall
 ret
 4a6:	8082                	ret

00000000000004a8 <exit>:
.global exit
exit:
 li a7, SYS_exit
 4a8:	4889                	li	a7,2
 ecall
 4aa:	00000073          	ecall
 ret
 4ae:	8082                	ret

00000000000004b0 <wait>:
.global wait
wait:
 li a7, SYS_wait
 4b0:	488d                	li	a7,3
 ecall
 4b2:	00000073          	ecall
 ret
 4b6:	8082                	ret

00000000000004b8 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 4b8:	4891                	li	a7,4
 ecall
 4ba:	00000073          	ecall
 ret
 4be:	8082                	ret

00000000000004c0 <read>:
.global read
read:
 li a7, SYS_read
 4c0:	4895                	li	a7,5
 ecall
 4c2:	00000073          	ecall
 ret
 4c6:	8082                	ret

00000000000004c8 <write>:
.global write
write:
 li a7, SYS_write
 4c8:	48c1                	li	a7,16
 ecall
 4ca:	00000073          	ecall
 ret
 4ce:	8082                	ret

00000000000004d0 <close>:
.global close
close:
 li a7, SYS_close
 4d0:	48d5                	li	a7,21
 ecall
 4d2:	00000073          	ecall
 ret
 4d6:	8082                	ret

00000000000004d8 <kill>:
.global kill
kill:
 li a7, SYS_kill
 4d8:	4899                	li	a7,6
 ecall
 4da:	00000073          	ecall
 ret
 4de:	8082                	ret

00000000000004e0 <exec>:
.global exec
exec:
 li a7, SYS_exec
 4e0:	489d                	li	a7,7
 ecall
 4e2:	00000073          	ecall
 ret
 4e6:	8082                	ret

00000000000004e8 <open>:
.global open
open:
 li a7, SYS_open
 4e8:	48bd                	li	a7,15
 ecall
 4ea:	00000073          	ecall
 ret
 4ee:	8082                	ret

00000000000004f0 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 4f0:	48c5                	li	a7,17
 ecall
 4f2:	00000073          	ecall
 ret
 4f6:	8082                	ret

00000000000004f8 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 4f8:	48c9                	li	a7,18
 ecall
 4fa:	00000073          	ecall
 ret
 4fe:	8082                	ret

0000000000000500 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 500:	48a1                	li	a7,8
 ecall
 502:	00000073          	ecall
 ret
 506:	8082                	ret

0000000000000508 <link>:
.global link
link:
 li a7, SYS_link
 508:	48cd                	li	a7,19
 ecall
 50a:	00000073          	ecall
 ret
 50e:	8082                	ret

0000000000000510 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 510:	48d1                	li	a7,20
 ecall
 512:	00000073          	ecall
 ret
 516:	8082                	ret

0000000000000518 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 518:	48a5                	li	a7,9
 ecall
 51a:	00000073          	ecall
 ret
 51e:	8082                	ret

0000000000000520 <dup>:
.global dup
dup:
 li a7, SYS_dup
 520:	48a9                	li	a7,10
 ecall
 522:	00000073          	ecall
 ret
 526:	8082                	ret

0000000000000528 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 528:	48ad                	li	a7,11
 ecall
 52a:	00000073          	ecall
 ret
 52e:	8082                	ret

0000000000000530 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 530:	48b1                	li	a7,12
 ecall
 532:	00000073          	ecall
 ret
 536:	8082                	ret

0000000000000538 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 538:	48b5                	li	a7,13
 ecall
 53a:	00000073          	ecall
 ret
 53e:	8082                	ret

0000000000000540 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 540:	48b9                	li	a7,14
 ecall
 542:	00000073          	ecall
 ret
 546:	8082                	ret

0000000000000548 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 548:	1101                	addi	sp,sp,-32
 54a:	ec06                	sd	ra,24(sp)
 54c:	e822                	sd	s0,16(sp)
 54e:	1000                	addi	s0,sp,32
 550:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 554:	4605                	li	a2,1
 556:	fef40593          	addi	a1,s0,-17
 55a:	f6fff0ef          	jal	ra,4c8 <write>
}
 55e:	60e2                	ld	ra,24(sp)
 560:	6442                	ld	s0,16(sp)
 562:	6105                	addi	sp,sp,32
 564:	8082                	ret

0000000000000566 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 566:	7139                	addi	sp,sp,-64
 568:	fc06                	sd	ra,56(sp)
 56a:	f822                	sd	s0,48(sp)
 56c:	f426                	sd	s1,40(sp)
 56e:	f04a                	sd	s2,32(sp)
 570:	ec4e                	sd	s3,24(sp)
 572:	0080                	addi	s0,sp,64
 574:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 576:	c299                	beqz	a3,57c <printint+0x16>
 578:	0805c763          	bltz	a1,606 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 57c:	2581                	sext.w	a1,a1
  neg = 0;
 57e:	4881                	li	a7,0
 580:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 584:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 586:	2601                	sext.w	a2,a2
 588:	00000517          	auipc	a0,0x0
 58c:	55050513          	addi	a0,a0,1360 # ad8 <digits>
 590:	883a                	mv	a6,a4
 592:	2705                	addiw	a4,a4,1
 594:	02c5f7bb          	remuw	a5,a1,a2
 598:	1782                	slli	a5,a5,0x20
 59a:	9381                	srli	a5,a5,0x20
 59c:	97aa                	add	a5,a5,a0
 59e:	0007c783          	lbu	a5,0(a5)
 5a2:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 5a6:	0005879b          	sext.w	a5,a1
 5aa:	02c5d5bb          	divuw	a1,a1,a2
 5ae:	0685                	addi	a3,a3,1
 5b0:	fec7f0e3          	bgeu	a5,a2,590 <printint+0x2a>
  if(neg)
 5b4:	00088c63          	beqz	a7,5cc <printint+0x66>
    buf[i++] = '-';
 5b8:	fd070793          	addi	a5,a4,-48
 5bc:	00878733          	add	a4,a5,s0
 5c0:	02d00793          	li	a5,45
 5c4:	fef70823          	sb	a5,-16(a4)
 5c8:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 5cc:	02e05663          	blez	a4,5f8 <printint+0x92>
 5d0:	fc040793          	addi	a5,s0,-64
 5d4:	00e78933          	add	s2,a5,a4
 5d8:	fff78993          	addi	s3,a5,-1
 5dc:	99ba                	add	s3,s3,a4
 5de:	377d                	addiw	a4,a4,-1
 5e0:	1702                	slli	a4,a4,0x20
 5e2:	9301                	srli	a4,a4,0x20
 5e4:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 5e8:	fff94583          	lbu	a1,-1(s2)
 5ec:	8526                	mv	a0,s1
 5ee:	f5bff0ef          	jal	ra,548 <putc>
  while(--i >= 0)
 5f2:	197d                	addi	s2,s2,-1
 5f4:	ff391ae3          	bne	s2,s3,5e8 <printint+0x82>
}
 5f8:	70e2                	ld	ra,56(sp)
 5fa:	7442                	ld	s0,48(sp)
 5fc:	74a2                	ld	s1,40(sp)
 5fe:	7902                	ld	s2,32(sp)
 600:	69e2                	ld	s3,24(sp)
 602:	6121                	addi	sp,sp,64
 604:	8082                	ret
    x = -xx;
 606:	40b005bb          	negw	a1,a1
    neg = 1;
 60a:	4885                	li	a7,1
    x = -xx;
 60c:	bf95                	j	580 <printint+0x1a>

000000000000060e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 60e:	7119                	addi	sp,sp,-128
 610:	fc86                	sd	ra,120(sp)
 612:	f8a2                	sd	s0,112(sp)
 614:	f4a6                	sd	s1,104(sp)
 616:	f0ca                	sd	s2,96(sp)
 618:	ecce                	sd	s3,88(sp)
 61a:	e8d2                	sd	s4,80(sp)
 61c:	e4d6                	sd	s5,72(sp)
 61e:	e0da                	sd	s6,64(sp)
 620:	fc5e                	sd	s7,56(sp)
 622:	f862                	sd	s8,48(sp)
 624:	f466                	sd	s9,40(sp)
 626:	f06a                	sd	s10,32(sp)
 628:	ec6e                	sd	s11,24(sp)
 62a:	0100                	addi	s0,sp,128
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 62c:	0005c903          	lbu	s2,0(a1)
 630:	22090e63          	beqz	s2,86c <vprintf+0x25e>
 634:	8b2a                	mv	s6,a0
 636:	8a2e                	mv	s4,a1
 638:	8bb2                	mv	s7,a2
  state = 0;
 63a:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 63c:	4481                	li	s1,0
 63e:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 640:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 644:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 648:	06c00d13          	li	s10,108
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 64c:	07500d93          	li	s11,117
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 650:	00000c97          	auipc	s9,0x0
 654:	488c8c93          	addi	s9,s9,1160 # ad8 <digits>
 658:	a005                	j	678 <vprintf+0x6a>
        putc(fd, c0);
 65a:	85ca                	mv	a1,s2
 65c:	855a                	mv	a0,s6
 65e:	eebff0ef          	jal	ra,548 <putc>
 662:	a019                	j	668 <vprintf+0x5a>
    } else if(state == '%'){
 664:	03598263          	beq	s3,s5,688 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 668:	2485                	addiw	s1,s1,1
 66a:	8726                	mv	a4,s1
 66c:	009a07b3          	add	a5,s4,s1
 670:	0007c903          	lbu	s2,0(a5)
 674:	1e090c63          	beqz	s2,86c <vprintf+0x25e>
    c0 = fmt[i] & 0xff;
 678:	0009079b          	sext.w	a5,s2
    if(state == 0){
 67c:	fe0994e3          	bnez	s3,664 <vprintf+0x56>
      if(c0 == '%'){
 680:	fd579de3          	bne	a5,s5,65a <vprintf+0x4c>
        state = '%';
 684:	89be                	mv	s3,a5
 686:	b7cd                	j	668 <vprintf+0x5a>
      if(c0) c1 = fmt[i+1] & 0xff;
 688:	cfa5                	beqz	a5,700 <vprintf+0xf2>
 68a:	00ea06b3          	add	a3,s4,a4
 68e:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 692:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 694:	c681                	beqz	a3,69c <vprintf+0x8e>
 696:	9752                	add	a4,a4,s4
 698:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 69c:	03878a63          	beq	a5,s8,6d0 <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 6a0:	05a78463          	beq	a5,s10,6e8 <vprintf+0xda>
      } else if(c0 == 'u'){
 6a4:	0db78763          	beq	a5,s11,772 <vprintf+0x164>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 6a8:	07800713          	li	a4,120
 6ac:	10e78963          	beq	a5,a4,7be <vprintf+0x1b0>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 6b0:	07000713          	li	a4,112
 6b4:	12e78e63          	beq	a5,a4,7f0 <vprintf+0x1e2>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 6b8:	07300713          	li	a4,115
 6bc:	16e78b63          	beq	a5,a4,832 <vprintf+0x224>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 6c0:	05579063          	bne	a5,s5,700 <vprintf+0xf2>
        putc(fd, '%');
 6c4:	85d6                	mv	a1,s5
 6c6:	855a                	mv	a0,s6
 6c8:	e81ff0ef          	jal	ra,548 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 6cc:	4981                	li	s3,0
 6ce:	bf69                	j	668 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 1);
 6d0:	008b8913          	addi	s2,s7,8
 6d4:	4685                	li	a3,1
 6d6:	4629                	li	a2,10
 6d8:	000ba583          	lw	a1,0(s7)
 6dc:	855a                	mv	a0,s6
 6de:	e89ff0ef          	jal	ra,566 <printint>
 6e2:	8bca                	mv	s7,s2
      state = 0;
 6e4:	4981                	li	s3,0
 6e6:	b749                	j	668 <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'd'){
 6e8:	03868663          	beq	a3,s8,714 <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6ec:	05a68163          	beq	a3,s10,72e <vprintf+0x120>
      } else if(c0 == 'l' && c1 == 'u'){
 6f0:	09b68d63          	beq	a3,s11,78a <vprintf+0x17c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 6f4:	03a68f63          	beq	a3,s10,732 <vprintf+0x124>
      } else if(c0 == 'l' && c1 == 'x'){
 6f8:	07800793          	li	a5,120
 6fc:	0cf68d63          	beq	a3,a5,7d6 <vprintf+0x1c8>
        putc(fd, '%');
 700:	85d6                	mv	a1,s5
 702:	855a                	mv	a0,s6
 704:	e45ff0ef          	jal	ra,548 <putc>
        putc(fd, c0);
 708:	85ca                	mv	a1,s2
 70a:	855a                	mv	a0,s6
 70c:	e3dff0ef          	jal	ra,548 <putc>
      state = 0;
 710:	4981                	li	s3,0
 712:	bf99                	j	668 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 714:	008b8913          	addi	s2,s7,8
 718:	4685                	li	a3,1
 71a:	4629                	li	a2,10
 71c:	000ba583          	lw	a1,0(s7)
 720:	855a                	mv	a0,s6
 722:	e45ff0ef          	jal	ra,566 <printint>
        i += 1;
 726:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 728:	8bca                	mv	s7,s2
      state = 0;
 72a:	4981                	li	s3,0
        i += 1;
 72c:	bf35                	j	668 <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 72e:	03860563          	beq	a2,s8,758 <vprintf+0x14a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 732:	07b60963          	beq	a2,s11,7a4 <vprintf+0x196>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 736:	07800793          	li	a5,120
 73a:	fcf613e3          	bne	a2,a5,700 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 73e:	008b8913          	addi	s2,s7,8
 742:	4681                	li	a3,0
 744:	4641                	li	a2,16
 746:	000ba583          	lw	a1,0(s7)
 74a:	855a                	mv	a0,s6
 74c:	e1bff0ef          	jal	ra,566 <printint>
        i += 2;
 750:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 752:	8bca                	mv	s7,s2
      state = 0;
 754:	4981                	li	s3,0
        i += 2;
 756:	bf09                	j	668 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 758:	008b8913          	addi	s2,s7,8
 75c:	4685                	li	a3,1
 75e:	4629                	li	a2,10
 760:	000ba583          	lw	a1,0(s7)
 764:	855a                	mv	a0,s6
 766:	e01ff0ef          	jal	ra,566 <printint>
        i += 2;
 76a:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 76c:	8bca                	mv	s7,s2
      state = 0;
 76e:	4981                	li	s3,0
        i += 2;
 770:	bde5                	j	668 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 0);
 772:	008b8913          	addi	s2,s7,8
 776:	4681                	li	a3,0
 778:	4629                	li	a2,10
 77a:	000ba583          	lw	a1,0(s7)
 77e:	855a                	mv	a0,s6
 780:	de7ff0ef          	jal	ra,566 <printint>
 784:	8bca                	mv	s7,s2
      state = 0;
 786:	4981                	li	s3,0
 788:	b5c5                	j	668 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 78a:	008b8913          	addi	s2,s7,8
 78e:	4681                	li	a3,0
 790:	4629                	li	a2,10
 792:	000ba583          	lw	a1,0(s7)
 796:	855a                	mv	a0,s6
 798:	dcfff0ef          	jal	ra,566 <printint>
        i += 1;
 79c:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 79e:	8bca                	mv	s7,s2
      state = 0;
 7a0:	4981                	li	s3,0
        i += 1;
 7a2:	b5d9                	j	668 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7a4:	008b8913          	addi	s2,s7,8
 7a8:	4681                	li	a3,0
 7aa:	4629                	li	a2,10
 7ac:	000ba583          	lw	a1,0(s7)
 7b0:	855a                	mv	a0,s6
 7b2:	db5ff0ef          	jal	ra,566 <printint>
        i += 2;
 7b6:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 7b8:	8bca                	mv	s7,s2
      state = 0;
 7ba:	4981                	li	s3,0
        i += 2;
 7bc:	b575                	j	668 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 16, 0);
 7be:	008b8913          	addi	s2,s7,8
 7c2:	4681                	li	a3,0
 7c4:	4641                	li	a2,16
 7c6:	000ba583          	lw	a1,0(s7)
 7ca:	855a                	mv	a0,s6
 7cc:	d9bff0ef          	jal	ra,566 <printint>
 7d0:	8bca                	mv	s7,s2
      state = 0;
 7d2:	4981                	li	s3,0
 7d4:	bd51                	j	668 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 7d6:	008b8913          	addi	s2,s7,8
 7da:	4681                	li	a3,0
 7dc:	4641                	li	a2,16
 7de:	000ba583          	lw	a1,0(s7)
 7e2:	855a                	mv	a0,s6
 7e4:	d83ff0ef          	jal	ra,566 <printint>
        i += 1;
 7e8:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 7ea:	8bca                	mv	s7,s2
      state = 0;
 7ec:	4981                	li	s3,0
        i += 1;
 7ee:	bdad                	j	668 <vprintf+0x5a>
        printptr(fd, va_arg(ap, uint64));
 7f0:	008b8793          	addi	a5,s7,8
 7f4:	f8f43423          	sd	a5,-120(s0)
 7f8:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 7fc:	03000593          	li	a1,48
 800:	855a                	mv	a0,s6
 802:	d47ff0ef          	jal	ra,548 <putc>
  putc(fd, 'x');
 806:	07800593          	li	a1,120
 80a:	855a                	mv	a0,s6
 80c:	d3dff0ef          	jal	ra,548 <putc>
 810:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 812:	03c9d793          	srli	a5,s3,0x3c
 816:	97e6                	add	a5,a5,s9
 818:	0007c583          	lbu	a1,0(a5)
 81c:	855a                	mv	a0,s6
 81e:	d2bff0ef          	jal	ra,548 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 822:	0992                	slli	s3,s3,0x4
 824:	397d                	addiw	s2,s2,-1
 826:	fe0916e3          	bnez	s2,812 <vprintf+0x204>
        printptr(fd, va_arg(ap, uint64));
 82a:	f8843b83          	ld	s7,-120(s0)
      state = 0;
 82e:	4981                	li	s3,0
 830:	bd25                	j	668 <vprintf+0x5a>
        if((s = va_arg(ap, char*)) == 0)
 832:	008b8993          	addi	s3,s7,8
 836:	000bb903          	ld	s2,0(s7)
 83a:	00090f63          	beqz	s2,858 <vprintf+0x24a>
        for(; *s; s++)
 83e:	00094583          	lbu	a1,0(s2)
 842:	c195                	beqz	a1,866 <vprintf+0x258>
          putc(fd, *s);
 844:	855a                	mv	a0,s6
 846:	d03ff0ef          	jal	ra,548 <putc>
        for(; *s; s++)
 84a:	0905                	addi	s2,s2,1
 84c:	00094583          	lbu	a1,0(s2)
 850:	f9f5                	bnez	a1,844 <vprintf+0x236>
        if((s = va_arg(ap, char*)) == 0)
 852:	8bce                	mv	s7,s3
      state = 0;
 854:	4981                	li	s3,0
 856:	bd09                	j	668 <vprintf+0x5a>
          s = "(null)";
 858:	00000917          	auipc	s2,0x0
 85c:	27890913          	addi	s2,s2,632 # ad0 <malloc+0x168>
        for(; *s; s++)
 860:	02800593          	li	a1,40
 864:	b7c5                	j	844 <vprintf+0x236>
        if((s = va_arg(ap, char*)) == 0)
 866:	8bce                	mv	s7,s3
      state = 0;
 868:	4981                	li	s3,0
 86a:	bbfd                	j	668 <vprintf+0x5a>
    }
  }
}
 86c:	70e6                	ld	ra,120(sp)
 86e:	7446                	ld	s0,112(sp)
 870:	74a6                	ld	s1,104(sp)
 872:	7906                	ld	s2,96(sp)
 874:	69e6                	ld	s3,88(sp)
 876:	6a46                	ld	s4,80(sp)
 878:	6aa6                	ld	s5,72(sp)
 87a:	6b06                	ld	s6,64(sp)
 87c:	7be2                	ld	s7,56(sp)
 87e:	7c42                	ld	s8,48(sp)
 880:	7ca2                	ld	s9,40(sp)
 882:	7d02                	ld	s10,32(sp)
 884:	6de2                	ld	s11,24(sp)
 886:	6109                	addi	sp,sp,128
 888:	8082                	ret

000000000000088a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 88a:	715d                	addi	sp,sp,-80
 88c:	ec06                	sd	ra,24(sp)
 88e:	e822                	sd	s0,16(sp)
 890:	1000                	addi	s0,sp,32
 892:	e010                	sd	a2,0(s0)
 894:	e414                	sd	a3,8(s0)
 896:	e818                	sd	a4,16(s0)
 898:	ec1c                	sd	a5,24(s0)
 89a:	03043023          	sd	a6,32(s0)
 89e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 8a2:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 8a6:	8622                	mv	a2,s0
 8a8:	d67ff0ef          	jal	ra,60e <vprintf>
}
 8ac:	60e2                	ld	ra,24(sp)
 8ae:	6442                	ld	s0,16(sp)
 8b0:	6161                	addi	sp,sp,80
 8b2:	8082                	ret

00000000000008b4 <printf>:

void
printf(const char *fmt, ...)
{
 8b4:	711d                	addi	sp,sp,-96
 8b6:	ec06                	sd	ra,24(sp)
 8b8:	e822                	sd	s0,16(sp)
 8ba:	1000                	addi	s0,sp,32
 8bc:	e40c                	sd	a1,8(s0)
 8be:	e810                	sd	a2,16(s0)
 8c0:	ec14                	sd	a3,24(s0)
 8c2:	f018                	sd	a4,32(s0)
 8c4:	f41c                	sd	a5,40(s0)
 8c6:	03043823          	sd	a6,48(s0)
 8ca:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 8ce:	00840613          	addi	a2,s0,8
 8d2:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 8d6:	85aa                	mv	a1,a0
 8d8:	4505                	li	a0,1
 8da:	d35ff0ef          	jal	ra,60e <vprintf>
}
 8de:	60e2                	ld	ra,24(sp)
 8e0:	6442                	ld	s0,16(sp)
 8e2:	6125                	addi	sp,sp,96
 8e4:	8082                	ret

00000000000008e6 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8e6:	1141                	addi	sp,sp,-16
 8e8:	e422                	sd	s0,8(sp)
 8ea:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8ec:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8f0:	00000797          	auipc	a5,0x0
 8f4:	7107b783          	ld	a5,1808(a5) # 1000 <freep>
 8f8:	a02d                	j	922 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 8fa:	4618                	lw	a4,8(a2)
 8fc:	9f2d                	addw	a4,a4,a1
 8fe:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 902:	6398                	ld	a4,0(a5)
 904:	6310                	ld	a2,0(a4)
 906:	a83d                	j	944 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 908:	ff852703          	lw	a4,-8(a0)
 90c:	9f31                	addw	a4,a4,a2
 90e:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 910:	ff053683          	ld	a3,-16(a0)
 914:	a091                	j	958 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 916:	6398                	ld	a4,0(a5)
 918:	00e7e463          	bltu	a5,a4,920 <free+0x3a>
 91c:	00e6ea63          	bltu	a3,a4,930 <free+0x4a>
{
 920:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 922:	fed7fae3          	bgeu	a5,a3,916 <free+0x30>
 926:	6398                	ld	a4,0(a5)
 928:	00e6e463          	bltu	a3,a4,930 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 92c:	fee7eae3          	bltu	a5,a4,920 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 930:	ff852583          	lw	a1,-8(a0)
 934:	6390                	ld	a2,0(a5)
 936:	02059813          	slli	a6,a1,0x20
 93a:	01c85713          	srli	a4,a6,0x1c
 93e:	9736                	add	a4,a4,a3
 940:	fae60de3          	beq	a2,a4,8fa <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 944:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 948:	4790                	lw	a2,8(a5)
 94a:	02061593          	slli	a1,a2,0x20
 94e:	01c5d713          	srli	a4,a1,0x1c
 952:	973e                	add	a4,a4,a5
 954:	fae68ae3          	beq	a3,a4,908 <free+0x22>
    p->s.ptr = bp->s.ptr;
 958:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 95a:	00000717          	auipc	a4,0x0
 95e:	6af73323          	sd	a5,1702(a4) # 1000 <freep>
}
 962:	6422                	ld	s0,8(sp)
 964:	0141                	addi	sp,sp,16
 966:	8082                	ret

0000000000000968 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 968:	7139                	addi	sp,sp,-64
 96a:	fc06                	sd	ra,56(sp)
 96c:	f822                	sd	s0,48(sp)
 96e:	f426                	sd	s1,40(sp)
 970:	f04a                	sd	s2,32(sp)
 972:	ec4e                	sd	s3,24(sp)
 974:	e852                	sd	s4,16(sp)
 976:	e456                	sd	s5,8(sp)
 978:	e05a                	sd	s6,0(sp)
 97a:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 97c:	02051493          	slli	s1,a0,0x20
 980:	9081                	srli	s1,s1,0x20
 982:	04bd                	addi	s1,s1,15
 984:	8091                	srli	s1,s1,0x4
 986:	0014899b          	addiw	s3,s1,1
 98a:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 98c:	00000517          	auipc	a0,0x0
 990:	67453503          	ld	a0,1652(a0) # 1000 <freep>
 994:	c515                	beqz	a0,9c0 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 996:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 998:	4798                	lw	a4,8(a5)
 99a:	02977f63          	bgeu	a4,s1,9d8 <malloc+0x70>
 99e:	8a4e                	mv	s4,s3
 9a0:	0009871b          	sext.w	a4,s3
 9a4:	6685                	lui	a3,0x1
 9a6:	00d77363          	bgeu	a4,a3,9ac <malloc+0x44>
 9aa:	6a05                	lui	s4,0x1
 9ac:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 9b0:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 9b4:	00000917          	auipc	s2,0x0
 9b8:	64c90913          	addi	s2,s2,1612 # 1000 <freep>
  if(p == (char*)-1)
 9bc:	5afd                	li	s5,-1
 9be:	a885                	j	a2e <malloc+0xc6>
    base.s.ptr = freep = prevp = &base;
 9c0:	00000797          	auipc	a5,0x0
 9c4:	66078793          	addi	a5,a5,1632 # 1020 <base>
 9c8:	00000717          	auipc	a4,0x0
 9cc:	62f73c23          	sd	a5,1592(a4) # 1000 <freep>
 9d0:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 9d2:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 9d6:	b7e1                	j	99e <malloc+0x36>
      if(p->s.size == nunits)
 9d8:	02e48c63          	beq	s1,a4,a10 <malloc+0xa8>
        p->s.size -= nunits;
 9dc:	4137073b          	subw	a4,a4,s3
 9e0:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9e2:	02071693          	slli	a3,a4,0x20
 9e6:	01c6d713          	srli	a4,a3,0x1c
 9ea:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9ec:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9f0:	00000717          	auipc	a4,0x0
 9f4:	60a73823          	sd	a0,1552(a4) # 1000 <freep>
      return (void*)(p + 1);
 9f8:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 9fc:	70e2                	ld	ra,56(sp)
 9fe:	7442                	ld	s0,48(sp)
 a00:	74a2                	ld	s1,40(sp)
 a02:	7902                	ld	s2,32(sp)
 a04:	69e2                	ld	s3,24(sp)
 a06:	6a42                	ld	s4,16(sp)
 a08:	6aa2                	ld	s5,8(sp)
 a0a:	6b02                	ld	s6,0(sp)
 a0c:	6121                	addi	sp,sp,64
 a0e:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 a10:	6398                	ld	a4,0(a5)
 a12:	e118                	sd	a4,0(a0)
 a14:	bff1                	j	9f0 <malloc+0x88>
  hp->s.size = nu;
 a16:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a1a:	0541                	addi	a0,a0,16
 a1c:	ecbff0ef          	jal	ra,8e6 <free>
  return freep;
 a20:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 a24:	dd61                	beqz	a0,9fc <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a26:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a28:	4798                	lw	a4,8(a5)
 a2a:	fa9777e3          	bgeu	a4,s1,9d8 <malloc+0x70>
    if(p == freep)
 a2e:	00093703          	ld	a4,0(s2)
 a32:	853e                	mv	a0,a5
 a34:	fef719e3          	bne	a4,a5,a26 <malloc+0xbe>
  p = sbrk(nu * sizeof(Header));
 a38:	8552                	mv	a0,s4
 a3a:	af7ff0ef          	jal	ra,530 <sbrk>
  if(p == (char*)-1)
 a3e:	fd551ce3          	bne	a0,s5,a16 <malloc+0xae>
        return 0;
 a42:	4501                	li	a0,0
 a44:	bf65                	j	9fc <malloc+0x94>
