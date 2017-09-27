<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<head>
<script type="text/javaScript" language="javascript">

	//AUIGrid ���� �� ��ȯ ID
//	var addrGridID;
//
//	$(document).ready(function(){
//	    //AUIGrid �׸��带 �����մϴ�.
//        createAUIGrid();
//        fn_getCustomerAddressAjax();
//
//        // �� ����Ŭ�� �̺�Ʈ ���ε�
//        AUIGrid.bind(addrGridID, "cellDoubleClick", function(event) {
//            fn_setData(AUIGrid.getCellValue(addrGridID , event.rowIndex , "custAddId"))
//            $('#custPopCloseBtn').click();
//        });
//	    
//	});
//	
//	function fn_setData(custAddId) {
//	    if($('#callPrgm').val() == 'ORD_REGISTER_BILL_MTH') {
//	        fn_loadMailAddr(custAddId);
//	    }
//	    else if($('#callPrgm').val() == 'ORD_REGISTER_INST_ADD') {
//	        fn_loadInstallAddr(custAddId);
//	    }
//	}
//	
//    function createAUIGrid() {
//        
//        //AUIGrid Į�� ����
//        var columnLayout = [{
//	            dataField : "name",
//	            headerText : "Status",
//	            width : 80
//	        }, {
//	            dataField : "addr",
//	            headerText : "Address"
//	        },{
//	            dataField : "custAddId",
//	            visible : false
//            }];
//
//        //�׸��� �Ӽ� ����
//        var gridPros = {
//            usePaging           : true,         //����¡ ���
//            pageRowCount        : 10,           //�� ȭ�鿡 ��µǴ� �� ���� 20(�⺻��:20)            
//            editable            : false,            
//            fixedColumnCount    : 0,            
//            showStateColumn     : false,             
//            displayTreeOpen     : false,            
//            selectionMode       : "singleRow",  //"multipleCells",            
//            headerHeight        : 30,       
//            useGroupingPanel    : false,        //�׷��� �г� ���
//            skipReadonlyColumns : true,         //�б� ���� ���� ���� Ű���� ������ �ǳ� ���� ����
//            wrapSelectionMove   : true,         //Į�� ������ ������ �̵� �� ���� ��, ó�� Į������ �̵����� ����
//            showRowNumColumn    : true,         //�ٹ�ȣ Į�� ������ ���    
//            noDataMessage       : "No order found.",
//            groupingMessage     : "Here groupping"
//        };
//        
//        addrGridID = GridCommon.createAUIGrid("grid_addr_wrap", columnLayout, "", gridPros);
//    }

	$(function(){
	    $('#btnRWok').click(function() {
	        
	        $('#lblOldOrderNo').text('');
	        $('#txtOldOrderID').val('');
	        
	        if(FormUtil.checkReqValue($('#rwOldOrder'))) {
                $('#lblOldOrderNo').text('* Please key in old order no.');
                return;
	        }
	        
	        console.log('/sales/order/checkOldOrderId.do CALL START');
	        console.log('param salesOrdId:'+$('#rwOldOrder').val());
	        console.log('param custId:'+$('#custId').val());

            Common.ajax("GET", "/sales/order/checkOldOrderId.do", {salesOrdNo : $('#rwOldOrder').val(), custId : $('#custId').val(), promoId : $('#ordPromo').val()}, function(RESULT) {
                console.log('RESULT ROOT_STATE  :'+RESULT.rootState);
                console.log('RESULT IS_IN_VALID :'+RESULT.isInValid);
                console.log('RESULT MSG         :'+RESULT.msg);
                console.log('RESULT OLD_ORDER_ID:'+RESULT.oldOrderId);
                console.log('RESULT INST_SPEC_INST:'+RESULT.instSpecInst);
                
                $('#txtOldOrderID').val(RESULT.oldOrderId);
                 
                if(RESULT.rootState == 'ROOT_1') {
                    $('#rwOldOrder').clearForm();
                    $('#lblOldOrderNo').text('* Order Number not found!');
                }
                if(RESULT.rootState == 'ROOT_2') {
                    $('#rwOldOrder').clearForm();
                    $('#lblOldOrderNo').text('* Service type order is disallowed to register for ex-trade!');
                }
                if(RESULT.rootState == 'ROOT_3') {
                    $('#rwOldOrder').clearForm();
                    $('#lblOldOrderNo').text('* Order number invalid!');
                }
                if(RESULT.rootState == 'ROOT_4') {
                    $('#oldOrderCloseBtn').click();
                    $('#speclInstct').val(RESULT.instSpecInst);
                    Common.confirm("Check Old Order No" + DEFAULT_DELIMITER + RESULT.msg, btnHidden_Valid_Click(RESULT.isInValid));
                }
                if(RESULT.rootState == 'ROOT_5') {
                    $('#rwOldOrder').clearForm();
                    $('#lblOldOrderNo').text('* Rental status not under REG, INV, SUS is disallowed to register for ex-trade!');
                }
                if(RESULT.rootState == 'ROOT_6') {
                    $('#oldOrderCloseBtn').click();
                    $('#speclInstct').val(RESULT.instSpecInst);
                    Common.confirm("Confirm To Proceed" + DEFAULT_DELIMITER + RESULT.msg, btnHidden_Valid_Click(RESULT.isInValid));
                }
                if(RESULT.rootState == 'ROOT_7') {
                    $('#txtOldOrderID').val(RESULT.oldOrderId);
                    $('#speclInstct').val(RESULT.instSpecInst);
                }
                if(RESULT.rootState == 'ROOT_8') {
                    $('#rwOldOrder').clearForm();
                    $('#lblOldOrderNo').text('* Order Number has been used to register for ex-trade!');
                }
            });
	    });
	});
	
	function btnHidden_Valid_Click(isInValid) {
	    console.log('btnHidden_Valid_Click CALL START');
	    console.log('isInValid :'+isInValid);
	    
	    
	    //TODO InValid�ΰ�� Approval Popup�� ���Ͽ� Ȯ�� ���� ��ħ
	    //�ϴ� ���� ����
//	    if(isInValid == 'InValid') {
//          this.txtApprovalCode.Text = "";
//          this.txtApprovalBy.Text = "";
//          this.lblErrorMsg_Approval.Text = "";
//          this.RadWindow_Approval.VisibleOnPageLoad = true;
//	    }
//	    else {
            fn_popOrderDetail();
//	    }
	}
	
	function fn_popOrderDetail() {	    
//      Sales.Orders so = new Sales.Orders();
//      this.RadWindow_Approval.VisibleOnPageLoad = false;
//      int getOldOrderID = so.Get_oldOrderID(ntxtRW_oldorder.Text);
//      this.txtOldOrderID.Text = getOldOrderID.ToString();
//      this.txtInstSpecialInstruction.Text = "(Old order No.)" + ntxtRW_oldorder.Text.Trim() + " , " + get_PromoDesc() + " , SVM expired : " + get_Services_expired();
//      this.RadWindow_OrderDetail.VisibleOnPageLoad = true;
//      this.LoadRadWindowOrderInfo();
        
	    Common.popupDiv("/sales/order/cnfmOrderDetailPop.do");
	}
	
//    //Get Contact by Ajax
//    function fn_getCustomerAddressAjax(){
//        Common.ajax("GET", "/sales/customer/selectCustomerAddressJsonList", $("#addrSearchForm").serializeJSON(), function(result) {
//            AUIGrid.setGridData(addrGridID, result);
//        });
//    }
  
</script>
</head>
<body>

<div id="popup_wrap" class="popup_wrap size_small"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Plese Key In Old Order</h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a id="oldOrderCloseBtn" href="#">CLOSE</a></p></li>
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
	<input id="rwOldOrder" name="rwOldOrder" type="text" title="" placeholder="" class="w100p" />
	</td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="left_btns mb10">
	<li><p><span id="lblOldOrderNo" class="red_text"></span></p></li>
</ul>

<ul class="center_btns">
	<li><p class="btn_blue2 big"><a id="btnRWok" href="#">Ok</a></p></li>
</ul>

</form>
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->

</body>
</html>