<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">

var gSelMainRowIdx = 0;
var gSelMainColIdx = 0;

// add by jgkim
var myDetailGridData = null;
  //Combo Data
  var StatusTypeData1 = [{"codeId": "4","codeName": "Completed"},{"codeId": "21","codeName": "Failed"},{"codeId": "10","codeName": "Cancelled"}];
  // 19-09-2018 REMOVE HS STATUS "CANCELLED" START FROM 1 OCT 2018
  //var StatusTypeData2 = [{"codeId": "4","codeName": "Completed"},{"codeId": "21","codeName": "Failed"}];

  /* cmbCollectType
      Collection Code */

  //installation checklist- order stock category
   //var stkCtgry;

  // AUIGrid 생성 후 반환 ID
  var myDetailGridID;
  var myDetailGridID2;
  var myDetailGridID3;

  var option = {
    width : "1000px", // 창 가로 크기
    height : "600px" // 창 세로 크기
  };

  function createAUIGrid(){
    // AUIGrid 칼럼 설정
    var columnLayout = [ {
                           dataField:"stkCode",
                           headerText:"Filter Code",
                           width:140,
                           height:30
                         }, {
                           dataField : "stkId",
                           headerText : "Filter id",
                           width : 240,
                           visible:false
                         }, {
                           dataField : "stkDesc",
                           headerText : "Filter Name",
                           width : 240
                         }, {
                           dataField : "bsResultItmId",
                           headerText : "Filter Name",
                           width : 240    ,
                           visible:false
                         }, {
                           dataField : "name",
                           headerText : "Filter Quantity",
                           width : 120,
                           dataType : "numeric",
                           /* editRenderer : {
                                                type : "NumberStepRenderer",
                                                min : 0,
                                                max : 50,
                                                step : 1,
                                                textEditable : true
                           }  */
                         }, {
                             dataField : "serialNo",
                             headerText : "Serial No",
                             width : 240
                             <c:if test="${orderDetail.codyInfo.serialRequireChkYn == 'Y' }">
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
	                                  gSelMainRowIdx = rowIndex;
	                                  gSelMainColIdx = columnIndex;

	                                  fn_serialSearchPop(item);
	                              }
	                           }
	                        </c:if>
                         }, {
                             dataField : "serialChk",
                             headerText : "Serial Check",
                             width : 100,
                             visible:false
                         }, {
                             dataField : "isReturn",
                             headerText : "Has Return",
                             width : 100,
                             renderer : {
                                        type : "CheckBoxEditRenderer",
                                        showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
                                        editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
                                        checkValue : "1", // true, false 인 경우가 기본
                                        unCheckValue : "0"
                             }
                         }];

    // 그리드 속성 설정
    var gridPros = {  // 페이징 사용
                  	  //usePaging : true,
                 	  // 한 화면에 출력되는 행 개수 20(기본값:20)
                	  //pageRowCount : 20,
                	  editable : true,
                	  //showStateColumn : true,
                	  //displayTreeOpen : true,
	                  headerHeight : 30,
	                  // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
	                  skipReadonlyColumns : true,
	                  // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
	                  wrapSelectionMove : true,
	                  // 줄번호 칼럼 렌더러 출력
	                  showRowNumColumn : true,
	                  // 수정한 셀에 수정된 표시(마크)를 출력할 지 여부
	                  showEditedCellMarker : false
           	       };

    //myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout, gridPros);
    myDetailGridID = AUIGrid.create("#grid_wrap1", columnLayout, gridPros);

    AUIGrid.bind(myDetailGridID, "cellEditBegin", function (event){
	  if (event.columnIndex == 4 || event.columnIndex == 5){
        if ($("#cmbStatusType2").val() == 4) {    // Completed
          return true;
        } else if ($("#cmbStatusType2").val() == 21) {    // Failed
          return false;
        } else if ($("#cmbStatusType2").val() == 10) {    // Cancelled
          return false;
        } else {
          return false;
        }
      }
    });

    // 에디팅 정상 종료 이벤트 바인딩
    AUIGrid.bind(myDetailGridID, "cellEditEnd", function (event) {
      console.log("createAUIGrid :: event :: " + event.columnIndex);

     //가용재고 체크 하기
     if(event.columnIndex == 4) {
       //마스터 그리드
        var selectedItem = AUIGrid.getItemByRowIndex(myGridID, '${ROW}');
        console.log("createAUIGrid :: selectedItem :: " + selectedItem);

  	    var ct = selectedItem.c5;
        var sk = event.item.stkId;

        var  availQty = isstckOk(ct ,sk);

        if(availQty == 0) {
          Common.alert('*<b> There are no available stocks.</b>');
          AUIGrid.setCellValue(myDetailGridID, event.rowIndex, "name", "");
        } else {
          if  ( availQty  <  Number(event.value) ){
            Common.alert('*<b> Not enough available stock to the member.  <br> availQty['+ availQty +'] </b>');
            AUIGrid.setCellValue(myDetailGridID, event.rowIndex, "name", "");
           }
        }

        // KR-OHK Serial Check add
        var serialChk = event.item.serialChk;
        var serialNo = event.item.serialNo;

        if($("#hidSerialRequireChkYn").val()  == 'Y' && serialChk == 'Y' && Number(event.value) > 1) {
            Common.alert("For serial check items, only quantity 1 can be entered.");
            AUIGrid.setCellValue(myDetailGridID, event.rowIndex, "name", "1");
            return false;
        }

        // CHECK MINERAL FILTER - NOT ALLOW TO EDIT -- TPY
        if(sk == 1428){
          Common.alert('*<b> This Filter not allow to edit.</b>');
          AUIGrid.setCellValue(myDetailGridID, event.rowIndex, "name", "");
        }
      }

      /*if (event.columnIndex == 7) {
        console.log("createAUIGrid :: event.item.stkId :: " + event.item.stkId);
        if((event.item.stkId) == 1428){
          Common.alert('* <b>' + event.item.stkDesc + '<br>is not allow to edit.</b>');
          AUIGrid.setCellValue(myDetailGridID, event.rowIndex, event.dataField, "");
        }
      }*/
    });
  }

  function createAUIGrid2(){
    // AUIGrid 칼럼 설정
    var resultColumnLayout = [ {
                                dataField:"resultIsCurr",
			                    headerText:"Version",
			                    width:100,
			                    height:30
			                   }, {
			                    dataField : "no",
			                    headerText : "BSR No",
			                    width : 140
			                   }, {
			                    dataField : "code",
			                    headerText : "Status",
			                    width : 140
			                   }, {
			                    dataField : "memCode",
			                    headerText : "Member",
			                    width : 140
			                   }, {
			                    dataField : "setlDt",
			                    headerText : "Settle Date",
			                    width : 140 ,
			                    dataType : "date",
			                    formatString : "dd/mm/yyyy"
			                   }, {
			                    dataField : "resultStockUse",
			                    headerText : "Has Filter",
			                    width : 140
			                   }, {
			                    dataField : "resultCrtDt",
			                    headerText : "Key At",
			                    width : 140,
			                    dataType : "date",
			                    formatString : "dd/mm/yyyy"
			                   }, {
			                    dataField : "userName",
			                    headerText : "Key By",
			                    width : 140
			                   }, {
			                    dataField : "resultId",
			                    headerText : "result_id",
			                    width : 140,
			                    visible:false
			                   }, {
                                dataField : "undefined",
		                        headerText : "View",
		                        width : 170,
		                        renderer : {
			                                 type : "ButtonRenderer",
			                                 labelText : "View",
		                                     onclick : function(rowIndex, columnIndex, value, item) {

                                               if(item.code == "ACT") {
                                                 Common.alert('Not able to EDIT for the HS order status in Active.');
                                                 return false;
                                               }

											   /* $("#_schdulId").val(item.schdulId);
											      $("#_salesOrdId").val(item.salesOrdId);
											      $("#_openGb").val("edit");
											      $("#_brnchId").val(item.brnchId);
											   */

                                               var aaa = AUIGrid.getCellValue(myDetailGridID2, rowIndex,"resultId");
                                               $("#MresultId").val(AUIGrid.getCellValue(myDetailGridID2, rowIndex,"resultId"));
                                               Common.popupDiv("/services/bs/hSMgtResultViewResultPop.do", $("#viewHSResultForm").serializeJSON());

                                             }
                                }
                               }];

    // 그리드 속성 설정
    var gridPros = {
      // 페이징 사용
      //usePaging : true,
      // 한 화면에 출력되는 행 개수 20(기본값:20)
      //pageRowCount : 20,
      editable : false,
      //showStateColumn : true,
      //displayTreeOpen : true,
      headerHeight : 30,
      // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
      skipReadonlyColumns : true,
      // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
      wrapSelectionMove : true,
      // 줄번호 칼럼 렌더러 출력
      showRowNumColumn : true

    };

    //myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout, gridPros);
    myDetailGridID2 = GridCommon.createAUIGrid("hsResult_grid_wrap", resultColumnLayout,'', gridPros);
  }

  function createAUIGrid3(){
    // AUIGrid 칼럼 설정
    var fitercolumnLayout = [ {
                               dataField:"no",
                               headerText:"BSR No",
                               width:200,
                               height:30
                              }, {
		                       dataField : "stkDesc",
		                       headerText : "Filter",
		                       width : 140
		                      }, {
		                       dataField : "bsResultPartQty",
		                       headerText : "Qty",
		                       width : 90
		                      }, {
		                       dataField : "bsResultFilterClm",
		                       headerText : "Claim",
		                       width : 240
		                      }, {
		                       dataField : "resultCrtDt",
		                       headerText : "Key At",
		                       width : 240 ,
		                       dataType : "date",
		                       formatString : "dd/mm/yyyy"
		                      }, {
		                       dataField : "userName",
		                       headerText : "Key By",
		                       width : 240

                           }];

    // 그리드 속성 설정
    var gridPros = {
                    // 페이징 사용
                    //usePaging : true,
                    // 한 화면에 출력되는 행 개수 20(기본값:20)
                    //pageRowCount : 20,
                    editable : true,
                    //showStateColumn : true,
                    //displayTreeOpen : true,
                    headerHeight : 30,
                    // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
                    skipReadonlyColumns : true,
                    // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
                    wrapSelectionMove : true,
                    // 줄번호 칼럼 렌더러 출력
                    showRowNumColumn : true
    };

    //myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout, gridPros);
    myDetailGridID3 = GridCommon.createAUIGrid("fiter_grid_wrap", fitercolumnLayout, '',gridPros);
  }

  /*function createInstallationChkViewAUIGrid() {
      var columnLayout = [  {
        dataField : "codeDesc",
        //headerText : "Status",
        headerText : '<spring:message code="service.grid.chkLst" />',
        editable : false,
        width : 870
      } ];

      var gridPros = {
        //usePaging : true,
        pageRowCount : 20,
        editable : true,
        //showStateColumn : true,
        displayTreeOpen : true,
        headerHeight : 30,
        skipReadonlyColumns : true,
        wrapSelectionMove : true,
        showRowNumColumn : true,
        height : 165
      };
       instChkLst_view = AUIGrid.create("#grid_wrap_instChk_view", columnLayout, gridPros);
    }*/

  $(document).ready(function() {
    // var mthYr = "${basicinfo.monthy}";
	// var mth = mthYr.substring(0, mthYr.indexOf("/"));
	// var yr = mthYr.substring(mthYr.indexOf("/") + 1, mthYr.length);
	// if (yr <= 2018 && mth <= 9) { // HS PERIOD BEFORE OCT 1 CAN HAVE CANCELLED STATUS
	  // doDefCombo(StatusTypeData1, '' ,'cmbStatusType2', 'S', '');
	// } else { // HS PERIOD AFTER SEP 30 REMOVE CANCELLED STATUS
	  // doDefCombo(StatusTypeData2, '' ,'cmbStatusType2', 'S', '');
	// }

	doDefCombo(StatusTypeData1, '' ,'cmbStatusType2', 'S', '');

    selSchdulId = $("#hidschdulId").val(); // TypeId
    selSalesOrdId = $("#hidSalesOrdId").val(); // TypeId
    openGb = $("#openGb").val(); // TypeId
    brnchId = $("#brnchId").val(); // TypeId
    hidHsno = $("#hidHsno").val(); // TypeId
    hrResultId = $("#hrResultId").val(); // TypeId

    createAUIGrid();
    createAUIGrid2();
    createAUIGrid3();
    //createInstallationChkViewAUIGrid();

    fn_getHsViewfilterInfoAjax();
    //fn_viewInstallationChkViewSearch();

 // KR-OHK Serial Check
    if( $("#hidSerialRequireChkYn").val() == 'Y' ) {
        $("#btnSerialEdit").attr("style", "");
    }

    var statusCd = "${basicinfo.stusCodeId}";
    $("#cmbStatusType2 option[value='"+ statusCd +"']").attr("selected", true);

    var failResnCd = "${basicinfo.failResnId}";
    //alert("fail reason : " + failResnCd);
    if (failResnCd != "0"){
      $("#failReason option[value='"+ failResnCd +"']").attr("selected", true);
      //$("#failReason option[value='60']").attr("selected", true);
    } else {
      $("#failReason").find("option").remove();
    }

    var codyIdCd = "${basicinfo.codyId}";
    $("#cmbServiceMem option[value='"+codyIdCd +"']").attr("selected", true);

    var renColctCd = "${basicinfo.renColctId}";
    /* if(renColctCd != "0" ){
         $("#cmbCollectType option[value='"+renColctCd +"']").attr("selected", true);
       } else {
         $("#cmbCollectType").find("option").remove();
       } */
    $("#cmbCollectType option[value='"+renColctCd +"']").attr("selected", true);
    if ($("#_openGb").val() == "view"){
      $("#btnSave").hide();
    }

    if ('${MOD}' =="VIEW") {
      $("#stitle").text("HS - Result View")	;
      $("#editHSResultForm").find("input, textarea, button, select").attr("disabled",true);
    } else {
      $("#stitle").text("HS - Result EDIT")  ;

      if ($("#stusCode").val()==4) {
        $("#editHSResultForm").find("input, textarea, button, select").attr("disabled",false);
        $('#cmbCollectType').removeAttr('disabled');
      }
    }

    //Installation checklist - stock category
 /*    stkCtgry = "${orderDetail.basicInfo.stkCtgryId}";
    $("#txtInstChkLst").hide();
    $("#grid_wrap_instChk_view").hide();
    $("#instChklstCheckBox").hide();
    $("#instChklstDesc").hide();
    $("#instChklstCheckBox").prop("checked", false); */

    // HS Result Information > HS Status 값에 따라 다른 정보 입력 가능 여부 설정
    if ($("#cmbStatusType2").val() == 4) {    // Completed
      $("input[name='settleDt']").attr('disabled', true);
      $("select[name='failReason'] option").remove();
      //doGetCombo('/services/bs/selectCollectType.do',  '', '','cmbCollectType', 'S' ,  '');
      //$("select[name=cmbCollectType]").attr('disabled', false);

      //Installation checklist
     /*  if(stkCtgry == 54){
    	  $("#txtInstChkLst").show();
          $("#grid_wrap_instChk_view").show();
          $("#instChklstCheckBox").show();
          $("#instChklstDesc").show();

         if('${basicinfo.hsChklist}'=='Y'){
        	  $("#instChklstCheckBox").prop("checked", true);
         }
         else {
        	 $("#instChklstCheckBox").prop("checked", false);
         }
      } */
   } else if ($("#cmbStatusType2").val() == 21) {    // Failed
        //AUIGrid.updateAllToValue(myDetailGridID, "name", '');
        //doGetCombo('/services/bs/selectFailReason.do',  '', '','failReason', 'S' ,  '');
        $('#settleDt').val('');
        $("input[name='settleDt']").attr('disabled', true);
        //$("select[name='cmbCollectType'] option").remove();
        //$("select[name=cmbCollectType]").attr('disabled', true);
     } else if ($("#cmbStatusType2").val() == 10) {    // Cancelled
        //AUIGrid.updateAllToValue(myDetailGridID, "name", '');
        //doGetCombo('/services/bs/selectFailReason.do',  '', '','failReason', 'S' ,  '');
        $('#settleDt').val('');
        $("input[name='settleDt']").attr('disabled', true);
        //$("select[name='cmbCollectType'] option").remove();
        //$("select[name=cmbCollectType]").attr('disabled', true);
     }

     $("#cmbStatusType2").change(function(){

       AUIGrid.forceEditingComplete(myDetailGridID, null, false);
       AUIGrid.updateAllToValue(myDetailGridID, "name", '');
       AUIGrid.updateAllToValue(myDetailGridID, "serialNo", '');

       //Installation checklist
     /*   $("#txtInstChkLst").hide();
       $("#grid_wrap_instChk_view").hide();
       $("#instChklstCheckBox").hide();
       $("#instChklstDesc").hide();
       $("#instChklstCheckBox").prop("checked", false); */

       if ($("#cmbStatusType2").val() == 4) {    // Completed
    	   $('#settleDt').val('${toDay}');
         $("input[name='settleDt']").attr('disabled', true);
         $("select[name='failReason'] option").remove();
         //doGetCombo('/services/bs/selectCollectType.do',  '', '','cmbCollectType', 'S' ,  '');
         //$("select[name=cmbCollectType]").attr('disabled', false);

         //Installation checklist
        /*  if(stkCtgry == 54){
        	 $("#txtInstChkLst").show();
             $("#grid_wrap_instChk_view").show();
             $("#instChklstCheckBox").show();
             $("#instChklstDesc").show();
         } */
       } else if ($("#cmbStatusType2").val() == 21) {    // Failed
         //AUIGrid.updateAllToValue(myDetailGridID, "name", '');
         doGetCombo('/services/bs/selectFailReason.do',  '', '','failReason', 'S' ,  '');
         $('#settleDt').val('');
         $("input[name='settleDt']").attr('disabled', true);
         //$("select[name='cmbCollectType'] option").remove();
         //$("select[name=cmbCollectType]").attr('disabled', true);
       } else if ($("#cmbStatusType2").val() == 10) {    // Cancelled
         //AUIGrid.updateAllToValue(myDetailGridID, "name", '');
         doGetCombo('/services/bs/selectFailReason.do',  '', '','failReason', 'S' ,  '');
         $('#settleDt').val('');
         $("input[name='settleDt']").attr('disabled', true);
         //$("select[name='cmbCollectType'] option").remove();
         //$("select[name=cmbCollectType]").attr('disabled', true);
       }
     });
  });

  function fn_getHsViewfilterInfoAjax(){
    Common.ajax("GET", "/services/bs/selectHsViewfilterPop.do",{selSchdulId : selSchdulId}, function(result) {
      console.log("성공 fn_getHsViewfilterInfoAjax.");
      console.log("data : " + result);

      AUIGrid.setGridData(myDetailGridID, result);

      // Grid 안의 값이 음수 또는 0인 경우 빈칸으로 출력
      var cnt = result.length;
      for (var i=0; i<cnt; i++) {
        var qtyCheck = AUIGrid.getCellValue(myDetailGridID, i, "name");
        if (qtyCheck < 0) {
          AUIGrid.updateRow(myDetailGridID, { name : "" }, i, false);
        } else if (qtyCheck == 0) {
          AUIGrid.updateRow(myDetailGridID, { name : "" }, i, false);
        }
      }
      myDetailGridData = result;
    });

    Common.ajax("GET", "/services/bs/selectHistoryHSResult.do",{selSchdulId : selSchdulId}, function(result) {
      console.log("성공 selectHistoryHSResult.");
      console.log("data : " + result);
      AUIGrid.setGridData(myDetailGridID2, result);
    });

    Common.ajax("GET", "/services/bs/selectFilterTransaction.do",{selSchdulId : selSchdulId}, function(result) {
      console.log("성공 selectFilterTransaction.");
      console.log("data : " + result);
      AUIGrid.setGridData(myDetailGridID3, result);
    });
  }

  function fn_getOrderDetailListAjax(){
    Common.ajax("GET", "/sales/order/orderDetailPop.do",{salesOrderId : 'selSalesOrdId'}, function(result) {
      console.log("성공.");
      console.log("data : " + result);
    });
  }

  //Installation checklist
