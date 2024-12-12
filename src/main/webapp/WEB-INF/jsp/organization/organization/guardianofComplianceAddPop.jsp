<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript">
  var myGridID_order;
  var complianceList;
  var asMalfuncResnId;
  $(document).ready(function() {

    //doGetComboCodeId('/common/selectReasonCodeList.do', {typeId : 1389, inputId : 1, separator : '-'}, '', 'caseCategory', 'S'); //Reason Code
    //CodeId('/common/selectReasonCodeList.do', {typeId : 1390, inputId : 1, separator : '-'}, '', 'docType', 'S'); //Reason Code
    /*
     $("#caseCategory").change(function(){

     alert($(this).val());

     if($("#caseCategory").val() == '2144' ){
     $("select[name=docType]").removeAttr("disabled");
     $("select[name=docType]").removeClass("w100p disabled");
     $("select[name=docType]").addClass("w100p");
     }else{
     $("#docType").val("");
     $("select[name=docType]").attr('disabled', 'disabled');
     $("select[name=docType]").addClass("disabled");
     //$("select[name=docType]").addClass("w100p");
     }

     }); */

	  fn_caseChange();

  });

  $(function() {
    $('#orderId').change(function(event) {
      fn_selectOrderInfo();
    });

    $('#reqstMemId').change(function(event) {
      fn_selectMemInfo();
    });

    $('#ordBtn').click(function() {
      //Common.searchpopupWin("searchForm", "/common/customerPop.do","");
      Common.popupDiv("/sales/order/orderSearchPop.do", {
        callPrgm : "BILLING_ADD_NEW_GROUP"
      });
    });

    $('#memBtn').click(function() {
      //Common.searchpopupWin("searchForm", "/common/memberPop.do","");
      Common.popupDiv("/common/memberPop.do", {callPrgm : "MEM_NO_STAT"}, null, true);
    });

  });

  function fn_orderInfo(ordNo, ordId) {
    loadOrderInfo(ordNo, ordId);
  }

  function loadOrderInfo(ordNo, ordId) {
    Common.ajax("GET", "/organization/compliance/selectOrderJsonList", {
      ordNo : ordNo
    }, function(result) {
      if (result != null && result.length == 1) {
        var orderInfo = result[0];

        $("#searchOrderId").val(orderInfo.ordId);
        $("#orderId").val(orderInfo.ordNo);
        $("#custName").val(orderInfo.custName);
        $("#orderId2").val(orderInfo.comboOrdNo);
        $("#reqstCntnt").val(orderInfo.telM1);

      } else {
        Common.alert("Order not found");
      }
    });
  }

  function fn_loadOrderSalesman(memId, memCode) {

    console.log('fn_loadOrderSalesman memId:' + memId);
    console.log('fn_loadOrderSalesman memCd:' + memCode);
    Common.ajax("GET", "/sales/order/selectMemberByMemberIDCode.do", {
      memId : memId,
      memCode : memCode,
      stus : ""
    }, function(memInfo) {

      if (memInfo == null) {
        //          Common.alert('<b>Member not found.</br>Your input member code : '+memCode+'</b>');
        Common.alert('<spring:message code="sal.alert.msg.memNotFoundInput" arguments="'+memCode+'"/>');
      } else {
        $('#memberId').val(memInfo.memId);
        $('#reqstMemId').val(memInfo.memCode);
        $("#memTypeId").val(memInfo.memType);

      }
    });
  }

  function fn_selectOrderInfo() {
    var strOrderId = $('#orderId').val();

    if (FormUtil.isNotEmpty(strOrderId) && strOrderId > 0) {
      fn_loadOrder(strOrderId);
    } else {
      Common.alert('<b>Invalid Order No.</b>');
    }
  }

  function fn_selectMemInfo() {
    var strMemberId = $('#reqstMemId').val();

    if (FormUtil.isNotEmpty(strMemberId) || strMemberId > 0) {
      fn_loadMember(strMemberId);
    } else {
      Common.alert('<b>Invalid Member Code.</b>');
    }
  }

  function fn_loadOrder(orderId) {
    //    $("#searchOrderId").val(orderId);
    Common.ajax("GET", "/organization/compliance/selectOrderJsonList", {
      ordNo : orderId
    }, function(result) {

      if (result != null && result.length == 1) {

        var orderInfo = result[0];

        $("#searchOrderId").val(orderInfo.ordId);
        $("#orderId").val(orderInfo.ordNo);
        $("#custName").val(orderInfo.custName);
        $("#orderId2").val(orderInfo.comboOrdNo);
        $("#reqstCntnt").val(orderInfo.telM1);

      } else {
        //          Common.alert('<b>Customer not found.<br>Your input customer ID :'+$("#searchCustId").val()+'</b>');
        Common.alert('Order not found');
      }
    });
  }

  function fn_loadMember(memId) {
    //  $("#searchOrderId").val(orderId);
    Common.ajax("GET", "/sales/order/selectMemberByMemberIDCode.do", {
      memCode : memId,
      stus : ""
    }, function(memInfo) {

      if (memInfo == null) {
        //           Common.alert('<b>Member not found.</br>Your input member code : '+memCode+'</b>');
        Common.alert('<spring:message code="sal.alert.msg.memNotFoundInput" arguments="'+memId+'"/>');
      } else {
        $("#memberId").val(memInfo.memId);
        $("#reqstMemId").val(memInfo.memCode);
        $("#memTypeId").val(memInfo.memType);

      }
    });
  }

  function fn_validation() {
    if ($("#caseCategory1").val() == "" || $("#caseCategory1").val() == '1') {
      Common.alert("Please select a case category");
      return false;
    }
//     if ($("#caseCategory1").val() == '2144') {
//       if ($("#docType").val() == "" || $("#docType").val() == '1' || $("#docType").val() == null) {
//         Common.alert("Please select a types of documents");
//         return false;
//       }
//     }
    if ($("#caseCategory2").val() == "" || $("#caseCategory2").val() == '1') {
        Common.alert("Please select a sub category");
        return false;
    }
    if (FormUtil.isEmpty($('#reqstRefDt').val().trim())) {
      Common.alert("Please select a complaint date");
      return false;
    }
    // 20210705 - LaiKW - Added validation exclusion for Unauthorized online sales on order number and person involved validation (RESN_ID mismatch)
    if($("#caseCategory1 option:selected").text() != "21-Unauthorized Online Sales") {
        if($("#orderId").val() == "" && $("#caseCategory1").val() != '2157'){
            console.log ( 'caseCategory1  :: ' + $("#caseCategory1").val() )
            console.log ( 'docType  :: ' + $("#docType").val() )
          Common.alert("Please key in Order No");
          return false;
        }
        if ($("#reqstMemId").val() == "") {
          Common.alert("Please key in Member Code");
          return false;
        }
    }
    if ($("#action").val() == "") {
      Common.alert("Please select an action");
      return false;
    }
    if ($("#complianceRem").val() == "") {
      Common.alert("Complaint content is empty");
      return false;
    }
    if ($("#hidFileName").val() == "") {
      Common.alert("Please upload attachment");
      return false;
    }

    return true;
  }

  function fn_saveConfirm() {
    if (fn_validation()) {
      var jsonObj = {};
      jsonObj.form = $("#saveForm").serializeJSON();

      Common.ajax("POST", "/organization/compliance/saveGuardian.do", jsonObj, function(result) {
        console.log("성공.");
        Common.alert("Guardian of Compliance saved.", fn_guardianViewPopClose());
      });
    }
  }

  function fn_guardianViewPopClose() {

    $('#btnGuarViewClose').click();
  }

  function fn_uploadfile() {
    Common.popupDiv("/organization/compliance/uploadGuardianAttachPop.do", null, null, true, 'fileUploadPop');
  }

  function fn_caseChange(val) {
    var CASE_CATEGORY = $("#caseCategory1").val();

    $("#caseCategory2 option").remove();
    doGetCombo('/organization/compliance/getSubCatList.do?CASE_CATEGORY=' + CASE_CATEGORY, '', '', 'caseCategory2', 'S');
  }

