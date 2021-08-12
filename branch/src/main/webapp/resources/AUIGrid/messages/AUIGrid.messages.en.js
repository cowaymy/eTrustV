/**
 * AUIGrid 에서 사용되는 메세지들을 정의합니다.
 */
AUIGridMessages = {
		/*
		 * 그리드에 출력시킬 데이터가 없는 메세지 
		 */
		noDataMessage: gridMsg["sys.info.grid.noDataMessage"], //"No Data to display",
		
		/*
		 * 그룹핑 패널 메세지
		 */
		groupingMessage: gridMsg["sys.info.grid.groupingMessage"], //"Drag a column header and drop here to group by that",
		
		/*
		 * 필터 메뉴 메세지들 
		 */
		filterNoValueText: gridMsg["sys.info.grid.filterNoValueText"], //"( Empty Value )",
		filterCheckAllText: gridMsg["sys.info.grid.filterCheckAllText"], //"( Check All )",
		filterClearText: gridMsg["sys.info.grid.filterClearText"], //"Clear Filter",
		filterSearchCheckAllText: gridMsg["sys.info.grid.filterSearchCheckAllText"], //"( Check All Found )",
		filterSearchPlaceholder : gridMsg["sys.info.grid.filterSearchPlaceholder"], //"Search", // 필터 검색 플레이홀더 텍스트
		filterOkText: gridMsg["sys.info.grid.filterOkText"], //"Okay",
		filterCancelText: gridMsg["sys.info.grid.filterCancelText"], //"Cancel",
		filterItemMoreMessage: gridMsg["sys.info.grid.filterItemMoreMessage"], //"Too many items...Search words",
		filterNumberOperatorList: [gridMsg["sys.info.grid.filterNumberOperatorList.eq"], //"Equal(=)", 
		                           gridMsg["sys.info.grid.filterNumberOperatorList.gt"], //"Greater than(>)", 
		                           gridMsg["sys.info.grid.filterNumberOperatorList.gte"], //"Greater than or Equal(>=)", 
		                           gridMsg["sys.info.grid.filterNumberOperatorList.lt"], // "Less than(<)", 
		                           gridMsg["sys.info.grid.filterNumberOperatorList.lte"], //"Less than or Equal(<=)", 
		                           gridMsg["sys.info.grid.filterNumberOperatorList.ne"] // "Not Equal(!=)"
		                            ],
	   
		/*
		 * 천 단위 구분자
		 */
		thousandSeparator : ",",
		
		/*
		 * 그룹핑 썸머리 합계 메세지
		 */
		summaryText: gridMsg["sys.info.grid.summaryText"], //"Summary",
		
		/*
		 * 행번호 칼럼의 헤더 텍스트
		 */
		rowNumHeaderText: gridMsg["sys.info.grid.rowNumHeaderText"], //"No.",
		
		/*
		 * 원격(리모트) 리스트 렌더러 검색 텍스트
		 */
		remoterPlaceholder: gridMsg["sys.info.grid.remoterPlaceholder"], //"Input your text",
		
		/* 
		 * 기본 컨텍스트 메뉴 
		 */
		contextTexts: [gridMsg["sys.info.grid.contextTexts.showonly"], //"Show only $value", 
		               gridMsg["sys.info.grid.contextTexts.showall.except"], //"Show all except $value", 
		               gridMsg["sys.info.grid.contextTexts.hide"], //"Hide $value", 
		               gridMsg["sys.info.grid.contextTexts.clear.filter"], //"Clear Filtering All", 
		               gridMsg["sys.info.grid.contextTexts.fixed.col"], //"Fixed Columns", 
		               gridMsg["sys.info.grid.contextTexts.clear.fixed.col"], //"Clear Fixed Columns all"
		               ],
		
		/*
		 * 달력
		 */
		calendar : {
			titles : [gridMsg["sys.info.grid.calendar.titles.sun"], //"S", 
			          gridMsg["sys.info.grid.calendar.titles.mon"], //"M", 
			          gridMsg["sys.info.grid.calendar.titles.tue"], //"T", 
			          gridMsg["sys.info.grid.calendar.titles.wed"], //"W", 
			          gridMsg["sys.info.grid.calendar.titles.thur"], //"T", 
			          gridMsg["sys.info.grid.calendar.titles.fri"], //"F", 
			          gridMsg["sys.info.grid.calendar.titles.sat"], //"S"
			          ],
			formatYearString : gridMsg["sys.info.grid.calendar.formatYearString"], //"yyyy",
			monthTitleString : gridMsg["sys.info.grid.calendar.monthTitleString"], //"mmm",
			formatMonthString : gridMsg["sys.info.grid.calendar.formatMonthString"], //"mmm, yyyy",
			todayText : gridMsg["sys.info.grid.calendar.todayText"], //"Today",
			uncheckDateText : gridMsg["sys.info.grid.calendar.uncheckDateText"], //"Delete the date"
		}
};