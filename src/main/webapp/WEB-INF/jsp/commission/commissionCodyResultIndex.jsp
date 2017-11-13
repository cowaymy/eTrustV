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
        $("#searchDt").change(function() {
        	$("#orgCombo").find('option').each(function() {
                $(this).remove();
            });
            if ($(this).val().trim() == "") {
                return;
            }       
            fn_getOrgCdListAllAjax(); //call orgList
        }); 
        
        //creat grid
        createActualAUIGrid();
        createSimulAUIGrid();
        createCompareAUIGrid();
        
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
        	Common.ajax("GET", "/commission/report/selectCodyRawData", $("#myForm").serializeJSON() , function(result) {
        		AUIGrid.setGridData(aGridID, result);
        		AUIGrid.setGridData(sGridID, result);
        		AUIGrid.setGridData(cGridID, result);
        	});
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
	});
	
	/* member Type Code Search */
	function fn_getOrgCdListAllAjax(callBack) {
        Common.ajaxSync("GET", "/commission/report/selectOrgCdListAll", $("#myForm").serialize(), function(result) {
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
	
	function createActualAUIGrid() {
		var columnLayout1 = [
			{dataField : "aMemCode",           headerText : "Mem Code",     style : "my-column", editable : false },
			{dataField : "aMemName",          headerText : "Mem Name",     style : "my-column", editable : false },
			{dataField : "aRank",                 headerText : "Rank",             style : "my-column", editable : false },
			{dataField : "aNric",                  headerText : "Nric",              style : "my-column", editable : false },
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
		    selectionMode : "singleRow",
		    headerHeight : 40 
		};
		aGridID = AUIGrid.create("#grid_wrap_a", columnLayout1,gridPros1);
	}
	
	function createSimulAUIGrid() {
        var columnLayout2 = [
            {dataField : "sMemCode",           headerText : "Mem Code",     style : "my-column", editable : false },
            {dataField : "sMemName",          headerText : "Mem Name",     style : "my-column", editable : false },
            {dataField : "sRank",                 headerText : "Rank",             style : "my-column", editable : false },
            {dataField : "sNric",                  headerText : "Nric",              style : "my-column", editable : false },
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
            selectionMode : "singleRow",
            headerHeight : 40
        };
        sGridID = AUIGrid.create("#grid_wrap_s", columnLayout2,gridPros2);
    }
	
	function createCompareAUIGrid() {
        var columnLayout3 = [
            {dataField : "aMemCode",           headerText : "Mem Code",            style : "my-column", editable : false },
            {dataField : "aMemName",          headerText : "Mem Name",            style : "my-column", editable : false },
            {dataField : "aRank",                 headerText : "A<br>Rank",            style : "my-column", editable : false },
            {dataField : "sRank",                 headerText : "S<br>Rank",            style : "my-column", editable : false },
            {dataField : "aNric",                  headerText : "A<br>Nric",             style : "my-column", editable : false },
            {dataField : "sNric",                  headerText : "S<br>Nric",             style : "my-column", editable : false },
            {dataField : "aPerAmt",              headerText : "A<br>Per Amt",       style : "my-column", editable : false },
            {dataField : "sPerAmt",              headerText : "S<br>Per Amt",       style : "my-column", editable : false },
            {dataField : "aSalesAmt",           headerText : "A<br>Sales Amt",    style : "my-column", editable : false },
            {dataField : "sSalesAmt",           headerText : "S<br>Sales Amt",     style : "my-column", editable : false },
            {dataField : "aBonusAmt",          headerText : "A<br>Bonus Amt",    style : "my-column", editable : false},
            {dataField : "sBonusAmt",          headerText : "S<br>Bonus Amt",    style : "my-column", editable : false},
            {dataField : "aCollectAmt",         headerText : "A<br>Collect Amt",   style : "my-column", editable : false },
            {dataField : "sCollectAmt",         headerText : "S<br>Collect Amt",          style : "my-column", editable : false },
            {dataField : "aMembershipAmt",   headerText : "A<br>Membership Amt",   style : "my-column", editable : false},
            {dataField : "sMembershipAmt",   headerText : "S<br>Membership Amt",   style : "my-column", editable : false},
            {dataField : "aHpAmt",               headerText : "A<br>Hp Amt",               style : "my-column", editable : false},
            {dataField : "sHpAmt",               headerText : "S<br>Hp Amt",               style : "my-column", editable : false},
            {dataField : "aTransportAmt",      headerText : "A<br>Transport Amt",      style : "my-column", editable : false},
            {dataField : "sTransportAmt",      headerText : "S<br>Transport Amt",      style : "my-column", editable : false},
            {dataField : "aNewcodyAmt",       headerText : "A<br>Newcody Amt",      style : "my-column", editable : false},
            {dataField : "sNewcodyAmt",       headerText : "S<br>Newcody Amt",      style : "my-column", editable : false},
            {dataField : "aIntroductionFees",  headerText : "A<br>Introduction Fees", style : "my-column", editable : false},
            {dataField : "sIntroductionFees",  headerText : "S<br>Introduction Fees", style : "my-column", editable : false},
            {dataField : "aStaffPurchase",      headerText : "A<br>Staff Purchase",     style : "my-column", editable : false},
            {dataField : "sStaffPurchase",      headerText : "S<br>Staff Purchase",     style : "my-column", editable : false},
            {dataField : "aTelephoneDeduct",  headerText : "A<br>Telephone Deduct",style : "my-column", editable : false},
            {dataField : "sTelephoneDeduct",  headerText : "S<br>Telephone Deduct",style : "my-column", editable : false},
            {dataField : "aIncentive",            headerText : "A<br>Incentive",            style : "my-column", editable : false},
            {dataField : "sIncentive",            headerText : "S<br>Incentive",            style : "my-column", editable : false},
            {dataField : "aAdj",                    headerText : "A<br>Adj",                    style : "my-column", editable : false},
            {dataField : "sAdj",                    headerText : "S<br>Adj",                    style : "my-column", editable : false},
            {dataField : "aShiAmt",               headerText : "A<br>ShiAmt",               style : "my-column", editable : false},
            {dataField : "sShiAmt",               headerText : "S<br>ShiAmt",               style : "my-column", editable : false},
            {dataField : "aRentalmembershipAmt",     headerText : "A<br>Rentalmembership Amt",       style : "my-column", editable : false},
            {dataField : "sRentalmembershipAmt",     headerText : "S<br>Rentalmembership Amt",       style : "my-column", editable : false},
            {dataField : "aShiRentalmembershipAmt", headerText : "A<br>Shi Rentalmembership Amt",   style : "my-column", editable : false},
            {dataField : "sShiRentalmembershipAmt", headerText : "S<br>Shi Rentalmembership Amt",   style : "my-column", editable : false}
        ];
        // 그리드 속성 설정
        var gridPros3 = {
            usePaging : true,// 페이징 사용       
            pageRowCount : 20,// 한 화면에 출력되는 행 개수 20(기본값:20)
            skipReadonlyColumns : true,// 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            wrapSelectionMove : true,// 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            showRowNumColumn : true,// 줄번호 칼럼 렌더러 출력
            selectionMode : "singleRow",
            headerHeight : 40
        };
        cGridID = AUIGrid.create("#grid_wrap_c", columnLayout3,gridPros3);
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
	   <!-- 엑셀 형식 레포트 || 카큘레이션 ?-->
	   <!-- <form name="reportForm" id="reportForm">
	       <input type="hidden" name="V_MEMCODE" id="mCode"/>
	       <input type="hidden" name="V_PVMTH" id="month"/>
	       <input type="hidden" name="V_PVYEAR" id="year"/>
	       <input type="hidden" name="V_MEMLVL" id="mLvl"/>
	       <input type="hidden" name="V_MEMTYPE" id="mType"/>
	       <input type="hidden" name="V_DEPTCODE" id="deptCode"/>
	       <input type="hidden" name="reportDownFileName" id="reportDownFileName"/>
	       <input type="hidden" name="reportFileName" id="reportFileName"/>
	       <input type="hidden" name="viewType" id="viewType"/>
	   </form> -->
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
                                    <option value="${list.cdid}">${list.cdnm}</option>
                                </c:forEach>
                            </select>
                        </td>
					</tr>
					<tr>
						<th scope="row">Member Code</th>
						<td>
						  <input type="text" title="" placeholder="" class="w50p" id="memCode" name="memCode"/>
						  <a id="memBtn" href="#" class="search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
						</td>
						<th scope="row">Mode</th>
                        <td colspan=3>
                            <label><input type="radio" name="actionType" id="actionTypeA" value="A"checked/><span>Actual</span></label>
	                        <label><input type="radio" name="actionType" id="actionTypeS" value="S"/><span>Simulation</span></label>
	                        <label><input type="radio" name="actionType" id="actionTypeC" value="C"/><span>Compare</span></label>
                        </td>
					</tr>
				</tbody>
			</table><!-- table end -->
		</form>
	</section><!-- search_table end -->
	
	<section class="search_result"><!-- search_result start -->
	
		<ul class="right_btns">
			<li><p class="btn_grid"><a href="#" id="generate">EXCEL DW</a></p></li>
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