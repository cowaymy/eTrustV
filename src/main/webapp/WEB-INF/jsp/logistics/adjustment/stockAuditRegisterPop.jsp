<!--=================================================================================================
* Task  : Logistics
* File Name : stockAuditRegisterPop.jsp
* Description : Stock Audit Doc Create
* Author : KR-OHK
* Date : 2019-10-08
* Change History :
* ------------------------------------------------------------------------------------------------
* [No]  [Date]        [Modifier]     [Contents]
* ------------------------------------------------------------------------------------------------
*  1     2019-10-08  KR-OHK        Init
*=================================================================================================-->
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>

<script type="text/javascript">

    var resGrid,reqGrid,itemResGrid,itemReqGrid ;

    var rescolumnLayout=[
                         {dataField: "rnum",headerText :"<spring:message code='log.head.rnum'/>" ,width:1 ,height:30 , visible:false },
                         {dataField: "codeName",headerText :"<spring:message code='log.head.locationtype'/>" ,width: 120   ,height:30 },
                         {dataField: "whLocCode",headerText :"<spring:message code='log.head.locationcode'/>"    ,width: 120    ,height:30},
                         {dataField: "whLocDesc",headerText :"<spring:message code='log.head.locationdesc'/>"    ,width: 350    ,height:30, style: "aui-grid-user-custom-left"},
                         {dataField: "whLocId",headerText :"<spring:message code='log.head.locationid'/>"    ,width: 100    ,height:30 },
                         {dataField: "serialRequireChkYn",headerText :"Serial Require Check Y/N"    ,width: 180    ,height:30 }
                 ];


    var reqcolumnLayout=[
                     {dataField: "adjrnum",headerText :"<spring:message code='log.head.rnum'/>"  ,width:1 ,height:30 , visible:false },
                     {dataField: "adjcodeName",headerText :"<spring:message code='log.head.locationtype'/>"  ,width: 120    ,height:30 },
                     {dataField: "adjwhLocCode",headerText :"<spring:message code='log.head.locationcode'/>" ,width: 120    ,height:30},
                     {dataField: "adjwhLocDesc",headerText :"<spring:message code='log.head.locationdesc'/>" ,width: 350    ,height:30, style: "aui-grid-user-custom-left"},
                     {dataField: "adjwhLocId",headerText :"<spring:message code='log.head.locationid'/>" ,width: 100    ,height:30 },
                     {dataField: "adjserialRequireChkYn",headerText :"Serial Require Check Y/N" ,width: 180    ,height:30 }
                     ];

    var itemrescolumnLayout=[
                         {dataField: "rnum",headerText :"<spring:message code='log.head.rnum'/>" ,width:1 ,height:30 , visible:false },
                         {dataField: "stkId",headerText :"<spring:message code='log.head.rnum'/>" ,width:1 ,height:30  , visible:false},
                         {dataField: "stkGrad",headerText :"<spring:message code='log.head.rnum'/>" ,width:1 ,height:30  , visible:false},
                         {dataField: "stkType",headerText :"<spring:message code='log.head.itemtype'/>"    ,width: 100    ,height:30 },
                         {dataField: "stkCtgryType",headerText :"<spring:message code='log.head.categoryType'/>" ,width: 120   ,height:30 },
                         {dataField: "stkCode",headerText :"<spring:message code='log.head.itemcode'/>"    ,width: 100    ,height:30},
                         {dataField: "stkDesc",headerText :"<spring:message code='log.head.itemname'/>"    ,width: 350    ,height:30, style: "aui-grid-user-custom-left"}
                 ];

    var itemreqcolumnLayout=[
                     {dataField: "adjrnum",headerText :"<spring:message code='log.head.rnum'/>"  ,width:1 ,height:30 , visible:false },
                     {dataField: "adjstkId",headerText :"<spring:message code='log.head.rnum'/>" ,width:1 ,height:30 , visible:false },
                     {dataField: "adjstkGrad",headerText :"<spring:message code='log.head.rnum'/>" ,width:1 ,height:30  , visible:false},
                     {dataField: "adjstkType",headerText :"<spring:message code='log.head.itemtype'/>" ,width: 100    ,height:30 },
                     {dataField: "adjstkCtgryType",headerText :"<spring:message code='log.head.categoryType'/>"  ,width: 120    ,height:30 },
                     {dataField: "adjstkCode",headerText :"<spring:message code='log.head.itemcode'/>" ,width: 100    ,height:30},
                     {dataField: "adjstkDesc",headerText :"<spring:message code='log.head.itemname'/>" ,width: 350    ,height:30, style: "aui-grid-user-custom-left"}
                      ];

    var resop = {
    		rowIdField : "rnum",
    		showRowCheckColumn : true,
    		showStateColumn : false,      // 상태 칼럼 사용
    		usePaging : false,
    		Editable:false};

    var reqop = {
    		usePaging : false,
    		showRowCheckColumn : true,
    		showStateColumn : false,      // 상태 칼럼 사용
    		useGroupingPanel : false,
    		Editable:false};

    var itemresop = {
            rowIdField : "rnum",
            showRowCheckColumn : true,
            showStateColumn : false,      // 상태 칼럼 사용
            usePaging : false,
            Editable:false};

    var itemreqop = {
            usePaging : false,
            showRowCheckColumn : true,
            showStateColumn : false,      // 상태 칼럼 사용
            useGroupingPanel : false,
            Editable:false};

    $(document).ready(function () {
    	resGrid = GridCommon.createAUIGrid("res_grid_wrap", rescolumnLayout,"", resop);
        reqGrid = GridCommon.createAUIGrid("req_grid_wrap", reqcolumnLayout,"", reqop);
        itemResGrid = GridCommon.createAUIGrid("item_res_grid_wrap", itemrescolumnLayout,"", itemresop);
        itemReqGrid = GridCommon.createAUIGrid("item_req_grid_wrap", itemreqcolumnLayout,"", itemreqop);

        if('${action}' == 'MOD') {
        	fn_selectAduitEditInfoAjax('${stockAuditNo}');
        	//AUIGrid.setGridData(reqGrid, $.parseJSON('${locList}'));
            //AUIGrid.setGridData(itemReqGrid, $.parseJSON('${itemList}'));
        } else {
        	CommonCombo.make('locType', '/logistics/adjustment/selectCodeList.do', {groupCode : 339}, '', {type: 'M', isCheckAll:false});
            CommonCombo.make('itemType', '/logistics/adjustment/selectCodeList.do', {groupCode : 15}, '', {type: 'M', isCheckAll:false});
            CommonCombo.make('catagoryType', '/logistics/adjustment/selectCodeList.do', {groupCode : 11} , '', {type: 'M', isCheckAll:false});
            CommonCombo.make('locGrade', '/common/selectCodeList.do', {groupCode : 383, orderValue: "CODE"} , '', {id:'code', type: 'M', isCheckAll:false});
            CommonCombo.make('docStusCodeId', '/common/selectCodeList.do', {groupCode : 436, orderValue: "CODE"} , '5678', {type: 'S'});

        }
    });

    function f_multiCombo() {
        $(function() {
            $('#locType, #itemType, #catagoryType').change(function() {
            }).multipleSelect({
                selectAll : true
            });
        });
    }

    function searchLocationListAjax(){
        Common.ajax("POST", "/logistics/adjustment/selectLocationList", $("#insertForm").serializeJSON(), function (result) {
            AUIGrid.setGridData(resGrid, result.dataList);
        });
    }

    function searchItemListAjax(){
        Common.ajax("POST", "/logistics/adjustment/selectItemList", $("#insertForm").serializeJSON(), function (result) {
            AUIGrid.setGridData(itemResGrid, result.dataList);
        });
    }

    AUIGrid.bind(resGrid, "rowCheckClick", function(event) {
        var serialRequireChkYn = AUIGrid.getCellValue(resGrid, event.rowIndex, "serialRequireChkYn");
        var checklist = AUIGrid.getCheckedRowItems(resGrid);

        for(var i = 0 ; i < checklist.length ; i++){
             if (checklist[i].item.serialRequireChkYn != event.item.serialRequireChkYn){
                Common.alert("Serial Require Check Y/N is different.");
                var rown = AUIGrid.getRowIndexesByValue(resGrid, "serialRequireChkYn" , serialRequireChkYn);
                for (var i = 0 ; i < rown.length ; i++){
                    AUIGrid.addUncheckedRowsByIds(resGrid, AUIGrid.getCellValue(resGrid, rown[i], "rnum"));
                }
                return false;
            }
        }
    });

    $("#popClose").click(function(){
    	if($("#hidDocStusCodeId").val() == '5679') { // Start Audit
    		   getListAjax(1);
    	}
    });

    $('#locType, #locGrade').change(function() {
    	var locTypeIdx = $("#locType option:selected").index();
        var locGradeIdx = $("#locGrade option:selected").index();

        if( locTypeIdx > -1 && locGradeIdx > -1) {
        	searchLocationListAjax();
        } else if( locTypeIdx == -1 && locGradeIdx == -1) {
        	// Grid Init
            AUIGrid.setGridData(resGrid, []);
            //AUIGrid.setGridData(reqGrid, []);
        }
    });

    $('#itemType, #catagoryType').change(function() {
        var itemTypeIdx = $("#itemType option:selected").index();
        var catagoryTypeIdx = $("#catagoryType option:selected").index();

        if( itemTypeIdx > -1 && catagoryTypeIdx > -1) {
            searchItemListAjax();
        } else if( itemTypeIdx == -1 && catagoryTypeIdx == -1) {
            // Grid Init
            AUIGrid.setGridData(itemResGrid, []);
            //AUIGrid.setGridData(itemReqGrid, []);
        }
    });

    $("#rightbtn").click(function(){
        var sortingInfo = [];
        // 차례로 Country, Name, Price 에 대하여 각각 오름차순, 내림차순, 오름차순 지정.
        sortingInfo[0] = { dataField : "adjwhLocId", sortType : 1 };
        checkedItems = AUIGrid.getCheckedRowItemsAll(resGrid);
        var addedItems = AUIGrid.getColumnValues(reqGrid,"adjwhLocId");
        var adjserialRequireChkYn = AUIGrid.getColumnValues(reqGrid,"adjserialRequireChkYn");

        var bool = true;
        if (checkedItems.length > 0){
            var rowPos = "first";
            var item = new Object();
            var rowList = [];
            var rowIndex = 0;

            if (addedItems.length > 0){
                for (var i = 0 ; i < addedItems.length ; i++){
                    for (var j = 0 ; j < checkedItems.length ;j++){
                        if(addedItems[i] == checkedItems[j].whLocId){
                            Common.alert("Loaction Id :"+checkedItems[j].whLocId+" is already exist.");
                            return false;
                        }
                        if(adjserialRequireChkYn[i] != checkedItems[j].serialRequireChkYn){
                            Common.alert("'Serial Require Check Y/N' is different.");
                            return false;
                        }
                    }
                }
            }

            for (var i = 0 ; i < checkedItems.length ; i++){
                rowList[i] = {
                                adjwhLocId : checkedItems[i].whLocId,
                                adjwhLocCode : checkedItems[i].whLocCode,
                                adjwhLocDesc : checkedItems[i].whLocDesc,
                                adjcodeName: checkedItems[i].codeName,
                                adjserialRequireChkYn: checkedItems[i].serialRequireChkYn
                        }

                AUIGrid.addUncheckedRowsByIds(resGrid, checkedItems[i].rnum);

                rowIndex = AUIGrid.getRowIndexesByValue(resGrid, "whLocId", checkedItems[i].whLocId);
                AUIGrid.removeRow(resGrid, rowIndex);

            }
            AUIGrid.removeSoftRows(resGrid);

            AUIGrid.addRow(reqGrid, rowList, rowPos);
            AUIGrid.setSorting(reqGrid, sortingInfo);

        }
    });

    $('#leftbtn').click(function(){
        var sortingInfo = [];
        sortingInfo[0] = { dataField : "whLocId", sortType : 1 };

        var reqCheckedItems = AUIGrid.getCheckedRowItemsAll(reqGrid);
        var addedItems = AUIGrid.getColumnValues(resGrid,"whLocId");

        if (reqCheckedItems.length > 0){
             var rowPos = "first";
             var item = new Object();
             var rowList = [];
             var rowIndex = 0;

             for (var i = 0 ; i < reqCheckedItems.length ; i++){
                 rowList[i] = {
                                 whLocId : reqCheckedItems[i].adjwhLocId,
                                 whLocCode : reqCheckedItems[i].adjwhLocCode,
                                 whLocDesc : reqCheckedItems[i].adjwhLocDesc,
                                 codeName: reqCheckedItems[i].adjcodeName,
                                 serialRequireChkYn: reqCheckedItems[i].adjserialRequireChkYn
                         }

                 AUIGrid.addUncheckedRowsByIds(reqGrid, reqCheckedItems[i].adjrnum);

                 rowIndex = AUIGrid.getRowIndexesByValue(reqGrid, "adjwhLocId", reqCheckedItems[i].adjwhLocId);
                 AUIGrid.removeRow(reqGrid, rowIndex);
             }
         }

        AUIGrid.removeSoftRows(reqGrid);

        AUIGrid.addRow(resGrid, rowList, rowPos);
        AUIGrid.setSorting(resGrid, sortingInfo);
    });

    $("#itemrightbtn").click(function(){

        var sortingInfo = [];
        // 차례로 Country, Name, Price 에 대하여 각각 오름차순, 내림차순, 오름차순 지정.
        sortingInfo[0] = { dataField : "adjstkCode", sortType : 1 };
        checkedItems = AUIGrid.getCheckedRowItemsAll(itemResGrid);
        var addedItems = AUIGrid.getColumnValues(itemReqGrid,"adjstkCode");

        var bool = true;
        if (checkedItems.length > 0){
            var rowPos = "first";
            var item = new Object();
            var rowList = [];
            var rowIndex = 0;

            if (addedItems.length > 0){
                for (var i = 0 ; i < addedItems.length ; i++){
                    for (var j = 0 ; j < checkedItems.length ;j++){
                        if(addedItems[i] == checkedItems[j].stkCode){
                            Common.alert("Item Code :"+checkedItems[j].stkCode+" is already exist.");
                            return false;
                        }
                    }
                }
            }

            for (var i = 0 ; i < checkedItems.length ; i++){
                rowList[i] = {
                            adjstkId : checkedItems[i].stkId,
                            adjstkGrad : checkedItems[i].stkGrad,
                            adjstkType : checkedItems[i].stkType,
                            adjstkCtgryType : checkedItems[i].stkCtgryType,
                            adjstkCode: checkedItems[i].stkCode,
                            adjstkDesc: checkedItems[i].stkDesc
                        }

                AUIGrid.addUncheckedRowsByIds(itemResGrid, checkedItems[i].rnum);

                rowIndex = AUIGrid.getRowIndexesByValue(itemResGrid, "stkCode", checkedItems[i].stkCode);
                AUIGrid.removeRow(itemResGrid, rowIndex);

            }
            AUIGrid.removeSoftRows(itemResGrid);

            AUIGrid.addRow(itemReqGrid, rowList, rowPos);
            AUIGrid.setSorting(itemReqGrid, sortingInfo);

        }
    });

    $('#itemleftbtn').click(function(){
        var sortingInfo = [];
        sortingInfo[0] = { dataField : "stkCode", sortType : 1 };

        var reqCheckedItems = AUIGrid.getCheckedRowItemsAll(itemReqGrid);
        var addedItems = AUIGrid.getColumnValues(itemResGrid,"stkCode");

        if (reqCheckedItems.length > 0){
             var rowPos = "first";
             var item = new Object();
             var rowList = [];
             var rowIndex = 0;

             for (var i = 0 ; i < reqCheckedItems.length ; i++){
                 rowList[i] = {
                          stkId : reqCheckedItems[i].adjstkId,
                          stkGrad : reqCheckedItems[i].adjstkGrad,
                          stkType : reqCheckedItems[i].adjstkType,
                          stkCtgryType : reqCheckedItems[i].adjstkCtgryType,
                          stkCode: reqCheckedItems[i].adjstkCode,
                          stkDesc: reqCheckedItems[i].adjstkDesc
                         }

                 AUIGrid.addUncheckedRowsByIds(itemReqGrid, reqCheckedItems[i].adjrnum);

                 rowIndex = AUIGrid.getRowIndexesByValue(itemReqGrid, "adjstkCode", reqCheckedItems[i].adjstkCode);
                 AUIGrid.removeRow(itemReqGrid, rowIndex);
             }
         }

        AUIGrid.removeSoftRows(itemReqGrid);

        AUIGrid.addRow(itemResGrid, rowList, rowPos);
        AUIGrid.setSorting(itemResGrid, sortingInfo);
    });

    $('#save').click(function() {

    	if ( true == $(this).parents().hasClass("btn_disabled") ) {
            return  false;
        }

        if(!fn_checkValid()){
        	return  false;
        }

    	$('#docStusCodeId').attr("disabled", false);

        var locGridList = GridCommon.getGridData(reqGrid);
        var itemGridList = GridCommon.getGridData(itemReqGrid);

        var obj = $("#insertForm").serializeJSON();
        obj.appvType = "save"
        obj.locGridList = locGridList;
        obj.itemGridList = itemGridList;

        if(Common.confirm("Do you want to save?", function(){
            Common.ajax("POST", "/logistics/adjustment/createStockAuditDoc.do", obj, function(result) {

	        	if($('#insStockAuditNo').val() == '' ) {
	        		Common.alert(""+result.message+"</br> Created : "+result.data);
	        	} else {
	        		Common.alert(result.message);
	        	}

	        	fn_selectAduitEditInfoAjax(result.data);
	            $('#docStusCodeId').attr("disabled", true);
            });
        }));
    });

    $('#startAudit').click(function() {

        if ( true == $(this).parents().hasClass("btn_disabled") ) {
            return  false;
        }

		if(!fn_checkValid()){
            return  false;
        }

        $('#docStusCodeId').attr("disabled", false);

        var locGridList = GridCommon.getGridData(reqGrid);
        var itemGridList = GridCommon.getGridData(itemReqGrid);

        var obj = $("#insertForm").serializeJSON();
        obj.appvType = "startAudit"
        obj.locGridList = locGridList;
        obj.itemGridList = itemGridList;

        var url = "";

        /*
        if($('#insStockAuditNo').val() == '' ) { // New
            url = "/logistics/adjustment/createStockAuditDoc.do";
        } else { // Edit
            url = "/logistics/adjustment/startStockAudit.do";
        }
        */

        url = "/logistics/adjustment/createStockAuditDoc.do";

        if(Common.confirm("Do you want to start audit?", function(){
                Common.ajax("POST", url, obj, function(result) {//  첨부파일 정보를 공통 첨부파일 테이블 이용 : 웹 호출 테스트
                   	if($('#insStockAuditNo').val() == '' ) {
		                Common.alert(""+result.message+"</br> Created : "+result.data);
		                fn_selectAduitEditInfoAjax(result.data);
		            } else {
		                Common.alert(result.message);
		                fn_selectAduitEditInfoAjax($('#insStockAuditNo').val());
		            }

                   	$('#docStusCodeId').attr("disabled", true);
                });
        }));
    });

    function fn_checkValid(){

        var locTypeIdx = $("#locType option:selected").index();
        var locGradeIdx = $("#locGrade option:selected").index();
        var itemTypeIdx = $("#itemType option:selected").index();
        var catagoryTypeIdx = $("#catagoryType option:selected").index();
        var locGridList = AUIGrid.getGridData(reqGrid);
        var itemGridList = AUIGrid.getGridData(itemReqGrid);

        if(FormUtil.checkReqValue($("#insDocStartDt"),false) || FormUtil.checkReqValue($("#insDocEndDt"),false)){
           var arg = "<spring:message code='log.head.stockAuditDate' />";
           Common.alert("<spring:message code='sys.msg.necessary' arguments='"+ arg +"'/>");
           return false;
       }

       var currDate = new Date();

       var docStartDt = $('#insDocStartDt').val();
       var docStartDtArr = docStartDt.split('/');
       var docEndDt = $('#insDocEndDt').val();
       var docEndDtArr = docEndDt.split('/');

       var newCurrDate = new Date(currDate.getFullYear(), currDate.getMonth(), currDate.getDate());
       var startDate = new Date(docStartDtArr[2], parseInt(docStartDtArr[1])-1, docStartDtArr[0]);
       var endDate = new Date(docEndDtArr[2], parseInt(docEndDtArr[1])-1, docEndDtArr[0]);

       newCurrDate = newCurrDate.getTime();
       startDate = startDate.getTime();
       endDate = endDate.getTime();

       if((startDate > endDate) || (startDate < newCurrDate) || (endDate < newCurrDate) ) {
    	  var arg = "<spring:message code='log.head.stockAuditDate' />";
          Common.alert("<spring:message code='sys.msg.invalid' arguments='"+ arg +"'/>");
          return false;
      }

      if($("input:radio[name='serialChkYn']:checked").length == 0) {
    	  var arg = "<spring:message code='log.head.serialcheck' />";
    	  Common.alert("<spring:message code='sys.msg.necessary' arguments='"+ arg +"'/>");
          return false;
      }

      if( locTypeIdx == -1) {
           var arg = "<spring:message code='log.head.locationtype' />";
           Common.alert("<spring:message code='sys.msg.necessary' arguments='"+ arg +"'/>");
           return false;
      }

      if(locGradeIdx == -1){
           var arg = "<spring:message code='log.head.locationgrade' />";
           Common.alert("<spring:message code='sys.msg.necessary' arguments='"+ arg +"'/>");
           return false;
      }

       if(itemTypeIdx == -1){
           var arg = "<spring:message code='log.head.itemtype' />";
           Common.alert("<spring:message code='sys.msg.necessary' arguments='"+ arg +"'/>");
           return false;
       }

       if(catagoryTypeIdx == -1){
           var arg = "<spring:message code='log.head.categoryType' />";
           Common.alert("<spring:message code='sys.msg.necessary' arguments='"+ arg +"'/>");
           return false;
       }

       if(FormUtil.checkReqValue($("#stockAuditReason"))){
           var arg = "<spring:message code='log.head.stockAuditReason' />";
           Common.alert("<spring:message code='sys.msg.necessary' arguments='"+ arg +"'/>");
           return false;
       }

       if(locGridList.length == 0) {
    	   var arg = "<spring:message code='log.head.locationcode' />";
           Common.alert("<spring:message code='sys.msg.necessary' arguments='"+ arg +"'/>");
           return false;
       }

       if(itemGridList.length == 0) {
           var arg = "<spring:message code='log.head.itemcode' />";
           Common.alert("<spring:message code='sys.msg.necessary' arguments='"+ arg +"'/>");
           return false;
       }

       var serialRequireChkYn =  locGridList[0].adjserialRequireChkYn;
       var serialChkYn = $("input:radio[name='serialChkYn']:checked").val();

       if(serialRequireChkYn == 'N' && serialChkYn == 'Y'){
           Common.alert("If Serial Require Check Y/N is 'N', Serial Check must be 'N'.");
           return false;
       }

       return true;
    }

    function fn_selectAduitEditInfoAjax(stockAuditNo) {
    	var obj = $("#insertForm").serializeJSON();
        obj.stockAuditNo = stockAuditNo;

        Common.ajax("GET", "/logistics/adjustment/selectStockAuditEditInfo", obj, function (result) {

        	$("#insStockAuditNo").val(result.docInfo.stockAuditNo);
        	$("#insDocStartDt").val(result.docInfo.docStartDt);
        	$("#insDocEndDt").val(result.docInfo.docEndDt);
        	$("#stockAuditReason").val(result.docInfo.stockAuditReason);
        	$("#rem").val(result.docInfo.rem);
        	$("#createInfo").val(result.docInfo.crtUserNm+" / "+result.docInfo.crtDt);
        	$("#updateInfo").val(result.docInfo.updUserNm+" / "+result.docInfo.updDt);
        	$("#hidUpdDtTime").val(result.docInfo.updDtTime);

        	if(result.docInfo.useYn == 'Y') {
        		$("input:radio[name='useYn']:radio[value='Y']").prop("checked", true);
        	} else {
        		$("input:radio[name='useYn']:radio[value='N']").prop("checked", true);
        	}

            if(result.docInfo.serialChkYn == 'Y') {
            	$("input:radio[name='serialChkYn']:radio[value='Y']").prop("checked", true);
            } else {
                $("input:radio[name='serialChkYn']:radio[value='N']").prop("checked", true);
            }

        	if(result.docInfo.docStusCodeId != '5678') {
        		 $("#btnSave").addClass("btn_disabled");
        		 $("#btnStartAudit").addClass("btn_disabled");
        	}

        	$("#hidDocStusCodeId").val(result.docInfo.docStusCodeId);

        	CommonCombo.make('locType', '/logistics/adjustment/selectCodeList.do', {groupCode : 339} , result.docInfo.mLocType, {type: 'M', isCheckAll:false});
            CommonCombo.make('itemType', '/logistics/adjustment/selectCodeList.do', {groupCode : 15} ,result.docInfo.mItmType, {type: 'M', isCheckAll:false});
            CommonCombo.make('catagoryType', '/logistics/adjustment/selectCodeList.do', {groupCode : 11} , result.docInfo.mCtgryType, {type: 'M', isCheckAll:false});
            CommonCombo.make('locGrade', '/common/selectCodeList.do', {groupCode : 383, orderValue: "CODE"} , result.docInfo.mLocStkGrad, {id:'code', type: 'M', isCheckAll:false});
            CommonCombo.make('docStusCodeId', '/common/selectCodeList.do', {groupCode : 436, orderValue: "CODE"} , '5678', {type: 'S'});

        	AUIGrid.setGridData(reqGrid, result.locList);
            AUIGrid.setGridData(itemReqGrid,result.itemList);

        });
    }