/*   function fn_viewInstallationChkViewSearch() {
      Common.ajax("GET", "/services/bs/instChkLst.do", "",
          function(result) {
            AUIGrid.setGridData(instChkLst_view, result);
          });
 }
 */
  function fn_UpdateHsResult(){
    if($("#cmbStatusType2").val() == null || $("#cmbStatusType2").val() == '' ) {
      Common.alert("Please Select 'HS Status' ");
      return false;
    }

    if ($("#cmbStatusType2").val() == 4) {    // Completed
      if ($("#settleDt").val() == '' || $("#settleDt").val() == null) {
        Common.alert("<spring:message code='sys.common.alert.validation' arguments='settleDate Type'/>");
        return false;
      }
      if ($("#cmbCollectType").val() == '' || $("#cmbCollectType").val() == null) {
        Common.alert("Please Select 'Collection Code'");
        return false;
      }

      //Installation checklist
    /*   if(stkCtgry == 54){
        if (!$("#instChklstCheckBox").prop('checked')) {
           Common.alert("* <spring:message code='sys.msg.tickCheckBox' arguments='Installation Checklist' htmlEscape='false'/>");
           return false;
         }
      } */
    } else if ($("#cmbStatusType2").val() == 21) {    // Failed
      if ($("#failReason").val() == '' || $("#failReason").val() == null) {
        Common.alert("Please Select 'Fail Reason'.");
        return false;
      }
    } else if ($("#cmbStatusType2").val() == 10) {    // Cancelled
      if ($("#failReason").val() == '' || $("#failReason").val() == null) {
        Common.alert("Please Select 'Fail Reason'.");
        return false;
      }
      /* if (<c:out value="${basicinfo.cancReqNo}"/> == "" || <c:out value="${basicinfo.cancReqNo}"/> == null) {
        Common.alert("Can’t entry without Cancel Request Number");
        return false;
      } */
    }

    /* if ($("#cmbStatusType2").val() == 21) {    // Failed
         if ($("#failReason").val() == '') {
           Common.alert("Please Select 'Fail Reason'.");
           return false;
         }
       } else if ($("#cmbStatusType2").val() == 10) {    // Cancelled
         if ($("#failReason").val() == '') {
           Common.alert("Please Select 'Fail Reason'.");
           return false;
         }
       } */

    // 시리얼넘버체크
    //수정된 행 아이템들(배열)
    var editedRowItems = AUIGrid.getEditedRowItems(myDetailGridID);

    var serialChkCode = new Array();
    var serialChkName = new Array();
    var j = 0;
    for (var i = 0; i < editedRowItems.length; i++) {
      if (parseInt(editedRowItems[i]["name"]) > 0 && editedRowItems[i]["serialChk"] == "Y" && (editedRowItems[i]["serialNo"] == null || editedRowItems[i]["serialNo"] == "") ) {
        serialChkCode[j] = editedRowItems[i]["stkCode"];
        serialChkName[j] = editedRowItems[i]["stkDesc"];
        j++;
      }
    }

    var serialChkList = "";
    if (serialChkCode.length > 0) {
      for (var i = 0; i < serialChkCode.length; i++) {
        serialChkList = serialChkList + "<br/>" + serialChkCode[i] + " - " + serialChkName[i];
      }
      Common.alert("Please insert 'Serial No' for" + serialChkList);
      return false;
    }

    var resultList = new Array();
    $("#cmbCollectType1").val(editHSResultForm.cmbCollectType.value);
    var jsonObj =  GridCommon.getEditData(myDetailGridID);
    var gridDataList = AUIGrid.getGridData(myDetailGridID);
    //var gridDataList = AUIGrid.getOrgGridData(myDetailGridID);
    //var gridDataList = AUIGrid.getEditedRowItems(myDetailGridID);
    console.log("fn_UpdateHsResult :: gridDataList ::" + gridDataList);
    for(var i = 0; i < gridDataList.length; i++) {
      var item = gridDataList[i];
      if(item.name > 0) {
        resultList.push(gridDataList[i]);
      }
    }
    jsonObj.add = resultList;

    // add by jgkim
    var cmbStatusType2 = $("#cmbStatusType2").val();
    $("input[name='settleDt']").removeAttr('disabled');
    //$("select[name=cmbCollectType]").removeAttr('disabled');
    var form = $("#editHSResultForm").serializeJSON();
    //$("input[name='settleDt']").attr('disabled', true);
    //$("select[name=cmbCollectType]").attr('disabled', true);
    form.cmbStatusType2 = cmbStatusType2;

    //Installation checklist
    //form.instChklstCheckBox = $("#instChklstCheckBox").val();

    jsonObj.form = form;
    console.log("fn_UpdateHsResult :: jsonObj :: " + jsonObj);

    // KR-MIN Serial Check add
    var url = "";
    if ($("#hidSerialRequireChkYn").val() == 'Y') {
        url = "/services/bs/UpdateHsResult2Serial.do";
    } else{
    	url = "/services/bs/UpdateHsResult2.do";
    }

    Common.ajax("POST", url, jsonObj, function(result) {
      Common.alert(result.message, fn_parentReload);
      $("#popClose").click();
    });
  }

  function fn_parentReload() {
    fn_getBSListAjax(); //parent Method (Reload)
  }

  //resize func (tab click)
  function fn_resizefunc(obj, gridName){
    var $this = $(obj);
    var width = $this.width();

    AUIGrid.resize(gridName, width, 200);
    // AUIGrid.resize(gridName, width, height);

    // setTimeout(function(){
    // AUIGrid.resize(gridName);
    // }, 100);
  }

  function isstckOk(ct , sk){
    var availQty = 0;
    Common.ajaxSync("GET", "/services/as/getSVC_AVAILABLE_INVENTORY.do",{CT_CODE: ct  , STK_CODE: sk }, function(result) {
      console.log("isstckOk.");
      console.log(result);
      availQty = result.availQty;
    });
    return availQty;
  }

  function fn_serialModifyPop(){
      $("#serialNoChangeForm #pSerialNo").val( $("#stockSerialNo").val() ); // Serial No
      $("#serialNoChangeForm #pSalesOrdId").val( $("#hidSalesOrdId").val() ); // 주문 ID
      $("#serialNoChangeForm #pSalesOrdNo").val( $("#hidSalesOrdNo").val() ); // 주문 번호
      $("#serialNoChangeForm #pRefDocNo").val( $("#hidSalesOrdCd").val() ); //
      $("#serialNoChangeForm #pItmCode").val( $("#hidStockCode").val()  ); // 제품 ID
      $("#serialNoChangeForm #pCallGbn").val( "HS" );
      $("#serialNoChangeForm #pMobileYn").val( "N"  );

      if(Common.checkPlatformType() == "mobile") {
          popupObj = Common.popupWin("serialNoChangeForm", "/logistics/serialChange/serialNoChangePop.do", {width : "1000px", height : "1000px", height : "720", resizable: "no", scrollbars: "yes"});
      } else{
          Common.popupDiv("/logistics/serialChange/serialNoChangePop.do", $("#serialNoChangeForm").serializeJSON(), null, true, '_serialNoChangePop');
      }
  }

  function fn_PopSerialChangeClose(obj){

      console.log("++++ obj.asIsSerialNo ::" + obj.asIsSerialNo +", obj.beforeSerialNo ::"+ obj.beforeSerialNo);

      $("#stockSerialNo").val(obj.asIsSerialNo);
      $("#hidStockSerialNo").val(obj.beforeSerialNo);

      if(popupObj!=null) popupObj.close();
      //fn_viewInstallResultSearch(); //조회
  }

