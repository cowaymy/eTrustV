<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">
	var custGridID;
	var gridViewData = null;
    var optionState = {chooseMessage: " Choose One "};

	var option = {
		width : "1200px", // 창 가로 크기
		height : "500px" // 창 세로 크기
	};

	var basicAuth = false;

	$(document).ready(function() {
		createAUIGrid();

        CommonCombo.make('mState', "/sales/customer/selectMagicAddressComboList", '' , '', optionState);
        appendLoyaltyCategory();
//         appendNextProductCategory();
	});

	$.fn.clearForm = function() {
	    return this.each(function() {
	        var type = this.type, tag = this.tagName.toLowerCase();
	        if (tag === 'form'){
	            return $(':input',this).clearForm();
	        }
	        if (type === 'text' || type === 'password' || type === 'hidden' || tag === 'textarea'){
	            this.value = '';
	        }
	        if (type === 'checkbox' || type === 'radio'){
	            this.checked = false;
	        }
	        if (tag === 'select'){
	            this.selectedIndex = -1;
	        }
	    });
	};

	function createAUIGrid() {
		var columnLayout = [ {
			headerText : "CID",
			dataField : "custId",
			width : "10%" ,
			editable : false
		}, {
			headerText : "Name",
			dataField : "name",
			width : "60%" ,
			editable : false
		}, {
			headerText : "NRIC",
			dataField : "nric",
			width : "15%" ,
			editable : false
		}, {
			dataField : "undefined",
            headerText : "360°",
            width : '15%',
            renderer : {
                     type : "ButtonRenderer",
                     labelText : "Generate",
                     onclick : function(rowIndex, columnIndex, value, item) {
                         fn_reportDownload(item.custId, item.nric);
                   }
            }
		} ];

		var gridPros = {
				usePaging : true,
				pageRowCount : 20,
				editable : true,
				fixedColumnCount : 1,
				showStateColumn : false,
				displayTreeOpen : true,
				headerHeight : 30,
				useGroupingPanel : false,
				skipReadonlyColumns : true,
				wrapSelectionMove : true,
				showRowNumColumn : true,
				wordWrap :  true
		};
		custGridID = AUIGrid.create("#grid_wrap", columnLayout, gridPros);
	}

	// Customer Score Cardsearch function
	function fn_customerScoreCardListAjax() {
		var filterCount = 0;
		if(!FormUtil.isEmpty($("#custId").val())){
			filterCount = 2;
		}
        if(!FormUtil.isEmpty($("#custIc").val())){
            filterCount = 2;
        }

        if(!FormUtil.isEmpty($("#mLoyalty").val())){
            filterCount++;
        }

        if(!FormUtil.isEmpty($("#mState").val())){
            filterCount++;
        }

		if (filterCount <= 1) {
			//&& FormUtil.isEmpty($("#mBrandCredit").val()) && FormUtil.isEmpty($("#mRePurcFlag").val())) {
			Common.alert("A minimum of 2 filtering criteria must be Inserted/Selected");
			return;
		} else {
			Common.ajax("GET", "/sales/customer/customer360ScoreCardList", $("#searchForm").serialize(), function(result) {
				console.log("----------------------------");
				gridViewData = result;
				if (result != null && result.length == 0) {
					gridViewData = null;
				}
				AUIGrid.setGridData(custGridID, result);
			});
		}
	}

	//Generate pdf report button
	function fn_reportDownload(custId, nric) {
		$("#reportFileName").val("");
		$("#reportDownFileName").val("");
		$("#viewType").val("");

		var v_WhereSQL = "";
		var V_CUST_ID = custId;
		var V_NRIC = nric;
        var V_CUST_NAME = name;

		if (V_CUST_ID != null || V_CUST_ID.length > 0){
            v_WhereSQL += "AND  A.CUST_ID = '"+V_CUST_ID+"' ";
		}

	    if (V_NRIC != null || V_NRIC.length > 0){
            v_WhereSQL += "AND  A.NRIC = '"+V_NRIC+"' ";
		}

	    if((V_CUST_ID == null || V_CUST_ID == "" ) && (V_NRIC == null || V_NRIC == "" ))
		{
            Common.alert("A minimum of 1 filtering criteria must be Inserted/Selected");
            return;
		}

		var date = new Date().getDate();
		if(date.toString().length == 1){
		    date = "0" + date;
		}
		$("#reportDownFileName").val("CustomerScoreCardList_"+date+(new Date().getMonth()+1)+new Date().getFullYear());
		$("#form #viewType").val("PDF");
		$("#form #reportFileName").val("/sales/ScoreCard360Report.rpt");

		$("#form #v_WhereSQL").val(v_WhereSQL);
		$("#form #V_CUST_ID").val(V_CUST_ID);
		$("#form #V_NRIC").val(V_NRIC);

		console.log($("#form").serializeJSON());

		// 프로시져로 구성된 경우 꼭 아래 option을 넘겨야 함.
		var option = {
		        isProcedure : true // procedure 로 구성된 리포트 인경우 필수.  => /payment/PaymentListing_Excel.rpt 는 프로시져로 구성된 파일임.
		};

		Common.report("form", option);
	}

	function appendLoyaltyCategory(){
        $('#mLoyalty').append($('<option>', { value: '', text: 'Choose One' }));
        $('#mLoyalty').append($('<option>', { value: 'fresh', text: 'Fresh' }));
        $('#mLoyalty').append($('<option>', { value: 'new', text: 'New' }));
        $('#mLoyalty').append($('<option>', { value: 'existing', text: 'Existing' }));
        $('#mLoyalty').append($('<option>', { value: 'loyal', text: 'Loyal' }));
	}

