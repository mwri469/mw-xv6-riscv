
user/_wlan_cfg:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <wilc_wlan_cfg_init>:
unsigned short g_cfg_hword[] = {0x1234, 0x5678};
unsigned int g_cfg_word[] = {0xDEADBEEF, 0xCAFEBABE};
struct wilc_cfg_s g_cfg_str[] = {{0, NULL}, {0, NULL}, {0, NULL}, {0, NULL}};

// The function being tested
int wilc_wlan_cfg_init(struct wilc *wl) {
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	addi	s0,sp,32
   c:	84aa                	mv	s1,a0
    struct wilc_cfg_string_vals *str_vals;
    int i = 0;

    wl->cfg.b = malloc(sizeof(g_cfg_byte));
   e:	450d                	li	a0,3
  10:	0b1000ef          	jal	ra,8c0 <malloc>
  14:	e088                	sd	a0,0(s1)
    if (!wl->cfg.b)
  16:	14050163          	beqz	a0,158 <wilc_wlan_cfg_init+0x158>
        return -1;

    memcpy(wl->cfg.b, g_cfg_byte, sizeof(g_cfg_byte));
  1a:	460d                	li	a2,3
  1c:	00001597          	auipc	a1,0x1
  20:	ff458593          	addi	a1,a1,-12 # 1010 <g_cfg_byte>
  24:	3c0000ef          	jal	ra,3e4 <memcpy>

    wl->cfg.hw = malloc(sizeof(g_cfg_hword));
  28:	4511                	li	a0,4
  2a:	097000ef          	jal	ra,8c0 <malloc>
  2e:	e488                	sd	a0,8(s1)
    if (!wl->cfg.hw)
  30:	10050b63          	beqz	a0,146 <wilc_wlan_cfg_init+0x146>
        goto out_b;

    memcpy(wl->cfg.hw, g_cfg_hword, sizeof(g_cfg_hword));
  34:	4611                	li	a2,4
  36:	00001597          	auipc	a1,0x1
  3a:	fd258593          	addi	a1,a1,-46 # 1008 <g_cfg_hword>
  3e:	3a6000ef          	jal	ra,3e4 <memcpy>

    wl->cfg.w = malloc(sizeof(g_cfg_word));
  42:	4521                	li	a0,8
  44:	07d000ef          	jal	ra,8c0 <malloc>
  48:	e888                	sd	a0,16(s1)
    if (!wl->cfg.w)
  4a:	0e050763          	beqz	a0,138 <wilc_wlan_cfg_init+0x138>
        goto out_hw;

    memcpy(wl->cfg.w, g_cfg_word, sizeof(g_cfg_word));
  4e:	4621                	li	a2,8
  50:	00001597          	auipc	a1,0x1
  54:	fb058593          	addi	a1,a1,-80 # 1000 <g_cfg_word>
  58:	38c000ef          	jal	ra,3e4 <memcpy>

    wl->cfg.s = malloc(sizeof(g_cfg_str));
  5c:	04000513          	li	a0,64
  60:	061000ef          	jal	ra,8c0 <malloc>
  64:	ec88                	sd	a0,24(s1)
    if (!wl->cfg.s)
  66:	c171                	beqz	a0,12a <wilc_wlan_cfg_init+0x12a>
        goto out_w;

    memcpy(wl->cfg.s, g_cfg_str, sizeof(g_cfg_str));
  68:	04000613          	li	a2,64
  6c:	00001597          	auipc	a1,0x1
  70:	fc458593          	addi	a1,a1,-60 # 1030 <g_cfg_str>
  74:	370000ef          	jal	ra,3e4 <memcpy>

    str_vals = malloc(sizeof(str_vals));
  78:	4521                	li	a0,8
  7a:	047000ef          	jal	ra,8c0 <malloc>
  7e:	892a                	mv	s2,a0
    if (!str_vals)
  80:	cd51                	beqz	a0,11c <wilc_wlan_cfg_init+0x11c>
        goto out_s;

    wl->cfg.str_vals = str_vals;
  82:	f088                	sd	a0,32(s1)

    /* store the string cfg parameters */
    wl->cfg.s[i].id = WID_FIRMWARE_VERSION;
  84:	6c9c                	ld	a5,24(s1)
  86:	4705                	li	a4,1
  88:	c398                	sw	a4,0(a5)
    wl->cfg.s[i].str = str_vals->firmware_version;
  8a:	6c9c                	ld	a5,24(s1)
  8c:	e788                	sd	a0,8(a5)
	// printf("Firmware version: %p\n", (void *) &str_vals->firmware_version);
    i++;
    wl->cfg.s[i].id = WID_MAC_ADDR;
  8e:	6c9c                	ld	a5,24(s1)
  90:	4709                	li	a4,2
  92:	cb98                	sw	a4,16(a5)
    wl->cfg.s[i].str = str_vals->mac_address;
  94:	6c9c                	ld	a5,24(s1)
  96:	08050713          	addi	a4,a0,128
  9a:	ef98                	sd	a4,24(a5)
    i++;
    wl->cfg.s[i].id = WID_ASSOC_RES_INFO;
  9c:	6c9c                	ld	a5,24(s1)
  9e:	470d                	li	a4,3
  a0:	d398                	sw	a4,32(a5)
    wl->cfg.s[i].str = str_vals->assoc_rsp;
  a2:	6c9c                	ld	a5,24(s1)
  a4:	10050713          	addi	a4,a0,256
  a8:	f798                	sd	a4,40(a5)
    i++;
    wl->cfg.s[i].id = WID_NIL;
  aa:	6c9c                	ld	a5,24(s1)
  ac:	4711                	li	a4,4
  ae:	db98                	sw	a4,48(a5)
    wl->cfg.s[i].str = NULL;
  b0:	6c9c                	ld	a5,24(s1)
  b2:	0207bc23          	sd	zero,56(a5)

	printf("Before: %s\n", str_vals->firmware_version);
  b6:	85aa                	mv	a1,a0
  b8:	00001517          	auipc	a0,0x1
  bc:	8f850513          	addi	a0,a0,-1800 # 9b0 <malloc+0xf0>
  c0:	74c000ef          	jal	ra,80c <printf>
	strcpy(wl->cfg.s[0].str, "1.2.3");
  c4:	6c9c                	ld	a5,24(s1)
  c6:	679c                	ld	a5,8(a5)
  c8:	00001717          	auipc	a4,0x1
  cc:	8f870713          	addi	a4,a4,-1800 # 9c0 <malloc+0x100>
  d0:	00074803          	lbu	a6,0(a4)
  d4:	00174503          	lbu	a0,1(a4)
  d8:	00274583          	lbu	a1,2(a4)
  dc:	00374603          	lbu	a2,3(a4)
  e0:	00474683          	lbu	a3,4(a4)
  e4:	00574703          	lbu	a4,5(a4)
  e8:	01078023          	sb	a6,0(a5)
  ec:	00a780a3          	sb	a0,1(a5)
  f0:	00b78123          	sb	a1,2(a5)
  f4:	00c781a3          	sb	a2,3(a5)
  f8:	00d78223          	sb	a3,4(a5)
  fc:	00e782a3          	sb	a4,5(a5)
	printf("After: %s\n", str_vals->firmware_version);
 100:	85ca                	mv	a1,s2
 102:	00001517          	auipc	a0,0x1
 106:	8c650513          	addi	a0,a0,-1850 # 9c8 <malloc+0x108>
 10a:	702000ef          	jal	ra,80c <printf>

    return 0;
 10e:	4501                	li	a0,0
out_hw:
    fprintf(1, "Cleaning hw");
out_b:
    fprintf(1, "Cleaning b");
    return -1;
}
 110:	60e2                	ld	ra,24(sp)
 112:	6442                	ld	s0,16(sp)
 114:	64a2                	ld	s1,8(sp)
 116:	6902                	ld	s2,0(sp)
 118:	6105                	addi	sp,sp,32
 11a:	8082                	ret
    fprintf(1, "Cleaning s");
 11c:	00001597          	auipc	a1,0x1
 120:	88458593          	addi	a1,a1,-1916 # 9a0 <malloc+0xe0>
 124:	4505                	li	a0,1
 126:	6bc000ef          	jal	ra,7e2 <fprintf>
    fprintf(1, "Cleaning w");
 12a:	00001597          	auipc	a1,0x1
 12e:	8ae58593          	addi	a1,a1,-1874 # 9d8 <malloc+0x118>
 132:	4505                	li	a0,1
 134:	6ae000ef          	jal	ra,7e2 <fprintf>
    fprintf(1, "Cleaning hw");
 138:	00001597          	auipc	a1,0x1
 13c:	8b058593          	addi	a1,a1,-1872 # 9e8 <malloc+0x128>
 140:	4505                	li	a0,1
 142:	6a0000ef          	jal	ra,7e2 <fprintf>
    fprintf(1, "Cleaning b");
 146:	00001597          	auipc	a1,0x1
 14a:	8b258593          	addi	a1,a1,-1870 # 9f8 <malloc+0x138>
 14e:	4505                	li	a0,1
 150:	692000ef          	jal	ra,7e2 <fprintf>
    return -1;
 154:	557d                	li	a0,-1
 156:	bf6d                	j	110 <wilc_wlan_cfg_init+0x110>
        return -1;
 158:	557d                	li	a0,-1
 15a:	bf5d                	j	110 <wilc_wlan_cfg_init+0x110>