//팝업에서 호출하는 조회 함수
function SearchListAjax(obj){

    console.log("++++ obj.asIsSerialNo ::" + obj.asIsSerialNo +", obj.beforeSerialNo ::"+ obj.beforeSerialNo);

    $("#stockSerialNo").val(obj.asIsSerialNo);
    $("#hidStockSerialNo").val(obj.beforeSerialNo);

    //fn_viewInstallResultSearch(); //조회
}

  function fn_serialSearchPop(item){

	    $("#pLocationType").val('${orderDetail.codyInfo.whLocGb}');
	    $('#pLocationCode').val('${orderDetail.codyInfo.ctWhLocId}');
	    $("#pItemCodeOrName").val(item.stkCode);

	    if (FormUtil.isEmpty(item.stkCode)) {
	        var text = "<spring:message code='service.grid.FilterCode'/>";
	        var rtnMsg = "* <spring:message code='sys.msg.necessary' arguments='" + text + "' htmlEscape='false'/> </br>";
	        Common.alert(rtnMsg);
	        return false;
	    }

	    Common.popupWin("frmSearchSerial", "/logistics/SerialMgmt/serialSearchPop.do", {width : "1000px", height : "580", resizable: "no", scrollbars: "no"});
	}

	function fnSerialSearchResult(data) {
	    data.forEach(function(dataRow) {
	        AUIGrid.setCellValue(myDetailGridID, gSelMainRowIdx, gSelMainColIdx, dataRow.serialNo);
	        console.log("serialNo : " + dataRow.serialNo);
	    });
	}

