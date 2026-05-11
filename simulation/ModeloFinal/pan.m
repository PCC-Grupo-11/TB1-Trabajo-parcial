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
	case 3: // STATE 1 - trabajo.pml:324 - [(run Reader())] (0:0:0 - 1)
		IfNotBlocked
		reached[8][1] = 1;
		if (!(addproc(II, 1, 0, 0)))
			continue;
		_m = 3; goto P999; /* 0 */
	case 4: // STATE 2 - trabajo.pml:328 - [((i<2))] (0:0:0 - 1)
		IfNotBlocked
		reached[8][2] = 1;
		if (!((((int)((P8 *)_this)->i)<2)))
			continue;
		_m = 3; goto P999; /* 0 */
	case 5: // STATE 3 - trabajo.pml:329 - [(run Worker(i))] (0:0:0 - 1)
		IfNotBlocked
		reached[8][3] = 1;
		if (!(addproc(II, 1, 1, ((int)((P8 *)_this)->i))))
			continue;
		_m = 3; goto P999; /* 0 */
	case 6: // STATE 4 - trabajo.pml:330 - [i = (i+1)] (0:0:1 - 1)
		IfNotBlocked
		reached[8][4] = 1;
		(trpt+1)->bup.oval = ((int)((P8 *)_this)->i);
		((P8 *)_this)->i = (((int)((P8 *)_this)->i)+1);
#ifdef VAR_RANGES
		logval(":init::i", ((int)((P8 *)_this)->i));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 7: // STATE 10 - trabajo.pml:337 - [j = 0] (0:17:2 - 3)
		IfNotBlocked
		reached[8][10] = 1;
		(trpt+1)->bup.ovals = grab_ints(2);
		(trpt+1)->bup.ovals[0] = ((int)((P8 *)_this)->j);
		((P8 *)_this)->j = 0;
#ifdef VAR_RANGES
		logval(":init::j", ((int)((P8 *)_this)->j));
#endif
		;
		/* merge: k = 0(17, 11, 17) */
		reached[8][11] = 1;
		(trpt+1)->bup.ovals[1] = ((int)((P8 *)_this)->k);
		((P8 *)_this)->k = 0;
#ifdef VAR_RANGES
		logval(":init::k", ((int)((P8 *)_this)->k));
#endif
		;
		/* merge: .(goto)(0, 18, 17) */
		reached[8][18] = 1;
		;
		_m = 3; goto P999; /* 2 */
	case 8: // STATE 12 - trabajo.pml:340 - [((j<2))] (0:0:0 - 1)
		IfNotBlocked
		reached[8][12] = 1;
		if (!((((int)((P8 *)_this)->j)<2)))
			continue;
		_m = 3; goto P999; /* 0 */
	case 9: // STATE 13 - trabajo.pml:341 - [done?k] (0:0:2 - 1)
		reached[8][13] = 1;
		if (q_len(now.done) == 0) continue;

		XX=1;
		(trpt+1)->bup.ovals = grab_ints(2);
		(trpt+1)->bup.ovals[0] = ((int)((P8 *)_this)->k);
		;
		((P8 *)_this)->k = qrecv(now.done, XX-1, 0, 1);
#ifdef VAR_RANGES
		logval(":init::k", ((int)((P8 *)_this)->k));
#endif
		;
		
#ifdef HAS_CODE
		if (readtrail && gui) {
			char simtmp[32];
			sprintf(simvals, "%d?", now.done);
		sprintf(simtmp, "%d", ((int)((P8 *)_this)->k)); strcat(simvals, simtmp);		}
#endif
		;
		if (TstOnly) return 1; /* TT */
		/* dead 2: k */  (trpt+1)->bup.ovals[1] = ((P8 *)_this)->k;
#ifdef HAS_CODE
		if (!readtrail)
#endif
			((P8 *)_this)->k = 0;
		_m = 4; goto P999; /* 0 */
	case 10: // STATE 14 - trabajo.pml:342 - [j = (j+1)] (0:0:1 - 1)
		IfNotBlocked
		reached[8][14] = 1;
		(trpt+1)->bup.oval = ((int)((P8 *)_this)->j);
		((P8 *)_this)->j = (((int)((P8 *)_this)->j)+1);
#ifdef VAR_RANGES
		logval(":init::j", ((int)((P8 *)_this)->j));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 11: // STATE 20 - trabajo.pml:348 - [(run DetectUsers())] (0:0:0 - 3)
		IfNotBlocked
		reached[8][20] = 1;
		if (!(addproc(II, 1, 2, 0)))
			continue;
		_m = 3; goto P999; /* 0 */
	case 12: // STATE 21 - trabajo.pml:349 - [(run DetectTargets())] (0:0:0 - 1)
		IfNotBlocked
		reached[8][21] = 1;
		if (!(addproc(II, 1, 3, 0)))
			continue;
		_m = 3; goto P999; /* 0 */
	case 13: // STATE 22 - trabajo.pml:350 - [(run DetectPairs())] (0:0:0 - 1)
		IfNotBlocked
		reached[8][22] = 1;
		if (!(addproc(II, 1, 4, 0)))
			continue;
		_m = 3; goto P999; /* 0 */
	case 14: // STATE 23 - trabajo.pml:351 - [(run DetectTypes())] (0:0:0 - 1)
		IfNotBlocked
		reached[8][23] = 1;
		if (!(addproc(II, 1, 5, 0)))
			continue;
		_m = 3; goto P999; /* 0 */
	case 15: // STATE 24 - trabajo.pml:352 - [(run DetectTexts())] (0:0:0 - 1)
		IfNotBlocked
		reached[8][24] = 1;
		if (!(addproc(II, 1, 6, 0)))
			continue;
		_m = 3; goto P999; /* 0 */
	case 16: // STATE 25 - trabajo.pml:355 - [(run Aggregator())] (0:0:0 - 1)
		IfNotBlocked
		reached[8][25] = 1;
		if (!(addproc(II, 1, 7, 0)))
			continue;
		_m = 3; goto P999; /* 0 */
	case 17: // STATE 26 - trabajo.pml:356 - [-end-] (0:0:0 - 1)
		IfNotBlocked
		reached[8][26] = 1;
		if (!delproc(1, II)) continue;
		_m = 3; goto P999; /* 0 */

		 /* PROC Aggregator */
	case 18: // STATE 1 - trabajo.pml:263 - [usersCh?value] (0:0:1 - 1)
		reached[7][1] = 1;
		if (q_len(now.usersCh) == 0) continue;

		XX=1;
		(trpt+1)->bup.oval = ((int)((P7 *)_this)->value);
		;
		((P7 *)_this)->value = qrecv(now.usersCh, XX-1, 0, 1);
