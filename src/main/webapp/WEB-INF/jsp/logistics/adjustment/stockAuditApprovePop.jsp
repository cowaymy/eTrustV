<!--=================================================================================================
* Task  : Logistics
* File Name : countStockAuditRegisterPop.jsp
* Description : Count-Stock Audit Create
* Author : KR-OHK
* Date : 2019-10-14
* Change History :
* ------------------------------------------------------------------------------------------------
* [No]  [Date]        [Modifier]     [Contents]
* ------------------------------------------------------------------------------------------------
*  1     2019-10-14  KR-OHK        Init
*=================================================================================================-->
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>

<script type="text/javascript">
    var dedRsnList = [];
    var otherGiRsnList = [];
    var otherGrRsnList = [];
    var comDedRsnList = [];
    var comOtherRsnList = [];

	var locGrid, itemGrid, appr3LocGrid, appr3ItemGrid;

    var appr2LocColumnLayout=[
                         {dataField: "adjrnum",headerText :"<spring:message code='log.head.rnum'/>",width:1, visible:false },
                         {dataField: "adjwhLocId",headerText :"<spring:message code='log.head.locationid'/>", width: 100, editable : false },
                         {dataField: "adjcodeName",headerText :"<spring:message code='log.head.locationtype'/>", width: 120, editable : false},
                         {dataField: "adjwhLocCode",headerText :"<spring:message code='log.head.locationcode'/>", width: 120, editable : false},
                         {dataField: "adjwhLocDesc",headerText :"<spring:message code='log.head.locationdesc'/>" ,width: 150, editable : false, style: "aui-grid-user-custom-left aui-grid-link-renderer",
                        	 renderer :
                             {
                                type : "LinkRenderer",
                                baseUrl : "javascript", // 자바스크립 함수 호출로 사용하고자 하는 경우에 baseUrl 에 "javascript" 로 설정
                                // baseUrl 에 javascript 로 설정한 경우, 링크 클릭 시 callback 호출됨.
                                jsCallback : function(rowIndex, columnIndex, value, item)
                                {
                                    fn_locDetailPop(item.stockAuditNo, item.adjwhLocId, 'DET');
                                }
                             }
                         },
                         {dataField: "locStusCodeNm",headerText :"<spring:message code='log.head.locationStatus'/>", width: 120, editable : false},
                         {dataField: "appv2Opinion",headerText :"<spring:message code='log.head.2ndOpinion'/>", width: 220, editable : true, headerStyle : "aui-grid-header-input-icon", style: "aui-grid-user-custom-left"},
                         {dataField: "locStusCodeId",headerText :"<spring:message code='log.head.locationStatus'/>", width: 1, editable : false, visible:false},
                 ];

    var appr3LocColumnLayout=[
                         {dataField: "adjrnum",headerText :"<spring:message code='log.head.rnum'/>",width:1, visible:false },
                         {dataField: "adjwhLocId",headerText :"<spring:message code='log.head.locationid'/>", width: 100, editable : false },
                         {dataField: "adjcodeName",headerText :"<spring:message code='log.head.locationtype'/>", width: 120, editable : false},
                         {dataField: "adjwhLocCode",headerText :"<spring:message code='log.head.locationcode'/>", width: 120, editable : false},
                         {dataField: "adjwhLocDesc",headerText :"<spring:message code='log.head.locationdesc'/>" ,width: 150, editable : false, style: "aui-grid-user-custom-left aui-grid-link-renderer",
                        	 renderer :
                             {
                                type : "LinkRenderer",
                                baseUrl : "javascript", // 자바스크립 함수 호출로 사용하고자 하는 경우에 baseUrl 에 "javascript" 로 설정
                                // baseUrl 에 javascript 로 설정한 경우, 링크 클릭 시 callback 호출됨.
                                jsCallback : function(rowIndex, columnIndex, value, item)
                                {
                                	fn_locDetailPop(item.stockAuditNo, item.adjwhLocId, 'DET');
                                }
                             }
                         },
                         {dataField: "locStusCodeNm",headerText :"<spring:message code='log.head.locationStatus'/>", width: 120, editable : false},
                         {dataField: "appv2Opinion",headerText :"<spring:message code='log.head.2ndOpinion'/>", width: 220, editable : false, style: "aui-grid-user-custom-left"},
                         {dataField: "locStusCodeId",headerText :"<spring:message code='log.head.locationStatus'/>", width: 1, editable : false, visible:false},
                 ];

    var itemColumnLayout=[
                          {dataField: "rnum",headerText :"<spring:message code='log.head.rnum'/>" ,width:1, visible:false },
                          {dataField: "itmId",headerText :"<spring:message code='log.head.rnum'/>" ,width:1, visible:false},
                          {dataField: "whLocId",headerText :"<spring:message code='log.head.locationid'/>", width: 100 },
                          {dataField: "locType",headerText :"<spring:message code='log.head.locationtype'/>", width: 120},
                          {dataField: "whLocCode",headerText :"<spring:message code='log.head.locationcode'/>", width: 120},
                          {dataField: "whLocDesc",headerText :"<spring:message code='log.head.locationdesc'/>" ,width: 150, style: "aui-grid-user-custom-left"},
                          {dataField: "stkCode",headerText :"<spring:message code='log.head.itemcode'/>",width: 100, editable : false},
                          {dataField: "stkDesc",headerText :"<spring:message code='log.head.itemname'/>",width: 150, editable : false, style: "aui-grid-user-custom-left"},
                          {dataField: "stkGrad",headerText :"<spring:message code='log.head.locationgrade'/>" ,width:120, editable : false},
                          {dataField: "stkType",headerText :"<spring:message code='log.head.itemtype'/>" ,width: 100, editable : false },
                          {dataField: "stkCtgryType",headerText :"<spring:message code='log.head.categoryType'/>", width: 120, editable : false },
                          {dataField: "sysQty",headerText :"<spring:message code='log.head.systemqty'/>",width:100, editable : false, style: "aui-grid-user-custom-right"},
                          {dataField: "cntQty",headerText :"<spring:message code='log.head.countqty'/>", width:100, editable : false, style: "aui-grid-user-custom-right"},
                          {dataField: "diffQty",headerText :"<spring:message code='log.head.variance'/>", width:200, editable : false, style: "aui-grid-user-custom-right"},
                          {dataField: "dedQty",headerText :"Deduction Qty", width:130, editable : false, style: "aui-grid-user-custom-right"},
                          {dataField: "dedReason",headerText :"Deduction Reason", width:250, editable : false,
                              labelFunction : function(  rowIndex, columnIndex, value, headerText, item ) {
                                  var retStr = value;
                                  comDedRsnList.length = 0;

                                  if(item.dedQty == 0) {
                                       comDedRsnList.push(dedRsnList[0]);
                                  } else {
                                      for(var i=0,len=dedRsnList.length; i<len; i++) {
                                           comDedRsnList.push(dedRsnList[i]);
                                      }
                                  }

                                  for(var i=0,len=comDedRsnList.length; i<len; i++) {
                                      if(comDedRsnList[i]["code"] == value) {
                                          retStr = comDedRsnList[i]["codeName"];
                                          break;
                                      }
                                  }
                                  return retStr;
                              },
                              editRenderer : {
                                  type : "DropDownListRenderer",
                                  showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
                                  list : comDedRsnList, //key-value Object 로 구성된 리스트
                                  keyField : "code", // key 에 해당되는 필드명
                                  valueField : "codeName", // value 에 해당되는 필드명
                                  listAlign : "left"
                              },
                          },
                          {dataField: "otherQty",headerText :"OtherGI/GR QTY", width:130, editable : false, style: "aui-grid-user-custom-right"},
                          {dataField: "otherReason",headerText :"OtherGI/GR Reason", width:250, editable : false,
                              labelFunction : function(  rowIndex, columnIndex, value, headerText, item ) {
                                  var retStr = value;
                                  comOtherRsnList.length = 0;

                                  if(item.otherQty > 0) {               // Other GR
                                      for(var i=0,len=otherGrRsnList.length; i<len; i++) {
                                          comOtherRsnList.push(otherGrRsnList[i]);
                                      }
                                  } else if(item.otherQty < 0 ) {   // Other GI
                                       for(var i=0,len=otherGiRsnList.length; i<len; i++) {
                                           comOtherRsnList.push(otherGiRsnList[i]);
                                      }
                                  } else {
                                     comOtherRsnList.push(otherGiRsnList[0]);
                                  }

                                  for(var i=0,len=comOtherRsnList.length; i<len; i++) {
                                      if(comOtherRsnList[i]["code"] == value) {
                                          retStr = comOtherRsnList[i]["codeName"];
                                          break;
                                      }
                                  }
                                  return retStr;
                              },
                              editRenderer : {
                                  type : "DropDownListRenderer",
                                  showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
                                  list : comOtherRsnList, //key-value Object 로 구성된 리스트
                                  keyField : "code", // key 에 해당되는 필드명
                                  valueField : "codeName", // value 에 해당되는 필드명
                                  listAlign : "left"
                              },
                          },
                          {dataField: "rem",headerText :"<spring:message code='log.head.remark'/>", width:500, editable : false, style: "aui-grid-user-custom-left"}
                  ];

    var appr2locop = {
            rowIdField : "adjrnum",
            showRowCheckColumn : true,
            showStateColumn : false,
            usePaging : false,
            enableFilter : true,
            editable : true};

    var appr3locop = {
            rowIdField : "adjrnum",
            showRowCheckColumn : false,
            showStateColumn : false,
            usePaging : false,
            enableFilter : true,
            editable : false};

    var itemop = {
            rowIdField : "rnum",
            showRowCheckColumn : false,
            editable : false,
            usePaging : false,
            showStateColumn : false,
            enableFilter : true,
            headerHeight: 35
            };

    $(document).ready(function () {

    	var isAppr2All = '' ;
    	fn_reasonCodeSearch();

    	if('${action}' == 'APPR2') {
            $("#T_APPR2").show();
            $("#T_APPR3").hide();

            $("#APPR2").show();
            $("#APPR3").hide();

            locGrid = GridCommon.createAUIGrid("appr2_loc_grid_wrap_pop", appr2LocColumnLayout,"", appr2locop);
            AUIGrid.setGridData(locGrid, $.parseJSON('${locList}'));

            itemGrid = GridCommon.createAUIGrid("appr2_item_grid_wrap_pop", itemColumnLayout,"", itemop);
            AUIGrid.setGridData(itemGrid, $.parseJSON('${itemList}'));

            var length = AUIGrid.getGridData(locGrid).length;
            var appr1Cnt = 0;
            var appr2Cnt = 0;

            if(length > 0) {
                for(var i = 0; i < length; i++) {
                    if(AUIGrid.getCellValue(locGrid, i, "locStusCodeId") == '5688') { // 1st Approve
                        appr1Cnt ++;
                    }
                    if(AUIGrid.getCellValue(locGrid, i, "locStusCodeId") == '5690') {// 2nd Approve
                        appr2Cnt ++;
                    }
                }
            }

            if(appr1Cnt == 0) {
            	$("#btnAppr2Approve").addClass("btn_disabled");
            	$("#btnAppr2Reject").addClass("btn_disabled");
            }
            if(appr2Cnt < length) {
                $("#btn3requestApproval").addClass("btn_disabled");
            } else {
            	isAppr2All = 'Y';
            }
        }

        if('${action}' == 'APPR3') {
       	    $("#T_APPR2").hide();
            $("#T_APPR3").show();

            $("#APPR2").hide();
            $("#APPR3").show();

            $("#pop_header_title").text("3rd Approval / Reject");

            appr3LocGrid = GridCommon.createAUIGrid("appr3_loc_grid_wrap_pop", appr3LocColumnLayout,"", appr3locop);
            AUIGrid.setGridData(appr3LocGrid, $.parseJSON('${locList}'));

            appr3ItemGrid = GridCommon.createAUIGrid("appr3_item_grid_wrap_pop", itemColumnLayout,"", itemop);
            AUIGrid.setGridData(appr3ItemGrid, $.parseJSON('${itemList}'));
        }

        var selectedVal = '';
        if(isAppr2All == 'Y') { // 2nd Approval All End
        	selectedVal = '';
        } else {
        	selectedVal = '5688' // 1st Approval
        }

        doGetComboCodeId('/common/selectCodeList.do', {groupCode : 437 , orderValue : 'CODE'}, selectedVal, 'appr2LocStusCodeId', 'A', 'fn_setFilterAppr2');
        doGetComboCodeId('/common/selectCodeList.do', {groupCode : 437 , orderValue : 'CODE'}, '', 'appr3LocStusCodeId', 'A', 'fn_setFilterAppr3');
        //CommonCombo.make('appr3LocStusCodeId', '/common/selectCodeList.do', {groupCode : 437, orderValue: "CODE"} , '', {type: 'A'});
        CommonCombo.make('appr2WhLocId', '/logistics/adjustment/selectLocCodeList.do', {stockAuditNo : '${docInfo.stockAuditNo}'} , '', {type: 'A'});
        CommonCombo.make('appr3WhLocId', '/logistics/adjustment/selectLocCodeList.do', {stockAuditNo : '${docInfo.stockAuditNo}'} , '', {type: 'A'});

        fn_setVal();

   	    $("input[name=attachFile]").on("dblclick", function () {

            Common.showLoader();

            var $this = $(this);
            var fileId = $this.attr("data-id");

            $.fileDownload("${pageContext.request.contextPath}/file/fileDown.do", {
                 httpMethod: "POST",
                 contentType: "application/json;charset=UTF-8",
                 data: {
                     fileId: fileId
                 },
                 failCallback: function (responseHtml, url, error) {
                     Common.alert($(responseHtml).find("#errorMessage").text());
                 }
            })
              .done(function () {
                  Common.removeLoader();
                  console.log('File download a success!');
              })
              .fail(function () {
                  Common.removeLoader();
              });
          return false; //this is critical to stop the click event which will trigger a normal file download
          });

           // cellClick event.
           AUIGrid.bind(locGrid, "cellClick", function( event )
           {
               var whLocId = AUIGrid.getCellValue(locGrid, event.rowIndex, "adjwhLocId");
               AUIGrid.setFilterByValues(itemGrid, "whLocId", [whLocId]);
           });

            // cellClick event.
           AUIGrid.bind(appr3LocGrid, "cellClick", function( event )
           {
               var whLocId = AUIGrid.getCellValue(appr3LocGrid, event.rowIndex, "adjwhLocId");
               AUIGrid.setFilterByValues(appr3ItemGrid, "whLocId", [whLocId]);
           });
    });

    function fn_locDetailPop(stockAuditNo, whLocId, action) {
    	var data = {
                stockAuditNo: stockAuditNo,
                whLocId: whLocId,
                action: action,
        };

        Common.popupDiv("/logistics/adjustment/countStockAuditRegisterPop.do", data, null, true, "locDetailPop");
    }

    //common_pub.js 에서 파일 change 이벤트 발생시 호출됨...
    function fn_abstractChangeFile(thisfakeInput) {
        // modyfy file case
        if (FormUtil.isNotEmpty(thisfakeInput.attr("data-id"))) {
            var updateFileIds = $("#updateFileIds").val();
            $("#updateFileIds").val(thisfakeInput.attr("data-id") + DEFAULT_DELIMITER + updateFileIds);
        }
    }

    //common_pub.js 에서 파일 delete 이벤트 발생시 호출됨...
    function fn_abstractDeleteFile(thisfakeInput) {
        // modyfy file case
        if (FormUtil.isNotEmpty(thisfakeInput.attr("data-id"))) {
            var deleteFileIds = $("#deleteFileIds").val();
            $("#deleteFileIds").val(thisfakeInput.attr("data-id") + DEFAULT_DELIMITER + deleteFileIds);
        }
    }

    function fn_close() {
        $("#popClose").click();
    }

    //excel Download
    $('#excelDownAppr2').click(function() {
       GridCommon.exportTo("appr2_item_grid_wrap_pop", 'xlsx', "Count Stock Audit Item List");
    });

    $('#excelDownAppr3').click(function() {
        GridCommon.exportTo("appr3_item_grid_wrap_pop", 'xlsx', "Count Stock Audit Item List");
     });

    $('#appr2Approve').click(function() {

        if ( true == $(this).parents().hasClass("btn_disabled") ) {
            return  false;
        }

        var locGridList = AUIGrid.getCheckedRowItemsAll(locGrid);

        if(locGridList.length < 1)
        {
            Common.alert("<spring:message code='expense.msg.NoData' htmlEscape='false'/>");
            return false;
        }

        var appr1Cnt = 0;
        if(locGridList.length > 0) {
            for(var i = 0; i < locGridList.length; i++) {
                if(AUIGrid.getCellValue(locGrid, i, "locStusCodeId") != '5688') { // 1st Approve
                    appr1Cnt ++;
                }
            }
        }

        if(appr1Cnt > 0) {
        	Common.alert("2nd Approval is only possible after the 1st Approval.");
            return false;
        }

        var appvType = "aprv2";

        var obj = $("#insertForm").serializeJSON();
        obj.stockAuditNo = $("#hidStockAuditNo").val();

        Common.ajaxSync("GET", "/logistics/adjustment/selectStockAuditDocDtTime.do", obj, function(result){
            if(result != null) {
                if(result.updDtTime != $("#hidUpdDtTime").val()) {
                    Common.alert("The data you have selected is already updated.");
                    return false;
                } else {
			        if(Common.confirm("Do you want to approve?", function(){
			        	var formData = Common.getFormData("appvForm");

			        	formData.append("atchFileGrpId", $("#atchFileGrpId").val());
			            formData.append("updateFileIds", $("#updateFileIds").val());
			            formData.append("deleteFileIds", $("#deleteFileIds").val());

			            Common.ajaxFile("/logistics/adjustment/uploadGroupwareFile.do", formData, function(result) {
			                console.log(result);
			                $("#atchFileGrpId").val(result.data);
			                fn_2ndApproval(appvType);
			            });
                    }));
                }
            }
       });
    });

    $('#appr2Reject').click(function() {

        if ( true == $(this).parents().hasClass("btn_disabled") ) {
            return  false;
        }

        var locGridList = AUIGrid.getCheckedRowItemsAll(locGrid);

        if(locGridList.length < 1)
        {
            Common.alert("<spring:message code='expense.msg.NoData' htmlEscape='false'/>");
            return false;
        }

        var opCnt = 0;
        var appr1Cnt = 0;
        if (locGridList.length > 0)
        {
            for(var i = 0; i < locGridList.length; i++) {
                if(AUIGrid.getCellValue(locGrid, i, "locStusCodeId") != '5688') { // 1st Approve
                    appr1Cnt ++;
                }
                if(FormUtil.isEmpty(locGridList[i].appv2Opinion)) {
                    opCnt++;
                }
            }

            if(appr1Cnt > 0) {
                Common.alert("2nd Reject is only possible after the 1st Approval.");
                return false;
            }

            if(opCnt > 0 ) {
                var arg = "<spring:message code='log.head.2ndOpinion' />";
                Common.alert("<spring:message code='sys.msg.necessary' arguments='"+ arg +"'/>");
                return false;
            }
        }

        var appvType = "rejt2";

        var obj = $("#insertForm").serializeJSON();
        obj.stockAuditNo = $("#hidStockAuditNo").val();

        Common.ajaxSync("GET", "/logistics/adjustment/selectStockAuditDocDtTime.do", obj, function(result){
            if(result != null) {
                if(result.updDtTime != $("#hidUpdDtTime").val()) {
                    Common.alert("The data you have selected is already updated.");
                    return false;
                } else {
			        if(Common.confirm("Do you want to reject?", function(){
			        	var formData = Common.getFormData("appvForm");

			        	formData.append("atchFileGrpId", $("#atchFileGrpId").val());
			            formData.append("updateFileIds", $("#updateFileIds").val());
			            formData.append("deleteFileIds", $("#deleteFileIds").val());

			            Common.ajaxFile("/logistics/adjustment/uploadGroupwareFile.do", formData, function(result) {
			                console.log(result);
			                $("#atchFileGrpId").val(result.data);
			                fn_2ndApproval(appvType);
			            });
                    }));
                }
            }
       });
    });

    function fn_2ndApproval(appvType) {
        var locGridList = AUIGrid.getCheckedRowItemsAll(locGrid);

        if (locGridList.length > 0)
        {
            var obj = {};

            obj.checked = locGridList;
            obj.form    = $("#appvForm").serializeJSON();
            obj.appvType = appvType;
            obj.stockAuditNo = $("#hidStockAuditNo").val();

            Common.ajax("POST", "/logistics/adjustment/saveAppv2Info.do", obj, function(result) {//  첨부파일 정보를 공통 첨부파일 테이블 이용 : 웹 호출 테스트
                 Common.alert(result.message);
                 $("#popClose").click();

                 getListAjax(1);
            });
        }
    }

    $('#3requestApproval').click(function() {

        if ( true == $(this).parents().hasClass("btn_disabled") ) {
            return  false;
        }

        if(FormUtil.checkReqValue($("#reuploadYn"))){
            var arg = "<spring:message code='log.head.groupwareAppAttFileReUpload' />";
            Common.alert("<spring:message code='sys.msg.necessary' arguments='"+ arg +"'/>");
            return false;
        }

        var flleName = "";
        var arrFileName = new Array();

        $.each($(".auto_file2"), function(){
       		fileName = $(this).find(":text").val();
       		if(FormUtil.isNotEmpty(fileName)) {
       			arrFileName.push(fileName);
       		}
       	});

       	if(arrFileName.length == 0) {
       		var arg = "<spring:message code='log.head.groupwareAppAttFile' />";
            Common.alert("<spring:message code='sys.msg.necessary' arguments='"+ arg +"'/>");
            return false;
       	}

        if(FormUtil.checkReqValue($("#appv3ReqstOpinion"))){
            var arg = "<spring:message code='log.head.3rdRequestapprovalOpinion' />";
            Common.alert("<spring:message code='sys.msg.necessary' arguments='"+ arg +"'/>");
            return false;
        }

        var obj = $("#insertForm").serializeJSON();
        obj.stockAuditNo = $("#hidStockAuditNo").val();

        Common.ajaxSync("GET", "/logistics/adjustment/selectStockAuditDocDtTime.do", obj, function(result){
            if(result != null) {
                if(result.updDtTime != $("#hidUpdDtTime").val()) {
                    Common.alert("The data you have selected is already updated.");
                    return false;
                } else {
			        if(Common.confirm("3rd Request Approva?", function(){
			        	var formData = Common.getFormData("appvForm");

			        	formData.append("atchFileGrpId", $("#atchFileGrpId").val());
			            formData.append("updateFileIds", $("#updateFileIds").val());
			            formData.append("deleteFileIds", $("#deleteFileIds").val());

			            Common.ajaxFile("/logistics/adjustment/uploadGroupwareFile.do", formData, function(result) {
			                console.log(result);
			                $("#atchFileGrpId").val(result.data);
			                fn_3rdRequestApproval();
			            });
                    }));
                }
            }
       });
    });

    function fn_3rdRequestApproval() {
    	var obj = $("#appvForm").serializeJSON();
        obj.stockAuditNo = $("#hidStockAuditNo").val();
        obj.appvType = "3ReqAprv";

        Common.ajax("POST", "/logistics/adjustment/saveDocAppvInfo.do", obj, function(result) {//  첨부파일 정보를 공통 첨부파일 테이블 이용 : 웹 호출 테스트
             Common.alert(result.message);
             $("#popClose").click();

             getListAjax(1);
        });
    }

    $('#appr3Approve').click(function() {

        if ( true == $(this).parents().hasClass("btn_disabled") ) {
            return  false;
        }

        if(FormUtil.checkReqValue($("#appv3Opinion"))){
            var arg = "<spring:message code='log.head.3rdOpinion' />";
            Common.alert("<spring:message code='sys.msg.necessary' arguments='"+ arg +"'/>");
            return false;
        }

        var obj = $("#appvForm").serializeJSON();
        obj.stockAuditNo = $("#hidStockAuditNo").val();
        obj.appvType = "aprv3";

        Common.ajaxSync("GET", "/logistics/adjustment/selectStockAuditDocDtTime.do", obj, function(result){
            if(result != null) {
                if(result.updDtTime != $("#hidUpdDtTime").val()) {
                    Common.alert("The data you have selected is already updated.");
                    return false;
                } else {
			        if(Common.confirm("Do you want to approve?", function(){
			                Common.ajax("POST", "/logistics/adjustment/saveDocAppvInfo.do", obj, function(result) {//  첨부파일 정보를 공통 첨부파일 테이블 이용 : 웹 호출 테스트
			                     Common.alert(result.message);
			                     $("#popClose").click();
			                     getListAjax(1);
			                });
                    }));
                }
            }
	    });
    });

    $('#appr3Reject').click(function() {

        if ( true == $(this).parents().hasClass("btn_disabled") ) {
            return  false;
        }

        if(FormUtil.checkReqValue($("#appv3Opinion"))){
            var arg = "<spring:message code='log.head.3rdOpinion' />";
            Common.alert("<spring:message code='sys.msg.necessary' arguments='"+ arg +"'/>");
            return false;
        }

        var obj = $("#appvForm").serializeJSON();
        obj.stockAuditNo = $("#hidStockAuditNo").val();
        obj.appvType = "rejt3";

        Common.ajaxSync("GET", "/logistics/adjustment/selectStockAuditDocDtTime.do", obj, function(result){
            if(result != null) {
                if(result.updDtTime != $("#hidUpdDtTime").val()) {
                    Common.alert("The data you have selected is already updated.");
                    return false;
                } else {
			        if(Common.confirm("Do you want to reject?", function(){
			                Common.ajax("POST", "/logistics/adjustment/saveDocAppvInfo.do", obj, function(result) {//  첨부파일 정보를 공통 첨부파일 테이블 이용 : 웹 호출 테스트
			                     Common.alert(result.message);
			                     $("#popClose").click();
			                     getListAjax(1);
			                });
                    }));
                }
            }
        });
    });

    //excel Download
    $('#excelDown').click(function() {
       GridCommon.exportTo("item_grid_wrap", 'xlsx', "New Count-Stock Audit Item List");
    });

    function fn_setVal(){

    	var locType =  $("#hidLocType").val();
    	var itmType =  $("#hidItmType").val();
    	var ctgryType =  $("#hidCtgryType").val();

    	var tmp1 = locType.split(',');
        var tmp2 = itmType.split(',');
        var tmp3 = ctgryType.split(',');

        fn_itemSet(tmp1,"event");
        fn_itemSet(tmp2,"item");
        fn_itemSet(tmp3,"catagory");

    }

    function fn_itemSet(tmp,str){
        var no;
        if(str=="event"){
            no=339;
        }else if(str=="item"){
            no=15;
        }else if(str=="catagory"){
            no=11;
        }
        var url = "/logistics/adjustment/selectCodeList.do";
        $.ajax({
            type : "GET",
            url : url,
            data : {
                groupCode : no
            },
            dataType : "json",
            contentType : "application/json;charset=UTF-8",
            success : function(data) {
                 fn_itemChck(data,tmp,str);
            },
            error : function(jqXHR, textStatus, errorThrown) {
            },
            complete : function() {
            }
        });
    }

    function  fn_itemChck(data,tmp2,str){
        var obj;
        if(str=="event" ){
            obj ="eventtypetd";
        }else if(str=="item"){
            obj ="itemtypetd";
        }else if(str=="catagory"){
            obj ="catagorytypetd";
        }
        obj= '#'+obj;

        $.each(data, function(index,value) {
                    $('<label />',{id:data[index].code}).appendTo(obj);
                    $('<input />',  {type : 'checkbox',value : data[index].codeId, id : data[index].codeId}).appendTo("#"+data[index].code).attr("disabled","disabled");
                    $('<span />',  {text:data[index].codeName}).appendTo("#"+data[index].code);
            });

            for(var i=0; i<tmp2.length;i++){
                $.each(data, function(index,value) {
                    if(tmp2[i]==data[index].codeId){
                        $("#"+data[index].codeId).attr("checked", "true");
                    }
                });
            }
    }

    $('#appr2LocStusCodeId').change(function() {
        var locStusCodeId = $("#appr2LocStusCodeId option:selected").val();
        if(locStusCodeId == '') {
        	AUIGrid.clearFilter(locGrid, "locStusCodeId");
        	AUIGrid.clearFilter(itemGrid, "whLocId");
        } else {
            AUIGrid.setFilterByValues(locGrid, "locStusCodeId", [locStusCodeId]);

            var length = AUIGrid.getGridData(locGrid).length;
            var arrWhLocId = new Array();

            if(length > 0) {
                for(var i = 0; i < length; i++) {
                    arrWhLocId.push(AUIGrid.getCellValue(locGrid, i, "whLocId"))
                }
            }
            AUIGrid.setFilterByValues(itemGrid, "whLocId", arrWhLocId);
        }
    });

    $('#appr3LocStusCodeId').change(function() {
        var locStusCodeId = $("#appr3LocStusCodeId option:selected").val();
        if(locStusCodeId == '') {
            AUIGrid.clearFilter(apprLocGrid, "locStusCodeId");
        } else {
            AUIGrid.setFilterByValues(apprLocGrid, "locStusCodeId", [locStusCodeId]);
        }
    });

    $('#appr2WhLocId').change(function() {
        var whLocId = $("#appr2WhLocId option:selected").val();

        if(whLocId == '') {
            AUIGrid.clearFilter(itemGrid, "whLocId");
        } else {
            AUIGrid.setFilterByValues(itemGrid, "whLocId", [whLocId]);
        }
    });

    $('#appr3WhLocId').change(function() {
        var whLocId = $("#appr3WhLocId option:selected").val();
        if(whLocId == '') {
            AUIGrid.clearFilter(appr3ItemGrid, "whLocId");
        } else {
            AUIGrid.setFilterByValues(appr3ItemGrid, "whLocId", [whLocId]);
        }
    });

    function fn_setFilterAppr2() {
        var locStusCodeId = $("#appr2LocStusCodeId option:selected").val();
        AUIGrid.setFilterByValues(locGrid, "locStusCodeId", [locStusCodeId]);
        if(locStusCodeId == '') {
        	AUIGrid.clearFilter(locGrid, "locStusCodeId");
        }
        var length = AUIGrid.getGridData(locGrid).length;
        var arrWhLocId = new Array();

        if(length > 0) {
            for(var i = 0; i < length; i++) {
            	arrWhLocId.push(AUIGrid.getCellValue(locGrid, i, "whLocId"))
            }
        }

        AUIGrid.setFilterByValues(itemGrid, "whLocId", arrWhLocId);
    }

    function fn_setFilterAppr3() {
        var locStusCodeId = $("#appr3LocStusCodeId option:selected").val();
        AUIGrid.setFilterByValues(appr3LocGrid, "locStusCodeId", [locStusCodeId]);
        AUIGrid.clearFilter(appr3LocGrid, "locStusCodeId");
    }

    function fn_reasonCodeSearch(){
        Common.ajax("GET", "/logistics/adjustment/selectOtherReasonCodeList.do",  {indVal : 'DED_RSN'}, function(result) {
            var temp    = { code : "", codeName : "" };
            dedRsnList.push(temp);
            otherGiRsnList.push(temp);
            otherGrRsnList.push(temp);
            for ( var i = 0 ; i < result.length ; i++ ) {
                if(result[i].ind == 'DED_RSN') {
                    dedRsnList.push(result[i]);
                } else if(result[i].ind == 'O_GI_RSN') {
                    otherGiRsnList.push(result[i]);
                }  else if(result[i].ind ==  'O_GR_RSN') {
                    otherGrRsnList.push(result[i]);
                }
            }
        }, null, {async : false});
    }