000000000000015c <main>:

int main() {
 15c:	7139                	addi	sp,sp,-64
 15e:	fc06                	sd	ra,56(sp)
 160:	f822                	sd	s0,48(sp)
 162:	0080                	addi	s0,sp,64
    struct wilc wl;

    // Initialize and test the function
    if (wilc_wlan_cfg_init(&wl) != 0) {
 164:	fc840513          	addi	a0,s0,-56
 168:	e99ff0ef          	jal	ra,0 <wilc_wlan_cfg_init>
 16c:	c919                	beqz	a0,182 <main+0x26>
        fprintf(1, "Failed to initialize WILC configuration.\n");
 16e:	00001597          	auipc	a1,0x1
 172:	89a58593          	addi	a1,a1,-1894 # a08 <malloc+0x148>
 176:	4505                	li	a0,1
 178:	66a000ef          	jal	ra,7e2 <fprintf>
        exit(1);
 17c:	4505                	li	a0,1
 17e:	282000ef          	jal	ra,400 <exit>
    }

    fprintf(1, "WILC configuration initialized successfully.\n");
 182:	00001597          	auipc	a1,0x1
 186:	8b658593          	addi	a1,a1,-1866 # a38 <malloc+0x178>
 18a:	4505                	li	a0,1
 18c:	656000ef          	jal	ra,7e2 <fprintf>
   
	exit(0);
 190:	4501                	li	a0,0
 192:	26e000ef          	jal	ra,400 <exit>

0000000000000196 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 196:	1141                	addi	sp,sp,-16
 198:	e406                	sd	ra,8(sp)
 19a:	e022                	sd	s0,0(sp)
 19c:	0800                	addi	s0,sp,16
  extern int main();
  main();
 19e:	fbfff0ef          	jal	ra,15c <main>
  exit(0);
 1a2:	4501                	li	a0,0
 1a4:	25c000ef          	jal	ra,400 <exit>

00000000000001a8 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 1a8:	1141                	addi	sp,sp,-16
 1aa:	e422                	sd	s0,8(sp)
 1ac:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1ae:	87aa                	mv	a5,a0
 1b0:	0585                	addi	a1,a1,1
 1b2:	0785                	addi	a5,a5,1
 1b4:	fff5c703          	lbu	a4,-1(a1)
 1b8:	fee78fa3          	sb	a4,-1(a5)
 1bc:	fb75                	bnez	a4,1b0 <strcpy+0x8>
    ;
  return os;
}
 1be:	6422                	ld	s0,8(sp)
 1c0:	0141                	addi	sp,sp,16
 1c2:	8082                	ret

00000000000001c4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1c4:	1141                	addi	sp,sp,-16
 1c6:	e422                	sd	s0,8(sp)
 1c8:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 1ca:	00054783          	lbu	a5,0(a0)
 1ce:	cb91                	beqz	a5,1e2 <strcmp+0x1e>
 1d0:	0005c703          	lbu	a4,0(a1)
 1d4:	00f71763          	bne	a4,a5,1e2 <strcmp+0x1e>
    p++, q++;
 1d8:	0505                	addi	a0,a0,1
 1da:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 1dc:	00054783          	lbu	a5,0(a0)
 1e0:	fbe5                	bnez	a5,1d0 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 1e2:	0005c503          	lbu	a0,0(a1)
}
 1e6:	40a7853b          	subw	a0,a5,a0
 1ea:	6422                	ld	s0,8(sp)
 1ec:	0141                	addi	sp,sp,16
 1ee:	8082                	ret

00000000000001f0 <strlen>:

