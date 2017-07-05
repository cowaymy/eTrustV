// GridCommon.
/*
 * AUIGrid에 대한 함수 중 공통으로 쓸 수 있는 함수들은 개발자 분들도 같이 구현 부탁 드려요~ 
 */
var GridCommon = {
		
		// AUIGrid 를 생성합니다.
		createAUIGrid : function(_sGridId, columnLayout) {
	        
	        // 그리드 속성 설정
	        var gridPros = {

	                // 편집 가능 여부 (기본값 : false)
	                editable : true,
	                
	                // 엔터키가 다음 행이 아닌 다음 칼럼으로 이동할지 여부 (기본값 : false)
	                enterKeyColumnBase : true,
	                
	                // 셀 선택모드 (기본값: singleCell)
	                selectionMode : "multipleCells",
	                
	                // 컨텍스트 메뉴 사용 여부 (기본값 : false)
	                useContextMenu : true,
	                
	                // 필터 사용 여부 (기본값 : false)
	                enableFilter : true,
	            
	                // 그룹핑 패널 사용
	                useGroupingPanel : true,
	                
	                // 상태 칼럼 사용
	                showStateColumn : true,
	                
	                // 그룹핑 또는 트리로 만들었을 때 펼쳐지게 할지 여부 (기본값 : false)
	                displayTreeOpen : true,
	                
	                noDataMessage : "출력할 데이터가 없습니다.",
	                
	                groupingMessage : "여기에 칼럼을 드래그하면 그룹핑이 됩니다."
	        };

	        // 실제로 #_sGridId 에 그리드 생성
	        return AUIGrid.create("#" + _sGridId, columnLayout, gridPros);
	    },

		// 행/열 로 선택한 셀의 값을 리턴.
		getCellValue : function(gridID, rowIdx, colIdx){
	        // ex) 3번째 행의 1 번째 칼럼 즉, (3, 1) 의 셀의 값 얻기
	        var cellValue = AUIGrid.getCellValue(gridID, rowIdx, colIdx);
	        return cellValue;
	    },
	    
	    // 행/컬럼Name으로 선택한 셀의 값을 리턴.
	    getCellValue : function(gridID, rowIdx, colName){
	        // rowIdx 번째 행의 name 칼럼의 값 얻기
	        var cellValue = AUIGrid.getCellValue(gridID, rowIdx, colName);
	        return cellValue;
	    }
};
