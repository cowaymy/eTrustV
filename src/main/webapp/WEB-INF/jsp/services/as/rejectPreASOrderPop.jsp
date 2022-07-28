<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript" language="javascript">

    $(document).ready(function() {
    	$("#branchCode").val('${branchCode}');
        doGetCombo('/services/as/getASReasonCode.do?RESN_TYPE_ID=5550', '','', 'ddlFailReason', 'S', '');
    });


    function validateUpdForm() {
        if ($("#preAsStatus").val() == '') {
            Common.alert("Please choose Status.");
            return false;
        }

        if ($("#ddlFailReason").val() == '') {
            Common.alert("Please choose Reason.");
            return false;
        }

        if ($("#preAsRemark").val() == '') {
            Common.alert("Please fill in Remark.");
            return false;
        }

        return true;
    }

    function updateRejected() {
    	var param;
        if (validateUpdForm()) {

               param = {
            		   orderNo : '${salesOrdNo}',
            		   failReason : $("#ddlFailReason").val(),
            		   remark :  $("#preAsRemark").val(),
             }

               Common.ajax("POST", "/services/as/updateRejectedPreAS.do", param, function(result) {

                 Common.alert("This approval has been rejected.");

               },fn_reloadList());

        }
   }


    function fn_reloadList() {
        location.reload();
    }

</script>
<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->
  <header class="pop_header"><!-- pop_header start -->
    <h1>Reject Approval</h1>
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
              <select id="preAsStatus" name="preAsStatus">
                <option value="6">Rejected</option>
              </select>
            </td>
          </tr>
          <tr>
            <th scope="row">Reason</th>
            <td>
	            <select id='ddlFailReason' name='ddlFailReason' >
	             <option value=""><spring:message code='sal.combo.text.chooseOne'/></option>
	            </select>
            </td>
          </tr>

          <tr>
           <th scope="row">DSC Code</th>
           <td><input type="text" class="readonly" name="branchCode" id="branchCode"  readonly=readonly /> </td>
          </tr>

          <tr>
            <th scope="row">Remark</th>
            <td><textarea cols="20" rows="2" type="text" id="preAsRemark" name="preAsRemark" maxlength="150" placeholder="Remark"/></td>
          </tr>
        </tbody>
      </table><!-- table end -->

      <ul class="center_btns">
        <li><p class="btn_blue2 big"><a href="#" id="saveBtn" onClick="updateRejected()">Save</a></p></li>
        <li><p class="btn_blue2 big"><a href="#" id="cancelBtn">Cancel</a></p></li>
      </ul>

</form>
</section>


</div><!-- popup_wrap end -->s