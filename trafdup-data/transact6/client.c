#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <sys/types.h>
#include <fcntl.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <errno.h>
#include <netinet/tcp.h>
#include <sys/time.h>

static unsigned long getusdiff(struct timeval *t1, struct timeval *t2)
{
	struct timeval tmp;

	timersub(t1, t2, &tmp);
	return (tmp.tv_sec * 1000000) + tmp.tv_usec;
}

int main(int ac, char **av)
{
	struct sockaddr_in6 sin6;
	int plen, fd, ret, off;
	struct timeval t1, t2;
	char req[100];
	int err = -1;
	char *data;

	if (ac < 4) {
		fprintf(stderr, "Usage: %s remoteip port plen\n", av[0]);
		return -1;
	}

	plen = atoi(av[3]);
	data = malloc(plen);
	if (!data) {
		perror("malloc");
		return -1;
	}

	memset(&sin6, 0, sizeof(sin6));

	fd = socket(AF_INET6, SOCK_STREAM, IPPROTO_TCP);
	if (fd < 0) {
		perror("socket");
		goto out_free;
	}

	if (setsockopt(fd, IPPROTO_TCP, TCP_NODELAY, &(int){ 1 }, sizeof(int)) < 0) {
		perror("setsockopt(TCP_NODELAY)");
		goto out_close;
	}

	sin6.sin6_family = AF_INET6;
	inet_pton(AF_INET6, av[1], &sin6.sin6_addr.s6_addr);
	sin6.sin6_port = htons(atoi(av[2]));

	if (connect(fd, (struct sockaddr *)&sin6, sizeof(sin6)) < 0) {
		perror("connect");
		goto out_close;
	}

	memset(req, 0x42, 100);

	gettimeofday(&t1, NULL);

	off = 0;
	do {
		ret = send(fd, req + off, 100 - off, 0);
		if (ret < 0) {
			perror("send");
			goto out_close;
		}
		off += ret;
	} while (off < 100);

	off = 0;
	do {
		ret = recv(fd, data + off, plen - off, 0);
		if (ret < 0) {
			perror("recv");
			goto out_close;
		}
		off += ret;
	} while (off < plen);

	gettimeofday(&t2, NULL);

	printf("%lu\n", getusdiff(&t2, &t1));

	err = 0;

out_close:
	close(fd);
out_free:
	free(data);
	return err;
}