// 	function appendNextProductCategory(){
//         $('#mNextProduct').append($('<option>', { value: 'waterpurifier', text: 'Water Purifier' }));
//         $('#mNextProduct').append($('<option>', { value: 'airpurifier', text: 'Air Purifier' }));
//         $('#mNextProduct').append($('<option>', { value: 'mattress', text: 'Mattress' }));
//         $('#mNextProduct').append($('<option>', { value: 'others', text: 'Others' }));

//         $(function() {
//             $('#mNextProduct').change(function() {

//             }).multipleSelect({
//                 selectAll: true, // 전체선택
//                 width: '80%'
//             });
//         });
// 	}

	function appendBrandCredibility(){
        $('#mBrandCredit').append($('<option>', { value: '', text: 'Choose One' }));
	}

	function appendRepurchaseFlag(){
        $('#mRePurcFlag').append($('<option>', { value: '', text: 'Choose One' }));
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
		<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
		<h2>360° Score Card</h2>

		<ul class="right_btns">
			<c:if test="${PAGE_AUTH.funcView == 'Y'}">
				<li>
                    <p class="btn_blue">
						<a href="#" onclick="javascript:fn_customerScoreCardListAjax()">
							<span class="search"></span>
                            <spring:message code="sal.btn.search" />
						</a>
					</p>
                </li>
			</c:if>
            <li>
                <p class="btn_blue type2">
                    <a href="#" onclick="javascript:$('#searchForm').clearForm();">
                        <span class="clear"></span>
                        <spring:message code="sal.btn.clear" />
                    </a>
                </p>
            </li>
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
						<th scope="row">NRIC</th>
                        <td>
                            <input type="text" title="NRIC" id="custIc" name="custIc" placeholder="NRIC" class="w100p" " />
                        </td>
                        <th scope="row">Loyalty Category</th>
                         <td>
                            <select class="w100p" id="mLoyalty"  name="mLoyalty">
                            </select>
                        </td>
                        <th></th>
                        <td> </td>
                    </tr>
                    <tr>
                        <th scope="row"><spring:message code="sal.text.customerId" /></th>
                        <td>
                            <input type="text" title="Customer ID" id="custId" name="custId" placeholder="Customer ID (Number Only)" class="w100p" />
                        </td>
                        <th scope="row">Brand Credibility</th>
                        <td>
                            <select class="w100p" name="mBrandCredit" id="mBrandCredit"></select>
                        </td>
                        <th></th>
                        <td></td>
					</tr>
                    <tr>
                        <th scope="row">Installation Area</th>
                        <td>
                            <select class="w100p" id="mState"  name="mState"></select>
                        </td>
                        <th scope="row">Repurchase Flag</th>
                        <td>
                            <select class="w100p" name="mRePurcFlag" id="mRePurcFlag"></select>
                        </td>
                        <th></th>
                        <td></td>
                    </tr>
				</tbody>
			</table>
		</form>
	</section>

<form id="form">
	<input type="hidden" id="reportFileName" name="reportFileName" value="" />
	<input type="hidden" id="viewType" name="viewType" value="" />
	<input type="hidden" id="reportDownFileName" name="reportDownFileName"	 value="" />
	<input type="hidden" id="V_CUST_ID"	name="V_CUST_ID" value="" />
	<input type="hidden" id="V_NRIC" name="V_NRIC" value="" />
 <!--    <input type="hidden" id="V_NxtProd" name="V_LOYAL" value="" />
    <input type="hidden" id="V_LOYAL" name="V_LOYAL" value="" />
    <input type="hidden" id="V_LOYAL" name="V_LOYAL" value="" />
    <input type="hidden" id="V_LOYAL" name="V_LOYAL" value="" />
    <input type="hidden" id="V_LOYAL" name="V_LOYAL" value="" /> -->
	<input type="hidden" id="v_WhereSQL" name="v_WhereSQL" value="" />
	<input type="hidden" id="V_MEM_TYPE" name="V_MEM_TYPE" value="" />
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