#ifdef VAR_RANGES
		logval("Aggregator:value", ((int)((P7 *)_this)->value));
#endif
		;
		
#ifdef HAS_CODE
		if (readtrail && gui) {
			char simtmp[32];
			sprintf(simvals, "%d?", now.usersCh);
		sprintf(simtmp, "%d", ((int)((P7 *)_this)->value)); strcat(simvals, simtmp);		}
#endif
		;
		_m = 4; goto P999; /* 0 */
	case 19: // STATE 2 - trabajo.pml:265 - [((value==255))] (0:0:1 - 1)
		IfNotBlocked
		reached[7][2] = 1;
		if (!((((int)((P7 *)_this)->value)==255)))
			continue;
		if (TstOnly) return 1; /* TT */
		/* dead 1: value */  (trpt+1)->bup.oval = ((P7 *)_this)->value;
#ifdef HAS_CODE
		if (!readtrail)
#endif
			((P7 *)_this)->value = 0;
		_m = 3; goto P999; /* 0 */
	case 20: // STATE 5 - trabajo.pml:268 - [printf('Anomalia USER detectada en indice: %d\\n',value)] (0:0:0 - 1)
		IfNotBlocked
		reached[7][5] = 1;
		Printf("Anomalia USER detectada en indice: %d\n", ((int)((P7 *)_this)->value));
		_m = 3; goto P999; /* 0 */
	case 21: // STATE 11 - trabajo.pml:274 - [targetsCh?value] (0:0:1 - 1)
		reached[7][11] = 1;
		if (q_len(now.targetsCh) == 0) continue;

		XX=1;
		(trpt+1)->bup.oval = ((int)((P7 *)_this)->value);
		;
		((P7 *)_this)->value = qrecv(now.targetsCh, XX-1, 0, 1);
#ifdef VAR_RANGES
		logval("Aggregator:value", ((int)((P7 *)_this)->value));
#endif
		;
		
#ifdef HAS_CODE
		if (readtrail && gui) {
			char simtmp[32];
			sprintf(simvals, "%d?", now.targetsCh);
		sprintf(simtmp, "%d", ((int)((P7 *)_this)->value)); strcat(simvals, simtmp);		}
#endif
		;
		_m = 4; goto P999; /* 0 */
	case 22: // STATE 12 - trabajo.pml:276 - [((value==255))] (0:0:1 - 1)
		IfNotBlocked
		reached[7][12] = 1;
		if (!((((int)((P7 *)_this)->value)==255)))
			continue;
		if (TstOnly) return 1; /* TT */
		/* dead 1: value */  (trpt+1)->bup.oval = ((P7 *)_this)->value;
#ifdef HAS_CODE
		if (!readtrail)
#endif
			((P7 *)_this)->value = 0;
		_m = 3; goto P999; /* 0 */
	case 23: // STATE 15 - trabajo.pml:279 - [printf('Anomalia TARGET detectada en indice: %d\\n',value)] (0:0:0 - 1)
		IfNotBlocked
		reached[7][15] = 1;
		Printf("Anomalia TARGET detectada en indice: %d\n", ((int)((P7 *)_this)->value));
		_m = 3; goto P999; /* 0 */
	case 24: // STATE 21 - trabajo.pml:285 - [pairsCh?value] (0:0:1 - 1)
		reached[7][21] = 1;
		if (q_len(now.pairsCh) == 0) continue;

		XX=1;
		(trpt+1)->bup.oval = ((int)((P7 *)_this)->value);
		;
		((P7 *)_this)->value = qrecv(now.pairsCh, XX-1, 0, 1);
#ifdef VAR_RANGES
		logval("Aggregator:value", ((int)((P7 *)_this)->value));
#endif
		;
		
#ifdef HAS_CODE
		if (readtrail && gui) {
			char simtmp[32];
			sprintf(simvals, "%d?", now.pairsCh);
		sprintf(simtmp, "%d", ((int)((P7 *)_this)->value)); strcat(simvals, simtmp);		}
#endif
		;
		_m = 4; goto P999; /* 0 */
	case 25: // STATE 22 - trabajo.pml:287 - [((value==255))] (0:0:1 - 1)
		IfNotBlocked
		reached[7][22] = 1;
		if (!((((int)((P7 *)_this)->value)==255)))
			continue;
		if (TstOnly) return 1; /* TT */
		/* dead 1: value */  (trpt+1)->bup.oval = ((P7 *)_this)->value;
#ifdef HAS_CODE
		if (!readtrail)
#endif
			((P7 *)_this)->value = 0;
		_m = 3; goto P999; /* 0 */
	case 26: // STATE 25 - trabajo.pml:290 - [printf('Anomalia PAIR detectada en indice: %d\\n',value)] (0:0:0 - 1)
		IfNotBlocked
		reached[7][25] = 1;
		Printf("Anomalia PAIR detectada en indice: %d\n", ((int)((P7 *)_this)->value));
		_m = 3; goto P999; /* 0 */
	case 27: // STATE 31 - trabajo.pml:296 - [typesCh?value] (0:0:1 - 1)
		reached[7][31] = 1;
		if (q_len(now.typesCh) == 0) continue;

		XX=1;
		(trpt+1)->bup.oval = ((int)((P7 *)_this)->value);
		;
		((P7 *)_this)->value = qrecv(now.typesCh, XX-1, 0, 1);
