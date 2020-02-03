<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript" language="javascript">
var ORD_NO = "${orderDetail.basicInfo.ordNo}";
var CUST_NAME = "${orderDetail.basicInfo.custName}";
var APP_TYPE_ID = "${orderDetail.basicInfo.appTypeId}";
var APP_TYPE_DESC = "${orderDetail.basicInfo.appTypeName}";
var PRODUCT_NAME = "${orderDetail.basicInfo.productName}";




    $(function(){

        CommonCombo.make("cmbRequestor", "/common/selectCodeList.do", {groupCode : '52', codeIn : 'HP,CODY,CDB,CUST,HC,HP,SO,HT,HBD'}, "", {
            id: "codeId",
            name: "codeName",
            type:"S"
        }); // REQUESTOR TYPE

        CommonCombo.make("cmbReason", "/homecare/sales/selectResnCodeList.do", {resnTypeId : '5785', stusCodeId : '1', codeIn : '001,002,003,004,005,006'}, "", {
            id: "code",
            name: "codeName",
            type:"S"
        }); // REASON CODE





        $('#btnOrdCancelClose').click(function() {

        });

        $('#btnConfirmCancel').click(function() {
            if ($("#txtRemark").val() == "" || $("#txtRemark").val() == null ){
            	Common.alert("Cancel Remark is required for checking purpose.");
            }else{
            	fn_clickBtnConfirmCancel();
            }
          });

    });

    function fn_clickBtnConfirmCancel() {
    	 var msg = "";
    	 msg += 'CS Order No.          : ' + ORD_NO + '<br />';
    	 msg += 'Customer Name  : ' + CUST_NAME + '<br />';
    	 msg += 'Application Type : ' + APP_TYPE_DESC + '<br />';
    	 msg += 'Product Size      : ' + PRODUCT_NAME + '<br />';

    	 if(APP_TYPE_ID == "3217" || APP_TYPE_ID == "3216"){
    		 msg += '<br /><i>Note : Kindly proceed to payment refund if any</i>';
    	 }

    	 msg += '<br/> <font style="color:red;font-weight: bold">Are you sure want to confirm CS cancellation? </font><br/><br/>';

    	 Common.confirm('<spring:message code="sal.title.text.reqCancConfrm" />'
    		        + DEFAULT_DELIMITER + "<b>" + msg + "</b>", fn_doSaveReqCancel,
    		        fn_selfClose)
    }

    function fn_doSaveReqCancel() {
        console.log('!@# fn_doSaveReqCancel START');

        Common.ajax("POST", "/homecare/sales/htRequestCancelCSOrder.do", $(
            '#frmReqCancel').serializeJSON(), function(result) {

          Common.alert('<spring:message code="sal.alert.msg.cancReqSum" />'
              + DEFAULT_DELIMITER + "<b>" + result.message + "</b>",
              fn_selfClose);

        }, function(jqXHR, textStatus, errorThrown) {
          try {
                console.log("Error message : " + jqXHR.responseJSON.message);
            Common.alert("Data Preparation Failed" + DEFAULT_DELIMITER
                + "<b>Saving data prepration failed.</b>");
          } catch (e) {
            console.log(e);
          }
        });
      }

    function fn_selfClose() {
        $('#btnOrdCancelClose').click();
      }

</script>
<body>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Care Service Order - Cancel Request</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a id="btnOrdCancelClose" href="#"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
<!------------------------------------------------------------------------------
    Order Detail Page Include START
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/homecare/sales/htOrderDetailContent.jsp" %>
<!------------------------------------------------------------------------------
    Order Detail Page Include END
------------------------------------------------------------------------------->
 <form id="frmReqCancel" action="#" method="post">
  <input id="ordId" name="ordId" type="hidden" value="${orderDetail.basicInfo.ordId}" />
  <input id="ordNo" name="ordNo" type="hidden" value="${orderDetail.basicInfo.ordNo}" />
  <input id="appTypeId" name="appTypeId" type="hidden" value="${orderDetail.basicInfo.appTypeId}" />
   <input id="totAmt" name="totAmt" type="hidden" value="${orderDetail.basicInfo.totAmt}" />

     <h3>
     Care Service Order Cancellation Request Information
    </h3>
<table class="type1">

<caption>table</caption>
    <colgroup>
        <col style="width: 180px" />
        <col style="width: *" />
        <col style="width: 180px" />
        <col style="width: *" />
        <col style="width: 180px" />
        <col style="width: *" />
       </colgroup>
<tbody>

<tr>

</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.requestor" /><span class="must">*</span></th>
    <td>
    <select id="cmbRequestor" name="cmbRequestor" class="w300p " ></select>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.reason" /><span class="must">*</span></th>
    <td>
    <select id="cmbReason" name="cmbReason" class="w300p " ></select>
    </td>
</tr>
<tr>
    <th scope="row">Cancel Remark<span class="must"> *</span></th>
    <td colspan="5"><textarea id="txtRemark" name="txtRemark" cols="20" rows="5" ></textarea></td>
</tr>
</tbody>
</table>

   <ul class="center_btns">
    <li><p class="btn_blue2">
      <a id="btnConfirmCancel" href="#">Confirm to Cancel</a>
     </p></li>
   </ul>
   </form>
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->

</body>
</html>