uint
strlen(const char *s)
{
 1f0:	1141                	addi	sp,sp,-16
 1f2:	e422                	sd	s0,8(sp)
 1f4:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1f6:	00054783          	lbu	a5,0(a0)
 1fa:	cf91                	beqz	a5,216 <strlen+0x26>
 1fc:	0505                	addi	a0,a0,1
 1fe:	87aa                	mv	a5,a0
 200:	4685                	li	a3,1
 202:	9e89                	subw	a3,a3,a0
 204:	00f6853b          	addw	a0,a3,a5
 208:	0785                	addi	a5,a5,1
 20a:	fff7c703          	lbu	a4,-1(a5)
 20e:	fb7d                	bnez	a4,204 <strlen+0x14>
    ;
  return n;
}
 210:	6422                	ld	s0,8(sp)
 212:	0141                	addi	sp,sp,16
 214:	8082                	ret
  for(n = 0; s[n]; n++)
 216:	4501                	li	a0,0
 218:	bfe5                	j	210 <strlen+0x20>

000000000000021a <memset>:

void*
memset(void *dst, int c, uint n)
{
 21a:	1141                	addi	sp,sp,-16
 21c:	e422                	sd	s0,8(sp)
 21e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 220:	ca19                	beqz	a2,236 <memset+0x1c>
 222:	87aa                	mv	a5,a0
 224:	1602                	slli	a2,a2,0x20
 226:	9201                	srli	a2,a2,0x20
 228:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 22c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 230:	0785                	addi	a5,a5,1
 232:	fee79de3          	bne	a5,a4,22c <memset+0x12>
  }
  return dst;
}
 236:	6422                	ld	s0,8(sp)
 238:	0141                	addi	sp,sp,16
 23a:	8082                	ret

000000000000023c <strchr>:

char*
strchr(const char *s, char c)
{
 23c:	1141                	addi	sp,sp,-16
 23e:	e422                	sd	s0,8(sp)
 240:	0800                	addi	s0,sp,16
  for(; *s; s++)
 242:	00054783          	lbu	a5,0(a0)
 246:	cb99                	beqz	a5,25c <strchr+0x20>
    if(*s == c)
 248:	00f58763          	beq	a1,a5,256 <strchr+0x1a>
  for(; *s; s++)
 24c:	0505                	addi	a0,a0,1
 24e:	00054783          	lbu	a5,0(a0)
 252:	fbfd                	bnez	a5,248 <strchr+0xc>
      return (char*)s;
  return 0;
 254:	4501                	li	a0,0
}
 256:	6422                	ld	s0,8(sp)
 258:	0141                	addi	sp,sp,16
 25a:	8082                	ret
  return 0;
 25c:	4501                	li	a0,0
 25e:	bfe5                	j	256 <strchr+0x1a>

0000000000000260 <gets>:

char*
gets(char *buf, int max)
{
 260:	711d                	addi	sp,sp,-96
 262:	ec86                	sd	ra,88(sp)
 264:	e8a2                	sd	s0,80(sp)
 266:	e4a6                	sd	s1,72(sp)
 268:	e0ca                	sd	s2,64(sp)
 26a:	fc4e                	sd	s3,56(sp)
 26c:	f852                	sd	s4,48(sp)
 26e:	f456                	sd	s5,40(sp)
 270:	f05a                	sd	s6,32(sp)
 272:	ec5e                	sd	s7,24(sp)
 274:	1080                	addi	s0,sp,96
 276:	8baa                	mv	s7,a0
 278:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 27a:	892a                	mv	s2,a0
 27c:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 27e:	4aa9                	li	s5,10
 280:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 282:	89a6                	mv	s3,s1
 284:	2485                	addiw	s1,s1,1
 286:	0344d663          	bge	s1,s4,2b2 <gets+0x52>
    cc = read(0, &c, 1);
 28a:	4605                	li	a2,1
 28c:	faf40593          	addi	a1,s0,-81
 290:	4501                	li	a0,0
 292:	186000ef          	jal	ra,418 <read>
    if(cc < 1)
 296:	00a05e63          	blez	a0,2b2 <gets+0x52>
    buf[i++] = c;
 29a:	faf44783          	lbu	a5,-81(s0)
 29e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 2a2:	01578763          	beq	a5,s5,2b0 <gets+0x50>
 2a6:	0905                	addi	s2,s2,1
 2a8:	fd679de3          	bne	a5,s6,282 <gets+0x22>
  for(i=0; i+1 < max; ){
 2ac:	89a6                	mv	s3,s1
 2ae:	a011                	j	2b2 <gets+0x52>
 2b0:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 2b2:	99de                	add	s3,s3,s7
 2b4:	00098023          	sb	zero,0(s3)
  return buf;
}
 2b8:	855e                	mv	a0,s7
 2ba:	60e6                	ld	ra,88(sp)
 2bc:	6446                	ld	s0,80(sp)
 2be:	64a6                	ld	s1,72(sp)
 2c0:	6906                	ld	s2,64(sp)
 2c2:	79e2                	ld	s3,56(sp)
 2c4:	7a42                	ld	s4,48(sp)
 2c6:	7aa2                	ld	s5,40(sp)
 2c8:	7b02                	ld	s6,32(sp)
 2ca:	6be2                	ld	s7,24(sp)
 2cc:	6125                	addi	sp,sp,96
 2ce:	8082                	ret

00000000000002d0 <stat>:

int
stat(const char *n, struct stat *st)
{
 2d0:	1101                	addi	sp,sp,-32
 2d2:	ec06                	sd	ra,24(sp)
 2d4:	e822                	sd	s0,16(sp)
 2d6:	e426                	sd	s1,8(sp)
 2d8:	e04a                	sd	s2,0(sp)
 2da:	1000                	addi	s0,sp,32
 2dc:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2de:	4581                	li	a1,0
 2e0:	160000ef          	jal	ra,440 <open>
  if(fd < 0)
 2e4:	02054163          	bltz	a0,306 <stat+0x36>
 2e8:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2ea:	85ca                	mv	a1,s2
 2ec:	16c000ef          	jal	ra,458 <fstat>
 2f0:	892a                	mv	s2,a0
  close(fd);
 2f2:	8526                	mv	a0,s1
 2f4:	134000ef          	jal	ra,428 <close>
  return r;
}
 2f8:	854a                	mv	a0,s2
 2fa:	60e2                	ld	ra,24(sp)
 2fc:	6442                	ld	s0,16(sp)
 2fe:	64a2                	ld	s1,8(sp)
 300:	6902                	ld	s2,0(sp)
 302:	6105                	addi	sp,sp,32
 304:	8082                	ret
    return -1;
 306:	597d                	li	s2,-1
 308:	bfc5                	j	2f8 <stat+0x28>

000000000000030a <atoi>:

int
atoi(const char *s)
{
 30a:	1141                	addi	sp,sp,-16
 30c:	e422                	sd	s0,8(sp)
 30e:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 310:	00054683          	lbu	a3,0(a0)
 314:	fd06879b          	addiw	a5,a3,-48
 318:	0ff7f793          	zext.b	a5,a5
 31c:	4625                	li	a2,9
 31e:	02f66863          	bltu	a2,a5,34e <atoi+0x44>
 322:	872a                	mv	a4,a0
  n = 0;
 324:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 326:	0705                	addi	a4,a4,1
 328:	0025179b          	slliw	a5,a0,0x2
 32c:	9fa9                	addw	a5,a5,a0
 32e:	0017979b          	slliw	a5,a5,0x1
 332:	9fb5                	addw	a5,a5,a3
 334:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 338:	00074683          	lbu	a3,0(a4)
 33c:	fd06879b          	addiw	a5,a3,-48
 340:	0ff7f793          	zext.b	a5,a5
 344:	fef671e3          	bgeu	a2,a5,326 <atoi+0x1c>
  return n;
}
 348:	6422                	ld	s0,8(sp)
 34a:	0141                	addi	sp,sp,16
 34c:	8082                	ret
  n = 0;
 34e:	4501                	li	a0,0
 350:	bfe5                	j	348 <atoi+0x3e>

0000000000000352 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 352:	1141                	addi	sp,sp,-16
 354:	e422                	sd	s0,8(sp)
 356:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 358:	02b57463          	bgeu	a0,a1,380 <memmove+0x2e>
    while(n-- > 0)
 35c:	00c05f63          	blez	a2,37a <memmove+0x28>
 360:	1602                	slli	a2,a2,0x20
 362:	9201                	srli	a2,a2,0x20
 364:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 368:	872a                	mv	a4,a0
      *dst++ = *src++;
 36a:	0585                	addi	a1,a1,1
 36c:	0705                	addi	a4,a4,1
 36e:	fff5c683          	lbu	a3,-1(a1)
 372:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 376:	fee79ae3          	bne	a5,a4,36a <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 37a:	6422                	ld	s0,8(sp)
 37c:	0141                	addi	sp,sp,16
 37e:	8082                	ret
    dst += n;
 380:	00c50733          	add	a4,a0,a2
    src += n;
 384:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 386:	fec05ae3          	blez	a2,37a <memmove+0x28>
 38a:	fff6079b          	addiw	a5,a2,-1
 38e:	1782                	slli	a5,a5,0x20
 390:	9381                	srli	a5,a5,0x20
 392:	fff7c793          	not	a5,a5
 396:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 398:	15fd                	addi	a1,a1,-1
 39a:	177d                	addi	a4,a4,-1
 39c:	0005c683          	lbu	a3,0(a1)
 3a0:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 3a4:	fee79ae3          	bne	a5,a4,398 <memmove+0x46>
 3a8:	bfc9                	j	37a <memmove+0x28>

00000000000003aa <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 3aa:	1141                	addi	sp,sp,-16
 3ac:	e422                	sd	s0,8(sp)
 3ae:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 3b0:	ca05                	beqz	a2,3e0 <memcmp+0x36>
 3b2:	fff6069b          	addiw	a3,a2,-1
 3b6:	1682                	slli	a3,a3,0x20
 3b8:	9281                	srli	a3,a3,0x20
 3ba:	0685                	addi	a3,a3,1
 3bc:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 3be:	00054783          	lbu	a5,0(a0)
 3c2:	0005c703          	lbu	a4,0(a1)
 3c6:	00e79863          	bne	a5,a4,3d6 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 3ca:	0505                	addi	a0,a0,1
    p2++;
 3cc:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 3ce:	fed518e3          	bne	a0,a3,3be <memcmp+0x14>
  }
  return 0;
 3d2:	4501                	li	a0,0
 3d4:	a019                	j	3da <memcmp+0x30>
      return *p1 - *p2;
 3d6:	40e7853b          	subw	a0,a5,a4
}
 3da:	6422                	ld	s0,8(sp)
 3dc:	0141                	addi	sp,sp,16
 3de:	8082                	ret
  return 0;
 3e0:	4501                	li	a0,0
 3e2:	bfe5                	j	3da <memcmp+0x30>