#ifdef VAR_RANGES
		logval("Aggregator:value", ((int)((P7 *)_this)->value));
#endif
		;
		
#ifdef HAS_CODE
		if (readtrail && gui) {
			char simtmp[32];
			sprintf(simvals, "%d?", now.typesCh);
		sprintf(simtmp, "%d", ((int)((P7 *)_this)->value)); strcat(simvals, simtmp);		}
#endif
		;
		_m = 4; goto P999; /* 0 */
	case 28: // STATE 32 - trabajo.pml:298 - [((value==255))] (0:0:1 - 1)
		IfNotBlocked
		reached[7][32] = 1;
		if (!((((int)((P7 *)_this)->value)==255)))
			continue;
		if (TstOnly) return 1; /* TT */
		/* dead 1: value */  (trpt+1)->bup.oval = ((P7 *)_this)->value;
#ifdef HAS_CODE
		if (!readtrail)
#endif
			((P7 *)_this)->value = 0;
		_m = 3; goto P999; /* 0 */
	case 29: // STATE 35 - trabajo.pml:301 - [printf('Anomalia TYPE detectada en indice: %d\\n',value)] (0:0:0 - 1)
		IfNotBlocked
		reached[7][35] = 1;
		Printf("Anomalia TYPE detectada en indice: %d\n", ((int)((P7 *)_this)->value));
		_m = 3; goto P999; /* 0 */
	case 30: // STATE 41 - trabajo.pml:307 - [textsCh?value] (0:0:1 - 1)
		reached[7][41] = 1;
		if (q_len(now.textsCh) == 0) continue;

		XX=1;
		(trpt+1)->bup.oval = ((int)((P7 *)_this)->value);
		;
		((P7 *)_this)->value = qrecv(now.textsCh, XX-1, 0, 1);
#ifdef VAR_RANGES
		logval("Aggregator:value", ((int)((P7 *)_this)->value));
#endif
		;
		
#ifdef HAS_CODE
		if (readtrail && gui) {
			char simtmp[32];
			sprintf(simvals, "%d?", now.textsCh);
		sprintf(simtmp, "%d", ((int)((P7 *)_this)->value)); strcat(simvals, simtmp);		}
#endif
		;
		_m = 4; goto P999; /* 0 */
	case 31: // STATE 42 - trabajo.pml:309 - [((value==255))] (0:0:1 - 1)
		IfNotBlocked
		reached[7][42] = 1;
		if (!((((int)((P7 *)_this)->value)==255)))
			continue;
		if (TstOnly) return 1; /* TT */
		/* dead 1: value */  (trpt+1)->bup.oval = ((P7 *)_this)->value;
#ifdef HAS_CODE
		if (!readtrail)
#endif
			((P7 *)_this)->value = 0;
		_m = 3; goto P999; /* 0 */
	case 32: // STATE 45 - trabajo.pml:312 - [printf('Anomalia TEXT detectada en indice: %d\\n',value)] (0:0:0 - 1)
		IfNotBlocked
		reached[7][45] = 1;
		Printf("Anomalia TEXT detectada en indice: %d\n", ((int)((P7 *)_this)->value));
		_m = 3; goto P999; /* 0 */
	case 33: // STATE 51 - trabajo.pml:315 - [-end-] (0:0:0 - 3)
		IfNotBlocked
		reached[7][51] = 1;
		if (!delproc(1, II)) continue;
		_m = 3; goto P999; /* 0 */

		 /* PROC DetectTexts */
	case 34: // STATE 1 - trabajo.pml:235 - [((i<10))] (0:0:0 - 1)
		IfNotBlocked
		reached[6][1] = 1;
		if (!((((int)((P6 *)_this)->i)<10)))
			continue;
		_m = 3; goto P999; /* 0 */
	case 35: // STATE 2 - trabajo.pml:238 - [((TextConts[i]>1))] (0:0:0 - 1)
		IfNotBlocked
		reached[6][2] = 1;
		if (!((((int)now.TextConts[ Index(((int)((P6 *)_this)->i), 10) ])>1)))
			continue;
		_m = 3; goto P999; /* 0 */
	case 36: // STATE 3 - trabajo.pml:239 - [textsCh!i] (0:0:0 - 1)
		IfNotBlocked
		reached[6][3] = 1;
		if (q_full(now.textsCh))
			continue;
#ifdef HAS_CODE
		if (readtrail && gui) {
			char simtmp[64];
			sprintf(simvals, "%d!", now.textsCh);
		sprintf(simtmp, "%d", ((int)((P6 *)_this)->i)); strcat(simvals, simtmp);		}
#endif
		
		qsend(now.textsCh, 0, ((int)((P6 *)_this)->i), 0, 0, 0, 1);
		_m = 2; goto P999; /* 0 */
	case 37: // STATE 5 - trabajo.pml:241 - [(1)] (11:0:1 - 1)
		IfNotBlocked
		reached[6][5] = 1;
		if (!(1))
			continue;
		/* merge: .(goto)(11, 7, 11) */
		reached[6][7] = 1;
		;
		/* merge: i = (i+1)(11, 8, 11) */
		reached[6][8] = 1;
		(trpt+1)->bup.oval = ((int)((P6 *)_this)->i);
		((P6 *)_this)->i = (((int)((P6 *)_this)->i)+1);
#ifdef VAR_RANGES
		logval("DetectTexts:i", ((int)((P6 *)_this)->i));
