// GridCommon.
/*
 * AUIGrid에 대한 함수 중 공통으로 쓸 수 있는 함수들은 개발자 분들도 같이 구현 부탁 드려요~ 
 */
var GridCommon = {
		
		// AUIGrid 를 생성합니다.
		createAUIGrid : function(_sGridId, _columnLayout, _sRowIdField, _options) {
	        
	        // 그리드 속성 설정
			// http://www.auisoft.net/documentation/auigrid/index.html
	        var gridPros = {

	                // 편집 가능 여부 (기본값 : false)
	                editable : true,
	                
	                // 페이징 사용.
	                usePaging : true,
	                
	                pageRowCount : 20,
	                
	                // 엔터키가 다음 행이 아닌 다음 칼럼으로 이동할지 여부 (기본값 : false)
	                enterKeyColumnBase : true,
	                
	                // 셀 선택모드 (기본값: singleCell)
	                selectionMode : "multipleCells",
	                
	                // 컨텍스트 메뉴 사용 여부 (기본값 : false)
	                useContextMenu : true,
	                
	                // 필터 사용 여부 (기본값 : false)
	                enableFilter : true,
	            
	                // 그룹핑 패널 사용
	                useGroupingPanel : false,
	                
	                // 상태 칼럼 사용
	                showStateColumn : true,
	                
	                // 행 아이템간의 중복되지 않는 값.
	                rowIdField : _sRowIdField,
	                
	                // 그룹핑 또는 트리로 만들었을 때 펼쳐지게 할지 여부 (기본값 : false)
	                displayTreeOpen : true,
	                
	                noDataMessage : gridMsg["sys.info.grid.noDataMessage"], //"출력할 데이터가 없습니다.",
	                
	                groupingMessage : gridMsg["sys.info.grid.groupingMessage"] // "여기에 칼럼을 드래그하면 그룹핑이 됩니다."
	        };
	        
	        gridPros = $.extend(gridPros, _options);
	        
	        

	        // 실제로 #_sGridId 에 그리드 생성
	        return AUIGrid.create(GridCommon.makeGridId(_sGridId), _columnLayout, gridPros);
	    },
	    
	    /**
	     * loading .... 표시.
	     * @param _sGridId
	     */
	    showLoader : function(_sGridId){
	    	_sGridId = GridCommon.makeGridId(_sGridId);
	    	AUIGrid.showAjaxLoader(GridCommon.makeGridId(_sGridId));
	    },
	    
	    /**
	     * loading .... 해제.
	     * @param _sGridId
	     */
	    removeLoader : function(_sGridId){
	    	_sGridId = GridCommon.makeGridId(_sGridId);
	    	AUIGrid.removeAjaxLoader(GridCommon.makeGridId(_sGridId));
	    },
	    
	    /**
	     * 그리드 파일 export
	     * @param type
	     */
	    exportTo : function(_sGridId, _type, _fileName) {
	    	
	    	_sGridId = GridCommon.makeGridId(_sGridId);
	    	
	    	var param = "";
	    	
	    	if(FormUtil.isNotEmpty(_fileName)){
	    		param = "?filename=" + _fileName;
	    	}
	        
	        // 그리드가 작성한 엑셀, CSV 등의 데이터를 다운로드 처리할 서버 URL을 지시합니다.
	        AUIGrid.setProp(_sGridId, "exportURL", "/common/exportGrid.do" + param);
	        
	        // 내보내기 실행  
	        switch(_type) {
	        case "xlsx":
	            AUIGrid.exportToXlsx(_sGridId, {
	                // 스타일 상태 유지 여부(기본값:true)
	                exportWithStyle : true
	            });
	            break;
	        case "csv":
	            AUIGrid.exportToCsv(_sGridId);
	            break;
	        case "txt":
	            AUIGrid.exportToTxt(_sGridId);
	            break;
	        case "xml":
	            AUIGrid.exportToXml(_sGridId);
	            break;
	        case "json":
	            AUIGrid.exportToJson(_sGridId);
	            break;
	        case "pdf":
	            if(!AUIGrid.isAvailabePdf(_sGridId)) {
	                alert(gridMsg["sys.warn.grid.pdf"]); // 'PDF 저장은 HTML5를 지원하는 최신 브라우저에서 가능합니다.(IE는 10부터 가능)'
	                return;
	            }
	            AUIGrid.exportToPdf(_sGridId, {
	                // 폰트 경로 지정(변경시 라이센스 확인 필.)
	                fontPath : "/resources/font/jejugothic-regular.ttf"
	            });
	            break;
	        case "object": // array-object 는 자바스크립트 객체임
	            var data = AUIGrid.exportToObject(_sGridId);
	            alert( data );
	            break;
	        }
	    },

		// 행/열 로 선택한 셀의 값을 리턴.
		getCellValue : function(gridID, rowIdx, colIdx){
			gridID = GridCommon.makeGridId(gridID);
	        // ex) 3번째 행의 1 번째 칼럼 즉, (3, 1) 의 셀의 값 얻기
	        var cellValue = AUIGrid.getCellValue(gridID, rowIdx, colIdx);
	        return cellValue;
	    },
	    
	    // 행/컬럼Name으로 선택한 셀의 값을 리턴.
	    getCellValue : function(gridID, rowIdx, colName){
	    	gridID = GridCommon.makeGridId(gridID);
	        // rowIdx 번째 행의 name 칼럼의 값 얻기
	        var cellValue = AUIGrid.getCellValue(gridID, rowIdx, colName);
	        return cellValue;
	    },
	    
	    // 편집된 그리드 데이터 가져오기.
	    getEditData : function(gridID){
	    	gridID = GridCommon.makeGridId(gridID);
	    	// 추가된 행 아이템들(배열)
	    	var addList = AUIGrid.getAddedRowItems(gridID);
	    	// 수정된 행 아이템들(배열)
	    	//var updateList = AUIGrid.getEditedRowColumnItems(gridID);
	    	var updateList = AUIGrid.getEditedRowItems(gridID); 
	    	// 삭제된 행 아이템들(배열)
	    	var removeList = AUIGrid.getRemovedItems(gridID);

	    	var data = {};
	    	
	    	if(addList.length > 0) data.add = addList;
	    	else data.add = [];
	    	
	    	if(updateList.length > 0) data.update = updateList;
	    	else data.update = [];
	    	
	    	if(removeList.length > 0) data.remove = removeList;
	    	else data.remove = [];
	    	
	    	return data;
	    },
	    
	    // 그리드 전체 데이터 가져오기.
	    getGridData : function(gridID){
	    	gridID = GridCommon.makeGridId(gridID);
	    	// 전체  행 아이템들(배열)
	    	var allList = AUIGrid.getGridData(gridID);
	    	
	    	var data = {};
	    	
	    	if(addList.length > 0) data.all = allList;
	    	else data.all = [];
	    	
	    	return data;
	    },
	    
	    makeGridId : function(gridID){
	    	var firstChar = gridID.substr(0, 1);
	    	if(firstChar == "#"){
	    		return gridID;
	    	}else{
	    		return "#" + gridID;
	    	}
	    }
	    
};
