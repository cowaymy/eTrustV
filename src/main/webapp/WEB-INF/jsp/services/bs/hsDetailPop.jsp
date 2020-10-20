<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">
   var gSelMainRowIdx = 0;
   var gSelMainColIdx = 0;

  //Combo Data
  var StatusTypeData1 = [{"codeId": "4","codeName": "Completed"},{"codeId": "21","codeName": "Failed"},{"codeId": "10","codeName": "Cancelled"}];
  // 19-09-2018 REMOVE HS STATUS "CANCELLED" START FROM 1 OCT 2018
  //var StatusTypeData1 = [{"codeId": "4","codeName": "Completed"},{"codeId": "21","codeName": "Failed"}];

  /*  cmbCollectType
      Collection Code
  */

  // AUIGrid 생성 후 반환 ID
  var myDetailGridID;

  //installation checklist- order stock category
  var stkCtgry;
  var stkId1;

  var option = {
    width : "1000px", // 창 가로 크기
    height : "600px" // 창 세로 크기
  };

  function fn_close(){
    $("#popup_wrap").remove();
  }

  function createAUIGrid(){
    // AUIGrid 칼럼 설정
    var columnLayout = [{ dataField:"stkCode",
                          headerText:"Filter Code",
                          width:140,
                          height:30,
                          editable : false
                        }, {
                          dataField : "stkId",
                          headerText : "Filter ID",
                          width : 240,
                          visible:false,
                          editable : false
                        }, {
                          dataField : "stkDesc",
                          headerText : "Filter Name",
                          width : 270,
                          editable : false,
                        }, {
                          dataField : "name",
                          headerText : "Filter Quantity",
                          width : 120,
                          dataType : "numeric",
                          editable : true
                        /*
						  editRenderer : { type : "NumberStepRenderer",
						        	       showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
						                   min : 0,
						                   max : 50,
						                   step : 1,
						                   textEditable : true
						  }*/
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
      showRowNumColumn : true,
      // 수정한 셀에 수정된 표시(마크)를 출력할 지 여부
      showEditedCellMarker : false
    };

    //myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout, gridPros);
    myDetailGridID = AUIGrid.create("#grid_wrap1", columnLayout, gridPros);

    AUIGrid.bind(myDetailGridID, "cellEditBegin", function (event){
      if (event.columnIndex == 3 || event.columnIndex == 4){
        if ($("#cmbStatusType1").val() == 4) {    // Completed
          return true;
        } else if ($("#cmbStatusType1").val() == 21) {    // Failed
          return false;
        } else if ($("#cmbStatusType1").val() == 10) {    // Cancelled
          return false;
        } else {
          return false;
        }
      }
    });

    // 에디팅 정상 종료 이벤트 바인딩
    AUIGrid.bind(myDetailGridID, "cellEditEnd", function (event){
      console.log("Event :: " + event.columnIndex);

      //가용재고 체크 하기
      if(event.columnIndex == 3) {
        //마스터 그리드
        var selectedItems = AUIGrid.getCheckedRowItems(myGridID);
        console.log("selectedItems :: " + selectedItems);

        var ct = selectedItems[0].item.c5;
        var sk = event.item.stkId;

        var stkId1 = event.item.stkId;

        var  availQty =isstckOk(ct ,sk);

        if(availQty == 0) {
          Common.alert('*<b> There are no available stocks.</b>');
          AUIGrid.setCellValue(myDetailGridID, event.rowIndex, "name", "");
        } else {
          if (availQty  <  Number(event.value)){
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
        //if(sk == 1428){
          //var msg = fn_checkStkDuration();
          //if(msg == "NO"){
            //Common.alert('*<b> This Filter not allow to edit.</b>');
            //AUIGrid.setCellValue(myDetailGridID, event.rowIndex, "name", "");
          //}
        //}
      }

      if (event.columnIndex == 6) { // 3-FILTER QUANTITY 4-SERIAL NO 5- HAS RETURN
    	  console.log("event.item.stkId :: " + event.item.stkId);
        if((event.item.stkId) == 1428){
          //var msg = fn_checkStkDuration();
          //console.log("msg :: " + msg);
          //if(msg == "0"){
            //Common.alert('* <b>' + event.item.stkDesc + '<br>currently are not allow to edit.</b>');
            //AUIGrid.setCellValue(myDetailGridID, event.rowIndex, event.dataField, "");
          //}
        } else {
          if (event.columnIndex == 6) {
        	  Common.alert('* <b>' + event.item.stkDesc + '<br>is not applicable for this option.</b>');
        	  AUIGrid.setCellValue(myDetailGridID, event.rowIndex, "isReturn", "0");
          }
        }
      }
    });
  }

  function fn_checkStkDuration(){
    Common.ajaxSync("GET", "/services/bs/checkStkDuration.do",{salesOrderId : '${hsDefaultInfo.salesOrdId}', stkId : 1428 }, function(result) {
      console.log("fn_checkStkDuration :: "+ result.message);
      msg = result.message;
    });
    return msg;
  }

  function fn_chStock(){
    // EMPTY
  }

  function isstckOk(ct , sk){
    var availQty = 0;
	Common.ajaxSync("GET", "/services/as/getSVC_AVAILABLE_INVENTORY.do",{CT_CODE: ct  , STK_CODE: sk }, function(result) {
      console.log("isstckOk.");
	  console.log("isstckOk :: " + result);
	  availQty = result.availQty;
	 });
	 return availQty;
  }

  function createInstallationChkViewAUIGrid() {
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
    }

  $(document).ready(function() {

    doDefCombo(StatusTypeData1, '' ,'cmbStatusType1', 'S', '');
    //order detail
    fn_getOrderDetailListAjax();

    createAUIGrid();
    createInstallationChkViewAUIGrid();
    fn_getHsFilterListAjax();
    fn_viewInstallationChkViewSearch();

    $("#txtInstChkLst").hide();
    $("#grid_wrap_instChk_view").hide();
    $("#instChklstCheckBox").hide();
    $("#instChklstDesc").hide();


    if ($("#cmbStatusType1").val() == 4) {    // Completed
    	$("input[name='settleDate']").attr('disabled', false);
        $("select[name='failReason'] option").remove();

         if(stkCtgry == 54){
        	 if(stkId1 == 1735){
	        $("#txtInstChkLst").show();
	        $("#grid_wrap_instChk_view").show();
	        $("#instChklstCheckBox").show();
	        $("#instChklstDesc").show();
	        }
        	}
  }

    //AUIGrid.setGridData(myGridID, "hsFilterList");
    //createAUIGridCust();
    //fn_getselectPopUpListAjax();

    // HS Result Information > HS Status 값 변경 시 다른 정보 입력 가능 여부 설정
    $("#cmbStatusType1").change(function(){
      AUIGrid.forceEditingComplete(myDetailGridID, null, false);
      AUIGrid.updateAllToValue(myDetailGridID, "name", '');
      AUIGrid.updateAllToValue(myDetailGridID, "serialNo", '');

       $("#txtInstChkLst").hide();
      $("#grid_wrap_instChk_view").hide();
      $("#instChklstCheckBox").hide();
      $("#instChklstDesc").hide();
      $("#instChklstCheckBox").prop("checked", false);

      if ($("#cmbStatusType1").val() == 4) {    // Completed
          $("input[name='settleDate']").attr('disabled', false);
          $("select[name='failReason'] option").remove();
          //doGetCombo('/services/bs/selectCollectType.do',  '', '','cmbCollectType', 'S' ,  '');
          //$("select[name=cmbCollectType]").attr('disabled', false);
           if(stkCtgry == 54){
        	    if (stkId1 == 1735 ){
              $("#txtInstChkLst").show();
              $("#grid_wrap_instChk_view").show();
              $("#instChklstCheckBox").show();
              $("#instChklstDesc").show();
        	    }
          }
      } else if ($("#cmbStatusType1").val() == 21) {    // Failed
          //AUIGrid.updateAllToValue(myDetailGridID, "name", '');
          doGetCombo('/services/bs/selectFailReason.do',  '', '','failReason', 'S' ,  '');
          $('#settleDate').val('');
          $("input[name='settleDate']").attr('disabled', true);
          //$("select[name='cmbCollectType'] option").remove();
          //$("select[name=cmbCollectType]").attr('disabled', true);
      } else if ($("#cmbStatusType1").val() == 10) {    // Cancelled
          //AUIGrid.updateAllToValue(myDetailGridID, "name", '');
          doGetCombo('/services/bs/selectFailReason.do',  '', '','failReason', 'S' ,  '');
          $('#settleDate').val('');
          $("input[name='settleDate']").attr('disabled', true);
          //$("select[name='cmbCollectType'] option").remove();
          //$("select[name=cmbCollectType]").attr('disabled', true);
      }
    });

    // KR-OHK Serial Check
    if( $("#hidSerialRequireChkYn").val() == 'Y' ) {
        $("#btnSerialEdit").attr("style", "");
    }

    // Added for displaying instruction remarks. By Hui Ding, 2020-10-09
    document.getElementById("instruction").value = $("#srvRem").val();

  });

    function fn_viewInstallationChkViewSearch() {
	   Common.ajax("GET", "/services/bs/instChkLst.do", "",
	        function(result) {
	          AUIGrid.setGridData(instChkLst_view, result);
	        });
   }

  function fn_getHsFilterListAjax(){
    Common.ajax("GET", "/services/bs/SelectHsFilterList.do",{salesOrderId : '${hsDefaultInfo.salesOrdId}'}, function(result) {
      console.log("성공.");
      console.log("fn_getHsFilterListAjax data :: " + result);
      AUIGrid.setGridData(myDetailGridID, result);
    });
  }


  function fn_getOrderDetailListAjax(){
    Common.ajax("GET", "/sales/order/orderDetailPop.do",{salesOrderId : '${hsDefaultInfo.salesOrdId}'}, function(result) {
      console.log("성공.");
      console.log("fn_getOrderDetailListAjax data :: " + result);

      //Installation Checklist - Get the stock category id
      stkCtgry = "${orderDetail.basicInfo.stkCtgryId}";
      stkId1 = "${orderDetail.basicInfo.stockId}";
      console.log ("prod_code :::" + stkId1);
      console.log ("stkCtgry :::" + stkCtgry);

    });
  }

  function fn_saveHsResult(){
    /* var dat =  GridCommon.getEditData(myGridID);
       dat.form = $("#addHsForm").serializeJSON();

       Common.ajax("POST", "/bs/addIHsResult.do",  dat.form, function(result) {
         Common.alert(result.message.message);
         console.log("성공.");
         console.log("data : " + result);
       });
    */

    console.log("instruction: " + $("#instruction").val());
    // KR-OHK Serial Check
    if (FormUtil.checkReqValue($("#cmbStatusType1"))) {
      Common.alert("Please Select HS Status.");
      return false;
    }

    if ($("#cmbStatusType1").val() == 4) {    // Completed
      if ($("#settleDate").val() == '' || $("#settleDate").val() == null) {
        Common.alert("<spring:message code='sys.common.alert.validation' arguments='settleDate Type'/>");
        return false;
      }
      if ($("#cmbCollectType").val() == '' || $("#cmbCollectType").val() == null) {
        Common.alert("Please Select 'Collection Code'");
        return false;
      }
      // KR-OHK Serial Check
      if ($("#hidSerialRequireChkYn").val() == 'Y' && FormUtil.checkReqValue($("#stockSerialNo"))) {
        Common.alert("Please insert Serial No.");
        return false;
      }

     //Installation checklist
        if(stkCtgry == 54){
        	if(stkId1 == 1735 ){
         if (!$("#instChklstCheckBox").prop('checked')) {
            Common.alert("* <spring:message code='sys.msg.tickCheckBox' arguments='Installation Checklist' htmlEscape='false'/>");
            return false;
            }
        	}
       }

    } else if ($("#cmbStatusType1").val() == 21) {    // Failed
      if ($("#failReason").val() == '' || $("#failReason").val() == null) {
        Common.alert("Please Select 'Fail Reason'.");
        return false;
      }
    } else if ($("#cmbStatusType1").val() == 10) {    // Cancelled
      if ($("#failReason").val() == '' || $("#failReason").val() == null) {
        Common.alert("Please Select 'Fail Reason'.");
        return false;
      }
      /* if (<c:out value="${hsDefaultInfo.cancReqNo}"/> == "" || <c:out value="${hsDefaultInfo.cancReqNo}"/> == null) {
           Common.alert("Can’t entry without Cancel Request Number");
           return false;
         } */
    }

    /* if("" == $("#remark").val() || null == $("#remark").val()){
         Common.alert("<spring:message code='sys.common.alert.validation' arguments='remark Type'/>");
         return false;
        }

        if("" == $("#instruction").val() || null == $("#instruction").val()){
            Common.alert("<spring:message code='sys.common.alert.validation' arguments='instruction Type'/>");
            return false;
        }
    */

    /* if("" == $("#srvBsWeek").val() || null == $("#srvBsWeek").val()){
         Common.alert("<spring:message code='sys.common.alert.validation' arguments='Week Type'/>");
         return false;
       }  */

    // 시리얼넘버체크
    //수정된 행 아이템들(배열)
    var editedRowItems = AUIGrid.getEditedRowItems(myDetailGridID);

    var serialChkCode = new Array();
    var serialChkName = new Array();
    var j = 0;

    for (var i = 0; i < editedRowItems.length; i++) {
      if (parseInt(editedRowItems[i]["name"]) > 0 && editedRowItems[i]["serialChk"] == "Y" && (editedRowItems[i]["serialNo"] == null || editedRowItems[i]["serialNo"] == "")) {
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

    // var jsonObj =  GridCommon.getEditData(myDetailGridID);
    // add by jgkim
    var jsonObj = {};
    var resultList = new Array();
    var gridDataList = AUIGrid.getGridData(myDetailGridID);
    //var gridDataList = AUIGrid.getOrgGridData(myDetailGridID);
    //var gridDataList = AUIGrid.getEditedRowItems(myDetailGridID);
    console.log("fn_saveHsResult :: gridDataList :: " + gridDataList);
    for(var i = 0; i < gridDataList.length; i++) {
      var item = gridDataList[i];
    	//if(item.name > 0) { // remove this to allow customer discontinue mineral filter (not renew case) by Hui Ding, 2020-10-20
    		resultList.push(gridDataList[i]);
    	//}
    }
    console.log("fn_saveHsResult :: resultList :: " + resultList);
    jsonObj.add = resultList;
    $("input[name='settleDate']").removeAttr('disabled');
    $("select[name=cmbCollectType]").removeAttr('disabled');
    jsonObj.form = $("#addHsForm").serializeJSON();
    //$("input[name='settleDate']").attr('disabled', true);
    //$("select[name=cmbCollectType]").attr('disabled', true);
    console.log("fn_saveHsResult :: jsonObj ::" + jsonObj);

    // KR-OHK Serial Check add
    var url = "";
    if ($("#hidSerialRequireChkYn").val() == 'Y') {
        url = "/services/bs/addIHsResultSerial.do";
    } else{
    	url = "/services/bs/addIHsResult.do";
    }

    Common.ajax("POST", "/services/bs/saveValidation.do", jsonObj, function(result) {
        // result가 0일 때만 저장
        if (result == 0) {
          Common.ajax("POST", url, jsonObj, function(result) {
            //Common.alert(result.message.message);
            console.log("message : " + result.message );
            Common.alert(result.message,fn_parentReload);
          });
        } else {
            Common.alert("There is already Result Number for the HS Order : ${hsDefaultInfo.no}");
            return false;
        }
    });
  }

  function fn_close(){
    $("#popup_wrap").remove();
  }

  function fn_parentReload() {
    fn_close();
    fn_getBSListAjax(); //parent Method (Reload)
  }

  //var StatusTypeData1 = [{"codeId": "4","codeName": "Completed"},{"codeId": "21","codeName": "Failed"},{"codeId": "10","codeName": "Cancelled"}];

  function onChangeStatusType(val){
    if($("#cmbStatusType1").val() == '4'){
      $("select[name=failReason]").attr('disabled', 'disabled');
      //$("select[name=cmbCollectType]").attr("disabled ",true);
      $("select[name=cmbCollectType]").attr('disabled',false);

      /* $("select[name=cmbCorpTypeId]").removeClass("w100p disabled");
      $("select[name=cmbCorpTypeId]").addClass("w100p");
      $("#cmbCorpTypeId").val('1173');
      $("#cmbNation").val('');
      $("select[name=cmbNation]").addClass("w100p disabled");
      $("select[name=cmbNation]").attr('disabled', 'disabled');
      $("#cmbRace").val('');
      $("select[name=cmbRace]").addClass("w100p disabled");
      $("select[name=cmbRace]").attr('disabled', 'disabled');
      $("#dob").val('');
      // $("select[name=dob]").attr('readonly','readonly');
      $("#dob").attr({'disabled' : 'disabled' , 'class' : 'j_date3 w100p'});
      $("#genderForm").attr('disabled',true);
      $("input:radio[name='gender']:radio[value='M']").prop("checked", false);
      $("input:radio[name='gender']:radio[value='F']").prop("checked", false);
      $("input:radio[name='gender']").attr("disabled" , "disabled");
      $("#genderForm").attr('checked', false); */
    } else if ($("#cmbStatusType1").val() == '21') {
      //$("select[name=cmbCollectType]").attr('disabled', 'disabled');
      //$("select[name=failReason]").attr("enabled",true);
      $("select[name=failReason]").attr('disabled',false);
    }
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

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->
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
<form action="#" id="addHsForm" method="post">
 <input type="hidden" value="${hsDefaultInfo.schdulId}" id="hidschdulId" name="hidschdulId"/>
 <input type="hidden" value="${hsDefaultInfo.salesOrdId}" id="hidSalesOrdId" name="hidSalesOrdId"/>
 <input type="hidden" value="${hsDefaultInfo.codyId}" id="hidCodyId" name="hidCodyId"/>
 <input type="hidden" value="${hsDefaultInfo.no}" id="hidSalesOrdCd" name="hidSalesOrdCd"/>
 <input type="hidden" value="${orderDetail.basicInfo.stockCode}" id="hidStockCode" name="hidStockCode"/>
 <input type="hidden" value="${orderDetail.basicInfo.ordNo}" id="hidSalesOrdNo" name="hidSalesOrdNo"/>
 <input type="hidden" value="${orderDetail.codyInfo.serialRequireChkYn}" id="hidSerialRequireChkYn" name="hidSerialRequireChkYn" />
 <input type="hidden" id='hidStockSerialNo' name='hidStockSerialNo' />
 <input type="hidden" value="${hsDefaultInfo.srvRem}" id="srvRem" name="hidSrvRem"/>
<header class="pop_header"><!-- pop_header start -->

<h1>HS - New HS Result</h1>
<ul class="right_opt">
    <li><p class="btn_blue2 big"><a href="#" onclick="fn_saveHsResult()">Save</a></p></li>
    <li><p class="btn_blue2 big"><a href="#" onclick="fn_close()">Close</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

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
    <td><span><c:out value="${hsDefaultInfo.no}"/></span></td>
    <th scope="row">HS Month</th>
    <td><span><c:out value="${hsDefaultInfo.monthy}"/></span></td>
    <th scope="row">HS Type</th>
    <td><span><c:out value="${hsDefaultInfo.codeName}"/></span></td>
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
<aside class="title_line mt20"><!-- title_line start -->
<h2>HS Result Information</h2>
</aside><!-- title_line end -->
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:160px" />
    <col style="width:380px" />
    <col style="width:170px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">HS Status<span class="must">*</span></th>
    <td>
    <select class="w100p"  id ="cmbStatusType1" name = "cmbStatusType"  onchange="onChangeStatusType(this.value)"" >
    </select>
    </td>
    <th scope="row" style="width: 119px; ">Settle Date</th>
    <td>
<!--      <input type="text" id ="settleDate" name = "settleDate" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p"  readonly="true"/>
  -->      <input type="text" id ="settleDate" name = "settleDate" value="${toDay}" title="Create start Date" placeholder="DD/MM/YYYY" class="readonly" readonly />

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
        <option value="" selected>Choose One</option>
            <c:forEach var="list" items="${failReasonList}" varStatus="status">
                 <option value="${list.codeId}">${list.codeName } </option>
            </c:forEach>
    </select>
    </td>
    <th scope="row">Collection Code</th>
    <td>
    <select class="w100p"  id ="cmbCollectType" name = "cmbCollectType">
        <option value="0" selected>Choose One</option>
            <c:forEach var="list" items="${ cmbCollectTypeComboList}" varStatus="status">
                 <option value="${list.code}">${list.c1 } </option>
            </c:forEach>
    </select>
    </td>
</tr>
<tr>
<%--     <th scope="row">Service Member</th>
    <td>
    <select class="w100p" id ="serMemList" name = "serMemList">
         <option value="" selected>Choose One</option>
            <c:forEach var="list" items="${ serMemList}" varStatus="status">
                 <option value="${list.CodeId}">${list.codeName } </option>
            </c:forEach>
    </select>
    </td>
    <th scope="row">Warehouse</th>
    <td>
    <select class="w100p" id ="wareHouse" name ="wareHouse" >

    </select>
    </td>
</tr>
<tr> --%>
    <th scope="row" style="width: 68px; ">Remark</th>
    <td style="width: 468px; "><textarea cols="20" rows="5" id ="remark" name = "remark"></textarea></td>
    <th scope="row" style="width: 94px; ">Instruction</th>
    <td style="width: 216px; "><textarea cols="20" rows="5"id ="instruction" name = "instruction"></textarea></td>
</tr>
<tr>
    <th scope="row" style="width: 65px; ">Prefer Service Week</th>
    <td colspan="1">
    <label><input type="radio" name="srvBsWeek"  value="0"/><span>None</span></label>
    <label><input type="radio" name="srvBsWeek"  value="1"/><span>Week 1</span></label>
    <label><input type="radio" name="srvBsWeek"  value="2"/><span>Week 2</span></label>
    <label><input type="radio" name="srvBsWeek"  value="3"/><span>Week 3</span></label>
    <label><input type="radio" name="srvBsWeek"  value="4"/><span>Week 4</span></label>
    </td>
        <th scope="row" style="width: 91px; ">Cancel Request Number</th>
    <td style="width: 242px; ">
        <span><c:out value="${hsDefaultInfo.cancReqNo}"/></span>
    </td>
</tr>
</tbody>
</table>
<!-- table end -->
 <!-- Installation Checklist  -->
 <aside class="title_line">
    <h2 id="txtInstChkLst" name="txtInstChkLst">
      <spring:message code='service.text.instChkLst' />
    </h2>
</aside>
<article class="grid_wrap">
    <!--  <div id="grid_wrap_instChk_view" style="width: 100%; height: 170px; margin: 90 auto;" class="hide"></div>  -->
       <div id="grid_wrap_instChk_view" style="width: 100%; height: 170px; margin: 90 auto;" ></div>
</article>
 <tr>
  <td colspan="8">
    <label><input type="checkbox" id="instChklstCheckBox" name="instChklstCheckBox" value="Y" class="hide" /><span id="instChklstDesc" name="instChklstDesc" class="hide"><spring:message code='service.btn.instChklst' /> </span></label>
  </td>
</tr>

<aside class="title_line"><!-- title_line start -->
<h2>Filter Information</h2>
</aside><!-- title_line end -->
<article class="grid_wrap"><!-- grid_wrap start -->
	 <div id="grid_wrap1" style="width: 100%; height: 334px; margin: 0 auto;"></div>

<!-- 	 <ul class="center_btns">
	    <li><p class="btn_blue2 big"><a href="#" onclick="fn_saveHsResult()">Save</a></p></li>
	    <li><p class="btn_blue2 big"><a href="#">Close</a></p></li>
    </ul> -->
</article><!-- grid_wrap end -->



</section><!-- pop_body end -->
</form>
</div><!-- popup_wrap end -->