#endif
		;
		/* merge: .(goto)(0, 12, 11) */
		reached[6][12] = 1;
		;
		_m = 3; goto P999; /* 3 */
	case 38: // STATE 8 - trabajo.pml:243 - [i = (i+1)] (0:11:1 - 3)
		IfNotBlocked
		reached[6][8] = 1;
		(trpt+1)->bup.oval = ((int)((P6 *)_this)->i);
		((P6 *)_this)->i = (((int)((P6 *)_this)->i)+1);
#ifdef VAR_RANGES
		logval("DetectTexts:i", ((int)((P6 *)_this)->i));
#endif
		;
		/* merge: .(goto)(0, 12, 11) */
		reached[6][12] = 1;
		;
		_m = 3; goto P999; /* 1 */
	case 39: // STATE 14 - trabajo.pml:247 - [textsCh!255] (0:0:0 - 3)
		IfNotBlocked
		reached[6][14] = 1;
		if (q_full(now.textsCh))
			continue;
#ifdef HAS_CODE
		if (readtrail && gui) {
			char simtmp[64];
			sprintf(simvals, "%d!", now.textsCh);
		sprintf(simtmp, "%d", 255); strcat(simvals, simtmp);		}
#endif
		
		qsend(now.textsCh, 0, 255, 0, 0, 0, 1);
		_m = 2; goto P999; /* 0 */
	case 40: // STATE 15 - trabajo.pml:248 - [-end-] (0:0:0 - 1)
		IfNotBlocked
		reached[6][15] = 1;
		if (!delproc(1, II)) continue;
		_m = 3; goto P999; /* 0 */

		 /* PROC DetectTypes */
	case 41: // STATE 1 - trabajo.pml:216 - [((i<10))] (0:0:0 - 1)
		IfNotBlocked
		reached[5][1] = 1;
		if (!((((int)((P5 *)_this)->i)<10)))
			continue;
		_m = 3; goto P999; /* 0 */
	case 42: // STATE 2 - trabajo.pml:219 - [((TypeConts[i]>1))] (0:0:0 - 1)
		IfNotBlocked
		reached[5][2] = 1;
		if (!((((int)now.TypeConts[ Index(((int)((P5 *)_this)->i), 10) ])>1)))
			continue;
		_m = 3; goto P999; /* 0 */
	case 43: // STATE 3 - trabajo.pml:220 - [typesCh!i] (0:0:0 - 1)
		IfNotBlocked
		reached[5][3] = 1;
		if (q_full(now.typesCh))
			continue;
#ifdef HAS_CODE
		if (readtrail && gui) {
			char simtmp[64];
			sprintf(simvals, "%d!", now.typesCh);
		sprintf(simtmp, "%d", ((int)((P5 *)_this)->i)); strcat(simvals, simtmp);		}
#endif
		
		qsend(now.typesCh, 0, ((int)((P5 *)_this)->i), 0, 0, 0, 1);
		_m = 2; goto P999; /* 0 */
	case 44: // STATE 5 - trabajo.pml:222 - [(1)] (11:0:1 - 1)
		IfNotBlocked
		reached[5][5] = 1;
		if (!(1))
			continue;
		/* merge: .(goto)(11, 7, 11) */
		reached[5][7] = 1;
		;
		/* merge: i = (i+1)(11, 8, 11) */
		reached[5][8] = 1;
		(trpt+1)->bup.oval = ((int)((P5 *)_this)->i);
		((P5 *)_this)->i = (((int)((P5 *)_this)->i)+1);
#ifdef VAR_RANGES
		logval("DetectTypes:i", ((int)((P5 *)_this)->i));
#endif
		;
		/* merge: .(goto)(0, 12, 11) */
		reached[5][12] = 1;
		;
		_m = 3; goto P999; /* 3 */
	case 45: // STATE 8 - trabajo.pml:224 - [i = (i+1)] (0:11:1 - 3)
		IfNotBlocked
		reached[5][8] = 1;
		(trpt+1)->bup.oval = ((int)((P5 *)_this)->i);
		((P5 *)_this)->i = (((int)((P5 *)_this)->i)+1);
#ifdef VAR_RANGES
		logval("DetectTypes:i", ((int)((P5 *)_this)->i));
#endif
		;
		/* merge: .(goto)(0, 12, 11) */
		reached[5][12] = 1;
		;
		_m = 3; goto P999; /* 1 */
	case 46: // STATE 14 - trabajo.pml:228 - [typesCh!255] (0:0:0 - 3)
		IfNotBlocked
		reached[5][14] = 1;
		if (q_full(now.typesCh))
			continue;
#ifdef HAS_CODE
		if (readtrail && gui) {
			char simtmp[64];
			sprintf(simvals, "%d!", now.typesCh);
		sprintf(simtmp, "%d", 255); strcat(simvals, simtmp);		}
#endif
		
		qsend(now.typesCh, 0, 255, 0, 0, 0, 1);
		_m = 2; goto P999; /* 0 */
	case 47: // STATE 15 - trabajo.pml:229 - [-end-] (0:0:0 - 1)
		IfNotBlocked
		reached[5][15] = 1;
		if (!delproc(1, II)) continue;
		_m = 3; goto P999; /* 0 */

		 /* PROC DetectPairs */
	case 48: // STATE 1 - trabajo.pml:197 - [((i<10))] (0:0:0 - 1)
		IfNotBlocked
		reached[4][1] = 1;
		if (!((((int)((P4 *)_this)->i)<10)))
			continue;
		_m = 3; goto P999; /* 0 */
	case 49: // STATE 2 - trabajo.pml:200 - [((PairConts[i]>1))] (0:0:0 - 1)
		IfNotBlocked
		reached[4][2] = 1;
		if (!((((int)now.PairConts[ Index(((int)((P4 *)_this)->i), 10) ])>1)))
			continue;
		_m = 3; goto P999; /* 0 */
	case 50: // STATE 3 - trabajo.pml:201 - [pairsCh!i] (0:0:0 - 1)
		IfNotBlocked
		reached[4][3] = 1;
		if (q_full(now.pairsCh))
			continue;
