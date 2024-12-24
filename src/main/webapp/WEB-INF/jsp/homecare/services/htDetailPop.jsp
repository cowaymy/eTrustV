<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">
var gSelMainRowIdx = 0;
var gSelMainColIdx = 0;
var myDetailGridID;

// AUIGrid 생성 후 반환 ID
var myDetailGridID;
var unmatchRsnList = [];
var unmatchRsnObj = {};
var productCategory ='${orderDetail.basicInfo.prodCat}';
<c:forEach var="obj" items="${unmatchRsnList}">
unmatchRsnList.push({codeId:"${obj.code}", codeName:"${obj.codeName}", codeNames:"("+"${obj.code}"+")"+"${obj.codeName}"});
unmatchRsnObj["${obj.code}"] = "${obj.codeName}";
</c:forEach>

  //Combo Data
  var StatusTypeData1 = [{"codeId": "4","codeName": "Completed"},{"codeId": "21","codeName": "Failed"},{"codeId": "10","codeName": "Cancelled"}];
  // 19-09-2018 REMOVE HS STATUS "CANCELLED" START FROM 1 OCT 2018
  //var StatusTypeData1 = [{"codeId": "4","codeName": "Completed"},{"codeId": "21","codeName": "Failed"}];

  var option = {
    width : "1000px", // 창 가로 크기
    height : "600px" // 창 세로 크기
  };

  function fn_close(){
    $("#popup_wrap").remove();
  }

  function createAUIGrid(){
	  var columnLayout = [{ dataField:"stkCode",
          headerText:"Filter Code",
          width:130,
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
        }
        , {
          dataField : "serialNo",
          headerText : "Serial No",
          width : 200
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
      }, {
          dataField : "oldSerialNo",
          headerText : "Old Serial No",
          width : 160,
          editable : true
        }, {
            dataField : "filterSerialUnmatchReason",
            headerText : "Unmatched Reason",
            width : 150,
            editRenderer : {
                type : "DropDownListRenderer",
                //showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
                list : unmatchRsnList,
                keyField : "codeId",        // key 에 해당되는 필드명
                valueField : "codeNames"    // value 에 해당되는 필드명
           }
          }, {
              dataField : "sOldSerialNo",
              headerText : "System Old Serial No",
              width : 100,
              visible:false
          }
        ];

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

	  myDetailGridID = AUIGrid.create("#grid_wrap1", columnLayout, gridPros);

	  AUIGrid.bind(myDetailGridID, "cellEditBegin", function (event){
	      if (event.columnIndex == 3 || event.columnIndex == 4 || event.columnIndex == 7 || event.columnIndex == 8){
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


	  AUIGrid.bind(myDetailGridID, "cellEditEnd", function (event){
	      console.log("Event :: " + event.columnIndex);

	      //가용재고 체크 하기
	      if(event.columnIndex == 3) {
	        //마스터 그리드
	        var selectedItems = AUIGrid.getCheckedRowItems(myGridID);
	        console.log("selectedItems :: " + selectedItems);
			debugger;
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

	      if (event.columnIndex == 4) {
	    	  console.log("event.item.name :: " + event.item.name);
	    	  if(event.item.name > 1){
	    		  Common.alert('* This function is not support for this filter currently. (quantity which more than 2 / other reasons).');
	              AUIGrid.setCellValue(myDetailGridID, event.rowIndex, "serialNo", "");
	    	  }else{
	              if(event.item.serialNo != ""){
	                  console.log("event.item.serialNo :: " + event.item.serialNo);
	                  var  codyLoc= ['${orderDetail.codyInfo.ctWhLocId}'];
	                  var codyFilterStatus = ['I'];
	                  Common.ajax("POST", "/logistics/SerialMgmt/serialSearchDataList.do", {searchSerialNo:event.item.serialNo,locCode:codyLoc,searchItemCodeOrName:event.item.stkCode,searchStatus:codyFilterStatus}, function (result) {
	                        if(result.data.length == 0){
	                            Common.alert('* This Serial Not belongs to this cody.');
	                            AUIGrid.setCellValue(myDetailGridID, event.rowIndex, "serialNo", "");
	                        }
	                    });
	              }

	          }
	      }

	      if (event.columnIndex == 7) { //7-old serial number

	    	  console.log("event.item.name :: " + event.item.name);
	          if(event.item.name > 1){
	              Common.alert('* This function is not support for this filter currently. (quantity which more than 2 / other reasons).');
	              AUIGrid.setCellValue(myDetailGridID, event.rowIndex, "oldSerialNo", "");
	          }else{
	        	  var sOldSerialNo = '';
	              if(event.item.sOldSerialNo != undefined){
	                  sOldSerialNo = event.item.sOldSerialNo;
	              }
	              if(sOldSerialNo != event.item.oldSerialNo){
	                  Common.alert('* Old Serial Number for <b>' + event.item.stkDesc + '<br>is not same as previous.</b>');
	                  AUIGrid.setCellValue(myDetailGridID, event.rowIndex, "oldSerialNo", "");
	              }
	          }
	      }

	      if (event.columnIndex == 8) {
	    	  console.log("event.item.name :: " + event.item.name);
	          if(event.item.name > 1){
	              Common.alert('* This function is not support for this filter currently. (quantity which more than 2 / other reasons).');
	              AUIGrid.setCellValue(myDetailGridID, event.rowIndex, "filterSerialUnmatchReason", "");
	          }
	      }
	    });
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

  $(document).ready(function() {
    doDefCombo(StatusTypeData1, '' ,'cmbStatusType1', 'S', '');

    createAUIGrid();
    fn_getHsFilterListAjax();

    $("#lblAppointmentDt").hide();
    $("#lblAppointmentDt2").hide();

    // HS Result Information > HS Status 값 변경 시 다른 정보 입력 가능 여부 설정
    $("#cmbStatusType1").change(function(){
     // AUIGrid.forceEditingComplete(myDetailGridID, null, false);
     // AUIGrid.updateAllToValue(myDetailGridID, "name", '');
     // AUIGrid.updateAllToValue(myDetailGridID, "serialNo", '');

      if ($("#cmbStatusType1").val() == 4) {    // Completed
          $("input[name='settleDate']").attr('disabled', false);
          $("select[name='failReason'] option").remove();

          $("#lblAppointmentDt").show();
          $("#lblAppointmentDt2").show();

      } else if ($("#cmbStatusType1").val() == 21) {    // Failed
          //AUIGrid.updateAllToValue(myDetailGridID, "name", '');
          doGetCombo('/services/bs/selectFailReason.do',  '', '','failReason', 'S' ,  '');
          $('#settleDate').val('');
          $("input[name='settleDate']").attr('disabled', true);

          $("#lblAppointmentDt").hide();
          $("#lblAppointmentDt2").hide();

      } else if ($("#cmbStatusType1").val() == 10) {    // Cancelled
          //AUIGrid.updateAllToValue(myDetailGridID, "name", '');
          doGetCombo('/services/bs/selectFailReason.do',  '', '','failReason', 'S' ,  '');
          $('#settleDate').val('');
          $("input[name='settleDate']").attr('disabled', true);

          $("#lblAppointmentDt").hide();
          $("#lblAppointmentDt2").hide();

      }
    });
  });

  function fn_getOrderDetailListAjax(){
    Common.ajax("GET", "/homecare/sales/htOrderDetailPop.do",{salesOrderId : '${hsDefaultInfo.salesOrdId}'}, function(result) {
      console.log("성공.");
      console.log("fn_getOrderDetailListAjax data :: " + result);
    });
  }

  function fn_getHsFilterListAjax(){
	  	/*
	  	* Currently only load filter for Air Cond orders, other will be ignore
	  	*/
		if(productCategory == "ACI" || productCategory == "ACO" || productCategory == "MC"){
			$('#filter_grid_display').show();
		    Common.ajax("GET", "/services/bs/SelectHsFilterList.do",{salesOrderId : '${hsDefaultInfo.salesOrdId}'}, function(result) {
			      console.log("성공.");
			      console.log("fn_getHsFilterListAjax data :: " + result);
			      AUIGrid.setGridData(myDetailGridID, result);
			});
		}
		else{
			$('#filter_grid_display').hide();
		}
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

    if (FormUtil.checkReqValue($("#cmbStatusType1"))) {
        Common.alert("Please Select CS Status.");
        return false;
    }

     if ($("#cmbStatusType1").val() == 4) {    // Completed
      if ($("#settleDate").val() == '' || $("#settleDate").val() == null) {
        Common.alert("<spring:message code='sys.common.alert.validation' arguments='settleDate Type'/>");
        return false;
      }

      if ($('#nextAppntDate').val() == "") {
     	  Common.alert("<spring:message code='sys.msg.necessary' arguments='Appointment Date' htmlEscape='false' /></br>");
           return false;
       }else{
       	var dateString = $('#nextAppntDate').val();  // Example: "27/12/2024"

       	// Split the date by '/'
       	var dateParts = dateString.split('/');

       	// Rearrange the date parts to "YYYYMMDD" format
       	var formattedDate = dateParts[2] + dateParts[1] + dateParts[0];  // "YYYYMMDD"

       	// Set the formatted date back into the input (if needed)
       	$('#nextAppntDt').val(formattedDate);

       	// Output to console (for debugging)
       	console.log("Formatted date: " + formattedDate);
       }

       if ($('#nextAppntTime').val() == "") {
           Common.alert("<spring:message code='sys.msg.necessary' arguments='Appointment Time' htmlEscape='false' /></br>");
           return false;
       }

       if ($('#nextAppntTime').val() != "") {
       	 var timeString = $('#nextAppntTime').val();

            // Parse the time using JavaScript's Date object
            var timeParts = timeString.match(/(\d+):(\d+)\s(AM|PM)/);
            if (timeParts) {
                var hours = parseInt(timeParts[1]);
                var minutes = parseInt(timeParts[2]);
                var period = timeParts[3];

                // Convert the hours to 24-hour format
                if (period === "PM" && hours !== 12) {
                    hours += 12;
                } else if (period === "AM" && hours === 12) {
                    hours = 0;
                }

                var formattedHours = (hours < 10 ? '0' : '') + hours;
                var formattedMinutes = '00';

           		// Combine hours and minutes into the desired format
           		var result = formattedHours + formattedMinutes;

                // Set the result in the hidden input
                $('#nextAppointmentTime').val(result);
                console.log("Formatted Time: " + result);
       }else {
           Common.alert("Invalid time format. Please enter a valid time.");
           return false;
       	}
     }

      var rsnGridDataList = AUIGrid.getGridData(myDetailGridID);
      var returnParam = true;
      for (var i = 0; i < rsnGridDataList.length; i++) {
          if((rsnGridDataList[i]["name"] != "" && rsnGridDataList[i]["name"] != null) && (rsnGridDataList[i]["serialChk"] == "Y" && $("#hidSerialRequireChkYn").val() == 'Y')){
              if (rsnGridDataList[i]["serialNo"] == null || rsnGridDataList[i]["serialNo"] == "") {
                Common.alert("* Please choose the serial number. ");
                returnParam = false;
                }

              if ((rsnGridDataList[i]["filterSerialUnmatchReason"] == "" || rsnGridDataList[i]["filterSerialUnmatchReason"] == null )
                              && (rsnGridDataList[i]["oldSerialNo"] == null || rsnGridDataList[i]["oldSerialNo"] == "")) {
            Common.alert("* Please choose the unmatched reason for Filter with no old serial number. ");
            returnParam = false;
            }
          }

          if(returnParam == false){
              return returnParam;
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

    }

     var editedRowItems = AUIGrid.getEditedRowItems(myDetailGridID);

     var serialChkCode = new Array();
     var serialChkName = new Array();
     var j = 0;

     for (var i = 0; i < editedRowItems.length; i++) {
       if (parseInt(editedRowItems[i]["name"]) > 0 && (editedRowItems[i]["serialChk"] == "Y" && $("#hidSerialRequireChkYn").val() == 'Y') && (editedRowItems[i]["serialNo"] == null || editedRowItems[i]["serialNo"] == "")) {
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

    var jsonObj = {};
    var resultList = new Array();
    var updIsReturnList = new Array();
    var gridDataList = AUIGrid.getGridData(myDetailGridID);

    console.log("fn_saveHsResult :: gridDataList :: " + gridDataList);
    for(var i = 0; i < gridDataList.length; i++) {
      var item = gridDataList[i];
    	if(item.name > 0) {
    		resultList.push(gridDataList[i]);
    		console.log("added add result filter: " + gridDataList[i].stkDesc);
    	} else if (item.isReturn == 1){
    		updIsReturnList.push(gridDataList[i]);
    		console.log("added upd filter: " + gridDataList[i].stkDesc);
    	}
    }
    console.log("fn_saveHsResult :: resultList :: " + resultList);
    jsonObj.add = resultList;
    console.log("fn_saveHsResult :: resultList :: " + resultList);
    $("input[name='settleDate']").removeAttr('disabled');
    $("select[name=cmbCollectType]").removeAttr('disabled');
    jsonObj.form = $("#addHsForm").serializeJSON();

    if (updIsReturnList != null){
    	jsonObj.update = updIsReturnList;
    }

//Serial Implementation is not needed
//  	// KR-OHK Serial Check add
//     var url = "";
//     if ($("#hidSerialRequireChkYn").val() == 'Y') {
//         url = "/services/bs/addIHsResultSerial.do";
//     } else{
//     	url = "/services/bs/addIHsResult.do";
//     }

    Common.ajax("POST", "/homecare/services/saveValidation.do", jsonObj, function(result) {
        console.log("fn_saveHsResult validation : " + result );

        // result가 0일 때만 저장
        if (result == 0) {
          Common.ajax("POST", "/homecare/services/addIHsResult.do", jsonObj, function(result) {
            //Common.alert(result.message.message);
            console.log("message : " + result.message );
            Common.alert(result.message,fn_parentReload);
          });
        } else {
            Common.alert("There is already Result Number for the CS Order : ${hsDefaultInfo.no}");
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


    } else if ($("#cmbStatusType1").val() == '21') {
      //$("select[name=cmbCollectType]").attr('disabled', 'disabled');
      //$("select[name=failReason]").attr("enabled",true);
      $("select[name=failReason]").attr('disabled',false);
    }
  }

</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

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
 <input type="hidden" id='nextAppointmentTime' name='nextAppointmentTime' />
 <input type="hidden" id='nextAppntDt' name='nextAppntDt' />
 <input type="hidden" value="WEB" id="srcform" name="srcform"/>
<header class="pop_header"><!-- pop_header start -->

<h1>Care Service - New CS Result</h1>
<ul class="right_opt">
    <li><p class="btn_blue2 big"><a href="#" onclick="fn_saveHsResult()">Save</a></p></li>
    <li><p class="btn_blue2 big"><a href="#" onclick="fn_close()">Close</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<aside class="title_line"><!-- title_line start -->
<h2>CS Information</h2>
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
    <th scope="row">CS No</th>
    <td><span><c:out value="${hsDefaultInfo.no}"/></span></td>
    <th scope="row">CS Month</th>
    <td><span><c:out value="${hsDefaultInfo.monthy}"/></span></td>
    <th scope="row">CS Type</th>
    <td><span><c:out value="${hsDefaultInfo.codeName}"/></span></td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2>Care Service Information</h2>
</aside><!-- title_line end -->
<!------------------------------------------------------------------------------
    Order Detail Page Include START
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/homecare/sales/htOrderDetailContent.jsp" %>
<!------------------------------------------------------------------------------
    Order Detail Page Include END
------------------------------------------------------------------------------->
<aside class="title_line mt20"><!-- title_line start -->
<h2>CS Result Information</h2>
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
    <th scope="row">CS Status<span class="must">*</span></th>
    <td>
    <select class="w100p"  id ="cmbStatusType1" name = "cmbStatusType"  onchange="onChangeStatusType(this.value)"" >
    </select>
    </td>
    <th scope="row" style="width: 119px; ">Settle Date</th>
    <td><input type="text" id ="settleDate" name = "settleDate" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" readonly="true" /></td>
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
  <!--   </td>
    <th scope="row">Collection Code</th>
    <td> -->
  <%--   <select class="w100p"  id ="cmbCollectType" name = "cmbCollectType">
        <option value="0" selected>Choose One</option>
            <c:forEach var="list" items="${ cmbCollectTypeComboList}" varStatus="status">
                 <option value="${list.code}">${list.c1 } </option>
            </c:forEach>
    </select> --%>
    </td>
    <th id="lblAppointmentDt" scope="row"><spring:message code='service.title.NextAppointmentDate' /><span class="must">*</span></th>
	<td id="lblAppointmentDt2">
	<input type="text" id ="nextAppntDate" name = "nextAppntDate" value="${toDay}" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p"/>
	 <div class="time_picker">
                  <input type="text" title="" placeholder="" id='nextAppntTime' name='nextAppntTime' class="time_date w100p" />
                  <ul>
                    <li><spring:message code='service.text.timePick' /></li>
                    <c:forEach var="list" items="${timePick}" varStatus="status">
                      <li><a href="#">${list.codeName}</a></li>
                    </c:forEach>
                  </ul>
                </div>
	</td>
</tr>
<tr>

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
    <%--     <th scope="row" style="width: 91px; ">Cancel Request Number</th>
    <td style="width: 242px; ">
        <span><c:out value="${hsDefaultInfo.cancReqNo}"/></span> --%>
    </td>
</tr>
</tbody>
</table>
<!-- table end -->

<div id="filter_grid_display">
	<aside class="title_line"><!-- title_line start -->
	<h2>Filter Information</h2>
	</aside><!-- title_line end -->
	<article class="grid_wrap"><!-- grid_wrap start -->
		 <div id="grid_wrap1" style="width: 100%; height: 334px; margin: 0 auto;"></div>
	</article><!-- grid_wrap end -->
</div>


</section><!-- pop_body end -->
</form>
</div><!-- popup_wrap end -->