00000000000003e4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3e4:	1141                	addi	sp,sp,-16
 3e6:	e406                	sd	ra,8(sp)
 3e8:	e022                	sd	s0,0(sp)
 3ea:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 3ec:	f67ff0ef          	jal	ra,352 <memmove>
}
 3f0:	60a2                	ld	ra,8(sp)
 3f2:	6402                	ld	s0,0(sp)
 3f4:	0141                	addi	sp,sp,16
 3f6:	8082                	ret

00000000000003f8 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3f8:	4885                	li	a7,1
 ecall
 3fa:	00000073          	ecall
 ret
 3fe:	8082                	ret

0000000000000400 <exit>:
.global exit
exit:
 li a7, SYS_exit
 400:	4889                	li	a7,2
 ecall
 402:	00000073          	ecall
 ret
 406:	8082                	ret

0000000000000408 <wait>:
.global wait
wait:
 li a7, SYS_wait
 408:	488d                	li	a7,3
 ecall
 40a:	00000073          	ecall
 ret
 40e:	8082                	ret

0000000000000410 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 410:	4891                	li	a7,4
 ecall
 412:	00000073          	ecall
 ret
 416:	8082                	ret

0000000000000418 <read>:
.global read
read:
 li a7, SYS_read
 418:	4895                	li	a7,5
 ecall
 41a:	00000073          	ecall
 ret
 41e:	8082                	ret

0000000000000420 <write>:
.global write
write:
 li a7, SYS_write
 420:	48c1                	li	a7,16
 ecall
 422:	00000073          	ecall
 ret
 426:	8082                	ret

0000000000000428 <close>:
.global close
close:
 li a7, SYS_close
 428:	48d5                	li	a7,21
 ecall
 42a:	00000073          	ecall
 ret
 42e:	8082                	ret

0000000000000430 <kill>:
.global kill
kill:
 li a7, SYS_kill
 430:	4899                	li	a7,6
 ecall
 432:	00000073          	ecall
 ret
 436:	8082                	ret

0000000000000438 <exec>:
.global exec
exec:
 li a7, SYS_exec
 438:	489d                	li	a7,7
 ecall
 43a:	00000073          	ecall
 ret
 43e:	8082                	ret

0000000000000440 <open>:
.global open
open:
 li a7, SYS_open
 440:	48bd                	li	a7,15
 ecall
 442:	00000073          	ecall
 ret
 446:	8082                	ret

0000000000000448 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 448:	48c5                	li	a7,17
 ecall
 44a:	00000073          	ecall
 ret
 44e:	8082                	ret

0000000000000450 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 450:	48c9                	li	a7,18
 ecall
 452:	00000073          	ecall
 ret
 456:	8082                	ret

0000000000000458 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 458:	48a1                	li	a7,8
 ecall
 45a:	00000073          	ecall
 ret
 45e:	8082                	ret