</script>

<div id="popup_Editwrap" class="popup_wrap"><!-- popup_wrap start -->
<form id="serialNoChangeForm" name="serialNoChangeForm" method="POST">
  <input type="hidden" name="pSerialNo" id="pSerialNo"/>
  <input type="hidden" name="pSalesOrdId"  id="pSalesOrdId"/>
  <input type="hidden" name="pSalesOrdNo"  id="pSalesOrdNo"/>
  <input type="hidden" name="pRefDocNo" id="pRefDocNo"/>
  <input type="hidden" name="pItmCode" id="pItmCode"/>
  <input type="hidden" name="pCallGbn" id="pCallGbn"/>
  <input type="hidden" name="pMobileYn" id="pMobileYn"/>
</form>
<form id="frmSearchSerial" name="frmSearchSerial" method="post">
     <input id="pGubun" name="pGubun" type="hidden" value="RADIO" />
     <input id="pFixdYn" name="pFixdYn" type="hidden" value="N" />
     <input id="pLocationType" name="pLocationType" type="hidden" value="" />
     <input id="pLocationCode" name="pLocationCode" type="hidden" value="" />
     <input id="pItemCodeOrName" name="pItemCodeOrName" type="hidden" value="" />
     <input id="pStatus" name="pStatus" type="hidden" value="" />
     <input id="pSerialNo" name="pSerialNo" type="hidden" value="" />
