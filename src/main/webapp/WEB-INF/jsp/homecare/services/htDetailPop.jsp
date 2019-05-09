<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">

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

  $(document).ready(function() {
    doDefCombo(StatusTypeData1, '' ,'cmbStatusType1', 'S', '');

    // HS Result Information > HS Status 값 변경 시 다른 정보 입력 가능 여부 설정
    $("#cmbStatusType1").change(function(){
     // AUIGrid.forceEditingComplete(myDetailGridID, null, false);
     // AUIGrid.updateAllToValue(myDetailGridID, "name", '');
     // AUIGrid.updateAllToValue(myDetailGridID, "serialNo", '');

      if ($("#cmbStatusType1").val() == 4) {    // Completed
          $("input[name='settleDate']").attr('disabled', false);
          $("select[name='failReason'] option").remove();

      } else if ($("#cmbStatusType1").val() == 21) {    // Failed
          //AUIGrid.updateAllToValue(myDetailGridID, "name", '');
          doGetCombo('/services/bs/selectFailReason.do',  '', '','failReason', 'S' ,  '');
          $('#settleDate').val('');
          $("input[name='settleDate']").attr('disabled', true);

      } else if ($("#cmbStatusType1").val() == 10) {    // Cancelled
          //AUIGrid.updateAllToValue(myDetailGridID, "name", '');
          doGetCombo('/services/bs/selectFailReason.do',  '', '','failReason', 'S' ,  '');
          $('#settleDate').val('');
          $("input[name='settleDate']").attr('disabled', true);

      }
    });
  });

  function fn_getOrderDetailListAjax(){
    Common.ajax("GET", "/homecare/sales/htOrderDetailPop.do",{salesOrderId : '${hsDefaultInfo.salesOrdId}'}, function(result) {
      console.log("성공.");
      console.log("fn_getOrderDetailListAjax data :: " + result);
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

    if ($("#cmbStatusType1").val() == 4) {    // Completed
      if ($("#settleDate").val() == '' || $("#settleDate").val() == null) {
        Common.alert("<spring:message code='sys.common.alert.validation' arguments='settleDate Type'/>");
        return false;
      }
  /*     if ($("#cmbCollectType").val() == '' || $("#cmbCollectType").val() == null) {
        Common.alert("Please Select 'Collection Code'");
        return false;
      } */
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

    var jsonObj = {};
    //console.log("fn_saveHsResult :: resultList :: " + resultList);
   // jsonObj.add = resultList;
    $("input[name='settleDate']").removeAttr('disabled');
    $("select[name=cmbCollectType]").removeAttr('disabled');
    jsonObj.form = $("#addHsForm").serializeJSON();
    //$("input[name='settleDate']").attr('disabled', true);
    //$("select[name=cmbCollectType]").attr('disabled', true);
    console.log("fn_saveHsResult :: jsonObj ::" + jsonObj);

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

  <aside class="title_line">
<!-- <h2>Filter Information</h2> -->
</aside>



</section><!-- pop_body end -->
</form>
</div><!-- popup_wrap end -->