0000000000000460 <link>:
.global link
link:
 li a7, SYS_link
 460:	48cd                	li	a7,19
 ecall
 462:	00000073          	ecall
 ret
 466:	8082                	ret

0000000000000468 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 468:	48d1                	li	a7,20
 ecall
 46a:	00000073          	ecall
 ret
 46e:	8082                	ret

0000000000000470 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 470:	48a5                	li	a7,9
 ecall
 472:	00000073          	ecall
 ret
 476:	8082                	ret

0000000000000478 <dup>:
.global dup
dup:
 li a7, SYS_dup
 478:	48a9                	li	a7,10
 ecall
 47a:	00000073          	ecall
 ret
 47e:	8082                	ret

0000000000000480 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 480:	48ad                	li	a7,11
 ecall
 482:	00000073          	ecall
 ret
 486:	8082                	ret

0000000000000488 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 488:	48b1                	li	a7,12
 ecall
 48a:	00000073          	ecall
 ret
 48e:	8082                	ret

0000000000000490 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 490:	48b5                	li	a7,13
 ecall
 492:	00000073          	ecall
 ret
 496:	8082                	ret

0000000000000498 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 498:	48b9                	li	a7,14
 ecall
 49a:	00000073          	ecall
 ret
 49e:	8082                	ret

00000000000004a0 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4a0:	1101                	addi	sp,sp,-32
 4a2:	ec06                	sd	ra,24(sp)
 4a4:	e822                	sd	s0,16(sp)
 4a6:	1000                	addi	s0,sp,32
 4a8:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4ac:	4605                	li	a2,1
 4ae:	fef40593          	addi	a1,s0,-17
 4b2:	f6fff0ef          	jal	ra,420 <write>
}
 4b6:	60e2                	ld	ra,24(sp)
 4b8:	6442                	ld	s0,16(sp)
 4ba:	6105                	addi	sp,sp,32
 4bc:	8082                	ret

00000000000004be <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4be:	7139                	addi	sp,sp,-64
 4c0:	fc06                	sd	ra,56(sp)
 4c2:	f822                	sd	s0,48(sp)
 4c4:	f426                	sd	s1,40(sp)
 4c6:	f04a                	sd	s2,32(sp)
 4c8:	ec4e                	sd	s3,24(sp)
 4ca:	0080                	addi	s0,sp,64
 4cc:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4ce:	c299                	beqz	a3,4d4 <printint+0x16>
 4d0:	0805c763          	bltz	a1,55e <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 4d4:	2581                	sext.w	a1,a1
  neg = 0;
 4d6:	4881                	li	a7,0
 4d8:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 4dc:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4de:	2601                	sext.w	a2,a2
 4e0:	00000517          	auipc	a0,0x0
 4e4:	59050513          	addi	a0,a0,1424 # a70 <digits>
 4e8:	883a                	mv	a6,a4
 4ea:	2705                	addiw	a4,a4,1
 4ec:	02c5f7bb          	remuw	a5,a1,a2
 4f0:	1782                	slli	a5,a5,0x20
 4f2:	9381                	srli	a5,a5,0x20
 4f4:	97aa                	add	a5,a5,a0
 4f6:	0007c783          	lbu	a5,0(a5)
 4fa:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4fe:	0005879b          	sext.w	a5,a1
 502:	02c5d5bb          	divuw	a1,a1,a2
 506:	0685                	addi	a3,a3,1
 508:	fec7f0e3          	bgeu	a5,a2,4e8 <printint+0x2a>
  if(neg)
 50c:	00088c63          	beqz	a7,524 <printint+0x66>
    buf[i++] = '-';
 510:	fd070793          	addi	a5,a4,-48
 514:	00878733          	add	a4,a5,s0
 518:	02d00793          	li	a5,45
 51c:	fef70823          	sb	a5,-16(a4)
 520:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 524:	02e05663          	blez	a4,550 <printint+0x92>
 528:	fc040793          	addi	a5,s0,-64
 52c:	00e78933          	add	s2,a5,a4
 530:	fff78993          	addi	s3,a5,-1
 534:	99ba                	add	s3,s3,a4
 536:	377d                	addiw	a4,a4,-1
 538:	1702                	slli	a4,a4,0x20
 53a:	9301                	srli	a4,a4,0x20
 53c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 540:	fff94583          	lbu	a1,-1(s2)
 544:	8526                	mv	a0,s1
 546:	f5bff0ef          	jal	ra,4a0 <putc>
  while(--i >= 0)
 54a:	197d                	addi	s2,s2,-1
 54c:	ff391ae3          	bne	s2,s3,540 <printint+0x82>
}
 550:	70e2                	ld	ra,56(sp)
 552:	7442                	ld	s0,48(sp)
 554:	74a2                	ld	s1,40(sp)
 556:	7902                	ld	s2,32(sp)
 558:	69e2                	ld	s3,24(sp)
 55a:	6121                	addi	sp,sp,64
 55c:	8082                	ret
    x = -xx;
 55e:	40b005bb          	negw	a1,a1
    neg = 1;
 562:	4885                	li	a7,1
    x = -xx;
 564:	bf95                	j	4d8 <printint+0x1a>

