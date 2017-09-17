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

int main(int ac, char **av)
{
	struct sockaddr_in6 sin6;
	int plen, fd, ret, off;
	char *data;

	if (ac < 4) {
		fprintf(stderr, "Usage: %s localip port plen\n", av[0]);
		return -1;
	}

	plen = atoi(av[3]);
	data = malloc(plen);
	if (!data) {
		perror("malloc");
		return -1;
	}

	fd = open("/dev/urandom", O_RDONLY);
	if (fd < 0) {
		perror("open");
		goto out_free;
	}

	off = 0;
	do {
		ret = read(fd, data + off, plen - off);
		if (ret < 0) {
			perror("read");
			goto out_close;
		}
		off += ret;
	} while (off < plen);

	close(fd);

	memset(&sin6, 0, sizeof(sin6));

	fd = socket(AF_INET6, SOCK_STREAM, IPPROTO_TCP);
	if (fd < 0) {
		perror("socket");
		goto out_free;
	}

	if (setsockopt(fd, SOL_SOCKET, SO_REUSEADDR, &(int){ 1 }, sizeof(int)) < 0) {
		perror("setsockopt(SO_REUSEADDR)");
		goto out_close;
	}

	if (setsockopt(fd, IPPROTO_TCP, TCP_NODELAY, &(int){ 1 }, sizeof(int)) < 0) {
		perror("setsockopt(TCP_NODELAY)");
		goto out_close;
	}

	sin6.sin6_family = AF_INET6;
	inet_pton(AF_INET6, av[1], &sin6.sin6_addr.s6_addr);
	sin6.sin6_port = htons(atoi(av[2]));

	if (bind(fd, (struct sockaddr *)&sin6, sizeof(sin6)) < 0) {
		perror("bind");
		goto out_close;
	}

	if (listen(fd, 5) < 0) {
		perror("listen");
		goto out_close;
	}

	for (;;) {
		char req[100];
		int cfd;

		cfd = accept(fd, NULL, NULL);
		if (cfd < 0) {
			perror("accept");
			goto out_close;
		}

		off = 0;
		do {
			ret = recv(cfd, req + off, 100 - off, 0);
			if (ret < 0) {
				perror("recv");
				close(cfd);
				goto out_close;
			}
			off += ret;
		} while (off < 100);

		off = 0;
		do {
			ret = send(cfd, data + off, plen - off, 0);
			if (ret < 0) {
				perror("send");
				close(cfd);
				goto out_close;
			}
			off += ret;
		} while (off < plen);

		close(cfd);
	}

out_close:
	close(fd);
out_free:
	free(data);
	return -1;
}
