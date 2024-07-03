<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<head>
<script type="text/javaScript" language="javascript">

	$(function(){
	    $('#btnRWok').click(function() {
	        fn_onClickBtnRWok();
	    });
        $('#rwOldOrder').keydown(function (event) {
            if (event.which === 13) {    //enter
                fn_onClickBtnRWok();
                return false;
            }
        });
	});

	function fn_onClickBtnRWok() {
        $('#lblOldOrderNo').text('');
        $('#txtOldOrderID').val('');

        if(FormUtil.checkReqValue($('#rwOldOrder'))) {
            $('#lblOldOrderNo').text('<spring:message code="sal.alert.msg.plzKeyInOldOrdNo" />');
            return;
        }

        console.log('/sales/order/checkOldOrderId.do CALL START');
        console.log('param salesOrdId:'+$('#relatedNo').val());
        console.log('param custId:'+$('#custId').val());

        Common.ajax("GET", "/sales/order/checkOldOrderId.do", {salesOrdNo : $('#rwOldOrder').val(), custId : $('#custId').val(), promoId : $('#ordPromo').val(), exTrade : $('#exTrade').val(), refNo : $('#hiddenRefNo').val()}, function(RESULT) {
            console.log('RESULT ROOT_STATE  :'+RESULT.rootState);
            console.log('RESULT IS_IN_VALID :'+RESULT.isInValid);
            console.log('RESULT MSG         :'+RESULT.msg);
            console.log('RESULT OLD_ORDER_ID:'+RESULT.oldOrderId);
            console.log('RESULT INST_SPEC_INST:'+RESULT.instSpecInst);
            //busType = AUIGrid.getCellValue(prevOrdNoGridID , event.rowIndex , "busType");
            console.log('RESULT EXTR_OPT_FLAG:'+RESULT.extrOptFlag);

            $('#txtOldOrderID').val(RESULT.oldOrderId);
            $('#relatedNo').val($('#rwOldOrder').val());
            //$('#txtBusType').val($('#txtBusType').val());

            if(RESULT.extrOptFlag == '1'){
            	$('#isReturnExtrade').attr("disabled",false);
            }else{
            	$('#isReturnExtrade').attr("disabled",true);
            }

            if(RESULT.rootState == 'ROOT_1') {
                $('#rwOldOrder').clearForm();
                $('#lblOldOrderNo').text('<spring:message code="sal.alert.msg.oldOrdNoNotFound" />');
            }
            if(RESULT.rootState == 'ROOT_2') {
                $('#rwOldOrder').clearForm();
                //$('#lblOldOrderNo').text('<spring:message code="sal.alert.msg.disallowExTrade" />');
                $('#lblOldOrderNo').text('Education and Free Trial type order is disallowed to register for ex-trade');
            }
            if(RESULT.rootState == 'ROOT_3') {
                $('#rwOldOrder').clearForm();
                $('#lblOldOrderNo').text('<spring:message code="sal.alert.msg.invalidOrdNo" />');
            }
            if(RESULT.rootState == 'ROOT_4') {
                $('#oldOrderCloseBtn').click();
                $('#speclInstct').val(RESULT.instSpecInst);
                Common.confirm('<spring:message code="sal.alert.msg.chkOldOrdNo" />' + DEFAULT_DELIMITER + RESULT.msg, btnHidden_Valid_Click(RESULT.isInValid), fn_apprvPopClose);
            }
            if(RESULT.rootState == 'ROOT_5') {
                $('#rwOldOrder').clearForm();
                $('#lblOldOrderNo').text('<spring:message code="sal.alert.msg.disallowExTrade2" />');
            }
            if(RESULT.rootState == 'ROOT_6') {
                $('#oldOrderCloseBtn').click();
                $('#speclInstct').val(RESULT.instSpecInst);
                Common.confirm('<spring:message code="sal.alert.msg.cnfrmProc" />' + DEFAULT_DELIMITER + RESULT.msg, btnHidden_Valid_Click(RESULT.isInValid), fn_apprvPopClose);
            }
            if(RESULT.rootState == 'ROOT_7') {
                $('#txtOldOrderID').val(RESULT.oldOrderId);
                $('#speclInstct').val(RESULT.instSpecInst);
                fn_popOrderDetail();
                $('#oldOrderCloseBtn').click();
            }
            if(RESULT.rootState == 'ROOT_8') {
                $('#rwOldOrder').clearForm();
                $('#lblOldOrderNo').text('<spring:message code="sal.alert.msg.usedExTrade" />');
            }
            if(RESULT.rootState == 'ROOT_9') {//checking for I-CARE Rental
                $('#rwOldOrder').clearForm();
                Common.alert('<spring:message code="sal.alert.msg.chkOldOrdNo" />' + DEFAULT_DELIMITER + RESULT.msg, fn_apprvPopClose);
            }
            if(RESULT.rootState == 'ROOT_10') {//checking for I-CARE
                $('#rwOldOrder').clearForm();
                Common.alert('<spring:message code="sal.alert.msg.chkOldOrdNo" />' + DEFAULT_DELIMITER + RESULT.msg, fn_apprvPopClose);
            }
        });
	}

	function fn_apprvPopClose() {
	    $('#orderApprvalCloseBtn').click();
	}

	function btnHidden_Valid_Click(isInValid) {
	    console.log('btnHidden_Valid_Click CALL START');
	    console.log('isInValid :'+isInValid);

	    if(isInValid == 'InValid') {
	    	console.log('InValid');
	        //2017.11.19 ����Ȯ�� �˾� �ּ�ó��. Confirm�޼����� ��ü
            //Common.popupDiv("/sales/order/orderApprovalPop.do")
            /* var msg = "Report For Decision (RFD) is require for those Ex-trade sales key-in that does not meet the 3 conditions <br>";
            msg += "(outstanding fees, early ex-trade 5 months and above advance before end of contract(Rental) and different customer)."; */

            Common.confirm('<spring:message code="sal.alert.msg.cnfrmToSave" />', fn_popOrderDetail);
	    }
	    else {
            fn_popOrderDetail();
	    }
	}

	  $(document).ready(function(){
	        $('#rwOldOrder').val($('#relatedNo').val());
	        //console.log("${bundleId}");
	        //console.log("${anoOrderNo}");
	        // $('#btnRWok').click();
	    });

</script>
</head>
<body>

<div id="popup_wrap" class="popup_wrap size_small"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="sal.alert.msg.plzKeyInOldOrd" /></h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a id="oldOrderCloseBtn" href="#"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
<form action="#" method="post">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:110px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">Order No.</th>
	<td>
	<input id="rwOldOrder" name="rwOldOrder" type="text" title=""  placeholder="" class="w100p readonly" readonly/>
	</td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="left_btns mb10">
	<li><p><span id="lblOldOrderNo" class="red_text"></span></p></li>
</ul>

<ul class="center_btns">
	<li><p class="btn_blue2 big"><a id="btnRWok" href="#"><spring:message code="sal.btn.ok" /></a></p></li>
</ul>

</form>
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->

</body>
</html>