0000000000000566 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 566:	7119                	addi	sp,sp,-128
 568:	fc86                	sd	ra,120(sp)
 56a:	f8a2                	sd	s0,112(sp)
 56c:	f4a6                	sd	s1,104(sp)
 56e:	f0ca                	sd	s2,96(sp)
 570:	ecce                	sd	s3,88(sp)
 572:	e8d2                	sd	s4,80(sp)
 574:	e4d6                	sd	s5,72(sp)
 576:	e0da                	sd	s6,64(sp)
 578:	fc5e                	sd	s7,56(sp)
 57a:	f862                	sd	s8,48(sp)
 57c:	f466                	sd	s9,40(sp)
 57e:	f06a                	sd	s10,32(sp)
 580:	ec6e                	sd	s11,24(sp)
 582:	0100                	addi	s0,sp,128
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 584:	0005c903          	lbu	s2,0(a1)
 588:	22090e63          	beqz	s2,7c4 <vprintf+0x25e>
 58c:	8b2a                	mv	s6,a0
 58e:	8a2e                	mv	s4,a1
 590:	8bb2                	mv	s7,a2
  state = 0;
 592:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 594:	4481                	li	s1,0
 596:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 598:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 59c:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 5a0:	06c00d13          	li	s10,108
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 5a4:	07500d93          	li	s11,117
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5a8:	00000c97          	auipc	s9,0x0
 5ac:	4c8c8c93          	addi	s9,s9,1224 # a70 <digits>
 5b0:	a005                	j	5d0 <vprintf+0x6a>
        putc(fd, c0);
 5b2:	85ca                	mv	a1,s2
 5b4:	855a                	mv	a0,s6
 5b6:	eebff0ef          	jal	ra,4a0 <putc>
 5ba:	a019                	j	5c0 <vprintf+0x5a>
    } else if(state == '%'){
 5bc:	03598263          	beq	s3,s5,5e0 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 5c0:	2485                	addiw	s1,s1,1
 5c2:	8726                	mv	a4,s1
 5c4:	009a07b3          	add	a5,s4,s1
 5c8:	0007c903          	lbu	s2,0(a5)
 5cc:	1e090c63          	beqz	s2,7c4 <vprintf+0x25e>
    c0 = fmt[i] & 0xff;
 5d0:	0009079b          	sext.w	a5,s2
    if(state == 0){
 5d4:	fe0994e3          	bnez	s3,5bc <vprintf+0x56>
      if(c0 == '%'){
 5d8:	fd579de3          	bne	a5,s5,5b2 <vprintf+0x4c>
        state = '%';
 5dc:	89be                	mv	s3,a5
 5de:	b7cd                	j	5c0 <vprintf+0x5a>
      if(c0) c1 = fmt[i+1] & 0xff;
 5e0:	cfa5                	beqz	a5,658 <vprintf+0xf2>
 5e2:	00ea06b3          	add	a3,s4,a4
 5e6:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 5ea:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 5ec:	c681                	beqz	a3,5f4 <vprintf+0x8e>
 5ee:	9752                	add	a4,a4,s4
 5f0:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 5f4:	03878a63          	beq	a5,s8,628 <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 5f8:	05a78463          	beq	a5,s10,640 <vprintf+0xda>
      } else if(c0 == 'u'){
 5fc:	0db78763          	beq	a5,s11,6ca <vprintf+0x164>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 600:	07800713          	li	a4,120
 604:	10e78963          	beq	a5,a4,716 <vprintf+0x1b0>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 608:	07000713          	li	a4,112
 60c:	12e78e63          	beq	a5,a4,748 <vprintf+0x1e2>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 610:	07300713          	li	a4,115
 614:	16e78b63          	beq	a5,a4,78a <vprintf+0x224>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 618:	05579063          	bne	a5,s5,658 <vprintf+0xf2>
        putc(fd, '%');
 61c:	85d6                	mv	a1,s5
 61e:	855a                	mv	a0,s6
 620:	e81ff0ef          	jal	ra,4a0 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 624:	4981                	li	s3,0
 626:	bf69                	j	5c0 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 1);
 628:	008b8913          	addi	s2,s7,8
 62c:	4685                	li	a3,1
 62e:	4629                	li	a2,10
 630:	000ba583          	lw	a1,0(s7)
 634:	855a                	mv	a0,s6
 636:	e89ff0ef          	jal	ra,4be <printint>
 63a:	8bca                	mv	s7,s2
      state = 0;
 63c:	4981                	li	s3,0
 63e:	b749                	j	5c0 <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'd'){
 640:	03868663          	beq	a3,s8,66c <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 644:	05a68163          	beq	a3,s10,686 <vprintf+0x120>
      } else if(c0 == 'l' && c1 == 'u'){
 648:	09b68d63          	beq	a3,s11,6e2 <vprintf+0x17c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 64c:	03a68f63          	beq	a3,s10,68a <vprintf+0x124>
      } else if(c0 == 'l' && c1 == 'x'){
 650:	07800793          	li	a5,120
 654:	0cf68d63          	beq	a3,a5,72e <vprintf+0x1c8>
        putc(fd, '%');
 658:	85d6                	mv	a1,s5
 65a:	855a                	mv	a0,s6
 65c:	e45ff0ef          	jal	ra,4a0 <putc>
        putc(fd, c0);
 660:	85ca                	mv	a1,s2
 662:	855a                	mv	a0,s6
 664:	e3dff0ef          	jal	ra,4a0 <putc>
      state = 0;
 668:	4981                	li	s3,0
 66a:	bf99                	j	5c0 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 66c:	008b8913          	addi	s2,s7,8
 670:	4685                	li	a3,1
 672:	4629                	li	a2,10
 674:	000ba583          	lw	a1,0(s7)
 678:	855a                	mv	a0,s6
 67a:	e45ff0ef          	jal	ra,4be <printint>
        i += 1;
 67e:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 680:	8bca                	mv	s7,s2
      state = 0;
 682:	4981                	li	s3,0
        i += 1;
 684:	bf35                	j	5c0 <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 686:	03860563          	beq	a2,s8,6b0 <vprintf+0x14a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 68a:	07b60963          	beq	a2,s11,6fc <vprintf+0x196>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 68e:	07800793          	li	a5,120
 692:	fcf613e3          	bne	a2,a5,658 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 696:	008b8913          	addi	s2,s7,8
 69a:	4681                	li	a3,0
 69c:	4641                	li	a2,16
 69e:	000ba583          	lw	a1,0(s7)
 6a2:	855a                	mv	a0,s6
 6a4:	e1bff0ef          	jal	ra,4be <printint>
        i += 2;
 6a8:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 6aa:	8bca                	mv	s7,s2
      state = 0;
 6ac:	4981                	li	s3,0
        i += 2;
 6ae:	bf09                	j	5c0 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6b0:	008b8913          	addi	s2,s7,8
 6b4:	4685                	li	a3,1
 6b6:	4629                	li	a2,10
 6b8:	000ba583          	lw	a1,0(s7)
 6bc:	855a                	mv	a0,s6
 6be:	e01ff0ef          	jal	ra,4be <printint>
        i += 2;
 6c2:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 6c4:	8bca                	mv	s7,s2
      state = 0;
 6c6:	4981                	li	s3,0
        i += 2;
 6c8:	bde5                	j	5c0 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 0);
 6ca:	008b8913          	addi	s2,s7,8
 6ce:	4681                	li	a3,0
 6d0:	4629                	li	a2,10
 6d2:	000ba583          	lw	a1,0(s7)
 6d6:	855a                	mv	a0,s6
 6d8:	de7ff0ef          	jal	ra,4be <printint>
 6dc:	8bca                	mv	s7,s2
      state = 0;
 6de:	4981                	li	s3,0
 6e0:	b5c5                	j	5c0 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6e2:	008b8913          	addi	s2,s7,8
 6e6:	4681                	li	a3,0
 6e8:	4629                	li	a2,10
 6ea:	000ba583          	lw	a1,0(s7)
 6ee:	855a                	mv	a0,s6
 6f0:	dcfff0ef          	jal	ra,4be <printint>
        i += 1;
 6f4:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 6f6:	8bca                	mv	s7,s2
      state = 0;
 6f8:	4981                	li	s3,0
        i += 1;
 6fa:	b5d9                	j	5c0 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6fc:	008b8913          	addi	s2,s7,8
 700:	4681                	li	a3,0
 702:	4629                	li	a2,10
 704:	000ba583          	lw	a1,0(s7)
 708:	855a                	mv	a0,s6
 70a:	db5ff0ef          	jal	ra,4be <printint>
        i += 2;
 70e:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 710:	8bca                	mv	s7,s2
      state = 0;
 712:	4981                	li	s3,0
        i += 2;
 714:	b575                	j	5c0 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 16, 0);
 716:	008b8913          	addi	s2,s7,8
 71a:	4681                	li	a3,0
 71c:	4641                	li	a2,16
 71e:	000ba583          	lw	a1,0(s7)
 722:	855a                	mv	a0,s6
 724:	d9bff0ef          	jal	ra,4be <printint>
 728:	8bca                	mv	s7,s2
      state = 0;
 72a:	4981                	li	s3,0
 72c:	bd51                	j	5c0 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 72e:	008b8913          	addi	s2,s7,8
 732:	4681                	li	a3,0
 734:	4641                	li	a2,16
 736:	000ba583          	lw	a1,0(s7)
 73a:	855a                	mv	a0,s6
 73c:	d83ff0ef          	jal	ra,4be <printint>
        i += 1;
 740:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 742:	8bca                	mv	s7,s2
      state = 0;
 744:	4981                	li	s3,0
        i += 1;
 746:	bdad                	j	5c0 <vprintf+0x5a>
        printptr(fd, va_arg(ap, uint64));
 748:	008b8793          	addi	a5,s7,8
 74c:	f8f43423          	sd	a5,-120(s0)
 750:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 754:	03000593          	li	a1,48
 758:	855a                	mv	a0,s6
 75a:	d47ff0ef          	jal	ra,4a0 <putc>
  putc(fd, 'x');
 75e:	07800593          	li	a1,120
 762:	855a                	mv	a0,s6
 764:	d3dff0ef          	jal	ra,4a0 <putc>
 768:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 76a:	03c9d793          	srli	a5,s3,0x3c
 76e:	97e6                	add	a5,a5,s9
 770:	0007c583          	lbu	a1,0(a5)
 774:	855a                	mv	a0,s6
 776:	d2bff0ef          	jal	ra,4a0 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 77a:	0992                	slli	s3,s3,0x4
 77c:	397d                	addiw	s2,s2,-1
 77e:	fe0916e3          	bnez	s2,76a <vprintf+0x204>
        printptr(fd, va_arg(ap, uint64));
 782:	f8843b83          	ld	s7,-120(s0)
      state = 0;
 786:	4981                	li	s3,0
 788:	bd25                	j	5c0 <vprintf+0x5a>
        if((s = va_arg(ap, char*)) == 0)
 78a:	008b8993          	addi	s3,s7,8
 78e:	000bb903          	ld	s2,0(s7)
 792:	00090f63          	beqz	s2,7b0 <vprintf+0x24a>
        for(; *s; s++)
 796:	00094583          	lbu	a1,0(s2)
 79a:	c195                	beqz	a1,7be <vprintf+0x258>
          putc(fd, *s);
 79c:	855a                	mv	a0,s6
 79e:	d03ff0ef          	jal	ra,4a0 <putc>
        for(; *s; s++)
 7a2:	0905                	addi	s2,s2,1
 7a4:	00094583          	lbu	a1,0(s2)
 7a8:	f9f5                	bnez	a1,79c <vprintf+0x236>
        if((s = va_arg(ap, char*)) == 0)
 7aa:	8bce                	mv	s7,s3
      state = 0;
 7ac:	4981                	li	s3,0
 7ae:	bd09                	j	5c0 <vprintf+0x5a>
          s = "(null)";
 7b0:	00000917          	auipc	s2,0x0
 7b4:	2b890913          	addi	s2,s2,696 # a68 <malloc+0x1a8>
        for(; *s; s++)
 7b8:	02800593          	li	a1,40
 7bc:	b7c5                	j	79c <vprintf+0x236>
        if((s = va_arg(ap, char*)) == 0)
 7be:	8bce                	mv	s7,s3
      state = 0;
 7c0:	4981                	li	s3,0
 7c2:	bbfd                	j	5c0 <vprintf+0x5a>
    }
  }
}
 7c4:	70e6                	ld	ra,120(sp)
 7c6:	7446                	ld	s0,112(sp)
 7c8:	74a6                	ld	s1,104(sp)
 7ca:	7906                	ld	s2,96(sp)
 7cc:	69e6                	ld	s3,88(sp)
 7ce:	6a46                	ld	s4,80(sp)
 7d0:	6aa6                	ld	s5,72(sp)
 7d2:	6b06                	ld	s6,64(sp)
 7d4:	7be2                	ld	s7,56(sp)
 7d6:	7c42                	ld	s8,48(sp)
 7d8:	7ca2                	ld	s9,40(sp)
 7da:	7d02                	ld	s10,32(sp)
 7dc:	6de2                	ld	s11,24(sp)
 7de:	6109                	addi	sp,sp,128
 7e0:	8082                	ret