</form>
<header class="pop_header"><!-- pop_header start -->

<h1>  <spin id='stitle'>  </spin></h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#"  id="btnSave" name="btnSave" onclick="fn_UpdateHsResult()">SAVE</a></p></li>
    <li><p class="btn_blue2"><a href="#" id="popClose">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
<form action="#" id="viewHSResultForm" method="post">
    <input type="hidden" name="MresultId" id="MresultId"/>
<aside class="title_line"><!-- title_line start -->
<h2>HS Information</h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:90px" />
    <col style="width:*" />
    <col style="width:110px" />
    <col style="width:*" />
    <col style="width:110px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">HS No</th>
    <td><span><c:out value="${basicinfo.no}"/></span></td>
    <th scope="row">HS Month</th>
    <td><span><c:out value="${basicinfo.monthy}"/></span></td>
    <th scope="row">HS Type</th>
    <td colspan="3"><span><c:out value="${basicinfo.codeName}"/></span></td>
</tr>
<tr>
    <th scope="row">Current BSR No</th>
    <td><span><c:out value="${basicinfo.c1}"/></span></td>
    <th scope="row">Prev HS Area</th>
    <td><span><c:out value="${basicinfo.prevSvcArea}"/></span></td>
    <th scope="row">Next HS Area</th>
    <td><span><c:out value="${basicinfo.nextSvcArea}"/></span></td>
     <th scope="row">Distance</th>
    <td><span><c:out value="${basicinfo.distance}"/></span></td>
