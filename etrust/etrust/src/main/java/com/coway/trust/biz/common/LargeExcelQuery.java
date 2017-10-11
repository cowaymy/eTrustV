package com.coway.trust.biz.common;

import java.util.HashMap;
import java.util.Map;

public enum LargeExcelQuery {

	CMM0013T("selectCMM0013T"), CMM0014T("selectCMM0014T");
	private final String queryId;

	LargeExcelQuery(String queryId) {
		this.queryId = queryId;
	}

	public String getQueryId() {
		return this.queryId;
	}

	private static final Map<String, LargeExcelQuery> lookup = new HashMap<>();

	static {
		for (LargeExcelQuery largeExcelQuery : LargeExcelQuery.values()) {
			lookup.put(largeExcelQuery.getQueryId(), largeExcelQuery);
		}
	}

	public static LargeExcelQuery get(String queryId) {
		return lookup.get(queryId);
	}
}
