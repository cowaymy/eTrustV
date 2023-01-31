<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript" language="javascript">

    $(document).ready(function() {
        $("#branchCode").val('${branchCode}');
        $("#creator").val('${SESSION_INFO.userMemCode}');
        $("#recallDt").val('${recallDt}');
        $("#defectCode").val('${defectCode}' + '_'+'${defectDesc}');

        getReasonList();
        checkAmendedErrorCode();
    });

    function checkAmendedErrorCode(){

    	 $("#amendedAsErrorCode").attr("class", "w100p readonly");
         $("#amendedAsErrorCode").attr("disabled", "disabled");

        $("#checkAmendedErrorCode").change(function() {
            if ($(this).is(':checked') && $("#updPreAsStatus").val() == 6) {
            	$("#amendedAsErrorCode").attr("class", "w100p");
            	$("#amendedAsErrorCode").attr("disabled", false);
            }
            else{
            	 $("#amendedAsErrorCode").attr("class", "w100p readonly");
                 $("#amendedAsErrorCode").attr("disabled", "disabled");
            }
        });
    }

    function getReasonList(){
        if ($("#updPreAsStatus").val() == 44) {
            doGetCombo('/services/as/getASReasonCode.do?RESN_TYPE_ID=6853', '','', 'ddlReason', 'S', '');
            pendingDisplay();

        }
        else if($("#updPreAsStatus").val() == 6){
            doGetCombo('/services/as/getASReasonCode.do?RESN_TYPE_ID=6854', '','', 'ddlReason', 'S', '');
            rejectDisplay();
        }
        else{
        	doGetCombo('/services/as/getASReasonCode.do?RESN_TYPE_ID=0', '','', 'ddlReason', 'S', '');
        	$("#remarkRow").hide();
        	$("#recallDtRow").hide();
        	 $(".errorCode").hide();
        }

    }

    function pendingDisplay(){
        $("#remarkRow").show();
        $("#recallDtRow").show();
        $(".errorCode").hide();
        document.getElementById('recallDt').disabled = false;
        $("#recallDt").attr("class", "w100p j_date");
    }

    function rejectDisplay(){
    	$("#remarkRow").show();
    	$("#recallDtRow").show();
    	var element = document.getElementById("recallDt");
    	 element.classList.remove("j_date");
    	 $("#recallDt").attr("class", "readonly");
         $("#recallDt").attr("disabled", "disabled");

         $(".errorCode").show();
    }

    $(function() {
    	 $("#updPreAsStatus").change(function(e){
    		 getReasonList();
    	 });
    });


    function validateUpdForm() {

        if (FormUtil.isEmpty($("#updPreAsStatus").val())) {
            Common.alert("Please choose Status.");
            return false;
        }

        if (($("#updPreAsStatus").val() ==44 || $("#updPreAsStatus").val()  == 6 )&& $("#ddlReason").val() == '') {
            Common.alert("Please choose Reason.");
            return false;
        }

        if(document.getElementById("checkAmendedErrorCode").checked == true && FormUtil.isEmpty($("#amendedAsErrorCode").val())){
            Common.alert("Please choose Amended AS Error Code");
            return false;
        }

        if (($("#updPreAsStatus").val() ==44 || $("#updPreAsStatus").val()  == 6 ) && FormUtil.isEmpty($("#updPreAsRemark").val())) {
            Common.alert("Please fill in Remark.");
            return false;
        }



        return true;
    }

    function fn_save() {
        var param;
        var recallDt = $("#recallDt").val() == '-' ? null : $("#recallDt").val();
        if (validateUpdForm()) {

        	if($("#updPreAsStatus").val() ==5){
        		fn_newASPop();
        	}else{

               param = {
                       orderNo : '${salesOrdNo}',
                       stus :  $("#updPreAsStatus").val(),
                       reason : $("#ddlReason").val(),
                       remark :  $("#updPreAsRemark").val(),
                       recallDt :  recallDt == null ? null : $("#recallDt").val(),
                       amendedErrorCode : $("#amendedAsErrorCode").val()
             }

               Common.ajax("POST", "/services/as/updatePreAsStatus.do", param, function(result) {
            	   Common.alert("Success to update.",fn_reloadList);
               }, function(jqXHR, textStatus, errorThrown) {
                   try {
                       console.log("status : " + jqXHR.status);
                       console.log("code : " + jqXHR.responseJSON.code);
                       console.log("message : " + jqXHR.responseJSON.message);
                       console.log("detailMessage : "+ jqXHR.responseJSON.detailMessage);
                   } catch (e) {
                       console.log(e);
                   }

               });
        	}
        }
   }


    function fn_reloadList() {
    	$("#btnPopClose").click();
    	fn_searchPreASManagement();
    }

