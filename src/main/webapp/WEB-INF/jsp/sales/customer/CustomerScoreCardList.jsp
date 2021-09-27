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
			$("#reportFileName").val("");
			$("#reportDownFileName").val("");
			$("#viewType").val("");

			var custId = $("#custId").val().trim();
			var custIc = $("#custIc").val().trim();

			GridCommon.exportTo("grid_wrap", "xlsx", "Order Listing"); /*this jus for test have to change to PDF*/
		}
	}
	/* function fn_report(viewType){

	    $("#reportFileName").val("");
	    $("#reportDownFileName").val("");
	    $("#viewType").val("");

	    var orderNoFrom = "";
	    var orderNoTo = "";
	    var orderDateFrom = "";
	    var orderDateTo = "";
	    var branchRegion = "";
	    var keyInBranch = "";
	    var appType = "";
	    var sortBy = "";
	    var whereSQL = "";
	    var extraWhereSQL = "";
	    var orderBySQL = "";
	    var custName = "";
	    var runNo = 0;


	    if($('#cmbAppType :selected').length > 0){
	        whereSQL += " AND (";

	        $('#cmbAppType :selected').each(function(i, mul){
	            if(runNo > 0){
	                whereSQL += " OR som.APP_TYPE_ID = '"+$(mul).val()+"' ";
	                appType += ", "+$(mul).text();

	            }else{
	                whereSQL += " som.APP_TYPE_ID = '"+$(mul).val()+"' ";
	                appType += $(mul).text();

	            }
	            runNo += 1;
	        });
	        whereSQL += ") ";
	    }
	    runNo = 0;

	    var txtOrderNoFr = $("#txtOrderNoFr").val().trim();
	    var txtOrderNoTo = $("#txtOrderNoTo").val().trim();
	    if(!(txtOrderNoFr == null || txtOrderNoFr.length == 0) && !(txtOrderNoTo == null || txtOrderNoTo.length == 0)){
	        orderNoFrom = txtOrderNoFr;
	        orderNoTo = txtOrderNoTo;
	        whereSQL += " AND (som.SRV_ORD_NO BETWEEN '"+txtOrderNoFr+"' AND '"+txtOrderNoTo+"')";
	    }
	    if($("#cmbKeyBranch :selected").index() > 0){
	        keyInBranch = $("#cmbKeyBranch :selected").val();
	        whereSQL += " AND som.BRNCH_ID = '"+$("#cmbKeyBranch :selected").val()+"'";
	    }
	    if(!($("#txtCustName").val().trim() == null || $("#txtCustName").val().trim().length == 0)){
	        custName = $("#txtCustName").val().trim();
	        whereSQL += " AND cust.NAME LIKE '%"+custName.replace("'", "''")+"%' ";
	    }
	    if($("#cmbUser :selected").index() > 0){
	        whereSQL += " AND som.CRT_USER_ID = '"+$("#cmbUser :selected").val()+"'";
	    }
	    if($("#cmbSort :selected").index() > -1){
	        sortBy = $("#cmbSort :selected").text();

	        if($("#cmbSort :selected").val() == "1"){
	            orderBySQL = " ORDER BY t2.CODE_NAME, b.CODE, t.CODE_NAME, som.SRV_ORD_NO";
	        }else if($("#cmbSort :selected").val() == "2"){
	            orderBySQL = " ORDER BY b.CODE, t.CODE_NAME, som.SRV_ORD_NO";
	        }else if($("#cmbSort :selected").val() == "3"){
	            orderBySQL = " ORDER BY som.SALES_DT, t.CODE_NAME, som.SRV_ORD_NO";
	        }else if($("#cmbSort :selected").val() == "4"){
	            orderBySQL = " ORDER BY som.SRV_ORD_NO, t.CODE_NAME";
	        }else if($("#cmbSort :selected").val() == "5"){
	            orderBySQL = " ORDER BY cust.NAME, som.SRV_ORD_NO";
	        }
	    }

	    var date = new Date().getDate();
	    if(date.toString().length == 1){
	        date = "0" + date;
	    }
	    $("#reportDownFileName").val("CareServicePayListing_"+date+(new Date().getMonth()+1)+new Date().getFullYear());


	     if(viewType == "PDF"){
	        $("#form #viewType").val("PDF");
	        $("#form #reportFileName").val("/homecare/CSPaymentListing_PDF_New.rpt");
	    }

	    $("#form #V_ORDERNOFROM").val(orderNoFrom);
	    $("#form #V_ORDERNOTO").val(orderNoTo);
	    $("#form #V_ORDERDATEFROM").val(orderDateFrom);
	    $("#form #V_ORDERDATETO").val(orderDateTo);
	    $("#form #V_BRANCHREGION").val(branchRegion);
	    $("#form #V_KEYINBRANCH").val(keyInBranch);
	    $("#form #V_APPTYPE").val(appType);
	    $("#form #V_CUSTNAME").val(custName);
	    $("#form #V_SORTBY").val(sortBy);
	    $("#form #V_WHERESQL").val(whereSQL);
	    $("#form #V_ORDERBYSQL").val(orderBySQL);
	    $("#form #V_SELECTSQL").val("");
	    $("#form #V_FULLSQL").val("");


	    // 프로시져로 구성된 경우 꼭 아래 option을 넘겨야 함.
	    var option = {
	            isProcedure : true // procedure 로 구성된 리포트 인경우 필수.  => /payment/PaymentListing_Excel.rpt 는 프로시져로 구성된 파일임.
	    };

	    Common.report("form", option);

	} */
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

	<input type="hidden" id="reportFileName" name="reportFileName" value="" />
	<input type="hidden" id="viewType" name="viewType" value="" />
	<input type="hidden" id="reportDownFileName" name="reportDownFileName"	 value="" />
	<input type="hidden" id="V_CUST_ID"	name="V_CUST_ID" value="" />
	<input type="hidden" id="V_NRIC" name="V_NRIC" value="" />
	<input type="hidden" id="V_ORDERDATEFROM" name="V_ORDERDATEFROM" value="" />
    <input type="hidden" id="V_SORTBY" name="V_SORTBY" value="" />
    <input type="hidden" id="V_WHERESQL" name="V_WHERESQL" value="" />
    <input type="hidden" id="V_EXTRAWHERESQL" name="V_EXTRAWHERESQL" value="" />
	<input type="hidden" id="V_ORDERBYSQL" name="V_ORDERBYSQL" value="" />
	<input type="hidden" id="V_SELECTSQL" name="V_SELECTSQL" value="" />
	<input type="hidden" id="V_FULLSQL" name="V_FULLSQL" value="" />

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
