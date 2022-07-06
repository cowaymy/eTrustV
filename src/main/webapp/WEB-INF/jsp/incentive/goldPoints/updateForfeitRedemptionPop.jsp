<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript" language="javascript">

    $(document).ready(function() {

        $("#_rdmId").val("${rdmId}");
        $("#_rdmNo").val("${rdmNo}");

        $('#cancelBtn').click(function() {
            $('#btnPopClose').trigger("click");
        });

        $('#saveBtn').click(function() {
        	fn_promptAdminForfeitConfirm();
        });

    });

    function validateUpdForm() {
        if ($("#rdmStatus").val() == '') {
            Common.alert("<spring:message code='sys.common.alert.validation' arguments='Action' htmlEscape='false'/>");
            return false;
        }
        return true;
    }

    function updateRedemption() {
        if (validateUpdForm()) {

            var updateRdmData = {
                rdmId : $("#_rdmId").val(),
                rdmStatus : $("#rdmStatus").val(),
                rdmRemark : $("#rdmRemark").val()
            };

            Common.ajax("POST", "/incentive/goldPoints/updateRedemption.do", updateRdmData, function(result) {
                if(result.code == "00") {        //successful update
                    Common.alert(" Update status successful for Redemption No: " + $("#_rdmNo").val()
                            + "<br />Status: " + $("#rdmStatus option:selected").text());
                } else {
                    Common.alert(result.message);
                }

            });
        }
    }

    function fn_promptAdminForfeitConfirm() {
    	 if (validateUpdForm()) {
		        var memName = "${memName}";
		        var memCode = "${memCode}";
		        var rdmItem = "${itmDisplayName}";
		        var qty = "${qty}";
		        var totalPts = "${totalPts}";

		        var confirmCancelMsg = memName + "<br />" + memCode + "<br />" +
		        rdmItem + "<br />Quantity : " + qty + "<br />Total Gold Points : " +
		        totalPts + "<br /><br />" + "Do you want to forfeit this redemption request?";

		        Common.confirm(confirmCancelMsg, fn_adminForfeitRedemption);
    	 }
    }


    function fn_adminForfeitRedemption() {

        var updateRdmData = {
                rdmId : $("#_rdmId").val(),
                rdmStatus : "110",
                rdmRemark : $("#rdmRemark").val()
            };

        Common.ajax("POST", "/incentive/goldPoints/updateRedemption.do", updateRdmData, function(result) {

            Common.ajax("POST", "/incentive/goldPoints/adminForfeitRedemption.do", {rdmId:$('#_rdmId').val()}, function(result) {

                if(result.p1 == 1) {     //successful forfeited redemption
                    Common.alert("Gold Points Redemption Request has been forfeited. <br />Redemption No. : "
                            + $('#_rdmNo').val(),fn_reloadList());
                    fn_reloadList();
                } else if (result.p1 == 99) {
                    Common.alert("Failed to Forfeit. Redemption is not Ready In Collect",fn_reloadList());

                }
            });
        });



    }

    function fn_reloadList() {
    	location.reload();
    }

</script>
<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->
  <header class="pop_header"><!-- pop_header start -->
    <h1><spring:message code="incentive.title.goldPtsRdmUpdStatus" /></h1>
    <ul class="right_opt">
      <li><p class="btn_blue2"><a id="btnPopClose" href="#"><spring:message code="sal.btn.close" /></a></p></li>
    </ul>
  </header><!-- pop_header end -->

  <section class="pop_body"><!-- pop_body start -->
    <table class="type1"><!-- table start -->
      <caption>table</caption>
      <colgroup>
        <col style="width:170px" />
        <col style="width:*" />
      </colgroup>
      <tbody>
        <tr>
          <th scope="row">Redemption No. </th>
          <td><span>${rdmNo}</span></td>
        </tr>
        <tr>
          <th scope="row">Member Code</th>
          <td><span>${memCode}</span></td>
          </tr>
        <tr>
          <th scope="row">Member Name</th>
          <td><span>${memName}</span></td>
        </tr>
        <tr>
          <th scope="row">NRIC</th>
          <td><span>${nric}</span></td>
        </tr>
      </tbody>
    </table><!-- table end -->

    <aside class="title_line"><!-- title_line start -->
      <h3>Redeem Information:</h3>
    </aside><!-- title_line end -->
    <table class="type1"><!-- table start -->
      <caption>table</caption>
      <colgroup>
        <col style="width:160px" />
        <col style="width:*" />
      </colgroup>
      <tbody>
        <tr>
          <th scope="row">Category</th>
          <td><span>${itmCat}</span></td>
        </tr>
        <tr>
          <th scope="row">Item</th>
          <td><span>${itmDisplayName}</span></td>
        </tr>
        <tr>
          <th scope="row">Quantity</th>
          <td><span>${qty}</span></td>
        </tr>
      </tbody>
    </table><!-- table end -->

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
              <select id="rdmStatus" name="rdmStatus">
                <option value=""></option>
                <option value="114">Forfeited</option>
              </select>
            </td>
          </tr>
          <tr>
            <th scope="row">Remark</th>
            <td><textarea cols="20" rows="2" type="text" id="rdmRemark" name="rdmRemark" maxlength="150" placeholder="Enter up to 150 characters"/></td>
          </tr>
        </tbody>
      </table><!-- table end -->

      <ul class="center_btns">
        <li><p class="btn_blue2 big"><a href="#" id="saveBtn">Save</a></p></li>
        <li><p class="btn_blue2 big"><a href="#" id="cancelBtn">Cancel</a></p></li>
      </ul>

    </form>

  </section><!-- pop_body end -->

</div><!-- popup_wrap end -->s