</script>
<div id="popup_wrap" class="popup_wrap">
  <!-- popup_wrap start -->
  <header class="pop_header">
    <!-- pop_header start -->
    <h1>Guardian of Coway New</h1>
    <ul class="right_opt">
      <li><p class="btn_blue2"><a href="#" id="btnGuarViewClose">CLOSE</a></p></li>
    </ul>
  </header>
  <!-- pop_header end -->
  <section class="pop_body">
    <!-- pop_body start -->
    <article class="tap_area">
      <!-- tap_area start -->
      <form action="#" method="post" id="saveForm">
        <input type="hidden" title="" placeholder="" class="" id="memberId" name="memberId" /> <input type="hidden" id="searchOrderId" name="searchOrderId" /> <input type="hidden" title="" placeholder="" class="" id="hidFileName" name="hidFileName" /> <input type="hidden" title="" placeholder="" class="" id="groupId" name="groupId" /> <input type="hidden" title="" placeholder="" class="" id="memTypeId" name="memTypeId" />
        <table class="type1">
          <!-- table start -->
          <caption>table</caption>
          <colgroup>
            <col style="width: 130px" />
            <col style="width: *" />
            <col style="width: 150px" />
            <col style="width: *" />
            <col style="width: 130px" />
            <col style="width: *" />
            <col style="width: 130px" />
            <col style="width: *" />
          </colgroup>
          <tbody>
            <tr>
              <th scope="row">Case Category</th>
              <td colspan="3">
                <select class="w100p" id="caseCategory1" name="caseCategory1" onchange="fn_caseChange(this.value);">
                  <c:forEach var="list" items="${caseCategoryCodeList}" varStatus="status">
                    <option value="${list.codeId}">${list.codeName }</option>
                  </c:forEach>
                </select>
              </td>
              <th scope="row">Sub Category</th>
              <td colspan="3"><select id='caseCategory2' name='caseCategory2' class="w100p"></select></td>
            </tr>
            <tr>
              <th scope="row">Complaint Date</th>
              <td colspan="3">
                <input type="text" title="Complaint Date" placeholder="DD/MM/YYYY" name="reqstRefDt" id="reqstRefDt" class="j_date" />
              </td>
              <th scope="row">Order No</th>
              <td colspan="3">
                <input id="orderId" name="orderId" type="text" title="" placeholder="Order No" class="" /><a class="search_btn" id="ordBtn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
              </td>
            </tr>
            <tr>
              <th scope="row">Customer Contact</th>
              <td colspan="3">
                <input type="text" title="" placeholder="Customer Contact" disabled="disabled" class="" id="reqstCntnt" name="reqstCntnt" value="" />
              </td>
              <th scope="row">Order No2</th>
              <td colspan="3">
                <input id="orderId2" name="orderId2" type="text" title="" placeholder="Order No2" disabled="disabled" class=""  value="" />
              </td>
            </tr>
            <tr>
              <th scope="row">Involved Person Code</th>
              <td colspan="3">
                <input id="reqstMemId" name="reqstMemId" type="text" title="" placeholder="Involved Person Code" class="" /><a class="search_btn" id="memBtn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
              </td>
              <th scope="row">Customer Name</th>
              <td colspan="3">
                <input type="text" title="" placeholder="Customer Name" disabled="disabled" class="" id="custName" name="custName" value="" />
              </td>
            </tr>
            <tr>
              <th scope="row">Complaint Content</th>
              <td colspan="7">
                <textarea cols="20" rows="5" placeholder="Complaint Content" id="complianceRem" name="complianceRem"></textarea>
              </td>
            </tr>
          </tbody>
        </table>
        <!-- table end -->
      </form>
      <ul class="center_btns">
        <li><p class="btn_blue2 big"><a href="#" onClick="javascript:fn_uploadfile()">Upload Attachment</a></p></li>
        <li><p class="btn_blue2 big"><a href="#" onClick="javascript:fn_saveConfirm()">SAVE</a></p></li>
      </ul>
    </article>
    <!-- tap_area end -->
    <article class="tap_area">
      <!-- tap_area start -->
  </section>
  <!-- pop_body end -->
</div>
<!-- popup_wrap end -->