</tr>

</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2>Order Information</h2>
</aside><!-- title_line end -->
<!------------------------------------------------------------------------------
    Order Detail Page Include START
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/sales/order/orderDetailContent.jsp" %>
<!------------------------------------------------------------------------------
    Order Detail Page Include END
------------------------------------------------------------------------------->

<article class="acodi_wrap"><!-- acodi_wrap start -->
<dl>
    <dt class="click_add_on"><a href="#" onclick="javascript: fn_resizefunc(this, myDetailGridID2)">Current & History HS Result</a></dt>
    <dd>
        <article class="grid_wrap"><!-- grid_wrap start -->
             <div id="hsResult_grid_wrap" style="width:100%; height:210px; margin:0 auto;"></div>
        </article><!-- grid_wrap end -->
    </dd>
    <dt class="click_add_on"><a href="#" onclick="javascript: fn_resizefunc(this, myDetailGridID3)">Filter Transaction</a></dt>
    <dd>
        <article class="grid_wrap"><!-- grid_wrap start -->
         <div id="fiter_grid_wrap" style="width: 100%; height: 210px; margin: 0 auto;"></div>
        </article><!-- grid_wrap end -->
    </dd>
</dl>
</article><!-- acodi_wrap end -->

<form action="#" id="editHSResultForm" method="post">
<aside class="title_line mt20"><!-- title_line start -->
<h2>HS Result Information</h2>
</aside><!-- title_line end -->
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:350px;" />
    <col style="width:170px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">HS Status<span class="must">*</span></th>
    <td>
    <select class="w100p"  id ="cmbStatusType2" name = "cmbStatusType2"></select>
    </td>
    <th scope="row" style="width: 186px; ">Settle Date</th>
    <td>
        <%-- <span><c:out value="${basicinfo.setlDt}"/></span> --%>