#ifdef HAS_CODE
		if (readtrail && gui) {
			char simtmp[64];
			sprintf(simvals, "%d!", now.pairsCh);
		sprintf(simtmp, "%d", ((int)((P4 *)_this)->i)); strcat(simvals, simtmp);		}
#endif
		
		qsend(now.pairsCh, 0, ((int)((P4 *)_this)->i), 0, 0, 0, 1);
		_m = 2; goto P999; /* 0 */
	case 51: // STATE 5 - trabajo.pml:203 - [(1)] (11:0:1 - 1)
		IfNotBlocked
		reached[4][5] = 1;
		if (!(1))
			continue;
		/* merge: .(goto)(11, 7, 11) */
		reached[4][7] = 1;
		;
		/* merge: i = (i+1)(11, 8, 11) */
		reached[4][8] = 1;
		(trpt+1)->bup.oval = ((int)((P4 *)_this)->i);
		((P4 *)_this)->i = (((int)((P4 *)_this)->i)+1);
#ifdef VAR_RANGES
		logval("DetectPairs:i", ((int)((P4 *)_this)->i));
#endif
		;
		/* merge: .(goto)(0, 12, 11) */
		reached[4][12] = 1;
		;
		_m = 3; goto P999; /* 3 */
	case 52: // STATE 8 - trabajo.pml:205 - [i = (i+1)] (0:11:1 - 3)
		IfNotBlocked
		reached[4][8] = 1;
		(trpt+1)->bup.oval = ((int)((P4 *)_this)->i);
		((P4 *)_this)->i = (((int)((P4 *)_this)->i)+1);
#ifdef VAR_RANGES
		logval("DetectPairs:i", ((int)((P4 *)_this)->i));
#endif
		;
		/* merge: .(goto)(0, 12, 11) */
		reached[4][12] = 1;
		;
		_m = 3; goto P999; /* 1 */
	case 53: // STATE 14 - trabajo.pml:209 - [pairsCh!255] (0:0:0 - 3)
		IfNotBlocked
		reached[4][14] = 1;
		if (q_full(now.pairsCh))
			continue;
#ifdef HAS_CODE
		if (readtrail && gui) {
			char simtmp[64];
			sprintf(simvals, "%d!", now.pairsCh);
		sprintf(simtmp, "%d", 255); strcat(simvals, simtmp);		}
#endif
		
		qsend(now.pairsCh, 0, 255, 0, 0, 0, 1);
		_m = 2; goto P999; /* 0 */
	case 54: // STATE 15 - trabajo.pml:210 - [-end-] (0:0:0 - 1)
		IfNotBlocked
		reached[4][15] = 1;
		if (!delproc(1, II)) continue;
		_m = 3; goto P999; /* 0 */

		 /* PROC DetectTargets */
	case 55: // STATE 1 - trabajo.pml:177 - [((i<10))] (0:0:0 - 1)
		IfNotBlocked
		reached[3][1] = 1;
		if (!((((int)((P3 *)_this)->i)<10)))
			continue;
		_m = 3; goto P999; /* 0 */
	case 56: // STATE 2 - trabajo.pml:180 - [((TargetConts[i]>1))] (0:0:0 - 1)
		IfNotBlocked
		reached[3][2] = 1;
		if (!((((int)now.TargetConts[ Index(((int)((P3 *)_this)->i), 10) ])>1)))
			continue;
		_m = 3; goto P999; /* 0 */
	case 57: // STATE 3 - trabajo.pml:181 - [targetsCh!i] (0:0:0 - 1)
		IfNotBlocked
		reached[3][3] = 1;
		if (q_full(now.targetsCh))
			continue;
#ifdef HAS_CODE
		if (readtrail && gui) {
			char simtmp[64];
			sprintf(simvals, "%d!", now.targetsCh);
		sprintf(simtmp, "%d", ((int)((P3 *)_this)->i)); strcat(simvals, simtmp);		}
#endif
		
		qsend(now.targetsCh, 0, ((int)((P3 *)_this)->i), 0, 0, 0, 1);
		_m = 2; goto P999; /* 0 */
	case 58: // STATE 5 - trabajo.pml:183 - [(1)] (11:0:1 - 1)
		IfNotBlocked
		reached[3][5] = 1;
		if (!(1))
			continue;
		/* merge: .(goto)(11, 7, 11) */
		reached[3][7] = 1;
		;
		/* merge: i = (i+1)(11, 8, 11) */
		reached[3][8] = 1;
		(trpt+1)->bup.oval = ((int)((P3 *)_this)->i);
		((P3 *)_this)->i = (((int)((P3 *)_this)->i)+1);
#ifdef VAR_RANGES
		logval("DetectTargets:i", ((int)((P3 *)_this)->i));
#endif
		;
		/* merge: .(goto)(0, 12, 11) */
		reached[3][12] = 1;
		;
		_m = 3; goto P999; /* 3 */
	case 59: // STATE 8 - trabajo.pml:185 - [i = (i+1)] (0:11:1 - 3)
		IfNotBlocked
		reached[3][8] = 1;
		(trpt+1)->bup.oval = ((int)((P3 *)_this)->i);
		((P3 *)_this)->i = (((int)((P3 *)_this)->i)+1);
#ifdef VAR_RANGES
		logval("DetectTargets:i", ((int)((P3 *)_this)->i));
#endif
		;
		/* merge: .(goto)(0, 12, 11) */
		reached[3][12] = 1;
		;
		_m = 3; goto P999; /* 1 */
	case 60: // STATE 14 - trabajo.pml:189 - [targetsCh!255] (0:0:0 - 3)
		IfNotBlocked
		reached[3][14] = 1;
		if (q_full(now.targetsCh))
			continue;
