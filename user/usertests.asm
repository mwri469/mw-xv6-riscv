
user/_usertests:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <copyinstr1>:
}

// what if you pass ridiculous string pointers to system calls?
void
copyinstr1(char *s)
{
       0:	711d                	addi	sp,sp,-96
       2:	ec86                	sd	ra,88(sp)
       4:	e8a2                	sd	s0,80(sp)
       6:	e4a6                	sd	s1,72(sp)
       8:	e0ca                	sd	s2,64(sp)
       a:	fc4e                	sd	s3,56(sp)
       c:	1080                	addi	s0,sp,96
  uint64 addrs[] = { 0x80000000LL, 0x3fffffe000, 0x3ffffff000, 0x4000000000,
       e:	00007797          	auipc	a5,0x7
      12:	36278793          	addi	a5,a5,866 # 7370 <malloc+0x247c>
      16:	638c                	ld	a1,0(a5)
      18:	6790                	ld	a2,8(a5)
      1a:	6b94                	ld	a3,16(a5)
      1c:	6f98                	ld	a4,24(a5)
      1e:	739c                	ld	a5,32(a5)
      20:	fab43423          	sd	a1,-88(s0)
      24:	fac43823          	sd	a2,-80(s0)
      28:	fad43c23          	sd	a3,-72(s0)
      2c:	fce43023          	sd	a4,-64(s0)
      30:	fcf43423          	sd	a5,-56(s0)
                     0xffffffffffffffff };

  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
      34:	fa840493          	addi	s1,s0,-88
      38:	fd040993          	addi	s3,s0,-48
    uint64 addr = addrs[ai];

    int fd = open((char *)addr, O_CREATE|O_WRONLY);
      3c:	0004b903          	ld	s2,0(s1)
      40:	20100593          	li	a1,513
      44:	854a                	mv	a0,s2
      46:	22f040ef          	jal	ra,4a74 <open>
    if(fd >= 0){
      4a:	00055c63          	bgez	a0,62 <copyinstr1+0x62>
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
      4e:	04a1                	addi	s1,s1,8
      50:	ff3496e3          	bne	s1,s3,3c <copyinstr1+0x3c>
      printf("open(%p) returned %d, not -1\n", (void*)addr, fd);
      exit(1);
    }
  }
}
      54:	60e6                	ld	ra,88(sp)
      56:	6446                	ld	s0,80(sp)
      58:	64a6                	ld	s1,72(sp)
      5a:	6906                	ld	s2,64(sp)
      5c:	79e2                	ld	s3,56(sp)
      5e:	6125                	addi	sp,sp,96
      60:	8082                	ret
      printf("open(%p) returned %d, not -1\n", (void*)addr, fd);
      62:	862a                	mv	a2,a0
      64:	85ca                	mv	a1,s2
      66:	00005517          	auipc	a0,0x5
      6a:	f7a50513          	addi	a0,a0,-134 # 4fe0 <malloc+0xec>
      6e:	5d3040ef          	jal	ra,4e40 <printf>
      exit(1);
      72:	4505                	li	a0,1
      74:	1c1040ef          	jal	ra,4a34 <exit>

0000000000000078 <bsstest>:
void
bsstest(char *s)
{
  int i;

  for(i = 0; i < sizeof(uninit); i++){
      78:	00009797          	auipc	a5,0x9
      7c:	4f078793          	addi	a5,a5,1264 # 9568 <uninit>
      80:	0000c697          	auipc	a3,0xc
      84:	bf868693          	addi	a3,a3,-1032 # bc78 <buf>
    if(uninit[i] != '\0'){
      88:	0007c703          	lbu	a4,0(a5)
      8c:	e709                	bnez	a4,96 <bsstest+0x1e>
  for(i = 0; i < sizeof(uninit); i++){
      8e:	0785                	addi	a5,a5,1
      90:	fed79ce3          	bne	a5,a3,88 <bsstest+0x10>
      94:	8082                	ret
{
      96:	1141                	addi	sp,sp,-16
      98:	e406                	sd	ra,8(sp)
      9a:	e022                	sd	s0,0(sp)
      9c:	0800                	addi	s0,sp,16
      printf("%s: bss test failed\n", s);
      9e:	85aa                	mv	a1,a0
      a0:	00005517          	auipc	a0,0x5
      a4:	f6050513          	addi	a0,a0,-160 # 5000 <malloc+0x10c>
      a8:	599040ef          	jal	ra,4e40 <printf>
      exit(1);
      ac:	4505                	li	a0,1
      ae:	187040ef          	jal	ra,4a34 <exit>

00000000000000b2 <opentest>:
{
      b2:	1101                	addi	sp,sp,-32
      b4:	ec06                	sd	ra,24(sp)
      b6:	e822                	sd	s0,16(sp)
      b8:	e426                	sd	s1,8(sp)
      ba:	1000                	addi	s0,sp,32
      bc:	84aa                	mv	s1,a0
  fd = open("echo", 0);
      be:	4581                	li	a1,0
      c0:	00005517          	auipc	a0,0x5
      c4:	f5850513          	addi	a0,a0,-168 # 5018 <malloc+0x124>
      c8:	1ad040ef          	jal	ra,4a74 <open>
  if(fd < 0){
      cc:	02054263          	bltz	a0,f0 <opentest+0x3e>
  close(fd);
      d0:	18d040ef          	jal	ra,4a5c <close>
  fd = open("doesnotexist", 0);
      d4:	4581                	li	a1,0
      d6:	00005517          	auipc	a0,0x5
      da:	f6250513          	addi	a0,a0,-158 # 5038 <malloc+0x144>
      de:	197040ef          	jal	ra,4a74 <open>
  if(fd >= 0){
      e2:	02055163          	bgez	a0,104 <opentest+0x52>
}
      e6:	60e2                	ld	ra,24(sp)
      e8:	6442                	ld	s0,16(sp)
      ea:	64a2                	ld	s1,8(sp)
      ec:	6105                	addi	sp,sp,32
      ee:	8082                	ret
    printf("%s: open echo failed!\n", s);
      f0:	85a6                	mv	a1,s1
      f2:	00005517          	auipc	a0,0x5
      f6:	f2e50513          	addi	a0,a0,-210 # 5020 <malloc+0x12c>
      fa:	547040ef          	jal	ra,4e40 <printf>
    exit(1);
      fe:	4505                	li	a0,1
     100:	135040ef          	jal	ra,4a34 <exit>
    printf("%s: open doesnotexist succeeded!\n", s);
     104:	85a6                	mv	a1,s1
     106:	00005517          	auipc	a0,0x5
     10a:	f4250513          	addi	a0,a0,-190 # 5048 <malloc+0x154>
     10e:	533040ef          	jal	ra,4e40 <printf>
    exit(1);
     112:	4505                	li	a0,1
     114:	121040ef          	jal	ra,4a34 <exit>

0000000000000118 <truncate2>:
{
     118:	7179                	addi	sp,sp,-48
     11a:	f406                	sd	ra,40(sp)
     11c:	f022                	sd	s0,32(sp)
     11e:	ec26                	sd	s1,24(sp)
     120:	e84a                	sd	s2,16(sp)
     122:	e44e                	sd	s3,8(sp)
     124:	1800                	addi	s0,sp,48
     126:	89aa                	mv	s3,a0
  unlink("truncfile");
     128:	00005517          	auipc	a0,0x5
     12c:	f4850513          	addi	a0,a0,-184 # 5070 <malloc+0x17c>
     130:	155040ef          	jal	ra,4a84 <unlink>
  int fd1 = open("truncfile", O_CREATE|O_TRUNC|O_WRONLY);
     134:	60100593          	li	a1,1537
     138:	00005517          	auipc	a0,0x5
     13c:	f3850513          	addi	a0,a0,-200 # 5070 <malloc+0x17c>
     140:	135040ef          	jal	ra,4a74 <open>
     144:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     146:	4611                	li	a2,4
     148:	00005597          	auipc	a1,0x5
     14c:	f3858593          	addi	a1,a1,-200 # 5080 <malloc+0x18c>
     150:	105040ef          	jal	ra,4a54 <write>
  int fd2 = open("truncfile", O_TRUNC|O_WRONLY);
     154:	40100593          	li	a1,1025
     158:	00005517          	auipc	a0,0x5
     15c:	f1850513          	addi	a0,a0,-232 # 5070 <malloc+0x17c>
     160:	115040ef          	jal	ra,4a74 <open>
     164:	892a                	mv	s2,a0
  int n = write(fd1, "x", 1);
     166:	4605                	li	a2,1
     168:	00005597          	auipc	a1,0x5
     16c:	f2058593          	addi	a1,a1,-224 # 5088 <malloc+0x194>
     170:	8526                	mv	a0,s1
     172:	0e3040ef          	jal	ra,4a54 <write>
  if(n != -1){
     176:	57fd                	li	a5,-1
     178:	02f51563          	bne	a0,a5,1a2 <truncate2+0x8a>
  unlink("truncfile");
     17c:	00005517          	auipc	a0,0x5
     180:	ef450513          	addi	a0,a0,-268 # 5070 <malloc+0x17c>
     184:	101040ef          	jal	ra,4a84 <unlink>
  close(fd1);
     188:	8526                	mv	a0,s1
     18a:	0d3040ef          	jal	ra,4a5c <close>
  close(fd2);
     18e:	854a                	mv	a0,s2
     190:	0cd040ef          	jal	ra,4a5c <close>
}
     194:	70a2                	ld	ra,40(sp)
     196:	7402                	ld	s0,32(sp)
     198:	64e2                	ld	s1,24(sp)
     19a:	6942                	ld	s2,16(sp)
     19c:	69a2                	ld	s3,8(sp)
     19e:	6145                	addi	sp,sp,48
     1a0:	8082                	ret
    printf("%s: write returned %d, expected -1\n", s, n);
     1a2:	862a                	mv	a2,a0
     1a4:	85ce                	mv	a1,s3
     1a6:	00005517          	auipc	a0,0x5
     1aa:	eea50513          	addi	a0,a0,-278 # 5090 <malloc+0x19c>
     1ae:	493040ef          	jal	ra,4e40 <printf>
    exit(1);
     1b2:	4505                	li	a0,1
     1b4:	081040ef          	jal	ra,4a34 <exit>

00000000000001b8 <createtest>:
{
     1b8:	7179                	addi	sp,sp,-48
     1ba:	f406                	sd	ra,40(sp)
     1bc:	f022                	sd	s0,32(sp)
     1be:	ec26                	sd	s1,24(sp)
     1c0:	e84a                	sd	s2,16(sp)
     1c2:	1800                	addi	s0,sp,48
  name[0] = 'a';
     1c4:	06100793          	li	a5,97
     1c8:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     1cc:	fc040d23          	sb	zero,-38(s0)
     1d0:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
     1d4:	06400913          	li	s2,100
    name[1] = '0' + i;
     1d8:	fc940ca3          	sb	s1,-39(s0)
    fd = open(name, O_CREATE|O_RDWR);
     1dc:	20200593          	li	a1,514
     1e0:	fd840513          	addi	a0,s0,-40
     1e4:	091040ef          	jal	ra,4a74 <open>
    close(fd);
     1e8:	075040ef          	jal	ra,4a5c <close>
  for(i = 0; i < N; i++){
     1ec:	2485                	addiw	s1,s1,1
     1ee:	0ff4f493          	zext.b	s1,s1
     1f2:	ff2493e3          	bne	s1,s2,1d8 <createtest+0x20>
  name[0] = 'a';
     1f6:	06100793          	li	a5,97
     1fa:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     1fe:	fc040d23          	sb	zero,-38(s0)
     202:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
     206:	06400913          	li	s2,100
    name[1] = '0' + i;
     20a:	fc940ca3          	sb	s1,-39(s0)
    unlink(name);
     20e:	fd840513          	addi	a0,s0,-40
     212:	073040ef          	jal	ra,4a84 <unlink>
  for(i = 0; i < N; i++){
     216:	2485                	addiw	s1,s1,1
     218:	0ff4f493          	zext.b	s1,s1
     21c:	ff2497e3          	bne	s1,s2,20a <createtest+0x52>
}
     220:	70a2                	ld	ra,40(sp)
     222:	7402                	ld	s0,32(sp)
     224:	64e2                	ld	s1,24(sp)
     226:	6942                	ld	s2,16(sp)
     228:	6145                	addi	sp,sp,48
     22a:	8082                	ret

000000000000022c <bigwrite>:
{
     22c:	715d                	addi	sp,sp,-80
     22e:	e486                	sd	ra,72(sp)
     230:	e0a2                	sd	s0,64(sp)
     232:	fc26                	sd	s1,56(sp)
     234:	f84a                	sd	s2,48(sp)
     236:	f44e                	sd	s3,40(sp)
     238:	f052                	sd	s4,32(sp)
     23a:	ec56                	sd	s5,24(sp)
     23c:	e85a                	sd	s6,16(sp)
     23e:	e45e                	sd	s7,8(sp)
     240:	0880                	addi	s0,sp,80
     242:	8baa                	mv	s7,a0
  unlink("bigwrite");
     244:	00005517          	auipc	a0,0x5
     248:	e7450513          	addi	a0,a0,-396 # 50b8 <malloc+0x1c4>
     24c:	039040ef          	jal	ra,4a84 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     250:	1f300493          	li	s1,499
    fd = open("bigwrite", O_CREATE | O_RDWR);
     254:	00005a97          	auipc	s5,0x5
     258:	e64a8a93          	addi	s5,s5,-412 # 50b8 <malloc+0x1c4>
      int cc = write(fd, buf, sz);
     25c:	0000ca17          	auipc	s4,0xc
     260:	a1ca0a13          	addi	s4,s4,-1508 # bc78 <buf>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     264:	6b0d                	lui	s6,0x3
     266:	1c9b0b13          	addi	s6,s6,457 # 31c9 <rmdot+0x53>
    fd = open("bigwrite", O_CREATE | O_RDWR);
     26a:	20200593          	li	a1,514
     26e:	8556                	mv	a0,s5
     270:	005040ef          	jal	ra,4a74 <open>
     274:	892a                	mv	s2,a0
    if(fd < 0){
     276:	04054563          	bltz	a0,2c0 <bigwrite+0x94>
      int cc = write(fd, buf, sz);
     27a:	8626                	mv	a2,s1
     27c:	85d2                	mv	a1,s4
     27e:	7d6040ef          	jal	ra,4a54 <write>
     282:	89aa                	mv	s3,a0
      if(cc != sz){
     284:	04a49863          	bne	s1,a0,2d4 <bigwrite+0xa8>
      int cc = write(fd, buf, sz);
     288:	8626                	mv	a2,s1
     28a:	85d2                	mv	a1,s4
     28c:	854a                	mv	a0,s2
     28e:	7c6040ef          	jal	ra,4a54 <write>
      if(cc != sz){
     292:	04951263          	bne	a0,s1,2d6 <bigwrite+0xaa>
    close(fd);
     296:	854a                	mv	a0,s2
     298:	7c4040ef          	jal	ra,4a5c <close>
    unlink("bigwrite");
     29c:	8556                	mv	a0,s5
     29e:	7e6040ef          	jal	ra,4a84 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2a2:	1d74849b          	addiw	s1,s1,471
     2a6:	fd6492e3          	bne	s1,s6,26a <bigwrite+0x3e>
}
     2aa:	60a6                	ld	ra,72(sp)
     2ac:	6406                	ld	s0,64(sp)
     2ae:	74e2                	ld	s1,56(sp)
     2b0:	7942                	ld	s2,48(sp)
     2b2:	79a2                	ld	s3,40(sp)
     2b4:	7a02                	ld	s4,32(sp)
     2b6:	6ae2                	ld	s5,24(sp)
     2b8:	6b42                	ld	s6,16(sp)
     2ba:	6ba2                	ld	s7,8(sp)
     2bc:	6161                	addi	sp,sp,80
     2be:	8082                	ret
      printf("%s: cannot create bigwrite\n", s);
     2c0:	85de                	mv	a1,s7
     2c2:	00005517          	auipc	a0,0x5
     2c6:	e0650513          	addi	a0,a0,-506 # 50c8 <malloc+0x1d4>
     2ca:	377040ef          	jal	ra,4e40 <printf>
      exit(1);
     2ce:	4505                	li	a0,1
     2d0:	764040ef          	jal	ra,4a34 <exit>
      if(cc != sz){
     2d4:	89a6                	mv	s3,s1
        printf("%s: write(%d) ret %d\n", s, sz, cc);
     2d6:	86aa                	mv	a3,a0
     2d8:	864e                	mv	a2,s3
     2da:	85de                	mv	a1,s7
     2dc:	00005517          	auipc	a0,0x5
     2e0:	e0c50513          	addi	a0,a0,-500 # 50e8 <malloc+0x1f4>
     2e4:	35d040ef          	jal	ra,4e40 <printf>
        exit(1);
     2e8:	4505                	li	a0,1
     2ea:	74a040ef          	jal	ra,4a34 <exit>

00000000000002ee <badwrite>:
// file is deleted? if the kernel has this bug, it will panic: balloc:
// out of blocks. assumed_free may need to be raised to be more than
// the number of free blocks. this test takes a long time.
void
badwrite(char *s)
{
     2ee:	7179                	addi	sp,sp,-48
     2f0:	f406                	sd	ra,40(sp)
     2f2:	f022                	sd	s0,32(sp)
     2f4:	ec26                	sd	s1,24(sp)
     2f6:	e84a                	sd	s2,16(sp)
     2f8:	e44e                	sd	s3,8(sp)
     2fa:	e052                	sd	s4,0(sp)
     2fc:	1800                	addi	s0,sp,48
  int assumed_free = 600;
  
  unlink("junk");
     2fe:	00005517          	auipc	a0,0x5
     302:	e0250513          	addi	a0,a0,-510 # 5100 <malloc+0x20c>
     306:	77e040ef          	jal	ra,4a84 <unlink>
     30a:	25800913          	li	s2,600
  for(int i = 0; i < assumed_free; i++){
    int fd = open("junk", O_CREATE|O_WRONLY);
     30e:	00005997          	auipc	s3,0x5
     312:	df298993          	addi	s3,s3,-526 # 5100 <malloc+0x20c>
    if(fd < 0){
      printf("open junk failed\n");
      exit(1);
    }
    write(fd, (char*)0xffffffffffL, 1);
     316:	5a7d                	li	s4,-1
     318:	018a5a13          	srli	s4,s4,0x18
    int fd = open("junk", O_CREATE|O_WRONLY);
     31c:	20100593          	li	a1,513
     320:	854e                	mv	a0,s3
     322:	752040ef          	jal	ra,4a74 <open>
     326:	84aa                	mv	s1,a0
    if(fd < 0){
     328:	04054d63          	bltz	a0,382 <badwrite+0x94>
    write(fd, (char*)0xffffffffffL, 1);
     32c:	4605                	li	a2,1
     32e:	85d2                	mv	a1,s4
     330:	724040ef          	jal	ra,4a54 <write>
    close(fd);
     334:	8526                	mv	a0,s1
     336:	726040ef          	jal	ra,4a5c <close>
    unlink("junk");
     33a:	854e                	mv	a0,s3
     33c:	748040ef          	jal	ra,4a84 <unlink>
  for(int i = 0; i < assumed_free; i++){
     340:	397d                	addiw	s2,s2,-1
     342:	fc091de3          	bnez	s2,31c <badwrite+0x2e>
  }

  int fd = open("junk", O_CREATE|O_WRONLY);
     346:	20100593          	li	a1,513
     34a:	00005517          	auipc	a0,0x5
     34e:	db650513          	addi	a0,a0,-586 # 5100 <malloc+0x20c>
     352:	722040ef          	jal	ra,4a74 <open>
     356:	84aa                	mv	s1,a0
  if(fd < 0){
     358:	02054e63          	bltz	a0,394 <badwrite+0xa6>
    printf("open junk failed\n");
    exit(1);
  }
  if(write(fd, "x", 1) != 1){
     35c:	4605                	li	a2,1
     35e:	00005597          	auipc	a1,0x5
     362:	d2a58593          	addi	a1,a1,-726 # 5088 <malloc+0x194>
     366:	6ee040ef          	jal	ra,4a54 <write>
     36a:	4785                	li	a5,1
     36c:	02f50d63          	beq	a0,a5,3a6 <badwrite+0xb8>
    printf("write failed\n");
     370:	00005517          	auipc	a0,0x5
     374:	db050513          	addi	a0,a0,-592 # 5120 <malloc+0x22c>
     378:	2c9040ef          	jal	ra,4e40 <printf>
    exit(1);
     37c:	4505                	li	a0,1
     37e:	6b6040ef          	jal	ra,4a34 <exit>
      printf("open junk failed\n");
     382:	00005517          	auipc	a0,0x5
     386:	d8650513          	addi	a0,a0,-634 # 5108 <malloc+0x214>
     38a:	2b7040ef          	jal	ra,4e40 <printf>
      exit(1);
     38e:	4505                	li	a0,1
     390:	6a4040ef          	jal	ra,4a34 <exit>
    printf("open junk failed\n");
     394:	00005517          	auipc	a0,0x5
     398:	d7450513          	addi	a0,a0,-652 # 5108 <malloc+0x214>
     39c:	2a5040ef          	jal	ra,4e40 <printf>
    exit(1);
     3a0:	4505                	li	a0,1
     3a2:	692040ef          	jal	ra,4a34 <exit>
  }
  close(fd);
     3a6:	8526                	mv	a0,s1
     3a8:	6b4040ef          	jal	ra,4a5c <close>
  unlink("junk");
     3ac:	00005517          	auipc	a0,0x5
     3b0:	d5450513          	addi	a0,a0,-684 # 5100 <malloc+0x20c>
     3b4:	6d0040ef          	jal	ra,4a84 <unlink>

  exit(0);
     3b8:	4501                	li	a0,0
     3ba:	67a040ef          	jal	ra,4a34 <exit>

00000000000003be <outofinodes>:
  }
}

void
outofinodes(char *s)
{
     3be:	715d                	addi	sp,sp,-80
     3c0:	e486                	sd	ra,72(sp)
     3c2:	e0a2                	sd	s0,64(sp)
     3c4:	fc26                	sd	s1,56(sp)
     3c6:	f84a                	sd	s2,48(sp)
     3c8:	f44e                	sd	s3,40(sp)
     3ca:	0880                	addi	s0,sp,80
  int nzz = 32*32;
  for(int i = 0; i < nzz; i++){
     3cc:	4481                	li	s1,0
    char name[32];
    name[0] = 'z';
     3ce:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
     3d2:	40000993          	li	s3,1024
    name[0] = 'z';
     3d6:	fb240823          	sb	s2,-80(s0)
    name[1] = 'z';
     3da:	fb2408a3          	sb	s2,-79(s0)
    name[2] = '0' + (i / 32);
     3de:	41f4d71b          	sraiw	a4,s1,0x1f
     3e2:	01b7571b          	srliw	a4,a4,0x1b
     3e6:	009707bb          	addw	a5,a4,s1
     3ea:	4057d69b          	sraiw	a3,a5,0x5
     3ee:	0306869b          	addiw	a3,a3,48
     3f2:	fad40923          	sb	a3,-78(s0)
    name[3] = '0' + (i % 32);
     3f6:	8bfd                	andi	a5,a5,31
     3f8:	9f99                	subw	a5,a5,a4
     3fa:	0307879b          	addiw	a5,a5,48
     3fe:	faf409a3          	sb	a5,-77(s0)
    name[4] = '\0';
     402:	fa040a23          	sb	zero,-76(s0)
    unlink(name);
     406:	fb040513          	addi	a0,s0,-80
     40a:	67a040ef          	jal	ra,4a84 <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
     40e:	60200593          	li	a1,1538
     412:	fb040513          	addi	a0,s0,-80
     416:	65e040ef          	jal	ra,4a74 <open>
    if(fd < 0){
     41a:	00054763          	bltz	a0,428 <outofinodes+0x6a>
      // failure is eventually expected.
      break;
    }
    close(fd);
     41e:	63e040ef          	jal	ra,4a5c <close>
  for(int i = 0; i < nzz; i++){
     422:	2485                	addiw	s1,s1,1
     424:	fb3499e3          	bne	s1,s3,3d6 <outofinodes+0x18>
     428:	4481                	li	s1,0
  }

  for(int i = 0; i < nzz; i++){
    char name[32];
    name[0] = 'z';
     42a:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
     42e:	40000993          	li	s3,1024
    name[0] = 'z';
     432:	fb240823          	sb	s2,-80(s0)
    name[1] = 'z';
     436:	fb2408a3          	sb	s2,-79(s0)
    name[2] = '0' + (i / 32);
     43a:	41f4d71b          	sraiw	a4,s1,0x1f
     43e:	01b7571b          	srliw	a4,a4,0x1b
     442:	009707bb          	addw	a5,a4,s1
     446:	4057d69b          	sraiw	a3,a5,0x5
     44a:	0306869b          	addiw	a3,a3,48
     44e:	fad40923          	sb	a3,-78(s0)
    name[3] = '0' + (i % 32);
     452:	8bfd                	andi	a5,a5,31
     454:	9f99                	subw	a5,a5,a4
     456:	0307879b          	addiw	a5,a5,48
     45a:	faf409a3          	sb	a5,-77(s0)
    name[4] = '\0';
     45e:	fa040a23          	sb	zero,-76(s0)
    unlink(name);
     462:	fb040513          	addi	a0,s0,-80
     466:	61e040ef          	jal	ra,4a84 <unlink>
  for(int i = 0; i < nzz; i++){
     46a:	2485                	addiw	s1,s1,1
     46c:	fd3493e3          	bne	s1,s3,432 <outofinodes+0x74>
  }
}
     470:	60a6                	ld	ra,72(sp)
     472:	6406                	ld	s0,64(sp)
     474:	74e2                	ld	s1,56(sp)
     476:	7942                	ld	s2,48(sp)
     478:	79a2                	ld	s3,40(sp)
     47a:	6161                	addi	sp,sp,80
     47c:	8082                	ret

000000000000047e <copyin>:
{
     47e:	7159                	addi	sp,sp,-112
     480:	f486                	sd	ra,104(sp)
     482:	f0a2                	sd	s0,96(sp)
     484:	eca6                	sd	s1,88(sp)
     486:	e8ca                	sd	s2,80(sp)
     488:	e4ce                	sd	s3,72(sp)
     48a:	e0d2                	sd	s4,64(sp)
     48c:	fc56                	sd	s5,56(sp)
     48e:	1880                	addi	s0,sp,112
  uint64 addrs[] = { 0x80000000LL, 0x3fffffe000, 0x3ffffff000, 0x4000000000,
     490:	00007797          	auipc	a5,0x7
     494:	ee078793          	addi	a5,a5,-288 # 7370 <malloc+0x247c>
     498:	638c                	ld	a1,0(a5)
     49a:	6790                	ld	a2,8(a5)
     49c:	6b94                	ld	a3,16(a5)
     49e:	6f98                	ld	a4,24(a5)
     4a0:	739c                	ld	a5,32(a5)
     4a2:	f8b43c23          	sd	a1,-104(s0)
     4a6:	fac43023          	sd	a2,-96(s0)
     4aa:	fad43423          	sd	a3,-88(s0)
     4ae:	fae43823          	sd	a4,-80(s0)
     4b2:	faf43c23          	sd	a5,-72(s0)
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
     4b6:	f9840913          	addi	s2,s0,-104
     4ba:	fc040a93          	addi	s5,s0,-64
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     4be:	00005a17          	auipc	s4,0x5
     4c2:	c72a0a13          	addi	s4,s4,-910 # 5130 <malloc+0x23c>
    uint64 addr = addrs[ai];
     4c6:	00093983          	ld	s3,0(s2)
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     4ca:	20100593          	li	a1,513
     4ce:	8552                	mv	a0,s4
     4d0:	5a4040ef          	jal	ra,4a74 <open>
     4d4:	84aa                	mv	s1,a0
    if(fd < 0){
     4d6:	06054763          	bltz	a0,544 <copyin+0xc6>
    int n = write(fd, (void*)addr, 8192);
     4da:	6609                	lui	a2,0x2
     4dc:	85ce                	mv	a1,s3
     4de:	576040ef          	jal	ra,4a54 <write>
    if(n >= 0){
     4e2:	06055a63          	bgez	a0,556 <copyin+0xd8>
    close(fd);
     4e6:	8526                	mv	a0,s1
     4e8:	574040ef          	jal	ra,4a5c <close>
    unlink("copyin1");
     4ec:	8552                	mv	a0,s4
     4ee:	596040ef          	jal	ra,4a84 <unlink>
    n = write(1, (char*)addr, 8192);
     4f2:	6609                	lui	a2,0x2
     4f4:	85ce                	mv	a1,s3
     4f6:	4505                	li	a0,1
     4f8:	55c040ef          	jal	ra,4a54 <write>
    if(n > 0){
     4fc:	06a04863          	bgtz	a0,56c <copyin+0xee>
    if(pipe(fds) < 0){
     500:	f9040513          	addi	a0,s0,-112
     504:	540040ef          	jal	ra,4a44 <pipe>
     508:	06054d63          	bltz	a0,582 <copyin+0x104>
    n = write(fds[1], (char*)addr, 8192);
     50c:	6609                	lui	a2,0x2
     50e:	85ce                	mv	a1,s3
     510:	f9442503          	lw	a0,-108(s0)
     514:	540040ef          	jal	ra,4a54 <write>
    if(n > 0){
     518:	06a04e63          	bgtz	a0,594 <copyin+0x116>
    close(fds[0]);
     51c:	f9042503          	lw	a0,-112(s0)
     520:	53c040ef          	jal	ra,4a5c <close>
    close(fds[1]);
     524:	f9442503          	lw	a0,-108(s0)
     528:	534040ef          	jal	ra,4a5c <close>
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
     52c:	0921                	addi	s2,s2,8
     52e:	f9591ce3          	bne	s2,s5,4c6 <copyin+0x48>
}
     532:	70a6                	ld	ra,104(sp)
     534:	7406                	ld	s0,96(sp)
     536:	64e6                	ld	s1,88(sp)
     538:	6946                	ld	s2,80(sp)
     53a:	69a6                	ld	s3,72(sp)
     53c:	6a06                	ld	s4,64(sp)
     53e:	7ae2                	ld	s5,56(sp)
     540:	6165                	addi	sp,sp,112
     542:	8082                	ret
      printf("open(copyin1) failed\n");
     544:	00005517          	auipc	a0,0x5
     548:	bf450513          	addi	a0,a0,-1036 # 5138 <malloc+0x244>
     54c:	0f5040ef          	jal	ra,4e40 <printf>
      exit(1);
     550:	4505                	li	a0,1
     552:	4e2040ef          	jal	ra,4a34 <exit>
      printf("write(fd, %p, 8192) returned %d, not -1\n", (void*)addr, n);
     556:	862a                	mv	a2,a0
     558:	85ce                	mv	a1,s3
     55a:	00005517          	auipc	a0,0x5
     55e:	bf650513          	addi	a0,a0,-1034 # 5150 <malloc+0x25c>
     562:	0df040ef          	jal	ra,4e40 <printf>
      exit(1);
     566:	4505                	li	a0,1
     568:	4cc040ef          	jal	ra,4a34 <exit>
      printf("write(1, %p, 8192) returned %d, not -1 or 0\n", (void*)addr, n);
     56c:	862a                	mv	a2,a0
     56e:	85ce                	mv	a1,s3
     570:	00005517          	auipc	a0,0x5
     574:	c1050513          	addi	a0,a0,-1008 # 5180 <malloc+0x28c>
     578:	0c9040ef          	jal	ra,4e40 <printf>
      exit(1);
     57c:	4505                	li	a0,1
     57e:	4b6040ef          	jal	ra,4a34 <exit>
      printf("pipe() failed\n");
     582:	00005517          	auipc	a0,0x5
     586:	c2e50513          	addi	a0,a0,-978 # 51b0 <malloc+0x2bc>
     58a:	0b7040ef          	jal	ra,4e40 <printf>
      exit(1);
     58e:	4505                	li	a0,1
     590:	4a4040ef          	jal	ra,4a34 <exit>
      printf("write(pipe, %p, 8192) returned %d, not -1 or 0\n", (void*)addr, n);
     594:	862a                	mv	a2,a0
     596:	85ce                	mv	a1,s3
     598:	00005517          	auipc	a0,0x5
     59c:	c2850513          	addi	a0,a0,-984 # 51c0 <malloc+0x2cc>
     5a0:	0a1040ef          	jal	ra,4e40 <printf>
      exit(1);
     5a4:	4505                	li	a0,1
     5a6:	48e040ef          	jal	ra,4a34 <exit>

00000000000005aa <copyout>:
{
     5aa:	7119                	addi	sp,sp,-128
     5ac:	fc86                	sd	ra,120(sp)
     5ae:	f8a2                	sd	s0,112(sp)
     5b0:	f4a6                	sd	s1,104(sp)
     5b2:	f0ca                	sd	s2,96(sp)
     5b4:	ecce                	sd	s3,88(sp)
     5b6:	e8d2                	sd	s4,80(sp)
     5b8:	e4d6                	sd	s5,72(sp)
     5ba:	e0da                	sd	s6,64(sp)
     5bc:	0100                	addi	s0,sp,128
  uint64 addrs[] = { 0LL, 0x80000000LL, 0x3fffffe000, 0x3ffffff000, 0x4000000000,
     5be:	00007797          	auipc	a5,0x7
     5c2:	db278793          	addi	a5,a5,-590 # 7370 <malloc+0x247c>
     5c6:	7788                	ld	a0,40(a5)
     5c8:	7b8c                	ld	a1,48(a5)
     5ca:	7f90                	ld	a2,56(a5)
     5cc:	63b4                	ld	a3,64(a5)
     5ce:	67b8                	ld	a4,72(a5)
     5d0:	6bbc                	ld	a5,80(a5)
     5d2:	f8a43823          	sd	a0,-112(s0)
     5d6:	f8b43c23          	sd	a1,-104(s0)
     5da:	fac43023          	sd	a2,-96(s0)
     5de:	fad43423          	sd	a3,-88(s0)
     5e2:	fae43823          	sd	a4,-80(s0)
     5e6:	faf43c23          	sd	a5,-72(s0)
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
     5ea:	f9040913          	addi	s2,s0,-112
     5ee:	fc040b13          	addi	s6,s0,-64
    int fd = open("README", 0);
     5f2:	00005a17          	auipc	s4,0x5
     5f6:	bfea0a13          	addi	s4,s4,-1026 # 51f0 <malloc+0x2fc>
    n = write(fds[1], "x", 1);
     5fa:	00005a97          	auipc	s5,0x5
     5fe:	a8ea8a93          	addi	s5,s5,-1394 # 5088 <malloc+0x194>
    uint64 addr = addrs[ai];
     602:	00093983          	ld	s3,0(s2)
    int fd = open("README", 0);
     606:	4581                	li	a1,0
     608:	8552                	mv	a0,s4
     60a:	46a040ef          	jal	ra,4a74 <open>
     60e:	84aa                	mv	s1,a0
    if(fd < 0){
     610:	06054763          	bltz	a0,67e <copyout+0xd4>
    int n = read(fd, (void*)addr, 8192);
     614:	6609                	lui	a2,0x2
     616:	85ce                	mv	a1,s3
     618:	434040ef          	jal	ra,4a4c <read>
    if(n > 0){
     61c:	06a04a63          	bgtz	a0,690 <copyout+0xe6>
    close(fd);
     620:	8526                	mv	a0,s1
     622:	43a040ef          	jal	ra,4a5c <close>
    if(pipe(fds) < 0){
     626:	f8840513          	addi	a0,s0,-120
     62a:	41a040ef          	jal	ra,4a44 <pipe>
     62e:	06054c63          	bltz	a0,6a6 <copyout+0xfc>
    n = write(fds[1], "x", 1);
     632:	4605                	li	a2,1
     634:	85d6                	mv	a1,s5
     636:	f8c42503          	lw	a0,-116(s0)
     63a:	41a040ef          	jal	ra,4a54 <write>
    if(n != 1){
     63e:	4785                	li	a5,1
     640:	06f51c63          	bne	a0,a5,6b8 <copyout+0x10e>
    n = read(fds[0], (void*)addr, 8192);
     644:	6609                	lui	a2,0x2
     646:	85ce                	mv	a1,s3
     648:	f8842503          	lw	a0,-120(s0)
     64c:	400040ef          	jal	ra,4a4c <read>
    if(n > 0){
     650:	06a04d63          	bgtz	a0,6ca <copyout+0x120>
    close(fds[0]);
     654:	f8842503          	lw	a0,-120(s0)
     658:	404040ef          	jal	ra,4a5c <close>
    close(fds[1]);
     65c:	f8c42503          	lw	a0,-116(s0)
     660:	3fc040ef          	jal	ra,4a5c <close>
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
     664:	0921                	addi	s2,s2,8
     666:	f9691ee3          	bne	s2,s6,602 <copyout+0x58>
}
     66a:	70e6                	ld	ra,120(sp)
     66c:	7446                	ld	s0,112(sp)
     66e:	74a6                	ld	s1,104(sp)
     670:	7906                	ld	s2,96(sp)
     672:	69e6                	ld	s3,88(sp)
     674:	6a46                	ld	s4,80(sp)
     676:	6aa6                	ld	s5,72(sp)
     678:	6b06                	ld	s6,64(sp)
     67a:	6109                	addi	sp,sp,128
     67c:	8082                	ret
      printf("open(README) failed\n");
     67e:	00005517          	auipc	a0,0x5
     682:	b7a50513          	addi	a0,a0,-1158 # 51f8 <malloc+0x304>
     686:	7ba040ef          	jal	ra,4e40 <printf>
      exit(1);
     68a:	4505                	li	a0,1
     68c:	3a8040ef          	jal	ra,4a34 <exit>
      printf("read(fd, %p, 8192) returned %d, not -1 or 0\n", (void*)addr, n);
     690:	862a                	mv	a2,a0
     692:	85ce                	mv	a1,s3
     694:	00005517          	auipc	a0,0x5
     698:	b7c50513          	addi	a0,a0,-1156 # 5210 <malloc+0x31c>
     69c:	7a4040ef          	jal	ra,4e40 <printf>
      exit(1);
     6a0:	4505                	li	a0,1
     6a2:	392040ef          	jal	ra,4a34 <exit>
      printf("pipe() failed\n");
     6a6:	00005517          	auipc	a0,0x5
     6aa:	b0a50513          	addi	a0,a0,-1270 # 51b0 <malloc+0x2bc>
     6ae:	792040ef          	jal	ra,4e40 <printf>
      exit(1);
     6b2:	4505                	li	a0,1
     6b4:	380040ef          	jal	ra,4a34 <exit>
      printf("pipe write failed\n");
     6b8:	00005517          	auipc	a0,0x5
     6bc:	b8850513          	addi	a0,a0,-1144 # 5240 <malloc+0x34c>
     6c0:	780040ef          	jal	ra,4e40 <printf>
      exit(1);
     6c4:	4505                	li	a0,1
     6c6:	36e040ef          	jal	ra,4a34 <exit>
      printf("read(pipe, %p, 8192) returned %d, not -1 or 0\n", (void*)addr, n);
     6ca:	862a                	mv	a2,a0
     6cc:	85ce                	mv	a1,s3
     6ce:	00005517          	auipc	a0,0x5
     6d2:	b8a50513          	addi	a0,a0,-1142 # 5258 <malloc+0x364>
     6d6:	76a040ef          	jal	ra,4e40 <printf>
      exit(1);
     6da:	4505                	li	a0,1
     6dc:	358040ef          	jal	ra,4a34 <exit>

00000000000006e0 <truncate1>:
{
     6e0:	711d                	addi	sp,sp,-96
     6e2:	ec86                	sd	ra,88(sp)
     6e4:	e8a2                	sd	s0,80(sp)
     6e6:	e4a6                	sd	s1,72(sp)
     6e8:	e0ca                	sd	s2,64(sp)
     6ea:	fc4e                	sd	s3,56(sp)
     6ec:	f852                	sd	s4,48(sp)
     6ee:	f456                	sd	s5,40(sp)
     6f0:	1080                	addi	s0,sp,96
     6f2:	8aaa                	mv	s5,a0
  unlink("truncfile");
     6f4:	00005517          	auipc	a0,0x5
     6f8:	97c50513          	addi	a0,a0,-1668 # 5070 <malloc+0x17c>
     6fc:	388040ef          	jal	ra,4a84 <unlink>
  int fd1 = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
     700:	60100593          	li	a1,1537
     704:	00005517          	auipc	a0,0x5
     708:	96c50513          	addi	a0,a0,-1684 # 5070 <malloc+0x17c>
     70c:	368040ef          	jal	ra,4a74 <open>
     710:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     712:	4611                	li	a2,4
     714:	00005597          	auipc	a1,0x5
     718:	96c58593          	addi	a1,a1,-1684 # 5080 <malloc+0x18c>
     71c:	338040ef          	jal	ra,4a54 <write>
  close(fd1);
     720:	8526                	mv	a0,s1
     722:	33a040ef          	jal	ra,4a5c <close>
  int fd2 = open("truncfile", O_RDONLY);
     726:	4581                	li	a1,0
     728:	00005517          	auipc	a0,0x5
     72c:	94850513          	addi	a0,a0,-1720 # 5070 <malloc+0x17c>
     730:	344040ef          	jal	ra,4a74 <open>
     734:	84aa                	mv	s1,a0
  int n = read(fd2, buf, sizeof(buf));
     736:	02000613          	li	a2,32
     73a:	fa040593          	addi	a1,s0,-96
     73e:	30e040ef          	jal	ra,4a4c <read>
  if(n != 4){
     742:	4791                	li	a5,4
     744:	0af51863          	bne	a0,a5,7f4 <truncate1+0x114>
  fd1 = open("truncfile", O_WRONLY|O_TRUNC);
     748:	40100593          	li	a1,1025
     74c:	00005517          	auipc	a0,0x5
     750:	92450513          	addi	a0,a0,-1756 # 5070 <malloc+0x17c>
     754:	320040ef          	jal	ra,4a74 <open>
     758:	89aa                	mv	s3,a0
  int fd3 = open("truncfile", O_RDONLY);
     75a:	4581                	li	a1,0
     75c:	00005517          	auipc	a0,0x5
     760:	91450513          	addi	a0,a0,-1772 # 5070 <malloc+0x17c>
     764:	310040ef          	jal	ra,4a74 <open>
     768:	892a                	mv	s2,a0
  n = read(fd3, buf, sizeof(buf));
     76a:	02000613          	li	a2,32
     76e:	fa040593          	addi	a1,s0,-96
     772:	2da040ef          	jal	ra,4a4c <read>
     776:	8a2a                	mv	s4,a0
  if(n != 0){
     778:	e949                	bnez	a0,80a <truncate1+0x12a>
  n = read(fd2, buf, sizeof(buf));
     77a:	02000613          	li	a2,32
     77e:	fa040593          	addi	a1,s0,-96
     782:	8526                	mv	a0,s1
     784:	2c8040ef          	jal	ra,4a4c <read>
     788:	8a2a                	mv	s4,a0
  if(n != 0){
     78a:	e155                	bnez	a0,82e <truncate1+0x14e>
  write(fd1, "abcdef", 6);
     78c:	4619                	li	a2,6
     78e:	00005597          	auipc	a1,0x5
     792:	b5a58593          	addi	a1,a1,-1190 # 52e8 <malloc+0x3f4>
     796:	854e                	mv	a0,s3
     798:	2bc040ef          	jal	ra,4a54 <write>
  n = read(fd3, buf, sizeof(buf));
     79c:	02000613          	li	a2,32
     7a0:	fa040593          	addi	a1,s0,-96
     7a4:	854a                	mv	a0,s2
     7a6:	2a6040ef          	jal	ra,4a4c <read>
  if(n != 6){
     7aa:	4799                	li	a5,6
     7ac:	0af51363          	bne	a0,a5,852 <truncate1+0x172>
  n = read(fd2, buf, sizeof(buf));
     7b0:	02000613          	li	a2,32
     7b4:	fa040593          	addi	a1,s0,-96
     7b8:	8526                	mv	a0,s1
     7ba:	292040ef          	jal	ra,4a4c <read>
  if(n != 2){
     7be:	4789                	li	a5,2
     7c0:	0af51463          	bne	a0,a5,868 <truncate1+0x188>
  unlink("truncfile");
     7c4:	00005517          	auipc	a0,0x5
     7c8:	8ac50513          	addi	a0,a0,-1876 # 5070 <malloc+0x17c>
     7cc:	2b8040ef          	jal	ra,4a84 <unlink>
  close(fd1);
     7d0:	854e                	mv	a0,s3
     7d2:	28a040ef          	jal	ra,4a5c <close>
  close(fd2);
     7d6:	8526                	mv	a0,s1
     7d8:	284040ef          	jal	ra,4a5c <close>
  close(fd3);
     7dc:	854a                	mv	a0,s2
     7de:	27e040ef          	jal	ra,4a5c <close>
}
     7e2:	60e6                	ld	ra,88(sp)
     7e4:	6446                	ld	s0,80(sp)
     7e6:	64a6                	ld	s1,72(sp)
     7e8:	6906                	ld	s2,64(sp)
     7ea:	79e2                	ld	s3,56(sp)
     7ec:	7a42                	ld	s4,48(sp)
     7ee:	7aa2                	ld	s5,40(sp)
     7f0:	6125                	addi	sp,sp,96
     7f2:	8082                	ret
    printf("%s: read %d bytes, wanted 4\n", s, n);
     7f4:	862a                	mv	a2,a0
     7f6:	85d6                	mv	a1,s5
     7f8:	00005517          	auipc	a0,0x5
     7fc:	a9050513          	addi	a0,a0,-1392 # 5288 <malloc+0x394>
     800:	640040ef          	jal	ra,4e40 <printf>
    exit(1);
     804:	4505                	li	a0,1
     806:	22e040ef          	jal	ra,4a34 <exit>
    printf("aaa fd3=%d\n", fd3);
     80a:	85ca                	mv	a1,s2
     80c:	00005517          	auipc	a0,0x5
     810:	a9c50513          	addi	a0,a0,-1380 # 52a8 <malloc+0x3b4>
     814:	62c040ef          	jal	ra,4e40 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     818:	8652                	mv	a2,s4
     81a:	85d6                	mv	a1,s5
     81c:	00005517          	auipc	a0,0x5
     820:	a9c50513          	addi	a0,a0,-1380 # 52b8 <malloc+0x3c4>
     824:	61c040ef          	jal	ra,4e40 <printf>
    exit(1);
     828:	4505                	li	a0,1
     82a:	20a040ef          	jal	ra,4a34 <exit>
    printf("bbb fd2=%d\n", fd2);
     82e:	85a6                	mv	a1,s1
     830:	00005517          	auipc	a0,0x5
     834:	aa850513          	addi	a0,a0,-1368 # 52d8 <malloc+0x3e4>
     838:	608040ef          	jal	ra,4e40 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     83c:	8652                	mv	a2,s4
     83e:	85d6                	mv	a1,s5
     840:	00005517          	auipc	a0,0x5
     844:	a7850513          	addi	a0,a0,-1416 # 52b8 <malloc+0x3c4>
     848:	5f8040ef          	jal	ra,4e40 <printf>
    exit(1);
     84c:	4505                	li	a0,1
     84e:	1e6040ef          	jal	ra,4a34 <exit>
    printf("%s: read %d bytes, wanted 6\n", s, n);
     852:	862a                	mv	a2,a0
     854:	85d6                	mv	a1,s5
     856:	00005517          	auipc	a0,0x5
     85a:	a9a50513          	addi	a0,a0,-1382 # 52f0 <malloc+0x3fc>
     85e:	5e2040ef          	jal	ra,4e40 <printf>
    exit(1);
     862:	4505                	li	a0,1
     864:	1d0040ef          	jal	ra,4a34 <exit>
    printf("%s: read %d bytes, wanted 2\n", s, n);
     868:	862a                	mv	a2,a0
     86a:	85d6                	mv	a1,s5
     86c:	00005517          	auipc	a0,0x5
     870:	aa450513          	addi	a0,a0,-1372 # 5310 <malloc+0x41c>
     874:	5cc040ef          	jal	ra,4e40 <printf>
    exit(1);
     878:	4505                	li	a0,1
     87a:	1ba040ef          	jal	ra,4a34 <exit>

000000000000087e <writetest>:
{
     87e:	7139                	addi	sp,sp,-64
     880:	fc06                	sd	ra,56(sp)
     882:	f822                	sd	s0,48(sp)
     884:	f426                	sd	s1,40(sp)
     886:	f04a                	sd	s2,32(sp)
     888:	ec4e                	sd	s3,24(sp)
     88a:	e852                	sd	s4,16(sp)
     88c:	e456                	sd	s5,8(sp)
     88e:	e05a                	sd	s6,0(sp)
     890:	0080                	addi	s0,sp,64
     892:	8b2a                	mv	s6,a0
  fd = open("small", O_CREATE|O_RDWR);
     894:	20200593          	li	a1,514
     898:	00005517          	auipc	a0,0x5
     89c:	a9850513          	addi	a0,a0,-1384 # 5330 <malloc+0x43c>
     8a0:	1d4040ef          	jal	ra,4a74 <open>
  if(fd < 0){
     8a4:	08054f63          	bltz	a0,942 <writetest+0xc4>
     8a8:	892a                	mv	s2,a0
     8aa:	4481                	li	s1,0
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     8ac:	00005997          	auipc	s3,0x5
     8b0:	aac98993          	addi	s3,s3,-1364 # 5358 <malloc+0x464>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     8b4:	00005a97          	auipc	s5,0x5
     8b8:	adca8a93          	addi	s5,s5,-1316 # 5390 <malloc+0x49c>
  for(i = 0; i < N; i++){
     8bc:	06400a13          	li	s4,100
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     8c0:	4629                	li	a2,10
     8c2:	85ce                	mv	a1,s3
     8c4:	854a                	mv	a0,s2
     8c6:	18e040ef          	jal	ra,4a54 <write>
     8ca:	47a9                	li	a5,10
     8cc:	08f51563          	bne	a0,a5,956 <writetest+0xd8>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     8d0:	4629                	li	a2,10
     8d2:	85d6                	mv	a1,s5
     8d4:	854a                	mv	a0,s2
     8d6:	17e040ef          	jal	ra,4a54 <write>
     8da:	47a9                	li	a5,10
     8dc:	08f51863          	bne	a0,a5,96c <writetest+0xee>
  for(i = 0; i < N; i++){
     8e0:	2485                	addiw	s1,s1,1
     8e2:	fd449fe3          	bne	s1,s4,8c0 <writetest+0x42>
  close(fd);
     8e6:	854a                	mv	a0,s2
     8e8:	174040ef          	jal	ra,4a5c <close>
  fd = open("small", O_RDONLY);
     8ec:	4581                	li	a1,0
     8ee:	00005517          	auipc	a0,0x5
     8f2:	a4250513          	addi	a0,a0,-1470 # 5330 <malloc+0x43c>
     8f6:	17e040ef          	jal	ra,4a74 <open>
     8fa:	84aa                	mv	s1,a0
  if(fd < 0){
     8fc:	08054363          	bltz	a0,982 <writetest+0x104>
  i = read(fd, buf, N*SZ*2);
     900:	7d000613          	li	a2,2000
     904:	0000b597          	auipc	a1,0xb
     908:	37458593          	addi	a1,a1,884 # bc78 <buf>
     90c:	140040ef          	jal	ra,4a4c <read>
  if(i != N*SZ*2){
     910:	7d000793          	li	a5,2000
     914:	08f51163          	bne	a0,a5,996 <writetest+0x118>
  close(fd);
     918:	8526                	mv	a0,s1
     91a:	142040ef          	jal	ra,4a5c <close>
  if(unlink("small") < 0){
     91e:	00005517          	auipc	a0,0x5
     922:	a1250513          	addi	a0,a0,-1518 # 5330 <malloc+0x43c>
     926:	15e040ef          	jal	ra,4a84 <unlink>
     92a:	08054063          	bltz	a0,9aa <writetest+0x12c>
}
     92e:	70e2                	ld	ra,56(sp)
     930:	7442                	ld	s0,48(sp)
     932:	74a2                	ld	s1,40(sp)
     934:	7902                	ld	s2,32(sp)
     936:	69e2                	ld	s3,24(sp)
     938:	6a42                	ld	s4,16(sp)
     93a:	6aa2                	ld	s5,8(sp)
     93c:	6b02                	ld	s6,0(sp)
     93e:	6121                	addi	sp,sp,64
     940:	8082                	ret
    printf("%s: error: creat small failed!\n", s);
     942:	85da                	mv	a1,s6
     944:	00005517          	auipc	a0,0x5
     948:	9f450513          	addi	a0,a0,-1548 # 5338 <malloc+0x444>
     94c:	4f4040ef          	jal	ra,4e40 <printf>
    exit(1);
     950:	4505                	li	a0,1
     952:	0e2040ef          	jal	ra,4a34 <exit>
      printf("%s: error: write aa %d new file failed\n", s, i);
     956:	8626                	mv	a2,s1
     958:	85da                	mv	a1,s6
     95a:	00005517          	auipc	a0,0x5
     95e:	a0e50513          	addi	a0,a0,-1522 # 5368 <malloc+0x474>
     962:	4de040ef          	jal	ra,4e40 <printf>
      exit(1);
     966:	4505                	li	a0,1
     968:	0cc040ef          	jal	ra,4a34 <exit>
      printf("%s: error: write bb %d new file failed\n", s, i);
     96c:	8626                	mv	a2,s1
     96e:	85da                	mv	a1,s6
     970:	00005517          	auipc	a0,0x5
     974:	a3050513          	addi	a0,a0,-1488 # 53a0 <malloc+0x4ac>
     978:	4c8040ef          	jal	ra,4e40 <printf>
      exit(1);
     97c:	4505                	li	a0,1
     97e:	0b6040ef          	jal	ra,4a34 <exit>
    printf("%s: error: open small failed!\n", s);
     982:	85da                	mv	a1,s6
     984:	00005517          	auipc	a0,0x5
     988:	a4450513          	addi	a0,a0,-1468 # 53c8 <malloc+0x4d4>
     98c:	4b4040ef          	jal	ra,4e40 <printf>
    exit(1);
     990:	4505                	li	a0,1
     992:	0a2040ef          	jal	ra,4a34 <exit>
    printf("%s: read failed\n", s);
     996:	85da                	mv	a1,s6
     998:	00005517          	auipc	a0,0x5
     99c:	a5050513          	addi	a0,a0,-1456 # 53e8 <malloc+0x4f4>
     9a0:	4a0040ef          	jal	ra,4e40 <printf>
    exit(1);
     9a4:	4505                	li	a0,1
     9a6:	08e040ef          	jal	ra,4a34 <exit>
    printf("%s: unlink small failed\n", s);
     9aa:	85da                	mv	a1,s6
     9ac:	00005517          	auipc	a0,0x5
     9b0:	a5450513          	addi	a0,a0,-1452 # 5400 <malloc+0x50c>
     9b4:	48c040ef          	jal	ra,4e40 <printf>
    exit(1);
     9b8:	4505                	li	a0,1
     9ba:	07a040ef          	jal	ra,4a34 <exit>

00000000000009be <writebig>:
{
     9be:	7139                	addi	sp,sp,-64
     9c0:	fc06                	sd	ra,56(sp)
     9c2:	f822                	sd	s0,48(sp)
     9c4:	f426                	sd	s1,40(sp)
     9c6:	f04a                	sd	s2,32(sp)
     9c8:	ec4e                	sd	s3,24(sp)
     9ca:	e852                	sd	s4,16(sp)
     9cc:	e456                	sd	s5,8(sp)
     9ce:	0080                	addi	s0,sp,64
     9d0:	8aaa                	mv	s5,a0
  fd = open("big", O_CREATE|O_RDWR);
     9d2:	20200593          	li	a1,514
     9d6:	00005517          	auipc	a0,0x5
     9da:	a4a50513          	addi	a0,a0,-1462 # 5420 <malloc+0x52c>
     9de:	096040ef          	jal	ra,4a74 <open>
     9e2:	89aa                	mv	s3,a0
  for(i = 0; i < MAXFILE; i++){
     9e4:	4481                	li	s1,0
    ((int*)buf)[0] = i;
     9e6:	0000b917          	auipc	s2,0xb
     9ea:	29290913          	addi	s2,s2,658 # bc78 <buf>
  for(i = 0; i < MAXFILE; i++){
     9ee:	10c00a13          	li	s4,268
  if(fd < 0){
     9f2:	06054463          	bltz	a0,a5a <writebig+0x9c>
    ((int*)buf)[0] = i;
     9f6:	00992023          	sw	s1,0(s2)
    if(write(fd, buf, BSIZE) != BSIZE){
     9fa:	40000613          	li	a2,1024
     9fe:	85ca                	mv	a1,s2
     a00:	854e                	mv	a0,s3
     a02:	052040ef          	jal	ra,4a54 <write>
     a06:	40000793          	li	a5,1024
     a0a:	06f51263          	bne	a0,a5,a6e <writebig+0xb0>
  for(i = 0; i < MAXFILE; i++){
     a0e:	2485                	addiw	s1,s1,1
     a10:	ff4493e3          	bne	s1,s4,9f6 <writebig+0x38>
  close(fd);
     a14:	854e                	mv	a0,s3
     a16:	046040ef          	jal	ra,4a5c <close>
  fd = open("big", O_RDONLY);
     a1a:	4581                	li	a1,0
     a1c:	00005517          	auipc	a0,0x5
     a20:	a0450513          	addi	a0,a0,-1532 # 5420 <malloc+0x52c>
     a24:	050040ef          	jal	ra,4a74 <open>
     a28:	89aa                	mv	s3,a0
  n = 0;
     a2a:	4481                	li	s1,0
    i = read(fd, buf, BSIZE);
     a2c:	0000b917          	auipc	s2,0xb
     a30:	24c90913          	addi	s2,s2,588 # bc78 <buf>
  if(fd < 0){
     a34:	04054863          	bltz	a0,a84 <writebig+0xc6>
    i = read(fd, buf, BSIZE);
     a38:	40000613          	li	a2,1024
     a3c:	85ca                	mv	a1,s2
     a3e:	854e                	mv	a0,s3
     a40:	00c040ef          	jal	ra,4a4c <read>
    if(i == 0){
     a44:	c931                	beqz	a0,a98 <writebig+0xda>
    } else if(i != BSIZE){
     a46:	40000793          	li	a5,1024
     a4a:	08f51a63          	bne	a0,a5,ade <writebig+0x120>
    if(((int*)buf)[0] != n){
     a4e:	00092683          	lw	a3,0(s2)
     a52:	0a969163          	bne	a3,s1,af4 <writebig+0x136>
    n++;
     a56:	2485                	addiw	s1,s1,1
    i = read(fd, buf, BSIZE);
     a58:	b7c5                	j	a38 <writebig+0x7a>
    printf("%s: error: creat big failed!\n", s);
     a5a:	85d6                	mv	a1,s5
     a5c:	00005517          	auipc	a0,0x5
     a60:	9cc50513          	addi	a0,a0,-1588 # 5428 <malloc+0x534>
     a64:	3dc040ef          	jal	ra,4e40 <printf>
    exit(1);
     a68:	4505                	li	a0,1
     a6a:	7cb030ef          	jal	ra,4a34 <exit>
      printf("%s: error: write big file failed i=%d\n", s, i);
     a6e:	8626                	mv	a2,s1
     a70:	85d6                	mv	a1,s5
     a72:	00005517          	auipc	a0,0x5
     a76:	9d650513          	addi	a0,a0,-1578 # 5448 <malloc+0x554>
     a7a:	3c6040ef          	jal	ra,4e40 <printf>
      exit(1);
     a7e:	4505                	li	a0,1
     a80:	7b5030ef          	jal	ra,4a34 <exit>
    printf("%s: error: open big failed!\n", s);
     a84:	85d6                	mv	a1,s5
     a86:	00005517          	auipc	a0,0x5
     a8a:	9ea50513          	addi	a0,a0,-1558 # 5470 <malloc+0x57c>
     a8e:	3b2040ef          	jal	ra,4e40 <printf>
    exit(1);
     a92:	4505                	li	a0,1
     a94:	7a1030ef          	jal	ra,4a34 <exit>
      if(n != MAXFILE){
     a98:	10c00793          	li	a5,268
     a9c:	02f49663          	bne	s1,a5,ac8 <writebig+0x10a>
  close(fd);
     aa0:	854e                	mv	a0,s3
     aa2:	7bb030ef          	jal	ra,4a5c <close>
  if(unlink("big") < 0){
     aa6:	00005517          	auipc	a0,0x5
     aaa:	97a50513          	addi	a0,a0,-1670 # 5420 <malloc+0x52c>
     aae:	7d7030ef          	jal	ra,4a84 <unlink>
     ab2:	04054c63          	bltz	a0,b0a <writebig+0x14c>
}
     ab6:	70e2                	ld	ra,56(sp)
     ab8:	7442                	ld	s0,48(sp)
     aba:	74a2                	ld	s1,40(sp)
     abc:	7902                	ld	s2,32(sp)
     abe:	69e2                	ld	s3,24(sp)
     ac0:	6a42                	ld	s4,16(sp)
     ac2:	6aa2                	ld	s5,8(sp)
     ac4:	6121                	addi	sp,sp,64
     ac6:	8082                	ret
        printf("%s: read only %d blocks from big", s, n);
     ac8:	8626                	mv	a2,s1
     aca:	85d6                	mv	a1,s5
     acc:	00005517          	auipc	a0,0x5
     ad0:	9c450513          	addi	a0,a0,-1596 # 5490 <malloc+0x59c>
     ad4:	36c040ef          	jal	ra,4e40 <printf>
        exit(1);
     ad8:	4505                	li	a0,1
     ada:	75b030ef          	jal	ra,4a34 <exit>
      printf("%s: read failed %d\n", s, i);
     ade:	862a                	mv	a2,a0
     ae0:	85d6                	mv	a1,s5
     ae2:	00005517          	auipc	a0,0x5
     ae6:	9d650513          	addi	a0,a0,-1578 # 54b8 <malloc+0x5c4>
     aea:	356040ef          	jal	ra,4e40 <printf>
      exit(1);
     aee:	4505                	li	a0,1
     af0:	745030ef          	jal	ra,4a34 <exit>
      printf("%s: read content of block %d is %d\n", s,
     af4:	8626                	mv	a2,s1
     af6:	85d6                	mv	a1,s5
     af8:	00005517          	auipc	a0,0x5
     afc:	9d850513          	addi	a0,a0,-1576 # 54d0 <malloc+0x5dc>
     b00:	340040ef          	jal	ra,4e40 <printf>
      exit(1);
     b04:	4505                	li	a0,1
     b06:	72f030ef          	jal	ra,4a34 <exit>
    printf("%s: unlink big failed\n", s);
     b0a:	85d6                	mv	a1,s5
     b0c:	00005517          	auipc	a0,0x5
     b10:	9ec50513          	addi	a0,a0,-1556 # 54f8 <malloc+0x604>
     b14:	32c040ef          	jal	ra,4e40 <printf>
    exit(1);
     b18:	4505                	li	a0,1
     b1a:	71b030ef          	jal	ra,4a34 <exit>

0000000000000b1e <unlinkread>:
{
     b1e:	7179                	addi	sp,sp,-48
     b20:	f406                	sd	ra,40(sp)
     b22:	f022                	sd	s0,32(sp)
     b24:	ec26                	sd	s1,24(sp)
     b26:	e84a                	sd	s2,16(sp)
     b28:	e44e                	sd	s3,8(sp)
     b2a:	1800                	addi	s0,sp,48
     b2c:	89aa                	mv	s3,a0
  fd = open("unlinkread", O_CREATE | O_RDWR);
     b2e:	20200593          	li	a1,514
     b32:	00005517          	auipc	a0,0x5
     b36:	9de50513          	addi	a0,a0,-1570 # 5510 <malloc+0x61c>
     b3a:	73b030ef          	jal	ra,4a74 <open>
  if(fd < 0){
     b3e:	0a054f63          	bltz	a0,bfc <unlinkread+0xde>
     b42:	84aa                	mv	s1,a0
  write(fd, "hello", SZ);
     b44:	4615                	li	a2,5
     b46:	00005597          	auipc	a1,0x5
     b4a:	9fa58593          	addi	a1,a1,-1542 # 5540 <malloc+0x64c>
     b4e:	707030ef          	jal	ra,4a54 <write>
  close(fd);
     b52:	8526                	mv	a0,s1
     b54:	709030ef          	jal	ra,4a5c <close>
  fd = open("unlinkread", O_RDWR);
     b58:	4589                	li	a1,2
     b5a:	00005517          	auipc	a0,0x5
     b5e:	9b650513          	addi	a0,a0,-1610 # 5510 <malloc+0x61c>
     b62:	713030ef          	jal	ra,4a74 <open>
     b66:	84aa                	mv	s1,a0
  if(fd < 0){
     b68:	0a054463          	bltz	a0,c10 <unlinkread+0xf2>
  if(unlink("unlinkread") != 0){
     b6c:	00005517          	auipc	a0,0x5
     b70:	9a450513          	addi	a0,a0,-1628 # 5510 <malloc+0x61c>
     b74:	711030ef          	jal	ra,4a84 <unlink>
     b78:	e555                	bnez	a0,c24 <unlinkread+0x106>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
     b7a:	20200593          	li	a1,514
     b7e:	00005517          	auipc	a0,0x5
     b82:	99250513          	addi	a0,a0,-1646 # 5510 <malloc+0x61c>
     b86:	6ef030ef          	jal	ra,4a74 <open>
     b8a:	892a                	mv	s2,a0
  write(fd1, "yyy", 3);
     b8c:	460d                	li	a2,3
     b8e:	00005597          	auipc	a1,0x5
     b92:	9fa58593          	addi	a1,a1,-1542 # 5588 <malloc+0x694>
     b96:	6bf030ef          	jal	ra,4a54 <write>
  close(fd1);
     b9a:	854a                	mv	a0,s2
     b9c:	6c1030ef          	jal	ra,4a5c <close>
  if(read(fd, buf, sizeof(buf)) != SZ){
     ba0:	660d                	lui	a2,0x3
     ba2:	0000b597          	auipc	a1,0xb
     ba6:	0d658593          	addi	a1,a1,214 # bc78 <buf>
     baa:	8526                	mv	a0,s1
     bac:	6a1030ef          	jal	ra,4a4c <read>
     bb0:	4795                	li	a5,5
     bb2:	08f51363          	bne	a0,a5,c38 <unlinkread+0x11a>
  if(buf[0] != 'h'){
     bb6:	0000b717          	auipc	a4,0xb
     bba:	0c274703          	lbu	a4,194(a4) # bc78 <buf>
     bbe:	06800793          	li	a5,104
     bc2:	08f71563          	bne	a4,a5,c4c <unlinkread+0x12e>
  if(write(fd, buf, 10) != 10){
     bc6:	4629                	li	a2,10
     bc8:	0000b597          	auipc	a1,0xb
     bcc:	0b058593          	addi	a1,a1,176 # bc78 <buf>
     bd0:	8526                	mv	a0,s1
     bd2:	683030ef          	jal	ra,4a54 <write>
     bd6:	47a9                	li	a5,10
     bd8:	08f51463          	bne	a0,a5,c60 <unlinkread+0x142>
  close(fd);
     bdc:	8526                	mv	a0,s1
     bde:	67f030ef          	jal	ra,4a5c <close>
  unlink("unlinkread");
     be2:	00005517          	auipc	a0,0x5
     be6:	92e50513          	addi	a0,a0,-1746 # 5510 <malloc+0x61c>
     bea:	69b030ef          	jal	ra,4a84 <unlink>
}
     bee:	70a2                	ld	ra,40(sp)
     bf0:	7402                	ld	s0,32(sp)
     bf2:	64e2                	ld	s1,24(sp)
     bf4:	6942                	ld	s2,16(sp)
     bf6:	69a2                	ld	s3,8(sp)
     bf8:	6145                	addi	sp,sp,48
     bfa:	8082                	ret
    printf("%s: create unlinkread failed\n", s);
     bfc:	85ce                	mv	a1,s3
     bfe:	00005517          	auipc	a0,0x5
     c02:	92250513          	addi	a0,a0,-1758 # 5520 <malloc+0x62c>
     c06:	23a040ef          	jal	ra,4e40 <printf>
    exit(1);
     c0a:	4505                	li	a0,1
     c0c:	629030ef          	jal	ra,4a34 <exit>
    printf("%s: open unlinkread failed\n", s);
     c10:	85ce                	mv	a1,s3
     c12:	00005517          	auipc	a0,0x5
     c16:	93650513          	addi	a0,a0,-1738 # 5548 <malloc+0x654>
     c1a:	226040ef          	jal	ra,4e40 <printf>
    exit(1);
     c1e:	4505                	li	a0,1
     c20:	615030ef          	jal	ra,4a34 <exit>
    printf("%s: unlink unlinkread failed\n", s);
     c24:	85ce                	mv	a1,s3
     c26:	00005517          	auipc	a0,0x5
     c2a:	94250513          	addi	a0,a0,-1726 # 5568 <malloc+0x674>
     c2e:	212040ef          	jal	ra,4e40 <printf>
    exit(1);
     c32:	4505                	li	a0,1
     c34:	601030ef          	jal	ra,4a34 <exit>
    printf("%s: unlinkread read failed", s);
     c38:	85ce                	mv	a1,s3
     c3a:	00005517          	auipc	a0,0x5
     c3e:	95650513          	addi	a0,a0,-1706 # 5590 <malloc+0x69c>
     c42:	1fe040ef          	jal	ra,4e40 <printf>
    exit(1);
     c46:	4505                	li	a0,1
     c48:	5ed030ef          	jal	ra,4a34 <exit>
    printf("%s: unlinkread wrong data\n", s);
     c4c:	85ce                	mv	a1,s3
     c4e:	00005517          	auipc	a0,0x5
     c52:	96250513          	addi	a0,a0,-1694 # 55b0 <malloc+0x6bc>
     c56:	1ea040ef          	jal	ra,4e40 <printf>
    exit(1);
     c5a:	4505                	li	a0,1
     c5c:	5d9030ef          	jal	ra,4a34 <exit>
    printf("%s: unlinkread write failed\n", s);
     c60:	85ce                	mv	a1,s3
     c62:	00005517          	auipc	a0,0x5
     c66:	96e50513          	addi	a0,a0,-1682 # 55d0 <malloc+0x6dc>
     c6a:	1d6040ef          	jal	ra,4e40 <printf>
    exit(1);
     c6e:	4505                	li	a0,1
     c70:	5c5030ef          	jal	ra,4a34 <exit>

0000000000000c74 <linktest>:
{
     c74:	1101                	addi	sp,sp,-32
     c76:	ec06                	sd	ra,24(sp)
     c78:	e822                	sd	s0,16(sp)
     c7a:	e426                	sd	s1,8(sp)
     c7c:	e04a                	sd	s2,0(sp)
     c7e:	1000                	addi	s0,sp,32
     c80:	892a                	mv	s2,a0
  unlink("lf1");
     c82:	00005517          	auipc	a0,0x5
     c86:	96e50513          	addi	a0,a0,-1682 # 55f0 <malloc+0x6fc>
     c8a:	5fb030ef          	jal	ra,4a84 <unlink>
  unlink("lf2");
     c8e:	00005517          	auipc	a0,0x5
     c92:	96a50513          	addi	a0,a0,-1686 # 55f8 <malloc+0x704>
     c96:	5ef030ef          	jal	ra,4a84 <unlink>
  fd = open("lf1", O_CREATE|O_RDWR);
     c9a:	20200593          	li	a1,514
     c9e:	00005517          	auipc	a0,0x5
     ca2:	95250513          	addi	a0,a0,-1710 # 55f0 <malloc+0x6fc>
     ca6:	5cf030ef          	jal	ra,4a74 <open>
  if(fd < 0){
     caa:	0c054f63          	bltz	a0,d88 <linktest+0x114>
     cae:	84aa                	mv	s1,a0
  if(write(fd, "hello", SZ) != SZ){
     cb0:	4615                	li	a2,5
     cb2:	00005597          	auipc	a1,0x5
     cb6:	88e58593          	addi	a1,a1,-1906 # 5540 <malloc+0x64c>
     cba:	59b030ef          	jal	ra,4a54 <write>
     cbe:	4795                	li	a5,5
     cc0:	0cf51e63          	bne	a0,a5,d9c <linktest+0x128>
  close(fd);
     cc4:	8526                	mv	a0,s1
     cc6:	597030ef          	jal	ra,4a5c <close>
  if(link("lf1", "lf2") < 0){
     cca:	00005597          	auipc	a1,0x5
     cce:	92e58593          	addi	a1,a1,-1746 # 55f8 <malloc+0x704>
     cd2:	00005517          	auipc	a0,0x5
     cd6:	91e50513          	addi	a0,a0,-1762 # 55f0 <malloc+0x6fc>
     cda:	5bb030ef          	jal	ra,4a94 <link>
     cde:	0c054963          	bltz	a0,db0 <linktest+0x13c>
  unlink("lf1");
     ce2:	00005517          	auipc	a0,0x5
     ce6:	90e50513          	addi	a0,a0,-1778 # 55f0 <malloc+0x6fc>
     cea:	59b030ef          	jal	ra,4a84 <unlink>
  if(open("lf1", 0) >= 0){
     cee:	4581                	li	a1,0
     cf0:	00005517          	auipc	a0,0x5
     cf4:	90050513          	addi	a0,a0,-1792 # 55f0 <malloc+0x6fc>
     cf8:	57d030ef          	jal	ra,4a74 <open>
     cfc:	0c055463          	bgez	a0,dc4 <linktest+0x150>
  fd = open("lf2", 0);
     d00:	4581                	li	a1,0
     d02:	00005517          	auipc	a0,0x5
     d06:	8f650513          	addi	a0,a0,-1802 # 55f8 <malloc+0x704>
     d0a:	56b030ef          	jal	ra,4a74 <open>
     d0e:	84aa                	mv	s1,a0
  if(fd < 0){
     d10:	0c054463          	bltz	a0,dd8 <linktest+0x164>
  if(read(fd, buf, sizeof(buf)) != SZ){
     d14:	660d                	lui	a2,0x3
     d16:	0000b597          	auipc	a1,0xb
     d1a:	f6258593          	addi	a1,a1,-158 # bc78 <buf>
     d1e:	52f030ef          	jal	ra,4a4c <read>
     d22:	4795                	li	a5,5
     d24:	0cf51463          	bne	a0,a5,dec <linktest+0x178>
  close(fd);
     d28:	8526                	mv	a0,s1
     d2a:	533030ef          	jal	ra,4a5c <close>
  if(link("lf2", "lf2") >= 0){
     d2e:	00005597          	auipc	a1,0x5
     d32:	8ca58593          	addi	a1,a1,-1846 # 55f8 <malloc+0x704>
     d36:	852e                	mv	a0,a1
     d38:	55d030ef          	jal	ra,4a94 <link>
     d3c:	0c055263          	bgez	a0,e00 <linktest+0x18c>
  unlink("lf2");
     d40:	00005517          	auipc	a0,0x5
     d44:	8b850513          	addi	a0,a0,-1864 # 55f8 <malloc+0x704>
     d48:	53d030ef          	jal	ra,4a84 <unlink>
  if(link("lf2", "lf1") >= 0){
     d4c:	00005597          	auipc	a1,0x5
     d50:	8a458593          	addi	a1,a1,-1884 # 55f0 <malloc+0x6fc>
     d54:	00005517          	auipc	a0,0x5
     d58:	8a450513          	addi	a0,a0,-1884 # 55f8 <malloc+0x704>
     d5c:	539030ef          	jal	ra,4a94 <link>
     d60:	0a055a63          	bgez	a0,e14 <linktest+0x1a0>
  if(link(".", "lf1") >= 0){
     d64:	00005597          	auipc	a1,0x5
     d68:	88c58593          	addi	a1,a1,-1908 # 55f0 <malloc+0x6fc>
     d6c:	00005517          	auipc	a0,0x5
     d70:	99450513          	addi	a0,a0,-1644 # 5700 <malloc+0x80c>
     d74:	521030ef          	jal	ra,4a94 <link>
     d78:	0a055863          	bgez	a0,e28 <linktest+0x1b4>
}
     d7c:	60e2                	ld	ra,24(sp)
     d7e:	6442                	ld	s0,16(sp)
     d80:	64a2                	ld	s1,8(sp)
     d82:	6902                	ld	s2,0(sp)
     d84:	6105                	addi	sp,sp,32
     d86:	8082                	ret
    printf("%s: create lf1 failed\n", s);
     d88:	85ca                	mv	a1,s2
     d8a:	00005517          	auipc	a0,0x5
     d8e:	87650513          	addi	a0,a0,-1930 # 5600 <malloc+0x70c>
     d92:	0ae040ef          	jal	ra,4e40 <printf>
    exit(1);
     d96:	4505                	li	a0,1
     d98:	49d030ef          	jal	ra,4a34 <exit>
    printf("%s: write lf1 failed\n", s);
     d9c:	85ca                	mv	a1,s2
     d9e:	00005517          	auipc	a0,0x5
     da2:	87a50513          	addi	a0,a0,-1926 # 5618 <malloc+0x724>
     da6:	09a040ef          	jal	ra,4e40 <printf>
    exit(1);
     daa:	4505                	li	a0,1
     dac:	489030ef          	jal	ra,4a34 <exit>
    printf("%s: link lf1 lf2 failed\n", s);
     db0:	85ca                	mv	a1,s2
     db2:	00005517          	auipc	a0,0x5
     db6:	87e50513          	addi	a0,a0,-1922 # 5630 <malloc+0x73c>
     dba:	086040ef          	jal	ra,4e40 <printf>
    exit(1);
     dbe:	4505                	li	a0,1
     dc0:	475030ef          	jal	ra,4a34 <exit>
    printf("%s: unlinked lf1 but it is still there!\n", s);
     dc4:	85ca                	mv	a1,s2
     dc6:	00005517          	auipc	a0,0x5
     dca:	88a50513          	addi	a0,a0,-1910 # 5650 <malloc+0x75c>
     dce:	072040ef          	jal	ra,4e40 <printf>
    exit(1);
     dd2:	4505                	li	a0,1
     dd4:	461030ef          	jal	ra,4a34 <exit>
    printf("%s: open lf2 failed\n", s);
     dd8:	85ca                	mv	a1,s2
     dda:	00005517          	auipc	a0,0x5
     dde:	8a650513          	addi	a0,a0,-1882 # 5680 <malloc+0x78c>
     de2:	05e040ef          	jal	ra,4e40 <printf>
    exit(1);
     de6:	4505                	li	a0,1
     de8:	44d030ef          	jal	ra,4a34 <exit>
    printf("%s: read lf2 failed\n", s);
     dec:	85ca                	mv	a1,s2
     dee:	00005517          	auipc	a0,0x5
     df2:	8aa50513          	addi	a0,a0,-1878 # 5698 <malloc+0x7a4>
     df6:	04a040ef          	jal	ra,4e40 <printf>
    exit(1);
     dfa:	4505                	li	a0,1
     dfc:	439030ef          	jal	ra,4a34 <exit>
    printf("%s: link lf2 lf2 succeeded! oops\n", s);
     e00:	85ca                	mv	a1,s2
     e02:	00005517          	auipc	a0,0x5
     e06:	8ae50513          	addi	a0,a0,-1874 # 56b0 <malloc+0x7bc>
     e0a:	036040ef          	jal	ra,4e40 <printf>
    exit(1);
     e0e:	4505                	li	a0,1
     e10:	425030ef          	jal	ra,4a34 <exit>
    printf("%s: link non-existent succeeded! oops\n", s);
     e14:	85ca                	mv	a1,s2
     e16:	00005517          	auipc	a0,0x5
     e1a:	8c250513          	addi	a0,a0,-1854 # 56d8 <malloc+0x7e4>
     e1e:	022040ef          	jal	ra,4e40 <printf>
    exit(1);
     e22:	4505                	li	a0,1
     e24:	411030ef          	jal	ra,4a34 <exit>
    printf("%s: link . lf1 succeeded! oops\n", s);
     e28:	85ca                	mv	a1,s2
     e2a:	00005517          	auipc	a0,0x5
     e2e:	8de50513          	addi	a0,a0,-1826 # 5708 <malloc+0x814>
     e32:	00e040ef          	jal	ra,4e40 <printf>
    exit(1);
     e36:	4505                	li	a0,1
     e38:	3fd030ef          	jal	ra,4a34 <exit>

0000000000000e3c <validatetest>:
{
     e3c:	7139                	addi	sp,sp,-64
     e3e:	fc06                	sd	ra,56(sp)
     e40:	f822                	sd	s0,48(sp)
     e42:	f426                	sd	s1,40(sp)
     e44:	f04a                	sd	s2,32(sp)
     e46:	ec4e                	sd	s3,24(sp)
     e48:	e852                	sd	s4,16(sp)
     e4a:	e456                	sd	s5,8(sp)
     e4c:	e05a                	sd	s6,0(sp)
     e4e:	0080                	addi	s0,sp,64
     e50:	8b2a                	mv	s6,a0
  for(p = 0; p <= (uint)hi; p += PGSIZE){
     e52:	4481                	li	s1,0
    if(link("nosuchfile", (char*)p) != -1){
     e54:	00005997          	auipc	s3,0x5
     e58:	8d498993          	addi	s3,s3,-1836 # 5728 <malloc+0x834>
     e5c:	597d                	li	s2,-1
  for(p = 0; p <= (uint)hi; p += PGSIZE){
     e5e:	6a85                	lui	s5,0x1
     e60:	00114a37          	lui	s4,0x114
    if(link("nosuchfile", (char*)p) != -1){
     e64:	85a6                	mv	a1,s1
     e66:	854e                	mv	a0,s3
     e68:	42d030ef          	jal	ra,4a94 <link>
     e6c:	01251f63          	bne	a0,s2,e8a <validatetest+0x4e>
  for(p = 0; p <= (uint)hi; p += PGSIZE){
     e70:	94d6                	add	s1,s1,s5
     e72:	ff4499e3          	bne	s1,s4,e64 <validatetest+0x28>
}
     e76:	70e2                	ld	ra,56(sp)
     e78:	7442                	ld	s0,48(sp)
     e7a:	74a2                	ld	s1,40(sp)
     e7c:	7902                	ld	s2,32(sp)
     e7e:	69e2                	ld	s3,24(sp)
     e80:	6a42                	ld	s4,16(sp)
     e82:	6aa2                	ld	s5,8(sp)
     e84:	6b02                	ld	s6,0(sp)
     e86:	6121                	addi	sp,sp,64
     e88:	8082                	ret
      printf("%s: link should not succeed\n", s);
     e8a:	85da                	mv	a1,s6
     e8c:	00005517          	auipc	a0,0x5
     e90:	8ac50513          	addi	a0,a0,-1876 # 5738 <malloc+0x844>
     e94:	7ad030ef          	jal	ra,4e40 <printf>
      exit(1);
     e98:	4505                	li	a0,1
     e9a:	39b030ef          	jal	ra,4a34 <exit>

0000000000000e9e <bigdir>:
{
     e9e:	715d                	addi	sp,sp,-80
     ea0:	e486                	sd	ra,72(sp)
     ea2:	e0a2                	sd	s0,64(sp)
     ea4:	fc26                	sd	s1,56(sp)
     ea6:	f84a                	sd	s2,48(sp)
     ea8:	f44e                	sd	s3,40(sp)
     eaa:	f052                	sd	s4,32(sp)
     eac:	ec56                	sd	s5,24(sp)
     eae:	e85a                	sd	s6,16(sp)
     eb0:	0880                	addi	s0,sp,80
     eb2:	89aa                	mv	s3,a0
  unlink("bd");
     eb4:	00005517          	auipc	a0,0x5
     eb8:	8a450513          	addi	a0,a0,-1884 # 5758 <malloc+0x864>
     ebc:	3c9030ef          	jal	ra,4a84 <unlink>
  fd = open("bd", O_CREATE);
     ec0:	20000593          	li	a1,512
     ec4:	00005517          	auipc	a0,0x5
     ec8:	89450513          	addi	a0,a0,-1900 # 5758 <malloc+0x864>
     ecc:	3a9030ef          	jal	ra,4a74 <open>
  if(fd < 0){
     ed0:	0c054163          	bltz	a0,f92 <bigdir+0xf4>
  close(fd);
     ed4:	389030ef          	jal	ra,4a5c <close>
  for(i = 0; i < N; i++){
     ed8:	4901                	li	s2,0
    name[0] = 'x';
     eda:	07800a93          	li	s5,120
    if(link("bd", name) != 0){
     ede:	00005a17          	auipc	s4,0x5
     ee2:	87aa0a13          	addi	s4,s4,-1926 # 5758 <malloc+0x864>
  for(i = 0; i < N; i++){
     ee6:	1f400b13          	li	s6,500
    name[0] = 'x';
     eea:	fb540823          	sb	s5,-80(s0)
    name[1] = '0' + (i / 64);
     eee:	41f9571b          	sraiw	a4,s2,0x1f
     ef2:	01a7571b          	srliw	a4,a4,0x1a
     ef6:	012707bb          	addw	a5,a4,s2
     efa:	4067d69b          	sraiw	a3,a5,0x6
     efe:	0306869b          	addiw	a3,a3,48
     f02:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
     f06:	03f7f793          	andi	a5,a5,63
     f0a:	9f99                	subw	a5,a5,a4
     f0c:	0307879b          	addiw	a5,a5,48
     f10:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
     f14:	fa0409a3          	sb	zero,-77(s0)
    if(link("bd", name) != 0){
     f18:	fb040593          	addi	a1,s0,-80
     f1c:	8552                	mv	a0,s4
     f1e:	377030ef          	jal	ra,4a94 <link>
     f22:	84aa                	mv	s1,a0
     f24:	e149                	bnez	a0,fa6 <bigdir+0x108>
  for(i = 0; i < N; i++){
     f26:	2905                	addiw	s2,s2,1
     f28:	fd6911e3          	bne	s2,s6,eea <bigdir+0x4c>
  unlink("bd");
     f2c:	00005517          	auipc	a0,0x5
     f30:	82c50513          	addi	a0,a0,-2004 # 5758 <malloc+0x864>
     f34:	351030ef          	jal	ra,4a84 <unlink>
    name[0] = 'x';
     f38:	07800913          	li	s2,120
  for(i = 0; i < N; i++){
     f3c:	1f400a13          	li	s4,500
    name[0] = 'x';
     f40:	fb240823          	sb	s2,-80(s0)
    name[1] = '0' + (i / 64);
     f44:	41f4d71b          	sraiw	a4,s1,0x1f
     f48:	01a7571b          	srliw	a4,a4,0x1a
     f4c:	009707bb          	addw	a5,a4,s1
     f50:	4067d69b          	sraiw	a3,a5,0x6
     f54:	0306869b          	addiw	a3,a3,48
     f58:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
     f5c:	03f7f793          	andi	a5,a5,63
     f60:	9f99                	subw	a5,a5,a4
     f62:	0307879b          	addiw	a5,a5,48
     f66:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
     f6a:	fa0409a3          	sb	zero,-77(s0)
    if(unlink(name) != 0){
     f6e:	fb040513          	addi	a0,s0,-80
     f72:	313030ef          	jal	ra,4a84 <unlink>
     f76:	e529                	bnez	a0,fc0 <bigdir+0x122>
  for(i = 0; i < N; i++){
     f78:	2485                	addiw	s1,s1,1
     f7a:	fd4493e3          	bne	s1,s4,f40 <bigdir+0xa2>
}
     f7e:	60a6                	ld	ra,72(sp)
     f80:	6406                	ld	s0,64(sp)
     f82:	74e2                	ld	s1,56(sp)
     f84:	7942                	ld	s2,48(sp)
     f86:	79a2                	ld	s3,40(sp)
     f88:	7a02                	ld	s4,32(sp)
     f8a:	6ae2                	ld	s5,24(sp)
     f8c:	6b42                	ld	s6,16(sp)
     f8e:	6161                	addi	sp,sp,80
     f90:	8082                	ret
    printf("%s: bigdir create failed\n", s);
     f92:	85ce                	mv	a1,s3
     f94:	00004517          	auipc	a0,0x4
     f98:	7cc50513          	addi	a0,a0,1996 # 5760 <malloc+0x86c>
     f9c:	6a5030ef          	jal	ra,4e40 <printf>
    exit(1);
     fa0:	4505                	li	a0,1
     fa2:	293030ef          	jal	ra,4a34 <exit>
      printf("%s: bigdir i=%d link(bd, %s) failed\n", s, i, name);
     fa6:	fb040693          	addi	a3,s0,-80
     faa:	864a                	mv	a2,s2
     fac:	85ce                	mv	a1,s3
     fae:	00004517          	auipc	a0,0x4
     fb2:	7d250513          	addi	a0,a0,2002 # 5780 <malloc+0x88c>
     fb6:	68b030ef          	jal	ra,4e40 <printf>
      exit(1);
     fba:	4505                	li	a0,1
     fbc:	279030ef          	jal	ra,4a34 <exit>
      printf("%s: bigdir unlink failed", s);
     fc0:	85ce                	mv	a1,s3
     fc2:	00004517          	auipc	a0,0x4
     fc6:	7e650513          	addi	a0,a0,2022 # 57a8 <malloc+0x8b4>
     fca:	677030ef          	jal	ra,4e40 <printf>
      exit(1);
     fce:	4505                	li	a0,1
     fd0:	265030ef          	jal	ra,4a34 <exit>

0000000000000fd4 <pgbug>:
{
     fd4:	7179                	addi	sp,sp,-48
     fd6:	f406                	sd	ra,40(sp)
     fd8:	f022                	sd	s0,32(sp)
     fda:	ec26                	sd	s1,24(sp)
     fdc:	1800                	addi	s0,sp,48
  argv[0] = 0;
     fde:	fc043c23          	sd	zero,-40(s0)
  exec(big, argv);
     fe2:	00007497          	auipc	s1,0x7
     fe6:	01e48493          	addi	s1,s1,30 # 8000 <big>
     fea:	fd840593          	addi	a1,s0,-40
     fee:	6088                	ld	a0,0(s1)
     ff0:	27d030ef          	jal	ra,4a6c <exec>
  pipe(big);
     ff4:	6088                	ld	a0,0(s1)
     ff6:	24f030ef          	jal	ra,4a44 <pipe>
  exit(0);
     ffa:	4501                	li	a0,0
     ffc:	239030ef          	jal	ra,4a34 <exit>

0000000000001000 <badarg>:
{
    1000:	7139                	addi	sp,sp,-64
    1002:	fc06                	sd	ra,56(sp)
    1004:	f822                	sd	s0,48(sp)
    1006:	f426                	sd	s1,40(sp)
    1008:	f04a                	sd	s2,32(sp)
    100a:	ec4e                	sd	s3,24(sp)
    100c:	0080                	addi	s0,sp,64
    100e:	64b1                	lui	s1,0xc
    1010:	35048493          	addi	s1,s1,848 # c350 <buf+0x6d8>
    argv[0] = (char*)0xffffffff;
    1014:	597d                	li	s2,-1
    1016:	02095913          	srli	s2,s2,0x20
    exec("echo", argv);
    101a:	00004997          	auipc	s3,0x4
    101e:	ffe98993          	addi	s3,s3,-2 # 5018 <malloc+0x124>
    argv[0] = (char*)0xffffffff;
    1022:	fd243023          	sd	s2,-64(s0)
    argv[1] = 0;
    1026:	fc043423          	sd	zero,-56(s0)
    exec("echo", argv);
    102a:	fc040593          	addi	a1,s0,-64
    102e:	854e                	mv	a0,s3
    1030:	23d030ef          	jal	ra,4a6c <exec>
  for(int i = 0; i < 50000; i++){
    1034:	34fd                	addiw	s1,s1,-1
    1036:	f4f5                	bnez	s1,1022 <badarg+0x22>
  exit(0);
    1038:	4501                	li	a0,0
    103a:	1fb030ef          	jal	ra,4a34 <exit>

000000000000103e <copyinstr2>:
{
    103e:	7155                	addi	sp,sp,-208
    1040:	e586                	sd	ra,200(sp)
    1042:	e1a2                	sd	s0,192(sp)
    1044:	0980                	addi	s0,sp,208
  for(int i = 0; i < MAXPATH; i++)
    1046:	f6840793          	addi	a5,s0,-152
    104a:	fe840693          	addi	a3,s0,-24
    b[i] = 'x';
    104e:	07800713          	li	a4,120
    1052:	00e78023          	sb	a4,0(a5)
  for(int i = 0; i < MAXPATH; i++)
    1056:	0785                	addi	a5,a5,1
    1058:	fed79de3          	bne	a5,a3,1052 <copyinstr2+0x14>
  b[MAXPATH] = '\0';
    105c:	fe040423          	sb	zero,-24(s0)
  int ret = unlink(b);
    1060:	f6840513          	addi	a0,s0,-152
    1064:	221030ef          	jal	ra,4a84 <unlink>
  if(ret != -1){
    1068:	57fd                	li	a5,-1
    106a:	0cf51263          	bne	a0,a5,112e <copyinstr2+0xf0>
  int fd = open(b, O_CREATE | O_WRONLY);
    106e:	20100593          	li	a1,513
    1072:	f6840513          	addi	a0,s0,-152
    1076:	1ff030ef          	jal	ra,4a74 <open>
  if(fd != -1){
    107a:	57fd                	li	a5,-1
    107c:	0cf51563          	bne	a0,a5,1146 <copyinstr2+0x108>
  ret = link(b, b);
    1080:	f6840593          	addi	a1,s0,-152
    1084:	852e                	mv	a0,a1
    1086:	20f030ef          	jal	ra,4a94 <link>
  if(ret != -1){
    108a:	57fd                	li	a5,-1
    108c:	0cf51963          	bne	a0,a5,115e <copyinstr2+0x120>
  char *args[] = { "xx", 0 };
    1090:	00006797          	auipc	a5,0x6
    1094:	86878793          	addi	a5,a5,-1944 # 68f8 <malloc+0x1a04>
    1098:	f4f43c23          	sd	a5,-168(s0)
    109c:	f6043023          	sd	zero,-160(s0)
  ret = exec(b, args);
    10a0:	f5840593          	addi	a1,s0,-168
    10a4:	f6840513          	addi	a0,s0,-152
    10a8:	1c5030ef          	jal	ra,4a6c <exec>
  if(ret != -1){
    10ac:	57fd                	li	a5,-1
    10ae:	0cf51563          	bne	a0,a5,1178 <copyinstr2+0x13a>
  int pid = fork();
    10b2:	17b030ef          	jal	ra,4a2c <fork>
  if(pid < 0){
    10b6:	0c054d63          	bltz	a0,1190 <copyinstr2+0x152>
  if(pid == 0){
    10ba:	0e051863          	bnez	a0,11aa <copyinstr2+0x16c>
    10be:	00007797          	auipc	a5,0x7
    10c2:	4a278793          	addi	a5,a5,1186 # 8560 <big.0>
    10c6:	00008697          	auipc	a3,0x8
    10ca:	49a68693          	addi	a3,a3,1178 # 9560 <big.0+0x1000>
      big[i] = 'x';
    10ce:	07800713          	li	a4,120
    10d2:	00e78023          	sb	a4,0(a5)
    for(int i = 0; i < PGSIZE; i++)
    10d6:	0785                	addi	a5,a5,1
    10d8:	fed79de3          	bne	a5,a3,10d2 <copyinstr2+0x94>
    big[PGSIZE] = '\0';
    10dc:	00008797          	auipc	a5,0x8
    10e0:	48078223          	sb	zero,1156(a5) # 9560 <big.0+0x1000>
    char *args2[] = { big, big, big, 0 };
    10e4:	00006797          	auipc	a5,0x6
    10e8:	28c78793          	addi	a5,a5,652 # 7370 <malloc+0x247c>
    10ec:	6fb0                	ld	a2,88(a5)
    10ee:	73b4                	ld	a3,96(a5)
    10f0:	77b8                	ld	a4,104(a5)
    10f2:	7bbc                	ld	a5,112(a5)
    10f4:	f2c43823          	sd	a2,-208(s0)
    10f8:	f2d43c23          	sd	a3,-200(s0)
    10fc:	f4e43023          	sd	a4,-192(s0)
    1100:	f4f43423          	sd	a5,-184(s0)
    ret = exec("echo", args2);
    1104:	f3040593          	addi	a1,s0,-208
    1108:	00004517          	auipc	a0,0x4
    110c:	f1050513          	addi	a0,a0,-240 # 5018 <malloc+0x124>
    1110:	15d030ef          	jal	ra,4a6c <exec>
    if(ret != -1){
    1114:	57fd                	li	a5,-1
    1116:	08f50663          	beq	a0,a5,11a2 <copyinstr2+0x164>
      printf("exec(echo, BIG) returned %d, not -1\n", fd);
    111a:	55fd                	li	a1,-1
    111c:	00004517          	auipc	a0,0x4
    1120:	73450513          	addi	a0,a0,1844 # 5850 <malloc+0x95c>
    1124:	51d030ef          	jal	ra,4e40 <printf>
      exit(1);
    1128:	4505                	li	a0,1
    112a:	10b030ef          	jal	ra,4a34 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    112e:	862a                	mv	a2,a0
    1130:	f6840593          	addi	a1,s0,-152
    1134:	00004517          	auipc	a0,0x4
    1138:	69450513          	addi	a0,a0,1684 # 57c8 <malloc+0x8d4>
    113c:	505030ef          	jal	ra,4e40 <printf>
    exit(1);
    1140:	4505                	li	a0,1
    1142:	0f3030ef          	jal	ra,4a34 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    1146:	862a                	mv	a2,a0
    1148:	f6840593          	addi	a1,s0,-152
    114c:	00004517          	auipc	a0,0x4
    1150:	69c50513          	addi	a0,a0,1692 # 57e8 <malloc+0x8f4>
    1154:	4ed030ef          	jal	ra,4e40 <printf>
    exit(1);
    1158:	4505                	li	a0,1
    115a:	0db030ef          	jal	ra,4a34 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    115e:	86aa                	mv	a3,a0
    1160:	f6840613          	addi	a2,s0,-152
    1164:	85b2                	mv	a1,a2
    1166:	00004517          	auipc	a0,0x4
    116a:	6a250513          	addi	a0,a0,1698 # 5808 <malloc+0x914>
    116e:	4d3030ef          	jal	ra,4e40 <printf>
    exit(1);
    1172:	4505                	li	a0,1
    1174:	0c1030ef          	jal	ra,4a34 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    1178:	567d                	li	a2,-1
    117a:	f6840593          	addi	a1,s0,-152
    117e:	00004517          	auipc	a0,0x4
    1182:	6b250513          	addi	a0,a0,1714 # 5830 <malloc+0x93c>
    1186:	4bb030ef          	jal	ra,4e40 <printf>
    exit(1);
    118a:	4505                	li	a0,1
    118c:	0a9030ef          	jal	ra,4a34 <exit>
    printf("fork failed\n");
    1190:	00006517          	auipc	a0,0x6
    1194:	c8850513          	addi	a0,a0,-888 # 6e18 <malloc+0x1f24>
    1198:	4a9030ef          	jal	ra,4e40 <printf>
    exit(1);
    119c:	4505                	li	a0,1
    119e:	097030ef          	jal	ra,4a34 <exit>
    exit(747); // OK
    11a2:	2eb00513          	li	a0,747
    11a6:	08f030ef          	jal	ra,4a34 <exit>
  int st = 0;
    11aa:	f4042a23          	sw	zero,-172(s0)
  wait(&st);
    11ae:	f5440513          	addi	a0,s0,-172
    11b2:	08b030ef          	jal	ra,4a3c <wait>
  if(st != 747){
    11b6:	f5442703          	lw	a4,-172(s0)
    11ba:	2eb00793          	li	a5,747
    11be:	00f71663          	bne	a4,a5,11ca <copyinstr2+0x18c>
}
    11c2:	60ae                	ld	ra,200(sp)
    11c4:	640e                	ld	s0,192(sp)
    11c6:	6169                	addi	sp,sp,208
    11c8:	8082                	ret
    printf("exec(echo, BIG) succeeded, should have failed\n");
    11ca:	00004517          	auipc	a0,0x4
    11ce:	6ae50513          	addi	a0,a0,1710 # 5878 <malloc+0x984>
    11d2:	46f030ef          	jal	ra,4e40 <printf>
    exit(1);
    11d6:	4505                	li	a0,1
    11d8:	05d030ef          	jal	ra,4a34 <exit>

00000000000011dc <truncate3>:
{
    11dc:	7159                	addi	sp,sp,-112
    11de:	f486                	sd	ra,104(sp)
    11e0:	f0a2                	sd	s0,96(sp)
    11e2:	eca6                	sd	s1,88(sp)
    11e4:	e8ca                	sd	s2,80(sp)
    11e6:	e4ce                	sd	s3,72(sp)
    11e8:	e0d2                	sd	s4,64(sp)
    11ea:	fc56                	sd	s5,56(sp)
    11ec:	1880                	addi	s0,sp,112
    11ee:	892a                	mv	s2,a0
  close(open("truncfile", O_CREATE|O_TRUNC|O_WRONLY));
    11f0:	60100593          	li	a1,1537
    11f4:	00004517          	auipc	a0,0x4
    11f8:	e7c50513          	addi	a0,a0,-388 # 5070 <malloc+0x17c>
    11fc:	079030ef          	jal	ra,4a74 <open>
    1200:	05d030ef          	jal	ra,4a5c <close>
  pid = fork();
    1204:	029030ef          	jal	ra,4a2c <fork>
  if(pid < 0){
    1208:	06054263          	bltz	a0,126c <truncate3+0x90>
  if(pid == 0){
    120c:	ed59                	bnez	a0,12aa <truncate3+0xce>
    120e:	06400993          	li	s3,100
      int fd = open("truncfile", O_WRONLY);
    1212:	00004a17          	auipc	s4,0x4
    1216:	e5ea0a13          	addi	s4,s4,-418 # 5070 <malloc+0x17c>
      int n = write(fd, "1234567890", 10);
    121a:	00004a97          	auipc	s5,0x4
    121e:	6bea8a93          	addi	s5,s5,1726 # 58d8 <malloc+0x9e4>
      int fd = open("truncfile", O_WRONLY);
    1222:	4585                	li	a1,1
    1224:	8552                	mv	a0,s4
    1226:	04f030ef          	jal	ra,4a74 <open>
    122a:	84aa                	mv	s1,a0
      if(fd < 0){
    122c:	04054a63          	bltz	a0,1280 <truncate3+0xa4>
      int n = write(fd, "1234567890", 10);
    1230:	4629                	li	a2,10
    1232:	85d6                	mv	a1,s5
    1234:	021030ef          	jal	ra,4a54 <write>
      if(n != 10){
    1238:	47a9                	li	a5,10
    123a:	04f51d63          	bne	a0,a5,1294 <truncate3+0xb8>
      close(fd);
    123e:	8526                	mv	a0,s1
    1240:	01d030ef          	jal	ra,4a5c <close>
      fd = open("truncfile", O_RDONLY);
    1244:	4581                	li	a1,0
    1246:	8552                	mv	a0,s4
    1248:	02d030ef          	jal	ra,4a74 <open>
    124c:	84aa                	mv	s1,a0
      read(fd, buf, sizeof(buf));
    124e:	02000613          	li	a2,32
    1252:	f9840593          	addi	a1,s0,-104
    1256:	7f6030ef          	jal	ra,4a4c <read>
      close(fd);
    125a:	8526                	mv	a0,s1
    125c:	001030ef          	jal	ra,4a5c <close>
    for(int i = 0; i < 100; i++){
    1260:	39fd                	addiw	s3,s3,-1
    1262:	fc0990e3          	bnez	s3,1222 <truncate3+0x46>
    exit(0);
    1266:	4501                	li	a0,0
    1268:	7cc030ef          	jal	ra,4a34 <exit>
    printf("%s: fork failed\n", s);
    126c:	85ca                	mv	a1,s2
    126e:	00004517          	auipc	a0,0x4
    1272:	63a50513          	addi	a0,a0,1594 # 58a8 <malloc+0x9b4>
    1276:	3cb030ef          	jal	ra,4e40 <printf>
    exit(1);
    127a:	4505                	li	a0,1
    127c:	7b8030ef          	jal	ra,4a34 <exit>
        printf("%s: open failed\n", s);
    1280:	85ca                	mv	a1,s2
    1282:	00004517          	auipc	a0,0x4
    1286:	63e50513          	addi	a0,a0,1598 # 58c0 <malloc+0x9cc>
    128a:	3b7030ef          	jal	ra,4e40 <printf>
        exit(1);
    128e:	4505                	li	a0,1
    1290:	7a4030ef          	jal	ra,4a34 <exit>
        printf("%s: write got %d, expected 10\n", s, n);
    1294:	862a                	mv	a2,a0
    1296:	85ca                	mv	a1,s2
    1298:	00004517          	auipc	a0,0x4
    129c:	65050513          	addi	a0,a0,1616 # 58e8 <malloc+0x9f4>
    12a0:	3a1030ef          	jal	ra,4e40 <printf>
        exit(1);
    12a4:	4505                	li	a0,1
    12a6:	78e030ef          	jal	ra,4a34 <exit>
    12aa:	09600993          	li	s3,150
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    12ae:	00004a17          	auipc	s4,0x4
    12b2:	dc2a0a13          	addi	s4,s4,-574 # 5070 <malloc+0x17c>
    int n = write(fd, "xxx", 3);
    12b6:	00004a97          	auipc	s5,0x4
    12ba:	652a8a93          	addi	s5,s5,1618 # 5908 <malloc+0xa14>
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    12be:	60100593          	li	a1,1537
    12c2:	8552                	mv	a0,s4
    12c4:	7b0030ef          	jal	ra,4a74 <open>
    12c8:	84aa                	mv	s1,a0
    if(fd < 0){
    12ca:	02054d63          	bltz	a0,1304 <truncate3+0x128>
    int n = write(fd, "xxx", 3);
    12ce:	460d                	li	a2,3
    12d0:	85d6                	mv	a1,s5
    12d2:	782030ef          	jal	ra,4a54 <write>
    if(n != 3){
    12d6:	478d                	li	a5,3
    12d8:	04f51063          	bne	a0,a5,1318 <truncate3+0x13c>
    close(fd);
    12dc:	8526                	mv	a0,s1
    12de:	77e030ef          	jal	ra,4a5c <close>
  for(int i = 0; i < 150; i++){
    12e2:	39fd                	addiw	s3,s3,-1
    12e4:	fc099de3          	bnez	s3,12be <truncate3+0xe2>
  wait(&xstatus);
    12e8:	fbc40513          	addi	a0,s0,-68
    12ec:	750030ef          	jal	ra,4a3c <wait>
  unlink("truncfile");
    12f0:	00004517          	auipc	a0,0x4
    12f4:	d8050513          	addi	a0,a0,-640 # 5070 <malloc+0x17c>
    12f8:	78c030ef          	jal	ra,4a84 <unlink>
  exit(xstatus);
    12fc:	fbc42503          	lw	a0,-68(s0)
    1300:	734030ef          	jal	ra,4a34 <exit>
      printf("%s: open failed\n", s);
    1304:	85ca                	mv	a1,s2
    1306:	00004517          	auipc	a0,0x4
    130a:	5ba50513          	addi	a0,a0,1466 # 58c0 <malloc+0x9cc>
    130e:	333030ef          	jal	ra,4e40 <printf>
      exit(1);
    1312:	4505                	li	a0,1
    1314:	720030ef          	jal	ra,4a34 <exit>
      printf("%s: write got %d, expected 3\n", s, n);
    1318:	862a                	mv	a2,a0
    131a:	85ca                	mv	a1,s2
    131c:	00004517          	auipc	a0,0x4
    1320:	5f450513          	addi	a0,a0,1524 # 5910 <malloc+0xa1c>
    1324:	31d030ef          	jal	ra,4e40 <printf>
      exit(1);
    1328:	4505                	li	a0,1
    132a:	70a030ef          	jal	ra,4a34 <exit>

000000000000132e <exectest>:
{
    132e:	715d                	addi	sp,sp,-80
    1330:	e486                	sd	ra,72(sp)
    1332:	e0a2                	sd	s0,64(sp)
    1334:	fc26                	sd	s1,56(sp)
    1336:	f84a                	sd	s2,48(sp)
    1338:	0880                	addi	s0,sp,80
    133a:	892a                	mv	s2,a0
  char *echoargv[] = { "echo", "OK", 0 };
    133c:	00004797          	auipc	a5,0x4
    1340:	cdc78793          	addi	a5,a5,-804 # 5018 <malloc+0x124>
    1344:	fcf43023          	sd	a5,-64(s0)
    1348:	00004797          	auipc	a5,0x4
    134c:	5e878793          	addi	a5,a5,1512 # 5930 <malloc+0xa3c>
    1350:	fcf43423          	sd	a5,-56(s0)
    1354:	fc043823          	sd	zero,-48(s0)
  unlink("echo-ok");
    1358:	00004517          	auipc	a0,0x4
    135c:	5e050513          	addi	a0,a0,1504 # 5938 <malloc+0xa44>
    1360:	724030ef          	jal	ra,4a84 <unlink>
  pid = fork();
    1364:	6c8030ef          	jal	ra,4a2c <fork>
  if(pid < 0) {
    1368:	02054e63          	bltz	a0,13a4 <exectest+0x76>
    136c:	84aa                	mv	s1,a0
  if(pid == 0) {
    136e:	e92d                	bnez	a0,13e0 <exectest+0xb2>
    close(1);
    1370:	4505                	li	a0,1
    1372:	6ea030ef          	jal	ra,4a5c <close>
    fd = open("echo-ok", O_CREATE|O_WRONLY);
    1376:	20100593          	li	a1,513
    137a:	00004517          	auipc	a0,0x4
    137e:	5be50513          	addi	a0,a0,1470 # 5938 <malloc+0xa44>
    1382:	6f2030ef          	jal	ra,4a74 <open>
    if(fd < 0) {
    1386:	02054963          	bltz	a0,13b8 <exectest+0x8a>
    if(fd != 1) {
    138a:	4785                	li	a5,1
    138c:	04f50063          	beq	a0,a5,13cc <exectest+0x9e>
      printf("%s: wrong fd\n", s);
    1390:	85ca                	mv	a1,s2
    1392:	00004517          	auipc	a0,0x4
    1396:	5c650513          	addi	a0,a0,1478 # 5958 <malloc+0xa64>
    139a:	2a7030ef          	jal	ra,4e40 <printf>
      exit(1);
    139e:	4505                	li	a0,1
    13a0:	694030ef          	jal	ra,4a34 <exit>
     printf("%s: fork failed\n", s);
    13a4:	85ca                	mv	a1,s2
    13a6:	00004517          	auipc	a0,0x4
    13aa:	50250513          	addi	a0,a0,1282 # 58a8 <malloc+0x9b4>
    13ae:	293030ef          	jal	ra,4e40 <printf>
     exit(1);
    13b2:	4505                	li	a0,1
    13b4:	680030ef          	jal	ra,4a34 <exit>
      printf("%s: create failed\n", s);
    13b8:	85ca                	mv	a1,s2
    13ba:	00004517          	auipc	a0,0x4
    13be:	58650513          	addi	a0,a0,1414 # 5940 <malloc+0xa4c>
    13c2:	27f030ef          	jal	ra,4e40 <printf>
      exit(1);
    13c6:	4505                	li	a0,1
    13c8:	66c030ef          	jal	ra,4a34 <exit>
    if(exec("echo", echoargv) < 0){
    13cc:	fc040593          	addi	a1,s0,-64
    13d0:	00004517          	auipc	a0,0x4
    13d4:	c4850513          	addi	a0,a0,-952 # 5018 <malloc+0x124>
    13d8:	694030ef          	jal	ra,4a6c <exec>
    13dc:	00054d63          	bltz	a0,13f6 <exectest+0xc8>
  if (wait(&xstatus) != pid) {
    13e0:	fdc40513          	addi	a0,s0,-36
    13e4:	658030ef          	jal	ra,4a3c <wait>
    13e8:	02951163          	bne	a0,s1,140a <exectest+0xdc>
  if(xstatus != 0)
    13ec:	fdc42503          	lw	a0,-36(s0)
    13f0:	c50d                	beqz	a0,141a <exectest+0xec>
    exit(xstatus);
    13f2:	642030ef          	jal	ra,4a34 <exit>
      printf("%s: exec echo failed\n", s);
    13f6:	85ca                	mv	a1,s2
    13f8:	00004517          	auipc	a0,0x4
    13fc:	57050513          	addi	a0,a0,1392 # 5968 <malloc+0xa74>
    1400:	241030ef          	jal	ra,4e40 <printf>
      exit(1);
    1404:	4505                	li	a0,1
    1406:	62e030ef          	jal	ra,4a34 <exit>
    printf("%s: wait failed!\n", s);
    140a:	85ca                	mv	a1,s2
    140c:	00004517          	auipc	a0,0x4
    1410:	57450513          	addi	a0,a0,1396 # 5980 <malloc+0xa8c>
    1414:	22d030ef          	jal	ra,4e40 <printf>
    1418:	bfd1                	j	13ec <exectest+0xbe>
  fd = open("echo-ok", O_RDONLY);
    141a:	4581                	li	a1,0
    141c:	00004517          	auipc	a0,0x4
    1420:	51c50513          	addi	a0,a0,1308 # 5938 <malloc+0xa44>
    1424:	650030ef          	jal	ra,4a74 <open>
  if(fd < 0) {
    1428:	02054463          	bltz	a0,1450 <exectest+0x122>
  if (read(fd, buf, 2) != 2) {
    142c:	4609                	li	a2,2
    142e:	fb840593          	addi	a1,s0,-72
    1432:	61a030ef          	jal	ra,4a4c <read>
    1436:	4789                	li	a5,2
    1438:	02f50663          	beq	a0,a5,1464 <exectest+0x136>
    printf("%s: read failed\n", s);
    143c:	85ca                	mv	a1,s2
    143e:	00004517          	auipc	a0,0x4
    1442:	faa50513          	addi	a0,a0,-86 # 53e8 <malloc+0x4f4>
    1446:	1fb030ef          	jal	ra,4e40 <printf>
    exit(1);
    144a:	4505                	li	a0,1
    144c:	5e8030ef          	jal	ra,4a34 <exit>
    printf("%s: open failed\n", s);
    1450:	85ca                	mv	a1,s2
    1452:	00004517          	auipc	a0,0x4
    1456:	46e50513          	addi	a0,a0,1134 # 58c0 <malloc+0x9cc>
    145a:	1e7030ef          	jal	ra,4e40 <printf>
    exit(1);
    145e:	4505                	li	a0,1
    1460:	5d4030ef          	jal	ra,4a34 <exit>
  unlink("echo-ok");
    1464:	00004517          	auipc	a0,0x4
    1468:	4d450513          	addi	a0,a0,1236 # 5938 <malloc+0xa44>
    146c:	618030ef          	jal	ra,4a84 <unlink>
  if(buf[0] == 'O' && buf[1] == 'K')
    1470:	fb844703          	lbu	a4,-72(s0)
    1474:	04f00793          	li	a5,79
    1478:	00f71863          	bne	a4,a5,1488 <exectest+0x15a>
    147c:	fb944703          	lbu	a4,-71(s0)
    1480:	04b00793          	li	a5,75
    1484:	00f70c63          	beq	a4,a5,149c <exectest+0x16e>
    printf("%s: wrong output\n", s);
    1488:	85ca                	mv	a1,s2
    148a:	00004517          	auipc	a0,0x4
    148e:	50e50513          	addi	a0,a0,1294 # 5998 <malloc+0xaa4>
    1492:	1af030ef          	jal	ra,4e40 <printf>
    exit(1);
    1496:	4505                	li	a0,1
    1498:	59c030ef          	jal	ra,4a34 <exit>
    exit(0);
    149c:	4501                	li	a0,0
    149e:	596030ef          	jal	ra,4a34 <exit>

00000000000014a2 <pipe1>:
{
    14a2:	711d                	addi	sp,sp,-96
    14a4:	ec86                	sd	ra,88(sp)
    14a6:	e8a2                	sd	s0,80(sp)
    14a8:	e4a6                	sd	s1,72(sp)
    14aa:	e0ca                	sd	s2,64(sp)
    14ac:	fc4e                	sd	s3,56(sp)
    14ae:	f852                	sd	s4,48(sp)
    14b0:	f456                	sd	s5,40(sp)
    14b2:	f05a                	sd	s6,32(sp)
    14b4:	ec5e                	sd	s7,24(sp)
    14b6:	1080                	addi	s0,sp,96
    14b8:	892a                	mv	s2,a0
  if(pipe(fds) != 0){
    14ba:	fa840513          	addi	a0,s0,-88
    14be:	586030ef          	jal	ra,4a44 <pipe>
    14c2:	e52d                	bnez	a0,152c <pipe1+0x8a>
    14c4:	84aa                	mv	s1,a0
  pid = fork();
    14c6:	566030ef          	jal	ra,4a2c <fork>
    14ca:	8a2a                	mv	s4,a0
  if(pid == 0){
    14cc:	c935                	beqz	a0,1540 <pipe1+0x9e>
  } else if(pid > 0){
    14ce:	14a05063          	blez	a0,160e <pipe1+0x16c>
    close(fds[1]);
    14d2:	fac42503          	lw	a0,-84(s0)
    14d6:	586030ef          	jal	ra,4a5c <close>
    total = 0;
    14da:	8a26                	mv	s4,s1
    cc = 1;
    14dc:	4985                	li	s3,1
    while((n = read(fds[0], buf, cc)) > 0){
    14de:	0000aa97          	auipc	s5,0xa
    14e2:	79aa8a93          	addi	s5,s5,1946 # bc78 <buf>
      if(cc > sizeof(buf))
    14e6:	6b0d                	lui	s6,0x3
    while((n = read(fds[0], buf, cc)) > 0){
    14e8:	864e                	mv	a2,s3
    14ea:	85d6                	mv	a1,s5
    14ec:	fa842503          	lw	a0,-88(s0)
    14f0:	55c030ef          	jal	ra,4a4c <read>
    14f4:	0ea05163          	blez	a0,15d6 <pipe1+0x134>
      for(i = 0; i < n; i++){
    14f8:	0000a717          	auipc	a4,0xa
    14fc:	78070713          	addi	a4,a4,1920 # bc78 <buf>
    1500:	00a4863b          	addw	a2,s1,a0
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    1504:	00074683          	lbu	a3,0(a4)
    1508:	0ff4f793          	zext.b	a5,s1
    150c:	2485                	addiw	s1,s1,1
    150e:	0af69263          	bne	a3,a5,15b2 <pipe1+0x110>
      for(i = 0; i < n; i++){
    1512:	0705                	addi	a4,a4,1
    1514:	fec498e3          	bne	s1,a2,1504 <pipe1+0x62>
      total += n;
    1518:	00aa0a3b          	addw	s4,s4,a0
      cc = cc * 2;
    151c:	0019979b          	slliw	a5,s3,0x1
    1520:	0007899b          	sext.w	s3,a5
      if(cc > sizeof(buf))
    1524:	fd3b72e3          	bgeu	s6,s3,14e8 <pipe1+0x46>
        cc = sizeof(buf);
    1528:	89da                	mv	s3,s6
    152a:	bf7d                	j	14e8 <pipe1+0x46>
    printf("%s: pipe() failed\n", s);
    152c:	85ca                	mv	a1,s2
    152e:	00004517          	auipc	a0,0x4
    1532:	48250513          	addi	a0,a0,1154 # 59b0 <malloc+0xabc>
    1536:	10b030ef          	jal	ra,4e40 <printf>
    exit(1);
    153a:	4505                	li	a0,1
    153c:	4f8030ef          	jal	ra,4a34 <exit>
    close(fds[0]);
    1540:	fa842503          	lw	a0,-88(s0)
    1544:	518030ef          	jal	ra,4a5c <close>
    for(n = 0; n < N; n++){
    1548:	0000ab17          	auipc	s6,0xa
    154c:	730b0b13          	addi	s6,s6,1840 # bc78 <buf>
    1550:	416004bb          	negw	s1,s6
    1554:	0ff4f493          	zext.b	s1,s1
    1558:	409b0993          	addi	s3,s6,1033
      if(write(fds[1], buf, SZ) != SZ){
    155c:	8bda                	mv	s7,s6
    for(n = 0; n < N; n++){
    155e:	6a85                	lui	s5,0x1
    1560:	42da8a93          	addi	s5,s5,1069 # 142d <exectest+0xff>
{
    1564:	87da                	mv	a5,s6
        buf[i] = seq++;
    1566:	0097873b          	addw	a4,a5,s1
    156a:	00e78023          	sb	a4,0(a5)
      for(i = 0; i < SZ; i++)
    156e:	0785                	addi	a5,a5,1
    1570:	fef99be3          	bne	s3,a5,1566 <pipe1+0xc4>
        buf[i] = seq++;
    1574:	409a0a1b          	addiw	s4,s4,1033
      if(write(fds[1], buf, SZ) != SZ){
    1578:	40900613          	li	a2,1033
    157c:	85de                	mv	a1,s7
    157e:	fac42503          	lw	a0,-84(s0)
    1582:	4d2030ef          	jal	ra,4a54 <write>
    1586:	40900793          	li	a5,1033
    158a:	00f51a63          	bne	a0,a5,159e <pipe1+0xfc>
    for(n = 0; n < N; n++){
    158e:	24a5                	addiw	s1,s1,9
    1590:	0ff4f493          	zext.b	s1,s1
    1594:	fd5a18e3          	bne	s4,s5,1564 <pipe1+0xc2>
    exit(0);
    1598:	4501                	li	a0,0
    159a:	49a030ef          	jal	ra,4a34 <exit>
        printf("%s: pipe1 oops 1\n", s);
    159e:	85ca                	mv	a1,s2
    15a0:	00004517          	auipc	a0,0x4
    15a4:	42850513          	addi	a0,a0,1064 # 59c8 <malloc+0xad4>
    15a8:	099030ef          	jal	ra,4e40 <printf>
        exit(1);
    15ac:	4505                	li	a0,1
    15ae:	486030ef          	jal	ra,4a34 <exit>
          printf("%s: pipe1 oops 2\n", s);
    15b2:	85ca                	mv	a1,s2
    15b4:	00004517          	auipc	a0,0x4
    15b8:	42c50513          	addi	a0,a0,1068 # 59e0 <malloc+0xaec>
    15bc:	085030ef          	jal	ra,4e40 <printf>
}
    15c0:	60e6                	ld	ra,88(sp)
    15c2:	6446                	ld	s0,80(sp)
    15c4:	64a6                	ld	s1,72(sp)
    15c6:	6906                	ld	s2,64(sp)
    15c8:	79e2                	ld	s3,56(sp)
    15ca:	7a42                	ld	s4,48(sp)
    15cc:	7aa2                	ld	s5,40(sp)
    15ce:	7b02                	ld	s6,32(sp)
    15d0:	6be2                	ld	s7,24(sp)
    15d2:	6125                	addi	sp,sp,96
    15d4:	8082                	ret
    if(total != N * SZ){
    15d6:	6785                	lui	a5,0x1
    15d8:	42d78793          	addi	a5,a5,1069 # 142d <exectest+0xff>
    15dc:	00fa0d63          	beq	s4,a5,15f6 <pipe1+0x154>
      printf("%s: pipe1 oops 3 total %d\n", s, total);
    15e0:	8652                	mv	a2,s4
    15e2:	85ca                	mv	a1,s2
    15e4:	00004517          	auipc	a0,0x4
    15e8:	41450513          	addi	a0,a0,1044 # 59f8 <malloc+0xb04>
    15ec:	055030ef          	jal	ra,4e40 <printf>
      exit(1);
    15f0:	4505                	li	a0,1
    15f2:	442030ef          	jal	ra,4a34 <exit>
    close(fds[0]);
    15f6:	fa842503          	lw	a0,-88(s0)
    15fa:	462030ef          	jal	ra,4a5c <close>
    wait(&xstatus);
    15fe:	fa440513          	addi	a0,s0,-92
    1602:	43a030ef          	jal	ra,4a3c <wait>
    exit(xstatus);
    1606:	fa442503          	lw	a0,-92(s0)
    160a:	42a030ef          	jal	ra,4a34 <exit>
    printf("%s: fork() failed\n", s);
    160e:	85ca                	mv	a1,s2
    1610:	00004517          	auipc	a0,0x4
    1614:	40850513          	addi	a0,a0,1032 # 5a18 <malloc+0xb24>
    1618:	029030ef          	jal	ra,4e40 <printf>
    exit(1);
    161c:	4505                	li	a0,1
    161e:	416030ef          	jal	ra,4a34 <exit>

0000000000001622 <exitwait>:
{
    1622:	7139                	addi	sp,sp,-64
    1624:	fc06                	sd	ra,56(sp)
    1626:	f822                	sd	s0,48(sp)
    1628:	f426                	sd	s1,40(sp)
    162a:	f04a                	sd	s2,32(sp)
    162c:	ec4e                	sd	s3,24(sp)
    162e:	e852                	sd	s4,16(sp)
    1630:	0080                	addi	s0,sp,64
    1632:	8a2a                	mv	s4,a0
  for(i = 0; i < 100; i++){
    1634:	4901                	li	s2,0
    1636:	06400993          	li	s3,100
    pid = fork();
    163a:	3f2030ef          	jal	ra,4a2c <fork>
    163e:	84aa                	mv	s1,a0
    if(pid < 0){
    1640:	02054863          	bltz	a0,1670 <exitwait+0x4e>
    if(pid){
    1644:	c525                	beqz	a0,16ac <exitwait+0x8a>
      if(wait(&xstate) != pid){
    1646:	fcc40513          	addi	a0,s0,-52
    164a:	3f2030ef          	jal	ra,4a3c <wait>
    164e:	02951b63          	bne	a0,s1,1684 <exitwait+0x62>
      if(i != xstate) {
    1652:	fcc42783          	lw	a5,-52(s0)
    1656:	05279163          	bne	a5,s2,1698 <exitwait+0x76>
  for(i = 0; i < 100; i++){
    165a:	2905                	addiw	s2,s2,1
    165c:	fd391fe3          	bne	s2,s3,163a <exitwait+0x18>
}
    1660:	70e2                	ld	ra,56(sp)
    1662:	7442                	ld	s0,48(sp)
    1664:	74a2                	ld	s1,40(sp)
    1666:	7902                	ld	s2,32(sp)
    1668:	69e2                	ld	s3,24(sp)
    166a:	6a42                	ld	s4,16(sp)
    166c:	6121                	addi	sp,sp,64
    166e:	8082                	ret
      printf("%s: fork failed\n", s);
    1670:	85d2                	mv	a1,s4
    1672:	00004517          	auipc	a0,0x4
    1676:	23650513          	addi	a0,a0,566 # 58a8 <malloc+0x9b4>
    167a:	7c6030ef          	jal	ra,4e40 <printf>
      exit(1);
    167e:	4505                	li	a0,1
    1680:	3b4030ef          	jal	ra,4a34 <exit>
        printf("%s: wait wrong pid\n", s);
    1684:	85d2                	mv	a1,s4
    1686:	00004517          	auipc	a0,0x4
    168a:	3aa50513          	addi	a0,a0,938 # 5a30 <malloc+0xb3c>
    168e:	7b2030ef          	jal	ra,4e40 <printf>
        exit(1);
    1692:	4505                	li	a0,1
    1694:	3a0030ef          	jal	ra,4a34 <exit>
        printf("%s: wait wrong exit status\n", s);
    1698:	85d2                	mv	a1,s4
    169a:	00004517          	auipc	a0,0x4
    169e:	3ae50513          	addi	a0,a0,942 # 5a48 <malloc+0xb54>
    16a2:	79e030ef          	jal	ra,4e40 <printf>
        exit(1);
    16a6:	4505                	li	a0,1
    16a8:	38c030ef          	jal	ra,4a34 <exit>
      exit(i);
    16ac:	854a                	mv	a0,s2
    16ae:	386030ef          	jal	ra,4a34 <exit>

00000000000016b2 <twochildren>:
{
    16b2:	1101                	addi	sp,sp,-32
    16b4:	ec06                	sd	ra,24(sp)
    16b6:	e822                	sd	s0,16(sp)
    16b8:	e426                	sd	s1,8(sp)
    16ba:	e04a                	sd	s2,0(sp)
    16bc:	1000                	addi	s0,sp,32
    16be:	892a                	mv	s2,a0
    16c0:	3e800493          	li	s1,1000
    int pid1 = fork();
    16c4:	368030ef          	jal	ra,4a2c <fork>
    if(pid1 < 0){
    16c8:	02054663          	bltz	a0,16f4 <twochildren+0x42>
    if(pid1 == 0){
    16cc:	cd15                	beqz	a0,1708 <twochildren+0x56>
      int pid2 = fork();
    16ce:	35e030ef          	jal	ra,4a2c <fork>
      if(pid2 < 0){
    16d2:	02054d63          	bltz	a0,170c <twochildren+0x5a>
      if(pid2 == 0){
    16d6:	c529                	beqz	a0,1720 <twochildren+0x6e>
        wait(0);
    16d8:	4501                	li	a0,0
    16da:	362030ef          	jal	ra,4a3c <wait>
        wait(0);
    16de:	4501                	li	a0,0
    16e0:	35c030ef          	jal	ra,4a3c <wait>
  for(int i = 0; i < 1000; i++){
    16e4:	34fd                	addiw	s1,s1,-1
    16e6:	fcf9                	bnez	s1,16c4 <twochildren+0x12>
}
    16e8:	60e2                	ld	ra,24(sp)
    16ea:	6442                	ld	s0,16(sp)
    16ec:	64a2                	ld	s1,8(sp)
    16ee:	6902                	ld	s2,0(sp)
    16f0:	6105                	addi	sp,sp,32
    16f2:	8082                	ret
      printf("%s: fork failed\n", s);
    16f4:	85ca                	mv	a1,s2
    16f6:	00004517          	auipc	a0,0x4
    16fa:	1b250513          	addi	a0,a0,434 # 58a8 <malloc+0x9b4>
    16fe:	742030ef          	jal	ra,4e40 <printf>
      exit(1);
    1702:	4505                	li	a0,1
    1704:	330030ef          	jal	ra,4a34 <exit>
      exit(0);
    1708:	32c030ef          	jal	ra,4a34 <exit>
        printf("%s: fork failed\n", s);
    170c:	85ca                	mv	a1,s2
    170e:	00004517          	auipc	a0,0x4
    1712:	19a50513          	addi	a0,a0,410 # 58a8 <malloc+0x9b4>
    1716:	72a030ef          	jal	ra,4e40 <printf>
        exit(1);
    171a:	4505                	li	a0,1
    171c:	318030ef          	jal	ra,4a34 <exit>
        exit(0);
    1720:	314030ef          	jal	ra,4a34 <exit>

0000000000001724 <forkfork>:
{
    1724:	7179                	addi	sp,sp,-48
    1726:	f406                	sd	ra,40(sp)
    1728:	f022                	sd	s0,32(sp)
    172a:	ec26                	sd	s1,24(sp)
    172c:	1800                	addi	s0,sp,48
    172e:	84aa                	mv	s1,a0
    int pid = fork();
    1730:	2fc030ef          	jal	ra,4a2c <fork>
    if(pid < 0){
    1734:	02054b63          	bltz	a0,176a <forkfork+0x46>
    if(pid == 0){
    1738:	c139                	beqz	a0,177e <forkfork+0x5a>
    int pid = fork();
    173a:	2f2030ef          	jal	ra,4a2c <fork>
    if(pid < 0){
    173e:	02054663          	bltz	a0,176a <forkfork+0x46>
    if(pid == 0){
    1742:	cd15                	beqz	a0,177e <forkfork+0x5a>
    wait(&xstatus);
    1744:	fdc40513          	addi	a0,s0,-36
    1748:	2f4030ef          	jal	ra,4a3c <wait>
    if(xstatus != 0) {
    174c:	fdc42783          	lw	a5,-36(s0)
    1750:	ebb9                	bnez	a5,17a6 <forkfork+0x82>
    wait(&xstatus);
    1752:	fdc40513          	addi	a0,s0,-36
    1756:	2e6030ef          	jal	ra,4a3c <wait>
    if(xstatus != 0) {
    175a:	fdc42783          	lw	a5,-36(s0)
    175e:	e7a1                	bnez	a5,17a6 <forkfork+0x82>
}
    1760:	70a2                	ld	ra,40(sp)
    1762:	7402                	ld	s0,32(sp)
    1764:	64e2                	ld	s1,24(sp)
    1766:	6145                	addi	sp,sp,48
    1768:	8082                	ret
      printf("%s: fork failed", s);
    176a:	85a6                	mv	a1,s1
    176c:	00004517          	auipc	a0,0x4
    1770:	2fc50513          	addi	a0,a0,764 # 5a68 <malloc+0xb74>
    1774:	6cc030ef          	jal	ra,4e40 <printf>
      exit(1);
    1778:	4505                	li	a0,1
    177a:	2ba030ef          	jal	ra,4a34 <exit>
{
    177e:	0c800493          	li	s1,200
        int pid1 = fork();
    1782:	2aa030ef          	jal	ra,4a2c <fork>
        if(pid1 < 0){
    1786:	00054b63          	bltz	a0,179c <forkfork+0x78>
        if(pid1 == 0){
    178a:	cd01                	beqz	a0,17a2 <forkfork+0x7e>
        wait(0);
    178c:	4501                	li	a0,0
    178e:	2ae030ef          	jal	ra,4a3c <wait>
      for(int j = 0; j < 200; j++){
    1792:	34fd                	addiw	s1,s1,-1
    1794:	f4fd                	bnez	s1,1782 <forkfork+0x5e>
      exit(0);
    1796:	4501                	li	a0,0
    1798:	29c030ef          	jal	ra,4a34 <exit>
          exit(1);
    179c:	4505                	li	a0,1
    179e:	296030ef          	jal	ra,4a34 <exit>
          exit(0);
    17a2:	292030ef          	jal	ra,4a34 <exit>
      printf("%s: fork in child failed", s);
    17a6:	85a6                	mv	a1,s1
    17a8:	00004517          	auipc	a0,0x4
    17ac:	2d050513          	addi	a0,a0,720 # 5a78 <malloc+0xb84>
    17b0:	690030ef          	jal	ra,4e40 <printf>
      exit(1);
    17b4:	4505                	li	a0,1
    17b6:	27e030ef          	jal	ra,4a34 <exit>

00000000000017ba <reparent2>:
{
    17ba:	1101                	addi	sp,sp,-32
    17bc:	ec06                	sd	ra,24(sp)
    17be:	e822                	sd	s0,16(sp)
    17c0:	e426                	sd	s1,8(sp)
    17c2:	1000                	addi	s0,sp,32
    17c4:	32000493          	li	s1,800
    int pid1 = fork();
    17c8:	264030ef          	jal	ra,4a2c <fork>
    if(pid1 < 0){
    17cc:	00054b63          	bltz	a0,17e2 <reparent2+0x28>
    if(pid1 == 0){
    17d0:	c115                	beqz	a0,17f4 <reparent2+0x3a>
    wait(0);
    17d2:	4501                	li	a0,0
    17d4:	268030ef          	jal	ra,4a3c <wait>
  for(int i = 0; i < 800; i++){
    17d8:	34fd                	addiw	s1,s1,-1
    17da:	f4fd                	bnez	s1,17c8 <reparent2+0xe>
  exit(0);
    17dc:	4501                	li	a0,0
    17de:	256030ef          	jal	ra,4a34 <exit>
      printf("fork failed\n");
    17e2:	00005517          	auipc	a0,0x5
    17e6:	63650513          	addi	a0,a0,1590 # 6e18 <malloc+0x1f24>
    17ea:	656030ef          	jal	ra,4e40 <printf>
      exit(1);
    17ee:	4505                	li	a0,1
    17f0:	244030ef          	jal	ra,4a34 <exit>
      fork();
    17f4:	238030ef          	jal	ra,4a2c <fork>
      fork();
    17f8:	234030ef          	jal	ra,4a2c <fork>
      exit(0);
    17fc:	4501                	li	a0,0
    17fe:	236030ef          	jal	ra,4a34 <exit>

0000000000001802 <createdelete>:
{
    1802:	7175                	addi	sp,sp,-144
    1804:	e506                	sd	ra,136(sp)
    1806:	e122                	sd	s0,128(sp)
    1808:	fca6                	sd	s1,120(sp)
    180a:	f8ca                	sd	s2,112(sp)
    180c:	f4ce                	sd	s3,104(sp)
    180e:	f0d2                	sd	s4,96(sp)
    1810:	ecd6                	sd	s5,88(sp)
    1812:	e8da                	sd	s6,80(sp)
    1814:	e4de                	sd	s7,72(sp)
    1816:	e0e2                	sd	s8,64(sp)
    1818:	fc66                	sd	s9,56(sp)
    181a:	0900                	addi	s0,sp,144
    181c:	8caa                	mv	s9,a0
  for(pi = 0; pi < NCHILD; pi++){
    181e:	4901                	li	s2,0
    1820:	4991                	li	s3,4
    pid = fork();
    1822:	20a030ef          	jal	ra,4a2c <fork>
    1826:	84aa                	mv	s1,a0
    if(pid < 0){
    1828:	02054d63          	bltz	a0,1862 <createdelete+0x60>
    if(pid == 0){
    182c:	c529                	beqz	a0,1876 <createdelete+0x74>
  for(pi = 0; pi < NCHILD; pi++){
    182e:	2905                	addiw	s2,s2,1
    1830:	ff3919e3          	bne	s2,s3,1822 <createdelete+0x20>
    1834:	4491                	li	s1,4
    wait(&xstatus);
    1836:	f7c40513          	addi	a0,s0,-132
    183a:	202030ef          	jal	ra,4a3c <wait>
    if(xstatus != 0)
    183e:	f7c42903          	lw	s2,-132(s0)
    1842:	0a091e63          	bnez	s2,18fe <createdelete+0xfc>
  for(pi = 0; pi < NCHILD; pi++){
    1846:	34fd                	addiw	s1,s1,-1
    1848:	f4fd                	bnez	s1,1836 <createdelete+0x34>
  name[0] = name[1] = name[2] = 0;
    184a:	f8040123          	sb	zero,-126(s0)
    184e:	03000993          	li	s3,48
    1852:	5a7d                	li	s4,-1
    1854:	07000c13          	li	s8,112
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1858:	4b21                	li	s6,8
      if((i == 0 || i >= N/2) && fd < 0){
    185a:	4ba5                	li	s7,9
    for(pi = 0; pi < NCHILD; pi++){
    185c:	07400a93          	li	s5,116
    1860:	a20d                	j	1982 <createdelete+0x180>
      printf("%s: fork failed\n", s);
    1862:	85e6                	mv	a1,s9
    1864:	00004517          	auipc	a0,0x4
    1868:	04450513          	addi	a0,a0,68 # 58a8 <malloc+0x9b4>
    186c:	5d4030ef          	jal	ra,4e40 <printf>
      exit(1);
    1870:	4505                	li	a0,1
    1872:	1c2030ef          	jal	ra,4a34 <exit>
      name[0] = 'p' + pi;
    1876:	0709091b          	addiw	s2,s2,112
    187a:	f9240023          	sb	s2,-128(s0)
      name[2] = '\0';
    187e:	f8040123          	sb	zero,-126(s0)
      for(i = 0; i < N; i++){
    1882:	4951                	li	s2,20
    1884:	a831                	j	18a0 <createdelete+0x9e>
          printf("%s: create failed\n", s);
    1886:	85e6                	mv	a1,s9
    1888:	00004517          	auipc	a0,0x4
    188c:	0b850513          	addi	a0,a0,184 # 5940 <malloc+0xa4c>
    1890:	5b0030ef          	jal	ra,4e40 <printf>
          exit(1);
    1894:	4505                	li	a0,1
    1896:	19e030ef          	jal	ra,4a34 <exit>
      for(i = 0; i < N; i++){
    189a:	2485                	addiw	s1,s1,1
    189c:	05248e63          	beq	s1,s2,18f8 <createdelete+0xf6>
        name[1] = '0' + i;
    18a0:	0304879b          	addiw	a5,s1,48
    18a4:	f8f400a3          	sb	a5,-127(s0)
        fd = open(name, O_CREATE | O_RDWR);
    18a8:	20200593          	li	a1,514
    18ac:	f8040513          	addi	a0,s0,-128
    18b0:	1c4030ef          	jal	ra,4a74 <open>
        if(fd < 0){
    18b4:	fc0549e3          	bltz	a0,1886 <createdelete+0x84>
        close(fd);
    18b8:	1a4030ef          	jal	ra,4a5c <close>
        if(i > 0 && (i % 2 ) == 0){
    18bc:	fc905fe3          	blez	s1,189a <createdelete+0x98>
    18c0:	0014f793          	andi	a5,s1,1
    18c4:	fbf9                	bnez	a5,189a <createdelete+0x98>
          name[1] = '0' + (i / 2);
    18c6:	01f4d79b          	srliw	a5,s1,0x1f
    18ca:	9fa5                	addw	a5,a5,s1
    18cc:	4017d79b          	sraiw	a5,a5,0x1
    18d0:	0307879b          	addiw	a5,a5,48
    18d4:	f8f400a3          	sb	a5,-127(s0)
          if(unlink(name) < 0){
    18d8:	f8040513          	addi	a0,s0,-128
    18dc:	1a8030ef          	jal	ra,4a84 <unlink>
    18e0:	fa055de3          	bgez	a0,189a <createdelete+0x98>
            printf("%s: unlink failed\n", s);
    18e4:	85e6                	mv	a1,s9
    18e6:	00004517          	auipc	a0,0x4
    18ea:	1b250513          	addi	a0,a0,434 # 5a98 <malloc+0xba4>
    18ee:	552030ef          	jal	ra,4e40 <printf>
            exit(1);
    18f2:	4505                	li	a0,1
    18f4:	140030ef          	jal	ra,4a34 <exit>
      exit(0);
    18f8:	4501                	li	a0,0
    18fa:	13a030ef          	jal	ra,4a34 <exit>
      exit(1);
    18fe:	4505                	li	a0,1
    1900:	134030ef          	jal	ra,4a34 <exit>
        printf("%s: oops createdelete %s didn't exist\n", s, name);
    1904:	f8040613          	addi	a2,s0,-128
    1908:	85e6                	mv	a1,s9
    190a:	00004517          	auipc	a0,0x4
    190e:	1a650513          	addi	a0,a0,422 # 5ab0 <malloc+0xbbc>
    1912:	52e030ef          	jal	ra,4e40 <printf>
        exit(1);
    1916:	4505                	li	a0,1
    1918:	11c030ef          	jal	ra,4a34 <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    191c:	034b7d63          	bgeu	s6,s4,1956 <createdelete+0x154>
      if(fd >= 0)
    1920:	02055863          	bgez	a0,1950 <createdelete+0x14e>
    for(pi = 0; pi < NCHILD; pi++){
    1924:	2485                	addiw	s1,s1,1
    1926:	0ff4f493          	zext.b	s1,s1
    192a:	05548463          	beq	s1,s5,1972 <createdelete+0x170>
      name[0] = 'p' + pi;
    192e:	f8940023          	sb	s1,-128(s0)
      name[1] = '0' + i;
    1932:	f93400a3          	sb	s3,-127(s0)
      fd = open(name, 0);
    1936:	4581                	li	a1,0
    1938:	f8040513          	addi	a0,s0,-128
    193c:	138030ef          	jal	ra,4a74 <open>
      if((i == 0 || i >= N/2) && fd < 0){
    1940:	00090463          	beqz	s2,1948 <createdelete+0x146>
    1944:	fd2bdce3          	bge	s7,s2,191c <createdelete+0x11a>
    1948:	fa054ee3          	bltz	a0,1904 <createdelete+0x102>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    194c:	014b7763          	bgeu	s6,s4,195a <createdelete+0x158>
        close(fd);
    1950:	10c030ef          	jal	ra,4a5c <close>
    1954:	bfc1                	j	1924 <createdelete+0x122>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1956:	fc0547e3          	bltz	a0,1924 <createdelete+0x122>
        printf("%s: oops createdelete %s did exist\n", s, name);
    195a:	f8040613          	addi	a2,s0,-128
    195e:	85e6                	mv	a1,s9
    1960:	00004517          	auipc	a0,0x4
    1964:	17850513          	addi	a0,a0,376 # 5ad8 <malloc+0xbe4>
    1968:	4d8030ef          	jal	ra,4e40 <printf>
        exit(1);
    196c:	4505                	li	a0,1
    196e:	0c6030ef          	jal	ra,4a34 <exit>
  for(i = 0; i < N; i++){
    1972:	2905                	addiw	s2,s2,1
    1974:	2a05                	addiw	s4,s4,1
    1976:	2985                	addiw	s3,s3,1
    1978:	0ff9f993          	zext.b	s3,s3
    197c:	47d1                	li	a5,20
    197e:	02f90863          	beq	s2,a5,19ae <createdelete+0x1ac>
    for(pi = 0; pi < NCHILD; pi++){
    1982:	84e2                	mv	s1,s8
    1984:	b76d                	j	192e <createdelete+0x12c>
  for(i = 0; i < N; i++){
    1986:	2905                	addiw	s2,s2,1
    1988:	0ff97913          	zext.b	s2,s2
    198c:	03490a63          	beq	s2,s4,19c0 <createdelete+0x1be>
  name[0] = name[1] = name[2] = 0;
    1990:	84d6                	mv	s1,s5
      name[0] = 'p' + pi;
    1992:	f8940023          	sb	s1,-128(s0)
      name[1] = '0' + i;
    1996:	f92400a3          	sb	s2,-127(s0)
      unlink(name);
    199a:	f8040513          	addi	a0,s0,-128
    199e:	0e6030ef          	jal	ra,4a84 <unlink>
    for(pi = 0; pi < NCHILD; pi++){
    19a2:	2485                	addiw	s1,s1,1
    19a4:	0ff4f493          	zext.b	s1,s1
    19a8:	ff3495e3          	bne	s1,s3,1992 <createdelete+0x190>
    19ac:	bfe9                	j	1986 <createdelete+0x184>
    19ae:	03000913          	li	s2,48
  name[0] = name[1] = name[2] = 0;
    19b2:	07000a93          	li	s5,112
    for(pi = 0; pi < NCHILD; pi++){
    19b6:	07400993          	li	s3,116
  for(i = 0; i < N; i++){
    19ba:	04400a13          	li	s4,68
    19be:	bfc9                	j	1990 <createdelete+0x18e>
}
    19c0:	60aa                	ld	ra,136(sp)
    19c2:	640a                	ld	s0,128(sp)
    19c4:	74e6                	ld	s1,120(sp)
    19c6:	7946                	ld	s2,112(sp)
    19c8:	79a6                	ld	s3,104(sp)
    19ca:	7a06                	ld	s4,96(sp)
    19cc:	6ae6                	ld	s5,88(sp)
    19ce:	6b46                	ld	s6,80(sp)
    19d0:	6ba6                	ld	s7,72(sp)
    19d2:	6c06                	ld	s8,64(sp)
    19d4:	7ce2                	ld	s9,56(sp)
    19d6:	6149                	addi	sp,sp,144
    19d8:	8082                	ret

00000000000019da <linkunlink>:
{
    19da:	711d                	addi	sp,sp,-96
    19dc:	ec86                	sd	ra,88(sp)
    19de:	e8a2                	sd	s0,80(sp)
    19e0:	e4a6                	sd	s1,72(sp)
    19e2:	e0ca                	sd	s2,64(sp)
    19e4:	fc4e                	sd	s3,56(sp)
    19e6:	f852                	sd	s4,48(sp)
    19e8:	f456                	sd	s5,40(sp)
    19ea:	f05a                	sd	s6,32(sp)
    19ec:	ec5e                	sd	s7,24(sp)
    19ee:	e862                	sd	s8,16(sp)
    19f0:	e466                	sd	s9,8(sp)
    19f2:	1080                	addi	s0,sp,96
    19f4:	84aa                	mv	s1,a0
  unlink("x");
    19f6:	00003517          	auipc	a0,0x3
    19fa:	69250513          	addi	a0,a0,1682 # 5088 <malloc+0x194>
    19fe:	086030ef          	jal	ra,4a84 <unlink>
  pid = fork();
    1a02:	02a030ef          	jal	ra,4a2c <fork>
  if(pid < 0){
    1a06:	02054b63          	bltz	a0,1a3c <linkunlink+0x62>
    1a0a:	8c2a                	mv	s8,a0
  unsigned int x = (pid ? 1 : 97);
    1a0c:	4c85                	li	s9,1
    1a0e:	e119                	bnez	a0,1a14 <linkunlink+0x3a>
    1a10:	06100c93          	li	s9,97
    1a14:	06400493          	li	s1,100
    x = x * 1103515245 + 12345;
    1a18:	41c659b7          	lui	s3,0x41c65
    1a1c:	e6d9899b          	addiw	s3,s3,-403 # 41c64e6d <base+0x41c561f5>
    1a20:	690d                	lui	s2,0x3
    1a22:	0399091b          	addiw	s2,s2,57 # 3039 <subdir+0x4b1>
    if((x % 3) == 0){
    1a26:	4a0d                	li	s4,3
    } else if((x % 3) == 1){
    1a28:	4b05                	li	s6,1
      unlink("x");
    1a2a:	00003a97          	auipc	s5,0x3
    1a2e:	65ea8a93          	addi	s5,s5,1630 # 5088 <malloc+0x194>
      link("cat", "x");
    1a32:	00004b97          	auipc	s7,0x4
    1a36:	0ceb8b93          	addi	s7,s7,206 # 5b00 <malloc+0xc0c>
    1a3a:	a025                	j	1a62 <linkunlink+0x88>
    printf("%s: fork failed\n", s);
    1a3c:	85a6                	mv	a1,s1
    1a3e:	00004517          	auipc	a0,0x4
    1a42:	e6a50513          	addi	a0,a0,-406 # 58a8 <malloc+0x9b4>
    1a46:	3fa030ef          	jal	ra,4e40 <printf>
    exit(1);
    1a4a:	4505                	li	a0,1
    1a4c:	7e9020ef          	jal	ra,4a34 <exit>
      close(open("x", O_RDWR | O_CREATE));
    1a50:	20200593          	li	a1,514
    1a54:	8556                	mv	a0,s5
    1a56:	01e030ef          	jal	ra,4a74 <open>
    1a5a:	002030ef          	jal	ra,4a5c <close>
  for(i = 0; i < 100; i++){
    1a5e:	34fd                	addiw	s1,s1,-1
    1a60:	c48d                	beqz	s1,1a8a <linkunlink+0xb0>
    x = x * 1103515245 + 12345;
    1a62:	033c87bb          	mulw	a5,s9,s3
    1a66:	012787bb          	addw	a5,a5,s2
    1a6a:	00078c9b          	sext.w	s9,a5
    if((x % 3) == 0){
    1a6e:	0347f7bb          	remuw	a5,a5,s4
    1a72:	dff9                	beqz	a5,1a50 <linkunlink+0x76>
    } else if((x % 3) == 1){
    1a74:	01678663          	beq	a5,s6,1a80 <linkunlink+0xa6>
      unlink("x");
    1a78:	8556                	mv	a0,s5
    1a7a:	00a030ef          	jal	ra,4a84 <unlink>
    1a7e:	b7c5                	j	1a5e <linkunlink+0x84>
      link("cat", "x");
    1a80:	85d6                	mv	a1,s5
    1a82:	855e                	mv	a0,s7
    1a84:	010030ef          	jal	ra,4a94 <link>
    1a88:	bfd9                	j	1a5e <linkunlink+0x84>
  if(pid)
    1a8a:	020c0263          	beqz	s8,1aae <linkunlink+0xd4>
    wait(0);
    1a8e:	4501                	li	a0,0
    1a90:	7ad020ef          	jal	ra,4a3c <wait>
}
    1a94:	60e6                	ld	ra,88(sp)
    1a96:	6446                	ld	s0,80(sp)
    1a98:	64a6                	ld	s1,72(sp)
    1a9a:	6906                	ld	s2,64(sp)
    1a9c:	79e2                	ld	s3,56(sp)
    1a9e:	7a42                	ld	s4,48(sp)
    1aa0:	7aa2                	ld	s5,40(sp)
    1aa2:	7b02                	ld	s6,32(sp)
    1aa4:	6be2                	ld	s7,24(sp)
    1aa6:	6c42                	ld	s8,16(sp)
    1aa8:	6ca2                	ld	s9,8(sp)
    1aaa:	6125                	addi	sp,sp,96
    1aac:	8082                	ret
    exit(0);
    1aae:	4501                	li	a0,0
    1ab0:	785020ef          	jal	ra,4a34 <exit>

0000000000001ab4 <forktest>:
{
    1ab4:	7179                	addi	sp,sp,-48
    1ab6:	f406                	sd	ra,40(sp)
    1ab8:	f022                	sd	s0,32(sp)
    1aba:	ec26                	sd	s1,24(sp)
    1abc:	e84a                	sd	s2,16(sp)
    1abe:	e44e                	sd	s3,8(sp)
    1ac0:	1800                	addi	s0,sp,48
    1ac2:	89aa                	mv	s3,a0
  for(n=0; n<N; n++){
    1ac4:	4481                	li	s1,0
    1ac6:	3e800913          	li	s2,1000
    pid = fork();
    1aca:	763020ef          	jal	ra,4a2c <fork>
    if(pid < 0)
    1ace:	02054263          	bltz	a0,1af2 <forktest+0x3e>
    if(pid == 0)
    1ad2:	cd11                	beqz	a0,1aee <forktest+0x3a>
  for(n=0; n<N; n++){
    1ad4:	2485                	addiw	s1,s1,1
    1ad6:	ff249ae3          	bne	s1,s2,1aca <forktest+0x16>
    printf("%s: fork claimed to work 1000 times!\n", s);
    1ada:	85ce                	mv	a1,s3
    1adc:	00004517          	auipc	a0,0x4
    1ae0:	04450513          	addi	a0,a0,68 # 5b20 <malloc+0xc2c>
    1ae4:	35c030ef          	jal	ra,4e40 <printf>
    exit(1);
    1ae8:	4505                	li	a0,1
    1aea:	74b020ef          	jal	ra,4a34 <exit>
      exit(0);
    1aee:	747020ef          	jal	ra,4a34 <exit>
  if (n == 0) {
    1af2:	c89d                	beqz	s1,1b28 <forktest+0x74>
  if(n == N){
    1af4:	3e800793          	li	a5,1000
    1af8:	fef481e3          	beq	s1,a5,1ada <forktest+0x26>
  for(; n > 0; n--){
    1afc:	00905963          	blez	s1,1b0e <forktest+0x5a>
    if(wait(0) < 0){
    1b00:	4501                	li	a0,0
    1b02:	73b020ef          	jal	ra,4a3c <wait>
    1b06:	02054b63          	bltz	a0,1b3c <forktest+0x88>
  for(; n > 0; n--){
    1b0a:	34fd                	addiw	s1,s1,-1
    1b0c:	f8f5                	bnez	s1,1b00 <forktest+0x4c>
  if(wait(0) != -1){
    1b0e:	4501                	li	a0,0
    1b10:	72d020ef          	jal	ra,4a3c <wait>
    1b14:	57fd                	li	a5,-1
    1b16:	02f51d63          	bne	a0,a5,1b50 <forktest+0x9c>
}
    1b1a:	70a2                	ld	ra,40(sp)
    1b1c:	7402                	ld	s0,32(sp)
    1b1e:	64e2                	ld	s1,24(sp)
    1b20:	6942                	ld	s2,16(sp)
    1b22:	69a2                	ld	s3,8(sp)
    1b24:	6145                	addi	sp,sp,48
    1b26:	8082                	ret
    printf("%s: no fork at all!\n", s);
    1b28:	85ce                	mv	a1,s3
    1b2a:	00004517          	auipc	a0,0x4
    1b2e:	fde50513          	addi	a0,a0,-34 # 5b08 <malloc+0xc14>
    1b32:	30e030ef          	jal	ra,4e40 <printf>
    exit(1);
    1b36:	4505                	li	a0,1
    1b38:	6fd020ef          	jal	ra,4a34 <exit>
      printf("%s: wait stopped early\n", s);
    1b3c:	85ce                	mv	a1,s3
    1b3e:	00004517          	auipc	a0,0x4
    1b42:	00a50513          	addi	a0,a0,10 # 5b48 <malloc+0xc54>
    1b46:	2fa030ef          	jal	ra,4e40 <printf>
      exit(1);
    1b4a:	4505                	li	a0,1
    1b4c:	6e9020ef          	jal	ra,4a34 <exit>
    printf("%s: wait got too many\n", s);
    1b50:	85ce                	mv	a1,s3
    1b52:	00004517          	auipc	a0,0x4
    1b56:	00e50513          	addi	a0,a0,14 # 5b60 <malloc+0xc6c>
    1b5a:	2e6030ef          	jal	ra,4e40 <printf>
    exit(1);
    1b5e:	4505                	li	a0,1
    1b60:	6d5020ef          	jal	ra,4a34 <exit>

0000000000001b64 <kernmem>:
{
    1b64:	715d                	addi	sp,sp,-80
    1b66:	e486                	sd	ra,72(sp)
    1b68:	e0a2                	sd	s0,64(sp)
    1b6a:	fc26                	sd	s1,56(sp)
    1b6c:	f84a                	sd	s2,48(sp)
    1b6e:	f44e                	sd	s3,40(sp)
    1b70:	f052                	sd	s4,32(sp)
    1b72:	ec56                	sd	s5,24(sp)
    1b74:	0880                	addi	s0,sp,80
    1b76:	8a2a                	mv	s4,a0
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    1b78:	4485                	li	s1,1
    1b7a:	04fe                	slli	s1,s1,0x1f
    if(xstatus != -1)  // did kernel kill child?
    1b7c:	5afd                	li	s5,-1
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    1b7e:	69b1                	lui	s3,0xc
    1b80:	35098993          	addi	s3,s3,848 # c350 <buf+0x6d8>
    1b84:	1003d937          	lui	s2,0x1003d
    1b88:	090e                	slli	s2,s2,0x3
    1b8a:	48090913          	addi	s2,s2,1152 # 1003d480 <base+0x1002e808>
    pid = fork();
    1b8e:	69f020ef          	jal	ra,4a2c <fork>
    if(pid < 0){
    1b92:	02054763          	bltz	a0,1bc0 <kernmem+0x5c>
    if(pid == 0){
    1b96:	cd1d                	beqz	a0,1bd4 <kernmem+0x70>
    wait(&xstatus);
    1b98:	fbc40513          	addi	a0,s0,-68
    1b9c:	6a1020ef          	jal	ra,4a3c <wait>
    if(xstatus != -1)  // did kernel kill child?
    1ba0:	fbc42783          	lw	a5,-68(s0)
    1ba4:	05579563          	bne	a5,s5,1bee <kernmem+0x8a>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    1ba8:	94ce                	add	s1,s1,s3
    1baa:	ff2492e3          	bne	s1,s2,1b8e <kernmem+0x2a>
}
    1bae:	60a6                	ld	ra,72(sp)
    1bb0:	6406                	ld	s0,64(sp)
    1bb2:	74e2                	ld	s1,56(sp)
    1bb4:	7942                	ld	s2,48(sp)
    1bb6:	79a2                	ld	s3,40(sp)
    1bb8:	7a02                	ld	s4,32(sp)
    1bba:	6ae2                	ld	s5,24(sp)
    1bbc:	6161                	addi	sp,sp,80
    1bbe:	8082                	ret
      printf("%s: fork failed\n", s);
    1bc0:	85d2                	mv	a1,s4
    1bc2:	00004517          	auipc	a0,0x4
    1bc6:	ce650513          	addi	a0,a0,-794 # 58a8 <malloc+0x9b4>
    1bca:	276030ef          	jal	ra,4e40 <printf>
      exit(1);
    1bce:	4505                	li	a0,1
    1bd0:	665020ef          	jal	ra,4a34 <exit>
      printf("%s: oops could read %p = %x\n", s, a, *a);
    1bd4:	0004c683          	lbu	a3,0(s1)
    1bd8:	8626                	mv	a2,s1
    1bda:	85d2                	mv	a1,s4
    1bdc:	00004517          	auipc	a0,0x4
    1be0:	f9c50513          	addi	a0,a0,-100 # 5b78 <malloc+0xc84>
    1be4:	25c030ef          	jal	ra,4e40 <printf>
      exit(1);
    1be8:	4505                	li	a0,1
    1bea:	64b020ef          	jal	ra,4a34 <exit>
      exit(1);
    1bee:	4505                	li	a0,1
    1bf0:	645020ef          	jal	ra,4a34 <exit>

0000000000001bf4 <MAXVAplus>:
{
    1bf4:	7179                	addi	sp,sp,-48
    1bf6:	f406                	sd	ra,40(sp)
    1bf8:	f022                	sd	s0,32(sp)
    1bfa:	ec26                	sd	s1,24(sp)
    1bfc:	e84a                	sd	s2,16(sp)
    1bfe:	1800                	addi	s0,sp,48
  volatile uint64 a = MAXVA;
    1c00:	4785                	li	a5,1
    1c02:	179a                	slli	a5,a5,0x26
    1c04:	fcf43c23          	sd	a5,-40(s0)
  for( ; a != 0; a <<= 1){
    1c08:	fd843783          	ld	a5,-40(s0)
    1c0c:	cb85                	beqz	a5,1c3c <MAXVAplus+0x48>
    1c0e:	892a                	mv	s2,a0
    if(xstatus != -1)  // did kernel kill child?
    1c10:	54fd                	li	s1,-1
    pid = fork();
    1c12:	61b020ef          	jal	ra,4a2c <fork>
    if(pid < 0){
    1c16:	02054963          	bltz	a0,1c48 <MAXVAplus+0x54>
    if(pid == 0){
    1c1a:	c129                	beqz	a0,1c5c <MAXVAplus+0x68>
    wait(&xstatus);
    1c1c:	fd440513          	addi	a0,s0,-44
    1c20:	61d020ef          	jal	ra,4a3c <wait>
    if(xstatus != -1)  // did kernel kill child?
    1c24:	fd442783          	lw	a5,-44(s0)
    1c28:	04979c63          	bne	a5,s1,1c80 <MAXVAplus+0x8c>
  for( ; a != 0; a <<= 1){
    1c2c:	fd843783          	ld	a5,-40(s0)
    1c30:	0786                	slli	a5,a5,0x1
    1c32:	fcf43c23          	sd	a5,-40(s0)
    1c36:	fd843783          	ld	a5,-40(s0)
    1c3a:	ffe1                	bnez	a5,1c12 <MAXVAplus+0x1e>
}
    1c3c:	70a2                	ld	ra,40(sp)
    1c3e:	7402                	ld	s0,32(sp)
    1c40:	64e2                	ld	s1,24(sp)
    1c42:	6942                	ld	s2,16(sp)
    1c44:	6145                	addi	sp,sp,48
    1c46:	8082                	ret
      printf("%s: fork failed\n", s);
    1c48:	85ca                	mv	a1,s2
    1c4a:	00004517          	auipc	a0,0x4
    1c4e:	c5e50513          	addi	a0,a0,-930 # 58a8 <malloc+0x9b4>
    1c52:	1ee030ef          	jal	ra,4e40 <printf>
      exit(1);
    1c56:	4505                	li	a0,1
    1c58:	5dd020ef          	jal	ra,4a34 <exit>
      *(char*)a = 99;
    1c5c:	fd843783          	ld	a5,-40(s0)
    1c60:	06300713          	li	a4,99
    1c64:	00e78023          	sb	a4,0(a5)
      printf("%s: oops wrote %p\n", s, (void*)a);
    1c68:	fd843603          	ld	a2,-40(s0)
    1c6c:	85ca                	mv	a1,s2
    1c6e:	00004517          	auipc	a0,0x4
    1c72:	f2a50513          	addi	a0,a0,-214 # 5b98 <malloc+0xca4>
    1c76:	1ca030ef          	jal	ra,4e40 <printf>
      exit(1);
    1c7a:	4505                	li	a0,1
    1c7c:	5b9020ef          	jal	ra,4a34 <exit>
      exit(1);
    1c80:	4505                	li	a0,1
    1c82:	5b3020ef          	jal	ra,4a34 <exit>

0000000000001c86 <stacktest>:
{
    1c86:	7179                	addi	sp,sp,-48
    1c88:	f406                	sd	ra,40(sp)
    1c8a:	f022                	sd	s0,32(sp)
    1c8c:	ec26                	sd	s1,24(sp)
    1c8e:	1800                	addi	s0,sp,48
    1c90:	84aa                	mv	s1,a0
  pid = fork();
    1c92:	59b020ef          	jal	ra,4a2c <fork>
  if(pid == 0) {
    1c96:	cd11                	beqz	a0,1cb2 <stacktest+0x2c>
  } else if(pid < 0){
    1c98:	02054c63          	bltz	a0,1cd0 <stacktest+0x4a>
  wait(&xstatus);
    1c9c:	fdc40513          	addi	a0,s0,-36
    1ca0:	59d020ef          	jal	ra,4a3c <wait>
  if(xstatus == -1)  // kernel killed child?
    1ca4:	fdc42503          	lw	a0,-36(s0)
    1ca8:	57fd                	li	a5,-1
    1caa:	02f50d63          	beq	a0,a5,1ce4 <stacktest+0x5e>
    exit(xstatus);
    1cae:	587020ef          	jal	ra,4a34 <exit>

static inline uint64
r_sp()
{
  uint64 x;
  asm volatile("mv %0, sp" : "=r" (x) );
    1cb2:	870a                	mv	a4,sp
    printf("%s: stacktest: read below stack %d\n", s, *sp);
    1cb4:	77fd                	lui	a5,0xfffff
    1cb6:	97ba                	add	a5,a5,a4
    1cb8:	0007c603          	lbu	a2,0(a5) # fffffffffffff000 <base+0xffffffffffff0388>
    1cbc:	85a6                	mv	a1,s1
    1cbe:	00004517          	auipc	a0,0x4
    1cc2:	ef250513          	addi	a0,a0,-270 # 5bb0 <malloc+0xcbc>
    1cc6:	17a030ef          	jal	ra,4e40 <printf>
    exit(1);
    1cca:	4505                	li	a0,1
    1ccc:	569020ef          	jal	ra,4a34 <exit>
    printf("%s: fork failed\n", s);
    1cd0:	85a6                	mv	a1,s1
    1cd2:	00004517          	auipc	a0,0x4
    1cd6:	bd650513          	addi	a0,a0,-1066 # 58a8 <malloc+0x9b4>
    1cda:	166030ef          	jal	ra,4e40 <printf>
    exit(1);
    1cde:	4505                	li	a0,1
    1ce0:	555020ef          	jal	ra,4a34 <exit>
    exit(0);
    1ce4:	4501                	li	a0,0
    1ce6:	54f020ef          	jal	ra,4a34 <exit>

0000000000001cea <nowrite>:
{
    1cea:	7159                	addi	sp,sp,-112
    1cec:	f486                	sd	ra,104(sp)
    1cee:	f0a2                	sd	s0,96(sp)
    1cf0:	eca6                	sd	s1,88(sp)
    1cf2:	e8ca                	sd	s2,80(sp)
    1cf4:	e4ce                	sd	s3,72(sp)
    1cf6:	1880                	addi	s0,sp,112
    1cf8:	89aa                	mv	s3,a0
  uint64 addrs[] = { 0, 0x80000000LL, 0x3fffffe000, 0x3ffffff000, 0x4000000000,
    1cfa:	00005797          	auipc	a5,0x5
    1cfe:	67678793          	addi	a5,a5,1654 # 7370 <malloc+0x247c>
    1d02:	7788                	ld	a0,40(a5)
    1d04:	7b8c                	ld	a1,48(a5)
    1d06:	7f90                	ld	a2,56(a5)
    1d08:	63b4                	ld	a3,64(a5)
    1d0a:	67b8                	ld	a4,72(a5)
    1d0c:	6bbc                	ld	a5,80(a5)
    1d0e:	f8a43c23          	sd	a0,-104(s0)
    1d12:	fab43023          	sd	a1,-96(s0)
    1d16:	fac43423          	sd	a2,-88(s0)
    1d1a:	fad43823          	sd	a3,-80(s0)
    1d1e:	fae43c23          	sd	a4,-72(s0)
    1d22:	fcf43023          	sd	a5,-64(s0)
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
    1d26:	4481                	li	s1,0
    1d28:	4919                	li	s2,6
    pid = fork();
    1d2a:	503020ef          	jal	ra,4a2c <fork>
    if(pid == 0) {
    1d2e:	c105                	beqz	a0,1d4e <nowrite+0x64>
    } else if(pid < 0){
    1d30:	04054263          	bltz	a0,1d74 <nowrite+0x8a>
    wait(&xstatus);
    1d34:	fcc40513          	addi	a0,s0,-52
    1d38:	505020ef          	jal	ra,4a3c <wait>
    if(xstatus == 0){
    1d3c:	fcc42783          	lw	a5,-52(s0)
    1d40:	c7a1                	beqz	a5,1d88 <nowrite+0x9e>
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
    1d42:	2485                	addiw	s1,s1,1
    1d44:	ff2493e3          	bne	s1,s2,1d2a <nowrite+0x40>
  exit(0);
    1d48:	4501                	li	a0,0
    1d4a:	4eb020ef          	jal	ra,4a34 <exit>
      volatile int *addr = (int *) addrs[ai];
    1d4e:	048e                	slli	s1,s1,0x3
    1d50:	fd048793          	addi	a5,s1,-48
    1d54:	008784b3          	add	s1,a5,s0
    1d58:	fc84b603          	ld	a2,-56(s1)
      *addr = 10;
    1d5c:	47a9                	li	a5,10
    1d5e:	c21c                	sw	a5,0(a2)
      printf("%s: write to %p did not fail!\n", s, addr);
    1d60:	85ce                	mv	a1,s3
    1d62:	00004517          	auipc	a0,0x4
    1d66:	e7650513          	addi	a0,a0,-394 # 5bd8 <malloc+0xce4>
    1d6a:	0d6030ef          	jal	ra,4e40 <printf>
      exit(0);
    1d6e:	4501                	li	a0,0
    1d70:	4c5020ef          	jal	ra,4a34 <exit>
      printf("%s: fork failed\n", s);
    1d74:	85ce                	mv	a1,s3
    1d76:	00004517          	auipc	a0,0x4
    1d7a:	b3250513          	addi	a0,a0,-1230 # 58a8 <malloc+0x9b4>
    1d7e:	0c2030ef          	jal	ra,4e40 <printf>
      exit(1);
    1d82:	4505                	li	a0,1
    1d84:	4b1020ef          	jal	ra,4a34 <exit>
      exit(1);
    1d88:	4505                	li	a0,1
    1d8a:	4ab020ef          	jal	ra,4a34 <exit>

0000000000001d8e <manywrites>:
{
    1d8e:	711d                	addi	sp,sp,-96
    1d90:	ec86                	sd	ra,88(sp)
    1d92:	e8a2                	sd	s0,80(sp)
    1d94:	e4a6                	sd	s1,72(sp)
    1d96:	e0ca                	sd	s2,64(sp)
    1d98:	fc4e                	sd	s3,56(sp)
    1d9a:	f852                	sd	s4,48(sp)
    1d9c:	f456                	sd	s5,40(sp)
    1d9e:	f05a                	sd	s6,32(sp)
    1da0:	ec5e                	sd	s7,24(sp)
    1da2:	1080                	addi	s0,sp,96
    1da4:	8aaa                	mv	s5,a0
  for(int ci = 0; ci < nchildren; ci++){
    1da6:	4981                	li	s3,0
    1da8:	4911                	li	s2,4
    int pid = fork();
    1daa:	483020ef          	jal	ra,4a2c <fork>
    1dae:	84aa                	mv	s1,a0
    if(pid < 0){
    1db0:	02054563          	bltz	a0,1dda <manywrites+0x4c>
    if(pid == 0){
    1db4:	cd05                	beqz	a0,1dec <manywrites+0x5e>
  for(int ci = 0; ci < nchildren; ci++){
    1db6:	2985                	addiw	s3,s3,1
    1db8:	ff2999e3          	bne	s3,s2,1daa <manywrites+0x1c>
    1dbc:	4491                	li	s1,4
    int st = 0;
    1dbe:	fa042423          	sw	zero,-88(s0)
    wait(&st);
    1dc2:	fa840513          	addi	a0,s0,-88
    1dc6:	477020ef          	jal	ra,4a3c <wait>
    if(st != 0)
    1dca:	fa842503          	lw	a0,-88(s0)
    1dce:	e169                	bnez	a0,1e90 <manywrites+0x102>
  for(int ci = 0; ci < nchildren; ci++){
    1dd0:	34fd                	addiw	s1,s1,-1
    1dd2:	f4f5                	bnez	s1,1dbe <manywrites+0x30>
  exit(0);
    1dd4:	4501                	li	a0,0
    1dd6:	45f020ef          	jal	ra,4a34 <exit>
      printf("fork failed\n");
    1dda:	00005517          	auipc	a0,0x5
    1dde:	03e50513          	addi	a0,a0,62 # 6e18 <malloc+0x1f24>
    1de2:	05e030ef          	jal	ra,4e40 <printf>
      exit(1);
    1de6:	4505                	li	a0,1
    1de8:	44d020ef          	jal	ra,4a34 <exit>
      name[0] = 'b';
    1dec:	06200793          	li	a5,98
    1df0:	faf40423          	sb	a5,-88(s0)
      name[1] = 'a' + ci;
    1df4:	0619879b          	addiw	a5,s3,97
    1df8:	faf404a3          	sb	a5,-87(s0)
      name[2] = '\0';
    1dfc:	fa040523          	sb	zero,-86(s0)
      unlink(name);
    1e00:	fa840513          	addi	a0,s0,-88
    1e04:	481020ef          	jal	ra,4a84 <unlink>
    1e08:	4bf9                	li	s7,30
          int cc = write(fd, buf, sz);
    1e0a:	0000ab17          	auipc	s6,0xa
    1e0e:	e6eb0b13          	addi	s6,s6,-402 # bc78 <buf>
        for(int i = 0; i < ci+1; i++){
    1e12:	8a26                	mv	s4,s1
    1e14:	0209c863          	bltz	s3,1e44 <manywrites+0xb6>
          int fd = open(name, O_CREATE | O_RDWR);
    1e18:	20200593          	li	a1,514
    1e1c:	fa840513          	addi	a0,s0,-88
    1e20:	455020ef          	jal	ra,4a74 <open>
    1e24:	892a                	mv	s2,a0
          if(fd < 0){
    1e26:	02054d63          	bltz	a0,1e60 <manywrites+0xd2>
          int cc = write(fd, buf, sz);
    1e2a:	660d                	lui	a2,0x3
    1e2c:	85da                	mv	a1,s6
    1e2e:	427020ef          	jal	ra,4a54 <write>
          if(cc != sz){
    1e32:	678d                	lui	a5,0x3
    1e34:	04f51263          	bne	a0,a5,1e78 <manywrites+0xea>
          close(fd);
    1e38:	854a                	mv	a0,s2
    1e3a:	423020ef          	jal	ra,4a5c <close>
        for(int i = 0; i < ci+1; i++){
    1e3e:	2a05                	addiw	s4,s4,1
    1e40:	fd49dce3          	bge	s3,s4,1e18 <manywrites+0x8a>
        unlink(name);
    1e44:	fa840513          	addi	a0,s0,-88
    1e48:	43d020ef          	jal	ra,4a84 <unlink>
      for(int iters = 0; iters < howmany; iters++){
    1e4c:	3bfd                	addiw	s7,s7,-1
    1e4e:	fc0b92e3          	bnez	s7,1e12 <manywrites+0x84>
      unlink(name);
    1e52:	fa840513          	addi	a0,s0,-88
    1e56:	42f020ef          	jal	ra,4a84 <unlink>
      exit(0);
    1e5a:	4501                	li	a0,0
    1e5c:	3d9020ef          	jal	ra,4a34 <exit>
            printf("%s: cannot create %s\n", s, name);
    1e60:	fa840613          	addi	a2,s0,-88
    1e64:	85d6                	mv	a1,s5
    1e66:	00004517          	auipc	a0,0x4
    1e6a:	d9250513          	addi	a0,a0,-622 # 5bf8 <malloc+0xd04>
    1e6e:	7d3020ef          	jal	ra,4e40 <printf>
            exit(1);
    1e72:	4505                	li	a0,1
    1e74:	3c1020ef          	jal	ra,4a34 <exit>
            printf("%s: write(%d) ret %d\n", s, sz, cc);
    1e78:	86aa                	mv	a3,a0
    1e7a:	660d                	lui	a2,0x3
    1e7c:	85d6                	mv	a1,s5
    1e7e:	00003517          	auipc	a0,0x3
    1e82:	26a50513          	addi	a0,a0,618 # 50e8 <malloc+0x1f4>
    1e86:	7bb020ef          	jal	ra,4e40 <printf>
            exit(1);
    1e8a:	4505                	li	a0,1
    1e8c:	3a9020ef          	jal	ra,4a34 <exit>
      exit(st);
    1e90:	3a5020ef          	jal	ra,4a34 <exit>

0000000000001e94 <copyinstr3>:
{
    1e94:	7179                	addi	sp,sp,-48
    1e96:	f406                	sd	ra,40(sp)
    1e98:	f022                	sd	s0,32(sp)
    1e9a:	ec26                	sd	s1,24(sp)
    1e9c:	1800                	addi	s0,sp,48
  sbrk(8192);
    1e9e:	6509                	lui	a0,0x2
    1ea0:	41d020ef          	jal	ra,4abc <sbrk>
  uint64 top = (uint64) sbrk(0);
    1ea4:	4501                	li	a0,0
    1ea6:	417020ef          	jal	ra,4abc <sbrk>
  if((top % PGSIZE) != 0){
    1eaa:	03451793          	slli	a5,a0,0x34
    1eae:	e7bd                	bnez	a5,1f1c <copyinstr3+0x88>
  top = (uint64) sbrk(0);
    1eb0:	4501                	li	a0,0
    1eb2:	40b020ef          	jal	ra,4abc <sbrk>
  if(top % PGSIZE){
    1eb6:	03451793          	slli	a5,a0,0x34
    1eba:	ebad                	bnez	a5,1f2c <copyinstr3+0x98>
  char *b = (char *) (top - 1);
    1ebc:	fff50493          	addi	s1,a0,-1 # 1fff <rwsbrk+0x67>
  *b = 'x';
    1ec0:	07800793          	li	a5,120
    1ec4:	fef50fa3          	sb	a5,-1(a0)
  int ret = unlink(b);
    1ec8:	8526                	mv	a0,s1
    1eca:	3bb020ef          	jal	ra,4a84 <unlink>
  if(ret != -1){
    1ece:	57fd                	li	a5,-1
    1ed0:	06f51763          	bne	a0,a5,1f3e <copyinstr3+0xaa>
  int fd = open(b, O_CREATE | O_WRONLY);
    1ed4:	20100593          	li	a1,513
    1ed8:	8526                	mv	a0,s1
    1eda:	39b020ef          	jal	ra,4a74 <open>
  if(fd != -1){
    1ede:	57fd                	li	a5,-1
    1ee0:	06f51a63          	bne	a0,a5,1f54 <copyinstr3+0xc0>
  ret = link(b, b);
    1ee4:	85a6                	mv	a1,s1
    1ee6:	8526                	mv	a0,s1
    1ee8:	3ad020ef          	jal	ra,4a94 <link>
  if(ret != -1){
    1eec:	57fd                	li	a5,-1
    1eee:	06f51e63          	bne	a0,a5,1f6a <copyinstr3+0xd6>
  char *args[] = { "xx", 0 };
    1ef2:	00005797          	auipc	a5,0x5
    1ef6:	a0678793          	addi	a5,a5,-1530 # 68f8 <malloc+0x1a04>
    1efa:	fcf43823          	sd	a5,-48(s0)
    1efe:	fc043c23          	sd	zero,-40(s0)
  ret = exec(b, args);
    1f02:	fd040593          	addi	a1,s0,-48
    1f06:	8526                	mv	a0,s1
    1f08:	365020ef          	jal	ra,4a6c <exec>
  if(ret != -1){
    1f0c:	57fd                	li	a5,-1
    1f0e:	06f51a63          	bne	a0,a5,1f82 <copyinstr3+0xee>
}
    1f12:	70a2                	ld	ra,40(sp)
    1f14:	7402                	ld	s0,32(sp)
    1f16:	64e2                	ld	s1,24(sp)
    1f18:	6145                	addi	sp,sp,48
    1f1a:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
    1f1c:	0347d513          	srli	a0,a5,0x34
    1f20:	6785                	lui	a5,0x1
    1f22:	40a7853b          	subw	a0,a5,a0
    1f26:	397020ef          	jal	ra,4abc <sbrk>
    1f2a:	b759                	j	1eb0 <copyinstr3+0x1c>
    printf("oops\n");
    1f2c:	00004517          	auipc	a0,0x4
    1f30:	ce450513          	addi	a0,a0,-796 # 5c10 <malloc+0xd1c>
    1f34:	70d020ef          	jal	ra,4e40 <printf>
    exit(1);
    1f38:	4505                	li	a0,1
    1f3a:	2fb020ef          	jal	ra,4a34 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    1f3e:	862a                	mv	a2,a0
    1f40:	85a6                	mv	a1,s1
    1f42:	00004517          	auipc	a0,0x4
    1f46:	88650513          	addi	a0,a0,-1914 # 57c8 <malloc+0x8d4>
    1f4a:	6f7020ef          	jal	ra,4e40 <printf>
    exit(1);
    1f4e:	4505                	li	a0,1
    1f50:	2e5020ef          	jal	ra,4a34 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    1f54:	862a                	mv	a2,a0
    1f56:	85a6                	mv	a1,s1
    1f58:	00004517          	auipc	a0,0x4
    1f5c:	89050513          	addi	a0,a0,-1904 # 57e8 <malloc+0x8f4>
    1f60:	6e1020ef          	jal	ra,4e40 <printf>
    exit(1);
    1f64:	4505                	li	a0,1
    1f66:	2cf020ef          	jal	ra,4a34 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    1f6a:	86aa                	mv	a3,a0
    1f6c:	8626                	mv	a2,s1
    1f6e:	85a6                	mv	a1,s1
    1f70:	00004517          	auipc	a0,0x4
    1f74:	89850513          	addi	a0,a0,-1896 # 5808 <malloc+0x914>
    1f78:	6c9020ef          	jal	ra,4e40 <printf>
    exit(1);
    1f7c:	4505                	li	a0,1
    1f7e:	2b7020ef          	jal	ra,4a34 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    1f82:	567d                	li	a2,-1
    1f84:	85a6                	mv	a1,s1
    1f86:	00004517          	auipc	a0,0x4
    1f8a:	8aa50513          	addi	a0,a0,-1878 # 5830 <malloc+0x93c>
    1f8e:	6b3020ef          	jal	ra,4e40 <printf>
    exit(1);
    1f92:	4505                	li	a0,1
    1f94:	2a1020ef          	jal	ra,4a34 <exit>

0000000000001f98 <rwsbrk>:
{
    1f98:	1101                	addi	sp,sp,-32
    1f9a:	ec06                	sd	ra,24(sp)
    1f9c:	e822                	sd	s0,16(sp)
    1f9e:	e426                	sd	s1,8(sp)
    1fa0:	e04a                	sd	s2,0(sp)
    1fa2:	1000                	addi	s0,sp,32
  uint64 a = (uint64) sbrk(8192);
    1fa4:	6509                	lui	a0,0x2
    1fa6:	317020ef          	jal	ra,4abc <sbrk>
  if(a == 0xffffffffffffffffLL) {
    1faa:	57fd                	li	a5,-1
    1fac:	04f50863          	beq	a0,a5,1ffc <rwsbrk+0x64>
    1fb0:	84aa                	mv	s1,a0
  if ((uint64) sbrk(-8192) ==  0xffffffffffffffffLL) {
    1fb2:	7579                	lui	a0,0xffffe
    1fb4:	309020ef          	jal	ra,4abc <sbrk>
    1fb8:	57fd                	li	a5,-1
    1fba:	04f50a63          	beq	a0,a5,200e <rwsbrk+0x76>
  fd = open("rwsbrk", O_CREATE|O_WRONLY);
    1fbe:	20100593          	li	a1,513
    1fc2:	00004517          	auipc	a0,0x4
    1fc6:	c8e50513          	addi	a0,a0,-882 # 5c50 <malloc+0xd5c>
    1fca:	2ab020ef          	jal	ra,4a74 <open>
    1fce:	892a                	mv	s2,a0
  if(fd < 0){
    1fd0:	04054863          	bltz	a0,2020 <rwsbrk+0x88>
  n = write(fd, (void*)(a+4096), 1024);
    1fd4:	6785                	lui	a5,0x1
    1fd6:	94be                	add	s1,s1,a5
    1fd8:	40000613          	li	a2,1024
    1fdc:	85a6                	mv	a1,s1
    1fde:	277020ef          	jal	ra,4a54 <write>
    1fe2:	862a                	mv	a2,a0
  if(n >= 0){
    1fe4:	04054763          	bltz	a0,2032 <rwsbrk+0x9a>
    printf("write(fd, %p, 1024) returned %d, not -1\n", (void*)a+4096, n);
    1fe8:	85a6                	mv	a1,s1
    1fea:	00004517          	auipc	a0,0x4
    1fee:	c8650513          	addi	a0,a0,-890 # 5c70 <malloc+0xd7c>
    1ff2:	64f020ef          	jal	ra,4e40 <printf>
    exit(1);
    1ff6:	4505                	li	a0,1
    1ff8:	23d020ef          	jal	ra,4a34 <exit>
    printf("sbrk(rwsbrk) failed\n");
    1ffc:	00004517          	auipc	a0,0x4
    2000:	c1c50513          	addi	a0,a0,-996 # 5c18 <malloc+0xd24>
    2004:	63d020ef          	jal	ra,4e40 <printf>
    exit(1);
    2008:	4505                	li	a0,1
    200a:	22b020ef          	jal	ra,4a34 <exit>
    printf("sbrk(rwsbrk) shrink failed\n");
    200e:	00004517          	auipc	a0,0x4
    2012:	c2250513          	addi	a0,a0,-990 # 5c30 <malloc+0xd3c>
    2016:	62b020ef          	jal	ra,4e40 <printf>
    exit(1);
    201a:	4505                	li	a0,1
    201c:	219020ef          	jal	ra,4a34 <exit>
    printf("open(rwsbrk) failed\n");
    2020:	00004517          	auipc	a0,0x4
    2024:	c3850513          	addi	a0,a0,-968 # 5c58 <malloc+0xd64>
    2028:	619020ef          	jal	ra,4e40 <printf>
    exit(1);
    202c:	4505                	li	a0,1
    202e:	207020ef          	jal	ra,4a34 <exit>
  close(fd);
    2032:	854a                	mv	a0,s2
    2034:	229020ef          	jal	ra,4a5c <close>
  unlink("rwsbrk");
    2038:	00004517          	auipc	a0,0x4
    203c:	c1850513          	addi	a0,a0,-1000 # 5c50 <malloc+0xd5c>
    2040:	245020ef          	jal	ra,4a84 <unlink>
  fd = open("README", O_RDONLY);
    2044:	4581                	li	a1,0
    2046:	00003517          	auipc	a0,0x3
    204a:	1aa50513          	addi	a0,a0,426 # 51f0 <malloc+0x2fc>
    204e:	227020ef          	jal	ra,4a74 <open>
    2052:	892a                	mv	s2,a0
  if(fd < 0){
    2054:	02054363          	bltz	a0,207a <rwsbrk+0xe2>
  n = read(fd, (void*)(a+4096), 10);
    2058:	4629                	li	a2,10
    205a:	85a6                	mv	a1,s1
    205c:	1f1020ef          	jal	ra,4a4c <read>
    2060:	862a                	mv	a2,a0
  if(n >= 0){
    2062:	02054563          	bltz	a0,208c <rwsbrk+0xf4>
    printf("read(fd, %p, 10) returned %d, not -1\n", (void*)a+4096, n);
    2066:	85a6                	mv	a1,s1
    2068:	00004517          	auipc	a0,0x4
    206c:	c3850513          	addi	a0,a0,-968 # 5ca0 <malloc+0xdac>
    2070:	5d1020ef          	jal	ra,4e40 <printf>
    exit(1);
    2074:	4505                	li	a0,1
    2076:	1bf020ef          	jal	ra,4a34 <exit>
    printf("open(rwsbrk) failed\n");
    207a:	00004517          	auipc	a0,0x4
    207e:	bde50513          	addi	a0,a0,-1058 # 5c58 <malloc+0xd64>
    2082:	5bf020ef          	jal	ra,4e40 <printf>
    exit(1);
    2086:	4505                	li	a0,1
    2088:	1ad020ef          	jal	ra,4a34 <exit>
  close(fd);
    208c:	854a                	mv	a0,s2
    208e:	1cf020ef          	jal	ra,4a5c <close>
  exit(0);
    2092:	4501                	li	a0,0
    2094:	1a1020ef          	jal	ra,4a34 <exit>

0000000000002098 <sbrkbasic>:
{
    2098:	7139                	addi	sp,sp,-64
    209a:	fc06                	sd	ra,56(sp)
    209c:	f822                	sd	s0,48(sp)
    209e:	f426                	sd	s1,40(sp)
    20a0:	f04a                	sd	s2,32(sp)
    20a2:	ec4e                	sd	s3,24(sp)
    20a4:	e852                	sd	s4,16(sp)
    20a6:	0080                	addi	s0,sp,64
    20a8:	8a2a                	mv	s4,a0
  pid = fork();
    20aa:	183020ef          	jal	ra,4a2c <fork>
  if(pid < 0){
    20ae:	02054863          	bltz	a0,20de <sbrkbasic+0x46>
  if(pid == 0){
    20b2:	e131                	bnez	a0,20f6 <sbrkbasic+0x5e>
    a = sbrk(TOOMUCH);
    20b4:	40000537          	lui	a0,0x40000
    20b8:	205020ef          	jal	ra,4abc <sbrk>
    if(a == (char*)0xffffffffffffffffL){
    20bc:	57fd                	li	a5,-1
    20be:	02f50963          	beq	a0,a5,20f0 <sbrkbasic+0x58>
    for(b = a; b < a+TOOMUCH; b += 4096){
    20c2:	400007b7          	lui	a5,0x40000
    20c6:	97aa                	add	a5,a5,a0
      *b = 99;
    20c8:	06300693          	li	a3,99
    for(b = a; b < a+TOOMUCH; b += 4096){
    20cc:	6705                	lui	a4,0x1
      *b = 99;
    20ce:	00d50023          	sb	a3,0(a0) # 40000000 <base+0x3fff1388>
    for(b = a; b < a+TOOMUCH; b += 4096){
    20d2:	953a                	add	a0,a0,a4
    20d4:	fef51de3          	bne	a0,a5,20ce <sbrkbasic+0x36>
    exit(1);
    20d8:	4505                	li	a0,1
    20da:	15b020ef          	jal	ra,4a34 <exit>
    printf("fork failed in sbrkbasic\n");
    20de:	00004517          	auipc	a0,0x4
    20e2:	bea50513          	addi	a0,a0,-1046 # 5cc8 <malloc+0xdd4>
    20e6:	55b020ef          	jal	ra,4e40 <printf>
    exit(1);
    20ea:	4505                	li	a0,1
    20ec:	149020ef          	jal	ra,4a34 <exit>
      exit(0);
    20f0:	4501                	li	a0,0
    20f2:	143020ef          	jal	ra,4a34 <exit>
  wait(&xstatus);
    20f6:	fcc40513          	addi	a0,s0,-52
    20fa:	143020ef          	jal	ra,4a3c <wait>
  if(xstatus == 1){
    20fe:	fcc42703          	lw	a4,-52(s0)
    2102:	4785                	li	a5,1
    2104:	00f70b63          	beq	a4,a5,211a <sbrkbasic+0x82>
  a = sbrk(0);
    2108:	4501                	li	a0,0
    210a:	1b3020ef          	jal	ra,4abc <sbrk>
    210e:	84aa                	mv	s1,a0
  for(i = 0; i < 5000; i++){
    2110:	4901                	li	s2,0
    2112:	6985                	lui	s3,0x1
    2114:	38898993          	addi	s3,s3,904 # 1388 <exectest+0x5a>
    2118:	a821                	j	2130 <sbrkbasic+0x98>
    printf("%s: too much memory allocated!\n", s);
    211a:	85d2                	mv	a1,s4
    211c:	00004517          	auipc	a0,0x4
    2120:	bcc50513          	addi	a0,a0,-1076 # 5ce8 <malloc+0xdf4>
    2124:	51d020ef          	jal	ra,4e40 <printf>
    exit(1);
    2128:	4505                	li	a0,1
    212a:	10b020ef          	jal	ra,4a34 <exit>
    a = b + 1;
    212e:	84be                	mv	s1,a5
    b = sbrk(1);
    2130:	4505                	li	a0,1
    2132:	18b020ef          	jal	ra,4abc <sbrk>
    if(b != a){
    2136:	04951263          	bne	a0,s1,217a <sbrkbasic+0xe2>
    *b = 1;
    213a:	4785                	li	a5,1
    213c:	00f48023          	sb	a5,0(s1)
    a = b + 1;
    2140:	00148793          	addi	a5,s1,1
  for(i = 0; i < 5000; i++){
    2144:	2905                	addiw	s2,s2,1
    2146:	ff3914e3          	bne	s2,s3,212e <sbrkbasic+0x96>
  pid = fork();
    214a:	0e3020ef          	jal	ra,4a2c <fork>
    214e:	892a                	mv	s2,a0
  if(pid < 0){
    2150:	04054263          	bltz	a0,2194 <sbrkbasic+0xfc>
  c = sbrk(1);
    2154:	4505                	li	a0,1
    2156:	167020ef          	jal	ra,4abc <sbrk>
  c = sbrk(1);
    215a:	4505                	li	a0,1
    215c:	161020ef          	jal	ra,4abc <sbrk>
  if(c != a + 1){
    2160:	0489                	addi	s1,s1,2
    2162:	04a48363          	beq	s1,a0,21a8 <sbrkbasic+0x110>
    printf("%s: sbrk test failed post-fork\n", s);
    2166:	85d2                	mv	a1,s4
    2168:	00004517          	auipc	a0,0x4
    216c:	be050513          	addi	a0,a0,-1056 # 5d48 <malloc+0xe54>
    2170:	4d1020ef          	jal	ra,4e40 <printf>
    exit(1);
    2174:	4505                	li	a0,1
    2176:	0bf020ef          	jal	ra,4a34 <exit>
      printf("%s: sbrk test failed %d %p %p\n", s, i, a, b);
    217a:	872a                	mv	a4,a0
    217c:	86a6                	mv	a3,s1
    217e:	864a                	mv	a2,s2
    2180:	85d2                	mv	a1,s4
    2182:	00004517          	auipc	a0,0x4
    2186:	b8650513          	addi	a0,a0,-1146 # 5d08 <malloc+0xe14>
    218a:	4b7020ef          	jal	ra,4e40 <printf>
      exit(1);
    218e:	4505                	li	a0,1
    2190:	0a5020ef          	jal	ra,4a34 <exit>
    printf("%s: sbrk test fork failed\n", s);
    2194:	85d2                	mv	a1,s4
    2196:	00004517          	auipc	a0,0x4
    219a:	b9250513          	addi	a0,a0,-1134 # 5d28 <malloc+0xe34>
    219e:	4a3020ef          	jal	ra,4e40 <printf>
    exit(1);
    21a2:	4505                	li	a0,1
    21a4:	091020ef          	jal	ra,4a34 <exit>
  if(pid == 0)
    21a8:	00091563          	bnez	s2,21b2 <sbrkbasic+0x11a>
    exit(0);
    21ac:	4501                	li	a0,0
    21ae:	087020ef          	jal	ra,4a34 <exit>
  wait(&xstatus);
    21b2:	fcc40513          	addi	a0,s0,-52
    21b6:	087020ef          	jal	ra,4a3c <wait>
  exit(xstatus);
    21ba:	fcc42503          	lw	a0,-52(s0)
    21be:	077020ef          	jal	ra,4a34 <exit>

00000000000021c2 <sbrkmuch>:
{
    21c2:	7179                	addi	sp,sp,-48
    21c4:	f406                	sd	ra,40(sp)
    21c6:	f022                	sd	s0,32(sp)
    21c8:	ec26                	sd	s1,24(sp)
    21ca:	e84a                	sd	s2,16(sp)
    21cc:	e44e                	sd	s3,8(sp)
    21ce:	e052                	sd	s4,0(sp)
    21d0:	1800                	addi	s0,sp,48
    21d2:	89aa                	mv	s3,a0
  oldbrk = sbrk(0);
    21d4:	4501                	li	a0,0
    21d6:	0e7020ef          	jal	ra,4abc <sbrk>
    21da:	892a                	mv	s2,a0
  a = sbrk(0);
    21dc:	4501                	li	a0,0
    21de:	0df020ef          	jal	ra,4abc <sbrk>
    21e2:	84aa                	mv	s1,a0
  p = sbrk(amt);
    21e4:	06400537          	lui	a0,0x6400
    21e8:	9d05                	subw	a0,a0,s1
    21ea:	0d3020ef          	jal	ra,4abc <sbrk>
  if (p != a) {
    21ee:	0aa49463          	bne	s1,a0,2296 <sbrkmuch+0xd4>
  char *eee = sbrk(0);
    21f2:	4501                	li	a0,0
    21f4:	0c9020ef          	jal	ra,4abc <sbrk>
    21f8:	87aa                	mv	a5,a0
  for(char *pp = a; pp < eee; pp += 4096)
    21fa:	00a4f963          	bgeu	s1,a0,220c <sbrkmuch+0x4a>
    *pp = 1;
    21fe:	4685                	li	a3,1
  for(char *pp = a; pp < eee; pp += 4096)
    2200:	6705                	lui	a4,0x1
    *pp = 1;
    2202:	00d48023          	sb	a3,0(s1)
  for(char *pp = a; pp < eee; pp += 4096)
    2206:	94ba                	add	s1,s1,a4
    2208:	fef4ede3          	bltu	s1,a5,2202 <sbrkmuch+0x40>
  *lastaddr = 99;
    220c:	064007b7          	lui	a5,0x6400
    2210:	06300713          	li	a4,99
    2214:	fee78fa3          	sb	a4,-1(a5) # 63fffff <base+0x63f1387>
  a = sbrk(0);
    2218:	4501                	li	a0,0
    221a:	0a3020ef          	jal	ra,4abc <sbrk>
    221e:	84aa                	mv	s1,a0
  c = sbrk(-PGSIZE);
    2220:	757d                	lui	a0,0xfffff
    2222:	09b020ef          	jal	ra,4abc <sbrk>
  if(c == (char*)0xffffffffffffffffL){
    2226:	57fd                	li	a5,-1
    2228:	08f50163          	beq	a0,a5,22aa <sbrkmuch+0xe8>
  c = sbrk(0);
    222c:	4501                	li	a0,0
    222e:	08f020ef          	jal	ra,4abc <sbrk>
  if(c != a - PGSIZE){
    2232:	77fd                	lui	a5,0xfffff
    2234:	97a6                	add	a5,a5,s1
    2236:	08f51463          	bne	a0,a5,22be <sbrkmuch+0xfc>
  a = sbrk(0);
    223a:	4501                	li	a0,0
    223c:	081020ef          	jal	ra,4abc <sbrk>
    2240:	84aa                	mv	s1,a0
  c = sbrk(PGSIZE);
    2242:	6505                	lui	a0,0x1
    2244:	079020ef          	jal	ra,4abc <sbrk>
    2248:	8a2a                	mv	s4,a0
  if(c != a || sbrk(0) != a + PGSIZE){
    224a:	08a49663          	bne	s1,a0,22d6 <sbrkmuch+0x114>
    224e:	4501                	li	a0,0
    2250:	06d020ef          	jal	ra,4abc <sbrk>
    2254:	6785                	lui	a5,0x1
    2256:	97a6                	add	a5,a5,s1
    2258:	06f51f63          	bne	a0,a5,22d6 <sbrkmuch+0x114>
  if(*lastaddr == 99){
    225c:	064007b7          	lui	a5,0x6400
    2260:	fff7c703          	lbu	a4,-1(a5) # 63fffff <base+0x63f1387>
    2264:	06300793          	li	a5,99
    2268:	08f70363          	beq	a4,a5,22ee <sbrkmuch+0x12c>
  a = sbrk(0);
    226c:	4501                	li	a0,0
    226e:	04f020ef          	jal	ra,4abc <sbrk>
    2272:	84aa                	mv	s1,a0
  c = sbrk(-(sbrk(0) - oldbrk));
    2274:	4501                	li	a0,0
    2276:	047020ef          	jal	ra,4abc <sbrk>
    227a:	40a9053b          	subw	a0,s2,a0
    227e:	03f020ef          	jal	ra,4abc <sbrk>
  if(c != a){
    2282:	08a49063          	bne	s1,a0,2302 <sbrkmuch+0x140>
}
    2286:	70a2                	ld	ra,40(sp)
    2288:	7402                	ld	s0,32(sp)
    228a:	64e2                	ld	s1,24(sp)
    228c:	6942                	ld	s2,16(sp)
    228e:	69a2                	ld	s3,8(sp)
    2290:	6a02                	ld	s4,0(sp)
    2292:	6145                	addi	sp,sp,48
    2294:	8082                	ret
    printf("%s: sbrk test failed to grow big address space; enough phys mem?\n", s);
    2296:	85ce                	mv	a1,s3
    2298:	00004517          	auipc	a0,0x4
    229c:	ad050513          	addi	a0,a0,-1328 # 5d68 <malloc+0xe74>
    22a0:	3a1020ef          	jal	ra,4e40 <printf>
    exit(1);
    22a4:	4505                	li	a0,1
    22a6:	78e020ef          	jal	ra,4a34 <exit>
    printf("%s: sbrk could not deallocate\n", s);
    22aa:	85ce                	mv	a1,s3
    22ac:	00004517          	auipc	a0,0x4
    22b0:	b0450513          	addi	a0,a0,-1276 # 5db0 <malloc+0xebc>
    22b4:	38d020ef          	jal	ra,4e40 <printf>
    exit(1);
    22b8:	4505                	li	a0,1
    22ba:	77a020ef          	jal	ra,4a34 <exit>
    printf("%s: sbrk deallocation produced wrong address, a %p c %p\n", s, a, c);
    22be:	86aa                	mv	a3,a0
    22c0:	8626                	mv	a2,s1
    22c2:	85ce                	mv	a1,s3
    22c4:	00004517          	auipc	a0,0x4
    22c8:	b0c50513          	addi	a0,a0,-1268 # 5dd0 <malloc+0xedc>
    22cc:	375020ef          	jal	ra,4e40 <printf>
    exit(1);
    22d0:	4505                	li	a0,1
    22d2:	762020ef          	jal	ra,4a34 <exit>
    printf("%s: sbrk re-allocation failed, a %p c %p\n", s, a, c);
    22d6:	86d2                	mv	a3,s4
    22d8:	8626                	mv	a2,s1
    22da:	85ce                	mv	a1,s3
    22dc:	00004517          	auipc	a0,0x4
    22e0:	b3450513          	addi	a0,a0,-1228 # 5e10 <malloc+0xf1c>
    22e4:	35d020ef          	jal	ra,4e40 <printf>
    exit(1);
    22e8:	4505                	li	a0,1
    22ea:	74a020ef          	jal	ra,4a34 <exit>
    printf("%s: sbrk de-allocation didn't really deallocate\n", s);
    22ee:	85ce                	mv	a1,s3
    22f0:	00004517          	auipc	a0,0x4
    22f4:	b5050513          	addi	a0,a0,-1200 # 5e40 <malloc+0xf4c>
    22f8:	349020ef          	jal	ra,4e40 <printf>
    exit(1);
    22fc:	4505                	li	a0,1
    22fe:	736020ef          	jal	ra,4a34 <exit>
    printf("%s: sbrk downsize failed, a %p c %p\n", s, a, c);
    2302:	86aa                	mv	a3,a0
    2304:	8626                	mv	a2,s1
    2306:	85ce                	mv	a1,s3
    2308:	00004517          	auipc	a0,0x4
    230c:	b7050513          	addi	a0,a0,-1168 # 5e78 <malloc+0xf84>
    2310:	331020ef          	jal	ra,4e40 <printf>
    exit(1);
    2314:	4505                	li	a0,1
    2316:	71e020ef          	jal	ra,4a34 <exit>

000000000000231a <sbrkarg>:
{
    231a:	7179                	addi	sp,sp,-48
    231c:	f406                	sd	ra,40(sp)
    231e:	f022                	sd	s0,32(sp)
    2320:	ec26                	sd	s1,24(sp)
    2322:	e84a                	sd	s2,16(sp)
    2324:	e44e                	sd	s3,8(sp)
    2326:	1800                	addi	s0,sp,48
    2328:	89aa                	mv	s3,a0
  a = sbrk(PGSIZE);
    232a:	6505                	lui	a0,0x1
    232c:	790020ef          	jal	ra,4abc <sbrk>
    2330:	892a                	mv	s2,a0
  fd = open("sbrk", O_CREATE|O_WRONLY);
    2332:	20100593          	li	a1,513
    2336:	00004517          	auipc	a0,0x4
    233a:	b6a50513          	addi	a0,a0,-1174 # 5ea0 <malloc+0xfac>
    233e:	736020ef          	jal	ra,4a74 <open>
    2342:	84aa                	mv	s1,a0
  unlink("sbrk");
    2344:	00004517          	auipc	a0,0x4
    2348:	b5c50513          	addi	a0,a0,-1188 # 5ea0 <malloc+0xfac>
    234c:	738020ef          	jal	ra,4a84 <unlink>
  if(fd < 0)  {
    2350:	0204c963          	bltz	s1,2382 <sbrkarg+0x68>
  if ((n = write(fd, a, PGSIZE)) < 0) {
    2354:	6605                	lui	a2,0x1
    2356:	85ca                	mv	a1,s2
    2358:	8526                	mv	a0,s1
    235a:	6fa020ef          	jal	ra,4a54 <write>
    235e:	02054c63          	bltz	a0,2396 <sbrkarg+0x7c>
  close(fd);
    2362:	8526                	mv	a0,s1
    2364:	6f8020ef          	jal	ra,4a5c <close>
  a = sbrk(PGSIZE);
    2368:	6505                	lui	a0,0x1
    236a:	752020ef          	jal	ra,4abc <sbrk>
  if(pipe((int *) a) != 0){
    236e:	6d6020ef          	jal	ra,4a44 <pipe>
    2372:	ed05                	bnez	a0,23aa <sbrkarg+0x90>
}
    2374:	70a2                	ld	ra,40(sp)
    2376:	7402                	ld	s0,32(sp)
    2378:	64e2                	ld	s1,24(sp)
    237a:	6942                	ld	s2,16(sp)
    237c:	69a2                	ld	s3,8(sp)
    237e:	6145                	addi	sp,sp,48
    2380:	8082                	ret
    printf("%s: open sbrk failed\n", s);
    2382:	85ce                	mv	a1,s3
    2384:	00004517          	auipc	a0,0x4
    2388:	b2450513          	addi	a0,a0,-1244 # 5ea8 <malloc+0xfb4>
    238c:	2b5020ef          	jal	ra,4e40 <printf>
    exit(1);
    2390:	4505                	li	a0,1
    2392:	6a2020ef          	jal	ra,4a34 <exit>
    printf("%s: write sbrk failed\n", s);
    2396:	85ce                	mv	a1,s3
    2398:	00004517          	auipc	a0,0x4
    239c:	b2850513          	addi	a0,a0,-1240 # 5ec0 <malloc+0xfcc>
    23a0:	2a1020ef          	jal	ra,4e40 <printf>
    exit(1);
    23a4:	4505                	li	a0,1
    23a6:	68e020ef          	jal	ra,4a34 <exit>
    printf("%s: pipe() failed\n", s);
    23aa:	85ce                	mv	a1,s3
    23ac:	00003517          	auipc	a0,0x3
    23b0:	60450513          	addi	a0,a0,1540 # 59b0 <malloc+0xabc>
    23b4:	28d020ef          	jal	ra,4e40 <printf>
    exit(1);
    23b8:	4505                	li	a0,1
    23ba:	67a020ef          	jal	ra,4a34 <exit>

00000000000023be <argptest>:
{
    23be:	1101                	addi	sp,sp,-32
    23c0:	ec06                	sd	ra,24(sp)
    23c2:	e822                	sd	s0,16(sp)
    23c4:	e426                	sd	s1,8(sp)
    23c6:	e04a                	sd	s2,0(sp)
    23c8:	1000                	addi	s0,sp,32
    23ca:	892a                	mv	s2,a0
  fd = open("init", O_RDONLY);
    23cc:	4581                	li	a1,0
    23ce:	00004517          	auipc	a0,0x4
    23d2:	b0a50513          	addi	a0,a0,-1270 # 5ed8 <malloc+0xfe4>
    23d6:	69e020ef          	jal	ra,4a74 <open>
  if (fd < 0) {
    23da:	02054563          	bltz	a0,2404 <argptest+0x46>
    23de:	84aa                	mv	s1,a0
  read(fd, sbrk(0) - 1, -1);
    23e0:	4501                	li	a0,0
    23e2:	6da020ef          	jal	ra,4abc <sbrk>
    23e6:	567d                	li	a2,-1
    23e8:	fff50593          	addi	a1,a0,-1
    23ec:	8526                	mv	a0,s1
    23ee:	65e020ef          	jal	ra,4a4c <read>
  close(fd);
    23f2:	8526                	mv	a0,s1
    23f4:	668020ef          	jal	ra,4a5c <close>
}
    23f8:	60e2                	ld	ra,24(sp)
    23fa:	6442                	ld	s0,16(sp)
    23fc:	64a2                	ld	s1,8(sp)
    23fe:	6902                	ld	s2,0(sp)
    2400:	6105                	addi	sp,sp,32
    2402:	8082                	ret
    printf("%s: open failed\n", s);
    2404:	85ca                	mv	a1,s2
    2406:	00003517          	auipc	a0,0x3
    240a:	4ba50513          	addi	a0,a0,1210 # 58c0 <malloc+0x9cc>
    240e:	233020ef          	jal	ra,4e40 <printf>
    exit(1);
    2412:	4505                	li	a0,1
    2414:	620020ef          	jal	ra,4a34 <exit>

0000000000002418 <sbrkbugs>:
{
    2418:	1141                	addi	sp,sp,-16
    241a:	e406                	sd	ra,8(sp)
    241c:	e022                	sd	s0,0(sp)
    241e:	0800                	addi	s0,sp,16
  int pid = fork();
    2420:	60c020ef          	jal	ra,4a2c <fork>
  if(pid < 0){
    2424:	00054c63          	bltz	a0,243c <sbrkbugs+0x24>
  if(pid == 0){
    2428:	e11d                	bnez	a0,244e <sbrkbugs+0x36>
    int sz = (uint64) sbrk(0);
    242a:	692020ef          	jal	ra,4abc <sbrk>
    sbrk(-sz);
    242e:	40a0053b          	negw	a0,a0
    2432:	68a020ef          	jal	ra,4abc <sbrk>
    exit(0);
    2436:	4501                	li	a0,0
    2438:	5fc020ef          	jal	ra,4a34 <exit>
    printf("fork failed\n");
    243c:	00005517          	auipc	a0,0x5
    2440:	9dc50513          	addi	a0,a0,-1572 # 6e18 <malloc+0x1f24>
    2444:	1fd020ef          	jal	ra,4e40 <printf>
    exit(1);
    2448:	4505                	li	a0,1
    244a:	5ea020ef          	jal	ra,4a34 <exit>
  wait(0);
    244e:	4501                	li	a0,0
    2450:	5ec020ef          	jal	ra,4a3c <wait>
  pid = fork();
    2454:	5d8020ef          	jal	ra,4a2c <fork>
  if(pid < 0){
    2458:	00054f63          	bltz	a0,2476 <sbrkbugs+0x5e>
  if(pid == 0){
    245c:	e515                	bnez	a0,2488 <sbrkbugs+0x70>
    int sz = (uint64) sbrk(0);
    245e:	65e020ef          	jal	ra,4abc <sbrk>
    sbrk(-(sz - 3500));
    2462:	6785                	lui	a5,0x1
    2464:	dac7879b          	addiw	a5,a5,-596 # dac <linktest+0x138>
    2468:	40a7853b          	subw	a0,a5,a0
    246c:	650020ef          	jal	ra,4abc <sbrk>
    exit(0);
    2470:	4501                	li	a0,0
    2472:	5c2020ef          	jal	ra,4a34 <exit>
    printf("fork failed\n");
    2476:	00005517          	auipc	a0,0x5
    247a:	9a250513          	addi	a0,a0,-1630 # 6e18 <malloc+0x1f24>
    247e:	1c3020ef          	jal	ra,4e40 <printf>
    exit(1);
    2482:	4505                	li	a0,1
    2484:	5b0020ef          	jal	ra,4a34 <exit>
  wait(0);
    2488:	4501                	li	a0,0
    248a:	5b2020ef          	jal	ra,4a3c <wait>
  pid = fork();
    248e:	59e020ef          	jal	ra,4a2c <fork>
  if(pid < 0){
    2492:	02054263          	bltz	a0,24b6 <sbrkbugs+0x9e>
  if(pid == 0){
    2496:	e90d                	bnez	a0,24c8 <sbrkbugs+0xb0>
    sbrk((10*4096 + 2048) - (uint64)sbrk(0));
    2498:	624020ef          	jal	ra,4abc <sbrk>
    249c:	67ad                	lui	a5,0xb
    249e:	8007879b          	addiw	a5,a5,-2048 # a800 <uninit+0x1298>
    24a2:	40a7853b          	subw	a0,a5,a0
    24a6:	616020ef          	jal	ra,4abc <sbrk>
    sbrk(-10);
    24aa:	5559                	li	a0,-10
    24ac:	610020ef          	jal	ra,4abc <sbrk>
    exit(0);
    24b0:	4501                	li	a0,0
    24b2:	582020ef          	jal	ra,4a34 <exit>
    printf("fork failed\n");
    24b6:	00005517          	auipc	a0,0x5
    24ba:	96250513          	addi	a0,a0,-1694 # 6e18 <malloc+0x1f24>
    24be:	183020ef          	jal	ra,4e40 <printf>
    exit(1);
    24c2:	4505                	li	a0,1
    24c4:	570020ef          	jal	ra,4a34 <exit>
  wait(0);
    24c8:	4501                	li	a0,0
    24ca:	572020ef          	jal	ra,4a3c <wait>
  exit(0);
    24ce:	4501                	li	a0,0
    24d0:	564020ef          	jal	ra,4a34 <exit>

00000000000024d4 <sbrklast>:
{
    24d4:	7179                	addi	sp,sp,-48
    24d6:	f406                	sd	ra,40(sp)
    24d8:	f022                	sd	s0,32(sp)
    24da:	ec26                	sd	s1,24(sp)
    24dc:	e84a                	sd	s2,16(sp)
    24de:	e44e                	sd	s3,8(sp)
    24e0:	e052                	sd	s4,0(sp)
    24e2:	1800                	addi	s0,sp,48
  uint64 top = (uint64) sbrk(0);
    24e4:	4501                	li	a0,0
    24e6:	5d6020ef          	jal	ra,4abc <sbrk>
  if((top % 4096) != 0)
    24ea:	03451793          	slli	a5,a0,0x34
    24ee:	ebad                	bnez	a5,2560 <sbrklast+0x8c>
  sbrk(4096);
    24f0:	6505                	lui	a0,0x1
    24f2:	5ca020ef          	jal	ra,4abc <sbrk>
  sbrk(10);
    24f6:	4529                	li	a0,10
    24f8:	5c4020ef          	jal	ra,4abc <sbrk>
  sbrk(-20);
    24fc:	5531                	li	a0,-20
    24fe:	5be020ef          	jal	ra,4abc <sbrk>
  top = (uint64) sbrk(0);
    2502:	4501                	li	a0,0
    2504:	5b8020ef          	jal	ra,4abc <sbrk>
    2508:	84aa                	mv	s1,a0
  char *p = (char *) (top - 64);
    250a:	fc050913          	addi	s2,a0,-64 # fc0 <bigdir+0x122>
  p[0] = 'x';
    250e:	07800a13          	li	s4,120
    2512:	fd450023          	sb	s4,-64(a0)
  p[1] = '\0';
    2516:	fc0500a3          	sb	zero,-63(a0)
  int fd = open(p, O_RDWR|O_CREATE);
    251a:	20200593          	li	a1,514
    251e:	854a                	mv	a0,s2
    2520:	554020ef          	jal	ra,4a74 <open>
    2524:	89aa                	mv	s3,a0
  write(fd, p, 1);
    2526:	4605                	li	a2,1
    2528:	85ca                	mv	a1,s2
    252a:	52a020ef          	jal	ra,4a54 <write>
  close(fd);
    252e:	854e                	mv	a0,s3
    2530:	52c020ef          	jal	ra,4a5c <close>
  fd = open(p, O_RDWR);
    2534:	4589                	li	a1,2
    2536:	854a                	mv	a0,s2
    2538:	53c020ef          	jal	ra,4a74 <open>
  p[0] = '\0';
    253c:	fc048023          	sb	zero,-64(s1)
  read(fd, p, 1);
    2540:	4605                	li	a2,1
    2542:	85ca                	mv	a1,s2
    2544:	508020ef          	jal	ra,4a4c <read>
  if(p[0] != 'x')
    2548:	fc04c783          	lbu	a5,-64(s1)
    254c:	03479263          	bne	a5,s4,2570 <sbrklast+0x9c>
}
    2550:	70a2                	ld	ra,40(sp)
    2552:	7402                	ld	s0,32(sp)
    2554:	64e2                	ld	s1,24(sp)
    2556:	6942                	ld	s2,16(sp)
    2558:	69a2                	ld	s3,8(sp)
    255a:	6a02                	ld	s4,0(sp)
    255c:	6145                	addi	sp,sp,48
    255e:	8082                	ret
    sbrk(4096 - (top % 4096));
    2560:	0347d513          	srli	a0,a5,0x34
    2564:	6785                	lui	a5,0x1
    2566:	40a7853b          	subw	a0,a5,a0
    256a:	552020ef          	jal	ra,4abc <sbrk>
    256e:	b749                	j	24f0 <sbrklast+0x1c>
    exit(1);
    2570:	4505                	li	a0,1
    2572:	4c2020ef          	jal	ra,4a34 <exit>

0000000000002576 <sbrk8000>:
{
    2576:	1141                	addi	sp,sp,-16
    2578:	e406                	sd	ra,8(sp)
    257a:	e022                	sd	s0,0(sp)
    257c:	0800                	addi	s0,sp,16
  sbrk(0x80000004);
    257e:	80000537          	lui	a0,0x80000
    2582:	0511                	addi	a0,a0,4 # ffffffff80000004 <base+0xffffffff7fff138c>
    2584:	538020ef          	jal	ra,4abc <sbrk>
  volatile char *top = sbrk(0);
    2588:	4501                	li	a0,0
    258a:	532020ef          	jal	ra,4abc <sbrk>
  *(top-1) = *(top-1) + 1;
    258e:	fff54783          	lbu	a5,-1(a0)
    2592:	2785                	addiw	a5,a5,1 # 1001 <badarg+0x1>
    2594:	0ff7f793          	zext.b	a5,a5
    2598:	fef50fa3          	sb	a5,-1(a0)
}
    259c:	60a2                	ld	ra,8(sp)
    259e:	6402                	ld	s0,0(sp)
    25a0:	0141                	addi	sp,sp,16
    25a2:	8082                	ret

00000000000025a4 <execout>:
{
    25a4:	715d                	addi	sp,sp,-80
    25a6:	e486                	sd	ra,72(sp)
    25a8:	e0a2                	sd	s0,64(sp)
    25aa:	fc26                	sd	s1,56(sp)
    25ac:	f84a                	sd	s2,48(sp)
    25ae:	f44e                	sd	s3,40(sp)
    25b0:	f052                	sd	s4,32(sp)
    25b2:	0880                	addi	s0,sp,80
  for(int avail = 0; avail < 15; avail++){
    25b4:	4901                	li	s2,0
    25b6:	49bd                	li	s3,15
    int pid = fork();
    25b8:	474020ef          	jal	ra,4a2c <fork>
    25bc:	84aa                	mv	s1,a0
    if(pid < 0){
    25be:	00054c63          	bltz	a0,25d6 <execout+0x32>
    } else if(pid == 0){
    25c2:	c11d                	beqz	a0,25e8 <execout+0x44>
      wait((int*)0);
    25c4:	4501                	li	a0,0
    25c6:	476020ef          	jal	ra,4a3c <wait>
  for(int avail = 0; avail < 15; avail++){
    25ca:	2905                	addiw	s2,s2,1
    25cc:	ff3916e3          	bne	s2,s3,25b8 <execout+0x14>
  exit(0);
    25d0:	4501                	li	a0,0
    25d2:	462020ef          	jal	ra,4a34 <exit>
      printf("fork failed\n");
    25d6:	00005517          	auipc	a0,0x5
    25da:	84250513          	addi	a0,a0,-1982 # 6e18 <malloc+0x1f24>
    25de:	063020ef          	jal	ra,4e40 <printf>
      exit(1);
    25e2:	4505                	li	a0,1
    25e4:	450020ef          	jal	ra,4a34 <exit>
        if(a == 0xffffffffffffffffLL)
    25e8:	59fd                	li	s3,-1
        *(char*)(a + 4096 - 1) = 1;
    25ea:	4a05                	li	s4,1
        uint64 a = (uint64) sbrk(4096);
    25ec:	6505                	lui	a0,0x1
    25ee:	4ce020ef          	jal	ra,4abc <sbrk>
        if(a == 0xffffffffffffffffLL)
    25f2:	01350763          	beq	a0,s3,2600 <execout+0x5c>
        *(char*)(a + 4096 - 1) = 1;
    25f6:	6785                	lui	a5,0x1
    25f8:	97aa                	add	a5,a5,a0
    25fa:	ff478fa3          	sb	s4,-1(a5) # fff <pgbug+0x2b>
      while(1){
    25fe:	b7fd                	j	25ec <execout+0x48>
      for(int i = 0; i < avail; i++)
    2600:	01205863          	blez	s2,2610 <execout+0x6c>
        sbrk(-4096);
    2604:	757d                	lui	a0,0xfffff
    2606:	4b6020ef          	jal	ra,4abc <sbrk>
      for(int i = 0; i < avail; i++)
    260a:	2485                	addiw	s1,s1,1
    260c:	ff249ce3          	bne	s1,s2,2604 <execout+0x60>
      close(1);
    2610:	4505                	li	a0,1
    2612:	44a020ef          	jal	ra,4a5c <close>
      char *args[] = { "echo", "x", 0 };
    2616:	00003517          	auipc	a0,0x3
    261a:	a0250513          	addi	a0,a0,-1534 # 5018 <malloc+0x124>
    261e:	faa43c23          	sd	a0,-72(s0)
    2622:	00003797          	auipc	a5,0x3
    2626:	a6678793          	addi	a5,a5,-1434 # 5088 <malloc+0x194>
    262a:	fcf43023          	sd	a5,-64(s0)
    262e:	fc043423          	sd	zero,-56(s0)
      exec("echo", args);
    2632:	fb840593          	addi	a1,s0,-72
    2636:	436020ef          	jal	ra,4a6c <exec>
      exit(0);
    263a:	4501                	li	a0,0
    263c:	3f8020ef          	jal	ra,4a34 <exit>

0000000000002640 <fourteen>:
{
    2640:	1101                	addi	sp,sp,-32
    2642:	ec06                	sd	ra,24(sp)
    2644:	e822                	sd	s0,16(sp)
    2646:	e426                	sd	s1,8(sp)
    2648:	1000                	addi	s0,sp,32
    264a:	84aa                	mv	s1,a0
  if(mkdir("12345678901234") != 0){
    264c:	00004517          	auipc	a0,0x4
    2650:	a6450513          	addi	a0,a0,-1436 # 60b0 <malloc+0x11bc>
    2654:	448020ef          	jal	ra,4a9c <mkdir>
    2658:	e555                	bnez	a0,2704 <fourteen+0xc4>
  if(mkdir("12345678901234/123456789012345") != 0){
    265a:	00004517          	auipc	a0,0x4
    265e:	8ae50513          	addi	a0,a0,-1874 # 5f08 <malloc+0x1014>
    2662:	43a020ef          	jal	ra,4a9c <mkdir>
    2666:	e94d                	bnez	a0,2718 <fourteen+0xd8>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    2668:	20000593          	li	a1,512
    266c:	00004517          	auipc	a0,0x4
    2670:	8f450513          	addi	a0,a0,-1804 # 5f60 <malloc+0x106c>
    2674:	400020ef          	jal	ra,4a74 <open>
  if(fd < 0){
    2678:	0a054a63          	bltz	a0,272c <fourteen+0xec>
  close(fd);
    267c:	3e0020ef          	jal	ra,4a5c <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    2680:	4581                	li	a1,0
    2682:	00004517          	auipc	a0,0x4
    2686:	95650513          	addi	a0,a0,-1706 # 5fd8 <malloc+0x10e4>
    268a:	3ea020ef          	jal	ra,4a74 <open>
  if(fd < 0){
    268e:	0a054963          	bltz	a0,2740 <fourteen+0x100>
  close(fd);
    2692:	3ca020ef          	jal	ra,4a5c <close>
  if(mkdir("12345678901234/12345678901234") == 0){
    2696:	00004517          	auipc	a0,0x4
    269a:	9b250513          	addi	a0,a0,-1614 # 6048 <malloc+0x1154>
    269e:	3fe020ef          	jal	ra,4a9c <mkdir>
    26a2:	c94d                	beqz	a0,2754 <fourteen+0x114>
  if(mkdir("123456789012345/12345678901234") == 0){
    26a4:	00004517          	auipc	a0,0x4
    26a8:	9fc50513          	addi	a0,a0,-1540 # 60a0 <malloc+0x11ac>
    26ac:	3f0020ef          	jal	ra,4a9c <mkdir>
    26b0:	cd45                	beqz	a0,2768 <fourteen+0x128>
  unlink("123456789012345/12345678901234");
    26b2:	00004517          	auipc	a0,0x4
    26b6:	9ee50513          	addi	a0,a0,-1554 # 60a0 <malloc+0x11ac>
    26ba:	3ca020ef          	jal	ra,4a84 <unlink>
  unlink("12345678901234/12345678901234");
    26be:	00004517          	auipc	a0,0x4
    26c2:	98a50513          	addi	a0,a0,-1654 # 6048 <malloc+0x1154>
    26c6:	3be020ef          	jal	ra,4a84 <unlink>
  unlink("12345678901234/12345678901234/12345678901234");
    26ca:	00004517          	auipc	a0,0x4
    26ce:	90e50513          	addi	a0,a0,-1778 # 5fd8 <malloc+0x10e4>
    26d2:	3b2020ef          	jal	ra,4a84 <unlink>
  unlink("123456789012345/123456789012345/123456789012345");
    26d6:	00004517          	auipc	a0,0x4
    26da:	88a50513          	addi	a0,a0,-1910 # 5f60 <malloc+0x106c>
    26de:	3a6020ef          	jal	ra,4a84 <unlink>
  unlink("12345678901234/123456789012345");
    26e2:	00004517          	auipc	a0,0x4
    26e6:	82650513          	addi	a0,a0,-2010 # 5f08 <malloc+0x1014>
    26ea:	39a020ef          	jal	ra,4a84 <unlink>
  unlink("12345678901234");
    26ee:	00004517          	auipc	a0,0x4
    26f2:	9c250513          	addi	a0,a0,-1598 # 60b0 <malloc+0x11bc>
    26f6:	38e020ef          	jal	ra,4a84 <unlink>
}
    26fa:	60e2                	ld	ra,24(sp)
    26fc:	6442                	ld	s0,16(sp)
    26fe:	64a2                	ld	s1,8(sp)
    2700:	6105                	addi	sp,sp,32
    2702:	8082                	ret
    printf("%s: mkdir 12345678901234 failed\n", s);
    2704:	85a6                	mv	a1,s1
    2706:	00003517          	auipc	a0,0x3
    270a:	7da50513          	addi	a0,a0,2010 # 5ee0 <malloc+0xfec>
    270e:	732020ef          	jal	ra,4e40 <printf>
    exit(1);
    2712:	4505                	li	a0,1
    2714:	320020ef          	jal	ra,4a34 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 failed\n", s);
    2718:	85a6                	mv	a1,s1
    271a:	00004517          	auipc	a0,0x4
    271e:	80e50513          	addi	a0,a0,-2034 # 5f28 <malloc+0x1034>
    2722:	71e020ef          	jal	ra,4e40 <printf>
    exit(1);
    2726:	4505                	li	a0,1
    2728:	30c020ef          	jal	ra,4a34 <exit>
    printf("%s: create 123456789012345/123456789012345/123456789012345 failed\n", s);
    272c:	85a6                	mv	a1,s1
    272e:	00004517          	auipc	a0,0x4
    2732:	86250513          	addi	a0,a0,-1950 # 5f90 <malloc+0x109c>
    2736:	70a020ef          	jal	ra,4e40 <printf>
    exit(1);
    273a:	4505                	li	a0,1
    273c:	2f8020ef          	jal	ra,4a34 <exit>
    printf("%s: open 12345678901234/12345678901234/12345678901234 failed\n", s);
    2740:	85a6                	mv	a1,s1
    2742:	00004517          	auipc	a0,0x4
    2746:	8c650513          	addi	a0,a0,-1850 # 6008 <malloc+0x1114>
    274a:	6f6020ef          	jal	ra,4e40 <printf>
    exit(1);
    274e:	4505                	li	a0,1
    2750:	2e4020ef          	jal	ra,4a34 <exit>
    printf("%s: mkdir 12345678901234/12345678901234 succeeded!\n", s);
    2754:	85a6                	mv	a1,s1
    2756:	00004517          	auipc	a0,0x4
    275a:	91250513          	addi	a0,a0,-1774 # 6068 <malloc+0x1174>
    275e:	6e2020ef          	jal	ra,4e40 <printf>
    exit(1);
    2762:	4505                	li	a0,1
    2764:	2d0020ef          	jal	ra,4a34 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 succeeded!\n", s);
    2768:	85a6                	mv	a1,s1
    276a:	00004517          	auipc	a0,0x4
    276e:	95650513          	addi	a0,a0,-1706 # 60c0 <malloc+0x11cc>
    2772:	6ce020ef          	jal	ra,4e40 <printf>
    exit(1);
    2776:	4505                	li	a0,1
    2778:	2bc020ef          	jal	ra,4a34 <exit>

000000000000277c <diskfull>:
{
    277c:	b8010113          	addi	sp,sp,-1152
    2780:	46113c23          	sd	ra,1144(sp)
    2784:	46813823          	sd	s0,1136(sp)
    2788:	46913423          	sd	s1,1128(sp)
    278c:	47213023          	sd	s2,1120(sp)
    2790:	45313c23          	sd	s3,1112(sp)
    2794:	45413823          	sd	s4,1104(sp)
    2798:	45513423          	sd	s5,1096(sp)
    279c:	45613023          	sd	s6,1088(sp)
    27a0:	43713c23          	sd	s7,1080(sp)
    27a4:	43813823          	sd	s8,1072(sp)
    27a8:	43913423          	sd	s9,1064(sp)
    27ac:	48010413          	addi	s0,sp,1152
    27b0:	8caa                	mv	s9,a0
  unlink("diskfulldir");
    27b2:	00004517          	auipc	a0,0x4
    27b6:	94650513          	addi	a0,a0,-1722 # 60f8 <malloc+0x1204>
    27ba:	2ca020ef          	jal	ra,4a84 <unlink>
    27be:	03000993          	li	s3,48
    name[0] = 'b';
    27c2:	06200b13          	li	s6,98
    name[1] = 'i';
    27c6:	06900a93          	li	s5,105
    name[2] = 'g';
    27ca:	06700a13          	li	s4,103
    27ce:	10c00b93          	li	s7,268
  for(fi = 0; done == 0 && '0' + fi < 0177; fi++){
    27d2:	07f00c13          	li	s8,127
    27d6:	aab9                	j	2934 <diskfull+0x1b8>
      printf("%s: could not create file %s\n", s, name);
    27d8:	b8040613          	addi	a2,s0,-1152
    27dc:	85e6                	mv	a1,s9
    27de:	00004517          	auipc	a0,0x4
    27e2:	92a50513          	addi	a0,a0,-1750 # 6108 <malloc+0x1214>
    27e6:	65a020ef          	jal	ra,4e40 <printf>
      break;
    27ea:	a039                	j	27f8 <diskfull+0x7c>
        close(fd);
    27ec:	854a                	mv	a0,s2
    27ee:	26e020ef          	jal	ra,4a5c <close>
    close(fd);
    27f2:	854a                	mv	a0,s2
    27f4:	268020ef          	jal	ra,4a5c <close>
  for(int i = 0; i < nzz; i++){
    27f8:	4481                	li	s1,0
    name[0] = 'z';
    27fa:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
    27fe:	08000993          	li	s3,128
    name[0] = 'z';
    2802:	bb240023          	sb	s2,-1120(s0)
    name[1] = 'z';
    2806:	bb2400a3          	sb	s2,-1119(s0)
    name[2] = '0' + (i / 32);
    280a:	41f4d71b          	sraiw	a4,s1,0x1f
    280e:	01b7571b          	srliw	a4,a4,0x1b
    2812:	009707bb          	addw	a5,a4,s1
    2816:	4057d69b          	sraiw	a3,a5,0x5
    281a:	0306869b          	addiw	a3,a3,48
    281e:	bad40123          	sb	a3,-1118(s0)
    name[3] = '0' + (i % 32);
    2822:	8bfd                	andi	a5,a5,31
    2824:	9f99                	subw	a5,a5,a4
    2826:	0307879b          	addiw	a5,a5,48
    282a:	baf401a3          	sb	a5,-1117(s0)
    name[4] = '\0';
    282e:	ba040223          	sb	zero,-1116(s0)
    unlink(name);
    2832:	ba040513          	addi	a0,s0,-1120
    2836:	24e020ef          	jal	ra,4a84 <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    283a:	60200593          	li	a1,1538
    283e:	ba040513          	addi	a0,s0,-1120
    2842:	232020ef          	jal	ra,4a74 <open>
    if(fd < 0)
    2846:	00054763          	bltz	a0,2854 <diskfull+0xd8>
    close(fd);
    284a:	212020ef          	jal	ra,4a5c <close>
  for(int i = 0; i < nzz; i++){
    284e:	2485                	addiw	s1,s1,1
    2850:	fb3499e3          	bne	s1,s3,2802 <diskfull+0x86>
  if(mkdir("diskfulldir") == 0)
    2854:	00004517          	auipc	a0,0x4
    2858:	8a450513          	addi	a0,a0,-1884 # 60f8 <malloc+0x1204>
    285c:	240020ef          	jal	ra,4a9c <mkdir>
    2860:	12050063          	beqz	a0,2980 <diskfull+0x204>
  unlink("diskfulldir");
    2864:	00004517          	auipc	a0,0x4
    2868:	89450513          	addi	a0,a0,-1900 # 60f8 <malloc+0x1204>
    286c:	218020ef          	jal	ra,4a84 <unlink>
  for(int i = 0; i < nzz; i++){
    2870:	4481                	li	s1,0
    name[0] = 'z';
    2872:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
    2876:	08000993          	li	s3,128
    name[0] = 'z';
    287a:	bb240023          	sb	s2,-1120(s0)
    name[1] = 'z';
    287e:	bb2400a3          	sb	s2,-1119(s0)
    name[2] = '0' + (i / 32);
    2882:	41f4d71b          	sraiw	a4,s1,0x1f
    2886:	01b7571b          	srliw	a4,a4,0x1b
    288a:	009707bb          	addw	a5,a4,s1
    288e:	4057d69b          	sraiw	a3,a5,0x5
    2892:	0306869b          	addiw	a3,a3,48
    2896:	bad40123          	sb	a3,-1118(s0)
    name[3] = '0' + (i % 32);
    289a:	8bfd                	andi	a5,a5,31
    289c:	9f99                	subw	a5,a5,a4
    289e:	0307879b          	addiw	a5,a5,48
    28a2:	baf401a3          	sb	a5,-1117(s0)
    name[4] = '\0';
    28a6:	ba040223          	sb	zero,-1116(s0)
    unlink(name);
    28aa:	ba040513          	addi	a0,s0,-1120
    28ae:	1d6020ef          	jal	ra,4a84 <unlink>
  for(int i = 0; i < nzz; i++){
    28b2:	2485                	addiw	s1,s1,1
    28b4:	fd3493e3          	bne	s1,s3,287a <diskfull+0xfe>
    28b8:	03000493          	li	s1,48
    name[0] = 'b';
    28bc:	06200a93          	li	s5,98
    name[1] = 'i';
    28c0:	06900a13          	li	s4,105
    name[2] = 'g';
    28c4:	06700993          	li	s3,103
  for(int i = 0; '0' + i < 0177; i++){
    28c8:	07f00913          	li	s2,127
    name[0] = 'b';
    28cc:	bb540023          	sb	s5,-1120(s0)
    name[1] = 'i';
    28d0:	bb4400a3          	sb	s4,-1119(s0)
    name[2] = 'g';
    28d4:	bb340123          	sb	s3,-1118(s0)
    name[3] = '0' + i;
    28d8:	ba9401a3          	sb	s1,-1117(s0)
    name[4] = '\0';
    28dc:	ba040223          	sb	zero,-1116(s0)
    unlink(name);
    28e0:	ba040513          	addi	a0,s0,-1120
    28e4:	1a0020ef          	jal	ra,4a84 <unlink>
  for(int i = 0; '0' + i < 0177; i++){
    28e8:	2485                	addiw	s1,s1,1
    28ea:	0ff4f493          	zext.b	s1,s1
    28ee:	fd249fe3          	bne	s1,s2,28cc <diskfull+0x150>
}
    28f2:	47813083          	ld	ra,1144(sp)
    28f6:	47013403          	ld	s0,1136(sp)
    28fa:	46813483          	ld	s1,1128(sp)
    28fe:	46013903          	ld	s2,1120(sp)
    2902:	45813983          	ld	s3,1112(sp)
    2906:	45013a03          	ld	s4,1104(sp)
    290a:	44813a83          	ld	s5,1096(sp)
    290e:	44013b03          	ld	s6,1088(sp)
    2912:	43813b83          	ld	s7,1080(sp)
    2916:	43013c03          	ld	s8,1072(sp)
    291a:	42813c83          	ld	s9,1064(sp)
    291e:	48010113          	addi	sp,sp,1152
    2922:	8082                	ret
    close(fd);
    2924:	854a                	mv	a0,s2
    2926:	136020ef          	jal	ra,4a5c <close>
  for(fi = 0; done == 0 && '0' + fi < 0177; fi++){
    292a:	2985                	addiw	s3,s3,1
    292c:	0ff9f993          	zext.b	s3,s3
    2930:	ed8984e3          	beq	s3,s8,27f8 <diskfull+0x7c>
    name[0] = 'b';
    2934:	b9640023          	sb	s6,-1152(s0)
    name[1] = 'i';
    2938:	b95400a3          	sb	s5,-1151(s0)
    name[2] = 'g';
    293c:	b9440123          	sb	s4,-1150(s0)
    name[3] = '0' + fi;
    2940:	b93401a3          	sb	s3,-1149(s0)
    name[4] = '\0';
    2944:	b8040223          	sb	zero,-1148(s0)
    unlink(name);
    2948:	b8040513          	addi	a0,s0,-1152
    294c:	138020ef          	jal	ra,4a84 <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    2950:	60200593          	li	a1,1538
    2954:	b8040513          	addi	a0,s0,-1152
    2958:	11c020ef          	jal	ra,4a74 <open>
    295c:	892a                	mv	s2,a0
    if(fd < 0){
    295e:	e6054de3          	bltz	a0,27d8 <diskfull+0x5c>
    2962:	84de                	mv	s1,s7
      if(write(fd, buf, BSIZE) != BSIZE){
    2964:	40000613          	li	a2,1024
    2968:	ba040593          	addi	a1,s0,-1120
    296c:	854a                	mv	a0,s2
    296e:	0e6020ef          	jal	ra,4a54 <write>
    2972:	40000793          	li	a5,1024
    2976:	e6f51be3          	bne	a0,a5,27ec <diskfull+0x70>
    for(int i = 0; i < MAXFILE; i++){
    297a:	34fd                	addiw	s1,s1,-1
    297c:	f4e5                	bnez	s1,2964 <diskfull+0x1e8>
    297e:	b75d                	j	2924 <diskfull+0x1a8>
    printf("%s: mkdir(diskfulldir) unexpectedly succeeded!\n", s);
    2980:	85e6                	mv	a1,s9
    2982:	00003517          	auipc	a0,0x3
    2986:	7a650513          	addi	a0,a0,1958 # 6128 <malloc+0x1234>
    298a:	4b6020ef          	jal	ra,4e40 <printf>
    298e:	bdd9                	j	2864 <diskfull+0xe8>

0000000000002990 <iputtest>:
{
    2990:	1101                	addi	sp,sp,-32
    2992:	ec06                	sd	ra,24(sp)
    2994:	e822                	sd	s0,16(sp)
    2996:	e426                	sd	s1,8(sp)
    2998:	1000                	addi	s0,sp,32
    299a:	84aa                	mv	s1,a0
  if(mkdir("iputdir") < 0){
    299c:	00003517          	auipc	a0,0x3
    29a0:	7bc50513          	addi	a0,a0,1980 # 6158 <malloc+0x1264>
    29a4:	0f8020ef          	jal	ra,4a9c <mkdir>
    29a8:	02054f63          	bltz	a0,29e6 <iputtest+0x56>
  if(chdir("iputdir") < 0){
    29ac:	00003517          	auipc	a0,0x3
    29b0:	7ac50513          	addi	a0,a0,1964 # 6158 <malloc+0x1264>
    29b4:	0f0020ef          	jal	ra,4aa4 <chdir>
    29b8:	04054163          	bltz	a0,29fa <iputtest+0x6a>
  if(unlink("../iputdir") < 0){
    29bc:	00003517          	auipc	a0,0x3
    29c0:	7dc50513          	addi	a0,a0,2012 # 6198 <malloc+0x12a4>
    29c4:	0c0020ef          	jal	ra,4a84 <unlink>
    29c8:	04054363          	bltz	a0,2a0e <iputtest+0x7e>
  if(chdir("/") < 0){
    29cc:	00003517          	auipc	a0,0x3
    29d0:	7fc50513          	addi	a0,a0,2044 # 61c8 <malloc+0x12d4>
    29d4:	0d0020ef          	jal	ra,4aa4 <chdir>
    29d8:	04054563          	bltz	a0,2a22 <iputtest+0x92>
}
    29dc:	60e2                	ld	ra,24(sp)
    29de:	6442                	ld	s0,16(sp)
    29e0:	64a2                	ld	s1,8(sp)
    29e2:	6105                	addi	sp,sp,32
    29e4:	8082                	ret
    printf("%s: mkdir failed\n", s);
    29e6:	85a6                	mv	a1,s1
    29e8:	00003517          	auipc	a0,0x3
    29ec:	77850513          	addi	a0,a0,1912 # 6160 <malloc+0x126c>
    29f0:	450020ef          	jal	ra,4e40 <printf>
    exit(1);
    29f4:	4505                	li	a0,1
    29f6:	03e020ef          	jal	ra,4a34 <exit>
    printf("%s: chdir iputdir failed\n", s);
    29fa:	85a6                	mv	a1,s1
    29fc:	00003517          	auipc	a0,0x3
    2a00:	77c50513          	addi	a0,a0,1916 # 6178 <malloc+0x1284>
    2a04:	43c020ef          	jal	ra,4e40 <printf>
    exit(1);
    2a08:	4505                	li	a0,1
    2a0a:	02a020ef          	jal	ra,4a34 <exit>
    printf("%s: unlink ../iputdir failed\n", s);
    2a0e:	85a6                	mv	a1,s1
    2a10:	00003517          	auipc	a0,0x3
    2a14:	79850513          	addi	a0,a0,1944 # 61a8 <malloc+0x12b4>
    2a18:	428020ef          	jal	ra,4e40 <printf>
    exit(1);
    2a1c:	4505                	li	a0,1
    2a1e:	016020ef          	jal	ra,4a34 <exit>
    printf("%s: chdir / failed\n", s);
    2a22:	85a6                	mv	a1,s1
    2a24:	00003517          	auipc	a0,0x3
    2a28:	7ac50513          	addi	a0,a0,1964 # 61d0 <malloc+0x12dc>
    2a2c:	414020ef          	jal	ra,4e40 <printf>
    exit(1);
    2a30:	4505                	li	a0,1
    2a32:	002020ef          	jal	ra,4a34 <exit>

0000000000002a36 <exitiputtest>:
{
    2a36:	7179                	addi	sp,sp,-48
    2a38:	f406                	sd	ra,40(sp)
    2a3a:	f022                	sd	s0,32(sp)
    2a3c:	ec26                	sd	s1,24(sp)
    2a3e:	1800                	addi	s0,sp,48
    2a40:	84aa                	mv	s1,a0
  pid = fork();
    2a42:	7eb010ef          	jal	ra,4a2c <fork>
  if(pid < 0){
    2a46:	02054e63          	bltz	a0,2a82 <exitiputtest+0x4c>
  if(pid == 0){
    2a4a:	e541                	bnez	a0,2ad2 <exitiputtest+0x9c>
    if(mkdir("iputdir") < 0){
    2a4c:	00003517          	auipc	a0,0x3
    2a50:	70c50513          	addi	a0,a0,1804 # 6158 <malloc+0x1264>
    2a54:	048020ef          	jal	ra,4a9c <mkdir>
    2a58:	02054f63          	bltz	a0,2a96 <exitiputtest+0x60>
    if(chdir("iputdir") < 0){
    2a5c:	00003517          	auipc	a0,0x3
    2a60:	6fc50513          	addi	a0,a0,1788 # 6158 <malloc+0x1264>
    2a64:	040020ef          	jal	ra,4aa4 <chdir>
    2a68:	04054163          	bltz	a0,2aaa <exitiputtest+0x74>
    if(unlink("../iputdir") < 0){
    2a6c:	00003517          	auipc	a0,0x3
    2a70:	72c50513          	addi	a0,a0,1836 # 6198 <malloc+0x12a4>
    2a74:	010020ef          	jal	ra,4a84 <unlink>
    2a78:	04054363          	bltz	a0,2abe <exitiputtest+0x88>
    exit(0);
    2a7c:	4501                	li	a0,0
    2a7e:	7b7010ef          	jal	ra,4a34 <exit>
    printf("%s: fork failed\n", s);
    2a82:	85a6                	mv	a1,s1
    2a84:	00003517          	auipc	a0,0x3
    2a88:	e2450513          	addi	a0,a0,-476 # 58a8 <malloc+0x9b4>
    2a8c:	3b4020ef          	jal	ra,4e40 <printf>
    exit(1);
    2a90:	4505                	li	a0,1
    2a92:	7a3010ef          	jal	ra,4a34 <exit>
      printf("%s: mkdir failed\n", s);
    2a96:	85a6                	mv	a1,s1
    2a98:	00003517          	auipc	a0,0x3
    2a9c:	6c850513          	addi	a0,a0,1736 # 6160 <malloc+0x126c>
    2aa0:	3a0020ef          	jal	ra,4e40 <printf>
      exit(1);
    2aa4:	4505                	li	a0,1
    2aa6:	78f010ef          	jal	ra,4a34 <exit>
      printf("%s: child chdir failed\n", s);
    2aaa:	85a6                	mv	a1,s1
    2aac:	00003517          	auipc	a0,0x3
    2ab0:	73c50513          	addi	a0,a0,1852 # 61e8 <malloc+0x12f4>
    2ab4:	38c020ef          	jal	ra,4e40 <printf>
      exit(1);
    2ab8:	4505                	li	a0,1
    2aba:	77b010ef          	jal	ra,4a34 <exit>
      printf("%s: unlink ../iputdir failed\n", s);
    2abe:	85a6                	mv	a1,s1
    2ac0:	00003517          	auipc	a0,0x3
    2ac4:	6e850513          	addi	a0,a0,1768 # 61a8 <malloc+0x12b4>
    2ac8:	378020ef          	jal	ra,4e40 <printf>
      exit(1);
    2acc:	4505                	li	a0,1
    2ace:	767010ef          	jal	ra,4a34 <exit>
  wait(&xstatus);
    2ad2:	fdc40513          	addi	a0,s0,-36
    2ad6:	767010ef          	jal	ra,4a3c <wait>
  exit(xstatus);
    2ada:	fdc42503          	lw	a0,-36(s0)
    2ade:	757010ef          	jal	ra,4a34 <exit>

0000000000002ae2 <dirtest>:
{
    2ae2:	1101                	addi	sp,sp,-32
    2ae4:	ec06                	sd	ra,24(sp)
    2ae6:	e822                	sd	s0,16(sp)
    2ae8:	e426                	sd	s1,8(sp)
    2aea:	1000                	addi	s0,sp,32
    2aec:	84aa                	mv	s1,a0
  if(mkdir("dir0") < 0){
    2aee:	00003517          	auipc	a0,0x3
    2af2:	71250513          	addi	a0,a0,1810 # 6200 <malloc+0x130c>
    2af6:	7a7010ef          	jal	ra,4a9c <mkdir>
    2afa:	02054f63          	bltz	a0,2b38 <dirtest+0x56>
  if(chdir("dir0") < 0){
    2afe:	00003517          	auipc	a0,0x3
    2b02:	70250513          	addi	a0,a0,1794 # 6200 <malloc+0x130c>
    2b06:	79f010ef          	jal	ra,4aa4 <chdir>
    2b0a:	04054163          	bltz	a0,2b4c <dirtest+0x6a>
  if(chdir("..") < 0){
    2b0e:	00003517          	auipc	a0,0x3
    2b12:	71250513          	addi	a0,a0,1810 # 6220 <malloc+0x132c>
    2b16:	78f010ef          	jal	ra,4aa4 <chdir>
    2b1a:	04054363          	bltz	a0,2b60 <dirtest+0x7e>
  if(unlink("dir0") < 0){
    2b1e:	00003517          	auipc	a0,0x3
    2b22:	6e250513          	addi	a0,a0,1762 # 6200 <malloc+0x130c>
    2b26:	75f010ef          	jal	ra,4a84 <unlink>
    2b2a:	04054563          	bltz	a0,2b74 <dirtest+0x92>
}
    2b2e:	60e2                	ld	ra,24(sp)
    2b30:	6442                	ld	s0,16(sp)
    2b32:	64a2                	ld	s1,8(sp)
    2b34:	6105                	addi	sp,sp,32
    2b36:	8082                	ret
    printf("%s: mkdir failed\n", s);
    2b38:	85a6                	mv	a1,s1
    2b3a:	00003517          	auipc	a0,0x3
    2b3e:	62650513          	addi	a0,a0,1574 # 6160 <malloc+0x126c>
    2b42:	2fe020ef          	jal	ra,4e40 <printf>
    exit(1);
    2b46:	4505                	li	a0,1
    2b48:	6ed010ef          	jal	ra,4a34 <exit>
    printf("%s: chdir dir0 failed\n", s);
    2b4c:	85a6                	mv	a1,s1
    2b4e:	00003517          	auipc	a0,0x3
    2b52:	6ba50513          	addi	a0,a0,1722 # 6208 <malloc+0x1314>
    2b56:	2ea020ef          	jal	ra,4e40 <printf>
    exit(1);
    2b5a:	4505                	li	a0,1
    2b5c:	6d9010ef          	jal	ra,4a34 <exit>
    printf("%s: chdir .. failed\n", s);
    2b60:	85a6                	mv	a1,s1
    2b62:	00003517          	auipc	a0,0x3
    2b66:	6c650513          	addi	a0,a0,1734 # 6228 <malloc+0x1334>
    2b6a:	2d6020ef          	jal	ra,4e40 <printf>
    exit(1);
    2b6e:	4505                	li	a0,1
    2b70:	6c5010ef          	jal	ra,4a34 <exit>
    printf("%s: unlink dir0 failed\n", s);
    2b74:	85a6                	mv	a1,s1
    2b76:	00003517          	auipc	a0,0x3
    2b7a:	6ca50513          	addi	a0,a0,1738 # 6240 <malloc+0x134c>
    2b7e:	2c2020ef          	jal	ra,4e40 <printf>
    exit(1);
    2b82:	4505                	li	a0,1
    2b84:	6b1010ef          	jal	ra,4a34 <exit>

0000000000002b88 <subdir>:
{
    2b88:	1101                	addi	sp,sp,-32
    2b8a:	ec06                	sd	ra,24(sp)
    2b8c:	e822                	sd	s0,16(sp)
    2b8e:	e426                	sd	s1,8(sp)
    2b90:	e04a                	sd	s2,0(sp)
    2b92:	1000                	addi	s0,sp,32
    2b94:	892a                	mv	s2,a0
  unlink("ff");
    2b96:	00003517          	auipc	a0,0x3
    2b9a:	7f250513          	addi	a0,a0,2034 # 6388 <malloc+0x1494>
    2b9e:	6e7010ef          	jal	ra,4a84 <unlink>
  if(mkdir("dd") != 0){
    2ba2:	00003517          	auipc	a0,0x3
    2ba6:	6b650513          	addi	a0,a0,1718 # 6258 <malloc+0x1364>
    2baa:	6f3010ef          	jal	ra,4a9c <mkdir>
    2bae:	2e051263          	bnez	a0,2e92 <subdir+0x30a>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    2bb2:	20200593          	li	a1,514
    2bb6:	00003517          	auipc	a0,0x3
    2bba:	6c250513          	addi	a0,a0,1730 # 6278 <malloc+0x1384>
    2bbe:	6b7010ef          	jal	ra,4a74 <open>
    2bc2:	84aa                	mv	s1,a0
  if(fd < 0){
    2bc4:	2e054163          	bltz	a0,2ea6 <subdir+0x31e>
  write(fd, "ff", 2);
    2bc8:	4609                	li	a2,2
    2bca:	00003597          	auipc	a1,0x3
    2bce:	7be58593          	addi	a1,a1,1982 # 6388 <malloc+0x1494>
    2bd2:	683010ef          	jal	ra,4a54 <write>
  close(fd);
    2bd6:	8526                	mv	a0,s1
    2bd8:	685010ef          	jal	ra,4a5c <close>
  if(unlink("dd") >= 0){
    2bdc:	00003517          	auipc	a0,0x3
    2be0:	67c50513          	addi	a0,a0,1660 # 6258 <malloc+0x1364>
    2be4:	6a1010ef          	jal	ra,4a84 <unlink>
    2be8:	2c055963          	bgez	a0,2eba <subdir+0x332>
  if(mkdir("/dd/dd") != 0){
    2bec:	00003517          	auipc	a0,0x3
    2bf0:	6e450513          	addi	a0,a0,1764 # 62d0 <malloc+0x13dc>
    2bf4:	6a9010ef          	jal	ra,4a9c <mkdir>
    2bf8:	2c051b63          	bnez	a0,2ece <subdir+0x346>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    2bfc:	20200593          	li	a1,514
    2c00:	00003517          	auipc	a0,0x3
    2c04:	6f850513          	addi	a0,a0,1784 # 62f8 <malloc+0x1404>
    2c08:	66d010ef          	jal	ra,4a74 <open>
    2c0c:	84aa                	mv	s1,a0
  if(fd < 0){
    2c0e:	2c054a63          	bltz	a0,2ee2 <subdir+0x35a>
  write(fd, "FF", 2);
    2c12:	4609                	li	a2,2
    2c14:	00003597          	auipc	a1,0x3
    2c18:	71458593          	addi	a1,a1,1812 # 6328 <malloc+0x1434>
    2c1c:	639010ef          	jal	ra,4a54 <write>
  close(fd);
    2c20:	8526                	mv	a0,s1
    2c22:	63b010ef          	jal	ra,4a5c <close>
  fd = open("dd/dd/../ff", 0);
    2c26:	4581                	li	a1,0
    2c28:	00003517          	auipc	a0,0x3
    2c2c:	70850513          	addi	a0,a0,1800 # 6330 <malloc+0x143c>
    2c30:	645010ef          	jal	ra,4a74 <open>
    2c34:	84aa                	mv	s1,a0
  if(fd < 0){
    2c36:	2c054063          	bltz	a0,2ef6 <subdir+0x36e>
  cc = read(fd, buf, sizeof(buf));
    2c3a:	660d                	lui	a2,0x3
    2c3c:	00009597          	auipc	a1,0x9
    2c40:	03c58593          	addi	a1,a1,60 # bc78 <buf>
    2c44:	609010ef          	jal	ra,4a4c <read>
  if(cc != 2 || buf[0] != 'f'){
    2c48:	4789                	li	a5,2
    2c4a:	2cf51063          	bne	a0,a5,2f0a <subdir+0x382>
    2c4e:	00009717          	auipc	a4,0x9
    2c52:	02a74703          	lbu	a4,42(a4) # bc78 <buf>
    2c56:	06600793          	li	a5,102
    2c5a:	2af71863          	bne	a4,a5,2f0a <subdir+0x382>
  close(fd);
    2c5e:	8526                	mv	a0,s1
    2c60:	5fd010ef          	jal	ra,4a5c <close>
  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    2c64:	00003597          	auipc	a1,0x3
    2c68:	71c58593          	addi	a1,a1,1820 # 6380 <malloc+0x148c>
    2c6c:	00003517          	auipc	a0,0x3
    2c70:	68c50513          	addi	a0,a0,1676 # 62f8 <malloc+0x1404>
    2c74:	621010ef          	jal	ra,4a94 <link>
    2c78:	2a051363          	bnez	a0,2f1e <subdir+0x396>
  if(unlink("dd/dd/ff") != 0){
    2c7c:	00003517          	auipc	a0,0x3
    2c80:	67c50513          	addi	a0,a0,1660 # 62f8 <malloc+0x1404>
    2c84:	601010ef          	jal	ra,4a84 <unlink>
    2c88:	2a051563          	bnez	a0,2f32 <subdir+0x3aa>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    2c8c:	4581                	li	a1,0
    2c8e:	00003517          	auipc	a0,0x3
    2c92:	66a50513          	addi	a0,a0,1642 # 62f8 <malloc+0x1404>
    2c96:	5df010ef          	jal	ra,4a74 <open>
    2c9a:	2a055663          	bgez	a0,2f46 <subdir+0x3be>
  if(chdir("dd") != 0){
    2c9e:	00003517          	auipc	a0,0x3
    2ca2:	5ba50513          	addi	a0,a0,1466 # 6258 <malloc+0x1364>
    2ca6:	5ff010ef          	jal	ra,4aa4 <chdir>
    2caa:	2a051863          	bnez	a0,2f5a <subdir+0x3d2>
  if(chdir("dd/../../dd") != 0){
    2cae:	00003517          	auipc	a0,0x3
    2cb2:	76a50513          	addi	a0,a0,1898 # 6418 <malloc+0x1524>
    2cb6:	5ef010ef          	jal	ra,4aa4 <chdir>
    2cba:	2a051a63          	bnez	a0,2f6e <subdir+0x3e6>
  if(chdir("dd/../../../dd") != 0){
    2cbe:	00003517          	auipc	a0,0x3
    2cc2:	78a50513          	addi	a0,a0,1930 # 6448 <malloc+0x1554>
    2cc6:	5df010ef          	jal	ra,4aa4 <chdir>
    2cca:	2a051c63          	bnez	a0,2f82 <subdir+0x3fa>
  if(chdir("./..") != 0){
    2cce:	00003517          	auipc	a0,0x3
    2cd2:	7b250513          	addi	a0,a0,1970 # 6480 <malloc+0x158c>
    2cd6:	5cf010ef          	jal	ra,4aa4 <chdir>
    2cda:	2a051e63          	bnez	a0,2f96 <subdir+0x40e>
  fd = open("dd/dd/ffff", 0);
    2cde:	4581                	li	a1,0
    2ce0:	00003517          	auipc	a0,0x3
    2ce4:	6a050513          	addi	a0,a0,1696 # 6380 <malloc+0x148c>
    2ce8:	58d010ef          	jal	ra,4a74 <open>
    2cec:	84aa                	mv	s1,a0
  if(fd < 0){
    2cee:	2a054e63          	bltz	a0,2faa <subdir+0x422>
  if(read(fd, buf, sizeof(buf)) != 2){
    2cf2:	660d                	lui	a2,0x3
    2cf4:	00009597          	auipc	a1,0x9
    2cf8:	f8458593          	addi	a1,a1,-124 # bc78 <buf>
    2cfc:	551010ef          	jal	ra,4a4c <read>
    2d00:	4789                	li	a5,2
    2d02:	2af51e63          	bne	a0,a5,2fbe <subdir+0x436>
  close(fd);
    2d06:	8526                	mv	a0,s1
    2d08:	555010ef          	jal	ra,4a5c <close>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    2d0c:	4581                	li	a1,0
    2d0e:	00003517          	auipc	a0,0x3
    2d12:	5ea50513          	addi	a0,a0,1514 # 62f8 <malloc+0x1404>
    2d16:	55f010ef          	jal	ra,4a74 <open>
    2d1a:	2a055c63          	bgez	a0,2fd2 <subdir+0x44a>
  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    2d1e:	20200593          	li	a1,514
    2d22:	00003517          	auipc	a0,0x3
    2d26:	7ee50513          	addi	a0,a0,2030 # 6510 <malloc+0x161c>
    2d2a:	54b010ef          	jal	ra,4a74 <open>
    2d2e:	2a055c63          	bgez	a0,2fe6 <subdir+0x45e>
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    2d32:	20200593          	li	a1,514
    2d36:	00004517          	auipc	a0,0x4
    2d3a:	80a50513          	addi	a0,a0,-2038 # 6540 <malloc+0x164c>
    2d3e:	537010ef          	jal	ra,4a74 <open>
    2d42:	2a055c63          	bgez	a0,2ffa <subdir+0x472>
  if(open("dd", O_CREATE) >= 0){
    2d46:	20000593          	li	a1,512
    2d4a:	00003517          	auipc	a0,0x3
    2d4e:	50e50513          	addi	a0,a0,1294 # 6258 <malloc+0x1364>
    2d52:	523010ef          	jal	ra,4a74 <open>
    2d56:	2a055c63          	bgez	a0,300e <subdir+0x486>
  if(open("dd", O_RDWR) >= 0){
    2d5a:	4589                	li	a1,2
    2d5c:	00003517          	auipc	a0,0x3
    2d60:	4fc50513          	addi	a0,a0,1276 # 6258 <malloc+0x1364>
    2d64:	511010ef          	jal	ra,4a74 <open>
    2d68:	2a055d63          	bgez	a0,3022 <subdir+0x49a>
  if(open("dd", O_WRONLY) >= 0){
    2d6c:	4585                	li	a1,1
    2d6e:	00003517          	auipc	a0,0x3
    2d72:	4ea50513          	addi	a0,a0,1258 # 6258 <malloc+0x1364>
    2d76:	4ff010ef          	jal	ra,4a74 <open>
    2d7a:	2a055e63          	bgez	a0,3036 <subdir+0x4ae>
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    2d7e:	00004597          	auipc	a1,0x4
    2d82:	85258593          	addi	a1,a1,-1966 # 65d0 <malloc+0x16dc>
    2d86:	00003517          	auipc	a0,0x3
    2d8a:	78a50513          	addi	a0,a0,1930 # 6510 <malloc+0x161c>
    2d8e:	507010ef          	jal	ra,4a94 <link>
    2d92:	2a050c63          	beqz	a0,304a <subdir+0x4c2>
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    2d96:	00004597          	auipc	a1,0x4
    2d9a:	83a58593          	addi	a1,a1,-1990 # 65d0 <malloc+0x16dc>
    2d9e:	00003517          	auipc	a0,0x3
    2da2:	7a250513          	addi	a0,a0,1954 # 6540 <malloc+0x164c>
    2da6:	4ef010ef          	jal	ra,4a94 <link>
    2daa:	2a050a63          	beqz	a0,305e <subdir+0x4d6>
  if(link("dd/ff", "dd/dd/ffff") == 0){
    2dae:	00003597          	auipc	a1,0x3
    2db2:	5d258593          	addi	a1,a1,1490 # 6380 <malloc+0x148c>
    2db6:	00003517          	auipc	a0,0x3
    2dba:	4c250513          	addi	a0,a0,1218 # 6278 <malloc+0x1384>
    2dbe:	4d7010ef          	jal	ra,4a94 <link>
    2dc2:	2a050863          	beqz	a0,3072 <subdir+0x4ea>
  if(mkdir("dd/ff/ff") == 0){
    2dc6:	00003517          	auipc	a0,0x3
    2dca:	74a50513          	addi	a0,a0,1866 # 6510 <malloc+0x161c>
    2dce:	4cf010ef          	jal	ra,4a9c <mkdir>
    2dd2:	2a050a63          	beqz	a0,3086 <subdir+0x4fe>
  if(mkdir("dd/xx/ff") == 0){
    2dd6:	00003517          	auipc	a0,0x3
    2dda:	76a50513          	addi	a0,a0,1898 # 6540 <malloc+0x164c>
    2dde:	4bf010ef          	jal	ra,4a9c <mkdir>
    2de2:	2a050c63          	beqz	a0,309a <subdir+0x512>
  if(mkdir("dd/dd/ffff") == 0){
    2de6:	00003517          	auipc	a0,0x3
    2dea:	59a50513          	addi	a0,a0,1434 # 6380 <malloc+0x148c>
    2dee:	4af010ef          	jal	ra,4a9c <mkdir>
    2df2:	2a050e63          	beqz	a0,30ae <subdir+0x526>
  if(unlink("dd/xx/ff") == 0){
    2df6:	00003517          	auipc	a0,0x3
    2dfa:	74a50513          	addi	a0,a0,1866 # 6540 <malloc+0x164c>
    2dfe:	487010ef          	jal	ra,4a84 <unlink>
    2e02:	2c050063          	beqz	a0,30c2 <subdir+0x53a>
  if(unlink("dd/ff/ff") == 0){
    2e06:	00003517          	auipc	a0,0x3
    2e0a:	70a50513          	addi	a0,a0,1802 # 6510 <malloc+0x161c>
    2e0e:	477010ef          	jal	ra,4a84 <unlink>
    2e12:	2c050263          	beqz	a0,30d6 <subdir+0x54e>
  if(chdir("dd/ff") == 0){
    2e16:	00003517          	auipc	a0,0x3
    2e1a:	46250513          	addi	a0,a0,1122 # 6278 <malloc+0x1384>
    2e1e:	487010ef          	jal	ra,4aa4 <chdir>
    2e22:	2c050463          	beqz	a0,30ea <subdir+0x562>
  if(chdir("dd/xx") == 0){
    2e26:	00004517          	auipc	a0,0x4
    2e2a:	8fa50513          	addi	a0,a0,-1798 # 6720 <malloc+0x182c>
    2e2e:	477010ef          	jal	ra,4aa4 <chdir>
    2e32:	2c050663          	beqz	a0,30fe <subdir+0x576>
  if(unlink("dd/dd/ffff") != 0){
    2e36:	00003517          	auipc	a0,0x3
    2e3a:	54a50513          	addi	a0,a0,1354 # 6380 <malloc+0x148c>
    2e3e:	447010ef          	jal	ra,4a84 <unlink>
    2e42:	2c051863          	bnez	a0,3112 <subdir+0x58a>
  if(unlink("dd/ff") != 0){
    2e46:	00003517          	auipc	a0,0x3
    2e4a:	43250513          	addi	a0,a0,1074 # 6278 <malloc+0x1384>
    2e4e:	437010ef          	jal	ra,4a84 <unlink>
    2e52:	2c051a63          	bnez	a0,3126 <subdir+0x59e>
  if(unlink("dd") == 0){
    2e56:	00003517          	auipc	a0,0x3
    2e5a:	40250513          	addi	a0,a0,1026 # 6258 <malloc+0x1364>
    2e5e:	427010ef          	jal	ra,4a84 <unlink>
    2e62:	2c050c63          	beqz	a0,313a <subdir+0x5b2>
  if(unlink("dd/dd") < 0){
    2e66:	00004517          	auipc	a0,0x4
    2e6a:	92a50513          	addi	a0,a0,-1750 # 6790 <malloc+0x189c>
    2e6e:	417010ef          	jal	ra,4a84 <unlink>
    2e72:	2c054e63          	bltz	a0,314e <subdir+0x5c6>
  if(unlink("dd") < 0){
    2e76:	00003517          	auipc	a0,0x3
    2e7a:	3e250513          	addi	a0,a0,994 # 6258 <malloc+0x1364>
    2e7e:	407010ef          	jal	ra,4a84 <unlink>
    2e82:	2e054063          	bltz	a0,3162 <subdir+0x5da>
}
    2e86:	60e2                	ld	ra,24(sp)
    2e88:	6442                	ld	s0,16(sp)
    2e8a:	64a2                	ld	s1,8(sp)
    2e8c:	6902                	ld	s2,0(sp)
    2e8e:	6105                	addi	sp,sp,32
    2e90:	8082                	ret
    printf("%s: mkdir dd failed\n", s);
    2e92:	85ca                	mv	a1,s2
    2e94:	00003517          	auipc	a0,0x3
    2e98:	3cc50513          	addi	a0,a0,972 # 6260 <malloc+0x136c>
    2e9c:	7a5010ef          	jal	ra,4e40 <printf>
    exit(1);
    2ea0:	4505                	li	a0,1
    2ea2:	393010ef          	jal	ra,4a34 <exit>
    printf("%s: create dd/ff failed\n", s);
    2ea6:	85ca                	mv	a1,s2
    2ea8:	00003517          	auipc	a0,0x3
    2eac:	3d850513          	addi	a0,a0,984 # 6280 <malloc+0x138c>
    2eb0:	791010ef          	jal	ra,4e40 <printf>
    exit(1);
    2eb4:	4505                	li	a0,1
    2eb6:	37f010ef          	jal	ra,4a34 <exit>
    printf("%s: unlink dd (non-empty dir) succeeded!\n", s);
    2eba:	85ca                	mv	a1,s2
    2ebc:	00003517          	auipc	a0,0x3
    2ec0:	3e450513          	addi	a0,a0,996 # 62a0 <malloc+0x13ac>
    2ec4:	77d010ef          	jal	ra,4e40 <printf>
    exit(1);
    2ec8:	4505                	li	a0,1
    2eca:	36b010ef          	jal	ra,4a34 <exit>
    printf("%s: subdir mkdir dd/dd failed\n", s);
    2ece:	85ca                	mv	a1,s2
    2ed0:	00003517          	auipc	a0,0x3
    2ed4:	40850513          	addi	a0,a0,1032 # 62d8 <malloc+0x13e4>
    2ed8:	769010ef          	jal	ra,4e40 <printf>
    exit(1);
    2edc:	4505                	li	a0,1
    2ede:	357010ef          	jal	ra,4a34 <exit>
    printf("%s: create dd/dd/ff failed\n", s);
    2ee2:	85ca                	mv	a1,s2
    2ee4:	00003517          	auipc	a0,0x3
    2ee8:	42450513          	addi	a0,a0,1060 # 6308 <malloc+0x1414>
    2eec:	755010ef          	jal	ra,4e40 <printf>
    exit(1);
    2ef0:	4505                	li	a0,1
    2ef2:	343010ef          	jal	ra,4a34 <exit>
    printf("%s: open dd/dd/../ff failed\n", s);
    2ef6:	85ca                	mv	a1,s2
    2ef8:	00003517          	auipc	a0,0x3
    2efc:	44850513          	addi	a0,a0,1096 # 6340 <malloc+0x144c>
    2f00:	741010ef          	jal	ra,4e40 <printf>
    exit(1);
    2f04:	4505                	li	a0,1
    2f06:	32f010ef          	jal	ra,4a34 <exit>
    printf("%s: dd/dd/../ff wrong content\n", s);
    2f0a:	85ca                	mv	a1,s2
    2f0c:	00003517          	auipc	a0,0x3
    2f10:	45450513          	addi	a0,a0,1108 # 6360 <malloc+0x146c>
    2f14:	72d010ef          	jal	ra,4e40 <printf>
    exit(1);
    2f18:	4505                	li	a0,1
    2f1a:	31b010ef          	jal	ra,4a34 <exit>
    printf("%s: link dd/dd/ff dd/dd/ffff failed\n", s);
    2f1e:	85ca                	mv	a1,s2
    2f20:	00003517          	auipc	a0,0x3
    2f24:	47050513          	addi	a0,a0,1136 # 6390 <malloc+0x149c>
    2f28:	719010ef          	jal	ra,4e40 <printf>
    exit(1);
    2f2c:	4505                	li	a0,1
    2f2e:	307010ef          	jal	ra,4a34 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    2f32:	85ca                	mv	a1,s2
    2f34:	00003517          	auipc	a0,0x3
    2f38:	48450513          	addi	a0,a0,1156 # 63b8 <malloc+0x14c4>
    2f3c:	705010ef          	jal	ra,4e40 <printf>
    exit(1);
    2f40:	4505                	li	a0,1
    2f42:	2f3010ef          	jal	ra,4a34 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded\n", s);
    2f46:	85ca                	mv	a1,s2
    2f48:	00003517          	auipc	a0,0x3
    2f4c:	49050513          	addi	a0,a0,1168 # 63d8 <malloc+0x14e4>
    2f50:	6f1010ef          	jal	ra,4e40 <printf>
    exit(1);
    2f54:	4505                	li	a0,1
    2f56:	2df010ef          	jal	ra,4a34 <exit>
    printf("%s: chdir dd failed\n", s);
    2f5a:	85ca                	mv	a1,s2
    2f5c:	00003517          	auipc	a0,0x3
    2f60:	4a450513          	addi	a0,a0,1188 # 6400 <malloc+0x150c>
    2f64:	6dd010ef          	jal	ra,4e40 <printf>
    exit(1);
    2f68:	4505                	li	a0,1
    2f6a:	2cb010ef          	jal	ra,4a34 <exit>
    printf("%s: chdir dd/../../dd failed\n", s);
    2f6e:	85ca                	mv	a1,s2
    2f70:	00003517          	auipc	a0,0x3
    2f74:	4b850513          	addi	a0,a0,1208 # 6428 <malloc+0x1534>
    2f78:	6c9010ef          	jal	ra,4e40 <printf>
    exit(1);
    2f7c:	4505                	li	a0,1
    2f7e:	2b7010ef          	jal	ra,4a34 <exit>
    printf("%s: chdir dd/../../../dd failed\n", s);
    2f82:	85ca                	mv	a1,s2
    2f84:	00003517          	auipc	a0,0x3
    2f88:	4d450513          	addi	a0,a0,1236 # 6458 <malloc+0x1564>
    2f8c:	6b5010ef          	jal	ra,4e40 <printf>
    exit(1);
    2f90:	4505                	li	a0,1
    2f92:	2a3010ef          	jal	ra,4a34 <exit>
    printf("%s: chdir ./.. failed\n", s);
    2f96:	85ca                	mv	a1,s2
    2f98:	00003517          	auipc	a0,0x3
    2f9c:	4f050513          	addi	a0,a0,1264 # 6488 <malloc+0x1594>
    2fa0:	6a1010ef          	jal	ra,4e40 <printf>
    exit(1);
    2fa4:	4505                	li	a0,1
    2fa6:	28f010ef          	jal	ra,4a34 <exit>
    printf("%s: open dd/dd/ffff failed\n", s);
    2faa:	85ca                	mv	a1,s2
    2fac:	00003517          	auipc	a0,0x3
    2fb0:	4f450513          	addi	a0,a0,1268 # 64a0 <malloc+0x15ac>
    2fb4:	68d010ef          	jal	ra,4e40 <printf>
    exit(1);
    2fb8:	4505                	li	a0,1
    2fba:	27b010ef          	jal	ra,4a34 <exit>
    printf("%s: read dd/dd/ffff wrong len\n", s);
    2fbe:	85ca                	mv	a1,s2
    2fc0:	00003517          	auipc	a0,0x3
    2fc4:	50050513          	addi	a0,a0,1280 # 64c0 <malloc+0x15cc>
    2fc8:	679010ef          	jal	ra,4e40 <printf>
    exit(1);
    2fcc:	4505                	li	a0,1
    2fce:	267010ef          	jal	ra,4a34 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded!\n", s);
    2fd2:	85ca                	mv	a1,s2
    2fd4:	00003517          	auipc	a0,0x3
    2fd8:	50c50513          	addi	a0,a0,1292 # 64e0 <malloc+0x15ec>
    2fdc:	665010ef          	jal	ra,4e40 <printf>
    exit(1);
    2fe0:	4505                	li	a0,1
    2fe2:	253010ef          	jal	ra,4a34 <exit>
    printf("%s: create dd/ff/ff succeeded!\n", s);
    2fe6:	85ca                	mv	a1,s2
    2fe8:	00003517          	auipc	a0,0x3
    2fec:	53850513          	addi	a0,a0,1336 # 6520 <malloc+0x162c>
    2ff0:	651010ef          	jal	ra,4e40 <printf>
    exit(1);
    2ff4:	4505                	li	a0,1
    2ff6:	23f010ef          	jal	ra,4a34 <exit>
    printf("%s: create dd/xx/ff succeeded!\n", s);
    2ffa:	85ca                	mv	a1,s2
    2ffc:	00003517          	auipc	a0,0x3
    3000:	55450513          	addi	a0,a0,1364 # 6550 <malloc+0x165c>
    3004:	63d010ef          	jal	ra,4e40 <printf>
    exit(1);
    3008:	4505                	li	a0,1
    300a:	22b010ef          	jal	ra,4a34 <exit>
    printf("%s: create dd succeeded!\n", s);
    300e:	85ca                	mv	a1,s2
    3010:	00003517          	auipc	a0,0x3
    3014:	56050513          	addi	a0,a0,1376 # 6570 <malloc+0x167c>
    3018:	629010ef          	jal	ra,4e40 <printf>
    exit(1);
    301c:	4505                	li	a0,1
    301e:	217010ef          	jal	ra,4a34 <exit>
    printf("%s: open dd rdwr succeeded!\n", s);
    3022:	85ca                	mv	a1,s2
    3024:	00003517          	auipc	a0,0x3
    3028:	56c50513          	addi	a0,a0,1388 # 6590 <malloc+0x169c>
    302c:	615010ef          	jal	ra,4e40 <printf>
    exit(1);
    3030:	4505                	li	a0,1
    3032:	203010ef          	jal	ra,4a34 <exit>
    printf("%s: open dd wronly succeeded!\n", s);
    3036:	85ca                	mv	a1,s2
    3038:	00003517          	auipc	a0,0x3
    303c:	57850513          	addi	a0,a0,1400 # 65b0 <malloc+0x16bc>
    3040:	601010ef          	jal	ra,4e40 <printf>
    exit(1);
    3044:	4505                	li	a0,1
    3046:	1ef010ef          	jal	ra,4a34 <exit>
    printf("%s: link dd/ff/ff dd/dd/xx succeeded!\n", s);
    304a:	85ca                	mv	a1,s2
    304c:	00003517          	auipc	a0,0x3
    3050:	59450513          	addi	a0,a0,1428 # 65e0 <malloc+0x16ec>
    3054:	5ed010ef          	jal	ra,4e40 <printf>
    exit(1);
    3058:	4505                	li	a0,1
    305a:	1db010ef          	jal	ra,4a34 <exit>
    printf("%s: link dd/xx/ff dd/dd/xx succeeded!\n", s);
    305e:	85ca                	mv	a1,s2
    3060:	00003517          	auipc	a0,0x3
    3064:	5a850513          	addi	a0,a0,1448 # 6608 <malloc+0x1714>
    3068:	5d9010ef          	jal	ra,4e40 <printf>
    exit(1);
    306c:	4505                	li	a0,1
    306e:	1c7010ef          	jal	ra,4a34 <exit>
    printf("%s: link dd/ff dd/dd/ffff succeeded!\n", s);
    3072:	85ca                	mv	a1,s2
    3074:	00003517          	auipc	a0,0x3
    3078:	5bc50513          	addi	a0,a0,1468 # 6630 <malloc+0x173c>
    307c:	5c5010ef          	jal	ra,4e40 <printf>
    exit(1);
    3080:	4505                	li	a0,1
    3082:	1b3010ef          	jal	ra,4a34 <exit>
    printf("%s: mkdir dd/ff/ff succeeded!\n", s);
    3086:	85ca                	mv	a1,s2
    3088:	00003517          	auipc	a0,0x3
    308c:	5d050513          	addi	a0,a0,1488 # 6658 <malloc+0x1764>
    3090:	5b1010ef          	jal	ra,4e40 <printf>
    exit(1);
    3094:	4505                	li	a0,1
    3096:	19f010ef          	jal	ra,4a34 <exit>
    printf("%s: mkdir dd/xx/ff succeeded!\n", s);
    309a:	85ca                	mv	a1,s2
    309c:	00003517          	auipc	a0,0x3
    30a0:	5dc50513          	addi	a0,a0,1500 # 6678 <malloc+0x1784>
    30a4:	59d010ef          	jal	ra,4e40 <printf>
    exit(1);
    30a8:	4505                	li	a0,1
    30aa:	18b010ef          	jal	ra,4a34 <exit>
    printf("%s: mkdir dd/dd/ffff succeeded!\n", s);
    30ae:	85ca                	mv	a1,s2
    30b0:	00003517          	auipc	a0,0x3
    30b4:	5e850513          	addi	a0,a0,1512 # 6698 <malloc+0x17a4>
    30b8:	589010ef          	jal	ra,4e40 <printf>
    exit(1);
    30bc:	4505                	li	a0,1
    30be:	177010ef          	jal	ra,4a34 <exit>
    printf("%s: unlink dd/xx/ff succeeded!\n", s);
    30c2:	85ca                	mv	a1,s2
    30c4:	00003517          	auipc	a0,0x3
    30c8:	5fc50513          	addi	a0,a0,1532 # 66c0 <malloc+0x17cc>
    30cc:	575010ef          	jal	ra,4e40 <printf>
    exit(1);
    30d0:	4505                	li	a0,1
    30d2:	163010ef          	jal	ra,4a34 <exit>
    printf("%s: unlink dd/ff/ff succeeded!\n", s);
    30d6:	85ca                	mv	a1,s2
    30d8:	00003517          	auipc	a0,0x3
    30dc:	60850513          	addi	a0,a0,1544 # 66e0 <malloc+0x17ec>
    30e0:	561010ef          	jal	ra,4e40 <printf>
    exit(1);
    30e4:	4505                	li	a0,1
    30e6:	14f010ef          	jal	ra,4a34 <exit>
    printf("%s: chdir dd/ff succeeded!\n", s);
    30ea:	85ca                	mv	a1,s2
    30ec:	00003517          	auipc	a0,0x3
    30f0:	61450513          	addi	a0,a0,1556 # 6700 <malloc+0x180c>
    30f4:	54d010ef          	jal	ra,4e40 <printf>
    exit(1);
    30f8:	4505                	li	a0,1
    30fa:	13b010ef          	jal	ra,4a34 <exit>
    printf("%s: chdir dd/xx succeeded!\n", s);
    30fe:	85ca                	mv	a1,s2
    3100:	00003517          	auipc	a0,0x3
    3104:	62850513          	addi	a0,a0,1576 # 6728 <malloc+0x1834>
    3108:	539010ef          	jal	ra,4e40 <printf>
    exit(1);
    310c:	4505                	li	a0,1
    310e:	127010ef          	jal	ra,4a34 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    3112:	85ca                	mv	a1,s2
    3114:	00003517          	auipc	a0,0x3
    3118:	2a450513          	addi	a0,a0,676 # 63b8 <malloc+0x14c4>
    311c:	525010ef          	jal	ra,4e40 <printf>
    exit(1);
    3120:	4505                	li	a0,1
    3122:	113010ef          	jal	ra,4a34 <exit>
    printf("%s: unlink dd/ff failed\n", s);
    3126:	85ca                	mv	a1,s2
    3128:	00003517          	auipc	a0,0x3
    312c:	62050513          	addi	a0,a0,1568 # 6748 <malloc+0x1854>
    3130:	511010ef          	jal	ra,4e40 <printf>
    exit(1);
    3134:	4505                	li	a0,1
    3136:	0ff010ef          	jal	ra,4a34 <exit>
    printf("%s: unlink non-empty dd succeeded!\n", s);
    313a:	85ca                	mv	a1,s2
    313c:	00003517          	auipc	a0,0x3
    3140:	62c50513          	addi	a0,a0,1580 # 6768 <malloc+0x1874>
    3144:	4fd010ef          	jal	ra,4e40 <printf>
    exit(1);
    3148:	4505                	li	a0,1
    314a:	0eb010ef          	jal	ra,4a34 <exit>
    printf("%s: unlink dd/dd failed\n", s);
    314e:	85ca                	mv	a1,s2
    3150:	00003517          	auipc	a0,0x3
    3154:	64850513          	addi	a0,a0,1608 # 6798 <malloc+0x18a4>
    3158:	4e9010ef          	jal	ra,4e40 <printf>
    exit(1);
    315c:	4505                	li	a0,1
    315e:	0d7010ef          	jal	ra,4a34 <exit>
    printf("%s: unlink dd failed\n", s);
    3162:	85ca                	mv	a1,s2
    3164:	00003517          	auipc	a0,0x3
    3168:	65450513          	addi	a0,a0,1620 # 67b8 <malloc+0x18c4>
    316c:	4d5010ef          	jal	ra,4e40 <printf>
    exit(1);
    3170:	4505                	li	a0,1
    3172:	0c3010ef          	jal	ra,4a34 <exit>

0000000000003176 <rmdot>:
{
    3176:	1101                	addi	sp,sp,-32
    3178:	ec06                	sd	ra,24(sp)
    317a:	e822                	sd	s0,16(sp)
    317c:	e426                	sd	s1,8(sp)
    317e:	1000                	addi	s0,sp,32
    3180:	84aa                	mv	s1,a0
  if(mkdir("dots") != 0){
    3182:	00003517          	auipc	a0,0x3
    3186:	64e50513          	addi	a0,a0,1614 # 67d0 <malloc+0x18dc>
    318a:	113010ef          	jal	ra,4a9c <mkdir>
    318e:	e53d                	bnez	a0,31fc <rmdot+0x86>
  if(chdir("dots") != 0){
    3190:	00003517          	auipc	a0,0x3
    3194:	64050513          	addi	a0,a0,1600 # 67d0 <malloc+0x18dc>
    3198:	10d010ef          	jal	ra,4aa4 <chdir>
    319c:	e935                	bnez	a0,3210 <rmdot+0x9a>
  if(unlink(".") == 0){
    319e:	00002517          	auipc	a0,0x2
    31a2:	56250513          	addi	a0,a0,1378 # 5700 <malloc+0x80c>
    31a6:	0df010ef          	jal	ra,4a84 <unlink>
    31aa:	cd2d                	beqz	a0,3224 <rmdot+0xae>
  if(unlink("..") == 0){
    31ac:	00003517          	auipc	a0,0x3
    31b0:	07450513          	addi	a0,a0,116 # 6220 <malloc+0x132c>
    31b4:	0d1010ef          	jal	ra,4a84 <unlink>
    31b8:	c141                	beqz	a0,3238 <rmdot+0xc2>
  if(chdir("/") != 0){
    31ba:	00003517          	auipc	a0,0x3
    31be:	00e50513          	addi	a0,a0,14 # 61c8 <malloc+0x12d4>
    31c2:	0e3010ef          	jal	ra,4aa4 <chdir>
    31c6:	e159                	bnez	a0,324c <rmdot+0xd6>
  if(unlink("dots/.") == 0){
    31c8:	00003517          	auipc	a0,0x3
    31cc:	67050513          	addi	a0,a0,1648 # 6838 <malloc+0x1944>
    31d0:	0b5010ef          	jal	ra,4a84 <unlink>
    31d4:	c551                	beqz	a0,3260 <rmdot+0xea>
  if(unlink("dots/..") == 0){
    31d6:	00003517          	auipc	a0,0x3
    31da:	68a50513          	addi	a0,a0,1674 # 6860 <malloc+0x196c>
    31de:	0a7010ef          	jal	ra,4a84 <unlink>
    31e2:	c949                	beqz	a0,3274 <rmdot+0xfe>
  if(unlink("dots") != 0){
    31e4:	00003517          	auipc	a0,0x3
    31e8:	5ec50513          	addi	a0,a0,1516 # 67d0 <malloc+0x18dc>
    31ec:	099010ef          	jal	ra,4a84 <unlink>
    31f0:	ed41                	bnez	a0,3288 <rmdot+0x112>
}
    31f2:	60e2                	ld	ra,24(sp)
    31f4:	6442                	ld	s0,16(sp)
    31f6:	64a2                	ld	s1,8(sp)
    31f8:	6105                	addi	sp,sp,32
    31fa:	8082                	ret
    printf("%s: mkdir dots failed\n", s);
    31fc:	85a6                	mv	a1,s1
    31fe:	00003517          	auipc	a0,0x3
    3202:	5da50513          	addi	a0,a0,1498 # 67d8 <malloc+0x18e4>
    3206:	43b010ef          	jal	ra,4e40 <printf>
    exit(1);
    320a:	4505                	li	a0,1
    320c:	029010ef          	jal	ra,4a34 <exit>
    printf("%s: chdir dots failed\n", s);
    3210:	85a6                	mv	a1,s1
    3212:	00003517          	auipc	a0,0x3
    3216:	5de50513          	addi	a0,a0,1502 # 67f0 <malloc+0x18fc>
    321a:	427010ef          	jal	ra,4e40 <printf>
    exit(1);
    321e:	4505                	li	a0,1
    3220:	015010ef          	jal	ra,4a34 <exit>
    printf("%s: rm . worked!\n", s);
    3224:	85a6                	mv	a1,s1
    3226:	00003517          	auipc	a0,0x3
    322a:	5e250513          	addi	a0,a0,1506 # 6808 <malloc+0x1914>
    322e:	413010ef          	jal	ra,4e40 <printf>
    exit(1);
    3232:	4505                	li	a0,1
    3234:	001010ef          	jal	ra,4a34 <exit>
    printf("%s: rm .. worked!\n", s);
    3238:	85a6                	mv	a1,s1
    323a:	00003517          	auipc	a0,0x3
    323e:	5e650513          	addi	a0,a0,1510 # 6820 <malloc+0x192c>
    3242:	3ff010ef          	jal	ra,4e40 <printf>
    exit(1);
    3246:	4505                	li	a0,1
    3248:	7ec010ef          	jal	ra,4a34 <exit>
    printf("%s: chdir / failed\n", s);
    324c:	85a6                	mv	a1,s1
    324e:	00003517          	auipc	a0,0x3
    3252:	f8250513          	addi	a0,a0,-126 # 61d0 <malloc+0x12dc>
    3256:	3eb010ef          	jal	ra,4e40 <printf>
    exit(1);
    325a:	4505                	li	a0,1
    325c:	7d8010ef          	jal	ra,4a34 <exit>
    printf("%s: unlink dots/. worked!\n", s);
    3260:	85a6                	mv	a1,s1
    3262:	00003517          	auipc	a0,0x3
    3266:	5de50513          	addi	a0,a0,1502 # 6840 <malloc+0x194c>
    326a:	3d7010ef          	jal	ra,4e40 <printf>
    exit(1);
    326e:	4505                	li	a0,1
    3270:	7c4010ef          	jal	ra,4a34 <exit>
    printf("%s: unlink dots/.. worked!\n", s);
    3274:	85a6                	mv	a1,s1
    3276:	00003517          	auipc	a0,0x3
    327a:	5f250513          	addi	a0,a0,1522 # 6868 <malloc+0x1974>
    327e:	3c3010ef          	jal	ra,4e40 <printf>
    exit(1);
    3282:	4505                	li	a0,1
    3284:	7b0010ef          	jal	ra,4a34 <exit>
    printf("%s: unlink dots failed!\n", s);
    3288:	85a6                	mv	a1,s1
    328a:	00003517          	auipc	a0,0x3
    328e:	5fe50513          	addi	a0,a0,1534 # 6888 <malloc+0x1994>
    3292:	3af010ef          	jal	ra,4e40 <printf>
    exit(1);
    3296:	4505                	li	a0,1
    3298:	79c010ef          	jal	ra,4a34 <exit>

000000000000329c <dirfile>:
{
    329c:	1101                	addi	sp,sp,-32
    329e:	ec06                	sd	ra,24(sp)
    32a0:	e822                	sd	s0,16(sp)
    32a2:	e426                	sd	s1,8(sp)
    32a4:	e04a                	sd	s2,0(sp)
    32a6:	1000                	addi	s0,sp,32
    32a8:	892a                	mv	s2,a0
  fd = open("dirfile", O_CREATE);
    32aa:	20000593          	li	a1,512
    32ae:	00003517          	auipc	a0,0x3
    32b2:	5fa50513          	addi	a0,a0,1530 # 68a8 <malloc+0x19b4>
    32b6:	7be010ef          	jal	ra,4a74 <open>
  if(fd < 0){
    32ba:	0c054563          	bltz	a0,3384 <dirfile+0xe8>
  close(fd);
    32be:	79e010ef          	jal	ra,4a5c <close>
  if(chdir("dirfile") == 0){
    32c2:	00003517          	auipc	a0,0x3
    32c6:	5e650513          	addi	a0,a0,1510 # 68a8 <malloc+0x19b4>
    32ca:	7da010ef          	jal	ra,4aa4 <chdir>
    32ce:	c569                	beqz	a0,3398 <dirfile+0xfc>
  fd = open("dirfile/xx", 0);
    32d0:	4581                	li	a1,0
    32d2:	00003517          	auipc	a0,0x3
    32d6:	61e50513          	addi	a0,a0,1566 # 68f0 <malloc+0x19fc>
    32da:	79a010ef          	jal	ra,4a74 <open>
  if(fd >= 0){
    32de:	0c055763          	bgez	a0,33ac <dirfile+0x110>
  fd = open("dirfile/xx", O_CREATE);
    32e2:	20000593          	li	a1,512
    32e6:	00003517          	auipc	a0,0x3
    32ea:	60a50513          	addi	a0,a0,1546 # 68f0 <malloc+0x19fc>
    32ee:	786010ef          	jal	ra,4a74 <open>
  if(fd >= 0){
    32f2:	0c055763          	bgez	a0,33c0 <dirfile+0x124>
  if(mkdir("dirfile/xx") == 0){
    32f6:	00003517          	auipc	a0,0x3
    32fa:	5fa50513          	addi	a0,a0,1530 # 68f0 <malloc+0x19fc>
    32fe:	79e010ef          	jal	ra,4a9c <mkdir>
    3302:	0c050963          	beqz	a0,33d4 <dirfile+0x138>
  if(unlink("dirfile/xx") == 0){
    3306:	00003517          	auipc	a0,0x3
    330a:	5ea50513          	addi	a0,a0,1514 # 68f0 <malloc+0x19fc>
    330e:	776010ef          	jal	ra,4a84 <unlink>
    3312:	0c050b63          	beqz	a0,33e8 <dirfile+0x14c>
  if(link("README", "dirfile/xx") == 0){
    3316:	00003597          	auipc	a1,0x3
    331a:	5da58593          	addi	a1,a1,1498 # 68f0 <malloc+0x19fc>
    331e:	00002517          	auipc	a0,0x2
    3322:	ed250513          	addi	a0,a0,-302 # 51f0 <malloc+0x2fc>
    3326:	76e010ef          	jal	ra,4a94 <link>
    332a:	0c050963          	beqz	a0,33fc <dirfile+0x160>
  if(unlink("dirfile") != 0){
    332e:	00003517          	auipc	a0,0x3
    3332:	57a50513          	addi	a0,a0,1402 # 68a8 <malloc+0x19b4>
    3336:	74e010ef          	jal	ra,4a84 <unlink>
    333a:	0c051b63          	bnez	a0,3410 <dirfile+0x174>
  fd = open(".", O_RDWR);
    333e:	4589                	li	a1,2
    3340:	00002517          	auipc	a0,0x2
    3344:	3c050513          	addi	a0,a0,960 # 5700 <malloc+0x80c>
    3348:	72c010ef          	jal	ra,4a74 <open>
  if(fd >= 0){
    334c:	0c055c63          	bgez	a0,3424 <dirfile+0x188>
  fd = open(".", 0);
    3350:	4581                	li	a1,0
    3352:	00002517          	auipc	a0,0x2
    3356:	3ae50513          	addi	a0,a0,942 # 5700 <malloc+0x80c>
    335a:	71a010ef          	jal	ra,4a74 <open>
    335e:	84aa                	mv	s1,a0
  if(write(fd, "x", 1) > 0){
    3360:	4605                	li	a2,1
    3362:	00002597          	auipc	a1,0x2
    3366:	d2658593          	addi	a1,a1,-730 # 5088 <malloc+0x194>
    336a:	6ea010ef          	jal	ra,4a54 <write>
    336e:	0ca04563          	bgtz	a0,3438 <dirfile+0x19c>
  close(fd);
    3372:	8526                	mv	a0,s1
    3374:	6e8010ef          	jal	ra,4a5c <close>
}
    3378:	60e2                	ld	ra,24(sp)
    337a:	6442                	ld	s0,16(sp)
    337c:	64a2                	ld	s1,8(sp)
    337e:	6902                	ld	s2,0(sp)
    3380:	6105                	addi	sp,sp,32
    3382:	8082                	ret
    printf("%s: create dirfile failed\n", s);
    3384:	85ca                	mv	a1,s2
    3386:	00003517          	auipc	a0,0x3
    338a:	52a50513          	addi	a0,a0,1322 # 68b0 <malloc+0x19bc>
    338e:	2b3010ef          	jal	ra,4e40 <printf>
    exit(1);
    3392:	4505                	li	a0,1
    3394:	6a0010ef          	jal	ra,4a34 <exit>
    printf("%s: chdir dirfile succeeded!\n", s);
    3398:	85ca                	mv	a1,s2
    339a:	00003517          	auipc	a0,0x3
    339e:	53650513          	addi	a0,a0,1334 # 68d0 <malloc+0x19dc>
    33a2:	29f010ef          	jal	ra,4e40 <printf>
    exit(1);
    33a6:	4505                	li	a0,1
    33a8:	68c010ef          	jal	ra,4a34 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    33ac:	85ca                	mv	a1,s2
    33ae:	00003517          	auipc	a0,0x3
    33b2:	55250513          	addi	a0,a0,1362 # 6900 <malloc+0x1a0c>
    33b6:	28b010ef          	jal	ra,4e40 <printf>
    exit(1);
    33ba:	4505                	li	a0,1
    33bc:	678010ef          	jal	ra,4a34 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    33c0:	85ca                	mv	a1,s2
    33c2:	00003517          	auipc	a0,0x3
    33c6:	53e50513          	addi	a0,a0,1342 # 6900 <malloc+0x1a0c>
    33ca:	277010ef          	jal	ra,4e40 <printf>
    exit(1);
    33ce:	4505                	li	a0,1
    33d0:	664010ef          	jal	ra,4a34 <exit>
    printf("%s: mkdir dirfile/xx succeeded!\n", s);
    33d4:	85ca                	mv	a1,s2
    33d6:	00003517          	auipc	a0,0x3
    33da:	55250513          	addi	a0,a0,1362 # 6928 <malloc+0x1a34>
    33de:	263010ef          	jal	ra,4e40 <printf>
    exit(1);
    33e2:	4505                	li	a0,1
    33e4:	650010ef          	jal	ra,4a34 <exit>
    printf("%s: unlink dirfile/xx succeeded!\n", s);
    33e8:	85ca                	mv	a1,s2
    33ea:	00003517          	auipc	a0,0x3
    33ee:	56650513          	addi	a0,a0,1382 # 6950 <malloc+0x1a5c>
    33f2:	24f010ef          	jal	ra,4e40 <printf>
    exit(1);
    33f6:	4505                	li	a0,1
    33f8:	63c010ef          	jal	ra,4a34 <exit>
    printf("%s: link to dirfile/xx succeeded!\n", s);
    33fc:	85ca                	mv	a1,s2
    33fe:	00003517          	auipc	a0,0x3
    3402:	57a50513          	addi	a0,a0,1402 # 6978 <malloc+0x1a84>
    3406:	23b010ef          	jal	ra,4e40 <printf>
    exit(1);
    340a:	4505                	li	a0,1
    340c:	628010ef          	jal	ra,4a34 <exit>
    printf("%s: unlink dirfile failed!\n", s);
    3410:	85ca                	mv	a1,s2
    3412:	00003517          	auipc	a0,0x3
    3416:	58e50513          	addi	a0,a0,1422 # 69a0 <malloc+0x1aac>
    341a:	227010ef          	jal	ra,4e40 <printf>
    exit(1);
    341e:	4505                	li	a0,1
    3420:	614010ef          	jal	ra,4a34 <exit>
    printf("%s: open . for writing succeeded!\n", s);
    3424:	85ca                	mv	a1,s2
    3426:	00003517          	auipc	a0,0x3
    342a:	59a50513          	addi	a0,a0,1434 # 69c0 <malloc+0x1acc>
    342e:	213010ef          	jal	ra,4e40 <printf>
    exit(1);
    3432:	4505                	li	a0,1
    3434:	600010ef          	jal	ra,4a34 <exit>
    printf("%s: write . succeeded!\n", s);
    3438:	85ca                	mv	a1,s2
    343a:	00003517          	auipc	a0,0x3
    343e:	5ae50513          	addi	a0,a0,1454 # 69e8 <malloc+0x1af4>
    3442:	1ff010ef          	jal	ra,4e40 <printf>
    exit(1);
    3446:	4505                	li	a0,1
    3448:	5ec010ef          	jal	ra,4a34 <exit>

000000000000344c <iref>:
{
    344c:	7139                	addi	sp,sp,-64
    344e:	fc06                	sd	ra,56(sp)
    3450:	f822                	sd	s0,48(sp)
    3452:	f426                	sd	s1,40(sp)
    3454:	f04a                	sd	s2,32(sp)
    3456:	ec4e                	sd	s3,24(sp)
    3458:	e852                	sd	s4,16(sp)
    345a:	e456                	sd	s5,8(sp)
    345c:	e05a                	sd	s6,0(sp)
    345e:	0080                	addi	s0,sp,64
    3460:	8b2a                	mv	s6,a0
    3462:	03300913          	li	s2,51
    if(mkdir("irefd") != 0){
    3466:	00003a17          	auipc	s4,0x3
    346a:	59aa0a13          	addi	s4,s4,1434 # 6a00 <malloc+0x1b0c>
    mkdir("");
    346e:	00003497          	auipc	s1,0x3
    3472:	09a48493          	addi	s1,s1,154 # 6508 <malloc+0x1614>
    link("README", "");
    3476:	00002a97          	auipc	s5,0x2
    347a:	d7aa8a93          	addi	s5,s5,-646 # 51f0 <malloc+0x2fc>
    fd = open("xx", O_CREATE);
    347e:	00003997          	auipc	s3,0x3
    3482:	47a98993          	addi	s3,s3,1146 # 68f8 <malloc+0x1a04>
    3486:	a835                	j	34c2 <iref+0x76>
      printf("%s: mkdir irefd failed\n", s);
    3488:	85da                	mv	a1,s6
    348a:	00003517          	auipc	a0,0x3
    348e:	57e50513          	addi	a0,a0,1406 # 6a08 <malloc+0x1b14>
    3492:	1af010ef          	jal	ra,4e40 <printf>
      exit(1);
    3496:	4505                	li	a0,1
    3498:	59c010ef          	jal	ra,4a34 <exit>
      printf("%s: chdir irefd failed\n", s);
    349c:	85da                	mv	a1,s6
    349e:	00003517          	auipc	a0,0x3
    34a2:	58250513          	addi	a0,a0,1410 # 6a20 <malloc+0x1b2c>
    34a6:	19b010ef          	jal	ra,4e40 <printf>
      exit(1);
    34aa:	4505                	li	a0,1
    34ac:	588010ef          	jal	ra,4a34 <exit>
      close(fd);
    34b0:	5ac010ef          	jal	ra,4a5c <close>
    34b4:	a82d                	j	34ee <iref+0xa2>
    unlink("xx");
    34b6:	854e                	mv	a0,s3
    34b8:	5cc010ef          	jal	ra,4a84 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    34bc:	397d                	addiw	s2,s2,-1
    34be:	04090263          	beqz	s2,3502 <iref+0xb6>
    if(mkdir("irefd") != 0){
    34c2:	8552                	mv	a0,s4
    34c4:	5d8010ef          	jal	ra,4a9c <mkdir>
    34c8:	f161                	bnez	a0,3488 <iref+0x3c>
    if(chdir("irefd") != 0){
    34ca:	8552                	mv	a0,s4
    34cc:	5d8010ef          	jal	ra,4aa4 <chdir>
    34d0:	f571                	bnez	a0,349c <iref+0x50>
    mkdir("");
    34d2:	8526                	mv	a0,s1
    34d4:	5c8010ef          	jal	ra,4a9c <mkdir>
    link("README", "");
    34d8:	85a6                	mv	a1,s1
    34da:	8556                	mv	a0,s5
    34dc:	5b8010ef          	jal	ra,4a94 <link>
    fd = open("", O_CREATE);
    34e0:	20000593          	li	a1,512
    34e4:	8526                	mv	a0,s1
    34e6:	58e010ef          	jal	ra,4a74 <open>
    if(fd >= 0)
    34ea:	fc0553e3          	bgez	a0,34b0 <iref+0x64>
    fd = open("xx", O_CREATE);
    34ee:	20000593          	li	a1,512
    34f2:	854e                	mv	a0,s3
    34f4:	580010ef          	jal	ra,4a74 <open>
    if(fd >= 0)
    34f8:	fa054fe3          	bltz	a0,34b6 <iref+0x6a>
      close(fd);
    34fc:	560010ef          	jal	ra,4a5c <close>
    3500:	bf5d                	j	34b6 <iref+0x6a>
    3502:	03300493          	li	s1,51
    chdir("..");
    3506:	00003997          	auipc	s3,0x3
    350a:	d1a98993          	addi	s3,s3,-742 # 6220 <malloc+0x132c>
    unlink("irefd");
    350e:	00003917          	auipc	s2,0x3
    3512:	4f290913          	addi	s2,s2,1266 # 6a00 <malloc+0x1b0c>
    chdir("..");
    3516:	854e                	mv	a0,s3
    3518:	58c010ef          	jal	ra,4aa4 <chdir>
    unlink("irefd");
    351c:	854a                	mv	a0,s2
    351e:	566010ef          	jal	ra,4a84 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    3522:	34fd                	addiw	s1,s1,-1
    3524:	f8ed                	bnez	s1,3516 <iref+0xca>
  chdir("/");
    3526:	00003517          	auipc	a0,0x3
    352a:	ca250513          	addi	a0,a0,-862 # 61c8 <malloc+0x12d4>
    352e:	576010ef          	jal	ra,4aa4 <chdir>
}
    3532:	70e2                	ld	ra,56(sp)
    3534:	7442                	ld	s0,48(sp)
    3536:	74a2                	ld	s1,40(sp)
    3538:	7902                	ld	s2,32(sp)
    353a:	69e2                	ld	s3,24(sp)
    353c:	6a42                	ld	s4,16(sp)
    353e:	6aa2                	ld	s5,8(sp)
    3540:	6b02                	ld	s6,0(sp)
    3542:	6121                	addi	sp,sp,64
    3544:	8082                	ret

0000000000003546 <openiputtest>:
{
    3546:	7179                	addi	sp,sp,-48
    3548:	f406                	sd	ra,40(sp)
    354a:	f022                	sd	s0,32(sp)
    354c:	ec26                	sd	s1,24(sp)
    354e:	1800                	addi	s0,sp,48
    3550:	84aa                	mv	s1,a0
  if(mkdir("oidir") < 0){
    3552:	00003517          	auipc	a0,0x3
    3556:	4e650513          	addi	a0,a0,1254 # 6a38 <malloc+0x1b44>
    355a:	542010ef          	jal	ra,4a9c <mkdir>
    355e:	02054a63          	bltz	a0,3592 <openiputtest+0x4c>
  pid = fork();
    3562:	4ca010ef          	jal	ra,4a2c <fork>
  if(pid < 0){
    3566:	04054063          	bltz	a0,35a6 <openiputtest+0x60>
  if(pid == 0){
    356a:	e939                	bnez	a0,35c0 <openiputtest+0x7a>
    int fd = open("oidir", O_RDWR);
    356c:	4589                	li	a1,2
    356e:	00003517          	auipc	a0,0x3
    3572:	4ca50513          	addi	a0,a0,1226 # 6a38 <malloc+0x1b44>
    3576:	4fe010ef          	jal	ra,4a74 <open>
    if(fd >= 0){
    357a:	04054063          	bltz	a0,35ba <openiputtest+0x74>
      printf("%s: open directory for write succeeded\n", s);
    357e:	85a6                	mv	a1,s1
    3580:	00003517          	auipc	a0,0x3
    3584:	4d850513          	addi	a0,a0,1240 # 6a58 <malloc+0x1b64>
    3588:	0b9010ef          	jal	ra,4e40 <printf>
      exit(1);
    358c:	4505                	li	a0,1
    358e:	4a6010ef          	jal	ra,4a34 <exit>
    printf("%s: mkdir oidir failed\n", s);
    3592:	85a6                	mv	a1,s1
    3594:	00003517          	auipc	a0,0x3
    3598:	4ac50513          	addi	a0,a0,1196 # 6a40 <malloc+0x1b4c>
    359c:	0a5010ef          	jal	ra,4e40 <printf>
    exit(1);
    35a0:	4505                	li	a0,1
    35a2:	492010ef          	jal	ra,4a34 <exit>
    printf("%s: fork failed\n", s);
    35a6:	85a6                	mv	a1,s1
    35a8:	00002517          	auipc	a0,0x2
    35ac:	30050513          	addi	a0,a0,768 # 58a8 <malloc+0x9b4>
    35b0:	091010ef          	jal	ra,4e40 <printf>
    exit(1);
    35b4:	4505                	li	a0,1
    35b6:	47e010ef          	jal	ra,4a34 <exit>
    exit(0);
    35ba:	4501                	li	a0,0
    35bc:	478010ef          	jal	ra,4a34 <exit>
  sleep(1);
    35c0:	4505                	li	a0,1
    35c2:	502010ef          	jal	ra,4ac4 <sleep>
  if(unlink("oidir") != 0){
    35c6:	00003517          	auipc	a0,0x3
    35ca:	47250513          	addi	a0,a0,1138 # 6a38 <malloc+0x1b44>
    35ce:	4b6010ef          	jal	ra,4a84 <unlink>
    35d2:	c919                	beqz	a0,35e8 <openiputtest+0xa2>
    printf("%s: unlink failed\n", s);
    35d4:	85a6                	mv	a1,s1
    35d6:	00002517          	auipc	a0,0x2
    35da:	4c250513          	addi	a0,a0,1218 # 5a98 <malloc+0xba4>
    35de:	063010ef          	jal	ra,4e40 <printf>
    exit(1);
    35e2:	4505                	li	a0,1
    35e4:	450010ef          	jal	ra,4a34 <exit>
  wait(&xstatus);
    35e8:	fdc40513          	addi	a0,s0,-36
    35ec:	450010ef          	jal	ra,4a3c <wait>
  exit(xstatus);
    35f0:	fdc42503          	lw	a0,-36(s0)
    35f4:	440010ef          	jal	ra,4a34 <exit>

00000000000035f8 <forkforkfork>:
{
    35f8:	1101                	addi	sp,sp,-32
    35fa:	ec06                	sd	ra,24(sp)
    35fc:	e822                	sd	s0,16(sp)
    35fe:	e426                	sd	s1,8(sp)
    3600:	1000                	addi	s0,sp,32
    3602:	84aa                	mv	s1,a0
  unlink("stopforking");
    3604:	00003517          	auipc	a0,0x3
    3608:	47c50513          	addi	a0,a0,1148 # 6a80 <malloc+0x1b8c>
    360c:	478010ef          	jal	ra,4a84 <unlink>
  int pid = fork();
    3610:	41c010ef          	jal	ra,4a2c <fork>
  if(pid < 0){
    3614:	02054b63          	bltz	a0,364a <forkforkfork+0x52>
  if(pid == 0){
    3618:	c139                	beqz	a0,365e <forkforkfork+0x66>
  sleep(20); // two seconds
    361a:	4551                	li	a0,20
    361c:	4a8010ef          	jal	ra,4ac4 <sleep>
  close(open("stopforking", O_CREATE|O_RDWR));
    3620:	20200593          	li	a1,514
    3624:	00003517          	auipc	a0,0x3
    3628:	45c50513          	addi	a0,a0,1116 # 6a80 <malloc+0x1b8c>
    362c:	448010ef          	jal	ra,4a74 <open>
    3630:	42c010ef          	jal	ra,4a5c <close>
  wait(0);
    3634:	4501                	li	a0,0
    3636:	406010ef          	jal	ra,4a3c <wait>
  sleep(10); // one second
    363a:	4529                	li	a0,10
    363c:	488010ef          	jal	ra,4ac4 <sleep>
}
    3640:	60e2                	ld	ra,24(sp)
    3642:	6442                	ld	s0,16(sp)
    3644:	64a2                	ld	s1,8(sp)
    3646:	6105                	addi	sp,sp,32
    3648:	8082                	ret
    printf("%s: fork failed", s);
    364a:	85a6                	mv	a1,s1
    364c:	00002517          	auipc	a0,0x2
    3650:	41c50513          	addi	a0,a0,1052 # 5a68 <malloc+0xb74>
    3654:	7ec010ef          	jal	ra,4e40 <printf>
    exit(1);
    3658:	4505                	li	a0,1
    365a:	3da010ef          	jal	ra,4a34 <exit>
      int fd = open("stopforking", 0);
    365e:	00003497          	auipc	s1,0x3
    3662:	42248493          	addi	s1,s1,1058 # 6a80 <malloc+0x1b8c>
    3666:	4581                	li	a1,0
    3668:	8526                	mv	a0,s1
    366a:	40a010ef          	jal	ra,4a74 <open>
      if(fd >= 0){
    366e:	00055e63          	bgez	a0,368a <forkforkfork+0x92>
      if(fork() < 0){
    3672:	3ba010ef          	jal	ra,4a2c <fork>
    3676:	fe0558e3          	bgez	a0,3666 <forkforkfork+0x6e>
        close(open("stopforking", O_CREATE|O_RDWR));
    367a:	20200593          	li	a1,514
    367e:	8526                	mv	a0,s1
    3680:	3f4010ef          	jal	ra,4a74 <open>
    3684:	3d8010ef          	jal	ra,4a5c <close>
    3688:	bff9                	j	3666 <forkforkfork+0x6e>
        exit(0);
    368a:	4501                	li	a0,0
    368c:	3a8010ef          	jal	ra,4a34 <exit>

0000000000003690 <killstatus>:
{
    3690:	7139                	addi	sp,sp,-64
    3692:	fc06                	sd	ra,56(sp)
    3694:	f822                	sd	s0,48(sp)
    3696:	f426                	sd	s1,40(sp)
    3698:	f04a                	sd	s2,32(sp)
    369a:	ec4e                	sd	s3,24(sp)
    369c:	e852                	sd	s4,16(sp)
    369e:	0080                	addi	s0,sp,64
    36a0:	8a2a                	mv	s4,a0
    36a2:	06400913          	li	s2,100
    if(xst != -1) {
    36a6:	59fd                	li	s3,-1
    int pid1 = fork();
    36a8:	384010ef          	jal	ra,4a2c <fork>
    36ac:	84aa                	mv	s1,a0
    if(pid1 < 0){
    36ae:	02054763          	bltz	a0,36dc <killstatus+0x4c>
    if(pid1 == 0){
    36b2:	cd1d                	beqz	a0,36f0 <killstatus+0x60>
    sleep(1);
    36b4:	4505                	li	a0,1
    36b6:	40e010ef          	jal	ra,4ac4 <sleep>
    kill(pid1);
    36ba:	8526                	mv	a0,s1
    36bc:	3a8010ef          	jal	ra,4a64 <kill>
    wait(&xst);
    36c0:	fcc40513          	addi	a0,s0,-52
    36c4:	378010ef          	jal	ra,4a3c <wait>
    if(xst != -1) {
    36c8:	fcc42783          	lw	a5,-52(s0)
    36cc:	03379563          	bne	a5,s3,36f6 <killstatus+0x66>
  for(int i = 0; i < 100; i++){
    36d0:	397d                	addiw	s2,s2,-1
    36d2:	fc091be3          	bnez	s2,36a8 <killstatus+0x18>
  exit(0);
    36d6:	4501                	li	a0,0
    36d8:	35c010ef          	jal	ra,4a34 <exit>
      printf("%s: fork failed\n", s);
    36dc:	85d2                	mv	a1,s4
    36de:	00002517          	auipc	a0,0x2
    36e2:	1ca50513          	addi	a0,a0,458 # 58a8 <malloc+0x9b4>
    36e6:	75a010ef          	jal	ra,4e40 <printf>
      exit(1);
    36ea:	4505                	li	a0,1
    36ec:	348010ef          	jal	ra,4a34 <exit>
        getpid();
    36f0:	3c4010ef          	jal	ra,4ab4 <getpid>
      while(1) {
    36f4:	bff5                	j	36f0 <killstatus+0x60>
       printf("%s: status should be -1\n", s);
    36f6:	85d2                	mv	a1,s4
    36f8:	00003517          	auipc	a0,0x3
    36fc:	39850513          	addi	a0,a0,920 # 6a90 <malloc+0x1b9c>
    3700:	740010ef          	jal	ra,4e40 <printf>
       exit(1);
    3704:	4505                	li	a0,1
    3706:	32e010ef          	jal	ra,4a34 <exit>

000000000000370a <preempt>:
{
    370a:	7139                	addi	sp,sp,-64
    370c:	fc06                	sd	ra,56(sp)
    370e:	f822                	sd	s0,48(sp)
    3710:	f426                	sd	s1,40(sp)
    3712:	f04a                	sd	s2,32(sp)
    3714:	ec4e                	sd	s3,24(sp)
    3716:	e852                	sd	s4,16(sp)
    3718:	0080                	addi	s0,sp,64
    371a:	892a                	mv	s2,a0
  pid1 = fork();
    371c:	310010ef          	jal	ra,4a2c <fork>
  if(pid1 < 0) {
    3720:	00054563          	bltz	a0,372a <preempt+0x20>
    3724:	84aa                	mv	s1,a0
  if(pid1 == 0)
    3726:	ed01                	bnez	a0,373e <preempt+0x34>
    for(;;)
    3728:	a001                	j	3728 <preempt+0x1e>
    printf("%s: fork failed", s);
    372a:	85ca                	mv	a1,s2
    372c:	00002517          	auipc	a0,0x2
    3730:	33c50513          	addi	a0,a0,828 # 5a68 <malloc+0xb74>
    3734:	70c010ef          	jal	ra,4e40 <printf>
    exit(1);
    3738:	4505                	li	a0,1
    373a:	2fa010ef          	jal	ra,4a34 <exit>
  pid2 = fork();
    373e:	2ee010ef          	jal	ra,4a2c <fork>
    3742:	89aa                	mv	s3,a0
  if(pid2 < 0) {
    3744:	00054463          	bltz	a0,374c <preempt+0x42>
  if(pid2 == 0)
    3748:	ed01                	bnez	a0,3760 <preempt+0x56>
    for(;;)
    374a:	a001                	j	374a <preempt+0x40>
    printf("%s: fork failed\n", s);
    374c:	85ca                	mv	a1,s2
    374e:	00002517          	auipc	a0,0x2
    3752:	15a50513          	addi	a0,a0,346 # 58a8 <malloc+0x9b4>
    3756:	6ea010ef          	jal	ra,4e40 <printf>
    exit(1);
    375a:	4505                	li	a0,1
    375c:	2d8010ef          	jal	ra,4a34 <exit>
  pipe(pfds);
    3760:	fc840513          	addi	a0,s0,-56
    3764:	2e0010ef          	jal	ra,4a44 <pipe>
  pid3 = fork();
    3768:	2c4010ef          	jal	ra,4a2c <fork>
    376c:	8a2a                	mv	s4,a0
  if(pid3 < 0) {
    376e:	02054863          	bltz	a0,379e <preempt+0x94>
  if(pid3 == 0){
    3772:	e921                	bnez	a0,37c2 <preempt+0xb8>
    close(pfds[0]);
    3774:	fc842503          	lw	a0,-56(s0)
    3778:	2e4010ef          	jal	ra,4a5c <close>
    if(write(pfds[1], "x", 1) != 1)
    377c:	4605                	li	a2,1
    377e:	00002597          	auipc	a1,0x2
    3782:	90a58593          	addi	a1,a1,-1782 # 5088 <malloc+0x194>
    3786:	fcc42503          	lw	a0,-52(s0)
    378a:	2ca010ef          	jal	ra,4a54 <write>
    378e:	4785                	li	a5,1
    3790:	02f51163          	bne	a0,a5,37b2 <preempt+0xa8>
    close(pfds[1]);
    3794:	fcc42503          	lw	a0,-52(s0)
    3798:	2c4010ef          	jal	ra,4a5c <close>
    for(;;)
    379c:	a001                	j	379c <preempt+0x92>
     printf("%s: fork failed\n", s);
    379e:	85ca                	mv	a1,s2
    37a0:	00002517          	auipc	a0,0x2
    37a4:	10850513          	addi	a0,a0,264 # 58a8 <malloc+0x9b4>
    37a8:	698010ef          	jal	ra,4e40 <printf>
     exit(1);
    37ac:	4505                	li	a0,1
    37ae:	286010ef          	jal	ra,4a34 <exit>
      printf("%s: preempt write error", s);
    37b2:	85ca                	mv	a1,s2
    37b4:	00003517          	auipc	a0,0x3
    37b8:	2fc50513          	addi	a0,a0,764 # 6ab0 <malloc+0x1bbc>
    37bc:	684010ef          	jal	ra,4e40 <printf>
    37c0:	bfd1                	j	3794 <preempt+0x8a>
  close(pfds[1]);
    37c2:	fcc42503          	lw	a0,-52(s0)
    37c6:	296010ef          	jal	ra,4a5c <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
    37ca:	660d                	lui	a2,0x3
    37cc:	00008597          	auipc	a1,0x8
    37d0:	4ac58593          	addi	a1,a1,1196 # bc78 <buf>
    37d4:	fc842503          	lw	a0,-56(s0)
    37d8:	274010ef          	jal	ra,4a4c <read>
    37dc:	4785                	li	a5,1
    37de:	02f50163          	beq	a0,a5,3800 <preempt+0xf6>
    printf("%s: preempt read error", s);
    37e2:	85ca                	mv	a1,s2
    37e4:	00003517          	auipc	a0,0x3
    37e8:	2e450513          	addi	a0,a0,740 # 6ac8 <malloc+0x1bd4>
    37ec:	654010ef          	jal	ra,4e40 <printf>
}
    37f0:	70e2                	ld	ra,56(sp)
    37f2:	7442                	ld	s0,48(sp)
    37f4:	74a2                	ld	s1,40(sp)
    37f6:	7902                	ld	s2,32(sp)
    37f8:	69e2                	ld	s3,24(sp)
    37fa:	6a42                	ld	s4,16(sp)
    37fc:	6121                	addi	sp,sp,64
    37fe:	8082                	ret
  close(pfds[0]);
    3800:	fc842503          	lw	a0,-56(s0)
    3804:	258010ef          	jal	ra,4a5c <close>
  printf("kill... ");
    3808:	00003517          	auipc	a0,0x3
    380c:	2d850513          	addi	a0,a0,728 # 6ae0 <malloc+0x1bec>
    3810:	630010ef          	jal	ra,4e40 <printf>
  kill(pid1);
    3814:	8526                	mv	a0,s1
    3816:	24e010ef          	jal	ra,4a64 <kill>
  kill(pid2);
    381a:	854e                	mv	a0,s3
    381c:	248010ef          	jal	ra,4a64 <kill>
  kill(pid3);
    3820:	8552                	mv	a0,s4
    3822:	242010ef          	jal	ra,4a64 <kill>
  printf("wait... ");
    3826:	00003517          	auipc	a0,0x3
    382a:	2ca50513          	addi	a0,a0,714 # 6af0 <malloc+0x1bfc>
    382e:	612010ef          	jal	ra,4e40 <printf>
  wait(0);
    3832:	4501                	li	a0,0
    3834:	208010ef          	jal	ra,4a3c <wait>
  wait(0);
    3838:	4501                	li	a0,0
    383a:	202010ef          	jal	ra,4a3c <wait>
  wait(0);
    383e:	4501                	li	a0,0
    3840:	1fc010ef          	jal	ra,4a3c <wait>
    3844:	b775                	j	37f0 <preempt+0xe6>

0000000000003846 <reparent>:
{
    3846:	7179                	addi	sp,sp,-48
    3848:	f406                	sd	ra,40(sp)
    384a:	f022                	sd	s0,32(sp)
    384c:	ec26                	sd	s1,24(sp)
    384e:	e84a                	sd	s2,16(sp)
    3850:	e44e                	sd	s3,8(sp)
    3852:	e052                	sd	s4,0(sp)
    3854:	1800                	addi	s0,sp,48
    3856:	89aa                	mv	s3,a0
  int master_pid = getpid();
    3858:	25c010ef          	jal	ra,4ab4 <getpid>
    385c:	8a2a                	mv	s4,a0
    385e:	0c800913          	li	s2,200
    int pid = fork();
    3862:	1ca010ef          	jal	ra,4a2c <fork>
    3866:	84aa                	mv	s1,a0
    if(pid < 0){
    3868:	00054e63          	bltz	a0,3884 <reparent+0x3e>
    if(pid){
    386c:	c121                	beqz	a0,38ac <reparent+0x66>
      if(wait(0) != pid){
    386e:	4501                	li	a0,0
    3870:	1cc010ef          	jal	ra,4a3c <wait>
    3874:	02951263          	bne	a0,s1,3898 <reparent+0x52>
  for(int i = 0; i < 200; i++){
    3878:	397d                	addiw	s2,s2,-1
    387a:	fe0914e3          	bnez	s2,3862 <reparent+0x1c>
  exit(0);
    387e:	4501                	li	a0,0
    3880:	1b4010ef          	jal	ra,4a34 <exit>
      printf("%s: fork failed\n", s);
    3884:	85ce                	mv	a1,s3
    3886:	00002517          	auipc	a0,0x2
    388a:	02250513          	addi	a0,a0,34 # 58a8 <malloc+0x9b4>
    388e:	5b2010ef          	jal	ra,4e40 <printf>
      exit(1);
    3892:	4505                	li	a0,1
    3894:	1a0010ef          	jal	ra,4a34 <exit>
        printf("%s: wait wrong pid\n", s);
    3898:	85ce                	mv	a1,s3
    389a:	00002517          	auipc	a0,0x2
    389e:	19650513          	addi	a0,a0,406 # 5a30 <malloc+0xb3c>
    38a2:	59e010ef          	jal	ra,4e40 <printf>
        exit(1);
    38a6:	4505                	li	a0,1
    38a8:	18c010ef          	jal	ra,4a34 <exit>
      int pid2 = fork();
    38ac:	180010ef          	jal	ra,4a2c <fork>
      if(pid2 < 0){
    38b0:	00054563          	bltz	a0,38ba <reparent+0x74>
      exit(0);
    38b4:	4501                	li	a0,0
    38b6:	17e010ef          	jal	ra,4a34 <exit>
        kill(master_pid);
    38ba:	8552                	mv	a0,s4
    38bc:	1a8010ef          	jal	ra,4a64 <kill>
        exit(1);
    38c0:	4505                	li	a0,1
    38c2:	172010ef          	jal	ra,4a34 <exit>

00000000000038c6 <sbrkfail>:
{
    38c6:	7119                	addi	sp,sp,-128
    38c8:	fc86                	sd	ra,120(sp)
    38ca:	f8a2                	sd	s0,112(sp)
    38cc:	f4a6                	sd	s1,104(sp)
    38ce:	f0ca                	sd	s2,96(sp)
    38d0:	ecce                	sd	s3,88(sp)
    38d2:	e8d2                	sd	s4,80(sp)
    38d4:	e4d6                	sd	s5,72(sp)
    38d6:	0100                	addi	s0,sp,128
    38d8:	8aaa                	mv	s5,a0
  if(pipe(fds) != 0){
    38da:	fb040513          	addi	a0,s0,-80
    38de:	166010ef          	jal	ra,4a44 <pipe>
    38e2:	e901                	bnez	a0,38f2 <sbrkfail+0x2c>
    38e4:	f8040493          	addi	s1,s0,-128
    38e8:	fa840993          	addi	s3,s0,-88
    38ec:	8926                	mv	s2,s1
    if(pids[i] != -1)
    38ee:	5a7d                	li	s4,-1
    38f0:	a0a1                	j	3938 <sbrkfail+0x72>
    printf("%s: pipe() failed\n", s);
    38f2:	85d6                	mv	a1,s5
    38f4:	00002517          	auipc	a0,0x2
    38f8:	0bc50513          	addi	a0,a0,188 # 59b0 <malloc+0xabc>
    38fc:	544010ef          	jal	ra,4e40 <printf>
    exit(1);
    3900:	4505                	li	a0,1
    3902:	132010ef          	jal	ra,4a34 <exit>
      sbrk(BIG - (uint64)sbrk(0));
    3906:	1b6010ef          	jal	ra,4abc <sbrk>
    390a:	064007b7          	lui	a5,0x6400
    390e:	40a7853b          	subw	a0,a5,a0
    3912:	1aa010ef          	jal	ra,4abc <sbrk>
      write(fds[1], "x", 1);
    3916:	4605                	li	a2,1
    3918:	00001597          	auipc	a1,0x1
    391c:	77058593          	addi	a1,a1,1904 # 5088 <malloc+0x194>
    3920:	fb442503          	lw	a0,-76(s0)
    3924:	130010ef          	jal	ra,4a54 <write>
      for(;;) sleep(1000);
    3928:	3e800513          	li	a0,1000
    392c:	198010ef          	jal	ra,4ac4 <sleep>
    3930:	bfe5                	j	3928 <sbrkfail+0x62>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    3932:	0911                	addi	s2,s2,4
    3934:	03390163          	beq	s2,s3,3956 <sbrkfail+0x90>
    if((pids[i] = fork()) == 0){
    3938:	0f4010ef          	jal	ra,4a2c <fork>
    393c:	00a92023          	sw	a0,0(s2)
    3940:	d179                	beqz	a0,3906 <sbrkfail+0x40>
    if(pids[i] != -1)
    3942:	ff4508e3          	beq	a0,s4,3932 <sbrkfail+0x6c>
      read(fds[0], &scratch, 1);
    3946:	4605                	li	a2,1
    3948:	faf40593          	addi	a1,s0,-81
    394c:	fb042503          	lw	a0,-80(s0)
    3950:	0fc010ef          	jal	ra,4a4c <read>
    3954:	bff9                	j	3932 <sbrkfail+0x6c>
  c = sbrk(PGSIZE);
    3956:	6505                	lui	a0,0x1
    3958:	164010ef          	jal	ra,4abc <sbrk>
    395c:	8a2a                	mv	s4,a0
    if(pids[i] == -1)
    395e:	597d                	li	s2,-1
    3960:	a021                	j	3968 <sbrkfail+0xa2>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    3962:	0491                	addi	s1,s1,4
    3964:	01348b63          	beq	s1,s3,397a <sbrkfail+0xb4>
    if(pids[i] == -1)
    3968:	4088                	lw	a0,0(s1)
    396a:	ff250ce3          	beq	a0,s2,3962 <sbrkfail+0x9c>
    kill(pids[i]);
    396e:	0f6010ef          	jal	ra,4a64 <kill>
    wait(0);
    3972:	4501                	li	a0,0
    3974:	0c8010ef          	jal	ra,4a3c <wait>
    3978:	b7ed                	j	3962 <sbrkfail+0x9c>
  if(c == (char*)0xffffffffffffffffL){
    397a:	57fd                	li	a5,-1
    397c:	02fa0d63          	beq	s4,a5,39b6 <sbrkfail+0xf0>
  pid = fork();
    3980:	0ac010ef          	jal	ra,4a2c <fork>
    3984:	84aa                	mv	s1,a0
  if(pid < 0){
    3986:	04054263          	bltz	a0,39ca <sbrkfail+0x104>
  if(pid == 0){
    398a:	c931                	beqz	a0,39de <sbrkfail+0x118>
  wait(&xstatus);
    398c:	fbc40513          	addi	a0,s0,-68
    3990:	0ac010ef          	jal	ra,4a3c <wait>
  if(xstatus != -1 && xstatus != 2)
    3994:	fbc42783          	lw	a5,-68(s0)
    3998:	577d                	li	a4,-1
    399a:	00e78563          	beq	a5,a4,39a4 <sbrkfail+0xde>
    399e:	4709                	li	a4,2
    39a0:	06e79d63          	bne	a5,a4,3a1a <sbrkfail+0x154>
}
    39a4:	70e6                	ld	ra,120(sp)
    39a6:	7446                	ld	s0,112(sp)
    39a8:	74a6                	ld	s1,104(sp)
    39aa:	7906                	ld	s2,96(sp)
    39ac:	69e6                	ld	s3,88(sp)
    39ae:	6a46                	ld	s4,80(sp)
    39b0:	6aa6                	ld	s5,72(sp)
    39b2:	6109                	addi	sp,sp,128
    39b4:	8082                	ret
    printf("%s: failed sbrk leaked memory\n", s);
    39b6:	85d6                	mv	a1,s5
    39b8:	00003517          	auipc	a0,0x3
    39bc:	14850513          	addi	a0,a0,328 # 6b00 <malloc+0x1c0c>
    39c0:	480010ef          	jal	ra,4e40 <printf>
    exit(1);
    39c4:	4505                	li	a0,1
    39c6:	06e010ef          	jal	ra,4a34 <exit>
    printf("%s: fork failed\n", s);
    39ca:	85d6                	mv	a1,s5
    39cc:	00002517          	auipc	a0,0x2
    39d0:	edc50513          	addi	a0,a0,-292 # 58a8 <malloc+0x9b4>
    39d4:	46c010ef          	jal	ra,4e40 <printf>
    exit(1);
    39d8:	4505                	li	a0,1
    39da:	05a010ef          	jal	ra,4a34 <exit>
    a = sbrk(0);
    39de:	4501                	li	a0,0
    39e0:	0dc010ef          	jal	ra,4abc <sbrk>
    39e4:	892a                	mv	s2,a0
    sbrk(10*BIG);
    39e6:	3e800537          	lui	a0,0x3e800
    39ea:	0d2010ef          	jal	ra,4abc <sbrk>
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    39ee:	87ca                	mv	a5,s2
    39f0:	3e800737          	lui	a4,0x3e800
    39f4:	993a                	add	s2,s2,a4
    39f6:	6705                	lui	a4,0x1
      n += *(a+i);
    39f8:	0007c683          	lbu	a3,0(a5) # 6400000 <base+0x63f1388>
    39fc:	9cb5                	addw	s1,s1,a3
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    39fe:	97ba                	add	a5,a5,a4
    3a00:	ff279ce3          	bne	a5,s2,39f8 <sbrkfail+0x132>
    printf("%s: allocate a lot of memory succeeded %d\n", s, n);
    3a04:	8626                	mv	a2,s1
    3a06:	85d6                	mv	a1,s5
    3a08:	00003517          	auipc	a0,0x3
    3a0c:	11850513          	addi	a0,a0,280 # 6b20 <malloc+0x1c2c>
    3a10:	430010ef          	jal	ra,4e40 <printf>
    exit(1);
    3a14:	4505                	li	a0,1
    3a16:	01e010ef          	jal	ra,4a34 <exit>
    exit(1);
    3a1a:	4505                	li	a0,1
    3a1c:	018010ef          	jal	ra,4a34 <exit>

0000000000003a20 <mem>:
{
    3a20:	7139                	addi	sp,sp,-64
    3a22:	fc06                	sd	ra,56(sp)
    3a24:	f822                	sd	s0,48(sp)
    3a26:	f426                	sd	s1,40(sp)
    3a28:	f04a                	sd	s2,32(sp)
    3a2a:	ec4e                	sd	s3,24(sp)
    3a2c:	0080                	addi	s0,sp,64
    3a2e:	89aa                	mv	s3,a0
  if((pid = fork()) == 0){
    3a30:	7fd000ef          	jal	ra,4a2c <fork>
    m1 = 0;
    3a34:	4481                	li	s1,0
    while((m2 = malloc(10001)) != 0){
    3a36:	6909                	lui	s2,0x2
    3a38:	71190913          	addi	s2,s2,1809 # 2711 <fourteen+0xd1>
  if((pid = fork()) == 0){
    3a3c:	cd11                	beqz	a0,3a58 <mem+0x38>
    wait(&xstatus);
    3a3e:	fcc40513          	addi	a0,s0,-52
    3a42:	7fb000ef          	jal	ra,4a3c <wait>
    if(xstatus == -1){
    3a46:	fcc42503          	lw	a0,-52(s0)
    3a4a:	57fd                	li	a5,-1
    3a4c:	04f50363          	beq	a0,a5,3a92 <mem+0x72>
    exit(xstatus);
    3a50:	7e5000ef          	jal	ra,4a34 <exit>
      *(char**)m2 = m1;
    3a54:	e104                	sd	s1,0(a0)
      m1 = m2;
    3a56:	84aa                	mv	s1,a0
    while((m2 = malloc(10001)) != 0){
    3a58:	854a                	mv	a0,s2
    3a5a:	49a010ef          	jal	ra,4ef4 <malloc>
    3a5e:	f97d                	bnez	a0,3a54 <mem+0x34>
    while(m1){
    3a60:	c491                	beqz	s1,3a6c <mem+0x4c>
      m2 = *(char**)m1;
    3a62:	8526                	mv	a0,s1
    3a64:	6084                	ld	s1,0(s1)
      free(m1);
    3a66:	40c010ef          	jal	ra,4e72 <free>
    while(m1){
    3a6a:	fce5                	bnez	s1,3a62 <mem+0x42>
    m1 = malloc(1024*20);
    3a6c:	6515                	lui	a0,0x5
    3a6e:	486010ef          	jal	ra,4ef4 <malloc>
    if(m1 == 0){
    3a72:	c511                	beqz	a0,3a7e <mem+0x5e>
    free(m1);
    3a74:	3fe010ef          	jal	ra,4e72 <free>
    exit(0);
    3a78:	4501                	li	a0,0
    3a7a:	7bb000ef          	jal	ra,4a34 <exit>
      printf("%s: couldn't allocate mem?!!\n", s);
    3a7e:	85ce                	mv	a1,s3
    3a80:	00003517          	auipc	a0,0x3
    3a84:	0d050513          	addi	a0,a0,208 # 6b50 <malloc+0x1c5c>
    3a88:	3b8010ef          	jal	ra,4e40 <printf>
      exit(1);
    3a8c:	4505                	li	a0,1
    3a8e:	7a7000ef          	jal	ra,4a34 <exit>
      exit(0);
    3a92:	4501                	li	a0,0
    3a94:	7a1000ef          	jal	ra,4a34 <exit>

0000000000003a98 <sharedfd>:
{
    3a98:	7159                	addi	sp,sp,-112
    3a9a:	f486                	sd	ra,104(sp)
    3a9c:	f0a2                	sd	s0,96(sp)
    3a9e:	eca6                	sd	s1,88(sp)
    3aa0:	e8ca                	sd	s2,80(sp)
    3aa2:	e4ce                	sd	s3,72(sp)
    3aa4:	e0d2                	sd	s4,64(sp)
    3aa6:	fc56                	sd	s5,56(sp)
    3aa8:	f85a                	sd	s6,48(sp)
    3aaa:	f45e                	sd	s7,40(sp)
    3aac:	1880                	addi	s0,sp,112
    3aae:	8a2a                	mv	s4,a0
  unlink("sharedfd");
    3ab0:	00003517          	auipc	a0,0x3
    3ab4:	0c050513          	addi	a0,a0,192 # 6b70 <malloc+0x1c7c>
    3ab8:	7cd000ef          	jal	ra,4a84 <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
    3abc:	20200593          	li	a1,514
    3ac0:	00003517          	auipc	a0,0x3
    3ac4:	0b050513          	addi	a0,a0,176 # 6b70 <malloc+0x1c7c>
    3ac8:	7ad000ef          	jal	ra,4a74 <open>
  if(fd < 0){
    3acc:	04054263          	bltz	a0,3b10 <sharedfd+0x78>
    3ad0:	892a                	mv	s2,a0
  pid = fork();
    3ad2:	75b000ef          	jal	ra,4a2c <fork>
    3ad6:	89aa                	mv	s3,a0
  memset(buf, pid==0?'c':'p', sizeof(buf));
    3ad8:	06300593          	li	a1,99
    3adc:	c119                	beqz	a0,3ae2 <sharedfd+0x4a>
    3ade:	07000593          	li	a1,112
    3ae2:	4629                	li	a2,10
    3ae4:	fa040513          	addi	a0,s0,-96
    3ae8:	567000ef          	jal	ra,484e <memset>
    3aec:	3e800493          	li	s1,1000
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
    3af0:	4629                	li	a2,10
    3af2:	fa040593          	addi	a1,s0,-96
    3af6:	854a                	mv	a0,s2
    3af8:	75d000ef          	jal	ra,4a54 <write>
    3afc:	47a9                	li	a5,10
    3afe:	02f51363          	bne	a0,a5,3b24 <sharedfd+0x8c>
  for(i = 0; i < N; i++){
    3b02:	34fd                	addiw	s1,s1,-1
    3b04:	f4f5                	bnez	s1,3af0 <sharedfd+0x58>
  if(pid == 0) {
    3b06:	02099963          	bnez	s3,3b38 <sharedfd+0xa0>
    exit(0);
    3b0a:	4501                	li	a0,0
    3b0c:	729000ef          	jal	ra,4a34 <exit>
    printf("%s: cannot open sharedfd for writing", s);
    3b10:	85d2                	mv	a1,s4
    3b12:	00003517          	auipc	a0,0x3
    3b16:	06e50513          	addi	a0,a0,110 # 6b80 <malloc+0x1c8c>
    3b1a:	326010ef          	jal	ra,4e40 <printf>
    exit(1);
    3b1e:	4505                	li	a0,1
    3b20:	715000ef          	jal	ra,4a34 <exit>
      printf("%s: write sharedfd failed\n", s);
    3b24:	85d2                	mv	a1,s4
    3b26:	00003517          	auipc	a0,0x3
    3b2a:	08250513          	addi	a0,a0,130 # 6ba8 <malloc+0x1cb4>
    3b2e:	312010ef          	jal	ra,4e40 <printf>
      exit(1);
    3b32:	4505                	li	a0,1
    3b34:	701000ef          	jal	ra,4a34 <exit>
    wait(&xstatus);
    3b38:	f9c40513          	addi	a0,s0,-100
    3b3c:	701000ef          	jal	ra,4a3c <wait>
    if(xstatus != 0)
    3b40:	f9c42983          	lw	s3,-100(s0)
    3b44:	00098563          	beqz	s3,3b4e <sharedfd+0xb6>
      exit(xstatus);
    3b48:	854e                	mv	a0,s3
    3b4a:	6eb000ef          	jal	ra,4a34 <exit>
  close(fd);
    3b4e:	854a                	mv	a0,s2
    3b50:	70d000ef          	jal	ra,4a5c <close>
  fd = open("sharedfd", 0);
    3b54:	4581                	li	a1,0
    3b56:	00003517          	auipc	a0,0x3
    3b5a:	01a50513          	addi	a0,a0,26 # 6b70 <malloc+0x1c7c>
    3b5e:	717000ef          	jal	ra,4a74 <open>
    3b62:	8baa                	mv	s7,a0
  nc = np = 0;
    3b64:	8ace                	mv	s5,s3
  if(fd < 0){
    3b66:	02054363          	bltz	a0,3b8c <sharedfd+0xf4>
    3b6a:	faa40913          	addi	s2,s0,-86
      if(buf[i] == 'c')
    3b6e:	06300493          	li	s1,99
      if(buf[i] == 'p')
    3b72:	07000b13          	li	s6,112
  while((n = read(fd, buf, sizeof(buf))) > 0){
    3b76:	4629                	li	a2,10
    3b78:	fa040593          	addi	a1,s0,-96
    3b7c:	855e                	mv	a0,s7
    3b7e:	6cf000ef          	jal	ra,4a4c <read>
    3b82:	02a05b63          	blez	a0,3bb8 <sharedfd+0x120>
    3b86:	fa040793          	addi	a5,s0,-96
    3b8a:	a839                	j	3ba8 <sharedfd+0x110>
    printf("%s: cannot open sharedfd for reading\n", s);
    3b8c:	85d2                	mv	a1,s4
    3b8e:	00003517          	auipc	a0,0x3
    3b92:	03a50513          	addi	a0,a0,58 # 6bc8 <malloc+0x1cd4>
    3b96:	2aa010ef          	jal	ra,4e40 <printf>
    exit(1);
    3b9a:	4505                	li	a0,1
    3b9c:	699000ef          	jal	ra,4a34 <exit>
        nc++;
    3ba0:	2985                	addiw	s3,s3,1
    for(i = 0; i < sizeof(buf); i++){
    3ba2:	0785                	addi	a5,a5,1
    3ba4:	fd2789e3          	beq	a5,s2,3b76 <sharedfd+0xde>
      if(buf[i] == 'c')
    3ba8:	0007c703          	lbu	a4,0(a5)
    3bac:	fe970ae3          	beq	a4,s1,3ba0 <sharedfd+0x108>
      if(buf[i] == 'p')
    3bb0:	ff6719e3          	bne	a4,s6,3ba2 <sharedfd+0x10a>
        np++;
    3bb4:	2a85                	addiw	s5,s5,1
    3bb6:	b7f5                	j	3ba2 <sharedfd+0x10a>
  close(fd);
    3bb8:	855e                	mv	a0,s7
    3bba:	6a3000ef          	jal	ra,4a5c <close>
  unlink("sharedfd");
    3bbe:	00003517          	auipc	a0,0x3
    3bc2:	fb250513          	addi	a0,a0,-78 # 6b70 <malloc+0x1c7c>
    3bc6:	6bf000ef          	jal	ra,4a84 <unlink>
  if(nc == N*SZ && np == N*SZ){
    3bca:	6789                	lui	a5,0x2
    3bcc:	71078793          	addi	a5,a5,1808 # 2710 <fourteen+0xd0>
    3bd0:	00f99763          	bne	s3,a5,3bde <sharedfd+0x146>
    3bd4:	6789                	lui	a5,0x2
    3bd6:	71078793          	addi	a5,a5,1808 # 2710 <fourteen+0xd0>
    3bda:	00fa8c63          	beq	s5,a5,3bf2 <sharedfd+0x15a>
    printf("%s: nc/np test fails\n", s);
    3bde:	85d2                	mv	a1,s4
    3be0:	00003517          	auipc	a0,0x3
    3be4:	01050513          	addi	a0,a0,16 # 6bf0 <malloc+0x1cfc>
    3be8:	258010ef          	jal	ra,4e40 <printf>
    exit(1);
    3bec:	4505                	li	a0,1
    3bee:	647000ef          	jal	ra,4a34 <exit>
    exit(0);
    3bf2:	4501                	li	a0,0
    3bf4:	641000ef          	jal	ra,4a34 <exit>

0000000000003bf8 <fourfiles>:
{
    3bf8:	7171                	addi	sp,sp,-176
    3bfa:	f506                	sd	ra,168(sp)
    3bfc:	f122                	sd	s0,160(sp)
    3bfe:	ed26                	sd	s1,152(sp)
    3c00:	e94a                	sd	s2,144(sp)
    3c02:	e54e                	sd	s3,136(sp)
    3c04:	e152                	sd	s4,128(sp)
    3c06:	fcd6                	sd	s5,120(sp)
    3c08:	f8da                	sd	s6,112(sp)
    3c0a:	f4de                	sd	s7,104(sp)
    3c0c:	f0e2                	sd	s8,96(sp)
    3c0e:	ece6                	sd	s9,88(sp)
    3c10:	e8ea                	sd	s10,80(sp)
    3c12:	e4ee                	sd	s11,72(sp)
    3c14:	1900                	addi	s0,sp,176
    3c16:	f4a43c23          	sd	a0,-168(s0)
  char *names[] = { "f0", "f1", "f2", "f3" };
    3c1a:	00003797          	auipc	a5,0x3
    3c1e:	fee78793          	addi	a5,a5,-18 # 6c08 <malloc+0x1d14>
    3c22:	f6f43823          	sd	a5,-144(s0)
    3c26:	00003797          	auipc	a5,0x3
    3c2a:	fea78793          	addi	a5,a5,-22 # 6c10 <malloc+0x1d1c>
    3c2e:	f6f43c23          	sd	a5,-136(s0)
    3c32:	00003797          	auipc	a5,0x3
    3c36:	fe678793          	addi	a5,a5,-26 # 6c18 <malloc+0x1d24>
    3c3a:	f8f43023          	sd	a5,-128(s0)
    3c3e:	00003797          	auipc	a5,0x3
    3c42:	fe278793          	addi	a5,a5,-30 # 6c20 <malloc+0x1d2c>
    3c46:	f8f43423          	sd	a5,-120(s0)
  for(pi = 0; pi < NCHILD; pi++){
    3c4a:	f7040c13          	addi	s8,s0,-144
  char *names[] = { "f0", "f1", "f2", "f3" };
    3c4e:	8962                	mv	s2,s8
  for(pi = 0; pi < NCHILD; pi++){
    3c50:	4481                	li	s1,0
    3c52:	4a11                	li	s4,4
    fname = names[pi];
    3c54:	00093983          	ld	s3,0(s2)
    unlink(fname);
    3c58:	854e                	mv	a0,s3
    3c5a:	62b000ef          	jal	ra,4a84 <unlink>
    pid = fork();
    3c5e:	5cf000ef          	jal	ra,4a2c <fork>
    if(pid < 0){
    3c62:	04054263          	bltz	a0,3ca6 <fourfiles+0xae>
    if(pid == 0){
    3c66:	c939                	beqz	a0,3cbc <fourfiles+0xc4>
  for(pi = 0; pi < NCHILD; pi++){
    3c68:	2485                	addiw	s1,s1,1
    3c6a:	0921                	addi	s2,s2,8
    3c6c:	ff4494e3          	bne	s1,s4,3c54 <fourfiles+0x5c>
    3c70:	4491                	li	s1,4
    wait(&xstatus);
    3c72:	f6c40513          	addi	a0,s0,-148
    3c76:	5c7000ef          	jal	ra,4a3c <wait>
    if(xstatus != 0)
    3c7a:	f6c42b03          	lw	s6,-148(s0)
    3c7e:	0a0b1a63          	bnez	s6,3d32 <fourfiles+0x13a>
  for(pi = 0; pi < NCHILD; pi++){
    3c82:	34fd                	addiw	s1,s1,-1
    3c84:	f4fd                	bnez	s1,3c72 <fourfiles+0x7a>
    3c86:	03000b93          	li	s7,48
    while((n = read(fd, buf, sizeof(buf))) > 0){
    3c8a:	00008a17          	auipc	s4,0x8
    3c8e:	feea0a13          	addi	s4,s4,-18 # bc78 <buf>
    3c92:	00008a97          	auipc	s5,0x8
    3c96:	fe7a8a93          	addi	s5,s5,-25 # bc79 <buf+0x1>
    if(total != N*SZ){
    3c9a:	6d85                	lui	s11,0x1
    3c9c:	770d8d93          	addi	s11,s11,1904 # 1770 <forkfork+0x4c>
  for(i = 0; i < NCHILD; i++){
    3ca0:	03400d13          	li	s10,52
    3ca4:	a8dd                	j	3d9a <fourfiles+0x1a2>
      printf("%s: fork failed\n", s);
    3ca6:	f5843583          	ld	a1,-168(s0)
    3caa:	00002517          	auipc	a0,0x2
    3cae:	bfe50513          	addi	a0,a0,-1026 # 58a8 <malloc+0x9b4>
    3cb2:	18e010ef          	jal	ra,4e40 <printf>
      exit(1);
    3cb6:	4505                	li	a0,1
    3cb8:	57d000ef          	jal	ra,4a34 <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    3cbc:	20200593          	li	a1,514
    3cc0:	854e                	mv	a0,s3
    3cc2:	5b3000ef          	jal	ra,4a74 <open>
    3cc6:	892a                	mv	s2,a0
      if(fd < 0){
    3cc8:	04054163          	bltz	a0,3d0a <fourfiles+0x112>
      memset(buf, '0'+pi, SZ);
    3ccc:	1f400613          	li	a2,500
    3cd0:	0304859b          	addiw	a1,s1,48
    3cd4:	00008517          	auipc	a0,0x8
    3cd8:	fa450513          	addi	a0,a0,-92 # bc78 <buf>
    3cdc:	373000ef          	jal	ra,484e <memset>
    3ce0:	44b1                	li	s1,12
        if((n = write(fd, buf, SZ)) != SZ){
    3ce2:	00008997          	auipc	s3,0x8
    3ce6:	f9698993          	addi	s3,s3,-106 # bc78 <buf>
    3cea:	1f400613          	li	a2,500
    3cee:	85ce                	mv	a1,s3
    3cf0:	854a                	mv	a0,s2
    3cf2:	563000ef          	jal	ra,4a54 <write>
    3cf6:	85aa                	mv	a1,a0
    3cf8:	1f400793          	li	a5,500
    3cfc:	02f51263          	bne	a0,a5,3d20 <fourfiles+0x128>
      for(i = 0; i < N; i++){
    3d00:	34fd                	addiw	s1,s1,-1
    3d02:	f4e5                	bnez	s1,3cea <fourfiles+0xf2>
      exit(0);
    3d04:	4501                	li	a0,0
    3d06:	52f000ef          	jal	ra,4a34 <exit>
        printf("%s: create failed\n", s);
    3d0a:	f5843583          	ld	a1,-168(s0)
    3d0e:	00002517          	auipc	a0,0x2
    3d12:	c3250513          	addi	a0,a0,-974 # 5940 <malloc+0xa4c>
    3d16:	12a010ef          	jal	ra,4e40 <printf>
        exit(1);
    3d1a:	4505                	li	a0,1
    3d1c:	519000ef          	jal	ra,4a34 <exit>
          printf("write failed %d\n", n);
    3d20:	00003517          	auipc	a0,0x3
    3d24:	f0850513          	addi	a0,a0,-248 # 6c28 <malloc+0x1d34>
    3d28:	118010ef          	jal	ra,4e40 <printf>
          exit(1);
    3d2c:	4505                	li	a0,1
    3d2e:	507000ef          	jal	ra,4a34 <exit>
      exit(xstatus);
    3d32:	855a                	mv	a0,s6
    3d34:	501000ef          	jal	ra,4a34 <exit>
          printf("%s: wrong char\n", s);
    3d38:	f5843583          	ld	a1,-168(s0)
    3d3c:	00003517          	auipc	a0,0x3
    3d40:	f0450513          	addi	a0,a0,-252 # 6c40 <malloc+0x1d4c>
    3d44:	0fc010ef          	jal	ra,4e40 <printf>
          exit(1);
    3d48:	4505                	li	a0,1
    3d4a:	4eb000ef          	jal	ra,4a34 <exit>
      total += n;
    3d4e:	00a9093b          	addw	s2,s2,a0
    while((n = read(fd, buf, sizeof(buf))) > 0){
    3d52:	660d                	lui	a2,0x3
    3d54:	85d2                	mv	a1,s4
    3d56:	854e                	mv	a0,s3
    3d58:	4f5000ef          	jal	ra,4a4c <read>
    3d5c:	02a05363          	blez	a0,3d82 <fourfiles+0x18a>
    3d60:	00008797          	auipc	a5,0x8
    3d64:	f1878793          	addi	a5,a5,-232 # bc78 <buf>
    3d68:	fff5069b          	addiw	a3,a0,-1
    3d6c:	1682                	slli	a3,a3,0x20
    3d6e:	9281                	srli	a3,a3,0x20
    3d70:	96d6                	add	a3,a3,s5
        if(buf[j] != '0'+i){
    3d72:	0007c703          	lbu	a4,0(a5)
    3d76:	fc9711e3          	bne	a4,s1,3d38 <fourfiles+0x140>
      for(j = 0; j < n; j++){
    3d7a:	0785                	addi	a5,a5,1
    3d7c:	fed79be3          	bne	a5,a3,3d72 <fourfiles+0x17a>
    3d80:	b7f9                	j	3d4e <fourfiles+0x156>
    close(fd);
    3d82:	854e                	mv	a0,s3
    3d84:	4d9000ef          	jal	ra,4a5c <close>
    if(total != N*SZ){
    3d88:	03b91463          	bne	s2,s11,3db0 <fourfiles+0x1b8>
    unlink(fname);
    3d8c:	8566                	mv	a0,s9
    3d8e:	4f7000ef          	jal	ra,4a84 <unlink>
  for(i = 0; i < NCHILD; i++){
    3d92:	0c21                	addi	s8,s8,8
    3d94:	2b85                	addiw	s7,s7,1
    3d96:	03ab8763          	beq	s7,s10,3dc4 <fourfiles+0x1cc>
    fname = names[i];
    3d9a:	000c3c83          	ld	s9,0(s8)
    fd = open(fname, 0);
    3d9e:	4581                	li	a1,0
    3da0:	8566                	mv	a0,s9
    3da2:	4d3000ef          	jal	ra,4a74 <open>
    3da6:	89aa                	mv	s3,a0
    total = 0;
    3da8:	895a                	mv	s2,s6
        if(buf[j] != '0'+i){
    3daa:	000b849b          	sext.w	s1,s7
    while((n = read(fd, buf, sizeof(buf))) > 0){
    3dae:	b755                	j	3d52 <fourfiles+0x15a>
      printf("wrong length %d\n", total);
    3db0:	85ca                	mv	a1,s2
    3db2:	00003517          	auipc	a0,0x3
    3db6:	e9e50513          	addi	a0,a0,-354 # 6c50 <malloc+0x1d5c>
    3dba:	086010ef          	jal	ra,4e40 <printf>
      exit(1);
    3dbe:	4505                	li	a0,1
    3dc0:	475000ef          	jal	ra,4a34 <exit>
}
    3dc4:	70aa                	ld	ra,168(sp)
    3dc6:	740a                	ld	s0,160(sp)
    3dc8:	64ea                	ld	s1,152(sp)
    3dca:	694a                	ld	s2,144(sp)
    3dcc:	69aa                	ld	s3,136(sp)
    3dce:	6a0a                	ld	s4,128(sp)
    3dd0:	7ae6                	ld	s5,120(sp)
    3dd2:	7b46                	ld	s6,112(sp)
    3dd4:	7ba6                	ld	s7,104(sp)
    3dd6:	7c06                	ld	s8,96(sp)
    3dd8:	6ce6                	ld	s9,88(sp)
    3dda:	6d46                	ld	s10,80(sp)
    3ddc:	6da6                	ld	s11,72(sp)
    3dde:	614d                	addi	sp,sp,176
    3de0:	8082                	ret

0000000000003de2 <concreate>:
{
    3de2:	7135                	addi	sp,sp,-160
    3de4:	ed06                	sd	ra,152(sp)
    3de6:	e922                	sd	s0,144(sp)
    3de8:	e526                	sd	s1,136(sp)
    3dea:	e14a                	sd	s2,128(sp)
    3dec:	fcce                	sd	s3,120(sp)
    3dee:	f8d2                	sd	s4,112(sp)
    3df0:	f4d6                	sd	s5,104(sp)
    3df2:	f0da                	sd	s6,96(sp)
    3df4:	ecde                	sd	s7,88(sp)
    3df6:	1100                	addi	s0,sp,160
    3df8:	89aa                	mv	s3,a0
  file[0] = 'C';
    3dfa:	04300793          	li	a5,67
    3dfe:	faf40423          	sb	a5,-88(s0)
  file[2] = '\0';
    3e02:	fa040523          	sb	zero,-86(s0)
  for(i = 0; i < N; i++){
    3e06:	4901                	li	s2,0
    if(pid && (i % 3) == 1){
    3e08:	4b0d                	li	s6,3
    3e0a:	4a85                	li	s5,1
      link("C0", file);
    3e0c:	00003b97          	auipc	s7,0x3
    3e10:	e5cb8b93          	addi	s7,s7,-420 # 6c68 <malloc+0x1d74>
  for(i = 0; i < N; i++){
    3e14:	02800a13          	li	s4,40
    3e18:	a41d                	j	403e <concreate+0x25c>
      link("C0", file);
    3e1a:	fa840593          	addi	a1,s0,-88
    3e1e:	855e                	mv	a0,s7
    3e20:	475000ef          	jal	ra,4a94 <link>
    if(pid == 0) {
    3e24:	a411                	j	4028 <concreate+0x246>
    } else if(pid == 0 && (i % 5) == 1){
    3e26:	4795                	li	a5,5
    3e28:	02f9693b          	remw	s2,s2,a5
    3e2c:	4785                	li	a5,1
    3e2e:	02f90563          	beq	s2,a5,3e58 <concreate+0x76>
      fd = open(file, O_CREATE | O_RDWR);
    3e32:	20200593          	li	a1,514
    3e36:	fa840513          	addi	a0,s0,-88
    3e3a:	43b000ef          	jal	ra,4a74 <open>
      if(fd < 0){
    3e3e:	1e055063          	bgez	a0,401e <concreate+0x23c>
        printf("concreate create %s failed\n", file);
    3e42:	fa840593          	addi	a1,s0,-88
    3e46:	00003517          	auipc	a0,0x3
    3e4a:	e2a50513          	addi	a0,a0,-470 # 6c70 <malloc+0x1d7c>
    3e4e:	7f3000ef          	jal	ra,4e40 <printf>
        exit(1);
    3e52:	4505                	li	a0,1
    3e54:	3e1000ef          	jal	ra,4a34 <exit>
      link("C0", file);
    3e58:	fa840593          	addi	a1,s0,-88
    3e5c:	00003517          	auipc	a0,0x3
    3e60:	e0c50513          	addi	a0,a0,-500 # 6c68 <malloc+0x1d74>
    3e64:	431000ef          	jal	ra,4a94 <link>
      exit(0);
    3e68:	4501                	li	a0,0
    3e6a:	3cb000ef          	jal	ra,4a34 <exit>
        exit(1);
    3e6e:	4505                	li	a0,1
    3e70:	3c5000ef          	jal	ra,4a34 <exit>
  memset(fa, 0, sizeof(fa));
    3e74:	02800613          	li	a2,40
    3e78:	4581                	li	a1,0
    3e7a:	f8040513          	addi	a0,s0,-128
    3e7e:	1d1000ef          	jal	ra,484e <memset>
  fd = open(".", 0);
    3e82:	4581                	li	a1,0
    3e84:	00002517          	auipc	a0,0x2
    3e88:	87c50513          	addi	a0,a0,-1924 # 5700 <malloc+0x80c>
    3e8c:	3e9000ef          	jal	ra,4a74 <open>
    3e90:	892a                	mv	s2,a0
  n = 0;
    3e92:	8aa6                	mv	s5,s1
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    3e94:	04300a13          	li	s4,67
      if(i < 0 || i >= sizeof(fa)){
    3e98:	02700b13          	li	s6,39
      fa[i] = 1;
    3e9c:	4b85                	li	s7,1
  while(read(fd, &de, sizeof(de)) > 0){
    3e9e:	4641                	li	a2,16
    3ea0:	f7040593          	addi	a1,s0,-144
    3ea4:	854a                	mv	a0,s2
    3ea6:	3a7000ef          	jal	ra,4a4c <read>
    3eaa:	06a05a63          	blez	a0,3f1e <concreate+0x13c>
    if(de.inum == 0)
    3eae:	f7045783          	lhu	a5,-144(s0)
    3eb2:	d7f5                	beqz	a5,3e9e <concreate+0xbc>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    3eb4:	f7244783          	lbu	a5,-142(s0)
    3eb8:	ff4793e3          	bne	a5,s4,3e9e <concreate+0xbc>
    3ebc:	f7444783          	lbu	a5,-140(s0)
    3ec0:	fff9                	bnez	a5,3e9e <concreate+0xbc>
      i = de.name[1] - '0';
    3ec2:	f7344783          	lbu	a5,-141(s0)
    3ec6:	fd07879b          	addiw	a5,a5,-48
    3eca:	0007871b          	sext.w	a4,a5
      if(i < 0 || i >= sizeof(fa)){
    3ece:	02eb6063          	bltu	s6,a4,3eee <concreate+0x10c>
      if(fa[i]){
    3ed2:	fb070793          	addi	a5,a4,-80 # fb0 <bigdir+0x112>
    3ed6:	97a2                	add	a5,a5,s0
    3ed8:	fd07c783          	lbu	a5,-48(a5)
    3edc:	e78d                	bnez	a5,3f06 <concreate+0x124>
      fa[i] = 1;
    3ede:	fb070793          	addi	a5,a4,-80
    3ee2:	00878733          	add	a4,a5,s0
    3ee6:	fd770823          	sb	s7,-48(a4)
      n++;
    3eea:	2a85                	addiw	s5,s5,1
    3eec:	bf4d                	j	3e9e <concreate+0xbc>
        printf("%s: concreate weird file %s\n", s, de.name);
    3eee:	f7240613          	addi	a2,s0,-142
    3ef2:	85ce                	mv	a1,s3
    3ef4:	00003517          	auipc	a0,0x3
    3ef8:	d9c50513          	addi	a0,a0,-612 # 6c90 <malloc+0x1d9c>
    3efc:	745000ef          	jal	ra,4e40 <printf>
        exit(1);
    3f00:	4505                	li	a0,1
    3f02:	333000ef          	jal	ra,4a34 <exit>
        printf("%s: concreate duplicate file %s\n", s, de.name);
    3f06:	f7240613          	addi	a2,s0,-142
    3f0a:	85ce                	mv	a1,s3
    3f0c:	00003517          	auipc	a0,0x3
    3f10:	da450513          	addi	a0,a0,-604 # 6cb0 <malloc+0x1dbc>
    3f14:	72d000ef          	jal	ra,4e40 <printf>
        exit(1);
    3f18:	4505                	li	a0,1
    3f1a:	31b000ef          	jal	ra,4a34 <exit>
  close(fd);
    3f1e:	854a                	mv	a0,s2
    3f20:	33d000ef          	jal	ra,4a5c <close>
  if(n != N){
    3f24:	02800793          	li	a5,40
    3f28:	00fa9763          	bne	s5,a5,3f36 <concreate+0x154>
    if(((i % 3) == 0 && pid == 0) ||
    3f2c:	4a8d                	li	s5,3
    3f2e:	4b05                	li	s6,1
  for(i = 0; i < N; i++){
    3f30:	02800a13          	li	s4,40
    3f34:	a079                	j	3fc2 <concreate+0x1e0>
    printf("%s: concreate not enough files in directory listing\n", s);
    3f36:	85ce                	mv	a1,s3
    3f38:	00003517          	auipc	a0,0x3
    3f3c:	da050513          	addi	a0,a0,-608 # 6cd8 <malloc+0x1de4>
    3f40:	701000ef          	jal	ra,4e40 <printf>
    exit(1);
    3f44:	4505                	li	a0,1
    3f46:	2ef000ef          	jal	ra,4a34 <exit>
      printf("%s: fork failed\n", s);
    3f4a:	85ce                	mv	a1,s3
    3f4c:	00002517          	auipc	a0,0x2
    3f50:	95c50513          	addi	a0,a0,-1700 # 58a8 <malloc+0x9b4>
    3f54:	6ed000ef          	jal	ra,4e40 <printf>
      exit(1);
    3f58:	4505                	li	a0,1
    3f5a:	2db000ef          	jal	ra,4a34 <exit>
      close(open(file, 0));
    3f5e:	4581                	li	a1,0
    3f60:	fa840513          	addi	a0,s0,-88
    3f64:	311000ef          	jal	ra,4a74 <open>
    3f68:	2f5000ef          	jal	ra,4a5c <close>
      close(open(file, 0));
    3f6c:	4581                	li	a1,0
    3f6e:	fa840513          	addi	a0,s0,-88
    3f72:	303000ef          	jal	ra,4a74 <open>
    3f76:	2e7000ef          	jal	ra,4a5c <close>
      close(open(file, 0));
    3f7a:	4581                	li	a1,0
    3f7c:	fa840513          	addi	a0,s0,-88
    3f80:	2f5000ef          	jal	ra,4a74 <open>
    3f84:	2d9000ef          	jal	ra,4a5c <close>
      close(open(file, 0));
    3f88:	4581                	li	a1,0
    3f8a:	fa840513          	addi	a0,s0,-88
    3f8e:	2e7000ef          	jal	ra,4a74 <open>
    3f92:	2cb000ef          	jal	ra,4a5c <close>
      close(open(file, 0));
    3f96:	4581                	li	a1,0
    3f98:	fa840513          	addi	a0,s0,-88
    3f9c:	2d9000ef          	jal	ra,4a74 <open>
    3fa0:	2bd000ef          	jal	ra,4a5c <close>
      close(open(file, 0));
    3fa4:	4581                	li	a1,0
    3fa6:	fa840513          	addi	a0,s0,-88
    3faa:	2cb000ef          	jal	ra,4a74 <open>
    3fae:	2af000ef          	jal	ra,4a5c <close>
    if(pid == 0)
    3fb2:	06090363          	beqz	s2,4018 <concreate+0x236>
      wait(0);
    3fb6:	4501                	li	a0,0
    3fb8:	285000ef          	jal	ra,4a3c <wait>
  for(i = 0; i < N; i++){
    3fbc:	2485                	addiw	s1,s1,1
    3fbe:	0b448963          	beq	s1,s4,4070 <concreate+0x28e>
    file[1] = '0' + i;
    3fc2:	0304879b          	addiw	a5,s1,48
    3fc6:	faf404a3          	sb	a5,-87(s0)
    pid = fork();
    3fca:	263000ef          	jal	ra,4a2c <fork>
    3fce:	892a                	mv	s2,a0
    if(pid < 0){
    3fd0:	f6054de3          	bltz	a0,3f4a <concreate+0x168>
    if(((i % 3) == 0 && pid == 0) ||
    3fd4:	0354e73b          	remw	a4,s1,s5
    3fd8:	00a767b3          	or	a5,a4,a0
    3fdc:	2781                	sext.w	a5,a5
    3fde:	d3c1                	beqz	a5,3f5e <concreate+0x17c>
    3fe0:	01671363          	bne	a4,s6,3fe6 <concreate+0x204>
       ((i % 3) == 1 && pid != 0)){
    3fe4:	fd2d                	bnez	a0,3f5e <concreate+0x17c>
      unlink(file);
    3fe6:	fa840513          	addi	a0,s0,-88
    3fea:	29b000ef          	jal	ra,4a84 <unlink>
      unlink(file);
    3fee:	fa840513          	addi	a0,s0,-88
    3ff2:	293000ef          	jal	ra,4a84 <unlink>
      unlink(file);
    3ff6:	fa840513          	addi	a0,s0,-88
    3ffa:	28b000ef          	jal	ra,4a84 <unlink>
      unlink(file);
    3ffe:	fa840513          	addi	a0,s0,-88
    4002:	283000ef          	jal	ra,4a84 <unlink>
      unlink(file);
    4006:	fa840513          	addi	a0,s0,-88
    400a:	27b000ef          	jal	ra,4a84 <unlink>
      unlink(file);
    400e:	fa840513          	addi	a0,s0,-88
    4012:	273000ef          	jal	ra,4a84 <unlink>
    4016:	bf71                	j	3fb2 <concreate+0x1d0>
      exit(0);
    4018:	4501                	li	a0,0
    401a:	21b000ef          	jal	ra,4a34 <exit>
      close(fd);
    401e:	23f000ef          	jal	ra,4a5c <close>
    if(pid == 0) {
    4022:	b599                	j	3e68 <concreate+0x86>
      close(fd);
    4024:	239000ef          	jal	ra,4a5c <close>
      wait(&xstatus);
    4028:	f6c40513          	addi	a0,s0,-148
    402c:	211000ef          	jal	ra,4a3c <wait>
      if(xstatus != 0)
    4030:	f6c42483          	lw	s1,-148(s0)
    4034:	e2049de3          	bnez	s1,3e6e <concreate+0x8c>
  for(i = 0; i < N; i++){
    4038:	2905                	addiw	s2,s2,1
    403a:	e3490de3          	beq	s2,s4,3e74 <concreate+0x92>
    file[1] = '0' + i;
    403e:	0309079b          	addiw	a5,s2,48
    4042:	faf404a3          	sb	a5,-87(s0)
    unlink(file);
    4046:	fa840513          	addi	a0,s0,-88
    404a:	23b000ef          	jal	ra,4a84 <unlink>
    pid = fork();
    404e:	1df000ef          	jal	ra,4a2c <fork>
    if(pid && (i % 3) == 1){
    4052:	dc050ae3          	beqz	a0,3e26 <concreate+0x44>
    4056:	036967bb          	remw	a5,s2,s6
    405a:	dd5780e3          	beq	a5,s5,3e1a <concreate+0x38>
      fd = open(file, O_CREATE | O_RDWR);
    405e:	20200593          	li	a1,514
    4062:	fa840513          	addi	a0,s0,-88
    4066:	20f000ef          	jal	ra,4a74 <open>
      if(fd < 0){
    406a:	fa055de3          	bgez	a0,4024 <concreate+0x242>
    406e:	bbd1                	j	3e42 <concreate+0x60>
}
    4070:	60ea                	ld	ra,152(sp)
    4072:	644a                	ld	s0,144(sp)
    4074:	64aa                	ld	s1,136(sp)
    4076:	690a                	ld	s2,128(sp)
    4078:	79e6                	ld	s3,120(sp)
    407a:	7a46                	ld	s4,112(sp)
    407c:	7aa6                	ld	s5,104(sp)
    407e:	7b06                	ld	s6,96(sp)
    4080:	6be6                	ld	s7,88(sp)
    4082:	610d                	addi	sp,sp,160
    4084:	8082                	ret

0000000000004086 <bigfile>:
{
    4086:	7139                	addi	sp,sp,-64
    4088:	fc06                	sd	ra,56(sp)
    408a:	f822                	sd	s0,48(sp)
    408c:	f426                	sd	s1,40(sp)
    408e:	f04a                	sd	s2,32(sp)
    4090:	ec4e                	sd	s3,24(sp)
    4092:	e852                	sd	s4,16(sp)
    4094:	e456                	sd	s5,8(sp)
    4096:	0080                	addi	s0,sp,64
    4098:	8aaa                	mv	s5,a0
  unlink("bigfile.dat");
    409a:	00003517          	auipc	a0,0x3
    409e:	c7650513          	addi	a0,a0,-906 # 6d10 <malloc+0x1e1c>
    40a2:	1e3000ef          	jal	ra,4a84 <unlink>
  fd = open("bigfile.dat", O_CREATE | O_RDWR);
    40a6:	20200593          	li	a1,514
    40aa:	00003517          	auipc	a0,0x3
    40ae:	c6650513          	addi	a0,a0,-922 # 6d10 <malloc+0x1e1c>
    40b2:	1c3000ef          	jal	ra,4a74 <open>
    40b6:	89aa                	mv	s3,a0
  for(i = 0; i < N; i++){
    40b8:	4481                	li	s1,0
    memset(buf, i, SZ);
    40ba:	00008917          	auipc	s2,0x8
    40be:	bbe90913          	addi	s2,s2,-1090 # bc78 <buf>
  for(i = 0; i < N; i++){
    40c2:	4a51                	li	s4,20
  if(fd < 0){
    40c4:	08054663          	bltz	a0,4150 <bigfile+0xca>
    memset(buf, i, SZ);
    40c8:	25800613          	li	a2,600
    40cc:	85a6                	mv	a1,s1
    40ce:	854a                	mv	a0,s2
    40d0:	77e000ef          	jal	ra,484e <memset>
    if(write(fd, buf, SZ) != SZ){
    40d4:	25800613          	li	a2,600
    40d8:	85ca                	mv	a1,s2
    40da:	854e                	mv	a0,s3
    40dc:	179000ef          	jal	ra,4a54 <write>
    40e0:	25800793          	li	a5,600
    40e4:	08f51063          	bne	a0,a5,4164 <bigfile+0xde>
  for(i = 0; i < N; i++){
    40e8:	2485                	addiw	s1,s1,1
    40ea:	fd449fe3          	bne	s1,s4,40c8 <bigfile+0x42>
  close(fd);
    40ee:	854e                	mv	a0,s3
    40f0:	16d000ef          	jal	ra,4a5c <close>
  fd = open("bigfile.dat", 0);
    40f4:	4581                	li	a1,0
    40f6:	00003517          	auipc	a0,0x3
    40fa:	c1a50513          	addi	a0,a0,-998 # 6d10 <malloc+0x1e1c>
    40fe:	177000ef          	jal	ra,4a74 <open>
    4102:	8a2a                	mv	s4,a0
  total = 0;
    4104:	4981                	li	s3,0
  for(i = 0; ; i++){
    4106:	4481                	li	s1,0
    cc = read(fd, buf, SZ/2);
    4108:	00008917          	auipc	s2,0x8
    410c:	b7090913          	addi	s2,s2,-1168 # bc78 <buf>
  if(fd < 0){
    4110:	06054463          	bltz	a0,4178 <bigfile+0xf2>
    cc = read(fd, buf, SZ/2);
    4114:	12c00613          	li	a2,300
    4118:	85ca                	mv	a1,s2
    411a:	8552                	mv	a0,s4
    411c:	131000ef          	jal	ra,4a4c <read>
    if(cc < 0){
    4120:	06054663          	bltz	a0,418c <bigfile+0x106>
    if(cc == 0)
    4124:	c155                	beqz	a0,41c8 <bigfile+0x142>
    if(cc != SZ/2){
    4126:	12c00793          	li	a5,300
    412a:	06f51b63          	bne	a0,a5,41a0 <bigfile+0x11a>
    if(buf[0] != i/2 || buf[SZ/2-1] != i/2){
    412e:	01f4d79b          	srliw	a5,s1,0x1f
    4132:	9fa5                	addw	a5,a5,s1
    4134:	4017d79b          	sraiw	a5,a5,0x1
    4138:	00094703          	lbu	a4,0(s2)
    413c:	06f71c63          	bne	a4,a5,41b4 <bigfile+0x12e>
    4140:	12b94703          	lbu	a4,299(s2)
    4144:	06f71863          	bne	a4,a5,41b4 <bigfile+0x12e>
    total += cc;
    4148:	12c9899b          	addiw	s3,s3,300
  for(i = 0; ; i++){
    414c:	2485                	addiw	s1,s1,1
    cc = read(fd, buf, SZ/2);
    414e:	b7d9                	j	4114 <bigfile+0x8e>
    printf("%s: cannot create bigfile", s);
    4150:	85d6                	mv	a1,s5
    4152:	00003517          	auipc	a0,0x3
    4156:	bce50513          	addi	a0,a0,-1074 # 6d20 <malloc+0x1e2c>
    415a:	4e7000ef          	jal	ra,4e40 <printf>
    exit(1);
    415e:	4505                	li	a0,1
    4160:	0d5000ef          	jal	ra,4a34 <exit>
      printf("%s: write bigfile failed\n", s);
    4164:	85d6                	mv	a1,s5
    4166:	00003517          	auipc	a0,0x3
    416a:	bda50513          	addi	a0,a0,-1062 # 6d40 <malloc+0x1e4c>
    416e:	4d3000ef          	jal	ra,4e40 <printf>
      exit(1);
    4172:	4505                	li	a0,1
    4174:	0c1000ef          	jal	ra,4a34 <exit>
    printf("%s: cannot open bigfile\n", s);
    4178:	85d6                	mv	a1,s5
    417a:	00003517          	auipc	a0,0x3
    417e:	be650513          	addi	a0,a0,-1050 # 6d60 <malloc+0x1e6c>
    4182:	4bf000ef          	jal	ra,4e40 <printf>
    exit(1);
    4186:	4505                	li	a0,1
    4188:	0ad000ef          	jal	ra,4a34 <exit>
      printf("%s: read bigfile failed\n", s);
    418c:	85d6                	mv	a1,s5
    418e:	00003517          	auipc	a0,0x3
    4192:	bf250513          	addi	a0,a0,-1038 # 6d80 <malloc+0x1e8c>
    4196:	4ab000ef          	jal	ra,4e40 <printf>
      exit(1);
    419a:	4505                	li	a0,1
    419c:	099000ef          	jal	ra,4a34 <exit>
      printf("%s: short read bigfile\n", s);
    41a0:	85d6                	mv	a1,s5
    41a2:	00003517          	auipc	a0,0x3
    41a6:	bfe50513          	addi	a0,a0,-1026 # 6da0 <malloc+0x1eac>
    41aa:	497000ef          	jal	ra,4e40 <printf>
      exit(1);
    41ae:	4505                	li	a0,1
    41b0:	085000ef          	jal	ra,4a34 <exit>
      printf("%s: read bigfile wrong data\n", s);
    41b4:	85d6                	mv	a1,s5
    41b6:	00003517          	auipc	a0,0x3
    41ba:	c0250513          	addi	a0,a0,-1022 # 6db8 <malloc+0x1ec4>
    41be:	483000ef          	jal	ra,4e40 <printf>
      exit(1);
    41c2:	4505                	li	a0,1
    41c4:	071000ef          	jal	ra,4a34 <exit>
  close(fd);
    41c8:	8552                	mv	a0,s4
    41ca:	093000ef          	jal	ra,4a5c <close>
  if(total != N*SZ){
    41ce:	678d                	lui	a5,0x3
    41d0:	ee078793          	addi	a5,a5,-288 # 2ee0 <subdir+0x358>
    41d4:	02f99163          	bne	s3,a5,41f6 <bigfile+0x170>
  unlink("bigfile.dat");
    41d8:	00003517          	auipc	a0,0x3
    41dc:	b3850513          	addi	a0,a0,-1224 # 6d10 <malloc+0x1e1c>
    41e0:	0a5000ef          	jal	ra,4a84 <unlink>
}
    41e4:	70e2                	ld	ra,56(sp)
    41e6:	7442                	ld	s0,48(sp)
    41e8:	74a2                	ld	s1,40(sp)
    41ea:	7902                	ld	s2,32(sp)
    41ec:	69e2                	ld	s3,24(sp)
    41ee:	6a42                	ld	s4,16(sp)
    41f0:	6aa2                	ld	s5,8(sp)
    41f2:	6121                	addi	sp,sp,64
    41f4:	8082                	ret
    printf("%s: read bigfile wrong total\n", s);
    41f6:	85d6                	mv	a1,s5
    41f8:	00003517          	auipc	a0,0x3
    41fc:	be050513          	addi	a0,a0,-1056 # 6dd8 <malloc+0x1ee4>
    4200:	441000ef          	jal	ra,4e40 <printf>
    exit(1);
    4204:	4505                	li	a0,1
    4206:	02f000ef          	jal	ra,4a34 <exit>

000000000000420a <bigargtest>:
{
    420a:	7121                	addi	sp,sp,-448
    420c:	ff06                	sd	ra,440(sp)
    420e:	fb22                	sd	s0,432(sp)
    4210:	f726                	sd	s1,424(sp)
    4212:	0380                	addi	s0,sp,448
    4214:	84aa                	mv	s1,a0
  unlink("bigarg-ok");
    4216:	00003517          	auipc	a0,0x3
    421a:	be250513          	addi	a0,a0,-1054 # 6df8 <malloc+0x1f04>
    421e:	067000ef          	jal	ra,4a84 <unlink>
  pid = fork();
    4222:	00b000ef          	jal	ra,4a2c <fork>
  if(pid == 0){
    4226:	c915                	beqz	a0,425a <bigargtest+0x50>
  } else if(pid < 0){
    4228:	08054a63          	bltz	a0,42bc <bigargtest+0xb2>
  wait(&xstatus);
    422c:	fdc40513          	addi	a0,s0,-36
    4230:	00d000ef          	jal	ra,4a3c <wait>
  if(xstatus != 0)
    4234:	fdc42503          	lw	a0,-36(s0)
    4238:	ed41                	bnez	a0,42d0 <bigargtest+0xc6>
  fd = open("bigarg-ok", 0);
    423a:	4581                	li	a1,0
    423c:	00003517          	auipc	a0,0x3
    4240:	bbc50513          	addi	a0,a0,-1092 # 6df8 <malloc+0x1f04>
    4244:	031000ef          	jal	ra,4a74 <open>
  if(fd < 0){
    4248:	08054663          	bltz	a0,42d4 <bigargtest+0xca>
  close(fd);
    424c:	011000ef          	jal	ra,4a5c <close>
}
    4250:	70fa                	ld	ra,440(sp)
    4252:	745a                	ld	s0,432(sp)
    4254:	74ba                	ld	s1,424(sp)
    4256:	6139                	addi	sp,sp,448
    4258:	8082                	ret
    memset(big, ' ', sizeof(big));
    425a:	19000613          	li	a2,400
    425e:	02000593          	li	a1,32
    4262:	e4840513          	addi	a0,s0,-440
    4266:	5e8000ef          	jal	ra,484e <memset>
    big[sizeof(big)-1] = '\0';
    426a:	fc040ba3          	sb	zero,-41(s0)
    for(i = 0; i < MAXARG-1; i++)
    426e:	00004797          	auipc	a5,0x4
    4272:	1f278793          	addi	a5,a5,498 # 8460 <args.1>
    4276:	00004697          	auipc	a3,0x4
    427a:	2e268693          	addi	a3,a3,738 # 8558 <args.1+0xf8>
      args[i] = big;
    427e:	e4840713          	addi	a4,s0,-440
    4282:	e398                	sd	a4,0(a5)
    for(i = 0; i < MAXARG-1; i++)
    4284:	07a1                	addi	a5,a5,8
    4286:	fed79ee3          	bne	a5,a3,4282 <bigargtest+0x78>
    args[MAXARG-1] = 0;
    428a:	00004597          	auipc	a1,0x4
    428e:	1d658593          	addi	a1,a1,470 # 8460 <args.1>
    4292:	0e05bc23          	sd	zero,248(a1)
    exec("echo", args);
    4296:	00001517          	auipc	a0,0x1
    429a:	d8250513          	addi	a0,a0,-638 # 5018 <malloc+0x124>
    429e:	7ce000ef          	jal	ra,4a6c <exec>
    fd = open("bigarg-ok", O_CREATE);
    42a2:	20000593          	li	a1,512
    42a6:	00003517          	auipc	a0,0x3
    42aa:	b5250513          	addi	a0,a0,-1198 # 6df8 <malloc+0x1f04>
    42ae:	7c6000ef          	jal	ra,4a74 <open>
    close(fd);
    42b2:	7aa000ef          	jal	ra,4a5c <close>
    exit(0);
    42b6:	4501                	li	a0,0
    42b8:	77c000ef          	jal	ra,4a34 <exit>
    printf("%s: bigargtest: fork failed\n", s);
    42bc:	85a6                	mv	a1,s1
    42be:	00003517          	auipc	a0,0x3
    42c2:	b4a50513          	addi	a0,a0,-1206 # 6e08 <malloc+0x1f14>
    42c6:	37b000ef          	jal	ra,4e40 <printf>
    exit(1);
    42ca:	4505                	li	a0,1
    42cc:	768000ef          	jal	ra,4a34 <exit>
    exit(xstatus);
    42d0:	764000ef          	jal	ra,4a34 <exit>
    printf("%s: bigarg test failed!\n", s);
    42d4:	85a6                	mv	a1,s1
    42d6:	00003517          	auipc	a0,0x3
    42da:	b5250513          	addi	a0,a0,-1198 # 6e28 <malloc+0x1f34>
    42de:	363000ef          	jal	ra,4e40 <printf>
    exit(1);
    42e2:	4505                	li	a0,1
    42e4:	750000ef          	jal	ra,4a34 <exit>

00000000000042e8 <fsfull>:
{
    42e8:	7171                	addi	sp,sp,-176
    42ea:	f506                	sd	ra,168(sp)
    42ec:	f122                	sd	s0,160(sp)
    42ee:	ed26                	sd	s1,152(sp)
    42f0:	e94a                	sd	s2,144(sp)
    42f2:	e54e                	sd	s3,136(sp)
    42f4:	e152                	sd	s4,128(sp)
    42f6:	fcd6                	sd	s5,120(sp)
    42f8:	f8da                	sd	s6,112(sp)
    42fa:	f4de                	sd	s7,104(sp)
    42fc:	f0e2                	sd	s8,96(sp)
    42fe:	ece6                	sd	s9,88(sp)
    4300:	e8ea                	sd	s10,80(sp)
    4302:	e4ee                	sd	s11,72(sp)
    4304:	1900                	addi	s0,sp,176
  printf("fsfull test\n");
    4306:	00003517          	auipc	a0,0x3
    430a:	b4250513          	addi	a0,a0,-1214 # 6e48 <malloc+0x1f54>
    430e:	333000ef          	jal	ra,4e40 <printf>
  for(nfiles = 0; ; nfiles++){
    4312:	4481                	li	s1,0
    name[0] = 'f';
    4314:	06600d13          	li	s10,102
    name[1] = '0' + nfiles / 1000;
    4318:	3e800c13          	li	s8,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    431c:	06400b93          	li	s7,100
    name[3] = '0' + (nfiles % 100) / 10;
    4320:	4b29                	li	s6,10
    printf("writing %s\n", name);
    4322:	00003c97          	auipc	s9,0x3
    4326:	b36c8c93          	addi	s9,s9,-1226 # 6e58 <malloc+0x1f64>
    int total = 0;
    432a:	4d81                	li	s11,0
      int cc = write(fd, buf, BSIZE);
    432c:	00008a17          	auipc	s4,0x8
    4330:	94ca0a13          	addi	s4,s4,-1716 # bc78 <buf>
    name[0] = 'f';
    4334:	f5a40823          	sb	s10,-176(s0)
    name[1] = '0' + nfiles / 1000;
    4338:	0384c7bb          	divw	a5,s1,s8
    433c:	0307879b          	addiw	a5,a5,48
    4340:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    4344:	0384e7bb          	remw	a5,s1,s8
    4348:	0377c7bb          	divw	a5,a5,s7
    434c:	0307879b          	addiw	a5,a5,48
    4350:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    4354:	0374e7bb          	remw	a5,s1,s7
    4358:	0367c7bb          	divw	a5,a5,s6
    435c:	0307879b          	addiw	a5,a5,48
    4360:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    4364:	0364e7bb          	remw	a5,s1,s6
    4368:	0307879b          	addiw	a5,a5,48
    436c:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    4370:	f4040aa3          	sb	zero,-171(s0)
    printf("writing %s\n", name);
    4374:	f5040593          	addi	a1,s0,-176
    4378:	8566                	mv	a0,s9
    437a:	2c7000ef          	jal	ra,4e40 <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    437e:	20200593          	li	a1,514
    4382:	f5040513          	addi	a0,s0,-176
    4386:	6ee000ef          	jal	ra,4a74 <open>
    438a:	892a                	mv	s2,a0
    if(fd < 0){
    438c:	0a055063          	bgez	a0,442c <fsfull+0x144>
      printf("open %s failed\n", name);
    4390:	f5040593          	addi	a1,s0,-176
    4394:	00003517          	auipc	a0,0x3
    4398:	ad450513          	addi	a0,a0,-1324 # 6e68 <malloc+0x1f74>
    439c:	2a5000ef          	jal	ra,4e40 <printf>
  while(nfiles >= 0){
    43a0:	0604c163          	bltz	s1,4402 <fsfull+0x11a>
    name[0] = 'f';
    43a4:	06600b13          	li	s6,102
    name[1] = '0' + nfiles / 1000;
    43a8:	3e800a13          	li	s4,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    43ac:	06400993          	li	s3,100
    name[3] = '0' + (nfiles % 100) / 10;
    43b0:	4929                	li	s2,10
  while(nfiles >= 0){
    43b2:	5afd                	li	s5,-1
    name[0] = 'f';
    43b4:	f5640823          	sb	s6,-176(s0)
    name[1] = '0' + nfiles / 1000;
    43b8:	0344c7bb          	divw	a5,s1,s4
    43bc:	0307879b          	addiw	a5,a5,48
    43c0:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    43c4:	0344e7bb          	remw	a5,s1,s4
    43c8:	0337c7bb          	divw	a5,a5,s3
    43cc:	0307879b          	addiw	a5,a5,48
    43d0:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    43d4:	0334e7bb          	remw	a5,s1,s3
    43d8:	0327c7bb          	divw	a5,a5,s2
    43dc:	0307879b          	addiw	a5,a5,48
    43e0:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    43e4:	0324e7bb          	remw	a5,s1,s2
    43e8:	0307879b          	addiw	a5,a5,48
    43ec:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    43f0:	f4040aa3          	sb	zero,-171(s0)
    unlink(name);
    43f4:	f5040513          	addi	a0,s0,-176
    43f8:	68c000ef          	jal	ra,4a84 <unlink>
    nfiles--;
    43fc:	34fd                	addiw	s1,s1,-1
  while(nfiles >= 0){
    43fe:	fb549be3          	bne	s1,s5,43b4 <fsfull+0xcc>
  printf("fsfull test finished\n");
    4402:	00003517          	auipc	a0,0x3
    4406:	a8650513          	addi	a0,a0,-1402 # 6e88 <malloc+0x1f94>
    440a:	237000ef          	jal	ra,4e40 <printf>
}
    440e:	70aa                	ld	ra,168(sp)
    4410:	740a                	ld	s0,160(sp)
    4412:	64ea                	ld	s1,152(sp)
    4414:	694a                	ld	s2,144(sp)
    4416:	69aa                	ld	s3,136(sp)
    4418:	6a0a                	ld	s4,128(sp)
    441a:	7ae6                	ld	s5,120(sp)
    441c:	7b46                	ld	s6,112(sp)
    441e:	7ba6                	ld	s7,104(sp)
    4420:	7c06                	ld	s8,96(sp)
    4422:	6ce6                	ld	s9,88(sp)
    4424:	6d46                	ld	s10,80(sp)
    4426:	6da6                	ld	s11,72(sp)
    4428:	614d                	addi	sp,sp,176
    442a:	8082                	ret
    int total = 0;
    442c:	89ee                	mv	s3,s11
      if(cc < BSIZE)
    442e:	3ff00a93          	li	s5,1023
      int cc = write(fd, buf, BSIZE);
    4432:	40000613          	li	a2,1024
    4436:	85d2                	mv	a1,s4
    4438:	854a                	mv	a0,s2
    443a:	61a000ef          	jal	ra,4a54 <write>
      if(cc < BSIZE)
    443e:	00aad563          	bge	s5,a0,4448 <fsfull+0x160>
      total += cc;
    4442:	00a989bb          	addw	s3,s3,a0
    while(1){
    4446:	b7f5                	j	4432 <fsfull+0x14a>
    printf("wrote %d bytes\n", total);
    4448:	85ce                	mv	a1,s3
    444a:	00003517          	auipc	a0,0x3
    444e:	a2e50513          	addi	a0,a0,-1490 # 6e78 <malloc+0x1f84>
    4452:	1ef000ef          	jal	ra,4e40 <printf>
    close(fd);
    4456:	854a                	mv	a0,s2
    4458:	604000ef          	jal	ra,4a5c <close>
    if(total == 0)
    445c:	f40982e3          	beqz	s3,43a0 <fsfull+0xb8>
  for(nfiles = 0; ; nfiles++){
    4460:	2485                	addiw	s1,s1,1
    4462:	bdc9                	j	4334 <fsfull+0x4c>

0000000000004464 <run>:
//

// run each test in its own process. run returns 1 if child's exit()
// indicates success.
int
run(void f(char *), char *s) {
    4464:	7179                	addi	sp,sp,-48
    4466:	f406                	sd	ra,40(sp)
    4468:	f022                	sd	s0,32(sp)
    446a:	ec26                	sd	s1,24(sp)
    446c:	e84a                	sd	s2,16(sp)
    446e:	1800                	addi	s0,sp,48
    4470:	84aa                	mv	s1,a0
    4472:	892e                	mv	s2,a1
  int pid;
  int xstatus;

  printf("test %s: ", s);
    4474:	00003517          	auipc	a0,0x3
    4478:	a2c50513          	addi	a0,a0,-1492 # 6ea0 <malloc+0x1fac>
    447c:	1c5000ef          	jal	ra,4e40 <printf>
  if((pid = fork()) < 0) {
    4480:	5ac000ef          	jal	ra,4a2c <fork>
    4484:	02054a63          	bltz	a0,44b8 <run+0x54>
    printf("runtest: fork error\n");
    exit(1);
  }
  if(pid == 0) {
    4488:	c129                	beqz	a0,44ca <run+0x66>
    f(s);
    exit(0);
  } else {
    wait(&xstatus);
    448a:	fdc40513          	addi	a0,s0,-36
    448e:	5ae000ef          	jal	ra,4a3c <wait>
    if(xstatus != 0) 
    4492:	fdc42783          	lw	a5,-36(s0)
    4496:	cf9d                	beqz	a5,44d4 <run+0x70>
      printf("FAILED\n");
    4498:	00003517          	auipc	a0,0x3
    449c:	a3050513          	addi	a0,a0,-1488 # 6ec8 <malloc+0x1fd4>
    44a0:	1a1000ef          	jal	ra,4e40 <printf>
    else
      printf("OK\n");
    return xstatus == 0;
    44a4:	fdc42503          	lw	a0,-36(s0)
  }
}
    44a8:	00153513          	seqz	a0,a0
    44ac:	70a2                	ld	ra,40(sp)
    44ae:	7402                	ld	s0,32(sp)
    44b0:	64e2                	ld	s1,24(sp)
    44b2:	6942                	ld	s2,16(sp)
    44b4:	6145                	addi	sp,sp,48
    44b6:	8082                	ret
    printf("runtest: fork error\n");
    44b8:	00003517          	auipc	a0,0x3
    44bc:	9f850513          	addi	a0,a0,-1544 # 6eb0 <malloc+0x1fbc>
    44c0:	181000ef          	jal	ra,4e40 <printf>
    exit(1);
    44c4:	4505                	li	a0,1
    44c6:	56e000ef          	jal	ra,4a34 <exit>
    f(s);
    44ca:	854a                	mv	a0,s2
    44cc:	9482                	jalr	s1
    exit(0);
    44ce:	4501                	li	a0,0
    44d0:	564000ef          	jal	ra,4a34 <exit>
      printf("OK\n");
    44d4:	00003517          	auipc	a0,0x3
    44d8:	9fc50513          	addi	a0,a0,-1540 # 6ed0 <malloc+0x1fdc>
    44dc:	165000ef          	jal	ra,4e40 <printf>
    44e0:	b7d1                	j	44a4 <run+0x40>

00000000000044e2 <runtests>:

int
runtests(struct test *tests, char *justone, int continuous) {
    44e2:	7139                	addi	sp,sp,-64
    44e4:	fc06                	sd	ra,56(sp)
    44e6:	f822                	sd	s0,48(sp)
    44e8:	f426                	sd	s1,40(sp)
    44ea:	f04a                	sd	s2,32(sp)
    44ec:	ec4e                	sd	s3,24(sp)
    44ee:	e852                	sd	s4,16(sp)
    44f0:	e456                	sd	s5,8(sp)
    44f2:	0080                	addi	s0,sp,64
  for (struct test *t = tests; t->s != 0; t++) {
    44f4:	00853903          	ld	s2,8(a0)
    44f8:	04090c63          	beqz	s2,4550 <runtests+0x6e>
    44fc:	84aa                	mv	s1,a0
    44fe:	89ae                	mv	s3,a1
    4500:	8a32                	mv	s4,a2
    if((justone == 0) || strcmp(t->s, justone) == 0) {
      if(!run(t->f, t->s)){
        if(continuous != 2){
    4502:	4a89                	li	s5,2
    4504:	a031                	j	4510 <runtests+0x2e>
  for (struct test *t = tests; t->s != 0; t++) {
    4506:	04c1                	addi	s1,s1,16
    4508:	0084b903          	ld	s2,8(s1)
    450c:	02090863          	beqz	s2,453c <runtests+0x5a>
    if((justone == 0) || strcmp(t->s, justone) == 0) {
    4510:	00098763          	beqz	s3,451e <runtests+0x3c>
    4514:	85ce                	mv	a1,s3
    4516:	854a                	mv	a0,s2
    4518:	2e0000ef          	jal	ra,47f8 <strcmp>
    451c:	f56d                	bnez	a0,4506 <runtests+0x24>
      if(!run(t->f, t->s)){
    451e:	85ca                	mv	a1,s2
    4520:	6088                	ld	a0,0(s1)
    4522:	f43ff0ef          	jal	ra,4464 <run>
    4526:	f165                	bnez	a0,4506 <runtests+0x24>
        if(continuous != 2){
    4528:	fd5a0fe3          	beq	s4,s5,4506 <runtests+0x24>
          printf("SOME TESTS FAILED\n");
    452c:	00003517          	auipc	a0,0x3
    4530:	9ac50513          	addi	a0,a0,-1620 # 6ed8 <malloc+0x1fe4>
    4534:	10d000ef          	jal	ra,4e40 <printf>
          return 1;
    4538:	4505                	li	a0,1
    453a:	a011                	j	453e <runtests+0x5c>
        }
      }
    }
  }
  return 0;
    453c:	4501                	li	a0,0
}
    453e:	70e2                	ld	ra,56(sp)
    4540:	7442                	ld	s0,48(sp)
    4542:	74a2                	ld	s1,40(sp)
    4544:	7902                	ld	s2,32(sp)
    4546:	69e2                	ld	s3,24(sp)
    4548:	6a42                	ld	s4,16(sp)
    454a:	6aa2                	ld	s5,8(sp)
    454c:	6121                	addi	sp,sp,64
    454e:	8082                	ret
  return 0;
    4550:	4501                	li	a0,0
    4552:	b7f5                	j	453e <runtests+0x5c>

0000000000004554 <countfree>:
// because out of memory with lazy allocation results in the process
// taking a fault and being killed, fork and report back.
//
int
countfree()
{
    4554:	7139                	addi	sp,sp,-64
    4556:	fc06                	sd	ra,56(sp)
    4558:	f822                	sd	s0,48(sp)
    455a:	f426                	sd	s1,40(sp)
    455c:	f04a                	sd	s2,32(sp)
    455e:	ec4e                	sd	s3,24(sp)
    4560:	0080                	addi	s0,sp,64
  int fds[2];

  if(pipe(fds) < 0){
    4562:	fc840513          	addi	a0,s0,-56
    4566:	4de000ef          	jal	ra,4a44 <pipe>
    456a:	04054b63          	bltz	a0,45c0 <countfree+0x6c>
    printf("pipe() failed in countfree()\n");
    exit(1);
  }
  
  int pid = fork();
    456e:	4be000ef          	jal	ra,4a2c <fork>

  if(pid < 0){
    4572:	06054063          	bltz	a0,45d2 <countfree+0x7e>
    printf("fork failed in countfree()\n");
    exit(1);
  }

  if(pid == 0){
    4576:	e935                	bnez	a0,45ea <countfree+0x96>
    close(fds[0]);
    4578:	fc842503          	lw	a0,-56(s0)
    457c:	4e0000ef          	jal	ra,4a5c <close>
    
    while(1){
      uint64 a = (uint64) sbrk(4096);
      if(a == 0xffffffffffffffff){
    4580:	597d                	li	s2,-1
        break;
      }

      // modify the memory to make sure it's really allocated.
      *(char *)(a + 4096 - 1) = 1;
    4582:	4485                	li	s1,1

      // report back one more page.
      if(write(fds[1], "x", 1) != 1){
    4584:	00001997          	auipc	s3,0x1
    4588:	b0498993          	addi	s3,s3,-1276 # 5088 <malloc+0x194>
      uint64 a = (uint64) sbrk(4096);
    458c:	6505                	lui	a0,0x1
    458e:	52e000ef          	jal	ra,4abc <sbrk>
      if(a == 0xffffffffffffffff){
    4592:	05250963          	beq	a0,s2,45e4 <countfree+0x90>
      *(char *)(a + 4096 - 1) = 1;
    4596:	6785                	lui	a5,0x1
    4598:	97aa                	add	a5,a5,a0
    459a:	fe978fa3          	sb	s1,-1(a5) # fff <pgbug+0x2b>
      if(write(fds[1], "x", 1) != 1){
    459e:	8626                	mv	a2,s1
    45a0:	85ce                	mv	a1,s3
    45a2:	fcc42503          	lw	a0,-52(s0)
    45a6:	4ae000ef          	jal	ra,4a54 <write>
    45aa:	fe9501e3          	beq	a0,s1,458c <countfree+0x38>
        printf("write() failed in countfree()\n");
    45ae:	00003517          	auipc	a0,0x3
    45b2:	98250513          	addi	a0,a0,-1662 # 6f30 <malloc+0x203c>
    45b6:	08b000ef          	jal	ra,4e40 <printf>
        exit(1);
    45ba:	4505                	li	a0,1
    45bc:	478000ef          	jal	ra,4a34 <exit>
    printf("pipe() failed in countfree()\n");
    45c0:	00003517          	auipc	a0,0x3
    45c4:	93050513          	addi	a0,a0,-1744 # 6ef0 <malloc+0x1ffc>
    45c8:	079000ef          	jal	ra,4e40 <printf>
    exit(1);
    45cc:	4505                	li	a0,1
    45ce:	466000ef          	jal	ra,4a34 <exit>
    printf("fork failed in countfree()\n");
    45d2:	00003517          	auipc	a0,0x3
    45d6:	93e50513          	addi	a0,a0,-1730 # 6f10 <malloc+0x201c>
    45da:	067000ef          	jal	ra,4e40 <printf>
    exit(1);
    45de:	4505                	li	a0,1
    45e0:	454000ef          	jal	ra,4a34 <exit>
      }
    }

    exit(0);
    45e4:	4501                	li	a0,0
    45e6:	44e000ef          	jal	ra,4a34 <exit>
  }

  close(fds[1]);
    45ea:	fcc42503          	lw	a0,-52(s0)
    45ee:	46e000ef          	jal	ra,4a5c <close>

  int n = 0;
    45f2:	4481                	li	s1,0
  while(1){
    char c;
    int cc = read(fds[0], &c, 1);
    45f4:	4605                	li	a2,1
    45f6:	fc740593          	addi	a1,s0,-57
    45fa:	fc842503          	lw	a0,-56(s0)
    45fe:	44e000ef          	jal	ra,4a4c <read>
    if(cc < 0){
    4602:	00054563          	bltz	a0,460c <countfree+0xb8>
      printf("read() failed in countfree()\n");
      exit(1);
    }
    if(cc == 0)
    4606:	cd01                	beqz	a0,461e <countfree+0xca>
      break;
    n += 1;
    4608:	2485                	addiw	s1,s1,1
  while(1){
    460a:	b7ed                	j	45f4 <countfree+0xa0>
      printf("read() failed in countfree()\n");
    460c:	00003517          	auipc	a0,0x3
    4610:	94450513          	addi	a0,a0,-1724 # 6f50 <malloc+0x205c>
    4614:	02d000ef          	jal	ra,4e40 <printf>
      exit(1);
    4618:	4505                	li	a0,1
    461a:	41a000ef          	jal	ra,4a34 <exit>
  }

  close(fds[0]);
    461e:	fc842503          	lw	a0,-56(s0)
    4622:	43a000ef          	jal	ra,4a5c <close>
  wait((int*)0);
    4626:	4501                	li	a0,0
    4628:	414000ef          	jal	ra,4a3c <wait>
  
  return n;
}
    462c:	8526                	mv	a0,s1
    462e:	70e2                	ld	ra,56(sp)
    4630:	7442                	ld	s0,48(sp)
    4632:	74a2                	ld	s1,40(sp)
    4634:	7902                	ld	s2,32(sp)
    4636:	69e2                	ld	s3,24(sp)
    4638:	6121                	addi	sp,sp,64
    463a:	8082                	ret

000000000000463c <drivetests>:

int
drivetests(int quick, int continuous, char *justone) {
    463c:	711d                	addi	sp,sp,-96
    463e:	ec86                	sd	ra,88(sp)
    4640:	e8a2                	sd	s0,80(sp)
    4642:	e4a6                	sd	s1,72(sp)
    4644:	e0ca                	sd	s2,64(sp)
    4646:	fc4e                	sd	s3,56(sp)
    4648:	f852                	sd	s4,48(sp)
    464a:	f456                	sd	s5,40(sp)
    464c:	f05a                	sd	s6,32(sp)
    464e:	ec5e                	sd	s7,24(sp)
    4650:	e862                	sd	s8,16(sp)
    4652:	e466                	sd	s9,8(sp)
    4654:	e06a                	sd	s10,0(sp)
    4656:	1080                	addi	s0,sp,96
    4658:	8a2a                	mv	s4,a0
    465a:	892e                	mv	s2,a1
    465c:	89b2                	mv	s3,a2
  do {
    printf("usertests starting\n");
    465e:	00003b97          	auipc	s7,0x3
    4662:	912b8b93          	addi	s7,s7,-1774 # 6f70 <malloc+0x207c>
    int free0 = countfree();
    int free1 = 0;
    if (runtests(quicktests, justone, continuous)) {
    4666:	00004b17          	auipc	s6,0x4
    466a:	9aab0b13          	addi	s6,s6,-1622 # 8010 <quicktests>
      if(continuous != 2) {
    466e:	4a89                	li	s5,2
          return 1;
        }
      }
    }
    if((free1 = countfree()) < free0) {
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    4670:	00003c97          	auipc	s9,0x3
    4674:	938c8c93          	addi	s9,s9,-1736 # 6fa8 <malloc+0x20b4>
      if (runtests(slowtests, justone, continuous)) {
    4678:	00004c17          	auipc	s8,0x4
    467c:	d68c0c13          	addi	s8,s8,-664 # 83e0 <slowtests>
        printf("usertests slow tests starting\n");
    4680:	00003d17          	auipc	s10,0x3
    4684:	908d0d13          	addi	s10,s10,-1784 # 6f88 <malloc+0x2094>
    4688:	a819                	j	469e <drivetests+0x62>
    468a:	856a                	mv	a0,s10
    468c:	7b4000ef          	jal	ra,4e40 <printf>
    4690:	a80d                	j	46c2 <drivetests+0x86>
    if((free1 = countfree()) < free0) {
    4692:	ec3ff0ef          	jal	ra,4554 <countfree>
    4696:	04954863          	blt	a0,s1,46e6 <drivetests+0xaa>
      if(continuous != 2) {
        return 1;
      }
    }
  } while(continuous);
    469a:	06090363          	beqz	s2,4700 <drivetests+0xc4>
    printf("usertests starting\n");
    469e:	855e                	mv	a0,s7
    46a0:	7a0000ef          	jal	ra,4e40 <printf>
    int free0 = countfree();
    46a4:	eb1ff0ef          	jal	ra,4554 <countfree>
    46a8:	84aa                	mv	s1,a0
    if (runtests(quicktests, justone, continuous)) {
    46aa:	864a                	mv	a2,s2
    46ac:	85ce                	mv	a1,s3
    46ae:	855a                	mv	a0,s6
    46b0:	e33ff0ef          	jal	ra,44e2 <runtests>
    46b4:	c119                	beqz	a0,46ba <drivetests+0x7e>
      if(continuous != 2) {
    46b6:	05591163          	bne	s2,s5,46f8 <drivetests+0xbc>
    if(!quick) {
    46ba:	fc0a1ce3          	bnez	s4,4692 <drivetests+0x56>
      if (justone == 0)
    46be:	fc0986e3          	beqz	s3,468a <drivetests+0x4e>
      if (runtests(slowtests, justone, continuous)) {
    46c2:	864a                	mv	a2,s2
    46c4:	85ce                	mv	a1,s3
    46c6:	8562                	mv	a0,s8
    46c8:	e1bff0ef          	jal	ra,44e2 <runtests>
    46cc:	d179                	beqz	a0,4692 <drivetests+0x56>
        if(continuous != 2) {
    46ce:	03591763          	bne	s2,s5,46fc <drivetests+0xc0>
    if((free1 = countfree()) < free0) {
    46d2:	e83ff0ef          	jal	ra,4554 <countfree>
    46d6:	fc9552e3          	bge	a0,s1,469a <drivetests+0x5e>
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    46da:	8626                	mv	a2,s1
    46dc:	85aa                	mv	a1,a0
    46de:	8566                	mv	a0,s9
    46e0:	760000ef          	jal	ra,4e40 <printf>
      if(continuous != 2) {
    46e4:	bf6d                	j	469e <drivetests+0x62>
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    46e6:	8626                	mv	a2,s1
    46e8:	85aa                	mv	a1,a0
    46ea:	8566                	mv	a0,s9
    46ec:	754000ef          	jal	ra,4e40 <printf>
      if(continuous != 2) {
    46f0:	fb5907e3          	beq	s2,s5,469e <drivetests+0x62>
        return 1;
    46f4:	4505                	li	a0,1
    46f6:	a031                	j	4702 <drivetests+0xc6>
        return 1;
    46f8:	4505                	li	a0,1
    46fa:	a021                	j	4702 <drivetests+0xc6>
          return 1;
    46fc:	4505                	li	a0,1
    46fe:	a011                	j	4702 <drivetests+0xc6>
  return 0;
    4700:	854a                	mv	a0,s2
}
    4702:	60e6                	ld	ra,88(sp)
    4704:	6446                	ld	s0,80(sp)
    4706:	64a6                	ld	s1,72(sp)
    4708:	6906                	ld	s2,64(sp)
    470a:	79e2                	ld	s3,56(sp)
    470c:	7a42                	ld	s4,48(sp)
    470e:	7aa2                	ld	s5,40(sp)
    4710:	7b02                	ld	s6,32(sp)
    4712:	6be2                	ld	s7,24(sp)
    4714:	6c42                	ld	s8,16(sp)
    4716:	6ca2                	ld	s9,8(sp)
    4718:	6d02                	ld	s10,0(sp)
    471a:	6125                	addi	sp,sp,96
    471c:	8082                	ret

000000000000471e <main>:

int
main(int argc, char *argv[])
{
    471e:	1101                	addi	sp,sp,-32
    4720:	ec06                	sd	ra,24(sp)
    4722:	e822                	sd	s0,16(sp)
    4724:	e426                	sd	s1,8(sp)
    4726:	e04a                	sd	s2,0(sp)
    4728:	1000                	addi	s0,sp,32
    472a:	84aa                	mv	s1,a0
  int continuous = 0;
  int quick = 0;
  char *justone = 0;

  if(argc == 2 && strcmp(argv[1], "-q") == 0){
    472c:	4789                	li	a5,2
    472e:	00f50f63          	beq	a0,a5,474c <main+0x2e>
    continuous = 1;
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    continuous = 2;
  } else if(argc == 2 && argv[1][0] != '-'){
    justone = argv[1];
  } else if(argc > 1){
    4732:	4785                	li	a5,1
    4734:	06a7c063          	blt	a5,a0,4794 <main+0x76>
  char *justone = 0;
    4738:	4901                	li	s2,0
  int quick = 0;
    473a:	4501                	li	a0,0
  int continuous = 0;
    473c:	4581                	li	a1,0
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    exit(1);
  }
  if (drivetests(quick, continuous, justone)) {
    473e:	864a                	mv	a2,s2
    4740:	efdff0ef          	jal	ra,463c <drivetests>
    4744:	c935                	beqz	a0,47b8 <main+0x9a>
    exit(1);
    4746:	4505                	li	a0,1
    4748:	2ec000ef          	jal	ra,4a34 <exit>
  if(argc == 2 && strcmp(argv[1], "-q") == 0){
    474c:	0085b903          	ld	s2,8(a1)
    4750:	00003597          	auipc	a1,0x3
    4754:	88858593          	addi	a1,a1,-1912 # 6fd8 <malloc+0x20e4>
    4758:	854a                	mv	a0,s2
    475a:	09e000ef          	jal	ra,47f8 <strcmp>
    475e:	85aa                	mv	a1,a0
    4760:	c139                	beqz	a0,47a6 <main+0x88>
  } else if(argc == 2 && strcmp(argv[1], "-c") == 0){
    4762:	00003597          	auipc	a1,0x3
    4766:	87e58593          	addi	a1,a1,-1922 # 6fe0 <malloc+0x20ec>
    476a:	854a                	mv	a0,s2
    476c:	08c000ef          	jal	ra,47f8 <strcmp>
    4770:	cd15                	beqz	a0,47ac <main+0x8e>
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    4772:	00003597          	auipc	a1,0x3
    4776:	87658593          	addi	a1,a1,-1930 # 6fe8 <malloc+0x20f4>
    477a:	854a                	mv	a0,s2
    477c:	07c000ef          	jal	ra,47f8 <strcmp>
    4780:	c90d                	beqz	a0,47b2 <main+0x94>
  } else if(argc == 2 && argv[1][0] != '-'){
    4782:	00094703          	lbu	a4,0(s2)
    4786:	02d00793          	li	a5,45
    478a:	00f70563          	beq	a4,a5,4794 <main+0x76>
  int quick = 0;
    478e:	4501                	li	a0,0
  int continuous = 0;
    4790:	4581                	li	a1,0
    4792:	b775                	j	473e <main+0x20>
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    4794:	00003517          	auipc	a0,0x3
    4798:	85c50513          	addi	a0,a0,-1956 # 6ff0 <malloc+0x20fc>
    479c:	6a4000ef          	jal	ra,4e40 <printf>
    exit(1);
    47a0:	4505                	li	a0,1
    47a2:	292000ef          	jal	ra,4a34 <exit>
  char *justone = 0;
    47a6:	4901                	li	s2,0
    quick = 1;
    47a8:	4505                	li	a0,1
    47aa:	bf51                	j	473e <main+0x20>
  char *justone = 0;
    47ac:	4901                	li	s2,0
    continuous = 1;
    47ae:	4585                	li	a1,1
    47b0:	b779                	j	473e <main+0x20>
    continuous = 2;
    47b2:	85a6                	mv	a1,s1
  char *justone = 0;
    47b4:	4901                	li	s2,0
    47b6:	b761                	j	473e <main+0x20>
  }
  printf("ALL TESTS PASSED\n");
    47b8:	00003517          	auipc	a0,0x3
    47bc:	86850513          	addi	a0,a0,-1944 # 7020 <malloc+0x212c>
    47c0:	680000ef          	jal	ra,4e40 <printf>
  exit(0);
    47c4:	4501                	li	a0,0
    47c6:	26e000ef          	jal	ra,4a34 <exit>

00000000000047ca <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
    47ca:	1141                	addi	sp,sp,-16
    47cc:	e406                	sd	ra,8(sp)
    47ce:	e022                	sd	s0,0(sp)
    47d0:	0800                	addi	s0,sp,16
  extern int main();
  main();
    47d2:	f4dff0ef          	jal	ra,471e <main>
  exit(0);
    47d6:	4501                	li	a0,0
    47d8:	25c000ef          	jal	ra,4a34 <exit>

00000000000047dc <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
    47dc:	1141                	addi	sp,sp,-16
    47de:	e422                	sd	s0,8(sp)
    47e0:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    47e2:	87aa                	mv	a5,a0
    47e4:	0585                	addi	a1,a1,1
    47e6:	0785                	addi	a5,a5,1
    47e8:	fff5c703          	lbu	a4,-1(a1)
    47ec:	fee78fa3          	sb	a4,-1(a5)
    47f0:	fb75                	bnez	a4,47e4 <strcpy+0x8>
    ;
  return os;
}
    47f2:	6422                	ld	s0,8(sp)
    47f4:	0141                	addi	sp,sp,16
    47f6:	8082                	ret

00000000000047f8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    47f8:	1141                	addi	sp,sp,-16
    47fa:	e422                	sd	s0,8(sp)
    47fc:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    47fe:	00054783          	lbu	a5,0(a0)
    4802:	cb91                	beqz	a5,4816 <strcmp+0x1e>
    4804:	0005c703          	lbu	a4,0(a1)
    4808:	00f71763          	bne	a4,a5,4816 <strcmp+0x1e>
    p++, q++;
    480c:	0505                	addi	a0,a0,1
    480e:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    4810:	00054783          	lbu	a5,0(a0)
    4814:	fbe5                	bnez	a5,4804 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    4816:	0005c503          	lbu	a0,0(a1)
}
    481a:	40a7853b          	subw	a0,a5,a0
    481e:	6422                	ld	s0,8(sp)
    4820:	0141                	addi	sp,sp,16
    4822:	8082                	ret

0000000000004824 <strlen>:

uint
strlen(const char *s)
{
    4824:	1141                	addi	sp,sp,-16
    4826:	e422                	sd	s0,8(sp)
    4828:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    482a:	00054783          	lbu	a5,0(a0)
    482e:	cf91                	beqz	a5,484a <strlen+0x26>
    4830:	0505                	addi	a0,a0,1
    4832:	87aa                	mv	a5,a0
    4834:	4685                	li	a3,1
    4836:	9e89                	subw	a3,a3,a0
    4838:	00f6853b          	addw	a0,a3,a5
    483c:	0785                	addi	a5,a5,1
    483e:	fff7c703          	lbu	a4,-1(a5)
    4842:	fb7d                	bnez	a4,4838 <strlen+0x14>
    ;
  return n;
}
    4844:	6422                	ld	s0,8(sp)
    4846:	0141                	addi	sp,sp,16
    4848:	8082                	ret
  for(n = 0; s[n]; n++)
    484a:	4501                	li	a0,0
    484c:	bfe5                	j	4844 <strlen+0x20>

000000000000484e <memset>:

void*
memset(void *dst, int c, uint n)
{
    484e:	1141                	addi	sp,sp,-16
    4850:	e422                	sd	s0,8(sp)
    4852:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    4854:	ca19                	beqz	a2,486a <memset+0x1c>
    4856:	87aa                	mv	a5,a0
    4858:	1602                	slli	a2,a2,0x20
    485a:	9201                	srli	a2,a2,0x20
    485c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    4860:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    4864:	0785                	addi	a5,a5,1
    4866:	fee79de3          	bne	a5,a4,4860 <memset+0x12>
  }
  return dst;
}
    486a:	6422                	ld	s0,8(sp)
    486c:	0141                	addi	sp,sp,16
    486e:	8082                	ret

0000000000004870 <strchr>:

char*
strchr(const char *s, char c)
{
    4870:	1141                	addi	sp,sp,-16
    4872:	e422                	sd	s0,8(sp)
    4874:	0800                	addi	s0,sp,16
  for(; *s; s++)
    4876:	00054783          	lbu	a5,0(a0)
    487a:	cb99                	beqz	a5,4890 <strchr+0x20>
    if(*s == c)
    487c:	00f58763          	beq	a1,a5,488a <strchr+0x1a>
  for(; *s; s++)
    4880:	0505                	addi	a0,a0,1
    4882:	00054783          	lbu	a5,0(a0)
    4886:	fbfd                	bnez	a5,487c <strchr+0xc>
      return (char*)s;
  return 0;
    4888:	4501                	li	a0,0
}
    488a:	6422                	ld	s0,8(sp)
    488c:	0141                	addi	sp,sp,16
    488e:	8082                	ret
  return 0;
    4890:	4501                	li	a0,0
    4892:	bfe5                	j	488a <strchr+0x1a>

0000000000004894 <gets>:

char*
gets(char *buf, int max)
{
    4894:	711d                	addi	sp,sp,-96
    4896:	ec86                	sd	ra,88(sp)
    4898:	e8a2                	sd	s0,80(sp)
    489a:	e4a6                	sd	s1,72(sp)
    489c:	e0ca                	sd	s2,64(sp)
    489e:	fc4e                	sd	s3,56(sp)
    48a0:	f852                	sd	s4,48(sp)
    48a2:	f456                	sd	s5,40(sp)
    48a4:	f05a                	sd	s6,32(sp)
    48a6:	ec5e                	sd	s7,24(sp)
    48a8:	1080                	addi	s0,sp,96
    48aa:	8baa                	mv	s7,a0
    48ac:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    48ae:	892a                	mv	s2,a0
    48b0:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    48b2:	4aa9                	li	s5,10
    48b4:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    48b6:	89a6                	mv	s3,s1
    48b8:	2485                	addiw	s1,s1,1
    48ba:	0344d663          	bge	s1,s4,48e6 <gets+0x52>
    cc = read(0, &c, 1);
    48be:	4605                	li	a2,1
    48c0:	faf40593          	addi	a1,s0,-81
    48c4:	4501                	li	a0,0
    48c6:	186000ef          	jal	ra,4a4c <read>
    if(cc < 1)
    48ca:	00a05e63          	blez	a0,48e6 <gets+0x52>
    buf[i++] = c;
    48ce:	faf44783          	lbu	a5,-81(s0)
    48d2:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    48d6:	01578763          	beq	a5,s5,48e4 <gets+0x50>
    48da:	0905                	addi	s2,s2,1
    48dc:	fd679de3          	bne	a5,s6,48b6 <gets+0x22>
  for(i=0; i+1 < max; ){
    48e0:	89a6                	mv	s3,s1
    48e2:	a011                	j	48e6 <gets+0x52>
    48e4:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    48e6:	99de                	add	s3,s3,s7
    48e8:	00098023          	sb	zero,0(s3)
  return buf;
}
    48ec:	855e                	mv	a0,s7
    48ee:	60e6                	ld	ra,88(sp)
    48f0:	6446                	ld	s0,80(sp)
    48f2:	64a6                	ld	s1,72(sp)
    48f4:	6906                	ld	s2,64(sp)
    48f6:	79e2                	ld	s3,56(sp)
    48f8:	7a42                	ld	s4,48(sp)
    48fa:	7aa2                	ld	s5,40(sp)
    48fc:	7b02                	ld	s6,32(sp)
    48fe:	6be2                	ld	s7,24(sp)
    4900:	6125                	addi	sp,sp,96
    4902:	8082                	ret

0000000000004904 <stat>:

int
stat(const char *n, struct stat *st)
{
    4904:	1101                	addi	sp,sp,-32
    4906:	ec06                	sd	ra,24(sp)
    4908:	e822                	sd	s0,16(sp)
    490a:	e426                	sd	s1,8(sp)
    490c:	e04a                	sd	s2,0(sp)
    490e:	1000                	addi	s0,sp,32
    4910:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    4912:	4581                	li	a1,0
    4914:	160000ef          	jal	ra,4a74 <open>
  if(fd < 0)
    4918:	02054163          	bltz	a0,493a <stat+0x36>
    491c:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    491e:	85ca                	mv	a1,s2
    4920:	16c000ef          	jal	ra,4a8c <fstat>
    4924:	892a                	mv	s2,a0
  close(fd);
    4926:	8526                	mv	a0,s1
    4928:	134000ef          	jal	ra,4a5c <close>
  return r;
}
    492c:	854a                	mv	a0,s2
    492e:	60e2                	ld	ra,24(sp)
    4930:	6442                	ld	s0,16(sp)
    4932:	64a2                	ld	s1,8(sp)
    4934:	6902                	ld	s2,0(sp)
    4936:	6105                	addi	sp,sp,32
    4938:	8082                	ret
    return -1;
    493a:	597d                	li	s2,-1
    493c:	bfc5                	j	492c <stat+0x28>

000000000000493e <atoi>:

int
atoi(const char *s)
{
    493e:	1141                	addi	sp,sp,-16
    4940:	e422                	sd	s0,8(sp)
    4942:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    4944:	00054683          	lbu	a3,0(a0)
    4948:	fd06879b          	addiw	a5,a3,-48
    494c:	0ff7f793          	zext.b	a5,a5
    4950:	4625                	li	a2,9
    4952:	02f66863          	bltu	a2,a5,4982 <atoi+0x44>
    4956:	872a                	mv	a4,a0
  n = 0;
    4958:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
    495a:	0705                	addi	a4,a4,1
    495c:	0025179b          	slliw	a5,a0,0x2
    4960:	9fa9                	addw	a5,a5,a0
    4962:	0017979b          	slliw	a5,a5,0x1
    4966:	9fb5                	addw	a5,a5,a3
    4968:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    496c:	00074683          	lbu	a3,0(a4)
    4970:	fd06879b          	addiw	a5,a3,-48
    4974:	0ff7f793          	zext.b	a5,a5
    4978:	fef671e3          	bgeu	a2,a5,495a <atoi+0x1c>
  return n;
}
    497c:	6422                	ld	s0,8(sp)
    497e:	0141                	addi	sp,sp,16
    4980:	8082                	ret
  n = 0;
    4982:	4501                	li	a0,0
    4984:	bfe5                	j	497c <atoi+0x3e>

0000000000004986 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    4986:	1141                	addi	sp,sp,-16
    4988:	e422                	sd	s0,8(sp)
    498a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    498c:	02b57463          	bgeu	a0,a1,49b4 <memmove+0x2e>
    while(n-- > 0)
    4990:	00c05f63          	blez	a2,49ae <memmove+0x28>
    4994:	1602                	slli	a2,a2,0x20
    4996:	9201                	srli	a2,a2,0x20
    4998:	00c507b3          	add	a5,a0,a2
  dst = vdst;
    499c:	872a                	mv	a4,a0
      *dst++ = *src++;
    499e:	0585                	addi	a1,a1,1
    49a0:	0705                	addi	a4,a4,1
    49a2:	fff5c683          	lbu	a3,-1(a1)
    49a6:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    49aa:	fee79ae3          	bne	a5,a4,499e <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    49ae:	6422                	ld	s0,8(sp)
    49b0:	0141                	addi	sp,sp,16
    49b2:	8082                	ret
    dst += n;
    49b4:	00c50733          	add	a4,a0,a2
    src += n;
    49b8:	95b2                	add	a1,a1,a2
    while(n-- > 0)
    49ba:	fec05ae3          	blez	a2,49ae <memmove+0x28>
    49be:	fff6079b          	addiw	a5,a2,-1 # 2fff <subdir+0x477>
    49c2:	1782                	slli	a5,a5,0x20
    49c4:	9381                	srli	a5,a5,0x20
    49c6:	fff7c793          	not	a5,a5
    49ca:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    49cc:	15fd                	addi	a1,a1,-1
    49ce:	177d                	addi	a4,a4,-1
    49d0:	0005c683          	lbu	a3,0(a1)
    49d4:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    49d8:	fee79ae3          	bne	a5,a4,49cc <memmove+0x46>
    49dc:	bfc9                	j	49ae <memmove+0x28>

00000000000049de <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    49de:	1141                	addi	sp,sp,-16
    49e0:	e422                	sd	s0,8(sp)
    49e2:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    49e4:	ca05                	beqz	a2,4a14 <memcmp+0x36>
    49e6:	fff6069b          	addiw	a3,a2,-1
    49ea:	1682                	slli	a3,a3,0x20
    49ec:	9281                	srli	a3,a3,0x20
    49ee:	0685                	addi	a3,a3,1
    49f0:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
    49f2:	00054783          	lbu	a5,0(a0)
    49f6:	0005c703          	lbu	a4,0(a1)
    49fa:	00e79863          	bne	a5,a4,4a0a <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
    49fe:	0505                	addi	a0,a0,1
    p2++;
    4a00:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    4a02:	fed518e3          	bne	a0,a3,49f2 <memcmp+0x14>
  }
  return 0;
    4a06:	4501                	li	a0,0
    4a08:	a019                	j	4a0e <memcmp+0x30>
      return *p1 - *p2;
    4a0a:	40e7853b          	subw	a0,a5,a4
}
    4a0e:	6422                	ld	s0,8(sp)
    4a10:	0141                	addi	sp,sp,16
    4a12:	8082                	ret
  return 0;
    4a14:	4501                	li	a0,0
    4a16:	bfe5                	j	4a0e <memcmp+0x30>

0000000000004a18 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    4a18:	1141                	addi	sp,sp,-16
    4a1a:	e406                	sd	ra,8(sp)
    4a1c:	e022                	sd	s0,0(sp)
    4a1e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    4a20:	f67ff0ef          	jal	ra,4986 <memmove>
}
    4a24:	60a2                	ld	ra,8(sp)
    4a26:	6402                	ld	s0,0(sp)
    4a28:	0141                	addi	sp,sp,16
    4a2a:	8082                	ret

0000000000004a2c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    4a2c:	4885                	li	a7,1
 ecall
    4a2e:	00000073          	ecall
 ret
    4a32:	8082                	ret

0000000000004a34 <exit>:
.global exit
exit:
 li a7, SYS_exit
    4a34:	4889                	li	a7,2
 ecall
    4a36:	00000073          	ecall
 ret
    4a3a:	8082                	ret

0000000000004a3c <wait>:
.global wait
wait:
 li a7, SYS_wait
    4a3c:	488d                	li	a7,3
 ecall
    4a3e:	00000073          	ecall
 ret
    4a42:	8082                	ret

0000000000004a44 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    4a44:	4891                	li	a7,4
 ecall
    4a46:	00000073          	ecall
 ret
    4a4a:	8082                	ret

0000000000004a4c <read>:
.global read
read:
 li a7, SYS_read
    4a4c:	4895                	li	a7,5
 ecall
    4a4e:	00000073          	ecall
 ret
    4a52:	8082                	ret

0000000000004a54 <write>:
.global write
write:
 li a7, SYS_write
    4a54:	48c1                	li	a7,16
 ecall
    4a56:	00000073          	ecall
 ret
    4a5a:	8082                	ret

0000000000004a5c <close>:
.global close
close:
 li a7, SYS_close
    4a5c:	48d5                	li	a7,21
 ecall
    4a5e:	00000073          	ecall
 ret
    4a62:	8082                	ret

0000000000004a64 <kill>:
.global kill
kill:
 li a7, SYS_kill
    4a64:	4899                	li	a7,6
 ecall
    4a66:	00000073          	ecall
 ret
    4a6a:	8082                	ret

0000000000004a6c <exec>:
.global exec
exec:
 li a7, SYS_exec
    4a6c:	489d                	li	a7,7
 ecall
    4a6e:	00000073          	ecall
 ret
    4a72:	8082                	ret

0000000000004a74 <open>:
.global open
open:
 li a7, SYS_open
    4a74:	48bd                	li	a7,15
 ecall
    4a76:	00000073          	ecall
 ret
    4a7a:	8082                	ret

0000000000004a7c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    4a7c:	48c5                	li	a7,17
 ecall
    4a7e:	00000073          	ecall
 ret
    4a82:	8082                	ret

0000000000004a84 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    4a84:	48c9                	li	a7,18
 ecall
    4a86:	00000073          	ecall
 ret
    4a8a:	8082                	ret

0000000000004a8c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    4a8c:	48a1                	li	a7,8
 ecall
    4a8e:	00000073          	ecall
 ret
    4a92:	8082                	ret

0000000000004a94 <link>:
.global link
link:
 li a7, SYS_link
    4a94:	48cd                	li	a7,19
 ecall
    4a96:	00000073          	ecall
 ret
    4a9a:	8082                	ret

0000000000004a9c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    4a9c:	48d1                	li	a7,20
 ecall
    4a9e:	00000073          	ecall
 ret
    4aa2:	8082                	ret

0000000000004aa4 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    4aa4:	48a5                	li	a7,9
 ecall
    4aa6:	00000073          	ecall
 ret
    4aaa:	8082                	ret

0000000000004aac <dup>:
.global dup
dup:
 li a7, SYS_dup
    4aac:	48a9                	li	a7,10
 ecall
    4aae:	00000073          	ecall
 ret
    4ab2:	8082                	ret

0000000000004ab4 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    4ab4:	48ad                	li	a7,11
 ecall
    4ab6:	00000073          	ecall
 ret
    4aba:	8082                	ret

0000000000004abc <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    4abc:	48b1                	li	a7,12
 ecall
    4abe:	00000073          	ecall
 ret
    4ac2:	8082                	ret

0000000000004ac4 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    4ac4:	48b5                	li	a7,13
 ecall
    4ac6:	00000073          	ecall
 ret
    4aca:	8082                	ret

0000000000004acc <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    4acc:	48b9                	li	a7,14
 ecall
    4ace:	00000073          	ecall
 ret
    4ad2:	8082                	ret

0000000000004ad4 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    4ad4:	1101                	addi	sp,sp,-32
    4ad6:	ec06                	sd	ra,24(sp)
    4ad8:	e822                	sd	s0,16(sp)
    4ada:	1000                	addi	s0,sp,32
    4adc:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    4ae0:	4605                	li	a2,1
    4ae2:	fef40593          	addi	a1,s0,-17
    4ae6:	f6fff0ef          	jal	ra,4a54 <write>
}
    4aea:	60e2                	ld	ra,24(sp)
    4aec:	6442                	ld	s0,16(sp)
    4aee:	6105                	addi	sp,sp,32
    4af0:	8082                	ret

0000000000004af2 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    4af2:	7139                	addi	sp,sp,-64
    4af4:	fc06                	sd	ra,56(sp)
    4af6:	f822                	sd	s0,48(sp)
    4af8:	f426                	sd	s1,40(sp)
    4afa:	f04a                	sd	s2,32(sp)
    4afc:	ec4e                	sd	s3,24(sp)
    4afe:	0080                	addi	s0,sp,64
    4b00:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    4b02:	c299                	beqz	a3,4b08 <printint+0x16>
    4b04:	0805c763          	bltz	a1,4b92 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    4b08:	2581                	sext.w	a1,a1
  neg = 0;
    4b0a:	4881                	li	a7,0
    4b0c:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
    4b10:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    4b12:	2601                	sext.w	a2,a2
    4b14:	00003517          	auipc	a0,0x3
    4b18:	8dc50513          	addi	a0,a0,-1828 # 73f0 <digits>
    4b1c:	883a                	mv	a6,a4
    4b1e:	2705                	addiw	a4,a4,1
    4b20:	02c5f7bb          	remuw	a5,a1,a2
    4b24:	1782                	slli	a5,a5,0x20
    4b26:	9381                	srli	a5,a5,0x20
    4b28:	97aa                	add	a5,a5,a0
    4b2a:	0007c783          	lbu	a5,0(a5)
    4b2e:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    4b32:	0005879b          	sext.w	a5,a1
    4b36:	02c5d5bb          	divuw	a1,a1,a2
    4b3a:	0685                	addi	a3,a3,1
    4b3c:	fec7f0e3          	bgeu	a5,a2,4b1c <printint+0x2a>
  if(neg)
    4b40:	00088c63          	beqz	a7,4b58 <printint+0x66>
    buf[i++] = '-';
    4b44:	fd070793          	addi	a5,a4,-48
    4b48:	00878733          	add	a4,a5,s0
    4b4c:	02d00793          	li	a5,45
    4b50:	fef70823          	sb	a5,-16(a4)
    4b54:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    4b58:	02e05663          	blez	a4,4b84 <printint+0x92>
    4b5c:	fc040793          	addi	a5,s0,-64
    4b60:	00e78933          	add	s2,a5,a4
    4b64:	fff78993          	addi	s3,a5,-1
    4b68:	99ba                	add	s3,s3,a4
    4b6a:	377d                	addiw	a4,a4,-1
    4b6c:	1702                	slli	a4,a4,0x20
    4b6e:	9301                	srli	a4,a4,0x20
    4b70:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    4b74:	fff94583          	lbu	a1,-1(s2)
    4b78:	8526                	mv	a0,s1
    4b7a:	f5bff0ef          	jal	ra,4ad4 <putc>
  while(--i >= 0)
    4b7e:	197d                	addi	s2,s2,-1
    4b80:	ff391ae3          	bne	s2,s3,4b74 <printint+0x82>
}
    4b84:	70e2                	ld	ra,56(sp)
    4b86:	7442                	ld	s0,48(sp)
    4b88:	74a2                	ld	s1,40(sp)
    4b8a:	7902                	ld	s2,32(sp)
    4b8c:	69e2                	ld	s3,24(sp)
    4b8e:	6121                	addi	sp,sp,64
    4b90:	8082                	ret
    x = -xx;
    4b92:	40b005bb          	negw	a1,a1
    neg = 1;
    4b96:	4885                	li	a7,1
    x = -xx;
    4b98:	bf95                	j	4b0c <printint+0x1a>

0000000000004b9a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    4b9a:	7119                	addi	sp,sp,-128
    4b9c:	fc86                	sd	ra,120(sp)
    4b9e:	f8a2                	sd	s0,112(sp)
    4ba0:	f4a6                	sd	s1,104(sp)
    4ba2:	f0ca                	sd	s2,96(sp)
    4ba4:	ecce                	sd	s3,88(sp)
    4ba6:	e8d2                	sd	s4,80(sp)
    4ba8:	e4d6                	sd	s5,72(sp)
    4baa:	e0da                	sd	s6,64(sp)
    4bac:	fc5e                	sd	s7,56(sp)
    4bae:	f862                	sd	s8,48(sp)
    4bb0:	f466                	sd	s9,40(sp)
    4bb2:	f06a                	sd	s10,32(sp)
    4bb4:	ec6e                	sd	s11,24(sp)
    4bb6:	0100                	addi	s0,sp,128
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    4bb8:	0005c903          	lbu	s2,0(a1)
    4bbc:	22090e63          	beqz	s2,4df8 <vprintf+0x25e>
    4bc0:	8b2a                	mv	s6,a0
    4bc2:	8a2e                	mv	s4,a1
    4bc4:	8bb2                	mv	s7,a2
  state = 0;
    4bc6:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
    4bc8:	4481                	li	s1,0
    4bca:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
    4bcc:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
    4bd0:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
    4bd4:	06c00d13          	li	s10,108
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
    4bd8:	07500d93          	li	s11,117
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    4bdc:	00003c97          	auipc	s9,0x3
    4be0:	814c8c93          	addi	s9,s9,-2028 # 73f0 <digits>
    4be4:	a005                	j	4c04 <vprintf+0x6a>
        putc(fd, c0);
    4be6:	85ca                	mv	a1,s2
    4be8:	855a                	mv	a0,s6
    4bea:	eebff0ef          	jal	ra,4ad4 <putc>
    4bee:	a019                	j	4bf4 <vprintf+0x5a>
    } else if(state == '%'){
    4bf0:	03598263          	beq	s3,s5,4c14 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
    4bf4:	2485                	addiw	s1,s1,1
    4bf6:	8726                	mv	a4,s1
    4bf8:	009a07b3          	add	a5,s4,s1
    4bfc:	0007c903          	lbu	s2,0(a5)
    4c00:	1e090c63          	beqz	s2,4df8 <vprintf+0x25e>
    c0 = fmt[i] & 0xff;
    4c04:	0009079b          	sext.w	a5,s2
    if(state == 0){
    4c08:	fe0994e3          	bnez	s3,4bf0 <vprintf+0x56>
      if(c0 == '%'){
    4c0c:	fd579de3          	bne	a5,s5,4be6 <vprintf+0x4c>
        state = '%';
    4c10:	89be                	mv	s3,a5
    4c12:	b7cd                	j	4bf4 <vprintf+0x5a>
      if(c0) c1 = fmt[i+1] & 0xff;
    4c14:	cfa5                	beqz	a5,4c8c <vprintf+0xf2>
    4c16:	00ea06b3          	add	a3,s4,a4
    4c1a:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
    4c1e:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
    4c20:	c681                	beqz	a3,4c28 <vprintf+0x8e>
    4c22:	9752                	add	a4,a4,s4
    4c24:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
    4c28:	03878a63          	beq	a5,s8,4c5c <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
    4c2c:	05a78463          	beq	a5,s10,4c74 <vprintf+0xda>
      } else if(c0 == 'u'){
    4c30:	0db78763          	beq	a5,s11,4cfe <vprintf+0x164>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
    4c34:	07800713          	li	a4,120
    4c38:	10e78963          	beq	a5,a4,4d4a <vprintf+0x1b0>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
    4c3c:	07000713          	li	a4,112
    4c40:	12e78e63          	beq	a5,a4,4d7c <vprintf+0x1e2>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
    4c44:	07300713          	li	a4,115
    4c48:	16e78b63          	beq	a5,a4,4dbe <vprintf+0x224>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
    4c4c:	05579063          	bne	a5,s5,4c8c <vprintf+0xf2>
        putc(fd, '%');
    4c50:	85d6                	mv	a1,s5
    4c52:	855a                	mv	a0,s6
    4c54:	e81ff0ef          	jal	ra,4ad4 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
    4c58:	4981                	li	s3,0
    4c5a:	bf69                	j	4bf4 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 1);
    4c5c:	008b8913          	addi	s2,s7,8
    4c60:	4685                	li	a3,1
    4c62:	4629                	li	a2,10
    4c64:	000ba583          	lw	a1,0(s7)
    4c68:	855a                	mv	a0,s6
    4c6a:	e89ff0ef          	jal	ra,4af2 <printint>
    4c6e:	8bca                	mv	s7,s2
      state = 0;
    4c70:	4981                	li	s3,0
    4c72:	b749                	j	4bf4 <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'd'){
    4c74:	03868663          	beq	a3,s8,4ca0 <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    4c78:	05a68163          	beq	a3,s10,4cba <vprintf+0x120>
      } else if(c0 == 'l' && c1 == 'u'){
    4c7c:	09b68d63          	beq	a3,s11,4d16 <vprintf+0x17c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    4c80:	03a68f63          	beq	a3,s10,4cbe <vprintf+0x124>
      } else if(c0 == 'l' && c1 == 'x'){
    4c84:	07800793          	li	a5,120
    4c88:	0cf68d63          	beq	a3,a5,4d62 <vprintf+0x1c8>
        putc(fd, '%');
    4c8c:	85d6                	mv	a1,s5
    4c8e:	855a                	mv	a0,s6
    4c90:	e45ff0ef          	jal	ra,4ad4 <putc>
        putc(fd, c0);
    4c94:	85ca                	mv	a1,s2
    4c96:	855a                	mv	a0,s6
    4c98:	e3dff0ef          	jal	ra,4ad4 <putc>
      state = 0;
    4c9c:	4981                	li	s3,0
    4c9e:	bf99                	j	4bf4 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
    4ca0:	008b8913          	addi	s2,s7,8
    4ca4:	4685                	li	a3,1
    4ca6:	4629                	li	a2,10
    4ca8:	000ba583          	lw	a1,0(s7)
    4cac:	855a                	mv	a0,s6
    4cae:	e45ff0ef          	jal	ra,4af2 <printint>
        i += 1;
    4cb2:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
    4cb4:	8bca                	mv	s7,s2
      state = 0;
    4cb6:	4981                	li	s3,0
        i += 1;
    4cb8:	bf35                	j	4bf4 <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    4cba:	03860563          	beq	a2,s8,4ce4 <vprintf+0x14a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    4cbe:	07b60963          	beq	a2,s11,4d30 <vprintf+0x196>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    4cc2:	07800793          	li	a5,120
    4cc6:	fcf613e3          	bne	a2,a5,4c8c <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
    4cca:	008b8913          	addi	s2,s7,8
    4cce:	4681                	li	a3,0
    4cd0:	4641                	li	a2,16
    4cd2:	000ba583          	lw	a1,0(s7)
    4cd6:	855a                	mv	a0,s6
    4cd8:	e1bff0ef          	jal	ra,4af2 <printint>
        i += 2;
    4cdc:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
    4cde:	8bca                	mv	s7,s2
      state = 0;
    4ce0:	4981                	li	s3,0
        i += 2;
    4ce2:	bf09                	j	4bf4 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
    4ce4:	008b8913          	addi	s2,s7,8
    4ce8:	4685                	li	a3,1
    4cea:	4629                	li	a2,10
    4cec:	000ba583          	lw	a1,0(s7)
    4cf0:	855a                	mv	a0,s6
    4cf2:	e01ff0ef          	jal	ra,4af2 <printint>
        i += 2;
    4cf6:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
    4cf8:	8bca                	mv	s7,s2
      state = 0;
    4cfa:	4981                	li	s3,0
        i += 2;
    4cfc:	bde5                	j	4bf4 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 0);
    4cfe:	008b8913          	addi	s2,s7,8
    4d02:	4681                	li	a3,0
    4d04:	4629                	li	a2,10
    4d06:	000ba583          	lw	a1,0(s7)
    4d0a:	855a                	mv	a0,s6
    4d0c:	de7ff0ef          	jal	ra,4af2 <printint>
    4d10:	8bca                	mv	s7,s2
      state = 0;
    4d12:	4981                	li	s3,0
    4d14:	b5c5                	j	4bf4 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
    4d16:	008b8913          	addi	s2,s7,8
    4d1a:	4681                	li	a3,0
    4d1c:	4629                	li	a2,10
    4d1e:	000ba583          	lw	a1,0(s7)
    4d22:	855a                	mv	a0,s6
    4d24:	dcfff0ef          	jal	ra,4af2 <printint>
        i += 1;
    4d28:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
    4d2a:	8bca                	mv	s7,s2
      state = 0;
    4d2c:	4981                	li	s3,0
        i += 1;
    4d2e:	b5d9                	j	4bf4 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
    4d30:	008b8913          	addi	s2,s7,8
    4d34:	4681                	li	a3,0
    4d36:	4629                	li	a2,10
    4d38:	000ba583          	lw	a1,0(s7)
    4d3c:	855a                	mv	a0,s6
    4d3e:	db5ff0ef          	jal	ra,4af2 <printint>
        i += 2;
    4d42:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
    4d44:	8bca                	mv	s7,s2
      state = 0;
    4d46:	4981                	li	s3,0
        i += 2;
    4d48:	b575                	j	4bf4 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 16, 0);
    4d4a:	008b8913          	addi	s2,s7,8
    4d4e:	4681                	li	a3,0
    4d50:	4641                	li	a2,16
    4d52:	000ba583          	lw	a1,0(s7)
    4d56:	855a                	mv	a0,s6
    4d58:	d9bff0ef          	jal	ra,4af2 <printint>
    4d5c:	8bca                	mv	s7,s2
      state = 0;
    4d5e:	4981                	li	s3,0
    4d60:	bd51                	j	4bf4 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 16, 0);
    4d62:	008b8913          	addi	s2,s7,8
    4d66:	4681                	li	a3,0
    4d68:	4641                	li	a2,16
    4d6a:	000ba583          	lw	a1,0(s7)
    4d6e:	855a                	mv	a0,s6
    4d70:	d83ff0ef          	jal	ra,4af2 <printint>
        i += 1;
    4d74:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
    4d76:	8bca                	mv	s7,s2
      state = 0;
    4d78:	4981                	li	s3,0
        i += 1;
    4d7a:	bdad                	j	4bf4 <vprintf+0x5a>
        printptr(fd, va_arg(ap, uint64));
    4d7c:	008b8793          	addi	a5,s7,8
    4d80:	f8f43423          	sd	a5,-120(s0)
    4d84:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    4d88:	03000593          	li	a1,48
    4d8c:	855a                	mv	a0,s6
    4d8e:	d47ff0ef          	jal	ra,4ad4 <putc>
  putc(fd, 'x');
    4d92:	07800593          	li	a1,120
    4d96:	855a                	mv	a0,s6
    4d98:	d3dff0ef          	jal	ra,4ad4 <putc>
    4d9c:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    4d9e:	03c9d793          	srli	a5,s3,0x3c
    4da2:	97e6                	add	a5,a5,s9
    4da4:	0007c583          	lbu	a1,0(a5)
    4da8:	855a                	mv	a0,s6
    4daa:	d2bff0ef          	jal	ra,4ad4 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    4dae:	0992                	slli	s3,s3,0x4
    4db0:	397d                	addiw	s2,s2,-1
    4db2:	fe0916e3          	bnez	s2,4d9e <vprintf+0x204>
        printptr(fd, va_arg(ap, uint64));
    4db6:	f8843b83          	ld	s7,-120(s0)
      state = 0;
    4dba:	4981                	li	s3,0
    4dbc:	bd25                	j	4bf4 <vprintf+0x5a>
        if((s = va_arg(ap, char*)) == 0)
    4dbe:	008b8993          	addi	s3,s7,8
    4dc2:	000bb903          	ld	s2,0(s7)
    4dc6:	00090f63          	beqz	s2,4de4 <vprintf+0x24a>
        for(; *s; s++)
    4dca:	00094583          	lbu	a1,0(s2)
    4dce:	c195                	beqz	a1,4df2 <vprintf+0x258>
          putc(fd, *s);
    4dd0:	855a                	mv	a0,s6
    4dd2:	d03ff0ef          	jal	ra,4ad4 <putc>
        for(; *s; s++)
    4dd6:	0905                	addi	s2,s2,1
    4dd8:	00094583          	lbu	a1,0(s2)
    4ddc:	f9f5                	bnez	a1,4dd0 <vprintf+0x236>
        if((s = va_arg(ap, char*)) == 0)
    4dde:	8bce                	mv	s7,s3
      state = 0;
    4de0:	4981                	li	s3,0
    4de2:	bd09                	j	4bf4 <vprintf+0x5a>
          s = "(null)";
    4de4:	00002917          	auipc	s2,0x2
    4de8:	60490913          	addi	s2,s2,1540 # 73e8 <malloc+0x24f4>
        for(; *s; s++)
    4dec:	02800593          	li	a1,40
    4df0:	b7c5                	j	4dd0 <vprintf+0x236>
        if((s = va_arg(ap, char*)) == 0)
    4df2:	8bce                	mv	s7,s3
      state = 0;
    4df4:	4981                	li	s3,0
    4df6:	bbfd                	j	4bf4 <vprintf+0x5a>
    }
  }
}
    4df8:	70e6                	ld	ra,120(sp)
    4dfa:	7446                	ld	s0,112(sp)
    4dfc:	74a6                	ld	s1,104(sp)
    4dfe:	7906                	ld	s2,96(sp)
    4e00:	69e6                	ld	s3,88(sp)
    4e02:	6a46                	ld	s4,80(sp)
    4e04:	6aa6                	ld	s5,72(sp)
    4e06:	6b06                	ld	s6,64(sp)
    4e08:	7be2                	ld	s7,56(sp)
    4e0a:	7c42                	ld	s8,48(sp)
    4e0c:	7ca2                	ld	s9,40(sp)
    4e0e:	7d02                	ld	s10,32(sp)
    4e10:	6de2                	ld	s11,24(sp)
    4e12:	6109                	addi	sp,sp,128
    4e14:	8082                	ret

0000000000004e16 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    4e16:	715d                	addi	sp,sp,-80
    4e18:	ec06                	sd	ra,24(sp)
    4e1a:	e822                	sd	s0,16(sp)
    4e1c:	1000                	addi	s0,sp,32
    4e1e:	e010                	sd	a2,0(s0)
    4e20:	e414                	sd	a3,8(s0)
    4e22:	e818                	sd	a4,16(s0)
    4e24:	ec1c                	sd	a5,24(s0)
    4e26:	03043023          	sd	a6,32(s0)
    4e2a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    4e2e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    4e32:	8622                	mv	a2,s0
    4e34:	d67ff0ef          	jal	ra,4b9a <vprintf>
}
    4e38:	60e2                	ld	ra,24(sp)
    4e3a:	6442                	ld	s0,16(sp)
    4e3c:	6161                	addi	sp,sp,80
    4e3e:	8082                	ret

0000000000004e40 <printf>:

void
printf(const char *fmt, ...)
{
    4e40:	711d                	addi	sp,sp,-96
    4e42:	ec06                	sd	ra,24(sp)
    4e44:	e822                	sd	s0,16(sp)
    4e46:	1000                	addi	s0,sp,32
    4e48:	e40c                	sd	a1,8(s0)
    4e4a:	e810                	sd	a2,16(s0)
    4e4c:	ec14                	sd	a3,24(s0)
    4e4e:	f018                	sd	a4,32(s0)
    4e50:	f41c                	sd	a5,40(s0)
    4e52:	03043823          	sd	a6,48(s0)
    4e56:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    4e5a:	00840613          	addi	a2,s0,8
    4e5e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    4e62:	85aa                	mv	a1,a0
    4e64:	4505                	li	a0,1
    4e66:	d35ff0ef          	jal	ra,4b9a <vprintf>
}
    4e6a:	60e2                	ld	ra,24(sp)
    4e6c:	6442                	ld	s0,16(sp)
    4e6e:	6125                	addi	sp,sp,96
    4e70:	8082                	ret

0000000000004e72 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    4e72:	1141                	addi	sp,sp,-16
    4e74:	e422                	sd	s0,8(sp)
    4e76:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    4e78:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    4e7c:	00003797          	auipc	a5,0x3
    4e80:	5d47b783          	ld	a5,1492(a5) # 8450 <freep>
    4e84:	a02d                	j	4eae <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    4e86:	4618                	lw	a4,8(a2)
    4e88:	9f2d                	addw	a4,a4,a1
    4e8a:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    4e8e:	6398                	ld	a4,0(a5)
    4e90:	6310                	ld	a2,0(a4)
    4e92:	a83d                	j	4ed0 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    4e94:	ff852703          	lw	a4,-8(a0)
    4e98:	9f31                	addw	a4,a4,a2
    4e9a:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    4e9c:	ff053683          	ld	a3,-16(a0)
    4ea0:	a091                	j	4ee4 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    4ea2:	6398                	ld	a4,0(a5)
    4ea4:	00e7e463          	bltu	a5,a4,4eac <free+0x3a>
    4ea8:	00e6ea63          	bltu	a3,a4,4ebc <free+0x4a>
{
    4eac:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    4eae:	fed7fae3          	bgeu	a5,a3,4ea2 <free+0x30>
    4eb2:	6398                	ld	a4,0(a5)
    4eb4:	00e6e463          	bltu	a3,a4,4ebc <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    4eb8:	fee7eae3          	bltu	a5,a4,4eac <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
    4ebc:	ff852583          	lw	a1,-8(a0)
    4ec0:	6390                	ld	a2,0(a5)
    4ec2:	02059813          	slli	a6,a1,0x20
    4ec6:	01c85713          	srli	a4,a6,0x1c
    4eca:	9736                	add	a4,a4,a3
    4ecc:	fae60de3          	beq	a2,a4,4e86 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
    4ed0:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    4ed4:	4790                	lw	a2,8(a5)
    4ed6:	02061593          	slli	a1,a2,0x20
    4eda:	01c5d713          	srli	a4,a1,0x1c
    4ede:	973e                	add	a4,a4,a5
    4ee0:	fae68ae3          	beq	a3,a4,4e94 <free+0x22>
    p->s.ptr = bp->s.ptr;
    4ee4:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    4ee6:	00003717          	auipc	a4,0x3
    4eea:	56f73523          	sd	a5,1386(a4) # 8450 <freep>
}
    4eee:	6422                	ld	s0,8(sp)
    4ef0:	0141                	addi	sp,sp,16
    4ef2:	8082                	ret

0000000000004ef4 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    4ef4:	7139                	addi	sp,sp,-64
    4ef6:	fc06                	sd	ra,56(sp)
    4ef8:	f822                	sd	s0,48(sp)
    4efa:	f426                	sd	s1,40(sp)
    4efc:	f04a                	sd	s2,32(sp)
    4efe:	ec4e                	sd	s3,24(sp)
    4f00:	e852                	sd	s4,16(sp)
    4f02:	e456                	sd	s5,8(sp)
    4f04:	e05a                	sd	s6,0(sp)
    4f06:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    4f08:	02051493          	slli	s1,a0,0x20
    4f0c:	9081                	srli	s1,s1,0x20
    4f0e:	04bd                	addi	s1,s1,15
    4f10:	8091                	srli	s1,s1,0x4
    4f12:	0014899b          	addiw	s3,s1,1
    4f16:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    4f18:	00003517          	auipc	a0,0x3
    4f1c:	53853503          	ld	a0,1336(a0) # 8450 <freep>
    4f20:	c515                	beqz	a0,4f4c <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    4f22:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    4f24:	4798                	lw	a4,8(a5)
    4f26:	02977f63          	bgeu	a4,s1,4f64 <malloc+0x70>
    4f2a:	8a4e                	mv	s4,s3
    4f2c:	0009871b          	sext.w	a4,s3
    4f30:	6685                	lui	a3,0x1
    4f32:	00d77363          	bgeu	a4,a3,4f38 <malloc+0x44>
    4f36:	6a05                	lui	s4,0x1
    4f38:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    4f3c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    4f40:	00003917          	auipc	s2,0x3
    4f44:	51090913          	addi	s2,s2,1296 # 8450 <freep>
  if(p == (char*)-1)
    4f48:	5afd                	li	s5,-1
    4f4a:	a885                	j	4fba <malloc+0xc6>
    base.s.ptr = freep = prevp = &base;
    4f4c:	0000a797          	auipc	a5,0xa
    4f50:	d2c78793          	addi	a5,a5,-724 # ec78 <base>
    4f54:	00003717          	auipc	a4,0x3
    4f58:	4ef73e23          	sd	a5,1276(a4) # 8450 <freep>
    4f5c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    4f5e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    4f62:	b7e1                	j	4f2a <malloc+0x36>
      if(p->s.size == nunits)
    4f64:	02e48c63          	beq	s1,a4,4f9c <malloc+0xa8>
        p->s.size -= nunits;
    4f68:	4137073b          	subw	a4,a4,s3
    4f6c:	c798                	sw	a4,8(a5)
        p += p->s.size;
    4f6e:	02071693          	slli	a3,a4,0x20
    4f72:	01c6d713          	srli	a4,a3,0x1c
    4f76:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    4f78:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    4f7c:	00003717          	auipc	a4,0x3
    4f80:	4ca73a23          	sd	a0,1236(a4) # 8450 <freep>
      return (void*)(p + 1);
    4f84:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    4f88:	70e2                	ld	ra,56(sp)
    4f8a:	7442                	ld	s0,48(sp)
    4f8c:	74a2                	ld	s1,40(sp)
    4f8e:	7902                	ld	s2,32(sp)
    4f90:	69e2                	ld	s3,24(sp)
    4f92:	6a42                	ld	s4,16(sp)
    4f94:	6aa2                	ld	s5,8(sp)
    4f96:	6b02                	ld	s6,0(sp)
    4f98:	6121                	addi	sp,sp,64
    4f9a:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    4f9c:	6398                	ld	a4,0(a5)
    4f9e:	e118                	sd	a4,0(a0)
    4fa0:	bff1                	j	4f7c <malloc+0x88>
  hp->s.size = nu;
    4fa2:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    4fa6:	0541                	addi	a0,a0,16
    4fa8:	ecbff0ef          	jal	ra,4e72 <free>
  return freep;
    4fac:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    4fb0:	dd61                	beqz	a0,4f88 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    4fb2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    4fb4:	4798                	lw	a4,8(a5)
    4fb6:	fa9777e3          	bgeu	a4,s1,4f64 <malloc+0x70>
    if(p == freep)
    4fba:	00093703          	ld	a4,0(s2)
    4fbe:	853e                	mv	a0,a5
    4fc0:	fef719e3          	bne	a4,a5,4fb2 <malloc+0xbe>
  p = sbrk(nu * sizeof(Header));
    4fc4:	8552                	mv	a0,s4
    4fc6:	af7ff0ef          	jal	ra,4abc <sbrk>
  if(p == (char*)-1)
    4fca:	fd551ce3          	bne	a0,s5,4fa2 <malloc+0xae>
        return 0;
    4fce:	4501                	li	a0,0
    4fd0:	bf65                	j	4f88 <malloc+0x94>
