<!--=================================================================================================
* Task  : Logistics
* File Name : serialLastInfoMgmt.jsp
* Description : Serial No. Last Info Management
* Author : KR-OHK
* Date : 2019-11-25
* Change History :
* ------------------------------------------------------------------------------------------------
* [No]  [Date]        [Modifier]     [Contents]
* ------------------------------------------------------------------------------------------------
*  1     2019-11-25  KR-OHK        Init
*=================================================================================================-->
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>

<script type="text/javaScript" language="javascript">
    var myGridID;
    var detailGridID;
    var mSort = {};
    var gSelMainRowIdx;

    var stusDs = [];
    <c:forEach var="obj" items="${stusList}">
      stusDs.push({code:"${obj.code}", codeName:"${obj.codeName}"});
    </c:forEach>

    $(document).ready(function() {
    	createAUIGrid();
    	createAUIHistoryGrid();

    	// main grid paging
        GridCommon.createExtPagingNavigator(1, 0, {funcName:'getListAjax'});

        AUIGrid.setGridData(myGridID, []);
        AUIGrid.setGridData(detailGridID, []);

        doGetComboData('/common/selectCodeList.do', { groupCode : 339 , orderValue : 'CODE'}, '${defLocType}', 'listLocType', 'M','f_multiCombo');
        CommonCombo.make('stusCode', '/common/selectCodeList.do', {groupCode : 446, orderValue: "CODE"} , '', {id:'code', type: 'S'});

        $("#btnSearch").click(function() {
        	getListAjax(1)
        });

        $("#btnSave").click(function() {

        	if(!fn_checkValid()){
                return false;
            }

        	fn_saveSerialLastInfo();
        });

        //excel Download
        $('#excelDown').click(function() {
           GridCommon.exportTo("grid_main_list", "xlsx", "Serial No. Last Info Management");
        });

        // main grid button
        $("#btnAdd").click(function(){
            var addList = AUIGrid.getAddedRowItems(myGridID);

            var item = new Object();
            AUIGrid.addRow(myGridID, item, "first");

        });

        $("#btnDel").click(function(){
        	var selectedItems = AUIGrid.getSelectedItems(myGridID);
            if(selectedItems.length <= 0 ){
                  Common.alert("There are no selected Items.");
                  return ;
            }

            AUIGrid.removeRow(myGridID, "selectedIndex");
        });

        // header Click
        /*
        AUIGrid.bind(myGridID, "headerClick", function( event ) {
            console.log(event.type + " : " + event.headerText + ", dataField : " + event.dataField + ", index : " + event.columnIndex + ", depth : " + event.item.depth);
            //return false; // 정렬 실행 안함.

            var span = $(myGridID).find(".aui-grid-header-panel").find("tbody > tr > td > div")[event.columnIndex];
            if(mSort.hasOwnProperty(event.dataField)){
                if(mSort[event.dataField].dir == "asc"){
                    mSort[event.dataField] = {"field":event.dataField, "dir":"desc" };
                    $(span).removeClass("aui-grid-sorting-ascending");
                    $(span).addClass("aui-grid-sorting-descending");
                }else{
                    delete mSort[event.dataField];
                    $(span).removeClass("aui-grid-sorting-descending");
                }
            }else{
                mSort[event.dataField] = {"field":event.dataField, "dir":"asc"};
                $(span).addClass("aui-grid-sorting-ascending");
            }

            getListAjax(1);
        });*/

        AUIGrid.bind(myGridID, "cellDoubleClick", function( event )
        {
        	var serialNo = AUIGrid.getCellValue(myGridID, event.rowIndex, "hidSerialNo");

            if(!FormUtil.isEmpty(serialNo)){
	            var serialNo = AUIGrid.getCellValue(myGridID, event.rowIndex, "serialNo");
	            var hidSerialNo = AUIGrid.getCellValue(myGridID, event.rowIndex, "hidSerialNo");

	            if(FormUtil.isEmpty(hidSerialNo)) {
	            	return false;
	            }
	            AUIGrid.setCheckedRowsByValue(myGridID, "serialNo", serialNo);
	            var subParam = {"serialNo":serialNo};

	            Common.ajax("GET", "/logistics/serialLastMgmt/selectSerialLastInfoHistoryList.do"
	                    , subParam
	                    , function(result){
	                           console.log("data : " + result);
	                           AUIGrid.setGridData(detailGridID, result.dataList);
	            });
            }
        });

        AUIGrid.bind(myGridID, "beforeRemoveRow", function(event) {
            var items = event.items;
            var item;
            var isOk = true;
            for(var i=0, len=items.length; i<len; i++) {
                item = items[i];
                if(FormUtil.isNotEmpty(item.hidSerialNo)) {
                    Common.alert("You cannot delete a Serial that is already registered.");
                    return false;
                }
            }
        });

        AUIGrid.bind(myGridID, "cellEditBegin", auiCellEditignHandler);
        AUIGrid.bind(myGridID, "cellEditEnd", auiCellEditignHandler);
    });

    function createAUIGrid() {
    	var columnLayout = [
            {dataField:"serialNo", headerText:"Serial No", width:170, height:30, headerStyle:"aui-grid-header-input-icon aui-grid-header-input-essen"
            	 , editRenderer : {
                     type : "InputEditRenderer",
                     maxlength : 18
                 }
            },
            {dataField:"stusCode", headerText:"In/Out", width:80, height:30, headerStyle:"aui-grid-header-input-icon aui-grid-header-input-essen"
            	,labelFunction : function(rowIndex, columnIndex, value, headerText, item ) {
                    var retStr = "";
                    for(var i=0, len=stusDs.length; i<len; i++) {
                        if(stusDs[i]["code"] == value) {
                            retStr = stusDs[i]["codeName"];
                            break;
                        }
                    }
                    return retStr;
                }
                ,editRenderer : {
                    type : "DropDownListRenderer",
                    showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
                    list : stusDs, //key-value Object 로 구성된 리스트
                    keyField : "code", // key 에 해당되는 필드명
                    valueField : "codeName", // value 에 해당되는 필드명
                    listAlign : "left"
                },
            },
            {dataField:"lastLocId", headerText:"Location Id", width:100, height:30, editable:false, visible:false},
            {dataField:"lastLocCode", headerText:"Location Code", width:150, height:30, headerStyle:"aui-grid-header-input-icon aui-grid-header-input-essen", editable:false
            	, renderer : {
                  type : "IconRenderer",
                  iconWidth : 24, // icon 가로 사이즈, 지정하지 않으면 24로 기본값 적용됨
                  iconHeight : 24,
                  iconPosition : "aisleRight",
                  iconTableRef :  { // icon 값 참조할 테이블 레퍼런스
                      "default" : "${pageContext.request.contextPath}/resources/images/common/normal_search.png" //
                  },
                  onclick : function(rowIndex, columnIndex, value, item)
                  {
                      console.log("onclick: ( " + rowIndex + ", " + columnIndex + " ) " + item.lastLocCode + " POPUP Click");
                      gSelMainRowIdx = rowIndex;
                      fn_locSearchPopUp();
                  }
               }
            },
            {dataField:"lastLocType", headerText:"Location Type", width:120, height:30, editable:false},
            {dataField:"lastSalesOrdId", headerText:"Order Id", width:100, height:30, editable:false, visible:false},
            {dataField:"lastSalesOrdNo", headerText:"Order No.", width:120, height:30, editable:false, headerStyle:"aui-grid-header-input-icon"
            	, renderer : {
                  type : "IconRenderer",
                  iconWidth : 24, // icon 가로 사이즈, 지정하지 않으면 24로 기본값 적용됨
                  iconHeight : 24,
                  iconPosition : "aisleRight",
                  iconTableRef :  { // icon 값 참조할 테이블 레퍼런스
                      "default" : "${pageContext.request.contextPath}/resources/images/common/normal_search.png" //
                  },
                  onclick : function(rowIndex, columnIndex, value, item)
                  {
                      console.log("onclick: ( " + rowIndex + ", " + columnIndex + " ) " + item.lastLocCode + " POPUP Click");
                      gSelMainRowIdx = rowIndex;
                      fn_orderSearchPop();
                  }
               }
            },
            {dataField:"itmCode", headerText:"Item Code", width:120, height:30, headerStyle:"aui-grid-header-input-icon aui-grid-header-input-essen", editable:false
            	, renderer : {
                  type : "IconRenderer",
                  iconWidth : 24, // icon 가로 사이즈, 지정하지 않으면 24로 기본값 적용됨
                  iconHeight : 24,
                  iconPosition : "aisleRight",
                  iconTableRef :  { // icon 값 참조할 테이블 레퍼런스
                      "default" : "${pageContext.request.contextPath}/resources/images/common/normal_search.png" //
                  },
                  onclick : function(rowIndex, columnIndex, value, item)
                  {
                      console.log("onclick: ( " + rowIndex + ", " + columnIndex + " ) " + item.itmCode + " POPUP Click");
                      gSelMainRowIdx = rowIndex;
                      fn_itemSearchPopUp();
                  }
               }
            },
            {dataField:"stkDesc", headerText:"Item Description", width:300, height:30, style:"aui-grid-user-custom-left", editable:false},
            {dataField:"lastLocStkGrad", headerText:"Stock Grade", width:100, height:30, editable:false},
            {dataField:"lastDelvryGrDt", headerText:"GR Date", width:120, dataType:"date", dateInputFormat:"dd/mm/yyyy", formatString:"dd/mm/yyyy", headerStyle:"aui-grid-header-input-icon"
            	   , editRenderer : {
                     type:"CalendarRenderer"
                   , onlyMonthMode:false
                   , showEditorBtnOver:true
                   , showExtraDays : true // 지난 달, 다음 달 여분의 날짜(days) 출력
                   //, defaultFormat:"dd/mm/yyyy" // 달력 선택 시 데이터에 적용되는 날짜 형식
                   , onlyCalendar:true // 사용자 입력 불가, 즉 달력으로만 날짜입력 (기본값 : true)
                   , maxlength:10 // 10자리 이하만 입력 가능
                   //, openDirectly : true  // 에디팅 진입 시 바로 달력 열기
                   , onlyNumeric : false // 숫자
               }
            },
            {dataField:"lastCustId", headerText:"Customer ID", width:100, height:30, editable:false},
            {dataField:"lastCustName", headerText:"Customer Name", width:200, height:30, style:"aui-grid-user-custom-left", editable:false},
            {dataField:"lastReqstNo", headerText:"Request No.", width:130, height:30, headerStyle:"aui-grid-header-input-icon"
            	, editRenderer : {
                    type : "InputEditRenderer",
                    maxlength : 18
                }
            },
            {dataField:"lastReqstNoItm", headerText:"Request No. Item", width:130, height:30, headerStyle:"aui-grid-header-input-icon"
            	, style:"aui-grid-user-custom-right"
                , dataType:"numeric"
                , editRenderer : {
                    type : "InputEditRenderer",
                    maxlength : 4,
                    showEditorBtnOver : false, // 마우스 오버 시 에디터버턴 보이기
                    onlyNumeric : true, // 0~9만 입력가능
                    allowPoint : false, // 소수점( . ) 도 허용할지 여부
                    allowNegative : false, // 마이너스 부호(-) 허용 여부
                    textAlign : "right", // 오른쪽 정렬로 입력되도록 설정
                    autoThousandSeparator : false // 천단위 구분자 삽입 여부
                }
            },
            {dataField:"lastDelvryNo", headerText:"Delivery No.", width:130, height:30, headerStyle:"aui-grid-header-input-icon"
            	, editRenderer : {
                    type : "InputEditRenderer",
                    maxlength : 23
                }
            },
            {dataField:"lastDelvryNoItm", headerText:"Delivery No. Item", width:130, height:30, headerStyle:"aui-grid-header-input-icon"
            	, style:"aui-grid-user-custom-right"
                , dataType:"numeric"
                , editRenderer : {
                    type : "InputEditRenderer",
                    maxlength : 4,
                    showEditorBtnOver : false, // 마우스 오버 시 에디터버턴 보이기
                    onlyNumeric : true, // 0~9만 입력가능
                    allowPoint : false, // 소수점( . ) 도 허용할지 여부
                    allowNegative : false, // 마이너스 부호(-) 허용 여부
                    textAlign : "right", // 오른쪽 정렬로 입력되도록 설정
                    autoThousandSeparator : false // 천단위 구분자 삽입 여부
                }
            },
            {dataField:"tempScanNo", headerText:"Temporary Scan No.", width:160, height:30, headerStyle:"aui-grid-header-input-icon"
                , editRenderer : {
                    type : "InputEditRenderer",
                    maxlength : 23
                }
            },
            {dataField:"crtUserName", headerText:"Create User", width:120, height:30, style:"aui-grid-user-custom-left", editable:false},
            {dataField:"crtDt", headerText:"Create Date Time", width:140, editable:false},
            {dataField:"updUserName", headerText:"Update User", width:120, height:30, style:"aui-grid-user-custom-left", editable:false},
            {dataField:"updDt", headerText:"Update Date Time", width:140, editable:false},
            {dataField:"hidSerialNo", headerText:"Serial No", width:170, height:30, editable:false, visible:false }
        ];

    	var gridOptions = {
    	    // 페이지 설정
    	    usePaging : false,
    	    showFooter : false,
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
    	    useGroupingPanel : false,
    	    enableSorting : true,
    	    showStateColumn : true,      // 상태 칼럼 사용
    	    softRemovePolicy : "exceptNew" //사용자추가한 행은 바로 삭제
    	};

    	myGridID = GridCommon.createAUIGrid("grid_main_list", columnLayout, "", gridOptions);

    	/*AUIGrid.bind(myGridID, "cellEditBegin", function(event) {
            if(event.dataField == "stusCode" || event.dataField == "lastLocCode" || event.dataField == "itmCode") {
            	console.log("event.dataField: " + event.dataField);
                // 추가된 행 아이템인지 조사하여 추가된 행인 경우만 에디팅 진입 허용
                if(AUIGrid.isAddedById(event.pid, event.item.id)) {
                    return true;
                } else {
                    return false; // false 반환하면 기본 행위 안함(즉, cellEditBegin 의 기본행위는 에디팅 진입임)
                }
            }
            return true; // 다른 필드들은 편집 허용
        });*/
    }

    function createAUIHistoryGrid() {
        var detailColumnLayout = [
            {dataField:"serialNo", headerText:"Serial No", width:170, height:30},
            {dataField:"seq", headerText:"Seq", width:50, height:30},
            {dataField:"stusCode", headerText:"In/Out", width:80, height:30
                ,labelFunction : function(rowIndex, columnIndex, value, headerText, item ) {
                    var retStr = "";
                    for(var i=0, len=stusDs.length; i<len; i++) {
                        if(stusDs[i]["code"] == value) {
                            retStr = stusDs[i]["codeName"];
                            break;
                        }
                    }
                    return retStr;
                }
                ,editRenderer : {
                    type : "DropDownListRenderer",
                    showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
                    list : stusDs, //key-value Object 로 구성된 리스트
                    keyField : "code", // key 에 해당되는 필드명
                    valueField : "codeName", // value 에 해당되는 필드명
                    listAlign : "left"
                },
            },
            {dataField:"lastLocId", headerText:"Location Id", width:100, height:30, editable:false, visible:false},
            {dataField:"lastLocCode", headerText:"Location Code", width:150, height:30, editable:false},
            {dataField:"lastLocType", headerText:"Location Type", width:120, height:30, editable:false},
            {dataField:"lastSalesOrdId", headerText:"Order Id", width:100, height:30, editable:false, visible:false},
            {dataField:"lastSalesOrdNo", headerText:"Order No.", width:120, height:30, editable:false},
            {dataField:"itmCode", headerText:"Item Code", width:120, height:30, editable:false},
            {dataField:"stkDesc", headerText:"Item Description", width:300, height:30, style:"aui-grid-user-custom-left", editable:false},
            {dataField:"lastLocStkGrad", headerText:"Stock Grade", width:100, height:30, editable:false},
            {dataField:"lastDelvryGrDt", headerText:"GR Date", width:120, dataType:"date", dateInputFormat:"dd/mm/yyyy", formatString:"dd/mm/yyyy"},
            {dataField:"lastCustId", headerText:"Customer ID", width:100, height:30, editable:false},
            {dataField:"lastCustName", headerText:"Customer Name", width:200, height:30, style:"aui-grid-user-custom-left", editable:false},
            {dataField:"lastReqstNo", headerText:"Request No.", width:130, height:30},
            {dataField:"lastReqstNoItm", headerText:"Request No. Item", width:130, height:30},
            {dataField:"lastDelvryNo", headerText:"Delivery No.", width:130, height:30},
            {dataField:"lastDelvryNoItm", headerText:"Delivery No. Item", width:130, height:30},
            {dataField:"tempScanNo", headerText:"Temporary Scan No.", width:160, height:30},
            {dataField:"crtUserName", headerText:"Create User", width:120, height:30, style:"aui-grid-user-custom-left", editable:false},
            {dataField:"crtDt", headerText:"Create Date Time", width:140, editable:false},
            {dataField:"updUserName", headerText:"Update User", width:120, height:30, style:"aui-grid-user-custom-left", editable:false},
            {dataField:"updDt", headerText:"Update Date Time", width:140, editable:false}
        ];

        var detailGridPros = {
            // 페이지 설정
            usePaging : false,
            showFooter : false,
            // 편집 가능 여부 (기본값 : false)
            editable : false,
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
            enableSorting : true,
            showStateColumn : false
        };

        detailGridID = GridCommon.createAUIGrid("grid_sub_list", detailColumnLayout,'',detailGridPros);
    }

    function fn_checkValid(){

        var length =  AUIGrid.getGridData(myGridID).length;

        if(length <= 0) {
            Common.alert('No data added.');
            return false;
        }

    	if(length > 0) {
           for(var i = 0; i < length; i++) {
               if(FormUtil.isEmpty(AUIGrid.getCellValue(myGridID, i, "serialNo"))) {
            	   Common.alert("Serial No is required.");
                   return false;
               }
               if(FormUtil.isEmpty(AUIGrid.getCellValue(myGridID, i, "stusCode"))) {
                   Common.alert("In/Out is required.");
                   return false;
               }
               if(FormUtil.isEmpty(AUIGrid.getCellValue(myGridID, i, "lastLocCode"))) {
                   Common.alert("Location Code is required.");
                   return false;
               }
               if(FormUtil.isEmpty(AUIGrid.getCellValue(myGridID, i, "lastLocType"))) {
                   Common.alert("Location Type is required.");
                   return false;
               }
               if(FormUtil.isEmpty(AUIGrid.getCellValue(myGridID, i, "itmCode"))) {
                   Common.alert("Item Code is required.");
                   return false;
               }
           }
        }

        return true;
    }

    function fn_locSearchPopUp()
    {
    	$("#sUrl").val("/logistics/organization/locationCdSearch.do");
    	$("#sFlag").val("location");
    	Common.searchpopupWin("searchForm", "/common/searchPopList.do", $("#sFlag").val());
    }

    function fn_itemSearchPopUp()
    {
        //$("#svalue").val($("#stkCd").val());
        $("#sUrl").val("/logistics/material/materialcdsearch.do");
        $("#sFlag").val("stock");
        Common.searchpopupWin("searchForm", "/common/searchPopList.do", $("#sFlag").val());
    }

    function fn_itempopList(data) {
        if($("#sFlag").val()  == "location")  {
        	AUIGrid.setCellValue(myGridID, gSelMainRowIdx, 2, data[0].item.locid);
	    	AUIGrid.setCellValue(myGridID, gSelMainRowIdx, 3, data[0].item.locdesc);
	        AUIGrid.setCellValue(myGridID, gSelMainRowIdx, 4, data[0].item.locgbnm);
	        AUIGrid.setCellValue(myGridID, gSelMainRowIdx, 9, data[0].item.locgrad);
        } else if ($("#sFlag").val()  == "stock") {
	        AUIGrid.setCellValue(myGridID, gSelMainRowIdx, 7, data[0].item.itemcode);
	        AUIGrid.setCellValue(myGridID, gSelMainRowIdx, 8, data[0].item.itemname);
        }
    }

    function fn_orderSearchPop(){
    	Common.popupDiv("/sales/order/orderSearchPop.do", {callPrgm : "SERIAL", indicator : "SearchOrder"});
    }

    //Search Order 팝업에서 결과값 받기
    function fn_orderInfo(ordNo){

        //Order Basic 정보 조회
        Common.ajax("GET", "/logistics/serialLastMgmt/selectOrderBasicInfoByOrderId.do", {"orderNo" : ordNo}, function(result) {

        //Order Info
        AUIGrid.setCellValue(myGridID, gSelMainRowIdx, 5, result.ordId);
        AUIGrid.setCellValue(myGridID, gSelMainRowIdx, 6, result.ordNo);

        AUIGrid.setCellValue(myGridID, gSelMainRowIdx, 7, result.stkCode);
        AUIGrid.setCellValue(myGridID, gSelMainRowIdx, 8, result.stkDesc);
        AUIGrid.setCellValue(myGridID, gSelMainRowIdx, 9, result.stkGrad);

        AUIGrid.setCellValue(myGridID, gSelMainRowIdx, 11, result.custId);
        AUIGrid.setCellValue(myGridID, gSelMainRowIdx, 12, result.custName);
        });
    }

    function getListAjax(goPage) {

    	if(FormUtil.isEmpty($("#serialNo").val()) && FormUtil.isEmpty($("#itmCode").val()) && FormUtil.isEmpty($("#requestNo").val()) && FormUtil.isEmpty($("#custId").val()) && FormUtil.isEmpty($("#orderNo").val()) && FormUtil.isEmpty($("#deliveryNo").val())) {
    		var locCodeVal = $("#locCode option:selected").val();

            if( FormUtil.isEmpty(locCodeVal)) {
               Common.alert('Please enter Location Code.');
               return false;
            }
        }

        var url = "/logistics/serialLastMgmt/selectSerialLastInfoList.do";

        var param = $("#searchForm").serializeJSON();
        //param.sMemAccId = $("#sMemAccId").val();

        var sortList = [];
        $.each(mSort, function(idx, row){
            sortList.push(row);
        });

        param = $.extend(param, {"rowCount":5000, "goPage":goPage}, {"sort":sortList});

        // 초기화
        AUIGrid.setGridData(myGridID, []);

        Common.ajax("POST" , url , param , function(data){
            // 그리드 페이징 네비게이터 생성

            GridCommon.createExtPagingNavigator(goPage, data.total, {funcName:'getListAjax', rowCount:5000 });

            AUIGrid.setGridData(myGridID, data.dataList);
            AUIGrid.setGridData(detailGridID, []);

        });
    }

    function fn_saveSerialLastInfo() {

        var obj = $("#searchForm").serializeJSON();
        var gridData = GridCommon.getEditData(myGridID);

        if ($("#pageAuthAdd").val() == 'Y'){ // add = Y
        	if ($("#pageAuthEdit").val() == 'Y'){ // edit = Y
        		if(gridData.add.length == 0 && gridData.update.length == 0){
        			Common.alert("No changes");
                    return false;
        		}
        	} else {// add = Y, edit = 'N'
        		if (gridData.update.length > 0){
        			Common.alert("You have no authorization to Edit.");
                    return false;
        		} else if (gridData.add.length == 0 && gridData.update.length == 0){
        			Common.alert("No changes");
                    return false;
        		}
        	}
        } else { // add = N
        	if ($("#pageAuthEdit").val() == 'Y'){
                if(gridData.add.length == 0 && gridData.update.length == 0){
                    Common.alert("No changes");
                    return false;
                }
            } else {// add = N, edit = 'N'
                if (gridData.update.length > 0){
                    Common.alert("You have no authorization to Edit.");
                    return false;
                } else if (gridData.add.length == 0 && gridData.update.length == 0){
                    Common.alert("No changes");
                    return false;
                }
            }
        }

        obj.gridData = gridData;

        if(Common.confirm("Do you want to save?", function(){
	        Common.ajax("POST", "/logistics/serialLastMgmt/saveSerialLastInfo.do", obj , function(result)    {
	            console.log("성공." + JSON.stringify(result));
	            console.log("data : " + result.data);
	            Common.alert(result.message);
	            getListAjax(1);
	        });
        }));
    }

    function f_multiCombo() {
        $(function() {
            $('#listLocType').change(function() {
                if ($('#listLocType').val() != null && $('#listLocType').val() != "" ){
                    var searchlocgb = $('#listLocType').val();

                    var locgbparam = "";
                    for (var i = 0 ; i < searchlocgb.length ; i++){
                        if (locgbparam == ""){
                            locgbparam = searchlocgb[i];
                         }else{
                            locgbparam = locgbparam +"∈"+searchlocgb[i];
                         }
                     }

                     var param = {searchlocgb:locgbparam , grade:""}
                     //doGetComboData('/common/selectStockLocationList2.do', param , '', 'locCode', 'M','f_multiComboType');
                     CommonCombo.make('locCode', '/common/selectStockLocationList2.do', param , '${defLocCode}', {type: 'M', id:'codeId', name:'codeName', width:'68%', isCheckAll:false});
                  }
            }).multipleSelect({
                selectAll : true
            });
        });
    }

    function f_multiComboType() {
        $(function() {
            $('#locCode').change(function() {
            }).multipleSelect({
                selectAll : true
            });
        });
    }

    function auiCellEditignHandler(event)
    {
        if(event.type == "cellEditBegin") {
            if (event.dataField == "serialNo")
            {
            	var hidSerialNo = AUIGrid.getCellValue(myGridID, event.rowIndex, "hidSerialNo");

            	if(FormUtil.isNotEmpty(hidSerialNo)) {
            		return false;
            	}
            }
        } else if(event.type == "cellEditEnd") {
            //console.log("에디팅 종료(cellEditEnd) : ( " + event.rowIndex + ", " + event.columnIndex + " ) " + event.headerText + ", value : " + event.value);

            if (event.dataField == "itmCode")
            {
        	    if (event.which == '13'){
	        	    //$("#svalue").val(event.value);
        	    }
            }
        }
    }