</script>


<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

    <header class="pop_header"><!-- pop_header start -->
        <h1 id="pop_header_title">2nd Approval / Reject</h1>
        <ul class="right_opt">
            <!-- APPR2 -->
            <c:if test="${action == 'APPR2'}">
                <li><p id="btnAppr2Approve" class="btn_blue2"><a href="#" id="appr2Approve">Approve</a></p></li>
                <li><p id="btnAppr2Reject" class="btn_blue2"><a href="#" id="appr2Reject">Reject</a></p></li>
                <li><p id="btn3requestApproval" class="btn_blue2"><a id="3requestApproval" >3rd Request approval</a></p></li>
            </c:if>
            <!-- APPR3 -->
            <c:if test="${action == 'APPR3'}">
                <li><p class="btn_blue2"><a id="appr3Approve">Approve</a></p></li>
	            <li><p class="btn_blue2"><a id="appr3Reject">Reject</a></p></li>
	        </c:if>
            <li><p class="btn_blue2"><a href="#" id="popClose"><spring:message code='sys.btn.close'/></a></p></li>
        </ul>
    </header><!-- pop_header end -->

    <section class="pop_body"><!-- pop_body start -->

        <form id="insForm" name="insForm" >
            <input type="hidden" id="hidStockAuditNo" name="hidStockAuditNo" value="${docInfo.stockAuditNo}">
            <input type="hidden" id="hidWhLocId" name="hidWhLocId" value="${docInfo.whLocId}">
            <input type="hidden" id="pAtchFileGrpId" name="pAtchFileGrpId" />
             <input type="hidden" id="hidLocType" name="hidLocType" value="${docInfo.locType}">
            <input type="hidden" id="hidItmType" name="hidItmType" value="${docInfo.itmType}">
            <input type="hidden" id="hidCtgryType" name="hidCtgryType" value="${docInfo.ctgryType}">
            <input type="hidden" id="hidUpdDtTime" name="hidUpdDtTime" value="${docInfo.updDtTime}">

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
					    <td>${docInfo.stockAuditNo}</td>
					     <th scope="row"><spring:message code='log.head.docStatus'/></th>
					     <td colspan="3">${docInfo.docStusNm}</td>
					</tr>
					<tr>
                        <th scope="row"><spring:message code='log.head.stockAuditDate'/></th>
                        <td>${docInfo.docStartDt} ~ ${docInfo.docEndDt}</td>
					    <th scope="row"><spring:message code='log.head.locationgrade'/></th>
					    <td>${docInfo.locStkGrad}</td>
					    <th scope="row"><spring:message code='log.head.serialcheck'/></th>
                        <td>${docInfo.serialChkYn}</td>
				    </tr>
                    <tr>
                        <th scope="row"><spring:message code='log.head.locationtype'/></th>
                        <td id="eventtypetd"></td>
                        <th scope="row"><spring:message code='log.head.itemtype'/></th>
                        <td colspan="3" id="itemtypetd"></td>
                    </tr>
				    <tr>
			            <th scope="row"><spring:message code='log.head.categoryType'/></th>
                        <td colspan="5" id="catagorytypetd"></td>
			        </tr>
			        <tr>
	                     <th scope="row"><spring:message code='log.head.stockAuditReason'/></th>
	                     <td colspan="5">${docInfo.stockAuditReason}</td>
	                 </tr>
	                 <tr>
	                     <th scope="row"><spring:message code='log.head.remark'/></th>
	                     <td colspan='3'>${docInfo.rem}</td>
	                 </tr>
	                 <tr>
	                     <th scope="row"><spring:message code='log.head.createUserDate'/></th>
	                     <td>${docInfo.crtUserNm} / ${docInfo.crtDt}</td>
	                     <th scope="row"><spring:message code='log.head.modifyUserDate'/></th>
	                     <td colspan="3">${docInfo.updUserNm} / ${docInfo.updDt}</td>
	                 </tr>
				</tbody>
			</table>

        </form>

		<form id="appvForm" name="appvForm"  enctype="multipart/form-data" >
            <input type="hidden" id="atchFileGrpId" name="atchFileGrpId" value="${docInfo.atchFileGrpId}">
            <input type="hidden" id="updateFileIds" name="updateFileIds" value="">
            <input type="hidden" id="deleteFileIds" name="deleteFileIds" value="">
		    <table class="type1" id="T_APPR2" style="display:none"><!-- table start -->
                <caption>table</caption>
                <colgroup>
                    <col style="width:150px" />
                    <col style="width:*" />
                    <col style="width:180px" />
                    <col style="width:*" />
                </colgroup>
                <tbody>
                     <tr>
                        <th scope="row"><spring:message code='log.head.groupwareAppAttFileReUpload'/><span class="must">*</span></th>
                        <td colspan='3'>
                            <label><input type="radio" name="reuploadYn" id="reuploadYn" value="Y" <c:if test="${docInfo.reuploadYn == 'Y'}">checked</c:if> /><span>Y</span></label>
                            <label><input type="radio" name="reuploadYn" id="reuploadYn" value="N" <c:if test="${docInfo.reuploadYn == 'N'}">checked</c:if> /><span>N</span></label>
                        </td>
                    </tr>
                    <tr>
                    <th scope="row"><spring:message code='log.head.groupwareAppAttFile'/><span class="must">*</span></th>
                    <td colspan='3'>
                        <c:if test="${action == 'APPR2'}">
	                        <c:forEach var="fileInfo" items="${files}" varStatus="status">
	                        <div class="auto_file2"><!-- auto_file start -->
	                           <input title="file add" style="width: 300px;" type="file">
	                           <label>
	                               <input type='text' class='input_text' readonly='readonly' name="attachFile"
	                                      value="${fileInfo.atchFileName}" data-id="${fileInfo.atchFileId}"/>
	                               <span class='label_text'><a href='#'><spring:message code="viewEditWebInvoice.file" /></a></span>
	                           </label>
	                           <span class='label_text'><a href='#'><spring:message code='sys.btn.add'/></a></span>
	                           <span class='label_text'><a href='#'><spring:message code='sys.btn.delete'/></a></span>
	                        </div>
	                        </c:forEach>
	                        <c:if test="${files.size() == 0 || files == null}">
		                        <div class="auto_file2"><!-- auto_file start -->
		                            <input title="file add" style="width: 300px;" type="file">
		                            <label>
		                                <input type='text' class='input_text' readonly='readonly' value="" data-id=""/>
		                                <span class='label_text'><a href='#'><spring:message code="viewEditWebInvoice.file" /></a></span>
		                            </label>
		                            <span class='label_text'><a href='#'><spring:message code='sys.btn.add'/></a></span>
		                            <span class='label_text'><a href='#'><spring:message code='sys.btn.delete'/></a></span>
		                       </div><!-- auto_file end -->
	                        </c:if>
	                    </c:if>
                    </td>
                </tr>
                     <tr>
                         <th scope="row"><spring:message code='log.head.3rdRequestapprovalOpinion'/><span class="must">*</span></th>
                         <td colspan='3'><input type="text" name="appv3ReqstOpinion" id="appv3ReqstOpinion" value="${docInfo.appv3ReqstOpinion}" class="w100p"/></td>
                     </tr>
                </tbody>
            </table>

            <table class="type1" id="T_APPR3" style="display:none"><!-- table start -->
                <caption>table</caption>
                <colgroup>
                    <col style="width:150px" />
                    <col style="width:*" />
                    <col style="width:180px" />
                    <col style="width:*" />
                </colgroup>
                <tbody>
                     <tr>
                        <th scope="row"><spring:message code='log.head.groupwareAppAttFileReUpload'/></th>
                        <td colspan='3'>${docInfo.reuploadYn}</td>
                    </tr>
                    <tr>
	                    <th scope="row"><spring:message code='log.head.groupwareAppAttFile'/></th>
	                    <td colspan='3'>
	                        <c:if test="${action == 'APPR3'}">
		                        <c:forEach var="fileInfo" items="${files}" varStatus="status">
		                        <div class="auto_file2"><!-- auto_file start -->
		                           <label>
		                               <input type='text' class='input_text' readonly='readonly' name="attachFile"
		                                      value="${fileInfo.atchFileName}" data-id="${fileInfo.atchFileId}"/>
		                               <span class='label_text'><a href='#'><spring:message code="viewEditWebInvoice.file" /></a></span>
		                           </label>
		                        </div>
		                        </c:forEach>
		                    </c:if>
	                    </td>
                     </tr>
                      <tr>
                         <th scope="row"><spring:message code='log.head.3rdRequester'/></th>
                         <td>${docInfo.appv3ReqstUserNm}</td>
                         <th scope="row"><spring:message code='log.head.3rdRequestdate'/></th>
                         <td>${docInfo.appv3ReqstDt}</td>
                     </tr>
                     <tr>
                         <th scope="row"><spring:message code='log.head.3rdRequestapprovalOpinion'/></th>
                         <td colspan='3'>${docInfo.appv3ReqstOpinion}</td>
                     </tr>
                     <tr>
                         <th scope="row"><spring:message code='log.head.3rdOpinion'/><span class="must">*</span></th>
                         <td colspan='3'><input type="text" name="appv3Opinion" id="appv3Opinion" value="${docInfo.appv3Opinion}" class="w100p"/></td>
                     </tr>
                </tbody>
            </table>

        </form>

		<section class="search_result" id="APPR2" style="display:none"><!-- search_result start -->

            <ul class="right_btns">
                <li><select class="w50p" id="appr2LocStusCodeId" name="appr2LocStusCodeId"></select></li>
                <!--
                <li><p id="btnAppr2Approve" class="btn_grid"><a href="#" id="appr2Approve">Approve</a></p></li>
                <li><p id="btnAppr2Reject" class="btn_grid"><a href="#" id="appr2Reject">Reject</a></p></li>-->
            </ul>
            <article class="grid_wrap"><!-- grid_wrap start -->
               <div id="appr2_loc_grid_wrap_pop" style="width:100%; height:300px; margin:0 auto;"></div>
            </article><!-- grid_wrap end -->

            <ul class="right_btns">
                <li><select class="w50p" id="appr2WhLocId" name="appr2WhLocId"></select></li>
                <li><p class="btn_grid"><a href="#" id="excelDownAppr2"><spring:message code='sys.btn.excel.dw'/></a></p></li>
            </ul>
            <article class="grid_wrap"><!-- grid_wrap start -->
               <div id="appr2_item_grid_wrap_pop" style="width:100%; height:300px; margin:0 auto;"></div>
            </article><!-- grid_wrap end -->

        </section><!-- search_result end -->

        <section class="search_result" id="APPR3" style="display:none"><!-- search_result start -->
            <ul class="right_btns">
                <li><select class="w50p" id="appr3LocStusCodeId" name="appr3LocStusCodeId"></select></li>
            </ul>
            <article class="grid_wrap"><!-- grid_wrap start -->
               <div id="appr3_loc_grid_wrap_pop" style="width:100%; height:300px; margin:0 auto;"></div>
            </article><!-- grid_wrap end -->

            <ul class="right_btns">
                <li><select class="w50p" id="appr3WhLocId" name="appr3WhLocId"></select></li>
                <li><p class="btn_grid"><a href="#" id="excelDownAppr3"><spring:message code='sys.btn.excel.dw'/></a></p></li>
            </ul>
            <article class="grid_wrap"><!-- grid_wrap start -->
               <div id="appr3_item_grid_wrap_pop" style="width:100%; height:300px; margin:0 auto;"></div>
            </article><!-- grid_wrap end -->

        </section><!-- search_result end -->

    </section><!-- pop_body end -->
</div>
<!-- popup_wrap end -->
