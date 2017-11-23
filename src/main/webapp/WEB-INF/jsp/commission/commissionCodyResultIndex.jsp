<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<style type="text/css">
/* 커스텀 칼럼 스타일 정의 */
.my-column {
    text-align:left;
    margin-top:-20px;
}
</style>
<script type="text/javaScript">
	var aGridID;
	var sGridID;
	var cGridID;
	var today = "${today}";

	$(document).ready(function() {
		$("#orgGrCombo").change(function() {
            $("#orgCombo").find('option').each(function() {
                $(this).remove();
            });
            if ($(this).val().trim() == "") {
                return;
            }       
            fn_getOrgCdListAllAjax(); //call orgList
        }); 
        
        $("#orgGrCombo option:eq(3)").attr("selected", "selected");
        
        //creat grid
        createCMActualAUIGrid();
        createCMSimulAUIGrid();
        createCMCompareAUIGrid();
        
        $('#grid_wrap_a').show();
        $('#grid_wrap_s').hide();
        $('#grid_wrap_c').hide();
        
        AUIGrid.bind(aGridID, "cellClick", function(event) {
            console.log("value : " + AUIGrid.getCellValue(aGridID, event.rowIndex, "aMemCode"));          
        }); 
        
        
        $('#memBtn').click(function() {
            //Common.searchpopupWin("searchForm", "/common/memberPop.do","");
            Common.popupDiv("/common/memberPop.do", $("#myForm").serializeJSON(), null, true);
        });
        
        
        $('#search').click(function(){
        	if($("#memCode").val() != null && $("#memCode").val() != ""){
	        	Common.ajax("GET", "/commission/report/selectCodyRawData", $("#myForm").serializeJSON() , function(result) {
	        		AUIGrid.setGridData(aGridID, result);
	        		AUIGrid.setGridData(sGridID, result);
	        		AUIGrid.setGridData(cGridID, result);
	        	});
        	}else{
        		Common.alert("Please select the member code.");
        	}
        });
        
        $('#actionTypeA').click(function(){
        	$('#grid_wrap_a').show();
        	$('#grid_wrap_s').hide();
        	$('#grid_wrap_c').hide();
        });
        $('#actionTypeS').click(function(){
            $('#grid_wrap_a').hide();
            $('#grid_wrap_s').show();
            $('#grid_wrap_c').hide();
        });
        $('#actionTypeC').click(function(){
            $('#grid_wrap_a').hide();
            $('#grid_wrap_s').hide();
            $('#grid_wrap_c').show();
        });
        
        $('#clear').click(function(){
        	$("#myForm")[0].reset();
        	$("#actionTypeA").trigger("click");
        });
	});
	
	/* member Type Code Search */
	function fn_getOrgCdListAllAjax(callBack) {
		var data = {"orgGrCombo" : $("#orgGrCombo").val()}
        Common.ajaxSync("GET", "/commission/report/selectOrgCdListAll", data, function(result) {
            orgList = new Array();
            if (result) {
            	if(result.length > 0){
	                for (var i = 0; i < result.length; i++) {
	                    $("#orgCombo").append("<option value='"+result[i].orgCd + "' > " + result[i].orgNm + "</option>");
	                }
            	}
            }
            //if you need callBack Function , you can use that function
            if (callBack) {
                callBack(orgList);
            }
        });
    }
	
	/* member Code Search */
	function fn_loadOrderSalesman(memId, memCode) {
	    $("#memCode").val(memCode);
	    console.log(' memId:'+memId);
	    console.log(' memCd:'+memCode);
	}
	
	function createCMActualAUIGrid() {
		var columnLayout1 = [
			{dataField : "aMemCode",           headerText : "Mem Code",     style : "my-column", editable : false, width : 80 },
			{dataField : "aMemName",          headerText : "Mem Name",     style : "my-column", editable : false, width : 260 },
			{dataField : "aRank",                 headerText : "Rank",             style : "my-column", editable : false },
			{dataField : "aNric",                  headerText : "Nric",              style : "my-column", editable : false, width : 110 },
			{dataField : "aPerAmt",              headerText : "Per Amt",        style : "my-column", editable : false },
			{dataField : "aSalesAmt",           headerText : "Sales Amt",      style : "my-column", editable : false },
			{dataField : "aBonusAmt",          headerText : "Bonus Amt",     style : "my-column", editable : false },
			{dataField : "aCollectAmt",         headerText : "Collect Amt",    style : "my-column", editable : false },
			{dataField : "aMembershipAmt",   headerText : "Membership Amt",   style : "my-column", editable : false},
			{dataField : "aHpAmt",               headerText : "Hp Amt",               style : "my-column", editable : false},
			{dataField : "aTransportAmt",      headerText : "Transport Amt",      style : "my-column", editable : false},
			{dataField : "aNewcodyAmt",       headerText : "Newcody Amt",      style : "my-column", editable : false},
			{dataField : "aIntroductionFees",  headerText : "Introduction Fees", style : "my-column", editable : false},
			{dataField : "aStaffPurchase",      headerText : "Staff Purchase",     style : "my-column", editable : false},
			{dataField : "aTelephoneDeduct",  headerText : "Telephone Deduct",style : "my-column", editable : false},
			{dataField : "aIncentive",            headerText : "Incentive",            style : "my-column", editable : false},
			{dataField : "aAdj",                    headerText : "Adj",                    style : "my-column", editable : false},
			{dataField : "aShiAmt",               headerText : "ShiAmt",               style : "my-column", editable : false},
			{dataField : "aRentalmembershipAmt",     headerText : "Rentalmembership Amt",       style : "my-column", editable : false},
			{dataField : "aShiRentalmembershipAmt", headerText : "Shi Rentalmembership Amt",   style : "my-column", editable : false}
		];
		// 그리드 속성 설정
		var gridPros1 = {
		    usePaging : true,// 페이징 사용       
		    pageRowCount : 20,// 한 화면에 출력되는 행 개수 20(기본값:20)
		    skipReadonlyColumns : true,// 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
		    wrapSelectionMove : true,// 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
		    showRowNumColumn : true,// 줄번호 칼럼 렌더러 출력
		    selectionMode : "singleRow"
		};
		aGridID = AUIGrid.create("#grid_wrap_a", columnLayout1,gridPros1);
	}
	
	function createCMSimulAUIGrid() {
        var columnLayout2 = [
            {dataField : "aMemCode",           headerText : "Mem Code",     style : "my-column", editable : false, width : 80 },
            {dataField : "aMemName",          headerText : "Mem Name",     style : "my-column", editable : false, width : 260 },
            {dataField : "aRank",                 headerText : "Rank",             style : "my-column", editable : false },
            {dataField : "aNric",                  headerText : "Nric",              style : "my-column", editable : false, width : 110 },
            {dataField : "sPerAmt",              headerText : "Per Amt",        style : "my-column", editable : false },
            {dataField : "sSalesAmt",           headerText : "Sales Amt",      style : "my-column", editable : false },
            {dataField : "sBonusAmt",          headerText : "Bonus Amt",     style : "my-column", editable : false},
            {dataField : "sCollectAmt",         headerText : "Collect Amt",    style : "my-column", editable : false },
            {dataField : "sMembershipAmt",   headerText : "Membership Amt",   style : "my-column", editable : false},
            {dataField : "sHpAmt",               headerText : "Hp Amt",               style : "my-column", editable : false},
            {dataField : "sTransportAmt",      headerText : "Transport Amt",      style : "my-column", editable : false},
            {dataField : "sNewcodyAmt",       headerText : "Newcody Amt",      style : "my-column", editable : false},
            {dataField : "sIntroductionFees",  headerText : "Introduction Fees", style : "my-column", editable : false},
            {dataField : "sStaffPurchase",      headerText : "Staff Purchase",     style : "my-column", editable : false},
            {dataField : "sTelephoneDeduct",  headerText : "Telephone Deduct",style : "my-column", editable : false},
            {dataField : "sIncentive",            headerText : "Incentive",            style : "my-column", editable : false},
            {dataField : "sAdj",                    headerText : "Adj",                    style : "my-column", editable : false},
            {dataField : "sShiAmt",               headerText : "ShiAmt",               style : "my-column", editable : false},
            {dataField : "sRentalmembershipAmt",     headerText : "Rentalmembership Amt",       style : "my-column", editable : false},
            {dataField : "sShiRentalmembershipAmt", headerText : "Shi Rentalmembership Amt",   style : "my-column", editable : false}
        ];
        // 그리드 속성 설정
        var gridPros2 = {
            usePaging : true,// 페이징 사용       
            pageRowCount : 20,// 한 화면에 출력되는 행 개수 20(기본값:20)
            skipReadonlyColumns : true,// 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            wrapSelectionMove : true,// 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            showRowNumColumn : true,// 줄번호 칼럼 렌더러 출력
            selectionMode : "singleRow"
        };
        sGridID = AUIGrid.create("#grid_wrap_s", columnLayout2,gridPros2);
    }
	
	function createCMCompareAUIGrid() {
        var columnLayout3 = [
            {dataField : "aMemCode",           headerText : "Mem Code",            style : "my-column", editable : false, width : 80},
            {dataField : "aMemName",          headerText : "Mem Name",            style : "my-column", editable : false, width : 260 },
            {dataField : "aRank",                 headerText : "Rank",                    style : "my-column", editable : false },
            {dataField : "aNric",                  headerText : "Nric",             style : "my-column", editable : false, width : 110 },
            
            {headerText : "Per Amt",              children: [{dataField: "aPerAmt", headerText: "A", editable : false}, {dataField: "sPerAmt", headerText: "S", editable : false}]},
            {headerText : "Sales Amt",           children: [{dataField: "aSalesAmt", headerText: "A", editable : false}, {dataField: "sSalesAmt", headerText: "S", editable : false}]},
            {headerText : "Bonus Amt",          children: [{dataField: "aBonusAmt", headerText: "A", editable : false}, {dataField: "sBonusAmt", headerText: "S", editable : false}]},
            {headerText : "Collect Amt",         children: [{dataField: "aCollectAmt", headerText: "A", editable : false}, {dataField: "sCollectAmt", headerText: "S", editable : false}]},
            {headerText : "Membership Amt",   children: [{dataField: "aMembershipAmt", headerText: "A", editable : false}, {dataField: "sMembershipAmt", headerText: "S", editable : false}]},
            
            {headerText : "Hp Amt",                children: [{dataField: "aHpAmt", headerText: "A", editable : false}, {dataField: "sHpAmt", headerText: "S", editable : false}]},
            {headerText : "Transport Amt",       children: [{dataField: "aTransportAmt", headerText: "A", editable : false}, {dataField: "sTransportAmt", headerText: "S", editable : false}]},
            {headerText : "Newcody Amt",       children: [{dataField: "aNewcodyAmt", headerText: "A", editable : false}, {dataField: "sNewcodyAmt", headerText: "S", editable : false}]},
            {headerText : "Introduction Fees",  children: [{dataField: "aIntroductionFees", headerText: "A", editable : false}, {dataField: "sIntroductionFees", headerText: "S", editable : false}]},
            {headerText : "Staff Purchase",      children: [{dataField: "aStaffPurchase", headerText: "A", editable : false}, {dataField: "sStaffPurchase", headerText: "S", editable : false}]},
            
            {headerText : "Telephone Deduct",          children: [{dataField: "aTelephoneDeduct", headerText: "A", editable : false}, {dataField: "sTelephoneDeduct", headerText: "S", editable : false}]},
            {headerText : "Incentive",                     children: [{dataField: "aIncentive", headerText: "A", editable : false}, {dataField: "sIncentive", headerText: "S", editable : false}]},
            {headerText : "Adj",                              children: [{dataField: "aAdj", headerText: "A", editable : false}, {dataField: "sAdj", headerText: "S", editable : false}]},
            {headerText : "ShiAmt",                         children: [{dataField: "aShiAmt", headerText: "A", editable : false}, {dataField: "sShiAmt", headerText: "S", editable : false}]},
            {headerText : "Rentalmembership Amt",    children: [{dataField: "aRentalmembershipAmt", headerText: "A", editable : false}, {dataField: "sRentalmembershipAmt", headerText: "S", editable : false}]},
            
            {headerText : "Shi Rentalmembership Amt",   children: [{dataField: "aShiRentalmembershipAmt", headerText: "A", editable : false}, {dataField: "sShiRentalmembershipAmt", headerText: "S", editable : false}]}
        ];
        // 그리드 속성 설정
        var gridPros3 = {
            usePaging : true,// 페이징 사용       
            pageRowCount : 20,// 한 화면에 출력되는 행 개수 20(기본값:20)
            skipReadonlyColumns : true,// 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            wrapSelectionMove : true,// 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            showRowNumColumn : true,// 줄번호 칼럼 렌더러 출력
            selectionMode : "singleRow"
        };
        cGridID = AUIGrid.create("#grid_wrap_c", columnLayout3,gridPros3);
    }
	
	function fn_excelDown(){
        var checkedValue = $("input[type=radio][name=actionType]:checked").val();
        var grdLength = "0"
        var divNm = "";
        var fileNm = "HPresultIndex_"+today;
        
        if(checkedValue == "A"){
            divNm = "grid_wrap_a";
            grdLength = AUIGrid.getGridData(aGridID).length;
        }else if(checkedValue == "S"){
            divNm = "grid_wrap_s";
            grdLength = AUIGrid.getGridData(sGridID).length;
        }else if(checkedValue == "C"){
            divNm = "grid_wrap_c";
            grdLength = AUIGrid.getGridData(cGridID).length;
        }

        if(Number(grdLength) > 0){
            GridCommon.exportTo(divNm, "xlsx", fileNm);
        }else{
            Common.alert("No Data");
        }
    }
