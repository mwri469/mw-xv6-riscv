
user/_sh:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <getcmd>:
  exit(0);
}

int
getcmd(char *buf, int nbuf)
{
       0:	1101                	addi	sp,sp,-32
       2:	ec06                	sd	ra,24(sp)
       4:	e822                	sd	s0,16(sp)
       6:	e426                	sd	s1,8(sp)
       8:	e04a                	sd	s2,0(sp)
       a:	1000                	addi	s0,sp,32
       c:	84aa                	mv	s1,a0
       e:	892e                	mv	s2,a1
  write(2, "$ ", 2);
      10:	4609                	li	a2,2
      12:	00001597          	auipc	a1,0x1
      16:	17e58593          	addi	a1,a1,382 # 1190 <malloc+0xe0>
      1a:	4509                	li	a0,2
      1c:	3f5000ef          	jal	ra,c10 <write>
  memset(buf, 0, nbuf);
      20:	864a                	mv	a2,s2
      22:	4581                	li	a1,0
      24:	8526                	mv	a0,s1
      26:	1e5000ef          	jal	ra,a0a <memset>
  gets(buf, nbuf);
      2a:	85ca                	mv	a1,s2
      2c:	8526                	mv	a0,s1
      2e:	223000ef          	jal	ra,a50 <gets>
  if(buf[0] == 0) // EOF
      32:	0004c503          	lbu	a0,0(s1)
      36:	00153513          	seqz	a0,a0
    return -1;
  return 0;
}
      3a:	40a00533          	neg	a0,a0
      3e:	60e2                	ld	ra,24(sp)
      40:	6442                	ld	s0,16(sp)
      42:	64a2                	ld	s1,8(sp)
      44:	6902                	ld	s2,0(sp)
      46:	6105                	addi	sp,sp,32
      48:	8082                	ret

000000000000004a <panic>:
  exit(0);
}

void
panic(char *s)
{
      4a:	1141                	addi	sp,sp,-16
      4c:	e406                	sd	ra,8(sp)
      4e:	e022                	sd	s0,0(sp)
      50:	0800                	addi	s0,sp,16
      52:	862a                	mv	a2,a0
  fprintf(2, "%s\n", s);
      54:	00001597          	auipc	a1,0x1
      58:	14458593          	addi	a1,a1,324 # 1198 <malloc+0xe8>
      5c:	4509                	li	a0,2
      5e:	775000ef          	jal	ra,fd2 <fprintf>
  exit(1);
      62:	4505                	li	a0,1
      64:	38d000ef          	jal	ra,bf0 <exit>

0000000000000068 <fork1>:
}

int
fork1(void)
{
      68:	1141                	addi	sp,sp,-16
      6a:	e406                	sd	ra,8(sp)
      6c:	e022                	sd	s0,0(sp)
      6e:	0800                	addi	s0,sp,16
  int pid;

  pid = fork();
      70:	379000ef          	jal	ra,be8 <fork>
  if(pid == -1)
      74:	57fd                	li	a5,-1
      76:	00f50663          	beq	a0,a5,82 <fork1+0x1a>
    panic("fork");
  return pid;
}
      7a:	60a2                	ld	ra,8(sp)
      7c:	6402                	ld	s0,0(sp)
      7e:	0141                	addi	sp,sp,16
      80:	8082                	ret
    panic("fork");
      82:	00001517          	auipc	a0,0x1
      86:	11e50513          	addi	a0,a0,286 # 11a0 <malloc+0xf0>
      8a:	fc1ff0ef          	jal	ra,4a <panic>