</script>

<section id="content"><!-- content start -->
    <ul class="path">
        <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
        <li>Logistics</li>
        <li>S/N Management</li>
        <li>GR Serial No. Scanning</li>
    </ul>

    <aside class="title_line"><!-- title_line start -->
        <p class="fav"><a href="#" class="click_add_on">My menu</a></p>
        <h2>Serial No. Last Info Management</h2>

        <ul class="right_btns">
        <li><p class="btn_blue"><a id="btnSave">Save</a></p></li>
        <c:if test="${PAGE_AUTH.funcView == 'Y'}">
            <li><p class="btn_blue"><a id="btnSearch"><span class="search"></span>Search</a></p></li>
        </c:if>
        </ul>
    </aside><!-- title_line end -->

    <section class="search_table"><!-- search_table start -->
        <form id="searchForm" name="searchForm">
        <input type="hidden" id="svalue" name="svalue"/>
        <input type="hidden" id="sUrl" name="sUrl"  />
        <input type="hidden" id="sFlag" name="sFlag"  />
        <input type="hidden" id="pageAuthEdit" value="${PAGE_AUTH.funcUserDefine1}"/>
        <input type="hidden" id="pageAuthAdd" value="${PAGE_AUTH.funcChange}"/>
            <table class="type1"><!-- table start -->
                <caption>table</caption>
                <colgroup>
                    <col style="width:200px" />
                    <col style="width:*" />
                </colgroup>
                <tbody>
                    <tr>
                        <th scope="row">GR Date</th>
                        <td>
                            <div class="date_set w100p">
                                <!-- date_set start -->
                                <p>
                                    <input id="grSDate" name="grSDate" type="text" title="GR Start Date" placeholder="DD/MM/YYYY" class="j_date" />
                                </p>
                                <span> To </span>
                                <p>
                                    <input id="grEDate" name="grEDate" type="text" title="GR End Date" placeholder="DD/MM/YYYY" class="j_date" />
                                </p>
                            </div>
                        </td>
                        <th scope="row">Location Type<span class="must">*</span></th>
                        <td>
                            <select id="listLocType" name="listLocType[]" class="multy_select w100p" multiple="multiple">
                            </select>
                        </td>
                        <th scope="row">Location Code<span class="must">*</span></th>
                        <td>
                            <select class="w100p" id="locCode" name="locCode[]"><option value="">Choose One</option></select>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Serial No.</th>
                        <td>
                            <input type="text"  id="serialNo" name="serialNo"  class="w100p" />
                        </td>
                        <th scope="row">Item Code</th>
                        <td>
                            <input type="text"  id="itmCode" name="itmCode"  class="w100p" />
                        </td>
                        <th scope="row">Request No.</th>
                        <td>
                            <input type="text"  id="requestNo" name="requestNo"  class="w100p" />
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Customer ID</th>
                        <td>
                            <input type="text"  id="custId" name="custId"  class="w100p" />
                        </td>
                        <th scope="row">Order No.</th>
                        <td>
                            <input type="text"  id="orderNo" name="orderNo"  class="w100p" />
                        </td>
                        <th scope="row">Delivery No.</th>
                        <td>
                            <input type="text"  id="deliveryNo" name="deliveryNo"  class="w100p" />
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Status</th>
                        <td colspan="5">
                            <select class="w50p" id="stusCode" name="stusCode"></select>
                        </td>
                    </tr>
                </tbody>
            </table><!-- table end -->
        </form>
	</section><!-- search_table end -->

     <section class="search_result"><!-- search_result start -->
        <ul class="right_btns">
          <c:if test="${PAGE_AUTH.funcChange == 'Y'}">
            <li><p class="btn_grid"><a id="btnAdd">Add</a></p></li>
            <li><p class="btn_grid"><a id="btnDel">Del</a></p></li>
          </c:if>
          <c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
            <li><p class="btn_grid"><a href="#" id="excelDown"><spring:message code='sys.btn.excel.dw'/></a></p></li>
          </c:if>
        </ul>

        <article class="grid_wrap"><!-- grid_wrap start -->
            <div id="grid_main_list" style="height:300px;"></div>

            <!-- 그리드 페이징 네비게이터 -->
            <div id="grid_paging" class="aui-grid-paging-panel my-grid-paging-panel autoFixArea"></div>
        </article><!-- grid_wrap end -->

        <aside class="title_line"><!-- title_line start -->
           <h3>Serial History</h3>
        </aside><!-- title_line end -->
        <article class="grid_wrap" ><!-- grid_wrap start -->
          <!--  그리드 영역2  -->
          <div id="grid_sub_list" class="autoGridHeight"></div>
        </article><!-- grid_wrap end -->
    </section><!-- search_result end -->

</section><!-- content end -->