#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"
#include "kernel/fcntl.h"

char* fmtname(char *path);

void
find(char* dir, char* fname) {
	// static char buff[DIRSIZ+1];
	char buff[512], *p;
	char buf1[DIRSIZ+1], buf2[DIRSIZ+1];
	int fd;
	struct stat st;
	struct dirent de;	

	// Open up current directory
	fd = open(dir, O_RDONLY);
	if (fd < 0) {
		fprintf(2, "find: err cannot open %s\n", dir);
		return;
	}
	if (fstat(fd, &st) < 0) {
		fprintf(2, "find: err getting dir %s stat\n", dir);
		close(fd);
		return;
	}

	// Choose next move depending on type of st
	switch(st.type) {
		case T_DEVICE: // Don't care abt devices
		case T_FILE:
			// Want to check against our target name
			// printf("Looking at file %s\n", fmtname(dir));
			// printf("File %s == %s : %d\n", fmtname(dir), fmtname(fname), strcmp(fmtname(dir), fmtname(fname)));
			strcpy(buf1, fmtname(dir));
			strcpy(buf2, fmtname(fname));
			if (strcmp(buf1, buf2) == 0) {
				printf("%s\n", dir);
			}
			break;
		case T_DIR:
			// Go recursively through directories
			// if (strlen(dir) + 1 + DIRSIZ + 1 > sizeof(buff)) {
			// 	fprintf(2, "find: err path too long\n");
			// 	break;
			// } 
			strcpy(buff, dir);
			p = buff + strlen(buff);
			*p++ = '/';
			while (read(fd, &de, sizeof(de)) == sizeof(de)) {
				// printf("Read %lu bytes\n", sizeof(de));
				if (de.inum == 0)
    				continue;

				// printf("dir %s\n", de.name);
				// Moving current de into existing buffer w/ full directory
				memmove(p, de.name, DIRSIZ);
      			p[DIRSIZ] = 0;

				if (strcmp(de.name, ".") != 0
					&& strcmp(de.name, "..") != 0) {
						// printf("Going into %s, de.name == . : %d, de.name == .. : %d\n", de.name, strcmp(de.name,"."), strcmp(de.name, ".."));
						// printf("Going into constructed path: %s\n", buff);
					
						find(buff, fname);
				}
			} // EndWhile
	} // EndSwitch

	close(fd);
}

int
main(int argc, char* argv[]) {
	// Inits
	
	if (argc < 2) {
		fprintf(2, "Usage: find <source_dir> <filename>");
		exit(1);
	} else {
		find(argv[1], argv[2]);
	}

	exit(0);
}

char*
fmtname(char *path)
{
  static char buf[DIRSIZ+1];
  char *p;

  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
    ;
  p++;

  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
    return p;
  memmove(buf, p, strlen(p));
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  return buf;
}