00000000000007e2 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7e2:	715d                	addi	sp,sp,-80
 7e4:	ec06                	sd	ra,24(sp)
 7e6:	e822                	sd	s0,16(sp)
 7e8:	1000                	addi	s0,sp,32
 7ea:	e010                	sd	a2,0(s0)
 7ec:	e414                	sd	a3,8(s0)
 7ee:	e818                	sd	a4,16(s0)
 7f0:	ec1c                	sd	a5,24(s0)
 7f2:	03043023          	sd	a6,32(s0)
 7f6:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7fa:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7fe:	8622                	mv	a2,s0
 800:	d67ff0ef          	jal	ra,566 <vprintf>
}
 804:	60e2                	ld	ra,24(sp)
 806:	6442                	ld	s0,16(sp)
 808:	6161                	addi	sp,sp,80
 80a:	8082                	ret

000000000000080c <printf>:

void
printf(const char *fmt, ...)
{
 80c:	711d                	addi	sp,sp,-96
 80e:	ec06                	sd	ra,24(sp)
 810:	e822                	sd	s0,16(sp)
 812:	1000                	addi	s0,sp,32
 814:	e40c                	sd	a1,8(s0)
 816:	e810                	sd	a2,16(s0)
 818:	ec14                	sd	a3,24(s0)
 81a:	f018                	sd	a4,32(s0)
 81c:	f41c                	sd	a5,40(s0)
 81e:	03043823          	sd	a6,48(s0)
 822:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 826:	00840613          	addi	a2,s0,8
 82a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 82e:	85aa                	mv	a1,a0
 830:	4505                	li	a0,1
 832:	d35ff0ef          	jal	ra,566 <vprintf>
}
 836:	60e2                	ld	ra,24(sp)
 838:	6442                	ld	s0,16(sp)
 83a:	6125                	addi	sp,sp,96
 83c:	8082                	ret

