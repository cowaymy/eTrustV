<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<head>
<script type="text/javaScript" language="javascript">

    //AUIGrid 생성 후 반환 ID
    var pwpOrdNoGridID;
//     var busType;

    $(document).ready(function(){
    	console.log('pwpOrderNoPop.jsp');
        //AUIGrid 그리드를 생성합니다.
        createAUIGrid();

        fn_getPwpOrderNo();

        // 셀 더블클릭 이벤트 바인딩
        AUIGrid.bind(pwpOrdNoGridID, "cellDoubleClick", function(event) {
        	$('#pwpNo').val("");
        	$('#lblPwpOrderNo').text("");

        	var salesOrdNo= AUIGrid.getCellValue(pwpOrdNoGridID , event.rowIndex , "salesOrdNo");

	       	Common.ajax("GET", "/homecare/sales/order/checkPwpOrderId.do", {salesOrdNo : salesOrdNo, custId : $('#custId').val()}, function(RESULT) {

	       	    if(RESULT.ispass == true){
	       	    	fn_setData(salesOrdNo, RESULT.mainOrderId);
                    $('#btnPwpOrderNo').click();
	       	    }else{
	       	    	$('#lblPwpOrderNo').text(RESULT.msg);
	       	    }
            });

//         	// [S] PWP VALIDATION
//         	if(status == 1 || status == 4){ // only active and completed with valid svm allow to do PWP
//         		if(status = 4 ){
//         			var now = new Date();
//                     var dd = String(now.getDate()).padStart(2, '0');
//                     var mm = String(now.getMonth() + 1).padStart(2, '0'); //January is 0!
//                     var yyyy = now.getFullYear();

//                     now = mm + '/' + dd + '/' + yyyy;

//                     var today = new Date(now);
//                     var expDt = new Date(svmExpDt);

//                     if(today > expDt || svmExpDt == undefined){
//                     	$('#lblPwpOrderNo').text('* Expired or without membership is disallowed to register for PWP!');
//                     }else{
//                     	fn_setData(AUIGrid.getCellValue(pwpOrdNoGridID , event.rowIndex , "salesOrdNo"))
//                         $('#btnPwpOrderNo').click();
//                     }

//         		}else{
//         			fn_setData(AUIGrid.getCellValue(pwpOrdNoGridID , event.rowIndex , "salesOrdNo"))
//                     $('#btnPwpOrderNo').click();
//         		}
//         	}else{
//         		$('#lblPwpOrderNo').text('* Order status not under ACT and COM is disallowed to register for PWP!');
//         	}

        });
    });

    function fn_setData(salesOrdNo, salesOrdId) {
    	$("#txtMainPwpOrderID").val(salesOrdId);
        $('#pwpNo').val(salesOrdNo);
//         fn_checkPromotionExtradeAvail();
    }

    function createAUIGrid() {

        //AUIGrid 칼럼 설정
        var columnLayout = [
            { headerText : "Order No",     dataField : "salesOrdNo", width : 120 }
          , { headerText : "App Type",     dataField : "appType",    width : 120 }
          , { headerText : "Product Code", dataField : "stkCode",    width : 120 }
          , { headerText : "Product Name", dataField : "stkDesc"}
          , { headerText : "Order Id",     dataField : "salesOrdId" , visible  : false}
          , { headerText : "Status",     dataField : "status" , visible  : true}
          , { headerText : "Membership Start Date",     dataField : "srvStartDt" , visible  : true}
          , { headerText : "Membership End Date",     dataField : "srvExprDt" , visible  : true}
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

        pwpOrdNoGridID = GridCommon.createAUIGrid("grid_pwp_ord_wrap", columnLayout, "", gridPros);
    }

    //Get Contact by Ajax
    function fn_getPwpOrderNo(){
        Common.ajax("GET", "/homecare/sales/order/selectPwpOrderNoList.do", {custId : '${custId}'}, function(result) {
            AUIGrid.setGridData(pwpOrdNoGridID, result);
        });
    }

    function fn_selfClose() {
        $('#btnPwpOrderNo').click();
      }

//     function btnHidden_Valid_Click(isInValid, salesOrdNo , salesOrdId) {
//         $('#txtBusType').val(busType);
//         if(isInValid == 'InValid') {
//                 fn_setData(salesOrdNo)
//                 $('#txtOldOrderID').val(salesOrdId);
//                 $('#btnPrevOrderNo').click();
//         }

//         else {
//             fn_setData(salesOrdNo)
//             $('#txtOldOrderID').val(salesOrdId);
//             $('#btnPrevOrderNo').click();
//         }
//     }

</script>
</head>
<!-- <body> -->

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

	<header class="pop_header"><!-- pop_header start -->
	<h1>PWP Order No.</h1>
	<ul class="right_opt">
	    <li><p class="btn_blue2"><a id="btnPwpOrderNo" href="#">CLOSE</a></p></li>
	</ul>
	</header><!-- pop_header end -->

	<section class="pop_body"><!-- pop_body start -->
		<section class="search_result"><!-- search_result start -->
			<article class="grid_wrap"><!-- grid_wrap start -->
			<div id="grid_pwp_ord_wrap" style="width:100%; height:220px; margin:0 auto;"></div>
			</article><!-- grid_wrap end -->

			<input type="hidden" id="custId" name="custId" value="${custId}"/>

			<ul class="left_btns mb10">
			    <li><p><span id="lblPwpOrderNo" class="red_text"></span></p></li>
			</ul>
		</section><!-- search_result end -->
	</section><!-- search_table end -->
</div><!-- popup_wrap end -->
