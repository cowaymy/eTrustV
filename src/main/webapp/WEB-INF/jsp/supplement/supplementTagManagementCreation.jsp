<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript">
//생성 후 반환 ID
var purchaseGridID;
var serialTempGridID;
var memGridID;

var paymentGridID;
var myFileCaches = {};
var atchFileGrpId = 0;

$(document).ready(function() {
/* 	console.log("fn_formSetting222");
	$("#basicForm").hide();
	$("#inputForm").hide(); */

	console.log ( "ret:: "+ '${orderInfo}');


	if ('${orderInfo}' != "" && '${orderInfo}' != null ) {
		  console.log("fn_formSetting222");
		$("#basicForm").show();
	    $("#inputForm").show();


	    $('#entry_supRefNo').val('${orderInfo.supRefNo}');

	}

	console.log ( "orderNo:: "+ $("#entry_supRefNo").val());

	setTimeout(function() {
        fn_descCheck(0)
      }, 1000);

});

$('#_saveBtn').click(function() {

	console.log("_saveBtn");

	 var supRefId =  $("#_infoSupRefStus").val();
	 var subTopic = $('#ddlSubTopic').val().trim();

	 console.log("supRefId::>><<@@" + supRefId);
	 console.log("subTopic::>><<@@" + subTopic);








    fn_SaveTagSubmission();
});

function fn_formSetting(){

	console.log("fn_formSetting111");
	$("#basicForm").show();
    $("#inputForm").show();
}

//Close
function fn_popClose(){
    $("#_systemClose").click();
}

function fn_bookingAndpopClose(){
    //프로시저 호출
    // 콜백  >>
    $("#_systemClose").click();
}


function fn_descCheck(ind) {

    var indicator = ind;
    var jsonObj = {
      DEFECT_GRP : $("#mainTopicList").val(),
      DEFECT_GRP_DEPT : $("#inchgDeptList").val(),
      TYPE : "SMI"
    };

    doGetCombo('/supplement/getSubTopicList.do?DEFECT_GRP=' + $("#mainTopicList").val(), '', '', 'ddlSubTopic', 'S', '');
    doGetCombo('/supplement/getSubDeptList.do?DEFECT_GRP_DEPT=' + $("#inchgDeptList").val(), '', '', 'ddlSubDept', 'S', '');
  }

function fn_mainTopic_SelectedIndexChanged() {
    $("#ddlSubTopic option").remove();
    doGetCombo('/supplement/getSubTopicList.do?DEFECT_GRP=' + $("#mainTopicList").val(), '', '', 'ddlSubTopic', 'S', '');
    }

function fn_inchgDept_SelectedIndexChanged() {
    $("#ddlSubDept option").remove();
    doGetCombo('/supplement/getSubDeptList.do?DEFECT_GRP_DEPT=' + $("#inchgDeptList").val(), '', '', 'ddlSubDept', 'S', '');
    }

function fn_checkOrderNo() {
    if ($("#entry_supRefNo").val() == "" ) {
      var field = "<spring:message code='supplement.text.supplementReferenceNo' />";
      Common.alert("<spring:message code='sys.msg.necessary' arguments='* <b>" +field + "</b>' htmlEscape='false'/>");
      return;
    }

     //Common.ajax("GET", "/services/as/searchOrderNo", { orderNo : $("#entry_orderNo").val() },
     Common.ajax("GET", "/supplement/searchOrderNo", { orderNo : $("#entry_supRefNo").val() },
      function(result) {

    	 console.log("result.supRefId:: " +result.supRefId);
    	 console.log("111");
        if (result == null) {
        	console.log("222");
          Common.alert("Order number does not exist.");
          return;
        } else {
        	console.log("333");


            /* var supplementForm = {
                    supRefId : clickChk[0].item.supRefId,
                    ind : "1"
                  }; */

           Common.popupDiv("/supplement/supplementViewBasicPop.do", { supRefNo : $("#entry_supRefNo").val() }, fn_formSetting() , true,'_insDiv2');

                  $("#_systemClose").click();

        }
      });
  }


//TODO 미개발 message