<%--         <input type="text" title="Settle Date" placeholder="DD/MM/YYYY" class="j_date w100p" id="settleDt" name="settleDt" value="${basicinfo.setlDt}" readonly="true"/>
 --%>
         <input type="text" title="Settle Date" placeholder="DD/MM/YYYY" id="settleDt" name="settleDt" value="${basicinfo.setlDt}" class="readonly" readonly/>

 </td>
</tr>
<tr>
    <th scope="row"><spring:message code='service.title.SerialNo' /><span class="must">*</span></th>
    <td colspan="3">
      <input type="text" id='stockSerialNo' name='stockSerialNo' value="${orderDetail.basicInfo.lastSerialNo}" class="readonly" readonly/>
      <p class="btn_grid" style="display:none" id="btnSerialEdit"><a href="#" onClick="fn_serialModifyPop()">EDIT</a></p>
    </td>
</tr>
<tr>
    <th scope="row">Fail Reason</th>
    <td>
    <select class="w100p" id ="failReason"  name ="failReason">
        <option>Choose One</option>
       <c:forEach var="list" items="${failReasonList}" varStatus="status">
             <option value="${list.codeId}">${list.codeName } </option>
        </c:forEach>
    </select>
    </td>
    <th scope="row" style="width: 244px; ">Collection Code<span class="must">*</span></th>
    <td>
    <select class="w100p"  id ="cmbCollectType" name = "cmbCollectType">
        <option value="0" selected>Choose One</option>
            <c:forEach var="list" items="${cmbCollectTypeComboList}" varStatus="status">
                 <option value="${list.code}">${list.c1 } </option>
            </c:forEach>
    </select>
    </td>
</tr>
<%-- <tr>
    <th scope="row">Service Member</th>
    <td>
    <select class="w100p" id ="cmbServiceMem" name = "cmbServiceMem">
       <c:forEach var="list" items="${ serMemList}" varStatus="status">
            <option value="${list.codeId}">${list.codeName } </option>
       </c:forEach>
    </select>
    </td>
    <th scope="row">Warehouse</th>
    <td>
    <select class="w100p" id ="wareHouse" name ="wareHouse">

    </select>
    </td>
</tr> --%>
<tr>
    <th scope="row" style="width: 176px; ">Remark</th>
    <td>
        <input id="txtRemark" name="txtRemark"  type="text" title="" placeholder="Remark" class="w100p" value="${basicinfo.resultRem}"/>
        <%-- <span>${basicinfo.resultRem}</span> --%>
    </td>
    <th scope="row" style="width: 59px; ">Instruction</th>
    <td>
        <input id="txtInstruction" name="txtInstruction"  type="text" title="" placeholder="Instruction" class="w100p" value="${basicinfo.instct}"/>
        <%-- <span>${settleInfo.configBsRem}</span> --%>
    </td>
