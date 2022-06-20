<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">
	//AUIGrid 생성 후 반환 ID
	var itemGridID;

	$(document).ready(function(){

	    // AUIGrid 그리드를 생성합니다.
	    createAUIitemGrid();

	    fn_getCnvrItmJsonAjax();

	});

	function createAUIitemGrid() {
        // AUIGrid 칼럼 설정

        // 데이터 형태는 다음과 같은 형태임,
        //[{"id":"#Cust0","date":"2014-09-03","name":"Han","country":"USA","product":"Apple","color":"Red","price":746400}, { .....} ];
        var columnLayout = [ {
                dataField : "orderNo",
                headerText : "<spring:message code='sal.text.ordNo' />",
                width : 90,
                editable : false,
                style: 'left_style'
            }, {
                dataField : "custId",
                headerText : "Customer ID",
                width : 90,
                editable : false,
                style: 'left_style'
            }, {
                dataField : "cardNo",
                headerText : "Card No",
                width : 120,
                editable : false,
                style: 'left_style'
            }, {
                dataField : "status",
                headerText : "<spring:message code='sal.text.status' />",
                width : 70,
                editable : false,
                style: 'left_style'
            }, {
                dataField : "resnDesc",
                headerText : "Fail Reason",
                width : 110,
                editable : false,
                style: 'left_style'
            }, {
                dataField : "udpDt",
                headerText : "Convert Date",
                dataType : "date",
                formatString : "dd/mm/yyyy" ,
                width : 110,
                editable : false,
                style: 'left_style'
            }];

        // 그리드 속성 설정
        var gridPros = {
            // 페이징 사용
            usePaging : true,
            // 한 화면에 출력되는 행 개수 20(기본값:20)
            pageRowCount : 10,
            editable : false,
            fixedColumnCount : 1,
            showStateColumn : false,
            displayTreeOpen : true,
            selectionMode : "multipleCells",
            headerHeight : 30,
            // 그룹핑 패널 사용
            useGroupingPanel : false,
            // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            skipReadonlyColumns : true,
            // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            wrapSelectionMove : true,
            // 줄번호 칼럼 렌더러 출력
            showRowNumColumn : true,
            groupingMessage : "Here groupping"
        };

        itemGridID = AUIGrid.create("#dt_grid_wrap", columnLayout, gridPros);
    }

	//Get Contact by Ajax
    function fn_getCnvrItmJsonAjax(){
        Common.ajax("GET", "/payment/batchTokenizeViewItmJsonList",$("#gridForm").serialize(), function(result) {
            AUIGrid.setGridData(itemGridID, result);
        });
    }

	function fn_all(){
		Common.ajax("GET", "/sales/order/orderConvertViewItmJsonList",$("#gridForm").serialize(), function(result) {
            AUIGrid.setGridData(itemGridID, result);
        });
	}

	function fn_valid(){
        Common.ajax("GET", "/sales/order/orderCnvrValidItmList",$("#gridForm").serialize(), function(result) {
            AUIGrid.setGridData(itemGridID, result);
        });
    }

	function fn_invalid(){
        Common.ajax("GET", "/sales/order/orderCnvrInvalidItmJsonList",$("#gridForm").serialize(), function(result) {
            AUIGrid.setGridData(itemGridID, result);
        });
    }

	function fn_success(){
		$("#_close").click();
		fn_searchListAjax();
		Common.popupDiv("/sales/order/conversionDetailPop.do", $("#searchForm").serializeJSON(), null, true, 'detailPop');
	}

	function fn_confirm(){
		var time = new Date();
		var day = time.getDate();

//		if( (day >= 26 || day == 1) && ($("#rsCnvrStusFrom").val() == 'REG') && ($("#rsCnvrStusTo").val() == 'INV')){
//		    Common.alert("This coversion type is not allowed from 26 until 1 next month.");
//		    return false;
//		}else{
//			if($("#allRows").val() <= 0){
//				Common.alert("<b>There are no item to convert in this conversion batch.<br />Confirm conversion batch is disallowed.");
//				return false;
//			}
//		}
		var msg = "<b><spring:message code='sal.alert.msg.thisConversionBatchWillProcess' /><br />";
		     msg += "<spring:message code='sal.alert.msg.areYouSureWantToConfirmConvtBatch' /></b>";
		Common.confirm(msg,fn_confirmOK);
	}

	function fn_confirmOK(){
		Common.ajax("GET", "/sales/order/updCnvrConfirm.do", $("#gridForm").serialize(), function(result){
            Common.alert("<spring:message code='sal.alert.msg.conversionConfirmed' />", fn_success);
        });
	}

	function fn_deactivate(){
		var msg = ("<b><spring:message code='sal.alert.msg.deactivateConversionBatch' /></b>");
		Common.confirm(msg,fn_deactivateOK);

    }

	function fn_deactivateOK(){
        Common.ajax("GET", "/sales/order/updCnvrDeactive.do", $("#gridForm").serialize(), function(result){
            Common.alert("<b><spring:message code='sal.alert.msg.conversionBatchDeactivated' /></b>", fn_success);
        });
    }
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="sal.page.title.conversionViewConfirm" /></h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#" id="_close"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<aside class="title_line"><!-- title_line start -->
<h3><spring:message code="sal.page.title.conversionBatchInfo" /></h3>

</aside><!-- title_line end -->

<form id="gridForm" name="gridForm" method="GET">

    <input type="hidden" id="batchId" name="batchId" value="${cnvrInfo.batchId}">
</form>
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:160px" />
    <col style="width:*" />
    <col style="width:170px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Batch No</th>
    <td><span>${cnvrInfo.batchNo }</span></td>
    <th scope="row"><spring:message code="sal.text.createAt" /></th>
    <td><span>${cnvrInfo.crtDt }</span></td>
    <th scope="row"><spring:message code="sal.text.createBy" /></th>
    <td><span>${cnvrInfo.crtUser }</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.batchStus" /></th>
    <td><span>${cnvrInfo.batchStatus }</span></td>
    <th scope="row"><spring:message code="sal.title.text.totItem" /></th>
    <td><span>${cnvrInfo.totalItem }</span></td>
    <%-- <th scope="row"><spring:message code="sal.title.text.statusrom" /></th>
    <td><span>${cnvrInfo.batchStatus }</span></td> --%>
    <%-- <th scope="row"><spring:message code="sal.title.text.statusTo" /></th>
    <td><span>${cnvrInfo.payCnvrStusTo }</span></td> --%>
</tr>
<%--
<tr>
    <th scope="row"><spring:message code="sal.text.remark" /></th>
    <td colspan="5"><span>${cnvrInfo.payCnvrRem }</span></td>
</tr> --%>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h3><spring:message code="sal.title.text.batchItem" /></h3>
</aside><!-- title_line end -->



<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="dt_grid_wrap" style="width:100%; height:280px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end-->

