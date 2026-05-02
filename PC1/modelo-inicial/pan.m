#define rand	pan_rand
#define pthread_equal(a,b)	((a)==(b))
#if defined(HAS_CODE) && defined(VERBOSE)
	#ifdef BFS_PAR
		bfs_printf("Pr: %d Tr: %d\n", II, t->forw);
	#else
		cpu_printf("Pr: %d Tr: %d\n", II, t->forw);
	#endif
#endif
	switch (t->forw) {
	default: Uerror("bad forward move");
	case 0:	/* if without executable clauses */
		continue;
	case 1: /* generic 'goto' or 'skip' */
		IfNotBlocked
		_m = 3; goto P999;
	case 2: /* generic 'else' */
		IfNotBlocked
		if (trpt->o_pm&1) continue;
		_m = 3; goto P999;

		 /* PROC :init: */
	case 3: // STATE 1 - trabajo.pml:183 - [(run Reader())] (0:0:0 - 1)
		IfNotBlocked
		reached[7][1] = 1;
		if (!(addproc(II, 1, 0, 0)))
			continue;
		_m = 3; goto P999; /* 0 */
	case 4: // STATE 2 - trabajo.pml:187 - [((i<3))] (0:0:0 - 1)
		IfNotBlocked
		reached[7][2] = 1;
		if (!((((int)((P7 *)_this)->i)<3)))
			continue;
		_m = 3; goto P999; /* 0 */
	case 5: // STATE 3 - trabajo.pml:188 - [(run Worker(i))] (0:0:0 - 1)
		IfNotBlocked
		reached[7][3] = 1;
		if (!(addproc(II, 1, 1, ((int)((P7 *)_this)->i))))
			continue;
		_m = 3; goto P999; /* 0 */
	case 6: // STATE 4 - trabajo.pml:189 - [i = (i+1)] (0:0:1 - 1)
		IfNotBlocked
		reached[7][4] = 1;
		(trpt+1)->bup.oval = ((int)((P7 *)_this)->i);
		((P7 *)_this)->i = (((int)((P7 *)_this)->i)+1);
#ifdef VAR_RANGES
		logval(":init::i", ((int)((P7 *)_this)->i));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 7: // STATE 10 - trabajo.pml:196 - [j = 0] (0:17:2 - 3)
		IfNotBlocked
		reached[7][10] = 1;
		(trpt+1)->bup.ovals = grab_ints(2);
		(trpt+1)->bup.ovals[0] = ((int)((P7 *)_this)->j);
		((P7 *)_this)->j = 0;
#ifdef VAR_RANGES
		logval(":init::j", ((int)((P7 *)_this)->j));
#endif
		;
		/* merge: k = 0(17, 11, 17) */
		reached[7][11] = 1;
		(trpt+1)->bup.ovals[1] = ((int)((P7 *)_this)->k);
		((P7 *)_this)->k = 0;
#ifdef VAR_RANGES
		logval(":init::k", ((int)((P7 *)_this)->k));
#endif
		;
		/* merge: .(goto)(0, 18, 17) */
		reached[7][18] = 1;
		;
		_m = 3; goto P999; /* 2 */
	case 8: // STATE 12 - trabajo.pml:198 - [((j<3))] (0:0:0 - 1)
		IfNotBlocked
		reached[7][12] = 1;
		if (!((((int)((P7 *)_this)->j)<3)))
			continue;
		_m = 3; goto P999; /* 0 */
	case 9: // STATE 13 - trabajo.pml:199 - [done?k] (0:0:2 - 1)
		reached[7][13] = 1;
		if (q_len(now.done) == 0) continue;

		XX=1;
		(trpt+1)->bup.ovals = grab_ints(2);
		(trpt+1)->bup.ovals[0] = ((int)((P7 *)_this)->k);
		;
		((P7 *)_this)->k = qrecv(now.done, XX-1, 0, 1);
#ifdef VAR_RANGES
		logval(":init::k", ((int)((P7 *)_this)->k));
#endif
		;
		
#ifdef HAS_CODE
		if (readtrail && gui) {
			char simtmp[32];
			sprintf(simvals, "%d?", now.done);
		sprintf(simtmp, "%d", ((int)((P7 *)_this)->k)); strcat(simvals, simtmp);		}
#endif
		;
		if (TstOnly) return 1; /* TT */
		/* dead 2: k */  (trpt+1)->bup.ovals[1] = ((P7 *)_this)->k;
#ifdef HAS_CODE
		if (!readtrail)
#endif
			((P7 *)_this)->k = 0;
		_m = 4; goto P999; /* 0 */
	case 10: // STATE 14 - trabajo.pml:200 - [j = (j+1)] (0:0:1 - 1)
		IfNotBlocked
		reached[7][14] = 1;
		(trpt+1)->bup.oval = ((int)((P7 *)_this)->j);
		((P7 *)_this)->j = (((int)((P7 *)_this)->j)+1);
#ifdef VAR_RANGES
		logval(":init::j", ((int)((P7 *)_this)->j));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 11: // STATE 20 - trabajo.pml:206 - [(run DetectUsers())] (0:0:0 - 3)
		IfNotBlocked
		reached[7][20] = 1;
		if (!(addproc(II, 1, 2, 0)))
			continue;
		_m = 3; goto P999; /* 0 */
	case 12: // STATE 21 - trabajo.pml:207 - [(run DetectTargets())] (0:0:0 - 1)
		IfNotBlocked
		reached[7][21] = 1;
		if (!(addproc(II, 1, 3, 0)))
			continue;
		_m = 3; goto P999; /* 0 */
	case 13: // STATE 22 - trabajo.pml:208 - [(run DetectPairs())] (0:0:0 - 1)
		IfNotBlocked
		reached[7][22] = 1;
		if (!(addproc(II, 1, 4, 0)))
			continue;
		_m = 3; goto P999; /* 0 */
	case 14: // STATE 23 - trabajo.pml:209 - [(run DetectTypes())] (0:0:0 - 1)
		IfNotBlocked
		reached[7][23] = 1;
		if (!(addproc(II, 1, 5, 0)))
			continue;
		_m = 3; goto P999; /* 0 */
	case 15: // STATE 24 - trabajo.pml:212 - [(run Aggregator())] (0:0:0 - 1)
		IfNotBlocked
		reached[7][24] = 1;
		if (!(addproc(II, 1, 6, 0)))
			continue;
		_m = 3; goto P999; /* 0 */
	case 16: // STATE 25 - trabajo.pml:214 - [-end-] (0:0:0 - 1)
		IfNotBlocked
		reached[7][25] = 1;
		if (!delproc(1, II)) continue;
		_m = 3; goto P999; /* 0 */

		 /* PROC Aggregator */
	case 17: // STATE 1 - trabajo.pml:166 - [usersCh?us] (0:0:2 - 1)
		reached[6][1] = 1;
		if (q_len(now.usersCh) == 0) continue;

		XX=1;
		(trpt+1)->bup.ovals = grab_ints(2);
		(trpt+1)->bup.ovals[0] = ((P6 *)_this)->us;
		;
		((P6 *)_this)->us = qrecv(now.usersCh, XX-1, 0, 1);
#ifdef VAR_RANGES
		logval("Aggregator:us", ((P6 *)_this)->us);
#endif
		;
		
#ifdef HAS_CODE
		if (readtrail && gui) {
			char simtmp[32];
			sprintf(simvals, "%d?", now.usersCh);
		sprintf(simtmp, "%d", ((P6 *)_this)->us); strcat(simvals, simtmp);		}
#endif
		;
		if (TstOnly) return 1; /* TT */
		/* dead 2: us */  (trpt+1)->bup.ovals[1] = ((P6 *)_this)->us;
#ifdef HAS_CODE
		if (!readtrail)
#endif
			((P6 *)_this)->us = 0;
		_m = 4; goto P999; /* 0 */
	case 18: // STATE 2 - trabajo.pml:167 - [targetsCh?ta] (0:0:2 - 1)
		reached[6][2] = 1;
		if (q_len(now.targetsCh) == 0) continue;

		XX=1;
		(trpt+1)->bup.ovals = grab_ints(2);
		(trpt+1)->bup.ovals[0] = ((P6 *)_this)->ta;
		;
		((P6 *)_this)->ta = qrecv(now.targetsCh, XX-1, 0, 1);
#ifdef VAR_RANGES
		logval("Aggregator:ta", ((P6 *)_this)->ta);
#endif
		;
		
#ifdef HAS_CODE
		if (readtrail && gui) {
			char simtmp[32];
			sprintf(simvals, "%d?", now.targetsCh);
		sprintf(simtmp, "%d", ((P6 *)_this)->ta); strcat(simvals, simtmp);		}
#endif
		;
		if (TstOnly) return 1; /* TT */
		/* dead 2: ta */  (trpt+1)->bup.ovals[1] = ((P6 *)_this)->ta;
#ifdef HAS_CODE
		if (!readtrail)
#endif
			((P6 *)_this)->ta = 0;
		_m = 4; goto P999; /* 0 */
	case 19: // STATE 3 - trabajo.pml:168 - [pairsCh?pa] (0:0:2 - 1)
		reached[6][3] = 1;
		if (q_len(now.pairsCh) == 0) continue;

		XX=1;
		(trpt+1)->bup.ovals = grab_ints(2);
		(trpt+1)->bup.ovals[0] = ((P6 *)_this)->pa;
		;
		((P6 *)_this)->pa = qrecv(now.pairsCh, XX-1, 0, 1);
#ifdef VAR_RANGES
		logval("Aggregator:pa", ((P6 *)_this)->pa);
#endif
		;
		
#ifdef HAS_CODE
		if (readtrail && gui) {
			char simtmp[32];
			sprintf(simvals, "%d?", now.pairsCh);
		sprintf(simtmp, "%d", ((P6 *)_this)->pa); strcat(simvals, simtmp);		}
#endif
		;
		if (TstOnly) return 1; /* TT */
		/* dead 2: pa */  (trpt+1)->bup.ovals[1] = ((P6 *)_this)->pa;
#ifdef HAS_CODE
		if (!readtrail)
#endif
			((P6 *)_this)->pa = 0;
		_m = 4; goto P999; /* 0 */
	case 20: // STATE 4 - trabajo.pml:169 - [typesCh?ty] (0:0:2 - 1)
		reached[6][4] = 1;
		if (q_len(now.typesCh) == 0) continue;

		XX=1;
		(trpt+1)->bup.ovals = grab_ints(2);
		(trpt+1)->bup.ovals[0] = ((P6 *)_this)->ty;
		;
		((P6 *)_this)->ty = qrecv(now.typesCh, XX-1, 0, 1);
#ifdef VAR_RANGES
		logval("Aggregator:ty", ((P6 *)_this)->ty);
#endif
		;
		
#ifdef HAS_CODE
		if (readtrail && gui) {
			char simtmp[32];
			sprintf(simvals, "%d?", now.typesCh);
		sprintf(simtmp, "%d", ((P6 *)_this)->ty); strcat(simvals, simtmp);		}
#endif
		;
		if (TstOnly) return 1; /* TT */
		/* dead 2: ty */  (trpt+1)->bup.ovals[1] = ((P6 *)_this)->ty;
#ifdef HAS_CODE
		if (!readtrail)
#endif
			((P6 *)_this)->ty = 0;
		_m = 4; goto P999; /* 0 */
	case 21: // STATE 5 - trabajo.pml:176 - [-end-] (0:0:0 - 1)
		IfNotBlocked
		reached[6][5] = 1;
		if (!delproc(1, II)) continue;
		_m = 3; goto P999; /* 0 */

		 /* PROC DetectTypes */
	case 22: // STATE 1 - trabajo.pml:151 - [((TypeConts[0]>1))] (0:0:0 - 1)
		IfNotBlocked
		reached[5][1] = 1;
		if (!((now.TypeConts[0]>1)))
			continue;
		_m = 3; goto P999; /* 0 */
	case 23: // STATE 2 - trabajo.pml:151 - [anomalous = 1] (0:0:1 - 1)
		IfNotBlocked
		reached[5][2] = 1;
		(trpt+1)->bup.oval = ((P5 *)_this)->anomalous;
		((P5 *)_this)->anomalous = 1;
#ifdef VAR_RANGES
		logval("DetectTypes:anomalous", ((P5 *)_this)->anomalous);
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 24: // STATE 7 - trabajo.pml:155 - [typesCh!anomalous] (0:0:0 - 3)
		IfNotBlocked
		reached[5][7] = 1;
		if (q_full(now.typesCh))
			continue;
#ifdef HAS_CODE
		if (readtrail && gui) {
			char simtmp[64];
			sprintf(simvals, "%d!", now.typesCh);
		sprintf(simtmp, "%d", ((P5 *)_this)->anomalous); strcat(simvals, simtmp);		}
#endif
		
		qsend(now.typesCh, 0, ((P5 *)_this)->anomalous, 0, 0, 1);
		_m = 2; goto P999; /* 0 */
	case 25: // STATE 8 - trabajo.pml:156 - [-end-] (0:0:0 - 1)
		IfNotBlocked
		reached[5][8] = 1;
		if (!delproc(1, II)) continue;
		_m = 3; goto P999; /* 0 */

		 /* PROC DetectPairs */
	case 26: // STATE 1 - trabajo.pml:137 - [((PairConts[0]>1))] (0:0:0 - 1)
		IfNotBlocked
		reached[4][1] = 1;
		if (!((now.PairConts[0]>1)))
			continue;
		_m = 3; goto P999; /* 0 */
	case 27: // STATE 2 - trabajo.pml:137 - [anomalous = 1] (0:0:1 - 1)
		IfNotBlocked
		reached[4][2] = 1;
		(trpt+1)->bup.oval = ((P4 *)_this)->anomalous;
		((P4 *)_this)->anomalous = 1;
#ifdef VAR_RANGES
		logval("DetectPairs:anomalous", ((P4 *)_this)->anomalous);
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 28: // STATE 7 - trabajo.pml:141 - [pairsCh!anomalous] (0:0:0 - 3)
		IfNotBlocked
		reached[4][7] = 1;
		if (q_full(now.pairsCh))
			continue;
#ifdef HAS_CODE
		if (readtrail && gui) {
			char simtmp[64];
			sprintf(simvals, "%d!", now.pairsCh);
		sprintf(simtmp, "%d", ((P4 *)_this)->anomalous); strcat(simvals, simtmp);		}
#endif
		
		qsend(now.pairsCh, 0, ((P4 *)_this)->anomalous, 0, 0, 1);
		_m = 2; goto P999; /* 0 */
	case 29: // STATE 8 - trabajo.pml:142 - [-end-] (0:0:0 - 1)
		IfNotBlocked
		reached[4][8] = 1;
		if (!delproc(1, II)) continue;
		_m = 3; goto P999; /* 0 */

		 /* PROC DetectTargets */
	case 30: // STATE 1 - trabajo.pml:123 - [((TargetConts[0]>1))] (0:0:0 - 1)
		IfNotBlocked
		reached[3][1] = 1;
		if (!((now.TargetConts[0]>1)))
			continue;
		_m = 3; goto P999; /* 0 */
	case 31: // STATE 2 - trabajo.pml:123 - [anomalous = 1] (0:0:1 - 1)
		IfNotBlocked
		reached[3][2] = 1;
		(trpt+1)->bup.oval = ((P3 *)_this)->anomalous;
		((P3 *)_this)->anomalous = 1;
#ifdef VAR_RANGES
		logval("DetectTargets:anomalous", ((P3 *)_this)->anomalous);
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 32: // STATE 7 - trabajo.pml:127 - [targetsCh!anomalous] (0:0:0 - 3)
		IfNotBlocked
		reached[3][7] = 1;
		if (q_full(now.targetsCh))
			continue;
#ifdef HAS_CODE
		if (readtrail && gui) {
			char simtmp[64];
			sprintf(simvals, "%d!", now.targetsCh);
		sprintf(simtmp, "%d", ((P3 *)_this)->anomalous); strcat(simvals, simtmp);		}
#endif
		
		qsend(now.targetsCh, 0, ((P3 *)_this)->anomalous, 0, 0, 1);
		_m = 2; goto P999; /* 0 */
	case 33: // STATE 8 - trabajo.pml:128 - [-end-] (0:0:0 - 1)
		IfNotBlocked
		reached[3][8] = 1;
		if (!delproc(1, II)) continue;
		_m = 3; goto P999; /* 0 */

		 /* PROC DetectUsers */
	case 34: // STATE 1 - trabajo.pml:109 - [((UserConts[0]>1))] (0:0:0 - 1)
		IfNotBlocked
		reached[2][1] = 1;
		if (!((now.UserConts[0]>1)))
			continue;
		_m = 3; goto P999; /* 0 */
	case 35: // STATE 2 - trabajo.pml:109 - [anomalous = 1] (0:0:1 - 1)
		IfNotBlocked
		reached[2][2] = 1;
		(trpt+1)->bup.oval = ((P2 *)_this)->anomalous;
		((P2 *)_this)->anomalous = 1;
#ifdef VAR_RANGES
		logval("DetectUsers:anomalous", ((P2 *)_this)->anomalous);
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 36: // STATE 7 - trabajo.pml:113 - [usersCh!anomalous] (0:0:0 - 3)
		IfNotBlocked
		reached[2][7] = 1;
		if (q_full(now.usersCh))
			continue;
#ifdef HAS_CODE
		if (readtrail && gui) {
			char simtmp[64];
			sprintf(simvals, "%d!", now.usersCh);
		sprintf(simtmp, "%d", ((P2 *)_this)->anomalous); strcat(simvals, simtmp);		}
#endif
		
		qsend(now.usersCh, 0, ((P2 *)_this)->anomalous, 0, 0, 1);
		_m = 2; goto P999; /* 0 */
	case 37: // STATE 8 - trabajo.pml:114 - [-end-] (0:0:0 - 1)
		IfNotBlocked
		reached[2][8] = 1;
		if (!delproc(1, II)) continue;
		_m = 3; goto P999; /* 0 */

		 /* PROC Worker */
	case 38: // STATE 1 - trabajo.pml:70 - [records?userKey,targetKey,typeKey] (0:0:3 - 1)
		reached[1][1] = 1;
		if (q_len(now.records) == 0) continue;

		XX=1;
		(trpt+1)->bup.ovals = grab_ints(3);
		(trpt+1)->bup.ovals[0] = ((P1 *)_this)->userKey;
		(trpt+1)->bup.ovals[1] = ((P1 *)_this)->targetKey;
		(trpt+1)->bup.ovals[2] = ((P1 *)_this)->typeKey;
		;
		((P1 *)_this)->userKey = qrecv(now.records, XX-1, 0, 0);
#ifdef VAR_RANGES
		logval("Worker:userKey", ((P1 *)_this)->userKey);
#endif
		;
		((P1 *)_this)->targetKey = qrecv(now.records, XX-1, 1, 0);
#ifdef VAR_RANGES
		logval("Worker:targetKey", ((P1 *)_this)->targetKey);
#endif
		;
		((P1 *)_this)->typeKey = qrecv(now.records, XX-1, 2, 1);
#ifdef VAR_RANGES
		logval("Worker:typeKey", ((P1 *)_this)->typeKey);
#endif
		;
		
#ifdef HAS_CODE
		if (readtrail && gui) {
			char simtmp[32];
			sprintf(simvals, "%d?", now.records);
		sprintf(simtmp, "%d", ((P1 *)_this)->userKey); strcat(simvals, simtmp);		strcat(simvals, ",");
		sprintf(simtmp, "%d", ((P1 *)_this)->targetKey); strcat(simvals, simtmp);		strcat(simvals, ",");
		sprintf(simtmp, "%d", ((P1 *)_this)->typeKey); strcat(simvals, simtmp);		}
#endif
		;
		_m = 4; goto P999; /* 0 */
	case 39: // STATE 2 - trabajo.pml:72 - [((userKey==-(1)))] (0:0:1 - 1)
		IfNotBlocked
		reached[1][2] = 1;
		if (!((((P1 *)_this)->userKey== -(1))))
			continue;
		if (TstOnly) return 1; /* TT */
		/* dead 1: userKey */  (trpt+1)->bup.oval = ((P1 *)_this)->userKey;
#ifdef HAS_CODE
		if (!readtrail)
#endif
			((P1 *)_this)->userKey = 0;
		_m = 3; goto P999; /* 0 */
	case 40: // STATE 5 - trabajo.pml:78 - [((mutex==0))] (15:0:6 - 1)
		IfNotBlocked
		reached[1][5] = 1;
		if (!((((int)now.mutex)==0)))
			continue;
		/* merge: mutex = 1(15, 6, 15) */
		reached[1][6] = 1;
		(trpt+1)->bup.ovals = grab_ints(6);
		(trpt+1)->bup.ovals[0] = ((int)now.mutex);
		now.mutex = 1;
#ifdef VAR_RANGES
		logval("mutex", ((int)now.mutex));
#endif
		;
		/* merge: UserConts[userKey] = (UserConts[userKey]+1)(15, 7, 15) */
		reached[1][7] = 1;
		(trpt+1)->bup.ovals[1] = now.UserConts[ Index(((P1 *)_this)->userKey, 3) ];
		now.UserConts[ Index(((P1 *)_this)->userKey, 3) ] = (now.UserConts[ Index(((P1 *)_this)->userKey, 3) ]+1);
#ifdef VAR_RANGES
		logval("UserConts[Worker:userKey]", now.UserConts[ Index(((P1 *)_this)->userKey, 3) ]);
#endif
		;
		/* merge: TargetConts[targetKey] = (TargetConts[targetKey]+1)(15, 8, 15) */
		reached[1][8] = 1;
		(trpt+1)->bup.ovals[2] = now.TargetConts[ Index(((P1 *)_this)->targetKey, 3) ];
		now.TargetConts[ Index(((P1 *)_this)->targetKey, 3) ] = (now.TargetConts[ Index(((P1 *)_this)->targetKey, 3) ]+1);
#ifdef VAR_RANGES
		logval("TargetConts[Worker:targetKey]", now.TargetConts[ Index(((P1 *)_this)->targetKey, 3) ]);
#endif
		;
		/* merge: PairConts[userKey] = (PairConts[userKey]+1)(15, 9, 15) */
		reached[1][9] = 1;
		(trpt+1)->bup.ovals[3] = now.PairConts[ Index(((P1 *)_this)->userKey, 3) ];
		now.PairConts[ Index(((P1 *)_this)->userKey, 3) ] = (now.PairConts[ Index(((P1 *)_this)->userKey, 3) ]+1);
#ifdef VAR_RANGES
		logval("PairConts[Worker:userKey]", now.PairConts[ Index(((P1 *)_this)->userKey, 3) ]);
#endif
		;
		/* merge: TypeConts[typeKey] = (TypeConts[typeKey]+1)(15, 10, 15) */
		reached[1][10] = 1;
		(trpt+1)->bup.ovals[4] = now.TypeConts[ Index(((P1 *)_this)->typeKey, 3) ];
		now.TypeConts[ Index(((P1 *)_this)->typeKey, 3) ] = (now.TypeConts[ Index(((P1 *)_this)->typeKey, 3) ]+1);
#ifdef VAR_RANGES
		logval("TypeConts[Worker:typeKey]", now.TypeConts[ Index(((P1 *)_this)->typeKey, 3) ]);
#endif
		;
		/* merge: mutex = 0(15, 11, 15) */
		reached[1][11] = 1;
		(trpt+1)->bup.ovals[5] = ((int)now.mutex);
		now.mutex = 0;
#ifdef VAR_RANGES
		logval("mutex", ((int)now.mutex));
#endif
		;
		/* merge: .(goto)(0, 14, 15) */
		reached[1][14] = 1;
		;
		/* merge: .(goto)(0, 16, 15) */
		reached[1][16] = 1;
		;
		_m = 3; goto P999; /* 8 */
	case 41: // STATE 18 - trabajo.pml:95 - [done!id] (0:0:0 - 3)
		IfNotBlocked
		reached[1][18] = 1;
		if (q_full(now.done))
			continue;
#ifdef HAS_CODE
		if (readtrail && gui) {
			char simtmp[64];
			sprintf(simvals, "%d!", now.done);
		sprintf(simtmp, "%d", ((int)((P1 *)_this)->id)); strcat(simvals, simtmp);		}
#endif
		
		qsend(now.done, 0, ((int)((P1 *)_this)->id), 0, 0, 1);
		_m = 2; goto P999; /* 0 */
	case 42: // STATE 19 - trabajo.pml:96 - [-end-] (0:0:0 - 1)
		IfNotBlocked
		reached[1][19] = 1;
		if (!delproc(1, II)) continue;
		_m = 3; goto P999; /* 0 */

		 /* PROC Reader */
	case 43: // STATE 1 - trabajo.pml:40 - [((i<50))] (0:0:0 - 1)
		IfNotBlocked
		reached[0][1] = 1;
		if (!((((P0 *)_this)->i<50)))
			continue;
		_m = 3; goto P999; /* 0 */
	case 44: // STATE 2 - trabajo.pml:43 - [records!(i%3),((i+1)%3),((i+2)%3)] (0:0:0 - 1)
		IfNotBlocked
		reached[0][2] = 1;
		if (q_full(now.records))
			continue;
#ifdef HAS_CODE
		if (readtrail && gui) {
			char simtmp[64];
			sprintf(simvals, "%d!", now.records);
		sprintf(simtmp, "%d", (((P0 *)_this)->i%3)); strcat(simvals, simtmp);		strcat(simvals, ",");
		sprintf(simtmp, "%d", ((((P0 *)_this)->i+1)%3)); strcat(simvals, simtmp);		strcat(simvals, ",");
		sprintf(simtmp, "%d", ((((P0 *)_this)->i+2)%3)); strcat(simvals, simtmp);		}
#endif
		
		qsend(now.records, 0, (((P0 *)_this)->i%3), ((((P0 *)_this)->i+1)%3), ((((P0 *)_this)->i+2)%3), 3);
		_m = 2; goto P999; /* 0 */
	case 45: // STATE 3 - trabajo.pml:44 - [i = (i+1)] (0:0:1 - 1)
		IfNotBlocked
		reached[0][3] = 1;
		(trpt+1)->bup.oval = ((P0 *)_this)->i;
		((P0 *)_this)->i = (((P0 *)_this)->i+1);
#ifdef VAR_RANGES
		logval("Reader:i", ((P0 *)_this)->i);
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 46: // STATE 9 - trabajo.pml:51 - [i = 0] (0:15:1 - 3)
		IfNotBlocked
		reached[0][9] = 1;
		(trpt+1)->bup.oval = ((P0 *)_this)->i;
		((P0 *)_this)->i = 0;
#ifdef VAR_RANGES
		logval("Reader:i", ((P0 *)_this)->i);
#endif
		;
		/* merge: .(goto)(0, 16, 15) */
		reached[0][16] = 1;
		;
		_m = 3; goto P999; /* 1 */
	case 47: // STATE 10 - trabajo.pml:53 - [((i<3))] (0:0:0 - 1)
		IfNotBlocked
		reached[0][10] = 1;
		if (!((((P0 *)_this)->i<3)))
			continue;
		_m = 3; goto P999; /* 0 */
	case 48: // STATE 11 - trabajo.pml:54 - [records!-(1),-(1),-(1)] (0:0:0 - 1)
		IfNotBlocked
		reached[0][11] = 1;
		if (q_full(now.records))
			continue;
#ifdef HAS_CODE
		if (readtrail && gui) {
			char simtmp[64];
			sprintf(simvals, "%d!", now.records);
		sprintf(simtmp, "%d",  -(1)); strcat(simvals, simtmp);		strcat(simvals, ",");
		sprintf(simtmp, "%d",  -(1)); strcat(simvals, simtmp);		strcat(simvals, ",");
		sprintf(simtmp, "%d",  -(1)); strcat(simvals, simtmp);		}
#endif
		
		qsend(now.records, 0,  -(1),  -(1),  -(1), 3);
		_m = 2; goto P999; /* 0 */
	case 49: // STATE 12 - trabajo.pml:55 - [i = (i+1)] (0:0:1 - 1)
		IfNotBlocked
		reached[0][12] = 1;
		(trpt+1)->bup.oval = ((P0 *)_this)->i;
		((P0 *)_this)->i = (((P0 *)_this)->i+1);
#ifdef VAR_RANGES
		logval("Reader:i", ((P0 *)_this)->i);
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 50: // STATE 18 - trabajo.pml:60 - [-end-] (0:0:0 - 3)
		IfNotBlocked
		reached[0][18] = 1;
		if (!delproc(1, II)) continue;
		_m = 3; goto P999; /* 0 */
	case  _T5:	/* np_ */
		if (!((!(trpt->o_pm&4) && !(trpt->tau&128))))
			continue;
		/* else fall through */
	case  _T2:	/* true */
		_m = 3; goto P999;
#undef rand
	}

