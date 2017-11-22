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
        
        $("#orgGrCombo option:eq(2)").attr("selected", "selected");
        
        //creat grid
        createHPActualAUIGrid();
        createHPSimulAUIGrid();
        createHPCompareAUIGrid();
        
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
	        	var data = {"memType" : $("#orgGrCombo").val(), "salesPersonCd" : $("#memCode").val()}
	        	Common.ajax("GET", "/commission/report/selectMemberCount", data , function(result) {
	        		if(result > 0){
			        	Common.ajax("GET", "/commission/report/selectHPRawData", $("#myForm").serializeJSON() , function(result) {
			        		AUIGrid.setGridData(aGridID, result);
			        		AUIGrid.setGridData(sGridID, result);
			        		AUIGrid.setGridData(cGridID, result);
			        	});
	        		}else{
	        			Common.alert("Unable to find [" + $("#memCode").val() + "] in  Cody Code .<br />Please ensure you key in the correct member code.");
	        			$("#memCode").val("")
	        		}
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
	
	function createHPActualAUIGrid() {
		var columnLayout1 = [
			{dataField : "aMCode",             headerText : "Mem Code",          style : "my-column", editable : false },
			{dataField : "aMemberName",     headerText : "Mem Name",         style : "my-column", editable : false },
			{dataField : "aRank",                headerText : "Rank",                 style : "my-column", editable : false },
			{dataField : "aNric",                 headerText : "Nric",                   style : "my-column", editable : false },
			{dataField : "aPi",                    headerText : "PI Amt",               style : "my-column", editable : false },
			{dataField : "aPa",                   headerText : "PA Amt",              style : "my-column", editable : false },
			{dataField : "aSgmAmt",            headerText : "SGM Amt",           style : "my-column", editable : false },
			{dataField : "aMgrAmt",             headerText : "MGR Amt",           style : "my-column", editable : false },
			{dataField : "aOutinsAmt",         headerText : "Outins Amt",        style : "my-column", editable : false},
			{dataField : "aBonus",               headerText : "Bonus",               style : "my-column", editable : false},
			{dataField : "aRenmgrAmt",        headerText : "Renmgr Amt",       style : "my-column", editable : false},
			{dataField : "aRentalAmt",          headerText : "Rental Amt",        style : "my-column", editable : false},
			{dataField : "aOutplsAmt",          headerText : "Outpls Amt",       style : "my-column", editable : false},
			{dataField : "aMembershipAmt",   headerText : "Membership Amt", style : "my-column", editable : false},
			{dataField : "aTbbAmt",             headerText : "TBB Amt",           style : "my-column", editable : false},
			{dataField : "aAdjustAmt",          headerText : "Adjust",             style : "my-column", editable : false},
			{dataField : "aIncentive",           headerText : "Incentive",          style : "my-column", editable : false},
			{dataField : "aShiAmt",              headerText : "Shi Amt",            style : "my-column", editable : false},
			{dataField : "aRentalmembershipAmt",     headerText : "Rentalmembership Amt",       style : "my-column", editable : false},
			{dataField : "aRentalmembershipShiAmt", headerText : "Shi Rentalmembership Amt",   style : "my-column", editable : false}
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
	
	function createHPSimulAUIGrid() {
        var columnLayout2 = [
            {dataField : "aMCode",             headerText : "Mem Code",          style : "my-column", editable : false },
            {dataField : "aMemberName",     headerText : "Mem Name",         style : "my-column", editable : false },
            {dataField : "aRank",                headerText : "Rank",                 style : "my-column", editable : false },
            {dataField : "aNric",                 headerText : "Nric",                   style : "my-column", editable : false },
            {dataField : "sPi",                    headerText : "PI Amt",               style : "my-column", editable : false },
            {dataField : "sPa",                   headerText : "PA Amt",              style : "my-column", editable : false },
            {dataField : "sSgmAmt",            headerText : "SGM Amt",           style : "my-column", editable : false },
            {dataField : "sMgrAmt",             headerText : "MGR Amt",           style : "my-column", editable : false },
            {dataField : "sOutinsAmt",         headerText : "Outins Amt",        style : "my-column", editable : false},
            {dataField : "sBonus",               headerText : "Bonus",               style : "my-column", editable : false},
            {dataField : "sRenmgrAmt",        headerText : "Renmgr Amt",       style : "my-column", editable : false},
            {dataField : "sRentalAmt",          headerText : "Rental Amt",        style : "my-column", editable : false},
            {dataField : "sOutplsAmt",          headerText : "Outpls Amt",       style : "my-column", editable : false},
            {dataField : "sMembershipAmt",   headerText : "Membership Amt", style : "my-column", editable : false},
            {dataField : "sTbbAmt",             headerText : "TBB Amt",           style : "my-column", editable : false},
            {dataField : "sAdjustAmt",          headerText : "Adjust",             style : "my-column", editable : false},
            {dataField : "sIncentive",           headerText : "Incentive",          style : "my-column", editable : false},
            {dataField : "sShiAmt",              headerText : "Shi Amt",            style : "my-column", editable : false},
            {dataField : "sRentalmembershipAmt",     headerText : "Rentalmembership Amt",       style : "my-column", editable : false},
            {dataField : "sRentalmembershipShiAmt", headerText : "Shi Rentalmembership Amt",   style : "my-column", editable : false}
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
	
	function createHPCompareAUIGrid() {
        var columnLayout3 = [
            {dataField : "aMCode",             headerText : "Mem Code",          style : "my-column", editable : false },
            {dataField : "aMemberName",     headerText : "Mem Name",         style : "my-column", editable : false },
            {dataField : "aRank",                headerText : "Rank",                 style : "my-column", editable : false },
            {dataField : "aNric",                 headerText : "Nric",                   style : "my-column", editable : false },
            {dataField : "aPi",                    headerText : "A<BR>PI Amt",               style : "my-column", editable : false },
            {dataField : "sPi",                    headerText : "S<BR>PI Amt",               style : "my-column", editable : false },
            {dataField : "aPa",                   headerText : "A<BR>PA Amt",              style : "my-column", editable : false },
            {dataField : "sPa",                   headerText : "S<BR>PA Amt",              style : "my-column", editable : false },
            {dataField : "aSgmAmt",            headerText : "A<BR>SGM Amt",           style : "my-column", editable : false },
            {dataField : "sSgmAmt",            headerText : "S<BR>SGM Amt",           style : "my-column", editable : false },
            {dataField : "aMgrAmt",             headerText : "A<BR>MGR Amt",           style : "my-column", editable : false },
            {dataField : "sMgrAmt",             headerText : "S<BR>MGR Amt",           style : "my-column", editable : false },
            {dataField : "aOutinsAmt",         headerText : "A<BR>Outins Amt",        style : "my-column", editable : false},
            {dataField : "sOutinsAmt",         headerText : "S<BR>Outins Amt",        style : "my-column", editable : false},
            {dataField : "aBonus",               headerText : "A<BR>Bonus",               style : "my-column", editable : false},
            {dataField : "sBonus",               headerText : "S<BR>Bonus",               style : "my-column", editable : false},
            {dataField : "aRenmgrAmt",        headerText : "A<BR>Renmgr Amt",       style : "my-column", editable : false},
            {dataField : "sRenmgrAmt",        headerText : "S<BR>Renmgr Amt",       style : "my-column", editable : false},
            {dataField : "aRentalAmt",          headerText : "A<BR>Rental Amt",        style : "my-column", editable : false},
            {dataField : "sRentalAmt",          headerText : "S<BR>Rental Amt",        style : "my-column", editable : false},
            {dataField : "aOutplsAmt",          headerText : "A<BR>Outpls Amt",       style : "my-column", editable : false},
            {dataField : "sOutplsAmt",          headerText : "S<BR>Outpls Amt",       style : "my-column", editable : false},
            {dataField : "aMembershipAmt",   headerText : "A<BR>Membership Amt", style : "my-column", editable : false},
            {dataField : "sMembershipAmt",   headerText : "S<BR>Membership Amt", style : "my-column", editable : false},
            {dataField : "aTbbAmt",             headerText : "A<BR>TBB Amt",           style : "my-column", editable : false},
            {dataField : "sTbbAmt",             headerText : "S<BR>TBB Amt",           style : "my-column", editable : false},
            {dataField : "aAdjustAmt",          headerText : "A<BR>Adjust",             style : "my-column", editable : false},
            {dataField : "sAdjustAmt",          headerText : "S<BR>Adjust",             style : "my-column", editable : false},
            {dataField : "aIncentive",           headerText : "A<BR>Incentive",          style : "my-column", editable : false},
            {dataField : "sIncentive",           headerText : "S<BR>Incentive",          style : "my-column", editable : false},
            {dataField : "aShiAmt",              headerText : "A<BR>Shi Amt",            style : "my-column", editable : false},
            {dataField : "sShiAmt",              headerText : "S<BR>Shi Amt",            style : "my-column", editable : false},
            {dataField : "aRentalmembershipAmt",     headerText : "A<BR>Rentalmembership Amt",       style : "my-column", editable : false},
            {dataField : "sRentalmembershipAmt",     headerText : "S<BR>Rentalmembership Amt",       style : "my-column", editable : false},
            {dataField : "aRentalmembershipShiAmt", headerText : "A<BR>Shi Rentalmembership Amt",   style : "my-column", editable : false},
            {dataField : "sRentalmembershipShiAmt", headerText : "S<BR>Shi Rentalmembership Amt",   style : "my-column", editable : false}
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
		<h2>HP commission result</h2>
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