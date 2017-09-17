#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/time.h>
#include <semaphore.h>

#include "srdb.h"

const char *nodes[] = { "STTL", "SNVA", "LOSA", "DENV", "KSCY", "HSTN", "CHIN",
			"IPLS", "ATLA", "WASH", "NYCM" };

const char *addrs[] = { "fc00:1::1", "fc00:2::1", "fc00:3::1", "fc00:4::1",
			"fc00:5::1", "fc00:6::1", "fc00:7::1", "fc00:8::1",
			"fc00:9::1", "fc00:10::1", "fc00:11::1" };

sem_t stop;
char nreqs[16];

static struct ovsdb_config ovsdb_conf = {
	.ovsdb_server 	= "tcp:[::1]:6640",
	.ovsdb_database	= "SR_test",
	.ntransacts	= 1,
};

void init_srandom(void)
{
	struct timeval tv;
	unsigned long junk;

	gettimeofday(&tv, NULL);

	srandom(getpid() ^ tv.tv_sec ^ tv.tv_usec ^ junk);
}

void select_srcdst(int *src, int *dst)
{
	int _src, _dst;

	_src = random() % 11;
	_dst = random() % 10;

	if (_dst >= _src)
		_dst = (_dst + 1) % 11;

	*src = _src;
	*dst = _dst;
}

void send_reqs(struct srdb *srdb, int reqs, int delay)
{
	struct srdb_flowreq_entry freq;
	struct srdb_table *tbl;
	struct timeval tv;
	int i, src, dst;

	tbl = srdb_table_by_name(srdb->tables, "FlowReq");

	freq.destination[0] = 0;
	freq.source[0] = 0;
	freq.bandwidth = 0;
	freq.delay = 0;
	freq.proxy[0] = 0;
	freq.status = 0;

	for (i = 0; i < reqs; i++) {
		select_srcdst(&src, &dst);
		sprintf(freq.request_id, "%d", i+1);
		strcpy(freq.router, nodes[src]);
		strcpy(freq.dstaddr, addrs[dst]);

		gettimeofday(&tv, NULL);
		printf(">> %ld.%ld REQ #%d\n", tv.tv_sec, tv.tv_usec, i+1);
		srdb_insert_sync(srdb, tbl, (struct srdb_entry *)&freq, NULL);

		if (delay)
			usleep(delay);
	}
}

int flowstate_read(struct srdb_entry *entry)
{
	struct srdb_flow_entry *flow_entry;
	struct timeval tv;

	gettimeofday(&tv, NULL);

	flow_entry = (struct srdb_flow_entry *)entry;

	printf("<< %ld.%ld RESPONSE #%s\n", tv.tv_sec, tv.tv_usec,
		flow_entry->request_id);

	if (!strcmp(flow_entry->request_id, nreqs))
		sem_post(&stop);

	return 0;
}

int main(int ac, char **av)
{
	struct srdb *srdb;

	if (ac != 3) {
		fprintf(stderr, "Usage: %s reqs delay\n", av[0]);
		return -1;
	}

	init_srandom();

	sem_init(&stop, 0, 0);

	srdb = srdb_new(&ovsdb_conf);

	strcpy(nreqs, av[1]);

	srdb_monitor(srdb, "FlowState", MON_INSERT, flowstate_read, NULL, NULL,
		     false, true);

	send_reqs(srdb, atoi(av[1]), atoi(av[2]));

	sem_wait(&stop);

	srdb_destroy(srdb);

	return 0;
}
