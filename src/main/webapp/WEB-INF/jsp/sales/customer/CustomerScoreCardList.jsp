<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">
	//AUIGrid 생성 후 반환 ID
	var custGridID;
	var gridViewData = null;

	// popup 크기
	var option = {
		width : "1200px", // 창 가로 크기
		height : "500px" // 창 세로 크기
	};

	var basicAuth = false;

	$(document).ready(function() {

		/* alert("Hello World"); */
		createAUIGrid();

	});

	function createAUIGrid() {
		// AUIGrid 칼럼 설정

		// 데이터 형태는 다음과 같은 형태임,
		//[{"id":"#Cust0","date":"2014-09-03","name":"Han","country":"USA","product":"Apple","color":"Red","price":746400}, { .....} ];
		var columnLayout = [ {
			headerText : "<spring:message code='sales.OrderNo'/>",
			dataField : "ordNo",
			editable : false
		}, {
			headerText : "<spring:message code='sales.RentalStatus'/>",
			dataField : "ordStusCode",
			editable : false
		}, {
			headerText : "<spring:message code='sales.AppType'/>",
			dataField : "appTypeCode",
			editable : false
		}, {
			headerText : "<spring:message code='sales.ordDt'/>",
			dataField : "ordDt",
			dataType : "date",
			formatString : "dd/mm/yyyy",
			editable : false
		}, {
			headerText : "<spring:message code='sales.insDt'/>",
			dataField : "insDt",
			dataType : "date",
			formatString : "dd/mm/yyyy",
			editable : false
		}, {
			headerText : "<spring:message code='sales.prod'/>",
			dataField : "productName",
			editable : false
		}, {
			headerText : "<spring:message code='sales.insAddr'/>",
			dataField : "insAddr",
			editable : false,
			width : 200
		}, {
			headerText : "<spring:message code='sales.payMode'/>",
			dataField : "payMode",
			editable : false
		}, {
			headerText : "<spring:message code='sales.agingMonth'/>",
			dataField : "agingMonth",
			editable : false
		}, {
			headerText : "<spring:message code='sales.outAmt'/>",
			dataField : "outAmt",
			editable : false
		}, {
			headerText : "<spring:message code='sales.memStus'/>",
			dataField : "memStus",
			editable : false,
			width : 100
		} ];

		// 그리드 속성 설정
		var gridPros = {

			// 페이징 사용
			usePaging : true,

			// 한 화면에 출력되는 행 개수 20(기본값:20)
			pageRowCount : 20,

			editable : true,

			fixedColumnCount : 1,

			showStateColumn : false,

			displayTreeOpen : true,

			//     selectionMode : "multipleCells",

			headerHeight : 30,

			// 그룹핑 패널 사용
			useGroupingPanel : false,

			// 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
			skipReadonlyColumns : true,

			// 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
			wrapSelectionMove : true,

			// 줄번호 칼럼 렌더러 출력
			showRowNumColumn : true
		};

		//custGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout, gridPros);
		custGridID = AUIGrid.create("#grid_wrap", columnLayout, gridPros);
	}

	// Customer Score Cardsearch function
	function fn_customerScoreCardListAjax() {
		var isValid = true;

		if (FormUtil.isEmpty($("#custId").val())
				&& FormUtil.isEmpty($("#custIc").val())) {
			Common
					.alert("<spring:message code='customer.alert.msg.customeridNricblank' />");
			return;
		}

		else {
			Common.ajax("GET", "/sales/customer/customerScoreCardList", $(
					"#searchForm").serialize(), function(result) {
				console.log("----------------------------");
				console.log(result);
				gridViewData = result;
				if (result != null && result.length == 0) {
					gridViewData = null;
				}
				AUIGrid.setGridData(custGridID, result);
			});
		}
	}

	//Generate pdf report button
	function fn_excelDown(result) {

		if (result == null) {
			Common
					.alert("<spring:message code='customer.alert.msg.nodataingridview' />");
		} else {
			/* $("#reportFileName").val("");
			$("#reportDownFileName").val("");
			$("#viewType").val("");

			var custId = $("#custId").val().trim();
			var custIc = $("#custIc").val().trim();

			GridCommon.exportTo("grid_wrap", "xlsx", "Order Listing"); //this jus for test have to change to PDF
			 */
			fn_report("PDF");
		}
	}
	function fn_report(viewType){

	    $("#reportFileName").val("");
	    $("#reportDownFileName").val("");
	    $("#viewType").val("");

	    var v_WhereSQL = "";
	    var V_CUST_ID = $("#custId").val().trim();
        var V_NRIC = $("#custIc").val().trim();

        if(V_CUST_ID == null || V_CUST_ID.length == 0){
        	V_CUST_ID = 0;
        }
	    if(V_NRIC == null || V_NRIC.length == 0){
	    	v_WhereSQL = "and  A.CUST_ID = '"+V_CUST_ID+"'";

	    }
	    else{
	    	v_WhereSQL = "and  A.NRIC = '"+V_NRIC+"'";
	    }

	    console.log( "v_WhereSQL" + v_WhereSQL );
	    console.log( "V_CUST_ID" + V_CUST_ID);
	    console.log( "V_NRIC" + V_NRIC);
	    var date = new Date().getDate();
	    if(date.toString().length == 1){
	        date = "0" + date;
	    }
	    $("#reportDownFileName").val("CSPaymentListing_"+date+(new Date().getMonth()+1)+new Date().getFullYear());
        $("#form #viewType").val("PDF");
        $("#form #reportFileName").val("/sales/CustomerScoreCard_PDF_New.rpt");

	    $("#form #v_WhereSQL").val(v_WhereSQL);
	    $("#form #V_CUST_ID").val(V_CUST_ID);
	    $("#form #V_NRIC").val(V_NRIC);

	    // 프로시져로 구성된 경우 꼭 아래 option을 넘겨야 함.
	    var option = {
	            isProcedure : true // procedure 로 구성된 리포트 인경우 필수.  => /payment/PaymentListing_Excel.rpt 는 프로시져로 구성된 파일임.
	    };

	    Common.report("form", option);

	}