</script>


<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

    <header class="pop_header"><!-- pop_header start -->
        <h1>New Stock Audit</h1>
        <ul class="right_opt">
            <li><p id="btnSave" class="btn_blue2"><a id="save">Save</a></p></li>
            <li><p id="btnStartAudit" class="btn_blue2"><a id="startAudit">Start Audit</a></p></li>
            <li><p class="btn_blue2"><a href="#" id="popClose"><spring:message code='sys.btn.close'/></a></p></li>
        </ul>
    </header><!-- pop_header end -->

    <section class="pop_body"><!-- pop_body start -->

        <form id="insertForm">
              <input type="hidden" id="hidUpdDtTime" name="hidUpdDtTime" value="${docInfo.updDtTime}">
			  <input type="hidden" id="hidDocStusCodeId" name="hidDocStusCodeId">
			  <table class="type1"><!-- table start -->
				<caption>table</caption>
				<colgroup>
				    <col style="width:140px" />
				    <col style="width:220px" />
				    <col style="width:140px" />
				    <col style="width:100px" />
				    <col style="width:140px" />
                    <col style="width:100px" />
				</colgroup>
				<tbody>
					<tr>
					    <th scope="row"><spring:message code='log.head.stockauditno'/></th>
					    <td><input id="insStockAuditNo" name="insStockAuditNo" type="text" title="" placeholder="Automatic" class="readonly w100p" readonly="readonly" /></td>
					    <th scope="row"><spring:message code='log.head.docStatus'/></th>
					    <td colspan="3">
					         <select class="w100p" id="docStusCodeId" name="docStusCodeId"  disabled="disabled">
                             </select>
					    </td>
					</tr>
					<tr>
                        <th scope="row"><spring:message code='log.head.stockAuditDate'/><span class="must">*</span></th>
                        <td>
                            <p><input id="insDocStartDt" name="insDocStartDt" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" readonly />
	                        <span>To</span>
	                        <input id="insDocEndDt" name="insDocEndDt" type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" readonly/>
	                        </p>                        </td>
					    <th scope="row"><spring:message code='log.head.serialcheck'/><span class="must">*</span></th>
					    <td>
					        <label><input type="radio" name="serialChkYn" id="serialChkYn" value="Y" <c:if test="${docInfo.serialChkYn == 'Y'}">checked</c:if> /><span>Y</span></label>
	                        <label><input type="radio" name="serialChkYn" id="serialChkYn" value="N" <c:if test="${docInfo.serialChkYn == 'N'}">checked</c:if> /><span>N</span></label>
					    </td>
					    <th scope="row"><spring:message code='log.head.useyn'/><span class="must">*</span></th>
                        <td>
                            <label><input type="radio" name="useYn" id="useYn" value="Y" <c:if test="${docInfo.useYn == 'Y' || docInfo.useYn == null}">checked</c:if> /><span>Y</span></label>
                            <label><input type="radio" name="useYn" id="useYn" value="N" <c:if test="${docInfo.useYn == 'N'}">checked</c:if> /><span>N</span></label>
                        </td>
				    </tr>
                    <tr>
                        <th scope="row"><spring:message code='log.head.locationtype'/><span class="must">*</span></th>
                        <td>
                            <select class="multy_select w100p" multiple="multiple" id="locType" name="locType[]" /></select>
                        </td>
                        <th scope="row"><spring:message code='log.head.locationgrade'/><span class="must">*</span></th>
                        <td colspan="3">
                            <select class="multy_select w100p" multiple="multiple" id="locGrade" name="locGrade[]" /></select>
                        </td>
                    </tr>

				    <tr>
			            <th scope="row"><spring:message code='log.head.itemtype'/><span class="must">*</span></th>
                        <td>
                            <select class="multy_select w100p" multiple="multiple" id="itemType" name="itemType[]" /></select>
                        </td>
                        <th scope="row"><spring:message code='log.head.categoryType'/><span class="must">*</span></th>
                        <td colspan="3">
                            <select class="multy_select w100p" multiple="multiple" id="catagoryType" name="catagoryType[]" /></select>
                        </td>
			        </tr>
			        <tr>
	                      <th scope="row"><spring:message code='log.head.stockAuditReason'/><span class="must">*</span></th>
	                      <td colspan="5"><input type="text" name="stockAuditReason" id="stockAuditReason" class="w100p"/></td>
	                 </tr>
	                 <tr>
	                     <th scope="row"><spring:message code='log.head.remark'/></th>
	                     <td colspan="5"><input type="text" name="rem" id="rem" class="w100p"/></td>
	                 </tr>
	                 <tr>
	                     <th scope="row"><spring:message code='log.head.createUserDate'/></th>
	                     <td><input type="text" name="createInfo" id="createInfo" placeholder="Automatic" class="readonly w100p" readonly="readonly"/></td>
	                     <th scope="row"><spring:message code='log.head.modifyUserDate'/></th>
	                     <td colspan="3"><input type="text" name="modifyInfo" id="updateInfo" placeholder="Automatic" class="readonly w100p" readonly="readonly"/></td>
	                 </tr>
				</tbody>
			</table>
		</form>

		<section class="search_result"><!-- search_result start -->

			<div class="divine_auto type2"><!-- divine_auto start -->
				<div style="width:50%"><!-- 50% start -->
					<aside class="title_line"><!-- title_line start -->
					<h3>Location</h3>
					</aside><!-- title_line end -->
					<div class="border_box" style="height:240px;"><!-- border_box start -->
						<article class="grid_wrap"><!-- grid_wrap start -->
						    <div id="res_grid_wrap" style="height:240px;"></div>
						</article><!-- grid_wrap end -->
					</div><!-- border_box end -->
			    </div><!-- 50% end -->
				<div style="width:50%"><!-- 50% start -->
					<aside class="title_line"><!-- title_line start -->
					<h3>Selected Location</h3>
					</aside><!-- title_line end -->
					<div class="border_box" style="height:240px;"><!-- border_box start -->
						<article class="grid_wrap"><!-- grid_wrap start -->
						    <div id="req_grid_wrap" style="height:240px;"></div>
						</article><!-- grid_wrap end -->
						<ul class="btns">
						    <li>
						         <a id="rightbtn"><img src="${pageContext.request.contextPath}/resources/images/common/btn_right2.gif" alt="right" /></a>
						         <br><br>
						         <a id="leftbtn"><img src="${pageContext.request.contextPath}/resources/images/common/btn_left2.gif" alt="left" /></a>
						    </li>
						</ul>
					</div><!-- border_box end -->
				</div><!-- 50% end -->
			</div><!-- divine_auto end -->

			<div class="divine_auto type2"><!-- divine_auto start -->
                <div style="width:50%"><!-- 50% start -->
                    <aside class="title_line"><!-- title_line start -->
                    <h3>Item</h3>
                    </aside><!-- title_line end -->

                    <div class="border_box" style="height:240px;"><!-- border_box start -->
                        <article class="grid_wrap"><!-- grid_wrap start -->
                            <div id="item_res_grid_wrap" style="height:240px;"></div>
                        </article><!-- grid_wrap end -->
                    </div><!-- border_box end -->
                </div><!-- 50% end -->
                <div style="width:50%"><!-- 50% start -->
                    <aside class="title_line"><!-- title_line start -->
                    <h3>Selected Item</h3>
                    </aside><!-- title_line end -->
                    <div class="border_box" style="height:240px;"><!-- border_box start -->
                        <article class="grid_wrap"><!-- grid_wrap start -->
                            <div id="item_req_grid_wrap" style="height:240px;"></div>
                        </article><!-- grid_wrap end -->
                        <ul class="btns">
                            <li>
                                 <a id="itemrightbtn"><img src="${pageContext.request.contextPath}/resources/images/common/btn_right2.gif" alt="right" /></a>
                                 <br><br>
                                 <a id="itemleftbtn"><img src="${pageContext.request.contextPath}/resources/images/common/btn_left2.gif" alt="left" /></a>
                            </li>
                        </ul>
                    </div><!-- border_box end -->
                </div><!-- 50% end -->
            </div><!-- divine_auto end -->

		</section><!-- search_result end -->

    </section><!-- pop_body end -->
</div>
<!-- popup_wrap end -->
