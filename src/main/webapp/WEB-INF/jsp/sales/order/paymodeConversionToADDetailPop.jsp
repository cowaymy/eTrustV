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
	function fn_downloadReport(){
	    var reportDownFileName = "BatchConversion_"+$('#batchId').val(); //report name
	    var reportFileName = "/sales/BatchConvertTOADReport.rpt"; //reportFileName
	    var reportViewType = "EXCEL"; //viewType


	    var $reportParameter = $("#reportParameter")[0];
	    $($reportParameter).empty(); //remove children
	    //default input setting
	    $($reportParameter).append('<input type="hidden" id="reportFileName" name="reportFileName"  /> ');//report file name
	    $($reportParameter).append('<input type="hidden" id="reportDownFileName" name="reportDownFileName" /> '); // download report name
	    $($reportParameter).append('<input type="hidden" id="viewType" name="viewType" /> '); // download report  type
	    $($reportParameter).append('<input type="hidden" id="batch_id" name="batch_id"  /> ');
	    $("#reportParameter #reportFileName").val(reportFileName);
	    $("#reportParameter #reportDownFileName").val(reportDownFileName);
	    $("#reportParameter #viewType").val(reportViewType);
	    $("#viewType").val("EXCEL");
	    $("#batch_id").val($('#batchId').val());

	    // 프로시져로 구성된 경우 꼭 아래 option을 넘겨야 함.
	    var option = {
	            isProcedure : true // procedure 로 구성된 리포트 인경우 필수.  => /payment/PaymentListing_Excel.rpt 는 프로시져로 구성된 파일임.
	    };
	    Common.report("reportParameter", option);
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
<form name="reportParameter" id="reportParameter" method="post"></form>
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
<p class="btn_blue right_opt"><a href="javascript:fn_downloadReport();">Download Report</a></p>
</aside><!-- title_line end -->



<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="dt_grid_wrap" style="width:100%; height:280px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end-->