</script>
<section id="content">
	<!-- content start -->
	<ul class="path">
		<li><img
			src="${pageContext.request.contextPath}/resources/images/common/path_home.gif"
			alt="Home" /></li>
		<li>Sales</li>
		<li>Customer</li>
		<li>Customer Score Card</li>
	</ul>

	<aside class="title_line">
		<!-- title_line start -->
		<p class="fav">
			<a href="#" class="click_add_on">My menu</a>
		</p>
		<h2>
			<spring:message code="sal.title.text.custScoreCardList" />
		</h2>

		<ul class="right_btns">
			<c:if test="${PAGE_AUTH.funcView == 'Y'}">
				<li><p class="btn_blue">
						<a href="#" onclick="javascript:fn_customerScoreCardListAjax()">
							<span class="search"></span> <spring:message
								code="sal.btn.search" />
						</a>
					</p></li>
			</c:if>


		</ul>
	</aside>
	<!-- title_line end -->


	<section class="search_table">
		<!-- search_table start -->
		<form id="searchForm" name="searchForm" action="#" method="post">
			<table class="type1">
				<!-- table start -->
				<caption>table</caption>
				<colgroup>
					<col style="width: 140px" />
					<col style="width: *" />
					<col style="width: 130px" />
					<col style="width: *" />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row"><spring:message code="sal.text.customerId" /></th>
						<td><input type="text" title="Customer ID" id="custId"
							name="custId" placeholder="Customer ID (Number Only)"
							class="w100p" /></td>
						<th scope="row"><spring:message
								code="sal.title.text.nricCompNo" /></th>
						<td><input type="text" title="NRIC/Company No" id="custIc"
							name="custIc" placeholder="NRIC / Company Number" class="w100p" " />
						</td>
					</tr>
				</tbody>
			</table>
			<!-- table end -->


		</form>
	</section>
	<!-- search_table end -->

	<ul class="right_btns">
		<li><p class="btn_grid">
				<a href="#" onClick="fn_excelDown(gridViewData)"><spring:message
						code='service.btn.Generate' /></a>
			</p></li>
	</ul>

<form id="form">
	<input type="hidden" id="reportFileName" name="reportFileName" value="" />
	<input type="hidden" id="viewType" name="viewType" value="" />
	<input type="hidden" id="reportDownFileName" name="reportDownFileName"	 value="" />
	<input type="hidden" id="V_CUST_ID"	name="V_CUST_ID" value="" />
	<input type="hidden" id="V_NRIC" name="V_NRIC" value="" />
	<input type="hidden" id="v_WhereSQL" name="v_WhereSQL" value="" />
</form>
	<section class="search_result">
		<!-- search_result start -->
		<article class="grid_wrap">
			<!-- grid_wrap start -->
			<div id="grid_wrap"
				style="width: 100%; height: 480px; margin: 0 auto;"></div>
		</article>
		<!-- grid_wrap end -->
	</section>
	<!-- search_result end -->
</section>
<!-- content end -->