</script>

<section id="content"><!-- content start -->
	<ul class="path">
        <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
        <li>Commission</li>
        <li>Management</li>
    </ul>
	
	<aside class="title_line"><!-- title_line start -->
		<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
		<h2>Cody commission result</h2>
		<ul class="right_btns">
			<li><p class="btn_blue"><a href="#" id="search">Search</a></p></li>
			<li><p class="btn_blue"><a href="#" id="clear"><span class="clear"></span>Clear</a></p></li>
		</ul>
	</aside><!-- title_line end -->
	
	
	<section class="search_table"><!-- search_table start -->
		<form action="#" method="post" name="myForm" id="myForm">
			
			<table class="type1"><!-- table start -->
				<caption>table</caption>
				<colgroup>
					<col style="width:140px" />
					<col style="width:*" />
					<col style="width:140px" />
                    <col style="width:*" />
					<col style="width:170px" />
					<col style="width:*" />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row">Commission Month</th>
						<td>
						  <input type="text" title="기준년월" class="j_date2 w50p" id="searchDt" name="searchDt" value="${searchDt }" />
						</td>
						<th scope="row">Member Group</th>
						<td>
							<select class="w50p" id="orgGrCombo" name="orgGrCombo" disabled="disabled">
								<c:forEach var="list" items="${orgGrList }">
								    <option value="${list.cdid}">${list.cdnm} (${list.cd})</option>
								</c:forEach>
                            </select>
						</td>
						<th scope="row">Member Type</th>
						<td>
                            <select class="w50p" id="orgCombo" name="orgCombo">
                                <c:forEach var="list" items="${orgList }">
                                    <option value="${list.cd}">${list.cdnm}</option>
                                </c:forEach>
                            </select>
                        </td>
					</tr>
					<tr>
						<th scope="row">Member Code</th>
						<td>
						  <input type="text" style="width: 100px;" id="memCode" name="memCode" maxlength="20"/>
						  <a id="memBtn" href="#" class="search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
						</td>
						<th scope="row">Mode</th>
                        <td colspan=3>
                            <label><input type="radio" name="actionType" id="actionTypeA" value="A"checked/><span>Actual</span></label>
	                        <label><input type="radio" name="actionType" id="actionTypeS" value="S"/><span>Simulation</span></label>
	                        <label><input type="radio" name="actionType" id="actionTypeC" value="C"/><span>A & S</span></label>
                        </td>
					</tr>
				</tbody>
			</table><!-- table end -->
		</form>
	</section><!-- search_table end -->
	
	<section class="search_result"><!-- search_result start -->
	
		<ul class="right_btns">
			<li><p class="btn_grid"><a href="javascript:fn_excelDown();">EXCEL DW</a></p></li>
		</ul>
	
		<article class="grid_wrap"><!-- grid_wrap start -->
		    <div id="grid_wrap_a" style="width: 100%; height: 334px; margin: 0 auto;"></div>
            <div id="grid_wrap_s" style="width: 100%; height: 334px; margin: 0 auto;"></div>
            <div id="grid_wrap_c" style="width: 100%; height: 334px; margin: 0 auto;"></div>
			
		</article><!-- grid_wrap end -->
	
	</section><!-- search_result end -->

</section><!-- content end -->

		
<hr />

</body>
</html>