000000000000008e <runcmd>:
{
      8e:	7179                	addi	sp,sp,-48
      90:	f406                	sd	ra,40(sp)
      92:	f022                	sd	s0,32(sp)
      94:	ec26                	sd	s1,24(sp)
      96:	1800                	addi	s0,sp,48
  if(cmd == 0)
      98:	c10d                	beqz	a0,ba <runcmd+0x2c>
      9a:	84aa                	mv	s1,a0
  switch(cmd->type){
      9c:	4118                	lw	a4,0(a0)
      9e:	4795                	li	a5,5
      a0:	02e7e063          	bltu	a5,a4,c0 <runcmd+0x32>
      a4:	00056783          	lwu	a5,0(a0)
      a8:	078a                	slli	a5,a5,0x2
      aa:	00001717          	auipc	a4,0x1
      ae:	1f670713          	addi	a4,a4,502 # 12a0 <malloc+0x1f0>
      b2:	97ba                	add	a5,a5,a4
      b4:	439c                	lw	a5,0(a5)
      b6:	97ba                	add	a5,a5,a4
      b8:	8782                	jr	a5
    exit(1);
      ba:	4505                	li	a0,1
      bc:	335000ef          	jal	ra,bf0 <exit>
    panic("runcmd");
      c0:	00001517          	auipc	a0,0x1
      c4:	0e850513          	addi	a0,a0,232 # 11a8 <malloc+0xf8>
      c8:	f83ff0ef          	jal	ra,4a <panic>
    if(ecmd->argv[0] == 0)
      cc:	6508                	ld	a0,8(a0)
      ce:	c105                	beqz	a0,ee <runcmd+0x60>
    exec(ecmd->argv[0], ecmd->argv);
      d0:	00848593          	addi	a1,s1,8
      d4:	355000ef          	jal	ra,c28 <exec>
    fprintf(2, "exec %s failed\n", ecmd->argv[0]);
      d8:	6490                	ld	a2,8(s1)
      da:	00001597          	auipc	a1,0x1
      de:	0d658593          	addi	a1,a1,214 # 11b0 <malloc+0x100>
      e2:	4509                	li	a0,2
      e4:	6ef000ef          	jal	ra,fd2 <fprintf>
  exit(0);
      e8:	4501                	li	a0,0
      ea:	307000ef          	jal	ra,bf0 <exit>
      exit(1);
      ee:	4505                	li	a0,1
      f0:	301000ef          	jal	ra,bf0 <exit>
    close(rcmd->fd);
      f4:	5148                	lw	a0,36(a0)
      f6:	323000ef          	jal	ra,c18 <close>
    if(open(rcmd->file, rcmd->mode) < 0){
      fa:	508c                	lw	a1,32(s1)
      fc:	6888                	ld	a0,16(s1)
      fe:	333000ef          	jal	ra,c30 <open>
     102:	00054563          	bltz	a0,10c <runcmd+0x7e>
    runcmd(rcmd->cmd);
     106:	6488                	ld	a0,8(s1)
     108:	f87ff0ef          	jal	ra,8e <runcmd>
      fprintf(2, "open %s failed\n", rcmd->file);
     10c:	6890                	ld	a2,16(s1)
     10e:	00001597          	auipc	a1,0x1
     112:	0b258593          	addi	a1,a1,178 # 11c0 <malloc+0x110>
     116:	4509                	li	a0,2
     118:	6bb000ef          	jal	ra,fd2 <fprintf>
      exit(1);
     11c:	4505                	li	a0,1
     11e:	2d3000ef          	jal	ra,bf0 <exit>
    if(fork1() == 0)
     122:	f47ff0ef          	jal	ra,68 <fork1>
     126:	e501                	bnez	a0,12e <runcmd+0xa0>
      runcmd(lcmd->left);
     128:	6488                	ld	a0,8(s1)
     12a:	f65ff0ef          	jal	ra,8e <runcmd>
    wait(0);
     12e:	4501                	li	a0,0
     130:	2c9000ef          	jal	ra,bf8 <wait>
    runcmd(lcmd->right);
     134:	6888                	ld	a0,16(s1)
     136:	f59ff0ef          	jal	ra,8e <runcmd>
    if(pipe(p) < 0)
     13a:	fd840513          	addi	a0,s0,-40
     13e:	2c3000ef          	jal	ra,c00 <pipe>
     142:	02054763          	bltz	a0,170 <runcmd+0xe2>
    if(fork1() == 0){
     146:	f23ff0ef          	jal	ra,68 <fork1>
     14a:	e90d                	bnez	a0,17c <runcmd+0xee>
      close(1);
     14c:	4505                	li	a0,1
     14e:	2cb000ef          	jal	ra,c18 <close>
      dup(p[1]);
     152:	fdc42503          	lw	a0,-36(s0)
     156:	313000ef          	jal	ra,c68 <dup>
      close(p[0]);
     15a:	fd842503          	lw	a0,-40(s0)
     15e:	2bb000ef          	jal	ra,c18 <close>
      close(p[1]);
     162:	fdc42503          	lw	a0,-36(s0)
     166:	2b3000ef          	jal	ra,c18 <close>
      runcmd(pcmd->left);
     16a:	6488                	ld	a0,8(s1)
     16c:	f23ff0ef          	jal	ra,8e <runcmd>
      panic("pipe");
     170:	00001517          	auipc	a0,0x1
     174:	06050513          	addi	a0,a0,96 # 11d0 <malloc+0x120>
     178:	ed3ff0ef          	jal	ra,4a <panic>
    if(fork1() == 0){
     17c:	eedff0ef          	jal	ra,68 <fork1>
     180:	e115                	bnez	a0,1a4 <runcmd+0x116>
      close(0);
     182:	297000ef          	jal	ra,c18 <close>
      dup(p[0]);
     186:	fd842503          	lw	a0,-40(s0)
     18a:	2df000ef          	jal	ra,c68 <dup>
      close(p[0]);
     18e:	fd842503          	lw	a0,-40(s0)
     192:	287000ef          	jal	ra,c18 <close>
      close(p[1]);
     196:	fdc42503          	lw	a0,-36(s0)
     19a:	27f000ef          	jal	ra,c18 <close>
      runcmd(pcmd->right);
     19e:	6888                	ld	a0,16(s1)
     1a0:	eefff0ef          	jal	ra,8e <runcmd>
    close(p[0]);
     1a4:	fd842503          	lw	a0,-40(s0)
     1a8:	271000ef          	jal	ra,c18 <close>
    close(p[1]);
     1ac:	fdc42503          	lw	a0,-36(s0)
     1b0:	269000ef          	jal	ra,c18 <close>
    wait(0);
     1b4:	4501                	li	a0,0
     1b6:	243000ef          	jal	ra,bf8 <wait>
    wait(0);
     1ba:	4501                	li	a0,0
     1bc:	23d000ef          	jal	ra,bf8 <wait>
    break;
     1c0:	b725                	j	e8 <runcmd+0x5a>
    if(fork1() == 0)
     1c2:	ea7ff0ef          	jal	ra,68 <fork1>
     1c6:	f20511e3          	bnez	a0,e8 <runcmd+0x5a>
      runcmd(bcmd->cmd);
     1ca:	6488                	ld	a0,8(s1)
     1cc:	ec3ff0ef          	jal	ra,8e <runcmd>

00000000000001d0 <execcmd>:
//PAGEBREAK!
// Constructors

struct cmd*
execcmd(void)
{
     1d0:	1101                	addi	sp,sp,-32
     1d2:	ec06                	sd	ra,24(sp)
     1d4:	e822                	sd	s0,16(sp)
     1d6:	e426                	sd	s1,8(sp)
     1d8:	1000                	addi	s0,sp,32
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     1da:	0a800513          	li	a0,168
     1de:	6d3000ef          	jal	ra,10b0 <malloc>
     1e2:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     1e4:	0a800613          	li	a2,168
     1e8:	4581                	li	a1,0
     1ea:	021000ef          	jal	ra,a0a <memset>
  cmd->type = EXEC;
     1ee:	4785                	li	a5,1
     1f0:	c09c                	sw	a5,0(s1)
  return (struct cmd*)cmd;
}
     1f2:	8526                	mv	a0,s1
     1f4:	60e2                	ld	ra,24(sp)
     1f6:	6442                	ld	s0,16(sp)
     1f8:	64a2                	ld	s1,8(sp)
     1fa:	6105                	addi	sp,sp,32
     1fc:	8082                	ret

00000000000001fe <redircmd>:

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
     1fe:	7139                	addi	sp,sp,-64
     200:	fc06                	sd	ra,56(sp)
     202:	f822                	sd	s0,48(sp)
     204:	f426                	sd	s1,40(sp)
     206:	f04a                	sd	s2,32(sp)
     208:	ec4e                	sd	s3,24(sp)
     20a:	e852                	sd	s4,16(sp)
     20c:	e456                	sd	s5,8(sp)
     20e:	e05a                	sd	s6,0(sp)
     210:	0080                	addi	s0,sp,64
     212:	8b2a                	mv	s6,a0
     214:	8aae                	mv	s5,a1
     216:	8a32                	mv	s4,a2
     218:	89b6                	mv	s3,a3
     21a:	893a                	mv	s2,a4
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     21c:	02800513          	li	a0,40
     220:	691000ef          	jal	ra,10b0 <malloc>
     224:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     226:	02800613          	li	a2,40
     22a:	4581                	li	a1,0
     22c:	7de000ef          	jal	ra,a0a <memset>
  cmd->type = REDIR;
     230:	4789                	li	a5,2
     232:	c09c                	sw	a5,0(s1)
  cmd->cmd = subcmd;
     234:	0164b423          	sd	s6,8(s1)
  cmd->file = file;
     238:	0154b823          	sd	s5,16(s1)
  cmd->efile = efile;
     23c:	0144bc23          	sd	s4,24(s1)
  cmd->mode = mode;
     240:	0334a023          	sw	s3,32(s1)
  cmd->fd = fd;
     244:	0324a223          	sw	s2,36(s1)
  return (struct cmd*)cmd;
}
     248:	8526                	mv	a0,s1
     24a:	70e2                	ld	ra,56(sp)
     24c:	7442                	ld	s0,48(sp)
     24e:	74a2                	ld	s1,40(sp)
     250:	7902                	ld	s2,32(sp)
     252:	69e2                	ld	s3,24(sp)
     254:	6a42                	ld	s4,16(sp)
     256:	6aa2                	ld	s5,8(sp)
     258:	6b02                	ld	s6,0(sp)
     25a:	6121                	addi	sp,sp,64
     25c:	8082                	ret

000000000000025e <pipecmd>:

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
     25e:	7179                	addi	sp,sp,-48
     260:	f406                	sd	ra,40(sp)
     262:	f022                	sd	s0,32(sp)
     264:	ec26                	sd	s1,24(sp)
     266:	e84a                	sd	s2,16(sp)
     268:	e44e                	sd	s3,8(sp)
     26a:	1800                	addi	s0,sp,48
     26c:	89aa                	mv	s3,a0
     26e:	892e                	mv	s2,a1
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     270:	4561                	li	a0,24
     272:	63f000ef          	jal	ra,10b0 <malloc>
     276:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     278:	4661                	li	a2,24
     27a:	4581                	li	a1,0
     27c:	78e000ef          	jal	ra,a0a <memset>
  cmd->type = PIPE;
     280:	478d                	li	a5,3
     282:	c09c                	sw	a5,0(s1)
  cmd->left = left;
     284:	0134b423          	sd	s3,8(s1)
  cmd->right = right;
     288:	0124b823          	sd	s2,16(s1)
  return (struct cmd*)cmd;
}
     28c:	8526                	mv	a0,s1
     28e:	70a2                	ld	ra,40(sp)
     290:	7402                	ld	s0,32(sp)
     292:	64e2                	ld	s1,24(sp)
     294:	6942                	ld	s2,16(sp)
     296:	69a2                	ld	s3,8(sp)
     298:	6145                	addi	sp,sp,48
     29a:	8082                	ret

000000000000029c <listcmd>:

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
     29c:	7179                	addi	sp,sp,-48
     29e:	f406                	sd	ra,40(sp)
     2a0:	f022                	sd	s0,32(sp)
     2a2:	ec26                	sd	s1,24(sp)
     2a4:	e84a                	sd	s2,16(sp)
     2a6:	e44e                	sd	s3,8(sp)
     2a8:	1800                	addi	s0,sp,48
     2aa:	89aa                	mv	s3,a0
     2ac:	892e                	mv	s2,a1
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     2ae:	4561                	li	a0,24
     2b0:	601000ef          	jal	ra,10b0 <malloc>
     2b4:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     2b6:	4661                	li	a2,24
     2b8:	4581                	li	a1,0
     2ba:	750000ef          	jal	ra,a0a <memset>
  cmd->type = LIST;
     2be:	4791                	li	a5,4
     2c0:	c09c                	sw	a5,0(s1)
  cmd->left = left;
     2c2:	0134b423          	sd	s3,8(s1)
  cmd->right = right;
     2c6:	0124b823          	sd	s2,16(s1)
  return (struct cmd*)cmd;
}
     2ca:	8526                	mv	a0,s1
     2cc:	70a2                	ld	ra,40(sp)
     2ce:	7402                	ld	s0,32(sp)
     2d0:	64e2                	ld	s1,24(sp)
     2d2:	6942                	ld	s2,16(sp)
     2d4:	69a2                	ld	s3,8(sp)
     2d6:	6145                	addi	sp,sp,48
     2d8:	8082                	ret

00000000000002da <backcmd>:

struct cmd*
backcmd(struct cmd *subcmd)
{
     2da:	1101                	addi	sp,sp,-32
     2dc:	ec06                	sd	ra,24(sp)
     2de:	e822                	sd	s0,16(sp)
     2e0:	e426                	sd	s1,8(sp)
     2e2:	e04a                	sd	s2,0(sp)
     2e4:	1000                	addi	s0,sp,32
     2e6:	892a                	mv	s2,a0
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     2e8:	4541                	li	a0,16
     2ea:	5c7000ef          	jal	ra,10b0 <malloc>
     2ee:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     2f0:	4641                	li	a2,16
     2f2:	4581                	li	a1,0
     2f4:	716000ef          	jal	ra,a0a <memset>
  cmd->type = BACK;
     2f8:	4795                	li	a5,5
     2fa:	c09c                	sw	a5,0(s1)
  cmd->cmd = subcmd;
     2fc:	0124b423          	sd	s2,8(s1)
  return (struct cmd*)cmd;
}
     300:	8526                	mv	a0,s1
     302:	60e2                	ld	ra,24(sp)
     304:	6442                	ld	s0,16(sp)
     306:	64a2                	ld	s1,8(sp)
     308:	6902                	ld	s2,0(sp)
     30a:	6105                	addi	sp,sp,32
     30c:	8082                	ret

000000000000030e <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
     30e:	7139                	addi	sp,sp,-64
     310:	fc06                	sd	ra,56(sp)
     312:	f822                	sd	s0,48(sp)
     314:	f426                	sd	s1,40(sp)
     316:	f04a                	sd	s2,32(sp)
     318:	ec4e                	sd	s3,24(sp)
     31a:	e852                	sd	s4,16(sp)
     31c:	e456                	sd	s5,8(sp)
     31e:	e05a                	sd	s6,0(sp)
     320:	0080                	addi	s0,sp,64
     322:	8a2a                	mv	s4,a0
     324:	892e                	mv	s2,a1
     326:	8ab2                	mv	s5,a2
     328:	8b36                	mv	s6,a3
  char *s;
  int ret;

  s = *ps;
     32a:	6104                	ld	s1,0(a0)
  while(s < es && strchr(whitespace, *s))
     32c:	00002997          	auipc	s3,0x2
     330:	cdc98993          	addi	s3,s3,-804 # 2008 <whitespace>
     334:	00b4fc63          	bgeu	s1,a1,34c <gettoken+0x3e>
     338:	0004c583          	lbu	a1,0(s1)
     33c:	854e                	mv	a0,s3
     33e:	6ee000ef          	jal	ra,a2c <strchr>
     342:	c509                	beqz	a0,34c <gettoken+0x3e>
    s++;
     344:	0485                	addi	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     346:	fe9919e3          	bne	s2,s1,338 <gettoken+0x2a>
    s++;
     34a:	84ca                	mv	s1,s2
  if(q)
     34c:	000a8463          	beqz	s5,354 <gettoken+0x46>
    *q = s;
     350:	009ab023          	sd	s1,0(s5)
  ret = *s;
     354:	0004c783          	lbu	a5,0(s1)
     358:	00078a9b          	sext.w	s5,a5
  switch(*s){
     35c:	03c00713          	li	a4,60
     360:	06f76463          	bltu	a4,a5,3c8 <gettoken+0xba>
     364:	03a00713          	li	a4,58
     368:	00f76e63          	bltu	a4,a5,384 <gettoken+0x76>
     36c:	cf89                	beqz	a5,386 <gettoken+0x78>
     36e:	02600713          	li	a4,38
     372:	00e78963          	beq	a5,a4,384 <gettoken+0x76>
     376:	fd87879b          	addiw	a5,a5,-40
     37a:	0ff7f793          	zext.b	a5,a5
     37e:	4705                	li	a4,1
     380:	06f76b63          	bltu	a4,a5,3f6 <gettoken+0xe8>
  case '(':
  case ')':
  case ';':
  case '&':
  case '<':
    s++;
     384:	0485                	addi	s1,s1,1
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if(eq)
     386:	000b0463          	beqz	s6,38e <gettoken+0x80>
    *eq = s;
     38a:	009b3023          	sd	s1,0(s6)

  while(s < es && strchr(whitespace, *s))
     38e:	00002997          	auipc	s3,0x2
     392:	c7a98993          	addi	s3,s3,-902 # 2008 <whitespace>
     396:	0124fc63          	bgeu	s1,s2,3ae <gettoken+0xa0>
     39a:	0004c583          	lbu	a1,0(s1)
     39e:	854e                	mv	a0,s3
     3a0:	68c000ef          	jal	ra,a2c <strchr>
     3a4:	c509                	beqz	a0,3ae <gettoken+0xa0>
    s++;
     3a6:	0485                	addi	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     3a8:	fe9919e3          	bne	s2,s1,39a <gettoken+0x8c>
    s++;
     3ac:	84ca                	mv	s1,s2
  *ps = s;
     3ae:	009a3023          	sd	s1,0(s4)
  return ret;
}
     3b2:	8556                	mv	a0,s5
     3b4:	70e2                	ld	ra,56(sp)
     3b6:	7442                	ld	s0,48(sp)
     3b8:	74a2                	ld	s1,40(sp)
     3ba:	7902                	ld	s2,32(sp)
     3bc:	69e2                	ld	s3,24(sp)
     3be:	6a42                	ld	s4,16(sp)
     3c0:	6aa2                	ld	s5,8(sp)
     3c2:	6b02                	ld	s6,0(sp)
     3c4:	6121                	addi	sp,sp,64
     3c6:	8082                	ret
  switch(*s){
     3c8:	03e00713          	li	a4,62
     3cc:	02e79163          	bne	a5,a4,3ee <gettoken+0xe0>
    s++;
     3d0:	00148693          	addi	a3,s1,1
    if(*s == '>'){
     3d4:	0014c703          	lbu	a4,1(s1)
     3d8:	03e00793          	li	a5,62
      s++;
     3dc:	0489                	addi	s1,s1,2
      ret = '+';
     3de:	02b00a93          	li	s5,43
    if(*s == '>'){
     3e2:	faf702e3          	beq	a4,a5,386 <gettoken+0x78>
    s++;
     3e6:	84b6                	mv	s1,a3
  ret = *s;
     3e8:	03e00a93          	li	s5,62
     3ec:	bf69                	j	386 <gettoken+0x78>
  switch(*s){
     3ee:	07c00713          	li	a4,124
     3f2:	f8e789e3          	beq	a5,a4,384 <gettoken+0x76>
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     3f6:	00002997          	auipc	s3,0x2
     3fa:	c1298993          	addi	s3,s3,-1006 # 2008 <whitespace>
     3fe:	00002a97          	auipc	s5,0x2
     402:	c02a8a93          	addi	s5,s5,-1022 # 2000 <symbols>
     406:	0324f263          	bgeu	s1,s2,42a <gettoken+0x11c>
     40a:	0004c583          	lbu	a1,0(s1)
     40e:	854e                	mv	a0,s3
     410:	61c000ef          	jal	ra,a2c <strchr>
     414:	e11d                	bnez	a0,43a <gettoken+0x12c>
     416:	0004c583          	lbu	a1,0(s1)
     41a:	8556                	mv	a0,s5
     41c:	610000ef          	jal	ra,a2c <strchr>
     420:	e911                	bnez	a0,434 <gettoken+0x126>
      s++;
     422:	0485                	addi	s1,s1,1
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     424:	fe9913e3          	bne	s2,s1,40a <gettoken+0xfc>
      s++;
     428:	84ca                	mv	s1,s2
  if(eq)
     42a:	06100a93          	li	s5,97
     42e:	f40b1ee3          	bnez	s6,38a <gettoken+0x7c>
     432:	bfb5                	j	3ae <gettoken+0xa0>
    ret = 'a';
     434:	06100a93          	li	s5,97
     438:	b7b9                	j	386 <gettoken+0x78>
     43a:	06100a93          	li	s5,97
     43e:	b7a1                	j	386 <gettoken+0x78>

0000000000000440 <peek>:

int
peek(char **ps, char *es, char *toks)
{
     440:	7139                	addi	sp,sp,-64
     442:	fc06                	sd	ra,56(sp)
     444:	f822                	sd	s0,48(sp)
     446:	f426                	sd	s1,40(sp)
     448:	f04a                	sd	s2,32(sp)
     44a:	ec4e                	sd	s3,24(sp)
     44c:	e852                	sd	s4,16(sp)
     44e:	e456                	sd	s5,8(sp)
     450:	0080                	addi	s0,sp,64
     452:	8a2a                	mv	s4,a0
     454:	892e                	mv	s2,a1
     456:	8ab2                	mv	s5,a2
  char *s;

  s = *ps;
     458:	6104                	ld	s1,0(a0)
  while(s < es && strchr(whitespace, *s))
     45a:	00002997          	auipc	s3,0x2
     45e:	bae98993          	addi	s3,s3,-1106 # 2008 <whitespace>
     462:	00b4fc63          	bgeu	s1,a1,47a <peek+0x3a>
     466:	0004c583          	lbu	a1,0(s1)
     46a:	854e                	mv	a0,s3
     46c:	5c0000ef          	jal	ra,a2c <strchr>
     470:	c509                	beqz	a0,47a <peek+0x3a>
    s++;
     472:	0485                	addi	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     474:	fe9919e3          	bne	s2,s1,466 <peek+0x26>
    s++;
     478:	84ca                	mv	s1,s2
  *ps = s;
     47a:	009a3023          	sd	s1,0(s4)
  return *s && strchr(toks, *s);
     47e:	0004c583          	lbu	a1,0(s1)
     482:	4501                	li	a0,0
     484:	e991                	bnez	a1,498 <peek+0x58>
}
     486:	70e2                	ld	ra,56(sp)
     488:	7442                	ld	s0,48(sp)
     48a:	74a2                	ld	s1,40(sp)
     48c:	7902                	ld	s2,32(sp)
     48e:	69e2                	ld	s3,24(sp)
     490:	6a42                	ld	s4,16(sp)
     492:	6aa2                	ld	s5,8(sp)
     494:	6121                	addi	sp,sp,64
     496:	8082                	ret
  return *s && strchr(toks, *s);
     498:	8556                	mv	a0,s5
     49a:	592000ef          	jal	ra,a2c <strchr>
     49e:	00a03533          	snez	a0,a0
     4a2:	b7d5                	j	486 <peek+0x46>

00000000000004a4 <parseredirs>:
  return cmd;
}

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     4a4:	7159                	addi	sp,sp,-112
     4a6:	f486                	sd	ra,104(sp)
     4a8:	f0a2                	sd	s0,96(sp)
     4aa:	eca6                	sd	s1,88(sp)
     4ac:	e8ca                	sd	s2,80(sp)
     4ae:	e4ce                	sd	s3,72(sp)
     4b0:	e0d2                	sd	s4,64(sp)
     4b2:	fc56                	sd	s5,56(sp)
     4b4:	f85a                	sd	s6,48(sp)
     4b6:	f45e                	sd	s7,40(sp)
     4b8:	f062                	sd	s8,32(sp)
     4ba:	ec66                	sd	s9,24(sp)
     4bc:	1880                	addi	s0,sp,112
     4be:	8a2a                	mv	s4,a0
     4c0:	89ae                	mv	s3,a1
     4c2:	8932                	mv	s2,a2
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     4c4:	00001b97          	auipc	s7,0x1
     4c8:	d34b8b93          	addi	s7,s7,-716 # 11f8 <malloc+0x148>
    tok = gettoken(ps, es, 0, 0);
    if(gettoken(ps, es, &q, &eq) != 'a')
     4cc:	06100c13          	li	s8,97
      panic("missing file for redirection");
    switch(tok){
     4d0:	03c00c93          	li	s9,60
  while(peek(ps, es, "<>")){
     4d4:	a00d                	j	4f6 <parseredirs+0x52>
      panic("missing file for redirection");
     4d6:	00001517          	auipc	a0,0x1
     4da:	d0250513          	addi	a0,a0,-766 # 11d8 <malloc+0x128>
     4de:	b6dff0ef          	jal	ra,4a <panic>
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     4e2:	4701                	li	a4,0
     4e4:	4681                	li	a3,0
     4e6:	f9043603          	ld	a2,-112(s0)
     4ea:	f9843583          	ld	a1,-104(s0)
     4ee:	8552                	mv	a0,s4
     4f0:	d0fff0ef          	jal	ra,1fe <redircmd>
     4f4:	8a2a                	mv	s4,a0
    switch(tok){
     4f6:	03e00b13          	li	s6,62
     4fa:	02b00a93          	li	s5,43
  while(peek(ps, es, "<>")){
     4fe:	865e                	mv	a2,s7
     500:	85ca                	mv	a1,s2
     502:	854e                	mv	a0,s3
     504:	f3dff0ef          	jal	ra,440 <peek>
     508:	c125                	beqz	a0,568 <parseredirs+0xc4>
    tok = gettoken(ps, es, 0, 0);
     50a:	4681                	li	a3,0
     50c:	4601                	li	a2,0
     50e:	85ca                	mv	a1,s2
     510:	854e                	mv	a0,s3
     512:	dfdff0ef          	jal	ra,30e <gettoken>
     516:	84aa                	mv	s1,a0
    if(gettoken(ps, es, &q, &eq) != 'a')
     518:	f9040693          	addi	a3,s0,-112
     51c:	f9840613          	addi	a2,s0,-104
     520:	85ca                	mv	a1,s2
     522:	854e                	mv	a0,s3
     524:	debff0ef          	jal	ra,30e <gettoken>
     528:	fb8517e3          	bne	a0,s8,4d6 <parseredirs+0x32>
    switch(tok){
     52c:	fb948be3          	beq	s1,s9,4e2 <parseredirs+0x3e>
     530:	03648063          	beq	s1,s6,550 <parseredirs+0xac>
     534:	fd5495e3          	bne	s1,s5,4fe <parseredirs+0x5a>
      break;
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE|O_TRUNC, 1);
      break;
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     538:	4705                	li	a4,1
     53a:	20100693          	li	a3,513
     53e:	f9043603          	ld	a2,-112(s0)
     542:	f9843583          	ld	a1,-104(s0)
     546:	8552                	mv	a0,s4
     548:	cb7ff0ef          	jal	ra,1fe <redircmd>
     54c:	8a2a                	mv	s4,a0
      break;
     54e:	b765                	j	4f6 <parseredirs+0x52>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE|O_TRUNC, 1);
     550:	4705                	li	a4,1
     552:	60100693          	li	a3,1537
     556:	f9043603          	ld	a2,-112(s0)
     55a:	f9843583          	ld	a1,-104(s0)
     55e:	8552                	mv	a0,s4
     560:	c9fff0ef          	jal	ra,1fe <redircmd>
     564:	8a2a                	mv	s4,a0
      break;
     566:	bf41                	j	4f6 <parseredirs+0x52>
    }
  }
  return cmd;
}
     568:	8552                	mv	a0,s4
     56a:	70a6                	ld	ra,104(sp)
     56c:	7406                	ld	s0,96(sp)
     56e:	64e6                	ld	s1,88(sp)
     570:	6946                	ld	s2,80(sp)
     572:	69a6                	ld	s3,72(sp)
     574:	6a06                	ld	s4,64(sp)
     576:	7ae2                	ld	s5,56(sp)
     578:	7b42                	ld	s6,48(sp)
     57a:	7ba2                	ld	s7,40(sp)
     57c:	7c02                	ld	s8,32(sp)
     57e:	6ce2                	ld	s9,24(sp)
     580:	6165                	addi	sp,sp,112
     582:	8082                	ret

0000000000000584 <parseexec>:
  return cmd;
}

struct cmd*
parseexec(char **ps, char *es)
{
     584:	7159                	addi	sp,sp,-112
     586:	f486                	sd	ra,104(sp)
     588:	f0a2                	sd	s0,96(sp)
     58a:	eca6                	sd	s1,88(sp)
     58c:	e8ca                	sd	s2,80(sp)
     58e:	e4ce                	sd	s3,72(sp)
     590:	e0d2                	sd	s4,64(sp)
     592:	fc56                	sd	s5,56(sp)
     594:	f85a                	sd	s6,48(sp)
     596:	f45e                	sd	s7,40(sp)
     598:	f062                	sd	s8,32(sp)
     59a:	ec66                	sd	s9,24(sp)
     59c:	1880                	addi	s0,sp,112
     59e:	8a2a                	mv	s4,a0
     5a0:	8aae                	mv	s5,a1
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;

  if(peek(ps, es, "("))
     5a2:	00001617          	auipc	a2,0x1
     5a6:	c5e60613          	addi	a2,a2,-930 # 1200 <malloc+0x150>
     5aa:	e97ff0ef          	jal	ra,440 <peek>
     5ae:	e505                	bnez	a0,5d6 <parseexec+0x52>
     5b0:	89aa                	mv	s3,a0
    return parseblock(ps, es);

  ret = execcmd();
     5b2:	c1fff0ef          	jal	ra,1d0 <execcmd>
     5b6:	8c2a                	mv	s8,a0
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
     5b8:	8656                	mv	a2,s5
     5ba:	85d2                	mv	a1,s4
     5bc:	ee9ff0ef          	jal	ra,4a4 <parseredirs>
     5c0:	84aa                	mv	s1,a0
  while(!peek(ps, es, "|)&;")){
     5c2:	008c0913          	addi	s2,s8,8
     5c6:	00001b17          	auipc	s6,0x1
     5ca:	c5ab0b13          	addi	s6,s6,-934 # 1220 <malloc+0x170>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
      break;
    if(tok != 'a')
     5ce:	06100c93          	li	s9,97
      panic("syntax");
    cmd->argv[argc] = q;
    cmd->eargv[argc] = eq;
    argc++;
    if(argc >= MAXARGS)
     5d2:	4ba9                	li	s7,10
  while(!peek(ps, es, "|)&;")){
     5d4:	a081                	j	614 <parseexec+0x90>
    return parseblock(ps, es);
     5d6:	85d6                	mv	a1,s5
     5d8:	8552                	mv	a0,s4
     5da:	170000ef          	jal	ra,74a <parseblock>
     5de:	84aa                	mv	s1,a0
    ret = parseredirs(ret, ps, es);
  }
  cmd->argv[argc] = 0;
  cmd->eargv[argc] = 0;
  return ret;
}
     5e0:	8526                	mv	a0,s1
     5e2:	70a6                	ld	ra,104(sp)
     5e4:	7406                	ld	s0,96(sp)
     5e6:	64e6                	ld	s1,88(sp)
     5e8:	6946                	ld	s2,80(sp)
     5ea:	69a6                	ld	s3,72(sp)
     5ec:	6a06                	ld	s4,64(sp)
     5ee:	7ae2                	ld	s5,56(sp)
     5f0:	7b42                	ld	s6,48(sp)
     5f2:	7ba2                	ld	s7,40(sp)
     5f4:	7c02                	ld	s8,32(sp)
     5f6:	6ce2                	ld	s9,24(sp)
     5f8:	6165                	addi	sp,sp,112
     5fa:	8082                	ret
      panic("syntax");
     5fc:	00001517          	auipc	a0,0x1
     600:	c0c50513          	addi	a0,a0,-1012 # 1208 <malloc+0x158>
     604:	a47ff0ef          	jal	ra,4a <panic>
    ret = parseredirs(ret, ps, es);
     608:	8656                	mv	a2,s5
     60a:	85d2                	mv	a1,s4
     60c:	8526                	mv	a0,s1
     60e:	e97ff0ef          	jal	ra,4a4 <parseredirs>
     612:	84aa                	mv	s1,a0
  while(!peek(ps, es, "|)&;")){
     614:	865a                	mv	a2,s6
     616:	85d6                	mv	a1,s5
     618:	8552                	mv	a0,s4
     61a:	e27ff0ef          	jal	ra,440 <peek>
     61e:	ed15                	bnez	a0,65a <parseexec+0xd6>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
     620:	f9040693          	addi	a3,s0,-112
     624:	f9840613          	addi	a2,s0,-104
     628:	85d6                	mv	a1,s5
     62a:	8552                	mv	a0,s4
     62c:	ce3ff0ef          	jal	ra,30e <gettoken>
     630:	c50d                	beqz	a0,65a <parseexec+0xd6>
    if(tok != 'a')
     632:	fd9515e3          	bne	a0,s9,5fc <parseexec+0x78>
    cmd->argv[argc] = q;
     636:	f9843783          	ld	a5,-104(s0)
     63a:	00f93023          	sd	a5,0(s2)
    cmd->eargv[argc] = eq;
     63e:	f9043783          	ld	a5,-112(s0)
     642:	04f93823          	sd	a5,80(s2)
    argc++;
     646:	2985                	addiw	s3,s3,1
    if(argc >= MAXARGS)
     648:	0921                	addi	s2,s2,8
     64a:	fb799fe3          	bne	s3,s7,608 <parseexec+0x84>
      panic("too many args");
     64e:	00001517          	auipc	a0,0x1
     652:	bc250513          	addi	a0,a0,-1086 # 1210 <malloc+0x160>
     656:	9f5ff0ef          	jal	ra,4a <panic>
  cmd->argv[argc] = 0;
     65a:	098e                	slli	s3,s3,0x3
     65c:	9c4e                	add	s8,s8,s3
     65e:	000c3423          	sd	zero,8(s8)
  cmd->eargv[argc] = 0;
     662:	040c3c23          	sd	zero,88(s8)
  return ret;
     666:	bfad                	j	5e0 <parseexec+0x5c>

0000000000000668 <parsepipe>:
{
     668:	7179                	addi	sp,sp,-48
     66a:	f406                	sd	ra,40(sp)
     66c:	f022                	sd	s0,32(sp)
     66e:	ec26                	sd	s1,24(sp)
     670:	e84a                	sd	s2,16(sp)
     672:	e44e                	sd	s3,8(sp)
     674:	1800                	addi	s0,sp,48
     676:	892a                	mv	s2,a0
     678:	89ae                	mv	s3,a1
  cmd = parseexec(ps, es);
     67a:	f0bff0ef          	jal	ra,584 <parseexec>
     67e:	84aa                	mv	s1,a0
  if(peek(ps, es, "|")){
     680:	00001617          	auipc	a2,0x1
     684:	ba860613          	addi	a2,a2,-1112 # 1228 <malloc+0x178>
     688:	85ce                	mv	a1,s3
     68a:	854a                	mv	a0,s2
     68c:	db5ff0ef          	jal	ra,440 <peek>
     690:	e909                	bnez	a0,6a2 <parsepipe+0x3a>
}
     692:	8526                	mv	a0,s1
     694:	70a2                	ld	ra,40(sp)
     696:	7402                	ld	s0,32(sp)
     698:	64e2                	ld	s1,24(sp)
     69a:	6942                	ld	s2,16(sp)
     69c:	69a2                	ld	s3,8(sp)
     69e:	6145                	addi	sp,sp,48
     6a0:	8082                	ret
    gettoken(ps, es, 0, 0);
     6a2:	4681                	li	a3,0
     6a4:	4601                	li	a2,0
     6a6:	85ce                	mv	a1,s3
     6a8:	854a                	mv	a0,s2
     6aa:	c65ff0ef          	jal	ra,30e <gettoken>
    cmd = pipecmd(cmd, parsepipe(ps, es));
     6ae:	85ce                	mv	a1,s3
     6b0:	854a                	mv	a0,s2
     6b2:	fb7ff0ef          	jal	ra,668 <parsepipe>
     6b6:	85aa                	mv	a1,a0
     6b8:	8526                	mv	a0,s1
     6ba:	ba5ff0ef          	jal	ra,25e <pipecmd>
     6be:	84aa                	mv	s1,a0
  return cmd;
     6c0:	bfc9                	j	692 <parsepipe+0x2a>

00000000000006c2 <parseline>:
{
     6c2:	7179                	addi	sp,sp,-48
     6c4:	f406                	sd	ra,40(sp)
     6c6:	f022                	sd	s0,32(sp)
     6c8:	ec26                	sd	s1,24(sp)
     6ca:	e84a                	sd	s2,16(sp)
     6cc:	e44e                	sd	s3,8(sp)
     6ce:	e052                	sd	s4,0(sp)
     6d0:	1800                	addi	s0,sp,48
     6d2:	892a                	mv	s2,a0
     6d4:	89ae                	mv	s3,a1
  cmd = parsepipe(ps, es);
     6d6:	f93ff0ef          	jal	ra,668 <parsepipe>
     6da:	84aa                	mv	s1,a0
  while(peek(ps, es, "&")){
     6dc:	00001a17          	auipc	s4,0x1
     6e0:	b54a0a13          	addi	s4,s4,-1196 # 1230 <malloc+0x180>
     6e4:	a819                	j	6fa <parseline+0x38>
    gettoken(ps, es, 0, 0);
     6e6:	4681                	li	a3,0
     6e8:	4601                	li	a2,0
     6ea:	85ce                	mv	a1,s3
     6ec:	854a                	mv	a0,s2
     6ee:	c21ff0ef          	jal	ra,30e <gettoken>
    cmd = backcmd(cmd);
     6f2:	8526                	mv	a0,s1
     6f4:	be7ff0ef          	jal	ra,2da <backcmd>
     6f8:	84aa                	mv	s1,a0
  while(peek(ps, es, "&")){
     6fa:	8652                	mv	a2,s4
     6fc:	85ce                	mv	a1,s3
     6fe:	854a                	mv	a0,s2
     700:	d41ff0ef          	jal	ra,440 <peek>
     704:	f16d                	bnez	a0,6e6 <parseline+0x24>
  if(peek(ps, es, ";")){
     706:	00001617          	auipc	a2,0x1
     70a:	b3260613          	addi	a2,a2,-1230 # 1238 <malloc+0x188>
     70e:	85ce                	mv	a1,s3
     710:	854a                	mv	a0,s2
     712:	d2fff0ef          	jal	ra,440 <peek>
     716:	e911                	bnez	a0,72a <parseline+0x68>
}
     718:	8526                	mv	a0,s1
     71a:	70a2                	ld	ra,40(sp)
     71c:	7402                	ld	s0,32(sp)
     71e:	64e2                	ld	s1,24(sp)
     720:	6942                	ld	s2,16(sp)
     722:	69a2                	ld	s3,8(sp)
     724:	6a02                	ld	s4,0(sp)
     726:	6145                	addi	sp,sp,48
     728:	8082                	ret
    gettoken(ps, es, 0, 0);
     72a:	4681                	li	a3,0
     72c:	4601                	li	a2,0
     72e:	85ce                	mv	a1,s3
     730:	854a                	mv	a0,s2
     732:	bddff0ef          	jal	ra,30e <gettoken>
    cmd = listcmd(cmd, parseline(ps, es));
     736:	85ce                	mv	a1,s3
     738:	854a                	mv	a0,s2
     73a:	f89ff0ef          	jal	ra,6c2 <parseline>
     73e:	85aa                	mv	a1,a0
     740:	8526                	mv	a0,s1
     742:	b5bff0ef          	jal	ra,29c <listcmd>
     746:	84aa                	mv	s1,a0
  return cmd;
     748:	bfc1                	j	718 <parseline+0x56>

000000000000074a <parseblock>:
{
     74a:	7179                	addi	sp,sp,-48
     74c:	f406                	sd	ra,40(sp)
     74e:	f022                	sd	s0,32(sp)
     750:	ec26                	sd	s1,24(sp)
     752:	e84a                	sd	s2,16(sp)
     754:	e44e                	sd	s3,8(sp)
     756:	1800                	addi	s0,sp,48
     758:	84aa                	mv	s1,a0
     75a:	892e                	mv	s2,a1
  if(!peek(ps, es, "("))
     75c:	00001617          	auipc	a2,0x1
     760:	aa460613          	addi	a2,a2,-1372 # 1200 <malloc+0x150>
     764:	cddff0ef          	jal	ra,440 <peek>
     768:	c539                	beqz	a0,7b6 <parseblock+0x6c>
  gettoken(ps, es, 0, 0);
     76a:	4681                	li	a3,0
     76c:	4601                	li	a2,0
     76e:	85ca                	mv	a1,s2
     770:	8526                	mv	a0,s1
     772:	b9dff0ef          	jal	ra,30e <gettoken>
  cmd = parseline(ps, es);
     776:	85ca                	mv	a1,s2
     778:	8526                	mv	a0,s1
     77a:	f49ff0ef          	jal	ra,6c2 <parseline>
     77e:	89aa                	mv	s3,a0
  if(!peek(ps, es, ")"))
     780:	00001617          	auipc	a2,0x1
     784:	ad060613          	addi	a2,a2,-1328 # 1250 <malloc+0x1a0>
     788:	85ca                	mv	a1,s2
     78a:	8526                	mv	a0,s1
     78c:	cb5ff0ef          	jal	ra,440 <peek>
     790:	c90d                	beqz	a0,7c2 <parseblock+0x78>
  gettoken(ps, es, 0, 0);
     792:	4681                	li	a3,0
     794:	4601                	li	a2,0
     796:	85ca                	mv	a1,s2
     798:	8526                	mv	a0,s1
     79a:	b75ff0ef          	jal	ra,30e <gettoken>
  cmd = parseredirs(cmd, ps, es);
     79e:	864a                	mv	a2,s2
     7a0:	85a6                	mv	a1,s1
     7a2:	854e                	mv	a0,s3
     7a4:	d01ff0ef          	jal	ra,4a4 <parseredirs>
}
     7a8:	70a2                	ld	ra,40(sp)
     7aa:	7402                	ld	s0,32(sp)
     7ac:	64e2                	ld	s1,24(sp)
     7ae:	6942                	ld	s2,16(sp)
     7b0:	69a2                	ld	s3,8(sp)
     7b2:	6145                	addi	sp,sp,48
     7b4:	8082                	ret
    panic("parseblock");
     7b6:	00001517          	auipc	a0,0x1
     7ba:	a8a50513          	addi	a0,a0,-1398 # 1240 <malloc+0x190>
     7be:	88dff0ef          	jal	ra,4a <panic>
    panic("syntax - missing )");
     7c2:	00001517          	auipc	a0,0x1
     7c6:	a9650513          	addi	a0,a0,-1386 # 1258 <malloc+0x1a8>
     7ca:	881ff0ef          	jal	ra,4a <panic>

00000000000007ce <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
     7ce:	1101                	addi	sp,sp,-32
     7d0:	ec06                	sd	ra,24(sp)
     7d2:	e822                	sd	s0,16(sp)
     7d4:	e426                	sd	s1,8(sp)
     7d6:	1000                	addi	s0,sp,32
     7d8:	84aa                	mv	s1,a0
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
     7da:	c131                	beqz	a0,81e <nulterminate+0x50>
    return 0;

  switch(cmd->type){
     7dc:	4118                	lw	a4,0(a0)
     7de:	4795                	li	a5,5
     7e0:	02e7ef63          	bltu	a5,a4,81e <nulterminate+0x50>
     7e4:	00056783          	lwu	a5,0(a0)
     7e8:	078a                	slli	a5,a5,0x2
     7ea:	00001717          	auipc	a4,0x1
     7ee:	ace70713          	addi	a4,a4,-1330 # 12b8 <malloc+0x208>
     7f2:	97ba                	add	a5,a5,a4
     7f4:	439c                	lw	a5,0(a5)
     7f6:	97ba                	add	a5,a5,a4
     7f8:	8782                	jr	a5
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    for(i=0; ecmd->argv[i]; i++)
     7fa:	651c                	ld	a5,8(a0)
     7fc:	c38d                	beqz	a5,81e <nulterminate+0x50>
     7fe:	01050793          	addi	a5,a0,16
      *ecmd->eargv[i] = 0;
     802:	67b8                	ld	a4,72(a5)
     804:	00070023          	sb	zero,0(a4)
    for(i=0; ecmd->argv[i]; i++)
     808:	07a1                	addi	a5,a5,8
     80a:	ff87b703          	ld	a4,-8(a5)
     80e:	fb75                	bnez	a4,802 <nulterminate+0x34>
     810:	a039                	j	81e <nulterminate+0x50>
    break;

  case REDIR:
    rcmd = (struct redircmd*)cmd;
    nulterminate(rcmd->cmd);
     812:	6508                	ld	a0,8(a0)
     814:	fbbff0ef          	jal	ra,7ce <nulterminate>
    *rcmd->efile = 0;
     818:	6c9c                	ld	a5,24(s1)
     81a:	00078023          	sb	zero,0(a5)
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
     81e:	8526                	mv	a0,s1
     820:	60e2                	ld	ra,24(sp)
     822:	6442                	ld	s0,16(sp)
     824:	64a2                	ld	s1,8(sp)
     826:	6105                	addi	sp,sp,32
     828:	8082                	ret
    nulterminate(pcmd->left);
     82a:	6508                	ld	a0,8(a0)
     82c:	fa3ff0ef          	jal	ra,7ce <nulterminate>
    nulterminate(pcmd->right);
     830:	6888                	ld	a0,16(s1)
     832:	f9dff0ef          	jal	ra,7ce <nulterminate>
    break;
     836:	b7e5                	j	81e <nulterminate+0x50>
    nulterminate(lcmd->left);
     838:	6508                	ld	a0,8(a0)
     83a:	f95ff0ef          	jal	ra,7ce <nulterminate>
    nulterminate(lcmd->right);
     83e:	6888                	ld	a0,16(s1)
     840:	f8fff0ef          	jal	ra,7ce <nulterminate>
    break;
     844:	bfe9                	j	81e <nulterminate+0x50>
    nulterminate(bcmd->cmd);
     846:	6508                	ld	a0,8(a0)
     848:	f87ff0ef          	jal	ra,7ce <nulterminate>
    break;
     84c:	bfc9                	j	81e <nulterminate+0x50>

000000000000084e <parsecmd>:
{
     84e:	7179                	addi	sp,sp,-48
     850:	f406                	sd	ra,40(sp)
     852:	f022                	sd	s0,32(sp)
     854:	ec26                	sd	s1,24(sp)
     856:	e84a                	sd	s2,16(sp)
     858:	1800                	addi	s0,sp,48
     85a:	fca43c23          	sd	a0,-40(s0)
  es = s + strlen(s);
     85e:	84aa                	mv	s1,a0
     860:	180000ef          	jal	ra,9e0 <strlen>
     864:	1502                	slli	a0,a0,0x20
     866:	9101                	srli	a0,a0,0x20
     868:	94aa                	add	s1,s1,a0
  cmd = parseline(&s, es);
     86a:	85a6                	mv	a1,s1
     86c:	fd840513          	addi	a0,s0,-40
     870:	e53ff0ef          	jal	ra,6c2 <parseline>
     874:	892a                	mv	s2,a0
  peek(&s, es, "");
     876:	00001617          	auipc	a2,0x1
     87a:	9fa60613          	addi	a2,a2,-1542 # 1270 <malloc+0x1c0>
     87e:	85a6                	mv	a1,s1
     880:	fd840513          	addi	a0,s0,-40
     884:	bbdff0ef          	jal	ra,440 <peek>
  if(s != es){
     888:	fd843603          	ld	a2,-40(s0)
     88c:	00961c63          	bne	a2,s1,8a4 <parsecmd+0x56>
  nulterminate(cmd);
     890:	854a                	mv	a0,s2
     892:	f3dff0ef          	jal	ra,7ce <nulterminate>
}
     896:	854a                	mv	a0,s2
     898:	70a2                	ld	ra,40(sp)
     89a:	7402                	ld	s0,32(sp)
     89c:	64e2                	ld	s1,24(sp)
     89e:	6942                	ld	s2,16(sp)
     8a0:	6145                	addi	sp,sp,48
     8a2:	8082                	ret
    fprintf(2, "leftovers: %s\n", s);
     8a4:	00001597          	auipc	a1,0x1
     8a8:	9d458593          	addi	a1,a1,-1580 # 1278 <malloc+0x1c8>
     8ac:	4509                	li	a0,2
     8ae:	724000ef          	jal	ra,fd2 <fprintf>
    panic("syntax");
     8b2:	00001517          	auipc	a0,0x1
     8b6:	95650513          	addi	a0,a0,-1706 # 1208 <malloc+0x158>
     8ba:	f90ff0ef          	jal	ra,4a <panic>

00000000000008be <main>:
{
     8be:	7139                	addi	sp,sp,-64
     8c0:	fc06                	sd	ra,56(sp)
     8c2:	f822                	sd	s0,48(sp)
     8c4:	f426                	sd	s1,40(sp)
     8c6:	f04a                	sd	s2,32(sp)
     8c8:	ec4e                	sd	s3,24(sp)
     8ca:	e852                	sd	s4,16(sp)
     8cc:	e456                	sd	s5,8(sp)
     8ce:	0080                	addi	s0,sp,64
  while((fd = open("console", O_RDWR)) >= 0){
     8d0:	00001497          	auipc	s1,0x1
     8d4:	9b848493          	addi	s1,s1,-1608 # 1288 <malloc+0x1d8>
     8d8:	4589                	li	a1,2
     8da:	8526                	mv	a0,s1
     8dc:	354000ef          	jal	ra,c30 <open>
     8e0:	00054763          	bltz	a0,8ee <main+0x30>
    if(fd >= 3){
     8e4:	4789                	li	a5,2
     8e6:	fea7d9e3          	bge	a5,a0,8d8 <main+0x1a>
      close(fd);
     8ea:	32e000ef          	jal	ra,c18 <close>
  while(getcmd(buf, sizeof(buf)) >= 0){
     8ee:	00001497          	auipc	s1,0x1
     8f2:	73248493          	addi	s1,s1,1842 # 2020 <buf.0>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     8f6:	06300913          	li	s2,99
     8fa:	02000993          	li	s3,32
      if(chdir(buf+3) < 0)
     8fe:	00001a17          	auipc	s4,0x1
     902:	725a0a13          	addi	s4,s4,1829 # 2023 <buf.0+0x3>
        fprintf(2, "cannot cd %s\n", buf+3);
     906:	00001a97          	auipc	s5,0x1
     90a:	98aa8a93          	addi	s5,s5,-1654 # 1290 <malloc+0x1e0>
     90e:	a039                	j	91c <main+0x5e>
    if(fork1() == 0)
     910:	f58ff0ef          	jal	ra,68 <fork1>
     914:	cd31                	beqz	a0,970 <main+0xb2>
    wait(0);
     916:	4501                	li	a0,0
     918:	2e0000ef          	jal	ra,bf8 <wait>
  while(getcmd(buf, sizeof(buf)) >= 0){
     91c:	06400593          	li	a1,100
     920:	8526                	mv	a0,s1
     922:	edeff0ef          	jal	ra,0 <getcmd>
     926:	04054d63          	bltz	a0,980 <main+0xc2>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     92a:	0004c783          	lbu	a5,0(s1)
     92e:	ff2791e3          	bne	a5,s2,910 <main+0x52>
     932:	0014c703          	lbu	a4,1(s1)
     936:	06400793          	li	a5,100
     93a:	fcf71be3          	bne	a4,a5,910 <main+0x52>
     93e:	0024c783          	lbu	a5,2(s1)
     942:	fd3797e3          	bne	a5,s3,910 <main+0x52>
      buf[strlen(buf)-1] = 0;  // chop \n
     946:	8526                	mv	a0,s1
     948:	098000ef          	jal	ra,9e0 <strlen>
     94c:	fff5079b          	addiw	a5,a0,-1
     950:	1782                	slli	a5,a5,0x20
     952:	9381                	srli	a5,a5,0x20
     954:	97a6                	add	a5,a5,s1
     956:	00078023          	sb	zero,0(a5)
      if(chdir(buf+3) < 0)
     95a:	8552                	mv	a0,s4
     95c:	304000ef          	jal	ra,c60 <chdir>
     960:	fa055ee3          	bgez	a0,91c <main+0x5e>
        fprintf(2, "cannot cd %s\n", buf+3);
     964:	8652                	mv	a2,s4
     966:	85d6                	mv	a1,s5
     968:	4509                	li	a0,2
     96a:	668000ef          	jal	ra,fd2 <fprintf>
     96e:	b77d                	j	91c <main+0x5e>
      runcmd(parsecmd(buf));
     970:	00001517          	auipc	a0,0x1
     974:	6b050513          	addi	a0,a0,1712 # 2020 <buf.0>
     978:	ed7ff0ef          	jal	ra,84e <parsecmd>
     97c:	f12ff0ef          	jal	ra,8e <runcmd>
  exit(0);
     980:	4501                	li	a0,0
     982:	26e000ef          	jal	ra,bf0 <exit>

0000000000000986 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
     986:	1141                	addi	sp,sp,-16
     988:	e406                	sd	ra,8(sp)
     98a:	e022                	sd	s0,0(sp)
     98c:	0800                	addi	s0,sp,16
  extern int main();
  main();
     98e:	f31ff0ef          	jal	ra,8be <main>
  exit(0);
     992:	4501                	li	a0,0
     994:	25c000ef          	jal	ra,bf0 <exit>

0000000000000998 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
     998:	1141                	addi	sp,sp,-16
     99a:	e422                	sd	s0,8(sp)
     99c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     99e:	87aa                	mv	a5,a0
     9a0:	0585                	addi	a1,a1,1
     9a2:	0785                	addi	a5,a5,1
     9a4:	fff5c703          	lbu	a4,-1(a1)
     9a8:	fee78fa3          	sb	a4,-1(a5)
     9ac:	fb75                	bnez	a4,9a0 <strcpy+0x8>
    ;
  return os;
}
     9ae:	6422                	ld	s0,8(sp)
     9b0:	0141                	addi	sp,sp,16
     9b2:	8082                	ret

00000000000009b4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     9b4:	1141                	addi	sp,sp,-16
     9b6:	e422                	sd	s0,8(sp)
     9b8:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     9ba:	00054783          	lbu	a5,0(a0)
     9be:	cb91                	beqz	a5,9d2 <strcmp+0x1e>
     9c0:	0005c703          	lbu	a4,0(a1)
     9c4:	00f71763          	bne	a4,a5,9d2 <strcmp+0x1e>
    p++, q++;
     9c8:	0505                	addi	a0,a0,1
     9ca:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     9cc:	00054783          	lbu	a5,0(a0)
     9d0:	fbe5                	bnez	a5,9c0 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
     9d2:	0005c503          	lbu	a0,0(a1)
}
     9d6:	40a7853b          	subw	a0,a5,a0
     9da:	6422                	ld	s0,8(sp)
     9dc:	0141                	addi	sp,sp,16
     9de:	8082                	ret

00000000000009e0 <strlen>:

uint
strlen(const char *s)
{
     9e0:	1141                	addi	sp,sp,-16
     9e2:	e422                	sd	s0,8(sp)
     9e4:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     9e6:	00054783          	lbu	a5,0(a0)
     9ea:	cf91                	beqz	a5,a06 <strlen+0x26>
     9ec:	0505                	addi	a0,a0,1
     9ee:	87aa                	mv	a5,a0
     9f0:	4685                	li	a3,1
     9f2:	9e89                	subw	a3,a3,a0
     9f4:	00f6853b          	addw	a0,a3,a5
     9f8:	0785                	addi	a5,a5,1
     9fa:	fff7c703          	lbu	a4,-1(a5)
     9fe:	fb7d                	bnez	a4,9f4 <strlen+0x14>
    ;
  return n;
}
     a00:	6422                	ld	s0,8(sp)
     a02:	0141                	addi	sp,sp,16
     a04:	8082                	ret
  for(n = 0; s[n]; n++)
     a06:	4501                	li	a0,0
     a08:	bfe5                	j	a00 <strlen+0x20>

0000000000000a0a <memset>:

void*
memset(void *dst, int c, uint n)
{
     a0a:	1141                	addi	sp,sp,-16
     a0c:	e422                	sd	s0,8(sp)
     a0e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     a10:	ca19                	beqz	a2,a26 <memset+0x1c>
     a12:	87aa                	mv	a5,a0
     a14:	1602                	slli	a2,a2,0x20
     a16:	9201                	srli	a2,a2,0x20
     a18:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     a1c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     a20:	0785                	addi	a5,a5,1
     a22:	fee79de3          	bne	a5,a4,a1c <memset+0x12>
  }
  return dst;
}
     a26:	6422                	ld	s0,8(sp)
     a28:	0141                	addi	sp,sp,16
     a2a:	8082                	ret

0000000000000a2c <strchr>:

char*
strchr(const char *s, char c)
{
     a2c:	1141                	addi	sp,sp,-16
     a2e:	e422                	sd	s0,8(sp)
     a30:	0800                	addi	s0,sp,16
  for(; *s; s++)
     a32:	00054783          	lbu	a5,0(a0)
     a36:	cb99                	beqz	a5,a4c <strchr+0x20>
    if(*s == c)
     a38:	00f58763          	beq	a1,a5,a46 <strchr+0x1a>
  for(; *s; s++)
     a3c:	0505                	addi	a0,a0,1
     a3e:	00054783          	lbu	a5,0(a0)
     a42:	fbfd                	bnez	a5,a38 <strchr+0xc>
      return (char*)s;
  return 0;
     a44:	4501                	li	a0,0
}
     a46:	6422                	ld	s0,8(sp)
     a48:	0141                	addi	sp,sp,16
     a4a:	8082                	ret
  return 0;
     a4c:	4501                	li	a0,0
     a4e:	bfe5                	j	a46 <strchr+0x1a>

0000000000000a50 <gets>:

char*
gets(char *buf, int max)
{
     a50:	711d                	addi	sp,sp,-96
     a52:	ec86                	sd	ra,88(sp)
     a54:	e8a2                	sd	s0,80(sp)
     a56:	e4a6                	sd	s1,72(sp)
     a58:	e0ca                	sd	s2,64(sp)
     a5a:	fc4e                	sd	s3,56(sp)
     a5c:	f852                	sd	s4,48(sp)
     a5e:	f456                	sd	s5,40(sp)
     a60:	f05a                	sd	s6,32(sp)
     a62:	ec5e                	sd	s7,24(sp)
     a64:	1080                	addi	s0,sp,96
     a66:	8baa                	mv	s7,a0
     a68:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     a6a:	892a                	mv	s2,a0
     a6c:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     a6e:	4aa9                	li	s5,10
     a70:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
     a72:	89a6                	mv	s3,s1
     a74:	2485                	addiw	s1,s1,1
     a76:	0344d663          	bge	s1,s4,aa2 <gets+0x52>
    cc = read(0, &c, 1);
     a7a:	4605                	li	a2,1
     a7c:	faf40593          	addi	a1,s0,-81
     a80:	4501                	li	a0,0
     a82:	186000ef          	jal	ra,c08 <read>
    if(cc < 1)
     a86:	00a05e63          	blez	a0,aa2 <gets+0x52>
    buf[i++] = c;
     a8a:	faf44783          	lbu	a5,-81(s0)
     a8e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     a92:	01578763          	beq	a5,s5,aa0 <gets+0x50>
     a96:	0905                	addi	s2,s2,1
     a98:	fd679de3          	bne	a5,s6,a72 <gets+0x22>
  for(i=0; i+1 < max; ){
     a9c:	89a6                	mv	s3,s1
     a9e:	a011                	j	aa2 <gets+0x52>
     aa0:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
     aa2:	99de                	add	s3,s3,s7
     aa4:	00098023          	sb	zero,0(s3)
  return buf;
}
     aa8:	855e                	mv	a0,s7
     aaa:	60e6                	ld	ra,88(sp)
     aac:	6446                	ld	s0,80(sp)
     aae:	64a6                	ld	s1,72(sp)
     ab0:	6906                	ld	s2,64(sp)
     ab2:	79e2                	ld	s3,56(sp)
     ab4:	7a42                	ld	s4,48(sp)
     ab6:	7aa2                	ld	s5,40(sp)
     ab8:	7b02                	ld	s6,32(sp)
     aba:	6be2                	ld	s7,24(sp)
     abc:	6125                	addi	sp,sp,96
     abe:	8082                	ret

0000000000000ac0 <stat>:

int
stat(const char *n, struct stat *st)
{
     ac0:	1101                	addi	sp,sp,-32
     ac2:	ec06                	sd	ra,24(sp)
     ac4:	e822                	sd	s0,16(sp)
     ac6:	e426                	sd	s1,8(sp)
     ac8:	e04a                	sd	s2,0(sp)
     aca:	1000                	addi	s0,sp,32
     acc:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     ace:	4581                	li	a1,0
     ad0:	160000ef          	jal	ra,c30 <open>
  if(fd < 0)
     ad4:	02054163          	bltz	a0,af6 <stat+0x36>
     ad8:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     ada:	85ca                	mv	a1,s2
     adc:	16c000ef          	jal	ra,c48 <fstat>
     ae0:	892a                	mv	s2,a0
  close(fd);
     ae2:	8526                	mv	a0,s1
     ae4:	134000ef          	jal	ra,c18 <close>
  return r;
}
     ae8:	854a                	mv	a0,s2
     aea:	60e2                	ld	ra,24(sp)
     aec:	6442                	ld	s0,16(sp)
     aee:	64a2                	ld	s1,8(sp)
     af0:	6902                	ld	s2,0(sp)
     af2:	6105                	addi	sp,sp,32
     af4:	8082                	ret
    return -1;
     af6:	597d                	li	s2,-1
     af8:	bfc5                	j	ae8 <stat+0x28>

0000000000000afa <atoi>:

int
atoi(const char *s)
{
     afa:	1141                	addi	sp,sp,-16
     afc:	e422                	sd	s0,8(sp)
     afe:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     b00:	00054683          	lbu	a3,0(a0)
     b04:	fd06879b          	addiw	a5,a3,-48
     b08:	0ff7f793          	zext.b	a5,a5
     b0c:	4625                	li	a2,9
     b0e:	02f66863          	bltu	a2,a5,b3e <atoi+0x44>
     b12:	872a                	mv	a4,a0
  n = 0;
     b14:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
     b16:	0705                	addi	a4,a4,1
     b18:	0025179b          	slliw	a5,a0,0x2
     b1c:	9fa9                	addw	a5,a5,a0
     b1e:	0017979b          	slliw	a5,a5,0x1
     b22:	9fb5                	addw	a5,a5,a3
     b24:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     b28:	00074683          	lbu	a3,0(a4)
     b2c:	fd06879b          	addiw	a5,a3,-48
     b30:	0ff7f793          	zext.b	a5,a5
     b34:	fef671e3          	bgeu	a2,a5,b16 <atoi+0x1c>
  return n;
}
     b38:	6422                	ld	s0,8(sp)
     b3a:	0141                	addi	sp,sp,16
     b3c:	8082                	ret
  n = 0;
     b3e:	4501                	li	a0,0
     b40:	bfe5                	j	b38 <atoi+0x3e>

0000000000000b42 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     b42:	1141                	addi	sp,sp,-16
     b44:	e422                	sd	s0,8(sp)
     b46:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     b48:	02b57463          	bgeu	a0,a1,b70 <memmove+0x2e>
    while(n-- > 0)
     b4c:	00c05f63          	blez	a2,b6a <memmove+0x28>
     b50:	1602                	slli	a2,a2,0x20
     b52:	9201                	srli	a2,a2,0x20
     b54:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     b58:	872a                	mv	a4,a0
      *dst++ = *src++;
     b5a:	0585                	addi	a1,a1,1
     b5c:	0705                	addi	a4,a4,1
     b5e:	fff5c683          	lbu	a3,-1(a1)
     b62:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     b66:	fee79ae3          	bne	a5,a4,b5a <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     b6a:	6422                	ld	s0,8(sp)
     b6c:	0141                	addi	sp,sp,16
     b6e:	8082                	ret
    dst += n;
     b70:	00c50733          	add	a4,a0,a2
    src += n;
     b74:	95b2                	add	a1,a1,a2
    while(n-- > 0)
     b76:	fec05ae3          	blez	a2,b6a <memmove+0x28>
     b7a:	fff6079b          	addiw	a5,a2,-1
     b7e:	1782                	slli	a5,a5,0x20
     b80:	9381                	srli	a5,a5,0x20
     b82:	fff7c793          	not	a5,a5
     b86:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     b88:	15fd                	addi	a1,a1,-1
     b8a:	177d                	addi	a4,a4,-1
     b8c:	0005c683          	lbu	a3,0(a1)
     b90:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     b94:	fee79ae3          	bne	a5,a4,b88 <memmove+0x46>
     b98:	bfc9                	j	b6a <memmove+0x28>

0000000000000b9a <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     b9a:	1141                	addi	sp,sp,-16
     b9c:	e422                	sd	s0,8(sp)
     b9e:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     ba0:	ca05                	beqz	a2,bd0 <memcmp+0x36>
     ba2:	fff6069b          	addiw	a3,a2,-1
     ba6:	1682                	slli	a3,a3,0x20
     ba8:	9281                	srli	a3,a3,0x20
     baa:	0685                	addi	a3,a3,1
     bac:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
     bae:	00054783          	lbu	a5,0(a0)
     bb2:	0005c703          	lbu	a4,0(a1)
     bb6:	00e79863          	bne	a5,a4,bc6 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
     bba:	0505                	addi	a0,a0,1
    p2++;
     bbc:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     bbe:	fed518e3          	bne	a0,a3,bae <memcmp+0x14>
  }
  return 0;
     bc2:	4501                	li	a0,0
     bc4:	a019                	j	bca <memcmp+0x30>
      return *p1 - *p2;
     bc6:	40e7853b          	subw	a0,a5,a4
}
     bca:	6422                	ld	s0,8(sp)
     bcc:	0141                	addi	sp,sp,16
     bce:	8082                	ret
  return 0;
     bd0:	4501                	li	a0,0
     bd2:	bfe5                	j	bca <memcmp+0x30>

0000000000000bd4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     bd4:	1141                	addi	sp,sp,-16
     bd6:	e406                	sd	ra,8(sp)
     bd8:	e022                	sd	s0,0(sp)
     bda:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     bdc:	f67ff0ef          	jal	ra,b42 <memmove>
}
     be0:	60a2                	ld	ra,8(sp)
     be2:	6402                	ld	s0,0(sp)
     be4:	0141                	addi	sp,sp,16
     be6:	8082                	ret

0000000000000be8 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     be8:	4885                	li	a7,1
 ecall
     bea:	00000073          	ecall
 ret
     bee:	8082                	ret

0000000000000bf0 <exit>:
.global exit
exit:
 li a7, SYS_exit
     bf0:	4889                	li	a7,2
 ecall
     bf2:	00000073          	ecall
 ret
     bf6:	8082                	ret

0000000000000bf8 <wait>:
.global wait
wait:
 li a7, SYS_wait
     bf8:	488d                	li	a7,3
 ecall
     bfa:	00000073          	ecall
 ret
     bfe:	8082                	ret

0000000000000c00 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     c00:	4891                	li	a7,4
 ecall
     c02:	00000073          	ecall
 ret
     c06:	8082                	ret

0000000000000c08 <read>:
.global read
read:
 li a7, SYS_read
     c08:	4895                	li	a7,5
 ecall
     c0a:	00000073          	ecall
 ret
     c0e:	8082                	ret

0000000000000c10 <write>:
.global write
write:
 li a7, SYS_write
     c10:	48c1                	li	a7,16
 ecall
     c12:	00000073          	ecall
 ret
     c16:	8082                	ret

0000000000000c18 <close>:
.global close
close:
 li a7, SYS_close
     c18:	48d5                	li	a7,21
 ecall
     c1a:	00000073          	ecall
 ret
     c1e:	8082                	ret

0000000000000c20 <kill>:
.global kill
kill:
 li a7, SYS_kill
     c20:	4899                	li	a7,6
 ecall
     c22:	00000073          	ecall
 ret
     c26:	8082                	ret

0000000000000c28 <exec>:
.global exec
exec:
 li a7, SYS_exec
     c28:	489d                	li	a7,7
 ecall
     c2a:	00000073          	ecall
 ret
     c2e:	8082                	ret

0000000000000c30 <open>:
.global open
open:
 li a7, SYS_open
     c30:	48bd                	li	a7,15
 ecall
     c32:	00000073          	ecall
 ret
     c36:	8082                	ret

0000000000000c38 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     c38:	48c5                	li	a7,17
 ecall
     c3a:	00000073          	ecall
 ret
     c3e:	8082                	ret

0000000000000c40 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     c40:	48c9                	li	a7,18
 ecall
     c42:	00000073          	ecall
 ret
     c46:	8082                	ret

0000000000000c48 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     c48:	48a1                	li	a7,8
 ecall
     c4a:	00000073          	ecall
 ret
     c4e:	8082                	ret

0000000000000c50 <link>:
.global link
link:
 li a7, SYS_link
     c50:	48cd                	li	a7,19
 ecall
     c52:	00000073          	ecall
 ret
     c56:	8082                	ret

0000000000000c58 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     c58:	48d1                	li	a7,20
 ecall
     c5a:	00000073          	ecall
 ret
     c5e:	8082                	ret

0000000000000c60 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     c60:	48a5                	li	a7,9
 ecall
     c62:	00000073          	ecall
 ret
     c66:	8082                	ret

0000000000000c68 <dup>:
.global dup
dup:
 li a7, SYS_dup
     c68:	48a9                	li	a7,10
 ecall
     c6a:	00000073          	ecall
 ret
     c6e:	8082                	ret

0000000000000c70 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     c70:	48ad                	li	a7,11
 ecall
     c72:	00000073          	ecall
 ret
     c76:	8082                	ret

0000000000000c78 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     c78:	48b1                	li	a7,12
 ecall
     c7a:	00000073          	ecall
 ret
     c7e:	8082                	ret

0000000000000c80 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     c80:	48b5                	li	a7,13
 ecall
     c82:	00000073          	ecall
 ret
     c86:	8082                	ret

0000000000000c88 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     c88:	48b9                	li	a7,14
 ecall
     c8a:	00000073          	ecall
 ret
     c8e:	8082                	ret

0000000000000c90 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     c90:	1101                	addi	sp,sp,-32
     c92:	ec06                	sd	ra,24(sp)
     c94:	e822                	sd	s0,16(sp)
     c96:	1000                	addi	s0,sp,32
     c98:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     c9c:	4605                	li	a2,1
     c9e:	fef40593          	addi	a1,s0,-17
     ca2:	f6fff0ef          	jal	ra,c10 <write>
}
     ca6:	60e2                	ld	ra,24(sp)
     ca8:	6442                	ld	s0,16(sp)
     caa:	6105                	addi	sp,sp,32
     cac:	8082                	ret

0000000000000cae <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     cae:	7139                	addi	sp,sp,-64
     cb0:	fc06                	sd	ra,56(sp)
     cb2:	f822                	sd	s0,48(sp)
     cb4:	f426                	sd	s1,40(sp)
     cb6:	f04a                	sd	s2,32(sp)
     cb8:	ec4e                	sd	s3,24(sp)
     cba:	0080                	addi	s0,sp,64
     cbc:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     cbe:	c299                	beqz	a3,cc4 <printint+0x16>
     cc0:	0805c763          	bltz	a1,d4e <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
     cc4:	2581                	sext.w	a1,a1
  neg = 0;
     cc6:	4881                	li	a7,0
     cc8:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
     ccc:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     cce:	2601                	sext.w	a2,a2
     cd0:	00000517          	auipc	a0,0x0
     cd4:	60850513          	addi	a0,a0,1544 # 12d8 <digits>
     cd8:	883a                	mv	a6,a4
     cda:	2705                	addiw	a4,a4,1
     cdc:	02c5f7bb          	remuw	a5,a1,a2
     ce0:	1782                	slli	a5,a5,0x20
     ce2:	9381                	srli	a5,a5,0x20
     ce4:	97aa                	add	a5,a5,a0
     ce6:	0007c783          	lbu	a5,0(a5)
     cea:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     cee:	0005879b          	sext.w	a5,a1
     cf2:	02c5d5bb          	divuw	a1,a1,a2
     cf6:	0685                	addi	a3,a3,1
     cf8:	fec7f0e3          	bgeu	a5,a2,cd8 <printint+0x2a>
  if(neg)
     cfc:	00088c63          	beqz	a7,d14 <printint+0x66>
    buf[i++] = '-';
     d00:	fd070793          	addi	a5,a4,-48
     d04:	00878733          	add	a4,a5,s0
     d08:	02d00793          	li	a5,45
     d0c:	fef70823          	sb	a5,-16(a4)
     d10:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
     d14:	02e05663          	blez	a4,d40 <printint+0x92>
     d18:	fc040793          	addi	a5,s0,-64
     d1c:	00e78933          	add	s2,a5,a4
     d20:	fff78993          	addi	s3,a5,-1
     d24:	99ba                	add	s3,s3,a4
     d26:	377d                	addiw	a4,a4,-1
     d28:	1702                	slli	a4,a4,0x20
     d2a:	9301                	srli	a4,a4,0x20
     d2c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     d30:	fff94583          	lbu	a1,-1(s2)
     d34:	8526                	mv	a0,s1
     d36:	f5bff0ef          	jal	ra,c90 <putc>
  while(--i >= 0)
     d3a:	197d                	addi	s2,s2,-1
     d3c:	ff391ae3          	bne	s2,s3,d30 <printint+0x82>
}
     d40:	70e2                	ld	ra,56(sp)
     d42:	7442                	ld	s0,48(sp)
     d44:	74a2                	ld	s1,40(sp)
     d46:	7902                	ld	s2,32(sp)
     d48:	69e2                	ld	s3,24(sp)
     d4a:	6121                	addi	sp,sp,64
     d4c:	8082                	ret
    x = -xx;
     d4e:	40b005bb          	negw	a1,a1
    neg = 1;
     d52:	4885                	li	a7,1
    x = -xx;
     d54:	bf95                	j	cc8 <printint+0x1a>

0000000000000d56 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     d56:	7119                	addi	sp,sp,-128
     d58:	fc86                	sd	ra,120(sp)
     d5a:	f8a2                	sd	s0,112(sp)
     d5c:	f4a6                	sd	s1,104(sp)
     d5e:	f0ca                	sd	s2,96(sp)
     d60:	ecce                	sd	s3,88(sp)
     d62:	e8d2                	sd	s4,80(sp)
     d64:	e4d6                	sd	s5,72(sp)
     d66:	e0da                	sd	s6,64(sp)
     d68:	fc5e                	sd	s7,56(sp)
     d6a:	f862                	sd	s8,48(sp)
     d6c:	f466                	sd	s9,40(sp)
     d6e:	f06a                	sd	s10,32(sp)
     d70:	ec6e                	sd	s11,24(sp)
     d72:	0100                	addi	s0,sp,128
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     d74:	0005c903          	lbu	s2,0(a1)
     d78:	22090e63          	beqz	s2,fb4 <vprintf+0x25e>
     d7c:	8b2a                	mv	s6,a0
     d7e:	8a2e                	mv	s4,a1
     d80:	8bb2                	mv	s7,a2
  state = 0;
     d82:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
     d84:	4481                	li	s1,0
     d86:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
     d88:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
     d8c:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
     d90:	06c00d13          	li	s10,108
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
     d94:	07500d93          	li	s11,117
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     d98:	00000c97          	auipc	s9,0x0
     d9c:	540c8c93          	addi	s9,s9,1344 # 12d8 <digits>
     da0:	a005                	j	dc0 <vprintf+0x6a>
        putc(fd, c0);
     da2:	85ca                	mv	a1,s2
     da4:	855a                	mv	a0,s6
     da6:	eebff0ef          	jal	ra,c90 <putc>
     daa:	a019                	j	db0 <vprintf+0x5a>
    } else if(state == '%'){
     dac:	03598263          	beq	s3,s5,dd0 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
     db0:	2485                	addiw	s1,s1,1
     db2:	8726                	mv	a4,s1
     db4:	009a07b3          	add	a5,s4,s1
     db8:	0007c903          	lbu	s2,0(a5)
     dbc:	1e090c63          	beqz	s2,fb4 <vprintf+0x25e>
    c0 = fmt[i] & 0xff;
     dc0:	0009079b          	sext.w	a5,s2
    if(state == 0){
     dc4:	fe0994e3          	bnez	s3,dac <vprintf+0x56>
      if(c0 == '%'){
     dc8:	fd579de3          	bne	a5,s5,da2 <vprintf+0x4c>
        state = '%';
     dcc:	89be                	mv	s3,a5
     dce:	b7cd                	j	db0 <vprintf+0x5a>
      if(c0) c1 = fmt[i+1] & 0xff;
     dd0:	cfa5                	beqz	a5,e48 <vprintf+0xf2>
     dd2:	00ea06b3          	add	a3,s4,a4
     dd6:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
     dda:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
     ddc:	c681                	beqz	a3,de4 <vprintf+0x8e>
     dde:	9752                	add	a4,a4,s4
     de0:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
     de4:	03878a63          	beq	a5,s8,e18 <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
     de8:	05a78463          	beq	a5,s10,e30 <vprintf+0xda>
      } else if(c0 == 'u'){
     dec:	0db78763          	beq	a5,s11,eba <vprintf+0x164>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
     df0:	07800713          	li	a4,120
     df4:	10e78963          	beq	a5,a4,f06 <vprintf+0x1b0>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
     df8:	07000713          	li	a4,112
     dfc:	12e78e63          	beq	a5,a4,f38 <vprintf+0x1e2>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
     e00:	07300713          	li	a4,115
     e04:	16e78b63          	beq	a5,a4,f7a <vprintf+0x224>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
     e08:	05579063          	bne	a5,s5,e48 <vprintf+0xf2>
        putc(fd, '%');
     e0c:	85d6                	mv	a1,s5
     e0e:	855a                	mv	a0,s6
     e10:	e81ff0ef          	jal	ra,c90 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
     e14:	4981                	li	s3,0
     e16:	bf69                	j	db0 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 1);
     e18:	008b8913          	addi	s2,s7,8
     e1c:	4685                	li	a3,1
     e1e:	4629                	li	a2,10
     e20:	000ba583          	lw	a1,0(s7)
     e24:	855a                	mv	a0,s6
     e26:	e89ff0ef          	jal	ra,cae <printint>
     e2a:	8bca                	mv	s7,s2
      state = 0;
     e2c:	4981                	li	s3,0
     e2e:	b749                	j	db0 <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'd'){
     e30:	03868663          	beq	a3,s8,e5c <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
     e34:	05a68163          	beq	a3,s10,e76 <vprintf+0x120>
      } else if(c0 == 'l' && c1 == 'u'){
     e38:	09b68d63          	beq	a3,s11,ed2 <vprintf+0x17c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
     e3c:	03a68f63          	beq	a3,s10,e7a <vprintf+0x124>
      } else if(c0 == 'l' && c1 == 'x'){
     e40:	07800793          	li	a5,120
     e44:	0cf68d63          	beq	a3,a5,f1e <vprintf+0x1c8>
        putc(fd, '%');
     e48:	85d6                	mv	a1,s5
     e4a:	855a                	mv	a0,s6
     e4c:	e45ff0ef          	jal	ra,c90 <putc>
        putc(fd, c0);
     e50:	85ca                	mv	a1,s2
     e52:	855a                	mv	a0,s6
     e54:	e3dff0ef          	jal	ra,c90 <putc>
      state = 0;
     e58:	4981                	li	s3,0
     e5a:	bf99                	j	db0 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
     e5c:	008b8913          	addi	s2,s7,8
     e60:	4685                	li	a3,1
     e62:	4629                	li	a2,10
     e64:	000ba583          	lw	a1,0(s7)
     e68:	855a                	mv	a0,s6
     e6a:	e45ff0ef          	jal	ra,cae <printint>
        i += 1;
     e6e:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
     e70:	8bca                	mv	s7,s2
      state = 0;
     e72:	4981                	li	s3,0
        i += 1;
     e74:	bf35                	j	db0 <vprintf+0x5a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
     e76:	03860563          	beq	a2,s8,ea0 <vprintf+0x14a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
     e7a:	07b60963          	beq	a2,s11,eec <vprintf+0x196>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
     e7e:	07800793          	li	a5,120
     e82:	fcf613e3          	bne	a2,a5,e48 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
     e86:	008b8913          	addi	s2,s7,8
     e8a:	4681                	li	a3,0
     e8c:	4641                	li	a2,16
     e8e:	000ba583          	lw	a1,0(s7)
     e92:	855a                	mv	a0,s6
     e94:	e1bff0ef          	jal	ra,cae <printint>
        i += 2;
     e98:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
     e9a:	8bca                	mv	s7,s2
      state = 0;
     e9c:	4981                	li	s3,0
        i += 2;
     e9e:	bf09                	j	db0 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 1);
     ea0:	008b8913          	addi	s2,s7,8
     ea4:	4685                	li	a3,1
     ea6:	4629                	li	a2,10
     ea8:	000ba583          	lw	a1,0(s7)
     eac:	855a                	mv	a0,s6
     eae:	e01ff0ef          	jal	ra,cae <printint>
        i += 2;
     eb2:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
     eb4:	8bca                	mv	s7,s2
      state = 0;
     eb6:	4981                	li	s3,0
        i += 2;
     eb8:	bde5                	j	db0 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 10, 0);
     eba:	008b8913          	addi	s2,s7,8
     ebe:	4681                	li	a3,0
     ec0:	4629                	li	a2,10
     ec2:	000ba583          	lw	a1,0(s7)
     ec6:	855a                	mv	a0,s6
     ec8:	de7ff0ef          	jal	ra,cae <printint>
     ecc:	8bca                	mv	s7,s2
      state = 0;
     ece:	4981                	li	s3,0
     ed0:	b5c5                	j	db0 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
     ed2:	008b8913          	addi	s2,s7,8
     ed6:	4681                	li	a3,0
     ed8:	4629                	li	a2,10
     eda:	000ba583          	lw	a1,0(s7)
     ede:	855a                	mv	a0,s6
     ee0:	dcfff0ef          	jal	ra,cae <printint>
        i += 1;
     ee4:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
     ee6:	8bca                	mv	s7,s2
      state = 0;
     ee8:	4981                	li	s3,0
        i += 1;
     eea:	b5d9                	j	db0 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 10, 0);
     eec:	008b8913          	addi	s2,s7,8
     ef0:	4681                	li	a3,0
     ef2:	4629                	li	a2,10
     ef4:	000ba583          	lw	a1,0(s7)
     ef8:	855a                	mv	a0,s6
     efa:	db5ff0ef          	jal	ra,cae <printint>
        i += 2;
     efe:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
     f00:	8bca                	mv	s7,s2
      state = 0;
     f02:	4981                	li	s3,0
        i += 2;
     f04:	b575                	j	db0 <vprintf+0x5a>
        printint(fd, va_arg(ap, int), 16, 0);
     f06:	008b8913          	addi	s2,s7,8
     f0a:	4681                	li	a3,0
     f0c:	4641                	li	a2,16
     f0e:	000ba583          	lw	a1,0(s7)
     f12:	855a                	mv	a0,s6
     f14:	d9bff0ef          	jal	ra,cae <printint>
     f18:	8bca                	mv	s7,s2
      state = 0;
     f1a:	4981                	li	s3,0
     f1c:	bd51                	j	db0 <vprintf+0x5a>
        printint(fd, va_arg(ap, uint64), 16, 0);
     f1e:	008b8913          	addi	s2,s7,8
     f22:	4681                	li	a3,0
     f24:	4641                	li	a2,16
     f26:	000ba583          	lw	a1,0(s7)
     f2a:	855a                	mv	a0,s6
     f2c:	d83ff0ef          	jal	ra,cae <printint>
        i += 1;
     f30:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
     f32:	8bca                	mv	s7,s2
      state = 0;
     f34:	4981                	li	s3,0
        i += 1;
     f36:	bdad                	j	db0 <vprintf+0x5a>
        printptr(fd, va_arg(ap, uint64));
     f38:	008b8793          	addi	a5,s7,8
     f3c:	f8f43423          	sd	a5,-120(s0)
     f40:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
     f44:	03000593          	li	a1,48
     f48:	855a                	mv	a0,s6
     f4a:	d47ff0ef          	jal	ra,c90 <putc>
  putc(fd, 'x');
     f4e:	07800593          	li	a1,120
     f52:	855a                	mv	a0,s6
     f54:	d3dff0ef          	jal	ra,c90 <putc>
     f58:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     f5a:	03c9d793          	srli	a5,s3,0x3c
     f5e:	97e6                	add	a5,a5,s9
     f60:	0007c583          	lbu	a1,0(a5)
     f64:	855a                	mv	a0,s6
     f66:	d2bff0ef          	jal	ra,c90 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
     f6a:	0992                	slli	s3,s3,0x4
     f6c:	397d                	addiw	s2,s2,-1
     f6e:	fe0916e3          	bnez	s2,f5a <vprintf+0x204>
        printptr(fd, va_arg(ap, uint64));
     f72:	f8843b83          	ld	s7,-120(s0)
      state = 0;
     f76:	4981                	li	s3,0
     f78:	bd25                	j	db0 <vprintf+0x5a>
        if((s = va_arg(ap, char*)) == 0)
     f7a:	008b8993          	addi	s3,s7,8
     f7e:	000bb903          	ld	s2,0(s7)
     f82:	00090f63          	beqz	s2,fa0 <vprintf+0x24a>
        for(; *s; s++)
     f86:	00094583          	lbu	a1,0(s2)
     f8a:	c195                	beqz	a1,fae <vprintf+0x258>
          putc(fd, *s);
     f8c:	855a                	mv	a0,s6
     f8e:	d03ff0ef          	jal	ra,c90 <putc>
        for(; *s; s++)
     f92:	0905                	addi	s2,s2,1
     f94:	00094583          	lbu	a1,0(s2)
     f98:	f9f5                	bnez	a1,f8c <vprintf+0x236>
        if((s = va_arg(ap, char*)) == 0)
     f9a:	8bce                	mv	s7,s3
      state = 0;
     f9c:	4981                	li	s3,0
     f9e:	bd09                	j	db0 <vprintf+0x5a>
          s = "(null)";
     fa0:	00000917          	auipc	s2,0x0
     fa4:	33090913          	addi	s2,s2,816 # 12d0 <malloc+0x220>
        for(; *s; s++)
     fa8:	02800593          	li	a1,40
     fac:	b7c5                	j	f8c <vprintf+0x236>
        if((s = va_arg(ap, char*)) == 0)
     fae:	8bce                	mv	s7,s3
      state = 0;
     fb0:	4981                	li	s3,0
     fb2:	bbfd                	j	db0 <vprintf+0x5a>
    }
  }
}
     fb4:	70e6                	ld	ra,120(sp)
     fb6:	7446                	ld	s0,112(sp)
     fb8:	74a6                	ld	s1,104(sp)
     fba:	7906                	ld	s2,96(sp)
     fbc:	69e6                	ld	s3,88(sp)
     fbe:	6a46                	ld	s4,80(sp)
     fc0:	6aa6                	ld	s5,72(sp)
     fc2:	6b06                	ld	s6,64(sp)
     fc4:	7be2                	ld	s7,56(sp)
     fc6:	7c42                	ld	s8,48(sp)
     fc8:	7ca2                	ld	s9,40(sp)
     fca:	7d02                	ld	s10,32(sp)
     fcc:	6de2                	ld	s11,24(sp)
     fce:	6109                	addi	sp,sp,128
     fd0:	8082                	ret

0000000000000fd2 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
     fd2:	715d                	addi	sp,sp,-80
     fd4:	ec06                	sd	ra,24(sp)
     fd6:	e822                	sd	s0,16(sp)
     fd8:	1000                	addi	s0,sp,32
     fda:	e010                	sd	a2,0(s0)
     fdc:	e414                	sd	a3,8(s0)
     fde:	e818                	sd	a4,16(s0)
     fe0:	ec1c                	sd	a5,24(s0)
     fe2:	03043023          	sd	a6,32(s0)
     fe6:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
     fea:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
     fee:	8622                	mv	a2,s0
     ff0:	d67ff0ef          	jal	ra,d56 <vprintf>
}
     ff4:	60e2                	ld	ra,24(sp)
     ff6:	6442                	ld	s0,16(sp)
     ff8:	6161                	addi	sp,sp,80
     ffa:	8082                	ret

0000000000000ffc <printf>:

void
printf(const char *fmt, ...)
{
     ffc:	711d                	addi	sp,sp,-96
     ffe:	ec06                	sd	ra,24(sp)
    1000:	e822                	sd	s0,16(sp)
    1002:	1000                	addi	s0,sp,32
    1004:	e40c                	sd	a1,8(s0)
    1006:	e810                	sd	a2,16(s0)
    1008:	ec14                	sd	a3,24(s0)
    100a:	f018                	sd	a4,32(s0)
    100c:	f41c                	sd	a5,40(s0)
    100e:	03043823          	sd	a6,48(s0)
    1012:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    1016:	00840613          	addi	a2,s0,8
    101a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    101e:	85aa                	mv	a1,a0
    1020:	4505                	li	a0,1
    1022:	d35ff0ef          	jal	ra,d56 <vprintf>
}
    1026:	60e2                	ld	ra,24(sp)
    1028:	6442                	ld	s0,16(sp)
    102a:	6125                	addi	sp,sp,96
    102c:	8082                	ret

000000000000102e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    102e:	1141                	addi	sp,sp,-16
    1030:	e422                	sd	s0,8(sp)
    1032:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1034:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1038:	00001797          	auipc	a5,0x1
    103c:	fd87b783          	ld	a5,-40(a5) # 2010 <freep>
    1040:	a02d                	j	106a <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    1042:	4618                	lw	a4,8(a2)
    1044:	9f2d                	addw	a4,a4,a1
    1046:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    104a:	6398                	ld	a4,0(a5)
    104c:	6310                	ld	a2,0(a4)
    104e:	a83d                	j	108c <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    1050:	ff852703          	lw	a4,-8(a0)
    1054:	9f31                	addw	a4,a4,a2
    1056:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    1058:	ff053683          	ld	a3,-16(a0)
    105c:	a091                	j	10a0 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    105e:	6398                	ld	a4,0(a5)
    1060:	00e7e463          	bltu	a5,a4,1068 <free+0x3a>
    1064:	00e6ea63          	bltu	a3,a4,1078 <free+0x4a>
{
    1068:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    106a:	fed7fae3          	bgeu	a5,a3,105e <free+0x30>
    106e:	6398                	ld	a4,0(a5)
    1070:	00e6e463          	bltu	a3,a4,1078 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1074:	fee7eae3          	bltu	a5,a4,1068 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
    1078:	ff852583          	lw	a1,-8(a0)
    107c:	6390                	ld	a2,0(a5)
    107e:	02059813          	slli	a6,a1,0x20
    1082:	01c85713          	srli	a4,a6,0x1c
    1086:	9736                	add	a4,a4,a3
    1088:	fae60de3          	beq	a2,a4,1042 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
    108c:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    1090:	4790                	lw	a2,8(a5)
    1092:	02061593          	slli	a1,a2,0x20
    1096:	01c5d713          	srli	a4,a1,0x1c
    109a:	973e                	add	a4,a4,a5
    109c:	fae68ae3          	beq	a3,a4,1050 <free+0x22>
    p->s.ptr = bp->s.ptr;
    10a0:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    10a2:	00001717          	auipc	a4,0x1
    10a6:	f6f73723          	sd	a5,-146(a4) # 2010 <freep>
}
    10aa:	6422                	ld	s0,8(sp)
    10ac:	0141                	addi	sp,sp,16
    10ae:	8082                	ret

00000000000010b0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    10b0:	7139                	addi	sp,sp,-64
    10b2:	fc06                	sd	ra,56(sp)
    10b4:	f822                	sd	s0,48(sp)
    10b6:	f426                	sd	s1,40(sp)
    10b8:	f04a                	sd	s2,32(sp)
    10ba:	ec4e                	sd	s3,24(sp)
    10bc:	e852                	sd	s4,16(sp)
    10be:	e456                	sd	s5,8(sp)
    10c0:	e05a                	sd	s6,0(sp)
    10c2:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    10c4:	02051493          	slli	s1,a0,0x20
    10c8:	9081                	srli	s1,s1,0x20
    10ca:	04bd                	addi	s1,s1,15
    10cc:	8091                	srli	s1,s1,0x4
    10ce:	0014899b          	addiw	s3,s1,1
    10d2:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    10d4:	00001517          	auipc	a0,0x1
    10d8:	f3c53503          	ld	a0,-196(a0) # 2010 <freep>
    10dc:	c515                	beqz	a0,1108 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    10de:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    10e0:	4798                	lw	a4,8(a5)
    10e2:	02977f63          	bgeu	a4,s1,1120 <malloc+0x70>
    10e6:	8a4e                	mv	s4,s3
    10e8:	0009871b          	sext.w	a4,s3
    10ec:	6685                	lui	a3,0x1
    10ee:	00d77363          	bgeu	a4,a3,10f4 <malloc+0x44>
    10f2:	6a05                	lui	s4,0x1
    10f4:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    10f8:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    10fc:	00001917          	auipc	s2,0x1
    1100:	f1490913          	addi	s2,s2,-236 # 2010 <freep>
  if(p == (char*)-1)
    1104:	5afd                	li	s5,-1
    1106:	a885                	j	1176 <malloc+0xc6>
    base.s.ptr = freep = prevp = &base;
    1108:	00001797          	auipc	a5,0x1
    110c:	f8078793          	addi	a5,a5,-128 # 2088 <base>
    1110:	00001717          	auipc	a4,0x1
    1114:	f0f73023          	sd	a5,-256(a4) # 2010 <freep>
    1118:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    111a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    111e:	b7e1                	j	10e6 <malloc+0x36>
      if(p->s.size == nunits)
    1120:	02e48c63          	beq	s1,a4,1158 <malloc+0xa8>
        p->s.size -= nunits;
    1124:	4137073b          	subw	a4,a4,s3
    1128:	c798                	sw	a4,8(a5)
        p += p->s.size;
    112a:	02071693          	slli	a3,a4,0x20
    112e:	01c6d713          	srli	a4,a3,0x1c
    1132:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    1134:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    1138:	00001717          	auipc	a4,0x1
    113c:	eca73c23          	sd	a0,-296(a4) # 2010 <freep>
      return (void*)(p + 1);
    1140:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    1144:	70e2                	ld	ra,56(sp)
    1146:	7442                	ld	s0,48(sp)
    1148:	74a2                	ld	s1,40(sp)
    114a:	7902                	ld	s2,32(sp)
    114c:	69e2                	ld	s3,24(sp)
    114e:	6a42                	ld	s4,16(sp)
    1150:	6aa2                	ld	s5,8(sp)
    1152:	6b02                	ld	s6,0(sp)
    1154:	6121                	addi	sp,sp,64
    1156:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    1158:	6398                	ld	a4,0(a5)
    115a:	e118                	sd	a4,0(a0)
    115c:	bff1                	j	1138 <malloc+0x88>
  hp->s.size = nu;
    115e:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    1162:	0541                	addi	a0,a0,16
    1164:	ecbff0ef          	jal	ra,102e <free>
  return freep;
    1168:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    116c:	dd61                	beqz	a0,1144 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    116e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1170:	4798                	lw	a4,8(a5)
    1172:	fa9777e3          	bgeu	a4,s1,1120 <malloc+0x70>
    if(p == freep)
    1176:	00093703          	ld	a4,0(s2)
    117a:	853e                	mv	a0,a5
    117c:	fef719e3          	bne	a4,a5,116e <malloc+0xbe>
  p = sbrk(nu * sizeof(Header));
    1180:	8552                	mv	a0,s4
    1182:	af7ff0ef          	jal	ra,c78 <sbrk>
  if(p == (char*)-1)
    1186:	fd551ce3          	bne	a0,s5,115e <malloc+0xae>
        return 0;
    118a:	4501                	li	a0,0
    118c:	bf65                	j	1144 <malloc+0x94>