#ifdef HAS_CODE
		if (readtrail && gui) {
			char simtmp[64];
			sprintf(simvals, "%d!", now.targetsCh);
		sprintf(simtmp, "%d", 255); strcat(simvals, simtmp);		}
#endif
		
		qsend(now.targetsCh, 0, 255, 0, 0, 0, 1);
		_m = 2; goto P999; /* 0 */
	case 61: // STATE 15 - trabajo.pml:190 - [-end-] (0:0:0 - 1)
		IfNotBlocked
		reached[3][15] = 1;
		if (!delproc(1, II)) continue;
		_m = 3; goto P999; /* 0 */

		 /* PROC DetectUsers */
	case 62: // STATE 1 - trabajo.pml:155 - [((i<10))] (0:0:0 - 1)
		IfNotBlocked
		reached[2][1] = 1;
		if (!((((int)((P2 *)_this)->i)<10)))
			continue;
		_m = 3; goto P999; /* 0 */
	case 63: // STATE 2 - trabajo.pml:158 - [((UserConts[i]>1))] (0:0:0 - 1)
		IfNotBlocked
		reached[2][2] = 1;
		if (!((((int)now.UserConts[ Index(((int)((P2 *)_this)->i), 10) ])>1)))
			continue;
		_m = 3; goto P999; /* 0 */
	case 64: // STATE 3 - trabajo.pml:159 - [usersCh!i] (0:0:0 - 1)
		IfNotBlocked
		reached[2][3] = 1;
		if (q_full(now.usersCh))
			continue;
#ifdef HAS_CODE
		if (readtrail && gui) {
			char simtmp[64];
			sprintf(simvals, "%d!", now.usersCh);
		sprintf(simtmp, "%d", ((int)((P2 *)_this)->i)); strcat(simvals, simtmp);		}
#endif
		
		qsend(now.usersCh, 0, ((int)((P2 *)_this)->i), 0, 0, 0, 1);
		_m = 2; goto P999; /* 0 */
	case 65: // STATE 5 - trabajo.pml:161 - [(1)] (11:0:1 - 1)
		IfNotBlocked
		reached[2][5] = 1;
		if (!(1))
			continue;
		/* merge: .(goto)(11, 7, 11) */
		reached[2][7] = 1;
		;
		/* merge: i = (i+1)(11, 8, 11) */
		reached[2][8] = 1;
		(trpt+1)->bup.oval = ((int)((P2 *)_this)->i);
		((P2 *)_this)->i = (((int)((P2 *)_this)->i)+1);
#ifdef VAR_RANGES
		logval("DetectUsers:i", ((int)((P2 *)_this)->i));
#endif
		;
		/* merge: .(goto)(0, 12, 11) */
		reached[2][12] = 1;
		;
		_m = 3; goto P999; /* 3 */
	case 66: // STATE 8 - trabajo.pml:163 - [i = (i+1)] (0:11:1 - 3)
		IfNotBlocked
		reached[2][8] = 1;
		(trpt+1)->bup.oval = ((int)((P2 *)_this)->i);
		((P2 *)_this)->i = (((int)((P2 *)_this)->i)+1);
#ifdef VAR_RANGES
		logval("DetectUsers:i", ((int)((P2 *)_this)->i));
#endif
		;
		/* merge: .(goto)(0, 12, 11) */
		reached[2][12] = 1;
		;
		_m = 3; goto P999; /* 1 */
	case 67: // STATE 14 - trabajo.pml:170 - [usersCh!255] (0:0:0 - 3)
		IfNotBlocked
		reached[2][14] = 1;
		if (q_full(now.usersCh))
			continue;
#ifdef HAS_CODE
		if (readtrail && gui) {
			char simtmp[64];
			sprintf(simvals, "%d!", now.usersCh);
		sprintf(simtmp, "%d", 255); strcat(simvals, simtmp);		}
#endif
		
		qsend(now.usersCh, 0, 255, 0, 0, 0, 1);
		_m = 2; goto P999; /* 0 */
	case 68: // STATE 15 - trabajo.pml:171 - [-end-] (0:0:0 - 1)
		IfNotBlocked
		reached[2][15] = 1;
		if (!delproc(1, II)) continue;
		_m = 3; goto P999; /* 0 */

		 /* PROC Worker */
	case 69: // STATE 1 - trabajo.pml:108 - [records?userKey,targetKey,typeKey,textKey] (0:0:4 - 1)
		reached[1][1] = 1;
		if (q_len(now.records) == 0) continue;

		XX=1;
		(trpt+1)->bup.ovals = grab_ints(4);
		(trpt+1)->bup.ovals[0] = ((int)((P1 *)_this)->userKey);
		(trpt+1)->bup.ovals[1] = ((int)((P1 *)_this)->targetKey);
		(trpt+1)->bup.ovals[2] = ((int)((P1 *)_this)->typeKey);
		(trpt+1)->bup.ovals[3] = ((int)((P1 *)_this)->textKey);
		;
		((P1 *)_this)->userKey = qrecv(now.records, XX-1, 0, 0);
#ifdef VAR_RANGES
		logval("Worker:userKey", ((int)((P1 *)_this)->userKey));
#endif
		;
		((P1 *)_this)->targetKey = qrecv(now.records, XX-1, 1, 0);
#ifdef VAR_RANGES
		logval("Worker:targetKey", ((int)((P1 *)_this)->targetKey));
#endif
		;
		((P1 *)_this)->typeKey = qrecv(now.records, XX-1, 2, 0);
#ifdef VAR_RANGES
		logval("Worker:typeKey", ((int)((P1 *)_this)->typeKey));
#endif
		;
		((P1 *)_this)->textKey = qrecv(now.records, XX-1, 3, 1);
