package com.coway.trust.cmmn.model;

import java.util.Collections;
import java.util.List;

import com.coway.trust.AppConstants;

public class DisplayPagination<T> {
	private int currentPageNo;
	private long totalRecordCount;
	private int recordCountPerPage = AppConstants.RECORD_COUNT_PER_PAGE;
	private List<T> recordList = Collections.emptyList();

	private DisplayPagination() {
	}

	public static <T> DisplayPagination create(int currentPageNo, long totalRecordCount, List<T> list) {
		DisplayPagination displayPagination = new DisplayPagination();
		displayPagination.currentPageNo = currentPageNo;
		displayPagination.totalRecordCount = totalRecordCount;
		displayPagination.recordList = list;

		return displayPagination;
	}

	public static <T> DisplayPagination create(int currentPageNo, int recordCountPerPage, long totalRecordCount,
			List<T> list) {
		DisplayPagination displayPagination = new DisplayPagination();
		displayPagination.currentPageNo = currentPageNo;
		displayPagination.recordCountPerPage = recordCountPerPage;
		displayPagination.totalRecordCount = totalRecordCount;
		displayPagination.recordList = list;

		return displayPagination;
	}

	public int getCurrentPageNo() {
		return currentPageNo;
	}

	public long getTotalRecordCount() {
		return totalRecordCount;
	}

	public int getRecordCountPerPage() {
		return recordCountPerPage;
	}

	public List<T> getRecordList() {
		return recordList;
	}
	
}