000000000000083e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 83e:	1141                	addi	sp,sp,-16
 840:	e422                	sd	s0,8(sp)
 842:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 844:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 848:	00000797          	auipc	a5,0x0
 84c:	7d87b783          	ld	a5,2008(a5) # 1020 <freep>
 850:	a02d                	j	87a <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 852:	4618                	lw	a4,8(a2)
 854:	9f2d                	addw	a4,a4,a1
 856:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 85a:	6398                	ld	a4,0(a5)
 85c:	6310                	ld	a2,0(a4)
 85e:	a83d                	j	89c <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 860:	ff852703          	lw	a4,-8(a0)
 864:	9f31                	addw	a4,a4,a2
 866:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 868:	ff053683          	ld	a3,-16(a0)
 86c:	a091                	j	8b0 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 86e:	6398                	ld	a4,0(a5)
 870:	00e7e463          	bltu	a5,a4,878 <free+0x3a>
 874:	00e6ea63          	bltu	a3,a4,888 <free+0x4a>
{
 878:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 87a:	fed7fae3          	bgeu	a5,a3,86e <free+0x30>
 87e:	6398                	ld	a4,0(a5)
 880:	00e6e463          	bltu	a3,a4,888 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 884:	fee7eae3          	bltu	a5,a4,878 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 888:	ff852583          	lw	a1,-8(a0)
 88c:	6390                	ld	a2,0(a5)
 88e:	02059813          	slli	a6,a1,0x20
 892:	01c85713          	srli	a4,a6,0x1c
 896:	9736                	add	a4,a4,a3
 898:	fae60de3          	beq	a2,a4,852 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 89c:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 8a0:	4790                	lw	a2,8(a5)
 8a2:	02061593          	slli	a1,a2,0x20
 8a6:	01c5d713          	srli	a4,a1,0x1c
 8aa:	973e                	add	a4,a4,a5
 8ac:	fae68ae3          	beq	a3,a4,860 <free+0x22>
    p->s.ptr = bp->s.ptr;
 8b0:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 8b2:	00000717          	auipc	a4,0x0
 8b6:	76f73723          	sd	a5,1902(a4) # 1020 <freep>
}
 8ba:	6422                	ld	s0,8(sp)
 8bc:	0141                	addi	sp,sp,16
 8be:	8082                	ret

00000000000008c0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8c0:	7139                	addi	sp,sp,-64
 8c2:	fc06                	sd	ra,56(sp)
 8c4:	f822                	sd	s0,48(sp)
 8c6:	f426                	sd	s1,40(sp)
 8c8:	f04a                	sd	s2,32(sp)
 8ca:	ec4e                	sd	s3,24(sp)
 8cc:	e852                	sd	s4,16(sp)
 8ce:	e456                	sd	s5,8(sp)
 8d0:	e05a                	sd	s6,0(sp)
 8d2:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8d4:	02051493          	slli	s1,a0,0x20
 8d8:	9081                	srli	s1,s1,0x20
 8da:	04bd                	addi	s1,s1,15
 8dc:	8091                	srli	s1,s1,0x4
 8de:	0014899b          	addiw	s3,s1,1
 8e2:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 8e4:	00000517          	auipc	a0,0x0
 8e8:	73c53503          	ld	a0,1852(a0) # 1020 <freep>
 8ec:	c515                	beqz	a0,918 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8ee:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8f0:	4798                	lw	a4,8(a5)
 8f2:	02977f63          	bgeu	a4,s1,930 <malloc+0x70>
 8f6:	8a4e                	mv	s4,s3
 8f8:	0009871b          	sext.w	a4,s3
 8fc:	6685                	lui	a3,0x1
 8fe:	00d77363          	bgeu	a4,a3,904 <malloc+0x44>
 902:	6a05                	lui	s4,0x1
 904:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 908:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 90c:	00000917          	auipc	s2,0x0
 910:	71490913          	addi	s2,s2,1812 # 1020 <freep>
  if(p == (char*)-1)
 914:	5afd                	li	s5,-1
 916:	a885                	j	986 <malloc+0xc6>
    base.s.ptr = freep = prevp = &base;
 918:	00000797          	auipc	a5,0x0
 91c:	75878793          	addi	a5,a5,1880 # 1070 <base>
 920:	00000717          	auipc	a4,0x0
 924:	70f73023          	sd	a5,1792(a4) # 1020 <freep>
 928:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 92a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 92e:	b7e1                	j	8f6 <malloc+0x36>
      if(p->s.size == nunits)
 930:	02e48c63          	beq	s1,a4,968 <malloc+0xa8>
        p->s.size -= nunits;
 934:	4137073b          	subw	a4,a4,s3
 938:	c798                	sw	a4,8(a5)
        p += p->s.size;
 93a:	02071693          	slli	a3,a4,0x20
 93e:	01c6d713          	srli	a4,a3,0x1c
 942:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 944:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 948:	00000717          	auipc	a4,0x0
 94c:	6ca73c23          	sd	a0,1752(a4) # 1020 <freep>
      return (void*)(p + 1);
 950:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 954:	70e2                	ld	ra,56(sp)
 956:	7442                	ld	s0,48(sp)
 958:	74a2                	ld	s1,40(sp)
 95a:	7902                	ld	s2,32(sp)
 95c:	69e2                	ld	s3,24(sp)
 95e:	6a42                	ld	s4,16(sp)
 960:	6aa2                	ld	s5,8(sp)
 962:	6b02                	ld	s6,0(sp)
 964:	6121                	addi	sp,sp,64
 966:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 968:	6398                	ld	a4,0(a5)
 96a:	e118                	sd	a4,0(a0)
 96c:	bff1                	j	948 <malloc+0x88>
  hp->s.size = nu;
 96e:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 972:	0541                	addi	a0,a0,16
 974:	ecbff0ef          	jal	ra,83e <free>
  return freep;
 978:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 97c:	dd61                	beqz	a0,954 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 97e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 980:	4798                	lw	a4,8(a5)
 982:	fa9777e3          	bgeu	a4,s1,930 <malloc+0x70>
    if(p == freep)
 986:	00093703          	ld	a4,0(s2)
 98a:	853e                	mv	a0,a5
 98c:	fef719e3          	bne	a4,a5,97e <malloc+0xbe>
  p = sbrk(nu * sizeof(Header));
 990:	8552                	mv	a0,s4
 992:	af7ff0ef          	jal	ra,488 <sbrk>
  if(p == (char*)-1)
 996:	fd551ce3          	bne	a0,s5,96e <malloc+0xae>
        return 0;
 99a:	4501                	li	a0,0
 99c:	bf65                	j	954 <malloc+0x94>