#ifdef VAR_RANGES
		logval("Worker:textKey", ((int)((P1 *)_this)->textKey));
#endif
		;
		
#ifdef HAS_CODE
		if (readtrail && gui) {
			char simtmp[32];
			sprintf(simvals, "%d?", now.records);
		sprintf(simtmp, "%d", ((int)((P1 *)_this)->userKey)); strcat(simvals, simtmp);		strcat(simvals, ",");
		sprintf(simtmp, "%d", ((int)((P1 *)_this)->targetKey)); strcat(simvals, simtmp);		strcat(simvals, ",");
		sprintf(simtmp, "%d", ((int)((P1 *)_this)->typeKey)); strcat(simvals, simtmp);		strcat(simvals, ",");
		sprintf(simtmp, "%d", ((int)((P1 *)_this)->textKey)); strcat(simvals, simtmp);		}
#endif
		;
		_m = 4; goto P999; /* 0 */
	case 70: // STATE 2 - trabajo.pml:112 - [((userKey==255))] (0:0:1 - 1)
		IfNotBlocked
		reached[1][2] = 1;
		if (!((((int)((P1 *)_this)->userKey)==255)))
			continue;
		if (TstOnly) return 1; /* TT */
		/* dead 1: userKey */  (trpt+1)->bup.oval = ((P1 *)_this)->userKey;
#ifdef HAS_CODE
		if (!readtrail)
#endif
			((P1 *)_this)->userKey = 0;
		_m = 3; goto P999; /* 0 */
	case 71: // STATE 5 - trabajo.pml:119 - [((mutex==0))] (17:0:8 - 1)
		IfNotBlocked
		reached[1][5] = 1;
		if (!((((int)now.mutex)==0)))
			continue;
		/* merge: mutex = 1(17, 6, 17) */
		reached[1][6] = 1;
		(trpt+1)->bup.ovals = grab_ints(8);
		(trpt+1)->bup.ovals[0] = ((int)now.mutex);
		now.mutex = 1;
#ifdef VAR_RANGES
		logval("mutex", ((int)now.mutex));
#endif
		;
		/* merge: UserConts[userKey] = (UserConts[userKey]+1)(17, 7, 17) */
		reached[1][7] = 1;
		(trpt+1)->bup.ovals[1] = ((int)now.UserConts[ Index(((int)((P1 *)_this)->userKey), 10) ]);
		now.UserConts[ Index(((P1 *)_this)->userKey, 10) ] = (((int)now.UserConts[ Index(((int)((P1 *)_this)->userKey), 10) ])+1);
#ifdef VAR_RANGES
		logval("UserConts[Worker:userKey]", ((int)now.UserConts[ Index(((int)((P1 *)_this)->userKey), 10) ]));
#endif
		;
		/* merge: TargetConts[targetKey] = (TargetConts[targetKey]+1)(17, 8, 17) */
		reached[1][8] = 1;
		(trpt+1)->bup.ovals[2] = ((int)now.TargetConts[ Index(((int)((P1 *)_this)->targetKey), 10) ]);
		now.TargetConts[ Index(((P1 *)_this)->targetKey, 10) ] = (((int)now.TargetConts[ Index(((int)((P1 *)_this)->targetKey), 10) ])+1);
#ifdef VAR_RANGES
		logval("TargetConts[Worker:targetKey]", ((int)now.TargetConts[ Index(((int)((P1 *)_this)->targetKey), 10) ]));
#endif
		;
		/* merge: TypeConts[typeKey] = (TypeConts[typeKey]+1)(17, 9, 17) */
		reached[1][9] = 1;
		(trpt+1)->bup.ovals[3] = ((int)now.TypeConts[ Index(((int)((P1 *)_this)->typeKey), 10) ]);
		now.TypeConts[ Index(((P1 *)_this)->typeKey, 10) ] = (((int)now.TypeConts[ Index(((int)((P1 *)_this)->typeKey), 10) ])+1);
#ifdef VAR_RANGES
		logval("TypeConts[Worker:typeKey]", ((int)now.TypeConts[ Index(((int)((P1 *)_this)->typeKey), 10) ]));
#endif
		;
		/* merge: TextConts[textKey] = (TextConts[textKey]+1)(17, 10, 17) */
		reached[1][10] = 1;
		(trpt+1)->bup.ovals[4] = ((int)now.TextConts[ Index(((int)((P1 *)_this)->textKey), 10) ]);
		now.TextConts[ Index(((P1 *)_this)->textKey, 10) ] = (((int)now.TextConts[ Index(((int)((P1 *)_this)->textKey), 10) ])+1);
#ifdef VAR_RANGES
		logval("TextConts[Worker:textKey]", ((int)now.TextConts[ Index(((int)((P1 *)_this)->textKey), 10) ]));
#endif
		;
		/* merge: pairIndex = ((userKey+targetKey)%10)(17, 11, 17) */
		reached[1][11] = 1;
		(trpt+1)->bup.ovals[5] = ((int)((P1 *)_this)->pairIndex);
		((P1 *)_this)->pairIndex = ((((int)((P1 *)_this)->userKey)+((int)((P1 *)_this)->targetKey))%10);
#ifdef VAR_RANGES
		logval("Worker:pairIndex", ((int)((P1 *)_this)->pairIndex));
#endif
		;
		/* merge: PairConts[pairIndex] = (PairConts[pairIndex]+1)(17, 12, 17) */
		reached[1][12] = 1;
		(trpt+1)->bup.ovals[6] = ((int)now.PairConts[ Index(((int)((P1 *)_this)->pairIndex), 10) ]);
		now.PairConts[ Index(((P1 *)_this)->pairIndex, 10) ] = (((int)now.PairConts[ Index(((int)((P1 *)_this)->pairIndex), 10) ])+1);