</script>
<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->
  <header class="pop_header"><!-- pop_header start -->
    <h1>Update Status</h1>
    <ul class="right_opt">
      <li><p class="btn_blue2"><a id="btnPopClose" href="#"><spring:message code="sal.btn.close" /></a></p></li>
    </ul>
  </header><!-- pop_header end -->
<section class="pop_body"><!-- pop_body start -->

 <aside class="title_line"><!-- title_line start -->
      <h3>Update Status:</h3>
    </aside><!-- title_line end -->
    <form action="#" method="post" name="updateForm" id="updateForm">
      <input id="_rdmId" name="rdmId" type="hidden" value="" />
      <input id="_rdmNo" name="rdmNo" type="hidden" value="" />
      <table class="type1"><!-- table start -->
        <caption>table</caption>
        <colgroup>
          <col style="width:160px" />
          <col style="width:*" />
        </colgroup>
        <tbody>
          <tr>
            <th scope="row">Action</th>
            <td>
            <select class=" w100p"  id="updPreAsStatus" name="updPreAsStatus">
	            <c:forEach var="list" items="${preasStat}" varStatus="status">
	             <option value="${list.codeId}">${list.codeName}</option>
	             </c:forEach>
            </select>
            </td>
          </tr>
          <tr>
            <th scope="row">Reason</th>
            <td>
                <select id='ddlReason' name='ddlReason' >
                 <option value=""><spring:message code='sal.combo.text.chooseOne'/></option>
                </select>
            </td>
          </tr>

          <tr class="errorCode">
           <th scope="row">Error Code</th>
           <td>
                <input type="text" class="readonly" name="defectCode" id="defectCode"  readonly=readonly />
                <input type="checkbox" id="checkAmendedErrorCode" name="checkAmendedErrorCode">
            </td>
          </tr>

          <tr  class="errorCode">
            <th scope="row">Amended AS Error Code</th>
            <td>
            <select class=" w100p"  id="amendedAsErrorCode" name="amendedAsErrorCode">
                <option value="" selected>Please Choose One </option>
                <c:forEach var="list" items="${errorCodeList}" varStatus="status">
                 <option value="${list.codeId}">${list.codeName}</option>
                 </c:forEach>
            </select>
            </td>
          </tr>

          <tr>
           <th scope="row">DSC Code</th>
           <td><input type="text" class="readonly" name="branchCode" id="branchCode"  readonly=readonly /> </td>
          </tr>

           <tr>
           <th scope="row">Create ID</th>
           <td><input type="text" class="readonly" name="creator" id="creator"  readonly=readonly /> </td>
          </tr>

          <tr id="recallDtRow">
           <th scope="row">Recall Date</th>
           <td><input type="text" title="Create start Date" placeholder="DD/MM/YYYY"  id="recallDt" name="recallDt" /></td>
          </tr>

          <tr id="remarkRow">
            <th scope="row">Remark</th>
            <td><textarea cols="20" rows="2" type="text" id="updPreAsRemark" name="updPreAsRemark" maxlength="300" placeholder="Remark"/></td>
          </tr>
        </tbody>
      </table><!-- table end -->

      <ul class="center_btns">
        <li><p class="btn_blue2 big"><a href="#" id="saveBtn" onClick="fn_save()">Save</a></p></li>
        <li><p class="btn_blue2 big"><a href="#" id="cancelBtn">Cancel</a></p></li>
      </ul>

</form>
</section>


</div><!-- popup_wrap end -->s