</tr>
<tr>
    <th scope="row">Prefer Service Week</th>
    <td colspan="1">
    <label><input type="radio" name="srvBsWeek" <c:if test="${basicinfo.srvBsWeek == 0 || orderDetail.orderCfgInfo.configBsWeek > 4}">checked</c:if> disabled/><span>None</span></label>
    <label><input type="radio" name="srvBsWeek" <c:if test="${basicinfo.srvBsWeek == 1}">checked</c:if> /><span>Week1</span></label>
    <label><input type="radio" name="srvBsWeek" <c:if test="${basicinfo.srvBsWeek == 2}">checked</c:if> /><span>Week2</span></label>
    <label><input type="radio" name="srvBsWeek" <c:if test="${basicinfo.srvBsWeek == 3}">checked</c:if> /><span>Week3</span></label>
    <label><input type="radio" name="srvBsWeek" <c:if test="${basicinfo.srvBsWeek == 4}">checked</c:if> /><span>Week4</span></label>

 <%--    <label><input type="radio" name="srvBsWeek" <c:if test="${basicinfo.srvBsWeek == 4}">checked</c:if> disabled/><span>Week4</span></label> --%>
    </td>
        <th scope="row" style="width: 186px; ">Cancel Request Number</th>
    <td>
        <input id="txtCancelRN" name="txtCancelRN"  type="text" title="" placeholder="N/A" class="w100p" value="${basicinfo.cancReqNo}"  readonly />
        <%-- <span><c:out value="${basicinfo.cancReqNo}"/></span>  --%>
    </td>
</tr>
</tbody>
</table><!-- table end -->
<!-- Installation Checklist -->
<!--<aside class="title_line">
    <h2 id="txtInstChkLst" name="txtInstChkLst">
      <spring:message code='service.text.instChkLst' />
    </h2>
</aside>
 <article class="grid_wrap">
      <div id="grid_wrap_instChk_view" style="width: 100%; height: 170px; margin: 90 auto;" class="hide"></div>
       <div id="grid_wrap_instChk_view" style="width: 100%; height: 170px; margin: 90 auto;" ></div>
</article> -->
<%-- <tr>
  <td colspan="8">
    <label><input type="checkbox" id="instChklstCheckBox" name="instChklstCheckBox" value="Y" class="hide" /><span id="instChklstDesc" name="instChklstDesc" class="hide"><spring:message code='service.btn.instChklst' /> </span></label>
  </td>
</tr> --%>

<aside class="title_line"><!-- title_line start -->
<h2>Filter Information</h2>
</aside><!-- title_line end -->
<article class="grid_wrap"><!-- grid_wrap start -->
	 <div id="grid_wrap1" style="width: 100%; height: 334px; margin: 0 auto;"></div>
</article><!-- grid_wrap end -->
<ul class="center_btns">

<!--     <li><p class="btn_blue2 big"><a href="#" id="_close" onclick="javascript: fn_closeFunc()">Close</a></p></li> -->
<!--     <li><p class="btn_blue2 big"><a href="#">Close</a></p></li> -->
</ul>

 <div  style="display:none">

 <input type="text" value="${basicinfo.schdulId}" id="hidschdulId" name="hidschdulId"/>
 <input type="text" value="${basicinfo.salesOrdId}" id="hidSalesOrdId" name="hidSalesOrdId"/>
 <input type="text" value="${basicinfo.no}" id="hidHsno" name="hidHsno"/>
 <input type="text" value="${basicinfo.c2}" id="hrResultId" name="hrResultId"/>
 <input type="text" value="${basicinfo.srvBsWeek}" id="srvBsWeek" name="srvBsWeek"/>
 <input type="text" value="${basicinfo.codyId}" id="cmbServiceMem" name="cmbServiceMem"/>
 <input type="hidden" value="${orderDetail.basicInfo.stockCode}" id="hidStockCode" name="hidStockCode"/>
 <input type="hidden" value="${orderDetail.basicInfo.ordNo}" id="hidSalesOrdNo" name="hidSalesOrdNo"/>
 <input type="hidden" value="${basicinfo.no}" id="hidSalesOrdCd" name="hidSalesOrdCd"/>

 <input type="text" value="<c:out value="${basicinfo.stusCodeId}"/> "  id="stusCode" name="stusCode"/>
 <input type="text" value="<c:out value="${basicinfo.failResnId}"/> "  id="failResn" name="failResn"/>
 <input type="text" value="<c:out value="${basicinfo.renColctId}"/> "  id="renColct" name="renColct"/>
 <input type="text" value="<c:out value="${basicinfo.codyId}"/> "  id="codyId" name="codyId"/>
 <input type="text" value="<c:out value="${basicinfo.setlDt}"/> "  id="setlDt" name="setlDt"/>
 <input type="text" value="<c:out value="${basicinfo.configBsRem}"/> "  id="configBsRem" name="configBsRem"/>
 <input type="text" value="<c:out value="${basicinfo.instct}"/> "  id="Instruction" name="Instruction"/>
 <input type="text" value=""  id="cmbCollectType1" name="cmbCollectType1"/>

 <input type="hidden" value="${orderDetail.codyInfo.serialRequireChkYn}" id="hidSerialRequireChkYn" name="hidSerialRequireChkYn" />
 <input type="hidden" id='hidStockSerialNo' name='hidStockSerialNo' />

 </div>

</form>


</section><!-- pop_body end -->
</div><!-- popup_wrap end -->