#ifdef VAR_RANGES
		logval("PairConts[Worker:pairIndex]", ((int)now.PairConts[ Index(((int)((P1 *)_this)->pairIndex), 10) ]));
#endif
		;
		/* merge: mutex = 0(17, 13, 17) */
		reached[1][13] = 1;
		(trpt+1)->bup.ovals[7] = ((int)now.mutex);
		now.mutex = 0;
#ifdef VAR_RANGES
		logval("mutex", ((int)now.mutex));
#endif
		;
		/* merge: .(goto)(0, 16, 17) */
		reached[1][16] = 1;
		;
		/* merge: .(goto)(0, 18, 17) */
		reached[1][18] = 1;
		;
		_m = 3; goto P999; /* 10 */
	case 72: // STATE 20 - trabajo.pml:138 - [done!id] (0:0:0 - 3)
		IfNotBlocked
		reached[1][20] = 1;
		if (q_full(now.done))
			continue;
#ifdef HAS_CODE
		if (readtrail && gui) {
			char simtmp[64];
			sprintf(simvals, "%d!", now.done);
		sprintf(simtmp, "%d", ((int)((P1 *)_this)->id)); strcat(simvals, simtmp);		}
#endif
		
		qsend(now.done, 0, ((int)((P1 *)_this)->id), 0, 0, 0, 1);
		_m = 2; goto P999; /* 0 */
	case 73: // STATE 21 - trabajo.pml:139 - [-end-] (0:0:0 - 1)
		IfNotBlocked
		reached[1][21] = 1;
		if (!delproc(1, II)) continue;
		_m = 3; goto P999; /* 0 */

		 /* PROC Reader */
	case 74: // STATE 1 - trabajo.pml:56 - [((i<10))] (0:0:0 - 1)
		IfNotBlocked
		reached[0][1] = 1;
		if (!((((int)((P0 *)_this)->i)<10)))
			continue;
		_m = 3; goto P999; /* 0 */
	case 75: // STATE 2 - trabajo.pml:68 - [records!(i%2),(i%4),(i%6),(i%8)] (0:0:0 - 1)
		IfNotBlocked
		reached[0][2] = 1;
		if (q_full(now.records))
			continue;
#ifdef HAS_CODE
		if (readtrail && gui) {
			char simtmp[64];
			sprintf(simvals, "%d!", now.records);
		sprintf(simtmp, "%d", (((int)((P0 *)_this)->i)%2)); strcat(simvals, simtmp);		strcat(simvals, ",");
		sprintf(simtmp, "%d", (((int)((P0 *)_this)->i)%4)); strcat(simvals, simtmp);		strcat(simvals, ",");
		sprintf(simtmp, "%d", (((int)((P0 *)_this)->i)%6)); strcat(simvals, simtmp);		strcat(simvals, ",");
		sprintf(simtmp, "%d", (((int)((P0 *)_this)->i)%8)); strcat(simvals, simtmp);		}
#endif
		
		qsend(now.records, 0, (((int)((P0 *)_this)->i)%2), (((int)((P0 *)_this)->i)%4), (((int)((P0 *)_this)->i)%6), (((int)((P0 *)_this)->i)%8), 4);
		_m = 2; goto P999; /* 0 */
	case 76: // STATE 3 - trabajo.pml:74 - [i = (i+1)] (0:0:1 - 1)
		IfNotBlocked
		reached[0][3] = 1;
		(trpt+1)->bup.oval = ((int)((P0 *)_this)->i);
		((P0 *)_this)->i = (((int)((P0 *)_this)->i)+1);
#ifdef VAR_RANGES
		logval("Reader:i", ((int)((P0 *)_this)->i));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 77: // STATE 9 - trabajo.pml:81 - [i = 0] (0:15:1 - 3)
		IfNotBlocked
		reached[0][9] = 1;
		(trpt+1)->bup.oval = ((int)((P0 *)_this)->i);
		((P0 *)_this)->i = 0;
#ifdef VAR_RANGES
		logval("Reader:i", ((int)((P0 *)_this)->i));
#endif
		;
		/* merge: .(goto)(0, 16, 15) */
		reached[0][16] = 1;
		;
		_m = 3; goto P999; /* 1 */
	case 78: // STATE 10 - trabajo.pml:84 - [((i<2))] (0:0:0 - 1)
		IfNotBlocked
		reached[0][10] = 1;
		if (!((((int)((P0 *)_this)->i)<2)))
			continue;
		_m = 3; goto P999; /* 0 */
	case 79: // STATE 11 - trabajo.pml:90 - [records!255,255,255,255] (0:0:0 - 1)
		IfNotBlocked
		reached[0][11] = 1;
		if (q_full(now.records))
			continue;
#ifdef HAS_CODE
		if (readtrail && gui) {
			char simtmp[64];
			sprintf(simvals, "%d!", now.records);
		sprintf(simtmp, "%d", 255); strcat(simvals, simtmp);		strcat(simvals, ",");
		sprintf(simtmp, "%d", 255); strcat(simvals, simtmp);		strcat(simvals, ",");
		sprintf(simtmp, "%d", 255); strcat(simvals, simtmp);		strcat(simvals, ",");
		sprintf(simtmp, "%d", 255); strcat(simvals, simtmp);		}
#endif
		
		qsend(now.records, 0, 255, 255, 255, 255, 4);
		_m = 2; goto P999; /* 0 */
	case 80: // STATE 12 - trabajo.pml:91 - [i = (i+1)] (0:0:1 - 1)
		IfNotBlocked
		reached[0][12] = 1;
		(trpt+1)->bup.oval = ((int)((P0 *)_this)->i);
		((P0 *)_this)->i = (((int)((P0 *)_this)->i)+1);
#ifdef VAR_RANGES
		logval("Reader:i", ((int)((P0 *)_this)->i));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 81: // STATE 18 - trabajo.pml:95 - [-end-] (0:0:0 - 3)
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