function fn_SaveTagSubmission(){
  //  var prchParam = AUIGrid.getGridData(purchaseGridID);
  //  var totAmt = fn_calcuPurchaseAmt();

    var orderVO = {

            supRefId :  $("#_infoSupRefId").val(),
           // atchFileGrpId : atchFileGrpId,
            mainTopic : $('#mainTopicList').val().trim(),
            subTopic : $('#ddlSubTopic').val().trim(),
            mainDept : $('#inchgDeptList').val().trim(),
            subDept : $('#ddlSubDept').val().trim(),
            callRemark : $('#_remark').val().trim(),
            supRefStus : $('#supRefStus').val().trim()
    };

    var supRefId =  $("#_infoSupRefId").val();
    console.log("supRefId........... :: " + supRefId);

    var formData = new FormData();
    $.each(myFileCaches, function(n, v) {
      formData.append(n, v.file);
    });

    console.log("supRefId###::" + supRefId);
    console.log("subTopic###::" + subTopic);

    Common.ajaxFile("/supplement/attachFileUploadId.do", formData, function(result) {
          if (result != 0 && result.code == 00) {
            orderVO["atchFileGrpId"] = result.data.fileGroupKey;
            Common.ajax("POST","/supplement/supplementTagSubmission.do", orderVO,
                    function(result) {Common.alert( '<spring:message code="supplement.text.saveSupplementSubmissionSummary" />'
                                  + DEFAULT_DELIMITER
                                  + "<b>"
                                  + result.message
                                  + "</b>",
                                  fn_closeSupplementSubmissionPop);
                    },
                    function(jqXHR, textStatus,
                        errorThrown) {
                      try {
                        Common.alert('<spring:message code="supplement.text.saveSupplementSubmissionSummary" />'
                                + DEFAULT_DELIMITER
                                + "<b>Failed to save order. "
                                + jqXHR.responseJSON.message
                                + "</b>");
                        Common.removeLoader();
                      } catch (e) {
                        console.log(e);
                      }
                    });

          } else {
            Common.alert('<spring:message code="supplement.text.saveSupplementSubmissionSummary" />'
                    + DEFAULT_DELIMITER + result.message);
          }
        },
        function(result) {
          Common
              .alert("Upload Failed. Please check with System Administrator.");
        });
}

function fn_closeSupplementSubmissionPop() {
    myFileCaches = {};
    $('#_systemClose').click();
   // fn_getSupplementSubmissionList();
  }

</script>
<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<input type="hidden" id="_infoSupRefId" value="${orderInfo.supRefId}">
<input type="hidden" id="_infoSupRefStus" value="${orderInfo.supRefStus}">
<input type="hidden" id="_memBrnch" value="${userBr}">


<header class="pop_header"><!-- pop_header start -->
<h1>Tag Management - New Ticket</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a id="btnLedger" href="#"><spring:message code="sal.btn.ledger" /></a></p></li>
    <li><p class="btn_blue2"><a id="_systemClose"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->


    </br>
     <table class="type1">
      <!-- table start -->
      <caption>table</caption>
      <colgroup>
       <col style="width: 180px" />
       <col style="width: *" />
      </colgroup>
      <tbody>
       <tr>
        <th scope="row"><spring:message code='supplement.text.supplementReferenceNo'/><span class="must">*</span></th>
        <td>
          <input type="text" title="" placeholder="supplementReferenceNo" class="" id="entry_supRefNo" name="entry_supRefNo" />
          <p class="btn_sky"><a href="#" onClick="fn_checkOrderNo()"><spring:message code='pay.combo.confirm'/></a></p><p class="btn_sky">
            <%-- <a href="#" onclick="fn_goCustSearch()"><spring:message code='sys.btn.search'/></a> --%>
           </p></td>
       </tr>
      </tbody>
     </table>
     </br>


<section class="tap_wrap">
<form id="basicForm" style ="display:none">
<!------------------------------------------------------------------------------
    Supplement Detail Page Include START
------------------------------------------------------------------------------->
 <%@ include file="/WEB-INF/jsp/supplement/supplementDetailContent.jsp" %>
<!------------------------------------------------------------------------------
    Supplement Detail Page Include END
------------------------------------------------------------------------------->
</form>
</section>

</br></br>
<form id="inputForm"  style ="display:none">
<aside class="title_line"><!-- title_line start -->
<h2>Ticket Info.</h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="supplement.text.supplementMainTopicInquiry"/><span class="must">*</span></th>
    <td>
      <select class="select w100p" id="mainTopicList" name="mainTopicList" onChange="fn_mainTopic_SelectedIndexChanged()">
                <option value="">Choose One</option>
                <c:forEach var="list" items="${mainTopic}" varStatus="status">
                  <option value="${list.codeId}">${list.codeName}</option>
                </c:forEach>
      </select>
    </td>
    <th scope="row"><spring:message code="supplement.text.supplementSubTopicInquiry" /><span class="must">*</span></th>
    <td>
      <select id='ddlSubTopic' name='ddlSubTopic' class="w100p"></select>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="service.text.InChrDept" /><span class="must">*</span></th>
    <td>
        <select class="select w100p" id="inchgDeptList" name="inchgDeptList" onChange="fn_inchgDept_SelectedIndexChanged()">
                <option value="">Choose One</option>
                <c:forEach var="list" items="${inchgDept}" varStatus="status">
                  <option value="${list.codeId}">${list.codeName}</option>
                </c:forEach>
        </select>
    </td>
    <th scope="row"><spring:message code="service.grid.subDept" /><span class="must">*</span></th>
    <td>
    <select id='ddlSubDept' name='ddlSubDept' class="w100p"></select>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.attachment" /></th>
    <td colspan = "3">
           <div class="auto_file">
                    <input type="file" title="file add" id="docFile" accept="image/jpg, image/jpeg, image/png, application/pdf" />
           </div>
     </td>
</tr>

<tr>
    <th scope="row"><spring:message code="pay.head.remark" /></th>
    <td colspan="3">
        <input type="text" title="" placeholder="Remark" class="w100p" id="_remark" " name="remark" />
    </td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="center_btns">
    <li><p class="btn_blue2"><a id="_saveBtn"><spring:message code="sal.btn.save" /></a></p></li>
</ul>

</form>
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->