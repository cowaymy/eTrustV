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

<style type="text/css">
    .auto_file{padding-right:74px;}
    .aui-grid-link-renderer1 {
	  text-decoration:underline;
	  color: #4374D9 !important;
	  cursor: pointer;
	  text-align: right;
	}
	/* 커스텀 열 스타일 */
	.my-column-style2 {
	    background:#FFEBFE;
	    color:#0000ff;
	}
</style>

<script type="text/javascript">
    var dedRsnList = [];
    var otherGiRsnList = [];
    var otherGrRsnList = [];
    var comDedRsnList = [];
    var detOtherRsnList = [];
    var detDedRsnList = [];
    var otherAllRsnList = [];

    var itemRegGrid, itemApprGrid;

    var itemColumnLayout=[
                         {dataField: "rnum",headerText :"<spring:message code='log.head.rnum'/>" ,width:1, visible:false },
                         {dataField: "itmId",headerText :"<spring:message code='log.head.rnum'/>" ,width:1, visible:false},
                         {dataField: "stkCode",headerText :"<spring:message code='log.head.itemcode'/>",width: 80, editable : false},
                         {dataField: "stkDesc",headerText :"<spring:message code='log.head.itemname'/>",width: 180, editable : false, style: "aui-grid-user-custom-left"},
                         {dataField: "sysQty",headerText :"<spring:message code='log.head.systemqty'/>",width:90, editable : false,style: "aui-grid-user-custom-right",
                        	 styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField){
                                 if(item.serialChkYn == "Y" && item.serialRequireChkYn== "Y" && item.itemSerialChkYn== "Y") {
                                     return "aui-grid-link-renderer1";
                                 }
                             }
                         },
                         {dataField: "cntQty",headerText :"<spring:message code='log.head.countqty'/>", width:90, editable : true, headerStyle : "aui-grid-header-input-icon aui-grid-header-input-essen", style: "aui-grid-user-custom-right",
                        	 dataType : "numeric",
                        	 styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField){
                        		 if(item.serialChkYn == "Y" && item.serialRequireChkYn== "Y" && item.itemSerialChkYn== "Y") {
                                     return "aui-grid-link-renderer1";
                                 } else{
                                	 return "my-column-style2";
                                 }
                             },
                        	 editRenderer : {
                        	     type : "InputEditRenderer",
                        	     onlyNumeric : true
                        	 }
                         },
                         {dataField: "diffQty",headerText :"<spring:message code='log.head.variance'/>", width:190, editable : false, style: "aui-grid-user-custom-right"},
                         {dataField: "dedQty",headerText :"<spring:message code='log.head.deductionQty'/>", width:1, editable : false, visible:false, style: "aui-grid-user-custom-right"},
                         {dataField: "otherQty",headerText :"<spring:message code='log.head.otherGiGrQty'/>", width:1, editable : false, visible:false, style: "aui-grid-user-custom-right"},
                         {dataField: "rem",headerText :"<spring:message code='log.head.remark'/>", width:180, editable : true, headerStyle : "aui-grid-header-input-icon", style: "aui-grid-user-custom-left"},
                         {dataField: "stkGrad",headerText :"<spring:message code='log.head.locationgrade'/>" ,width:120, editable : false},
                         {dataField: "stkType",headerText :"<spring:message code='log.head.itemtype'/>" ,width: 90, editable : false },
                         {dataField: "stkCtgryType",headerText :"<spring:message code='log.head.categoryType'/>", width: 120, editable : false },
                         {dataField: "serialChkYn",headerText :"Serial Chk Yn" ,width:100, visible:false},
                         {dataField: "stockAuditNo",headerText :"<spring:message code='log.head.stockAuditNo'/>" ,width:100, visible:false},
                         {dataField: "whLocId",headerText :"" ,width:100, visible:false},
                         {dataField: "whLocGb",headerText :"" ,width:100, visible:false},
                         {dataField: "serialRequireChkYn",headerText :"" ,width:100, visible:false},
                         {dataField: "itemSerialChkYn",headerText :"" ,width:100, visible:false}

                 ];

    var itemApprColumnLayout=[
                          {dataField: "rnum",headerText :"<spring:message code='log.head.rnum'/>" ,width:1, visible:false },
                          {dataField: "itmId",headerText :"<spring:message code='log.head.rnum'/>" ,width:1, visible:false},
                          {dataField: "stkCode",headerText :"<spring:message code='log.head.itemcode'/>",width: 80, editable : false},
                          {dataField: "stkDesc",headerText :"<spring:message code='log.head.itemname'/>",width: 180, editable : false, style: "aui-grid-user-custom-left"},
                          {dataField: "stkGrad",headerText :"<spring:message code='log.head.locationgrade'/>" ,width:120, editable : false},
                          {dataField: "stkType",headerText :"<spring:message code='log.head.itemtype'/>" ,width: 90, editable : false },
                          {dataField: "stkCtgryType",headerText :"<spring:message code='log.head.categoryType'/>", width: 120, editable : false },
                          {dataField: "sysQty",headerText :"<spring:message code='log.head.systemqty'/>",width:90, editable : false, style: "aui-grid-user-custom-right"},
                          {dataField: "cntQty",headerText :"<spring:message code='log.head.countqty'/>", width:90, editable : false, style: "aui-grid-user-custom-right"},
                          {dataField: "diffQty",headerText :"<spring:message code='log.head.variance'/>", width:190, editable : false, style: "aui-grid-user-custom-right"},
                          {dataField: "dedQty",headerText :"<spring:message code='log.head.deductionQty'/>", width:130, editable : true, headerStyle : "aui-grid-header-input-icon aui-grid-header-input-essen", style: "aui-grid-user-custom-right",
                        	  dataType : "numeric",
                              editRenderer : {
                                  type : "InputEditRenderer",
                                  onlyNumeric : true
                              }
                          },
                          {dataField: "dedReason",headerText :"<spring:message code='log.head.deductionReason'/>", width:130, editable : true, headerStyle : "aui-grid-header-input-icon",
                        	  labelFunction : function(  rowIndex, columnIndex, value, headerText, item ) {
                        		  var retStr = value;

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
                          {dataField: "otherQty",headerText :"<spring:message code='log.head.otherGiGrQty'/>", width:130, editable : false, style: "aui-grid-user-custom-right"},
                          {dataField: "otherReason",headerText :"<spring:message code='log.head.otherGiGrReason'/>", width:160, editable : true, headerStyle : "aui-grid-header-input-icon",
                        	  labelFunction : function(  rowIndex, columnIndex, value, headerText, item ) {
                                  var retStr = value;

                                  for(var i=0,len=otherAllRsnList.length; i<len; i++) {
                                	  if(otherAllRsnList[i]["code"] == value) {
                                    	  retStr = otherAllRsnList[i]["codeName"];
                                          break;
                                      }
                                  }
                                  return retStr;
                              },
                              editRenderer : {
                                  type : "DropDownListRenderer",
                                  showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
                                  list : otherAllRsnList, //key-value Object 로 구성된 리스트
                                  keyField : "code", // key 에 해당되는 필드명
                                  valueField : "codeName", // value 에 해당되는 필드명
                                  listAlign : "left"
                              },
                          },
                          {dataField: "rem",headerText :"<spring:message code='log.head.remark'/>", width:180, editable : true, headerStyle : "aui-grid-header-input-icon", style: "aui-grid-user-custom-left"}
                  ];

    var itemDetColumnLayout=[
                              {dataField: "rnum",headerText :"<spring:message code='log.head.rnum'/>" ,width:1, visible:false },
                              {dataField: "itmId",headerText :"<spring:message code='log.head.rnum'/>" ,width:1, visible:false},
                              {dataField: "stkCode",headerText :"<spring:message code='log.head.itemcode'/>",width: 80},
                              {dataField: "stkDesc",headerText :"<spring:message code='log.head.itemname'/>",width: 180, style: "aui-grid-user-custom-left"},
                              {dataField: "stkGrad",headerText :"<spring:message code='log.head.locationgrade'/>" ,width:120},
                              {dataField: "stkType",headerText :"<spring:message code='log.head.itemtype'/>" ,width: 90},
                              {dataField: "stkCtgryType",headerText :"<spring:message code='log.head.categoryType'/>", width: 120},
                              {dataField: "sysQty",headerText :"<spring:message code='log.head.systemqty'/>",width:90, style: "aui-grid-user-custom-right"},
                              {dataField: "cntQty",headerText :"<spring:message code='log.head.countqty'/>", width:90, style: "aui-grid-user-custom-right"},
                              {dataField: "diffQty",headerText :"<spring:message code='log.head.variance'/>", width:190, style: "aui-grid-user-custom-right"},
                              {dataField: "dedQty",headerText :"<spring:message code='log.head.deductionQty'/>", width:130, style: "aui-grid-user-custom-right"},
                              {dataField: "dedReason",headerText :"<spring:message code='log.head.deductionReason'/>", width:250,
                            	  labelFunction : function(  rowIndex, columnIndex, value, headerText, item ) {
                                      var retStr = value;
                                      detDedRsnList.length = 0;

                                      if(item.dedQty == 0) {
                                    	  var temp    = { code : "", codeName : "" };
                                    	  var dedRsnListTemp = [];
                                    	  dedRsnListTemp.push(temp);
                                    	  detDedRsnList.push(dedRsnListTemp[0]);
                                      } else {
                                          for(var i=0,len=dedRsnList.length; i<len; i++) {
                                        	  detDedRsnList.push(dedRsnList[i]);
                                          }
                                      }

                                      for(var i=0,len=detDedRsnList.length; i<len; i++) {
                                          if(detDedRsnList[i]["code"] == value) {
                                        	  if(FormUtil.isEmpty(value)) {
                                        		  retStr = "";
                                        	  } else {
                                        		  retStr = detDedRsnList[i]["codeName"];
                                        	  }
                                        	  break;
                                          }
                                      }
                                      return retStr;
                                  },
                                  editRenderer : {
                                      type : "DropDownListRenderer",
                                      showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
                                      list : detDedRsnList, //key-value Object 로 구성된 리스트
                                      keyField : "code", // key 에 해당되는 필드명
                                      valueField : "codeName", // value 에 해당되는 필드명
                                      listAlign : "left"
                                  },
                              },
                              {dataField: "otherQty",headerText :"<spring:message code='log.head.otherGiGrQty'/>", width:130, style: "aui-grid-user-custom-right"},
                              {dataField: "otherReason",headerText :"<spring:message code='log.head.otherGiGrReason'/>", width:250,
                            	  labelFunction : function(  rowIndex, columnIndex, value, headerText, item ) {
                                      var retStr = value;
                                      detOtherRsnList.length = 0;

                                      if(item.otherQty > 0) {               // Other GR
                                          for(var i=0,len=otherGrRsnList.length; i<len; i++) {
                                        	  detOtherRsnList.push(otherGrRsnList[i]);
                                          }
                                      } else if(item.otherQty < 0 ) {   // Other GI
                                           for(var i=0,len=otherGiRsnList.length; i<len; i++) {
                                        	   detOtherRsnList.push(otherGiRsnList[i]);
                                          }
                                      } else {
                                    	  var temp    = { code : "", codeName : "" };
                                    	  var otherRsnListTemp = [];
                                    	  otherRsnListTemp.push(temp);
                                          detOtherRsnList.push(otherRsnListTemp[0]);
                                      }

                                      for(var i=0,len=detOtherRsnList.length; i<len; i++) {
                                          if(detOtherRsnList[i]["code"] == value) {
                                        	  if(FormUtil.isEmpty(value)) {
                                                  retStr = "";
                                              } else {
                                        	      retStr = detOtherRsnList[i]["codeName"];
                                              }
                                        	  break;
                                          }
                                      }
                                      return retStr;
                                  },
                                  editRenderer : {
                                      type : "DropDownListRenderer",
                                      showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
                                      list : detOtherRsnList, //key-value Object 로 구성된 리스트
                                      keyField : "code", // key 에 해당되는 필드명
                                      valueField : "codeName", // value 에 해당되는 필드명
                                      listAlign : "left"
                                  },
                              },
                              {dataField: "rem",headerText :"<spring:message code='log.head.remark'/>", width:180, style: "aui-grid-user-custom-left"}
                      ];
    var itemregop = {
        rowIdField : "rnum",
        showRowCheckColumn : false,
        editable : true,
        usePaging : false, //페이징 사용
        showStateColumn : true,
        headerHeight: 35,
        selectionMode : "singleCell",
        };

    var itemapprop = {
        rowIdField : "rnum",
        showRowCheckColumn : false,
        editable : true,
        usePaging : false, //페이징 사용
        showStateColumn : true,
        headerHeight: 35,
        selectionMode : "singleCell",
        };

    var itemdetop = {
        rowIdField : "rnum",
        showRowCheckColumn : false,
        editable : false,
        usePaging : false, //페이징 사용
        showStateColumn : false,
        headerHeight: 35,
        selectionMode : "singleCell",
        };

    $(document).ready(function () {

        fn_reasonCodeSearch();

        if('${action}' == 'REG') {
    	    $("#APPR_T").hide();
    		$("#APPR_D1").hide();
    		$("#APPR_D2").hide();

    		$("#REG").show();
            $("#APPR").hide();
            $("#DET").hide();

            itemRegGrid = GridCommon.createAUIGrid("item_grid_wrap_pop", itemColumnLayout,"", itemregop);
	    	AUIGrid.setGridData(itemRegGrid, $.parseJSON('${itemList}'));

	    	var length = AUIGrid.getGridData(itemRegGrid).length;
	    	var requireCnt = 0;
	    	var itemCnt = 0;

	    	if(length > 0) {
	    	    for(var i = 0; i < length; i++) {
	    	        if(AUIGrid.getCellValue(itemRegGrid, i, "serialRequireChkYn") == 'Y') {// SERIAL_REQUIRE_CHK_YN
	    	            requireCnt ++;
	    	        }
	    	        if(AUIGrid.getCellValue(itemRegGrid, i, "itemSerialChkYn") == 'Y') {// ITEM SERIAL CHECK YN
                        itemCnt ++;
                    }
	    	    }
	    	}

	    	$("#liAllDel").show();
            $("#liPopSerial").show();

	    	if('${docInfo.serialChkYn}' == 'Y' && requireCnt > 0 && itemCnt > 0) {
	    		$("#btnPopSerial").parent().removeClass("btn_disabled");
	    	    $("#btnAllDel").parent().removeClass("btn_disabled");
            } else {
            	$("#btnPopSerial").parent().addClass("btn_disabled");
                $("#btnAllDel").parent().addClass("btn_disabled");
            }

            setInputFile();

        } else if('${action}' == 'APPR') {
        	$("#APPR_T").show();
            $("#APPR_D1").show();
            $("#APPR_D2").hide();

            $("#REG").hide();
            $("#APPR").show();
            $("#DET").hide();

            $("#pop_header_title_dtl").text("1st Approval / Reject");

            itemApprGrid = GridCommon.createAUIGrid("itemappr_grid_wrap_pop", itemApprColumnLayout,"", itemapprop);
            AUIGrid.setGridData(itemApprGrid, $.parseJSON('${itemList}'));

        } else if('${action}' == 'DET') {
        	$("#APPR_T").show();
            $("#APPR_D1").hide();
            $("#APPR_D2").show();

            $("#REG").hide();
            $("#APPR").hide();
            $("#DET").show();

            $("#pop_header_title_dtl").text("Count-Stock Audit Detail");

            itemDetGrid = GridCommon.createAUIGrid("itemdet_grid_wrap_pop", itemDetColumnLayout,"", itemdetop);
            AUIGrid.setGridData(itemDetGrid, $.parseJSON('${itemList}'));

        }

        fn_setVal();

        AUIGrid.bind(itemRegGrid, "cellClick", function( event ) {
     	    var rowIndex = event.rowIndex;
            var dataField = AUIGrid.getDataFieldByColumnIndex(itemRegGrid, event.columnIndex);
            var serialChkYn = AUIGrid.getCellValue(itemRegGrid, rowIndex, "serialChkYn");
            var serialRequireChkYn = AUIGrid.getCellValue(itemRegGrid, rowIndex, "serialRequireChkYn");
            var itemSerialChkYn = AUIGrid.getCellValue(itemRegGrid, rowIndex, "itemSerialChkYn");

            if(dataField == "sysQty"){
                var rowIndex = event.rowIndex;
                if(serialChkYn == "Y" && serialRequireChkYn == "Y" && itemSerialChkYn == "Y"){
                    $('#frmSearchSerial #pLocationType').val( AUIGrid.getCellValue(itemRegGrid, rowIndex, "whLocGb") );
                    $('#frmSearchSerial #pLocationCode').val( AUIGrid.getCellValue(itemRegGrid, rowIndex, "whLocId") );
                    $('#frmSearchSerial #pItemCodeOrName').val( AUIGrid.getCellValue(itemRegGrid, rowIndex, "stkCode") );

                    fn_serialSearchPop();
                }
            }

           if(dataField == "cntQty"){
        	   if(serialChkYn == "Y" && serialRequireChkYn == "Y" && itemSerialChkYn == "Y"){
            	   $("#serialForm #pRequestNo").val(AUIGrid.getCellValue(itemRegGrid, rowIndex, "stockAuditNo"));
                   $("#serialForm #pStatus").val("I");
                   fn_scanSearchPop();
                }
           }
       });

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

	   // 에디팅 정상 종료 이벤트 바인딩
       AUIGrid.bind(itemRegGrid, "cellEditBegin", auiCellEditignHandler);
       AUIGrid.bind(itemRegGrid, "cellEditEnd", auiCellEditignHandler);
       AUIGrid.bind(itemApprGrid, "cellEditBegin",auiCellEditignHandlerAppr);
       AUIGrid.bind(itemApprGrid, "cellEditEnd",auiCellEditignHandlerAppr);

       // IE10, 11은 readAsBinaryString 지원을 안함. 따라서 체크함.
       var rABS = typeof FileReader !== "undefined" && typeof FileReader.prototype !== "undefined" && typeof FileReader.prototype.readAsBinaryString !== "undefined";

       // HTML5 브라우저인지 체크 즉, FileReader 를 사용할 수 있는지 여부
       function checkHTML5Brower() {
           var isCompatible = false;
           if (window.File && window.FileReader && window.FileList && window.Blob) {
               isCompatible = true;
           }
           return isCompatible;
       };

       $('#fileSelector').on('change', function(evt) {
           if (!checkHTML5Brower()) {
        	   Common.alert("* Not Support HTML5 your Browser!. Please Upload To Server.");
               return;
           } else {
               var data = null;
               var file = evt.target.files[0];
               if (typeof file == "undefined") {
            	   Common.alert("* can not Select this File.");
                   return;
               }
               var reader = new FileReader();

               reader.onload = function(e) {
                   var data = e.target.result;

                   /* 엑셀 바이너리 읽기 */
                   var workbook;

                   if(rABS) { // 일반적인 바이너리 지원하는 경우
                       workbook = XLSX.read(data, {type: 'binary'});
                   } else { // IE 10, 11인 경우
                       var arr = fixdata(data);
                       workbook = XLSX.read(btoa(arr), {type: 'base64'});
                   }

                   var jsonObj = process_wb(workbook);

                   createAUIGrid( jsonObj[Object.keys(jsonObj)[0]] );
               };

               if(rABS) reader.readAsBinaryString(file);
               else reader.readAsArrayBuffer(file);

           }
       });

       $("#btnAllDel").click(function(){
           if($(this).parent().hasClass("btn_disabled") == true){
               return false;
           }

           var msg = "Do you want to All Delete Stock Aduit No ["+$("#zRstNo").val()+"]?";

           Common
               .confirm(msg,
                   function(){
                       var itemDs = {"allYn":"Y"
                               , "rstNo":$("#zRstNo").val()
                               , "locId":$("#zFromLoc").val()
                               , "ioType":$("#zIoType").val()
                               , "transactionType":$("#zTrnscType").val()};

                           Common.ajax("POST", "/logistics/serialMgmtNew/deleteAdSerial.do"
                                   , itemDs
                                   , function(result){
                                       $("#btnPopSearch").click();
                                   }
                                   , function(jqXHR, textStatus, errorThrown){
                                       try{
                                           if (FormUtil.isNotEmpty(jqXHR.responseJSON)) {
                                               console.log("code : "  + jqXHR.responseJSON.code);
                                               Common.alert("Fail : " + jqXHR.responseJSON.message);
                                           }else{
                                               console.log("Fail Status : " + jqXHR.status);
                                               console.log("code : "        + jqXHR.responseJSON.code);
                                               console.log("message : "     + jqXHR.responseJSON.message);
                                               console.log("detailMessage : "  + jqXHR.responseJSON.detailMessage);
                                           }
                                       }catch (e){
                                           console.log(e);
                                       }
                          });
                   }
           );
       });

       $("#btnPopSerial").click(function(){
           if($(this).parent().hasClass("btn_disabled") == true){
               return false;
           }

           var editedRowItems = AUIGrid.getEditedRowItems(itemRegGrid);
           //alert(editedRowItems.length)
           if(editedRowItems.length > 0){
        	   Common.alert("It's changed. Save first.");
        	   return false;
           }

           if(Common.checkPlatformType() == "mobile") {
               popupObj = Common.popupWin("serialForm", "/logistics/serialMgmtNew/serialScanCommonPop.do", {width : "1000px", height : "720", resizable: "no", scrollbars: "yes"});
           } else{
               Common.popupDiv("/logistics/serialMgmtNew/serialScanCommonPop.do", null, null, true, '_serialScanPop');
           }
       });

       $("#btnPopSearch").click(function(){
           fn_itemListAjax();
       });
    });

    function fn_itemListAjax() {

        var obj = {"stockAuditNo":$("#hidStockAuditNo").val(), "whLocId":$("#hidWhLocId").val()};

           Common.ajax("GET", "/logistics/adjustment/countStockAuditItemList.do", obj, function (result) {
            AUIGrid.setGridData(itemRegGrid,result);
        });
    }

    //IE10, 11는 바이너리스트링 못읽기 때문에 ArrayBuffer 처리 하기 위함.
    function fixdata(data) {
        var o = "", l = 0, w = 10240;
        for(; l<data.byteLength/w; ++l) o+=String.fromCharCode.apply(null,new Uint8Array(data.slice(l*w,l*w+w)));
        o+=String.fromCharCode.apply(null, new Uint8Array(data.slice(l*w)));
        return o;
    }

    // 파싱된 시트의 CDATA 제거 후 반환.
    function process_wb(wb) {
        var output = "";
        output = JSON.stringify(to_json(wb));
        output = output.replace( /<!\[CDATA\[(.*?)\]\]>/g, '$1' );
        return JSON.parse(output);
    }

    // 엑셀 시트를 파싱하여 반환
    function to_json(workbook) {
        var result = {};
        workbook.SheetNames.forEach(function(sheetName) {
            var roa = XLSX.utils.sheet_to_row_object_array(workbook.Sheets[sheetName],{defval:""});
            if(roa.length >= 0){
                result[sheetName] = roa;
            }
        });
        return result;
    }

    // 엑셀 파일 시트에서 파싱한 JSON 데이터 기반으로 그리드 동적 생성
    function createAUIGrid(jsonData) {
    	var firstRow = jsonData;

    	if(typeof firstRow == "undefined") {
    	    Common.alert("* Can Convert File. Please Try Again.");
    	    $("#fileSelector").val("");
    	    return;
    	}

   	    var gridArray = [];
   	    $.each(firstRow, function(key , value) {
   	        var keyValue = {};
   	      $.each(value, function(k, v) {
   	            console.log("key : " + k + ",value : " + v);
   	            console.log("key : " + v);
   	            if(k.trim() == "Item Code") {
   	                keyValue.stkCode = v;
   	            }
	   	        if(k.trim() == "Count Qty") {
	                keyValue.cntQty = v;
	            }
		   	    if(k.trim() == "System Qty") {
	                keyValue.sysQty = v;
	            }
   	            if(k.trim() == "Remark") {
   	                keyValue.rem = v;
   	            }

   	      });
   	      gridArray.push(keyValue);
   	    });

   	    //template Chk
   	    if(gridArray == null || gridArray.length <= 0) {
   	        Common.alert("* Template was Chaged. Please Try Again. ");
   	        $("#fileSelector").val("");
   	        return;
   	    }

   	   fn_setGridDataByUploadData(gridArray);

    };

    function fn_setGridDataByUploadData(array) {
    	var itemRegGridData = AUIGrid.getGridData(itemRegGrid);

        //Params Setting
        var strArr = [];
        for (var idx = 0; idx < itemRegGridData.length; idx++) {
            strArr.push(itemRegGridData[idx].stkCode);
        }

        var existArray = [];
        $.each(array, function(i , o) {
            var data = null;
            $.each(o, function(k, v) {
              //console.log("key : " + k+ ", val : " + v)
              if(k.trim() == "stkCode") {
                  if(strArr.indexOf(v) != -1){
                      data = o;
                      existArray.push(data);
                  }
              }
            });
        });

        if(existArray.length > 0) {
            for (var idx = 0; idx < existArray.length; idx++) {
                console.log(existArray[idx]);
                var rows = AUIGrid.getRowIndexesByValue(itemRegGrid, "stkCode", existArray[idx].stkCode);
                if(!FormUtil.onlyNumCheck(existArray[idx].cntQty)) {
                	Common.alert("<spring:message code='sys.common.alert.validationNumber' />");
                    return false;
                } else {
                	if(AUIGrid.getCellValue(itemRegGrid, rows[0], "serialChkYn") == 'Y' && AUIGrid.getCellValue(itemRegGrid, rows[0], "serialRequireChkYn") == 'Y' && AUIGrid.getCellValue(itemRegGrid, rows[0], "itemSerialChkYn") == "Y") {
                    } else {
	                	var cntQty = existArray[idx].cntQty;
	                	var sysQty = existArray[idx].sysQty;
	                    var diffQty = Number(cntQty) - Number(sysQty);

	                	AUIGrid.setCellValue(itemRegGrid, rows[0], "cntQty", cntQty);                     // Count Qty
	                    AUIGrid.setCellValue(itemRegGrid, rows[0], "diffQty", diffQty);                     // Variance
	                    AUIGrid.setCellValue(itemRegGrid, rows[0], "dedQty", 0);                            // Deduction Qty(Hidden)
	                    AUIGrid.setCellValue(itemRegGrid, rows[0], "otherQty", diffQty);                  // Other GI/GR Qty(Hidden)
	                    AUIGrid.setCellValue(itemRegGrid, rows[0], "rem", existArray[idx].rem);         // Remark
                    }
                }
            }
        } else {
        	var arg = "<spring:message code='log.head.itemcode' />";
            Common.alert("<spring:message code='sys.msg.invalid' arguments='"+ arg +"'/>");
        }
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

    function fn_selectCountStockAuditAjax(){
        Common.ajax("POST", "/logistics/adjustment/countStockAuditRegisterPop", $("#insertForm").serializeJSON(), function (result) {
            AUIGrid.setGridData(itemRegGrid, result.dataList);
        });
    }

    function fn_checkValid(){

    	var reqCnt = 0;
        var length = AUIGrid.getGridData(itemRegGrid).length;
        var arg = "<spring:message code='log.head.countqty' />";

        if(length > 0) {
            var blZero = false;
            for(var i = 0; i < length; i++) {
        	   var serialChkYn = AUIGrid.getCellValue(itemRegGrid, i, "serialChkYn");
               var serialRequireChkYn = AUIGrid.getCellValue(itemRegGrid, i, "serialRequireChkYn");
               var itemSerialChkYn = AUIGrid.getCellValue(itemRegGrid, i, "itemSerialChkYn");

               var blEdit = true;
               if(serialChkYn == 'Y' && serialRequireChkYn == 'Y' && itemSerialChkYn == 'Y' ){
            	   blEdit = false;
               }

               if(FormUtil.isEmpty(AUIGrid.getCellValue(itemRegGrid, i, "cntQty")) || AUIGrid.getCellValue(itemRegGrid, i, "cntQty") < 0) {

            	   //reqCnt ++;
            	   Common.alert("<spring:message code='sys.msg.necessary' arguments='"+ arg +"'/>");
            	   AUIGrid.setSelectionByIndex(itemRegGrid, i, 8);
            	   return false;
               }

               if(AUIGrid.getCellValue(itemRegGrid, i, "cntQty") == 0){
            	   blZero = true;
               }
            }
            if(blZero){
            	if(Common.confirm("Count Qty is zero. Do you want to request approval?", function(){
            		for(var i = 0; i < length; i++) {
            			if(AUIGrid.getCellValue(itemRegGrid, i, "cntQty") == 0){
            				AUIGrid.setCellValue(itemRegGrid, i, "cntQty","0");
            				var diffQty = 0 - Number(AUIGrid.getCellValue(itemRegGrid, i, "sysQty"));

                            AUIGrid.setCellValue(itemRegGrid, i, "diffQty", diffQty);           // Variance
                            AUIGrid.setCellValue(itemRegGrid, i, "dedQty", 0);                 // Deduction Qty(Hidden)
                            AUIGrid.setCellValue(itemRegGrid, i, "otherQty", diffQty);         // Other GI/GR Qty(Hidden)
                        }
            		}

            		fn_requestApprove();
            	})){
            		return true;
            	}else{
            		return false;
            	}
            }

        }

        /*
        if(reqCnt > 0) {
            var arg = "<spring:message code='log.head.countqty' />";
            Common.alert("<spring:message code='sys.msg.necessary' arguments='"+ arg +"'/>");
            return false;
        }
        */
        return true;
    }

    function fn_checkApprValid(){
        var reqCnt = 0;
        var length = AUIGrid.getGridData(itemApprGrid).length;

        if(length > 0) {
           for(var i = 0; i < length; i++) {

               if(Math.abs(AUIGrid.getCellValue(itemApprGrid, i, "diffQty")) < AUIGrid.getCellValue(itemApprGrid, i, "dedQty")) {
                   reqCnt ++;
               }
           }
        }

        if(reqCnt > 0) {
            Common.alert("Deduction Qty cannot be greater than Variance.");
            return false;
        }
        return true;
    }

    function fn_close() {
        $("#popClose").click();
    }

    //excel Download
    $('#excelDownReg').click(function() {
       GridCommon.exportTo("item_grid_wrap_pop", 'xlsx', "Count Stock Audit Item List");
    });

    $('#excelDownAppr').click(function() {
        GridCommon.exportTo("itemappr_grid_wrap_pop", 'xlsx', "Count Stock Audit Item List");
     });

    $('#excelDownDet').click(function() {
        GridCommon.exportTo("itemdet_grid_wrap_pop", 'xlsx', "Count Stock Audit Item List");
     });

    $('#save').click(function() {

    	if ( true == $(this).parents().hasClass("btn_disabled") ) {
            return  false;
        }

    	//if(!fn_checkValid()){
        //    return  false;
        //}

    	var appvType = "save";

        var obj = $("#insertForm").serializeJSON();
        obj.stockAuditNo = $("#hidStockAuditNo").val();
        obj.whLocId = $("#hidWhLocId").val();

        Common.ajaxSync("GET", "/logistics/adjustment/selectStockAuditLocDtTime.do", obj, function(result){
            if(result != null) {
                if(result.updDtTime != $("#hidUpdDtTime").val()) {
                    Common.alert("The data you have selected is already updated.");
                    return false;
                } else {
                	if(Common.confirm("<spring:message code='sys.common.alert.save'/>", function(){
                		var formData = Common.getFormData("insertForm");

                        formData.append("atchFileGrpId", $("#atchFileGrpId").val());
                        formData.append("updateFileIds", $("#updateFileIds").val());
                        formData.append("deleteFileIds", $("#deleteFileIds").val());

                        Common.ajaxFile("/logistics/adjustment/stockAuditUploadFile.do", formData, function(result) {//  첨부파일 정보를 공통 첨부파일 테이블 이용 : 웹 호출 테스트
                            if(result.data) {
                                $("#atchFileGrpId").val(result.data);
                            }
                            fn_saveCountStockAuditNew(appvType);
                        });
                    }));
                }
            }
       });
    });

    $('#requestApproval').click(function() {

    	if ( true == $(this).parents().hasClass("btn_disabled") ) {
            return  false;
        }

    	if(!fn_checkValid()){
            return  false;
        }

    	fn_requestApprove();
    });

    function fn_requestApprove(){
    	var appvType = "reqAprv";

        var obj = $("#insertForm").serializeJSON();
        obj.stockAuditNo = $("#hidStockAuditNo").val();
        obj.whLocId = $("#hidWhLocId").val();

        Common.ajaxSync("GET", "/logistics/adjustment/selectStockAuditLocDtTime.do", obj, function(result){
            if(result != null) {
                if(result.updDtTime != $("#hidUpdDtTime").val()) {
                    Common.alert("The data you have selected is already updated.");
                    return false;
                } else {
                    if(Common.confirm("Do you want to request approval?", function(){
                        var formData = Common.getFormData("insertForm");

                        formData.append("atchFileGrpId", $("#atchFileGrpId").val());
                        formData.append("updateFileIds", $("#updateFileIds").val());
                        formData.append("deleteFileIds", $("#deleteFileIds").val());

                        Common.ajaxFile("/logistics/adjustment/stockAuditUploadFile.do", formData, function(result) {//  첨부파일 정보를 공통 첨부파일 테이블 이용 : 웹 호출 테스트
                            if(result.data) {
                                $("#atchFileGrpId").val(result.data);
                            }
                            fn_saveCountStockAuditNew(appvType);
                        });
                    }));
                }
            }
       });
    }

    $('#appsave').click(function() {

        if ( true == $(this).parents().hasClass("btn_disabled") ) {
            return  false;
        }

        if(!fn_checkApprValid()){
            return  false;
        }

        var appvType = "aprv1Save";

        var obj = $("#insertForm").serializeJSON();
        obj.stockAuditNo = $("#hidStockAuditNo").val();
        obj.whLocId = $("#hidWhLocId").val();

        Common.ajaxSync("GET", "/logistics/adjustment/selectStockAuditLocDtTime.do", obj, function(result){
            if(result != null) {
                if(result.updDtTime != $("#hidUpdDtTime").val()) {
                    Common.alert("The data you have selected is already updated.");
                    return false;
                } else {
			        if(Common.confirm("<spring:message code='sys.common.alert.save'/>", function(){
			            var formData = Common.getFormData("insertForm");

			            formData.append("atchFileGrpId", $("#atchFileGrpId").val());
			            formData.append("updateFileIds", $("#updateFileIds").val());
			            formData.append("deleteFileIds", $("#deleteFileIds").val());

			    	    Common.ajaxFile("/logistics/adjustment/stockAuditUploadFile.do", formData, function(result) {//  첨부파일 정보를 공통 첨부파일 테이블 이용 : 웹 호출 테스트
			                if(result.data) {
			                    $("#atchFileGrpId").val(result.data);
			                }
			                fn_1stApproval(appvType, locStusCodeId);
			    	    });
                    }));
                }
            }
       });
    });

    $('#approve').click(function() {

        if ( true == $(this).parents().hasClass("btn_disabled") ) {
            return  false;
        }

        if(FormUtil.checkReqValue($("#appv1Opinion"))){
            var arg = "<spring:message code='log.head.1stOpinion' />";
            Common.alert("<spring:message code='sys.msg.necessary' arguments='"+ arg +"'/>");
            return false;
        }

        if(!fn_checkApprValid()){
            return  false;
        }

        var dedCnt = 0;
        var length = AUIGrid.getGridData(itemApprGrid).length;
        if(length > 0) {
           for(var i = 0; i < length; i++) {
        	   if(AUIGrid.getCellValue(itemApprGrid, i, "dedQty") > 0 && FormUtil.isEmpty(AUIGrid.getCellValue(itemApprGrid, i, "dedReason"))) {
            	   dedCnt ++;
               }
           }
        }

        if(dedCnt > 0) {
            var arg = "<spring:message code='log.head.deductionReason' />";
            Common.alert("<spring:message code='sys.msg.necessary' arguments='"+ arg +"'/>");
            return false;
        }

        var otherCnt = 0;
        if(length > 0) {
           for(var i = 0; i < length; i++) {
               if(Math.abs(AUIGrid.getCellValue(itemApprGrid, i, "otherQty")) > 0 && FormUtil.isEmpty(AUIGrid.getCellValue(itemApprGrid, i, "otherReason"))) {
            	   otherCnt ++;
               }
           }
        }

        if(otherCnt > 0) {
            var arg = "<spring:message code='log.head.otherGiGrReason' />";
            Common.alert("<spring:message code='sys.msg.necessary' arguments='"+ arg +"'/>");
            return false;
        }

        var appvType = "aprv1";

        var obj = $("#insertForm").serializeJSON();
        obj.stockAuditNo = $("#hidStockAuditNo").val();
        obj.whLocId = $("#hidWhLocId").val();

        Common.ajaxSync("GET", "/logistics/adjustment/selectStockAuditLocDtTime.do", obj, function(result){
        	if(result != null) {
                if(result.updDtTime != $("#hidUpdDtTime").val()) {
                    Common.alert("The data you have selected is already updated.");
                    return false;
                } else {
			        if(Common.confirm("Do you want to approve?", function(){
			            var formData = Common.getFormData("insertForm");

			            formData.append("atchFileGrpId", $("#atchFileGrpId").val());
			            formData.append("updateFileIds", $("#updateFileIds").val());
			            formData.append("deleteFileIds", $("#deleteFileIds").val());

			            Common.ajaxFile("/logistics/adjustment/stockAuditUploadFile.do", formData, function(result) {//  첨부파일 정보를 공통 첨부파일 테이블 이용 : 웹 호출 테스트
			                if(result.data) {
			                    $("#atchFileGrpId").val(result.data);
			                }
			                fn_1stApproval(appvType, locStusCodeId);
			        	});
                    }));
                }
            }
       });
    });

    $('#reject').click(function() {

        if ( true == $(this).parents().hasClass("btn_disabled") ) {
            return  false;
        }

        if(FormUtil.checkReqValue($("#appv1Opinion"))){
            var arg = "<spring:message code='log.head.1stOpinion' />";
            Common.alert("<spring:message code='sys.msg.necessary' arguments='"+ arg +"'/>");
            return false;
        }

        var appvType = "rejt1";

        var obj = $("#insertForm").serializeJSON();
        obj.stockAuditNo = $("#hidStockAuditNo").val();
        obj.whLocId = $("#hidWhLocId").val();

        Common.ajaxSync("GET", "/logistics/adjustment/selectStockAuditLocDtTime.do", obj, function(result){
            if(result != null) {
                if(result.updDtTime != $("#hidUpdDtTime").val()) {
                    Common.alert("The data you have selected is already updated.");
                    return false;
                } else {
			        if(Common.confirm("Do you want to reject?", function(){
			            var formData = Common.getFormData("insertForm");

			            formData.append("atchFileGrpId", $("#atchFileGrpId").val());
			            formData.append("updateFileIds", $("#updateFileIds").val());
			            formData.append("deleteFileIds", $("#deleteFileIds").val());

			            Common.ajaxFile("/logistics/adjustment/stockAuditUploadFile.do", formData, function(result) {//  첨부파일 정보를 공통 첨부파일 테이블 이용 : 웹 호출 테스트
			                if(result.data) {
			                    $("#atchFileGrpId").val(result.data);
			                }
			                fn_1stApproval(appvType, locStusCodeId);
			        	});
                    }));
                }
            }
       });
    });

    function fn_saveCountStockAuditNew(appvType, locStusCodeId) {

        var obj = $("#insertForm").serializeJSON();
        var gridData = GridCommon.getGridData(itemRegGrid);
        obj.gridData = gridData;

        obj.appvType = appvType;
        obj.locStusCodeId = locStusCodeId;

        Common.ajax("POST", "/logistics/adjustment/saveCountStockAuditNew.do", obj , function(result)    {
            console.log("성공." + JSON.stringify(result));
            console.log("data : " + result.data);

            Common.alert(result.message, Common.removeLoader());

            $("#popClose").click();

            if(appvType == 'save') {
                var data = {
	                stockAuditNo: '${docInfo.stockAuditNo}',
	                whLocId: '${docInfo.whLocId}',
	                action: 'REG',
                };
                getListAjax(1);
            	//Common.popupDiv("/logistics/adjustment/countStockAuditRegisterPop.do", data, null, true);
            } else {
            	getListAjax(1);
            }
        }
        ,   function(jqXHR, textStatus, errorThrown){
                try {
                    console.log("Fail Status : " + jqXHR.status);
                    console.log("code : "        + jqXHR.responseJSON.code);
                    console.log("message : "     + jqXHR.responseJSON.message);
                    console.log("detailMessage : "  + jqXHR.responseJSON.detailMessage);
              }
              catch (e)
              {
                console.log(e);
              }
              Common.alert("Fail : " + jqXHR.responseJSON.message);
          });

    }

    function fn_1stApproval(appvType, locStusCodeId) {
        var obj = $("#insertForm").serializeJSON();

        var gridData = GridCommon.getGridData(itemApprGrid);
        obj.gridData = gridData;

        obj.stockAuditNo = $("#hidStockAuditNo").val();
        obj.whLocId = $("#hidWhLocId").val();
        obj.locStusCodeId = locStusCodeId;
        obj.appvType = appvType;

        Common.ajax("POST", "/logistics/adjustment/saveAppvInfo.do", obj, function(result) {//  첨부파일 정보를 공통 첨부파일 테이블 이용 : 웹 호출 테스트
             Common.alert(result.message);
             $("#popClose").click();

             getListAjax(1);
        });
    }

    function auiCellEditignHandler(event)
    {
        if(event.type == "cellEditBegin") {
            if (event.dataField == "cntQty")
            {
                var serialChkYn = AUIGrid.getCellValue(itemRegGrid, event.rowIndex, "serialChkYn");
                var serialRequireChkYn = AUIGrid.getCellValue(itemRegGrid, event.rowIndex, "serialRequireChkYn");
                var itemSerialChkYn = AUIGrid.getCellValue(itemRegGrid, event.rowIndex, "itemSerialChkYn");

                if(serialChkYn == 'Y' && serialRequireChkYn == 'Y' && itemSerialChkYn == 'Y' ) {
                     return false;
                }
            }
        } else if(event.type == "cellEditEnd") {
            //console.log("에디팅 종료(cellEditEnd) : ( " + event.rowIndex + ", " + event.columnIndex + " ) " + event.headerText + ", value : " + event.value);

            if (event.dataField == "cntQty")
            {
        	    var sysQty = AUIGrid.getCellValue(itemRegGrid, event.rowIndex, "sysQty");
        	    var cntQty = event.value;

        	    var diffQty = Number(cntQty) - Number(sysQty);

        	    AUIGrid.setCellValue(itemRegGrid, event.rowIndex, "diffQty", diffQty);           // Variance
        	    AUIGrid.setCellValue(itemRegGrid, event.rowIndex, "dedQty", 0);                 // Deduction Qty(Hidden)
        	    AUIGrid.setCellValue(itemRegGrid, event.rowIndex, "otherQty", diffQty);         // Other GI/GR Qty(Hidden)
            }
        }
    }

    function auiCellEditignHandlerAppr(event)
    {
        if (event.type == "cellEditBegin") {
        	if (event.dataField == "dedReason"){
        		comDedRsnList.length = 0;
                var dedQty = AUIGrid.getCellValue(itemApprGrid, event.rowIndex, "dedQty"); // Deduction Qty

                if(dedQty > 0) {
                    for(var i=0,len=dedRsnList.length; i<len; i++) {
                    	comDedRsnList.push(dedRsnList[i]);
                    }
                } else {
                    var temp    = { code : "", codeName : "" };
                    var dedRsnListTemp = [];
                    dedRsnListTemp.push(temp);
                    comDedRsnList.push(dedRsnListTemp[0]);
                }
            }

        	if (event.dataField == "otherReason"){
        		otherAllRsnList.length = 0;
        		var otherQty = AUIGrid.getCellValue(itemApprGrid, event.rowIndex, "otherQty"); // Other GI/GR Qty

        		if(otherQty > 0) {
        			for(var i=0,len=otherGrRsnList.length; i<len; i++) {
        				otherAllRsnList.push(otherGrRsnList[i]);
                    }
        		} else if(otherQty < 0) {
                    for(var i=0,len=otherGiRsnList.length; i<len; i++) {
                        otherAllRsnList.push(otherGiRsnList[i]);
                    }
                } else {
                	var temp    = { code : "", codeName : "" };
                    var otherRsnListTemp = [];
                    otherRsnListTemp.push(temp);
                    otherAllRsnList.push(otherRsnListTemp[0]);
                }
        	}
        }
        else if(event.type == "cellEditEnd") {
            //console.log("에디팅 종료(cellEditEnd) : ( " + event.rowIndex + ", " + event.columnIndex + " ) " + event.headerText + ", value : " + event.value);

            if (event.dataField == "dedQty")
            {
                var diffQty = AUIGrid.getCellValue(itemApprGrid, event.rowIndex, "diffQty");
                var dedQty = event.value;

                if(Math.abs(diffQty) <  dedQty) {
            	    Common.alert("Deduction Qty cannot be greater than Variance.");
            	    AUIGrid.setCellValue(itemApprGrid, event.rowIndex, "dedQty", 0);
            	    AUIGrid.setCellValue(itemApprGrid, event.rowIndex, "otherQty", diffQty);          // Other GI/GR Qty
                    return false;
                } else if(Number(diffQty) > 0 && Number(dedQty) > 0 ) {
                    Common.alert("If Variance Qty >0, Deduction Qty cannot be greater than 0.");
                    AUIGrid.setCellValue(itemApprGrid, event.rowIndex, "dedQty", 0);
                    AUIGrid.setCellValue(itemApprGrid, event.rowIndex, "otherQty", diffQty);          // Other GI/GR Qty
                    return false;
                } else {
	                var otherQty = Number(diffQty) +  Number(dedQty);
	                AUIGrid.setCellValue(itemApprGrid, event.rowIndex, "otherQty", otherQty);          // Other GI/GR Qty


		            if(dedQty == 0) {
		                AUIGrid.setCellValue(itemApprGrid, event.rowIndex, "dedReason", "");
		            }

		            if(otherQty == 0 ) {
	                    AUIGrid.setCellValue(itemApprGrid, event.rowIndex, "otherReason", "");
		            }
              }
          }
      }
   }

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
            obj ="dtlEventtypetd";
        }else if(str=="item"){
            obj ="dtlItemtypetd";
        }else if(str=="catagory"){
            obj ="dtlCatagorytypetd";
        }
        obj= '#'+obj;

        $.each(data, function(index,value) {
        	        $('<label>',{id:data[index].code}).appendTo(obj);
                    $('<input />',  {type : 'checkbox',value : data[index].codeId, id : data[index].codeId}).appendTo("#insertForm #"+data[index].code).attr("disabled","disabled");
                    $('<span />',  {text:data[index].codeName}).appendTo("#insertForm #"+data[index].code);
            });

            for(var i=0; i<tmp2.length;i++){
                $.each(data, function(index,value) {
                    if(tmp2[i]==data[index].codeId){
                        $("#insertForm #"+data[index].codeId).attr("checked", "true");
                    }
                });
            }
    }

    function setInputFile(){//인풋파일 세팅하기
        $(".auto_file").append("<label><span class='label_text'><a href='#'>EXCEL UP</a></span><input type='text' class='input_text' readonly='readonly'/></label>");
    }

    function fn_reasonCodeSearch(){
        Common.ajax("GET", "/logistics/adjustment/selectOtherReasonCodeList.do",  {indVal : 'DED_RSN'}, function(result) {
            var temp    = { code : "", codeName : "Choose one" };
            dedRsnList.push(temp);
            otherGiRsnList.push(temp);
            otherGrRsnList.push(temp);
            otherAllRsnList.push(temp);
            comDedRsnList.push(temp);
            for ( var i = 0 ; i < result.length ; i++ ) {
            	if(result[i].ind == 'DED_RSN') {
            		dedRsnList.push(result[i]);
            		comDedRsnList.push(result[i]);
            	} else if(result[i].ind == 'O_GI_RSN') {
            		otherGiRsnList.push(result[i]);
            		otherAllRsnList.push(result[i]);
                }  else if(result[i].ind ==  'O_GR_RSN') {
            		otherGrRsnList.push(result[i]);
            		otherAllRsnList.push(result[i]);
                }
            }
        }, null, {async : false});
    }

    //Serial Scan Search Pop
    function fn_scanSearchPop(){

    	if(Common.checkPlatformType() == "mobile") {
            popupObj = Common.popupWin("serialForm", "/logistics/SerialMgmt/scanSearchPop.do", {width : "1000px", height : "1000px", height : "720", resizable: "no", scrollbars: "yes"});
        } else{
            Common.popupDiv("/logistics/SerialMgmt/scanSearchPop.do", $("#serialForm").serializeJSON(), null, true, '_scanSearchPop');
        }
    }

    function fn_PopSerialClose(){
        if(popupObj!=null) popupObj.close();
        $("#btnPopSearch").click();
    }

    //Serial Search Pop
    function fn_serialSearchPop(){
    	Common.popupWin("frmSearchSerial", "/logistics/SerialMgmt/serialSearchPop.do", {width : "1000px", height : "580", resizable: "no", scrollbars: "no"});
    }

    function fnSerialSearchResult(data) {
        data.forEach(function(dataRow) {
            console.log("serialNo : " + dataRow.serialNo);
        });
    }

    function fn_detailDisplay(yn){
    	var hMain = $("#tbMain").height() ;

    	if(yn == "Y"){
    		//btnCollapse
    		$('#btnCollapse').css("display", "");
    		$('#btnExpand').css("display", "none");
            $('#tbMain').attr("style", "");

            $('#item_grid_wrap_pop').height(330 );
            $('#itemappr_grid_wrap_pop').height(230 );
            $('#itemdet_grid_wrap_pop').height(200 );

        } else{
        	$('#btnCollapse').css("display", "none");
            $('#btnExpand').css("display", "");
    		$('#tbMain').attr("style", "display:none;");

    		$('#item_grid_wrap_pop').height(330 + hMain);
            $('#itemappr_grid_wrap_pop').height(230 + hMain);
            $('#itemdet_grid_wrap_pop').height(200 + hMain);
    	}

    	AUIGrid.resize(itemRegGrid);
        AUIGrid.resize(itemApprGrid);
        AUIGrid.resize(itemDetGrid);

    }
</script>


<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

    <header class="pop_header"><!-- pop_header start -->
        <h1 id="pop_header_title_dtl">New Count-Stock Audit</h1>
        <ul class="right_opt">
            <!-- REG -->
            <c:if test="${action == 'REG'}">
	            <li><p class="btn_blue2 <c:if test="${docInfo.locStusCodeId != '5685' && docInfo.locStusCodeId != '5686' && docInfo.locStusCodeId != '5689' && docInfo.locStusCodeId != '5691' && docInfo.locStusCodeId != '5713'}"> btn_disabled</c:if>"><a id="save">Save</a></p></li>
	            <li><p class="btn_blue2 <c:if test="${docInfo.locStusCodeId != '5685' && docInfo.locStusCodeId != '5686' && docInfo.locStusCodeId != '5689' && docInfo.locStusCodeId != '5691' && docInfo.locStusCodeId != '5713'}"> btn_disabled</c:if>"><a id="requestApproval">Request approval</a></p></li>
            </c:if>
            <!-- APPR -->
            <c:if test="${action == 'APPR'}">
	            <li><p class="btn_blue2 <c:if test="${docInfo.locStusCodeId != '5687'}"> btn_disabled</c:if>"><a id="appsave">Save</a></p></li>
	            <li><p class="btn_blue2 <c:if test="${docInfo.locStusCodeId != '5687'}"> btn_disabled</c:if>"><a id="approve">Approve</a></p></li>
	            <li><p class="btn_blue2 <c:if test="${docInfo.locStusCodeId != '5687'}"> btn_disabled</c:if>"><a id="reject">Reject</a></p></li>
            </c:if>
            <li><p class="btn_blue2"><a href="#" id="popClose"><spring:message code='sys.btn.close'/></a></p></li>
        </ul>
    </header><!-- pop_header end -->

    <section class="pop_body"><!-- pop_body start -->

        <form id="frmSearchSerial" name="frmSearchSerial" method="post">
	        <input id="pGubun" name="pGubun" type="hidden" value="SEARCH" />
	        <input id="pFixdYn" name="pFixdYn" type="hidden" value="N" />
	        <input id="pLocationType" name="pLocationType" type="hidden" value="" />
	        <input id="pLocationCode" name="pLocationCode" type="hidden" value="" />
	        <input id="pItemCodeOrName" name="pItemCodeOrName" type="hidden" value="" />
	        <input id="pStatus" name="pStatus" type="hidden" value="" />
	        <input id="pSerialNo" name="pSerialNo" type="hidden" value="" />
        </form>

        <form id="serialForm" name="serialForm" method="POST">
            <input type="hidden" name="zTrnscType" id="zTrnscType" value="AD" />
            <input type="hidden" name="zRstNo" id="zRstNo" value="${docInfo.stockAuditNo}"/>
            <input type="hidden" name="zFromLoc" id="zFromLoc" value="${docInfo.whLocId}" />
            <input type="hidden" name="zIoType" id="zIoType" value="I"/>
            <input type="hidden" name="pRequestNo" id="pRequestNo" />
            <input type="hidden" name="pRequestItem" id="pRequestItem" />
            <input type="hidden" name="pStatus" id="pStatus" />
        </form>

        <form id="insertForm" name="insertForm" enctype="multipart/form-data">
            <input type="hidden" id="hidStockAuditNo" name="hidStockAuditNo" value="${docInfo.stockAuditNo}">
            <input type="hidden" id="hidWhLocId" name="hidWhLocId" value="${docInfo.whLocId}">
            <input type="hidden" id="pAtchFileGrpId" name="pAtchFileGrpId" />
            <input type="hidden" id="atchFileGrpId" name="atchFileGrpId" value="${docInfo.atchFileGrpId}">
            <input type="hidden" id="updateFileIds" name="updateFileIds" value="">
            <input type="hidden" id="deleteFileIds" name="deleteFileIds" value="">
            <input type="hidden" id="hidLocType" name="hidLocType" value="${docInfo.locType}">
            <input type="hidden" id="hidItmType" name="hidItmType" value="${docInfo.itmType}">
            <input type="hidden" id="hidCtgryType" name="hidCtgryType" value="${docInfo.ctgryType}">
            <input type="hidden" id="hidLocStusCodeId" name="hidLocStusCodeId" value="${docInfo.locStusCodeId}">
            <input type="hidden" id="hidUpdDtTime" name="hidUpdDtTime" value="${docInfo.updDtTime}">
            <img src="${pageContext.request.contextPath}/resources/images/common/btn_up.gif" alt="Collapse" id="btnCollapse" style="position:static;float: right;" onclick="fn_detailDisplay('N')"/>
            <img src="${pageContext.request.contextPath}/resources/images/common/btn_down.gif" alt="Expand" id="btnExpand" style="position:static;float: right;display:none" onclick="fn_detailDisplay('Y')"/>
			  <table class="type1" id="tbMain"><!-- table start -->
				<caption>table</caption>
				<colgroup>
				    <col style="width:150px" />
				    <col style="width:220px" />
				    <col style="width:190px" />
				    <col style="width:100px" />
				    <col style="width:140px" />
                    <col style="width:100px" />
				</colgroup>
				<tbody>
					<tr>
					    <th scope="row"><spring:message code='log.head.stockauditno'/></th>
					    <td>${docInfo.stockAuditNo}</td>
					    <th scope="row"><spring:message code='log.head.locationStatus'/>/<spring:message code='log.head.docStatus'/></th>
					    <td colspan="3">${docInfo.locStusNm} / ${docInfo.docStusNm}</td>
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
                        <td id="dtlEventtypetd"></td>
                        <th scope="row"><spring:message code='log.head.itemtype'/></th>
                        <td colspan="3" id="dtlItemtypetd"></td>
                    </tr>
				    <tr>
			            <th scope="row"><spring:message code='log.head.categoryType'/></th>
                        <td colspan="5" id="dtlCatagorytypetd"></td>
			        </tr>
			        <tr>
	                     <th scope="row"><spring:message code='log.head.stockAuditReason'/></th>
	                     <td colspan="5">${docInfo.stockAuditReason}</td>
	                 </tr>
	                 <tr>
	                     <th scope="row"><spring:message code='log.head.remark'/></th>
	                     <td colspan="5">${docInfo.rem}</td>
	                 </tr>
				</tbody>
			</table>

			<table class="type1"><!-- table start -->
                <caption>table</caption>
                <colgroup>
                    <col style="width:150px"/>
                    <col style="width:*"/>
                    <col style="width:180px" />
                    <col style="width:*" />
                </colgroup>
                <tbody>
                <tr>
                    <th scope="row"><spring:message code='notice.title.AttachedFile'/></th>
                    <td  colspan='3'>
                        <c:if test="${action != 'DET'}">
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
					   <c:if test="${action == 'DET'}">
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
                    <th scope="row"><spring:message code='log.head.createUserDate'/></th>
                    <td>${docInfo.crtUserNm} / ${docInfo.crtDt}</td>
                    <th scope="row"><spring:message code='log.head.modifyUserDate'/></th>
                    <td>${docInfo.updUserNm} / ${docInfo.updDt}</td>
                </tr>
				</tbody>
		  </table><!-- table end -->

          <aside class="title_line" id="APPR_T"  style="display:none"><!-- title_line start -->
                <h1>Approve Information</h1>
            </aside><!-- title_line end -->

		    <table class="type1"  id="APPR_D1"  style="display:none"><!-- table start -->
                <caption>table</caption>
                <colgroup>
                    <col style="width:150px" />
                    <col style="width:*" />
                    <col style="width:180px" />
                    <col style="width:*" />
                </colgroup>
                <tbody>
                     <tr>
                         <th scope="row"><spring:message code='approveView.requester'/></th>
                         <td>${docInfo.appv1ReqstUserNm}</td>
                         <th scope="row"><spring:message code='log.head.requestdate'/></th>
                         <td>${docInfo.appv1ReqstDt}</td>
                     </tr>
                     <tr>
                         <th scope="row"><spring:message code='log.head.1stOpinion'/><span class="must">*</span></th>
                         <td colspan='3'><input type="text" name="appv1Opinion" id="appv1Opinion" value="${docInfo.appv1Opinion}"  class="w100p"/></td>
                     </tr>
                </tbody>
            </table>

            <table class="type1"  id="APPR_D2"  style="display:none"><!-- table start -->
                <caption>table</caption>
                <colgroup>
                    <col style="width:150px" />
                    <col style="width:*" />
                    <col style="width:180px" />
                    <col style="width:*" />
                </colgroup>
                <tbody>
                     <tr>
                         <th scope="row"><spring:message code='approveView.requester'/></th>
                         <td>${docInfo.appv1ReqstUserNm}</td>
                         <th scope="row"><spring:message code='log.head.requestdate'/></th>
                         <td>${docInfo.appv1ReqstDt}</td>
                     </tr>
                     <tr>
                         <th scope="row"><spring:message code='log.head.1stApprover'/></th>
                         <td>${docInfo.appv1UserNm}</td>
                         <th scope="row"><spring:message code='log.head.1stApprovaldate'/></th>
                         <td>${docInfo.appv1Dt}</td>
                     </tr>
                     <tr>
                         <th scope="row"><spring:message code='log.head.1stOpinion'/></th>
                         <td colspan='3'>${docInfo.appv1Opinion}</td>
                     </tr>
                     <tr>
                         <th scope="row"><spring:message code='log.head.2ndApprover'/></th>
                         <td>${docInfo.appv2UserNm}</td>
                         <th scope="row"><spring:message code='log.head.2ndApprovaldate'/></th>
                         <td>${docInfo.appv2Dt}</td>
                     </tr>
                     <tr>
                         <th scope="row"><spring:message code='log.head.2ndOpinion'/></th>
                         <td colspan='3'>${docInfo.appv2Opinion}</td>
                     </tr>
                     <tr>
                         <th scope="row"><spring:message code='log.head.3rdApprover'/></th>
                         <td>${docInfo.appv3UserNm}</td>
                         <th scope="row"><spring:message code='log.head.3rdApprovaldate'/></th>
                         <td>${docInfo.appv3Dt}</td>
                     </tr>
                     <tr>
                         <th scope="row"><spring:message code='log.head.3rdOpinion'/></th>
                         <td colspan='3'>${docInfo.appv3Opinion}</td>
                     </tr>
                </tbody>
            </table>
        </form>

		<section class="search_result" id="REG" style="display:none"><!-- search_result start -->
            <ul class="right_btns">
                <li>
                    <div class="auto_file"><!-- auto_file start -->
                      <input type="file" id="fileSelector" title="file add" accept=".xlsx"/>
                    </div><!-- auto_file end -->
                </li>
                <li><p class="btn_grid"><a href="#" id="excelDownReg"><spring:message code='sys.btn.excel.dw'/></a></p></li>
                <li id="liAllDel" style="display:none;"><p class="btn_grid"><a id="btnAllDel">Clear Serial</a></p></li>
                <li id="liPopSerial" style="display:none;"><p class="btn_grid"><a id="btnPopSerial">Serial Scan</a></p></li>
                <li style="display:none;"><p class="btn_grid"><a id="btnPopSearch">Search</a></p></li>
            </ul>

			<article class="grid_wrap"><!-- grid_wrap start -->
	           <div id="item_grid_wrap_pop" style="width:100%; height:330px; margin:0 auto;"></div>
	        </article><!-- grid_wrap end -->

		</section><!-- search_result end -->

		<section class="search_result" id="APPR" style="display:none"><!-- search_result start -->
            <ul class="right_btns">
                <li><p class="btn_grid"><a href="#" id="excelDownAppr"><spring:message code='sys.btn.excel.dw'/></a></p></li>
            </ul>

            <article class="grid_wrap"><!-- grid_wrap start -->
               <div id="itemappr_grid_wrap_pop" style="width:100%; height:250px; margin:0 auto;"></div>
            </article><!-- grid_wrap end -->

        </section><!-- search_result end -->

        <section class="search_result" id="DET" style="display:none"><!-- search_result start -->
            <ul class="right_btns">
                <li><p class="btn_grid"><a href="#" id="excelDownDet"><spring:message code='sys.btn.excel.dw'/></a></p></li>
            </ul>

            <article class="grid_wrap"><!-- grid_wrap start -->
               <div id="itemdet_grid_wrap_pop" style="width:100%; height:200px; margin:0 auto;"></div>
            </article><!-- grid_wrap end -->

        </section><!-- search_result end -->
    </section><!-- pop_body end -->

</div>
<!-- popup_wrap end -->
