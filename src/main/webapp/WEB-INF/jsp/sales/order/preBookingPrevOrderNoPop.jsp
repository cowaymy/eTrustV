<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<head>
<script type="text/javaScript" language="javascript">

    //AUIGrid 생성 후 반환 ID
    var prevOrdNoGridID;
    var busType;

    $(document).ready(function(){
        //AUIGrid 그리드를 생성합니다.
        createAUIGrid();

        fn_getPrevOrderNo();

        AUIGrid.bind(prevOrdNoGridID, "cellDoubleClick", function(event) {
        	$('#relatedOrdNo').val("");

            Common.ajax("GET", "/sales/order/preBooking/checkOldOrderId.do", {salesOrdNo : AUIGrid.getCellValue(prevOrdNoGridID , event.rowIndex , "salesOrdNo"), custId : $('#custId').val(), promoId : AUIGrid.getCellValue(prevOrdNoGridID , event.rowIndex , "promoId"), exTrade : $('#exTrade').val(), prodId : $('#prodId').val(), stkId : AUIGrid.getCellValue(prevOrdNoGridID , event.rowIndex , "stkId")}, function(RESULT) {
                console.log("DOUBLE CLICK - RESULT :: {} " +JSON.stringify(RESULT));
            	console.log("buss type" + AUIGrid.getCellValue(prevOrdNoGridID , event.rowIndex , "busType"));
                busType = AUIGrid.getCellValue(prevOrdNoGridID , event.rowIndex , "busType");

               if($('#isHomecare').val() != '2'){ //no product return
            	   if(RESULT.extrOptFlag == '1'){
                       $('#isReturnExtrade').attr("disabled",false);
                   }else{
                       $('#isReturnExtrade').attr("disabled",true);
                       $('#isReturnExtrade').prop("checked", true);
                   }
               }

                if(RESULT.rootState == 'ROOT_1') {
                    $('#lblOldOrderNo').text('<spring:message code="sal.alert.msg.oldOrdNoNotFound" />');
                }

                if(RESULT.rootState == 'ROOT_2') {
                    $('#lblOldOrderNo').text('Education and Free Trial type order is disallowed to register for ex-trade');
                }

                if(RESULT.rootState == 'ROOT_3') {
                    $('#lblOldOrderNo').text('<spring:message code="sal.alert.msg.invalidOrdNo" />');
                }

                if(RESULT.rootState == 'ROOT_4') {
                   $('#speclInstct').val(RESULT.instSpecInst);
                    Common.alert('<spring:message code="sal.alert.msg.chkOldOrdNo" />' + DEFAULT_DELIMITER + RESULT.msg, btnHidden_Valid_Click(RESULT.isInValid, AUIGrid.getCellValue(prevOrdNoGridID , event.rowIndex , "salesOrdNo"), AUIGrid.getCellValue(prevOrdNoGridID , event.rowIndex , "salesOrdId")));
                }

                if(RESULT.rootState == 'ROOT_5') {
                    $('#lblOldOrderNo').text('<spring:message code="sal.alert.msg.disallowExTrade2" />');
                }

                if(RESULT.rootState == 'ROOT_6') {
                    $('#speclInstct').val(RESULT.instSpecInst);
                    Common.alert('<spring:message code="sal.alert.msg.cnfrmProc" />' + DEFAULT_DELIMITER + RESULT.msg, btnHidden_Valid_Click(RESULT.isInValid, AUIGrid.getCellValue(prevOrdNoGridID , event.rowIndex , "salesOrdNo"), AUIGrid.getCellValue(prevOrdNoGridID , event.rowIndex , "salesOrdId")));
                }

                if(RESULT.rootState == 'ROOT_7') {
                    $('#txtOldOrderID').val(RESULT.oldOrderId);
                    $('#speclInstct').val(RESULT.instSpecInst);
                    $('#hiddenMonthExpired').val(RESULT.monthExpired);
                    btnHidden_Valid_Click(RESULT.isInValid, AUIGrid.getCellValue(prevOrdNoGridID , event.rowIndex , "salesOrdNo"), AUIGrid.getCellValue(prevOrdNoGridID , event.rowIndex , "salesOrdId"));
                }

                if(RESULT.rootState == 'ROOT_8') {
                    $('#lblOldOrderNo').text('<spring:message code="sal.alert.msg.usedExTrade" />');
                }

                if(RESULT.rootState == 'ROOT_9') {//checking for I-CARE Rental
                    Common.alert('<spring:message code="sal.alert.msg.chkOldOrdNo" />' + DEFAULT_DELIMITER + RESULT.msg);
                }

                if(RESULT.rootState == 'ROOT_10') {//checking for I-CARE
                    Common.alert('<spring:message code="sal.alert.msg.chkOldOrdNo" />' + DEFAULT_DELIMITER + RESULT.msg);
                }

                if(RESULT.rootState == '') {
                    fn_setData(AUIGrid.getCellValue(prevOrdNoGridID , event.rowIndex , "salesOrdNo"), AUIGrid.getCellValue(prevOrdNoGridID , event.rowIndex , "salesOrdId"))
                    $('#btnClose').click();
                }
            });
        });
    });

    function fn_setData(salesOrdNo,salesOrdId) {
        $('#relatedOrdNo').val(salesOrdNo);
        $('#txtOldOrderID').val(salesOrdId);
    }

    function createAUIGrid() {
        var columnLayout = [
            { headerText : "Order No",     dataField : "salesOrdNo", width : 120 }
          , { headerText : "App Type",     dataField : "appType",    width : 120 }
          , { headerText : "Product Code", dataField : "stkCode",    width : 120 }
          , { headerText : "Product Name", dataField : "stkDesc"}
          , { headerText : "Promo Id",     dataField : "promoId", visible  : false }
          , { headerText : "Order Id",     dataField : "salesOrdId" , visible  : false}
          , { headerText : "Business Type",     dataField : "busType" , visible  : false}
        ];

        var gridPros = {
            usePaging           : true,
            pageRowCount        : 5,
            editable            : false,
            fixedColumnCount    : 0,
            showStateColumn     : false,
            displayTreeOpen     : false,
            headerHeight        : 30,
            useGroupingPanel    : false,
            skipReadonlyColumns : true,
            wrapSelectionMove   : true,
            showRowNumColumn    : true,
            noDataMessage       : "No order found.",
            groupingMessage     : "Here groupping"
        };

        prevOrdNoGridID = GridCommon.createAUIGrid("grid_prev_ord_wrap", columnLayout, "", gridPros);
    }

    //Get previous order number
    function fn_getPrevOrderNo(){
        Common.ajax("GET", "/sales/order/preBooking/selectPrevOrderNoList.do", {custId : '${custId}', isHomecare : '${isHomecare}'}, function(result) {
            AUIGrid.setGridData(prevOrdNoGridID, result);
        });
    }

    function fn_selfClose() {
        $('#btnClose').click();
      }

    function btnHidden_Valid_Click(isInValid, salesOrdNo , salesOrdId) {
        $('#txtBusType').val(busType);
        if(isInValid == 'InValid') {
                fn_setData(salesOrdNo)
                $('#txtOldOrderID').val(salesOrdId);
                $('#btnClose').click();
        } else {
            fn_setData(salesOrdNo)
            $('#txtOldOrderID').val(salesOrdId);
            $('#btnClose').click();
        }
    }

</script>
</head>
<body>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Previous Order No.</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a id="btnClose" href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<section class="search_result"><!-- search_result start -->

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="grid_prev_ord_wrap" style="width:100%; height:220px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

<input type="hidden" id="custId" name="custId" value="${custId}"/>
<%-- <input type="hidden" id="prodId" name="prodId" value="${prodId}"/> --%> <!-- Used for extrade Neo to Neo Plus -->
<input type="hidden" id="exTrade" name="exTrade" value="${exTrade}"/>
<input type="hidden" id="isHomecare" name="exTrade" value="${isHomecare}"/>

<ul class="left_btns mb10">
    <li><p><span id="lblOldOrderNo" class="red_text"></span></p></li>
</ul>
</section><!-- search_result end -->

</section><!-- search_table end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->
