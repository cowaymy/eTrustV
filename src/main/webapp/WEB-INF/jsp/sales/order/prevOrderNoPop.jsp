<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<head>
<script type="text/javaScript" language="javascript">

    //AUIGrid 생성 후 반환 ID
    var prevOrdNoGridID;
    var busType;

    $(document).ready(function(){
    	console.log('prevOrderNoPop.jsp');
        //AUIGrid 그리드를 생성합니다.
        createAUIGrid();

        fn_getPrevOrderNo();

        // 셀 더블클릭 이벤트 바인딩
        AUIGrid.bind(prevOrdNoGridID, "cellDoubleClick", function(event) {
        	$('#relatedNo').val("");

           //** Start exTrade Neo to Neo Plus **//
		   //             if($('#prodId').val() == null || $('#prodId').val() == ''){
		   //             	Common.alert("Please select a product.");
		   //             	$('#btnPrevOrderNo').click();
		   //             }else{
	       //** End exTrade Neo to Neo Plus **//

            Common.ajax("GET", "/sales/order/checkOldOrderId.do", {salesOrdNo : AUIGrid.getCellValue(prevOrdNoGridID , event.rowIndex , "salesOrdNo"), custId : $('#custId').val(), promoId : AUIGrid.getCellValue(prevOrdNoGridID , event.rowIndex , "promoId"), exTrade : $('#exTrade').val(), prodId : $('#prodId').val(), stkId : AUIGrid.getCellValue(prevOrdNoGridID , event.rowIndex , "stkId")
            	,refNo : AUIGrid.getCellValue(prevOrdNoGridID , event.rowIndex , "refNo")}, function(RESULT) {
                //console.log('RESULT ROOT_STATE  :'+RESULT.rootState);
                //console.log('RESULT IS_IN_VALID :'+RESULT.isInValid);
                //console.log('RESULT MSG         :'+RESULT.msg);
                //console.log('RESULT OLD_ORDER_ID:'+RESULT.oldOrderId);
                //console.log('RESULT INST_SPEC_INST:'+RESULT.instSpecInst);
                //console.log("buss type" + AUIGrid.getCellValue(prevOrdNoGridID , event.rowIndex , "busType"));
                busType = AUIGrid.getCellValue(prevOrdNoGridID , event.rowIndex , "busType");
                //console.log('RESULT EXTR_OPT_FLAG:'+RESULT.extrOptFlag);
                //console.log('RESULT MONTH EXPIRED:'+RESULT.monthExpired);

                //$('#txtOldOrderID').val(RESULT.oldOrderId);
               // $('#relatedNo').val($('#rwOldOrder').val());
               if($('#isHomecare').val() != '2'){ //no product return
            	   if(RESULT.extrOptFlag == '1'){
                       $('#isReturnExtrade').attr("disabled",false);
                   }else{
                       $('#isReturnExtrade').attr("disabled",true);
                       $('#isReturnExtrade').prop("checked", true);
                   }
               }

                if(RESULT.rootState == 'ROOT_1') {
                    //$('#rwOldOrder').clearForm();
                    $('#lblOldOrderNo').text('<spring:message code="sal.alert.msg.oldOrdNoNotFound" />');
                }
                if(RESULT.rootState == 'ROOT_2') {
                    //$('#rwOldOrder').clearForm();
                    //$('#lblOldOrderNo').text('<spring:message code="sal.alert.msg.disallowExTrade" />');
                    $('#lblOldOrderNo').text('Education and Free Trial type order is disallowed to register for ex-trade');
                }
                if(RESULT.rootState == 'ROOT_3') {
                    //$('#rwOldOrder').clearForm();
                    $('#lblOldOrderNo').text('<spring:message code="sal.alert.msg.invalidOrdNo" />');
                }
                if(RESULT.rootState == 'ROOT_4') {
                    //$('#oldOrderCloseBtn').click();
                    $('#speclInstct').val(RESULT.instSpecInst);
                    $('#hiddenMonthExpired').val(RESULT.monthExpired);
                    $('#hiddenPreBook').val(0); //$('#hiddenPreBook').val(RESULT.preBook);
                    Common.alert('<spring:message code="sal.alert.msg.chkOldOrdNo" />' + DEFAULT_DELIMITER + RESULT.msg, btnHidden_Valid_Click(RESULT.isInValid, AUIGrid.getCellValue(prevOrdNoGridID , event.rowIndex , "salesOrdNo"), AUIGrid.getCellValue(prevOrdNoGridID , event.rowIndex , "salesOrdId")));
                }
                if(RESULT.rootState == 'ROOT_5') {
                    //$('#rwOldOrder').clearForm();
                    $('#lblOldOrderNo').text('<spring:message code="sal.alert.msg.disallowExTrade2" />');
                }
                if(RESULT.rootState == 'ROOT_6') {
                    //$('#oldOrderCloseBtn').click();
                    $('#speclInstct').val(RESULT.instSpecInst);
                    $('#hiddenMonthExpired').val(RESULT.monthExpired);
                    $('#hiddenPreBook').val(0); //$('#hiddenPreBook').val(RESULT.preBook);
                    Common.alert('<spring:message code="sal.alert.msg.cnfrmProc" />' + DEFAULT_DELIMITER + RESULT.msg, btnHidden_Valid_Click(RESULT.isInValid, AUIGrid.getCellValue(prevOrdNoGridID , event.rowIndex , "salesOrdNo"), AUIGrid.getCellValue(prevOrdNoGridID , event.rowIndex , "salesOrdId")));
                }
                if(RESULT.rootState == 'ROOT_7') {
                    $('#txtOldOrderID').val(RESULT.oldOrderId);
                    $('#speclInstct').val(RESULT.instSpecInst);
                    $('#hiddenMonthExpired').val(RESULT.monthExpired);
                    $('#hiddenPreBook').val(0); //$('#hiddenPreBook').val(RESULT.preBook);
                    btnHidden_Valid_Click(RESULT.isInValid, AUIGrid.getCellValue(prevOrdNoGridID , event.rowIndex , "salesOrdNo"), AUIGrid.getCellValue(prevOrdNoGridID , event.rowIndex , "salesOrdId"));
                    //fn_popOrderDetail();
                    //$('#oldOrderCloseBtn').click();
                }
                if(RESULT.rootState == 'ROOT_8') {
                    //$('#rwOldOrder').clearForm();
                    $('#lblOldOrderNo').text('<spring:message code="sal.alert.msg.usedExTrade" />');
                }
                if(RESULT.rootState == 'ROOT_9') {//checking for I-CARE Rental
                    //$('#rwOldOrder').clearForm();
                    Common.alert('<spring:message code="sal.alert.msg.chkOldOrdNo" />' + DEFAULT_DELIMITER + RESULT.msg);
                }
                if(RESULT.rootState == 'ROOT_10') {//checking for I-CARE
                    //$('#rwOldOrder').clearForm();
                    Common.alert('<spring:message code="sal.alert.msg.chkOldOrdNo" />' + DEFAULT_DELIMITER + RESULT.msg);
                }
            });
            //fn_setData(AUIGrid.getCellValue(prevOrdNoGridID , event.rowIndex , "salesOrdNo"))
            //$('#btnPrevOrderNo').click();
//             }
        });

    });

    function fn_setData(salesOrdNo) {
        $('#relatedNo').val(salesOrdNo);
        fn_checkPromotionExtradeAvail();
    }

    function createAUIGrid() {

        //AUIGrid 칼럼 설정
        var columnLayout = [
            { headerText : "Order No",     dataField : "salesOrdNo", width : 120 }
          , { headerText : "Old Ord Sof No",     dataField : "refNo",    width : 120 }
          , { headerText : "App Type",     dataField : "appType",    width : 120 }
          , { headerText : "Product Code", dataField : "stkCode",    width : 120 }
          , { headerText : "Product Name", dataField : "stkDesc"}
          , { headerText : "Promo Id",     dataField : "promoId", visible  : false }
          , { headerText : "Order Id",     dataField : "salesOrdId" , visible  : false}
          , { headerText : "Business Type",     dataField : "busType" , visible  : false}
//           , { headerText : "Stock Id",     dataField : "stkId" , visible  : false}  // Used for exTrade Neo to NeoPlus
            ];

        //그리드 속성 설정
        var gridPros = {
            usePaging           : true,         //페이징 사용
            pageRowCount        : 5,            //한 화면에 출력되는 행 개수 20(기본값:20)
            editable            : false,
            fixedColumnCount    : 0,
            showStateColumn     : false,
            displayTreeOpen     : false,
          //selectionMode       : "singleRow",  //"multipleCells",
            headerHeight        : 30,
            useGroupingPanel    : false,        //그룹핑 패널 사용
            skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력
            noDataMessage       : "No order found.",
            groupingMessage     : "Here groupping"
        };

        prevOrdNoGridID = GridCommon.createAUIGrid("grid_prev_ord_wrap", columnLayout, "", gridPros);
    }

    $(function(){

    });

    //Get Contact by Ajax
    function fn_getPrevOrderNo(){
        Common.ajax("GET", "/sales/order/selectPrevOrderNoList.do", {custId : '${custId}', isHomecare : '${isHomecare}'}, function(result) {
            AUIGrid.setGridData(prevOrdNoGridID, result);
        });
    }

    function fn_selfClose() {
        $('#btnPrevOrderNo').click();
      }

    function btnHidden_Valid_Click(isInValid, salesOrdNo , salesOrdId) {
        //console.log('btnHidden_Valid_Click CALL START');
        //console.log('isInValid :'+isInValid);

        $('#txtBusType').val(busType);
        if(isInValid == 'InValid') {
                fn_setData(salesOrdNo)
                $('#txtOldOrderID').val(salesOrdId);
                $('#btnPrevOrderNo').click();
        }

        else {
            fn_setData(salesOrdNo)
            $('#txtOldOrderID').val(salesOrdId);
            $('#btnPrevOrderNo').click();
        }
    }

</script>
</head>
<body>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Previous Order No.</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a id="btnPrevOrderNo" href="#">CLOSE</a></p></li>
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
