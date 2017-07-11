/**
 * AUIGrid 에서 사용되는 메세지들을 정의합니다.
 */
AUIGridMessages = {
		/*
		 * 그리드에 출력시킬 데이터가 없는 메세지 
		 */
		noDataMessage: gridMsg["sys.info.grid.noDataMessage"], //"출력할 데이터가 없습니다.",
		
		/*
		 * 그룹핑 패널 메세지
		 */
		groupingMessage: gridMsg["sys.info.grid.groupingMessage"], //"여기에 칼럼을 드래그하면 그룹핑이 됩니다.",
		
		/*
		 * 필터 메뉴 메세지들 
		 */
		filterNoValueText: gridMsg["sys.info.grid.filterNoValueText"], //"(필드 값 없음)",
		filterCheckAllText: gridMsg["sys.info.grid.filterCheckAllText"], //"(전체선택)",
		filterClearText: gridMsg["sys.info.grid.filterClearText"], //"필터 초기화",
		filterSearchCheckAllText: gridMsg["sys.info.grid.filterSearchCheckAllText"], //"(검색 전체선택)",
		filterSearchPlaceholder : gridMsg["sys.info.grid.filterSearchPlaceholder"], //"검색", // 필터 검색 플레이홀더 텍스트
		filterOkText: gridMsg["sys.info.grid.filterOkText"], //"확 인",
		filterCancelText: gridMsg["sys.info.grid.filterCancelText"], //"취 소",
		filterItemMoreMessage: gridMsg["sys.info.grid.filterItemMoreMessage"], //"Too many items...Search words",
		filterNumberOperatorList: [gridMsg["sys.info.grid.filterNumberOperatorList.eq"], //"같다(=)"
		                           gridMsg["sys.info.grid.filterNumberOperatorList.gt"], //"크다(>)"
		                           gridMsg["sys.info.grid.filterNumberOperatorList.gte"], //"크거나 같다(>=)"
		                           gridMsg["sys.info.grid.filterNumberOperatorList.lt"], //"작다(<)"
		                           gridMsg["sys.info.grid.filterNumberOperatorList.lte"], //"작거나 같다(<=)"
		                           gridMsg["sys.info.grid.filterNumberOperatorList.ne"] //"같지 않다(!=)"
		],
		
		/*
		 * 천 단위 구분자
		 */
		thousandSeparator : ",",
		
		/*
		 * 그룹핑 썸머리 합계 메세지
		 */
		summaryText: gridMsg["sys.info.grid.summaryText"], //"합계",
		
		/*
		 * 행번호 칼럼의 헤더 텍스트
		 */
		rowNumHeaderText: gridMsg["sys.info.grid.rowNumHeaderText"], //"No.",
		
		/*
		 * 원격(리모트) 리스트 렌더러 검색 텍스트
		 */
		remoterPlaceholder: gridMsg["sys.info.grid.remoterPlaceholder"], //"검색어를 입력하세요.",
		
		/* 
		 * 기본 컨텍스트 메뉴 
		 */
		contextTexts: [gridMsg["sys.info.grid.contextTexts.showonly"], //"$value 만 보기", 
		               gridMsg["sys.info.grid.contextTexts.showall.except"], //"$value 제거하고 다 보기", 
		               gridMsg["sys.info.grid.contextTexts.hide"], //"$value 제거하고 보기", 
		               gridMsg["sys.info.grid.contextTexts.clear.filter"], //"모든 필터링 초기화", 
		               gridMsg["sys.info.grid.contextTexts.fixed.col"], //"칼럼 틀 고정", 
		               gridMsg["sys.info.grid.contextTexts.clear.fixed.col"], //"칼럼 틀 고정 초기화"
		               ],
		
		/*
		 * 달력
		 */
		calendar : {
			titles : [gridMsg["sys.info.grid.calendar.titles.sun"], //"일", 
			          gridMsg["sys.info.grid.calendar.titles.mon"], //"월", 
			          gridMsg["sys.info.grid.calendar.titles.tue"], //"화", 
			          gridMsg["sys.info.grid.calendar.titles.wed"], //"수", 
			          gridMsg["sys.info.grid.calendar.titles.thur"], //"목", 
			          gridMsg["sys.info.grid.calendar.titles.fri"], //"금", 
			          gridMsg["sys.info.grid.calendar.titles.sat"], //"토"
			          ],
			formatYearString : gridMsg["sys.info.grid.calendar.formatYearString"], //"yyyy년",
			monthTitleString : gridMsg["sys.info.grid.calendar.monthTitleString"], //"m월",
			formatMonthString : gridMsg["sys.info.grid.calendar.formatMonthString"], //"yyyy년 mm월",
			todayText : gridMsg["sys.info.grid.calendar.todayText"], //"오늘 선택",
			uncheckDateText : gridMsg["sys.info.grid.calendar.uncheckDateText"], //"날짜 선택 해제"
		}
};