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
	var gridID;
	var radio;
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
        
        $("#orgGrCombo option:eq(1)").attr("selected", "selected");
        
        //creat grid
        createGrid("CTR");
        
        $('#memBtn').click(function() {
            //Common.searchpopupWin("searchForm", "/common/memberPop.do","");
            Common.popupDiv("/common/memberPop.do", $("#myForm").serializeJSON(), null, true);
        });
        
        
        $('#search').click(function(){
        	//if($("#memCode").val() != null && $("#memCode").val() != ""){
	        	Common.ajax("GET", "/commission/report/selectCTRawData", $("#myForm").serializeJSON() , function(result) {

                    destroyGrid();
                    
                    var rank = $("#orgCombo").val();
                    
                    createGrid(rank);
                    
                    AUIGrid.setGridData(gridID, result);
                    
	        	});
        	/* }else{
        		Common.alert("Please select the member code.");
        		$('input:radio[name="actionType"][value="'+radio+'"]').prop('checked', true);
        	} */
        });
        
        $('#actionTypeA').click(function(){
        	$("#search").click();
        });
        $('#actionTypeS').click(function(){
        	$("#search").click();
        });
        $('#actionTypeC').click(function(){
        	$("#search").click();
        });
        
        $('#clear').click(function(){
            $("#myForm")[0].reset();
            $('input:radio[name="actionType"][value="A"]').prop('checked', true);
            destroyGrid();
            createGrid("CTR");
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
	
	function createGrid(lvl){
        var gridPros = {
            usePaging : true,// 페이징 사용       
            pageRowCount : 20,// 한 화면에 출력되는 행 개수 20(기본값:20)
            skipReadonlyColumns : true,// 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            wrapSelectionMove : true,// 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            showRowNumColumn : true,// 줄번호 칼럼 렌더러 출력
            selectionMode : "singleRow"
        };
        
        var type = $("input[type=radio][name=actionType]:checked").val();
        radio = type;
        if(lvl == "CTN" || lvl == "CTR" || lvl == "CTE"){
            if(type == "A"){
                gridID = AUIGrid.create("#grid_wrap", columnCTActualLayout,gridPros);
            }else if(type == "S"){
                gridID = AUIGrid.create("#grid_wrap", columnCTSimulLayout,gridPros);
            }else if(type == "C"){
                gridID = AUIGrid.create("#grid_wrap", columnCTCompareLayout,gridPros);
            }
        }else if(lvl == "CTL"){
            if(type == "A"){
             gridID = AUIGrid.create("#grid_wrap", columnCTLActualLayout,gridPros);
            }else if(type == "S"){
                gridID = AUIGrid.create("#grid_wrap", columnCTLSimulLayout,gridPros);
            }else if(type == "C"){
                gridID = AUIGrid.create("#grid_wrap", columnCTLCompareLayout,gridPros);
            }
        }else if(lvl == "CTM"){
            if(type == "A"){
                gridID = AUIGrid.create("#grid_wrap", columnCTMActualLayout,gridPros);
            }else if(type == "S"){
                gridID = AUIGrid.create("#grid_wrap", columnCTMSimulLayout,gridPros);
            }else if(type == "C"){
                gridID = AUIGrid.create("#grid_wrap", columnCTMCompareLayout,gridPros);
            }
        }
        
    }
    
    function destroyGrid() {
        AUIGrid.destroy("#grid_wrap");
        gridID = null;
    }
	
	function fn_excelDown(){
	    var checkedValue = $("input[type=radio][name=actionType]:checked").val();
	    var grdLength = "0"
	    var divNm = "";
	    var fileNm = "";
	    
	    grdLength = AUIGrid.getGridData(gridID).length;
	  
	    var type = $("input[type=radio][name=actionType]:checked").val();
        if(type == "A"){
            fileNm = "CTresultIndex_Actual_"+today;
        }else if(type == "S"){
            fileNm = "CTresultIndex_Simul_"+today;
        }else if(type == "C"){
            fileNm = "CTresultIndex_Actual_N_Simul_"+today;
        }
        fileNm=fileNm+".xlsx"
        /* grad download 
        if(Number(grdLength) > 0){
            GridCommon.exportTo("grid_wrap", "xlsx", fileNm);
        }else{
            Common.alert("No Data");
        } */
        
        var codeNm = "result_CT";
        var searchDt = $("#searchDt").val();
        var year = searchDt.substr(searchDt.indexOf("/")+1,searchDt.length);
        var month = searchDt.substr(0,searchDt.indexOf("/"));
        var orgCombo = $("#orgCombo").val();
        var memCode = $("#memCode").val();
        
        Common.showLoader();
        $.fileDownload("/commExcelFile.do?fileName=" + fileNm + "&code="+codeNm+"&year="+year+"&month="+month+"&orgCombo="+orgCombo+"&memCode="+memCode+"&actionType="+checkedValue)
        .done(function () {
            //Common.alert('File download a success!');
            Common.alert("<spring:message code='commission.alert.report.download.success'/>");
            Common.removeLoader();            
        })
        .fail(function () {
            //Common.alert('File download failed!');
            Common.alert("<spring:message code='commission.alert.report.download.fail'/>");
            Common.removeLoader();            
         });
	}
	/** ****************************************************************
    ACTUAL GRID
**************************************************************** **/
   
    var columnCTActualLayout = [
        {dataField : "mCode",              headerText : "Member Code",     style : "my-column", editable : false, width : 80 },
        {dataField : "ctName",             headerText : "CT Name",           style : "my-column", editable : false, width : 260 },
        {dataField : "ctRank",              headerText : "CT Rank",             style : "my-column", editable : false },
        {dataField : "nric",                  headerText : "Nric",                  style : "my-column", editable : false, width : 110 },
        {dataField : "joinDate",            headerText : "Join Date",           style : "my-column", editable : false },
        {dataField : "serviceMonths",    headerText : "Service Months",   style : "my-column", editable : false },
        {dataField : "status",               headerText : "Status",               style : "my-column", editable : false },
        {dataField : "brnch",                headerText : "Branch",              style : "my-column", editable : false},
        
        {dataField : "aAsCount",           headerText : "AS Count",           style : "my-column", editable : false},
        {dataField : "aAsSumCp",          headerText : "AS Sum Cp",         style : "my-column", editable : false},
        {dataField : "aBsCount",           headerText : "BS Count",           style : "my-column", editable : false},
        {dataField : "aBsSumCp",          headerText : "BS Sum Cp",         style : "my-column", editable : false},
        {dataField : "aInsCount",          headerText : "Ins Count",           style : "my-column", editable : false},
        {dataField : "aInsSumCp",         headerText : "Ins Sum Cp",         style : "my-column", editable : false},
        {dataField : "aPrCount",            headerText : "Pr Count",            style : "my-column", editable : false},
        {dataField : "aPrSumCp",           headerText : "Pr Sum Cp",          style : "my-column", editable : false},
        {dataField : "aTotalPoint",         headerText : "Total Point",          style : "my-column", editable : false},
        {dataField : "aProPercent",        headerText : "Pro Percent",         style : "my-column", editable : false},
        {dataField : "aPerPercent",        headerText : "Per Percent",         style : "my-column", editable : false},
        {dataField : "aProFactor30",       headerText : "Pro Factor(30%)",  style : "my-column", editable : false},
        {dataField : "aPerFactor70",       headerText : "Per Factor(70%)",  style : "my-column", editable : false},
        {dataField : "aSumFactor",         headerText : "Sum Factor",         style : "my-column", editable : false},
        {dataField : "aGrossComm",        headerText : "Gross Comm",        style : "my-column", editable : false},
        {dataField : "aRentalComm",       headerText : "Rental Comm",       style : "my-column", editable : false},
        {dataField : "aSrvMemComm",     headerText : "Srv Mem Comm",    style : "my-column", editable : false},
        {dataField : "aBasicAndAllowance",       headerText : "Basic And Allowance",     style : "my-column", editable : false},
        {dataField : "aPerformanceIncentive",   headerText : "Performance Incentive",  style : "my-column", editable : false},
        {dataField : "aAdjustment",                 headerText : "Adjustment",                 style : "my-column", editable : false},
        {dataField : "aCffReward",                   headerText : "CFF REWARD",               style : "my-column", editable : false},
        {dataField : "aSeniority",                     headerText : "Seniority",                    style : "my-column", editable : false},
        {dataField : "aGrandTotal",                  headerText : "Grand Total",                 style : "my-column", editable : false}
    ];
    
    var columnCTLActualLayout = [
         {dataField : "mCode",              headerText : "Member Code",     style : "my-column", editable : false, width : 80 },
         {dataField : "ctName",             headerText : "CT Name",           style : "my-column", editable : false, width : 260 },
         {dataField : "ctRank",              headerText : "CT Rank",             style : "my-column", editable : false },
         {dataField : "nric",                  headerText : "Nric",                  style : "my-column", editable : false, width : 110 },
         {dataField : "joinDate",            headerText : "Join Date",           style : "my-column", editable : false },
         {dataField : "serviceMonths",    headerText : "Service Months",   style : "my-column", editable : false },
         {dataField : "status",               headerText : "Status",               style : "my-column", editable : false },
         {dataField : "brnch",                headerText : "Branch",              style : "my-column", editable : false},
         
         {dataField : "aAsCount",           headerText : "AS Count",           style : "my-column", editable : false},
         {dataField : "aAsSumCp",          headerText : "AS Sum Cp",         style : "my-column", editable : false},
         {dataField : "aBsCount",           headerText : "BS Count",           style : "my-column", editable : false},
         {dataField : "aBsSumCp",          headerText : "BS Sum Cp",         style : "my-column", editable : false},
         {dataField : "aInsCount",          headerText : "Ins Count",           style : "my-column", editable : false},
         {dataField : "aInsSumCp",         headerText : "Ins Sum Cp",         style : "my-column", editable : false},
         {dataField : "aPrCount",            headerText : "Pr Count",            style : "my-column", editable : false},
         {dataField : "aPrSumCp",           headerText : "Pr Sum Cp",          style : "my-column", editable : false},
         {dataField : "aTotalPoint",         headerText : "Total Point",          style : "my-column", editable : false},
         {dataField : "aProPercent",        headerText : "Pro Percent",         style : "my-column", editable : false},
         {dataField : "aPerPercent",        headerText : "Per Percent",         style : "my-column", editable : false},
         {dataField : "aProFactor30",       headerText : "Pro Factor(30%)",  style : "my-column", editable : false},
         {dataField : "aPerFactor70",       headerText : "Per Factor(70%)",  style : "my-column", editable : false},
         {dataField : "aSumFactor",         headerText : "Sum Factor",         style : "my-column", editable : false},
         {dataField : "aGrossComm",        headerText : "Gross Comm",        style : "my-column", editable : false},
         {dataField : "aRentalComm",       headerText : "Rental Comm",       style : "my-column", editable : false},
         {dataField : "aSrvMemComm",     headerText : "Srv Mem Comm",    style : "my-column", editable : false},
         {dataField : "aBasicAndAllowance",       headerText : "Basic And Allowance",     style : "my-column", editable : false},
         {dataField : "aPerformanceIncentive",   headerText : "Performance Incentive",  style : "my-column", editable : false},
         {dataField : "aAdjustment",                 headerText : "Adjustment",                 style : "my-column", editable : false},
         {dataField : "aCffReward",                   headerText : "CFF REWARD",               style : "my-column", editable : false},
         {dataField : "aSeniority",                     headerText : "Seniority",                    style : "my-column", editable : false},
         {dataField : "aGrandTotal",                  headerText : "Grand Total",                 style : "my-column", editable : false}
     ];
    
    var columnCTMActualLayout = [
         {dataField : "mCode",              headerText : "Member Code",     style : "my-column", editable : false, width : 80 },
         {dataField : "ctName",             headerText : "CT Name",           style : "my-column", editable : false, width : 260 },
         {dataField : "ctRank",              headerText : "CT Rank",             style : "my-column", editable : false },
         {dataField : "nric",                  headerText : "Nric",                  style : "my-column", editable : false, width : 110 },
         {dataField : "joinDate",            headerText : "Join Date",           style : "my-column", editable : false },
         {dataField : "serviceMonths",    headerText : "Service Months",   style : "my-column", editable : false },
         {dataField : "status",               headerText : "Status",               style : "my-column", editable : false },
         {dataField : "brnch",                headerText : "Branch",              style : "my-column", editable : false},
         
         {dataField : "aAsCount",           headerText : "AS Count",           style : "my-column", editable : false},
         {dataField : "aAsSumCp",          headerText : "AS Sum Cp",         style : "my-column", editable : false},
         {dataField : "aBsCount",           headerText : "BS Count",           style : "my-column", editable : false},
         {dataField : "aBsSumCp",          headerText : "BS Sum Cp",         style : "my-column", editable : false},
         {dataField : "aInsCount",          headerText : "Ins Count",           style : "my-column", editable : false},
         {dataField : "aInsSumCp",         headerText : "Ins Sum Cp",         style : "my-column", editable : false},
         {dataField : "aPrCount",            headerText : "Pr Count",            style : "my-column", editable : false},
         {dataField : "aPrSumCp",           headerText : "Pr Sum Cp",          style : "my-column", editable : false},
         {dataField : "aTotalPoint",         headerText : "Total Point",          style : "my-column", editable : false},
         {dataField : "aProPercent",        headerText : "Pro Percent",         style : "my-column", editable : false},
         {dataField : "aPerPercent",        headerText : "Per Percent",         style : "my-column", editable : false},
         {dataField : "aProFactor30",       headerText : "Pro Factor(30%)",  style : "my-column", editable : false},
         {dataField : "aPerFactor70",       headerText : "Per Factor(70%)",  style : "my-column", editable : false},
         {dataField : "aSumFactor",         headerText : "Sum Factor",         style : "my-column", editable : false},
         {dataField : "aGrossComm",        headerText : "Gross Comm",        style : "my-column", editable : false},
         {dataField : "aRentalComm",       headerText : "Rental Comm",       style : "my-column", editable : false},
         {dataField : "aSrvMemComm",     headerText : "Srv Mem Comm",    style : "my-column", editable : false},
         {dataField : "aBasicAndAllowance",       headerText : "Basic And Allowance",     style : "my-column", editable : false},
         {dataField : "aPerformanceIncentive",   headerText : "Performance Incentive",  style : "my-column", editable : false},
         {dataField : "aAdjustment",                 headerText : "Adjustment",                 style : "my-column", editable : false},
         {dataField : "aCffReward",                   headerText : "CFF REWARD",               style : "my-column", editable : false},
         {dataField : "aSeniority",                     headerText : "Seniority",                    style : "my-column", editable : false},
         {dataField : "aGrandTotal",                  headerText : "Grand Total",                 style : "my-column", editable : false}
     ];
    
/** ****************************************************************
    SIMULATION GRID
**************************************************************** **/
     
    var columnCTSimulLayout = [
        {dataField : "mCode",              headerText : "Member Code",     style : "my-column", editable : false, width : 80 },
        {dataField : "ctName",             headerText : "CT Name",           style : "my-column", editable : false, width : 260 },
        {dataField : "ctRank",              headerText : "CT Rank",             style : "my-column", editable : false },
        {dataField : "nric",                  headerText : "Nric",                  style : "my-column", editable : false, width : 110 },
        {dataField : "joinDate",            headerText : "Join Date",           style : "my-column", editable : false },
        {dataField : "serviceMonths",    headerText : "Service Months",   style : "my-column", editable : false },
        {dataField : "status",               headerText : "Status",               style : "my-column", editable : false },
        {dataField : "brnch",                headerText : "Branch",              style : "my-column", editable : false},
        
        {dataField : "sAsCount",           headerText : "AS Count",           style : "my-column", editable : false},
        {dataField : "sAsSumCp",          headerText : "AS Sum Cp",         style : "my-column", editable : false},
        {dataField : "sBsCount",           headerText : "BS Count",           style : "my-column", editable : false},
        {dataField : "sBsSumCp",          headerText : "BS Sum Cp",         style : "my-column", editable : false},
        {dataField : "sInsCount",          headerText : "Ins Count",           style : "my-column", editable : false},
        {dataField : "sInsSumCp",         headerText : "Ins Sum Cp",         style : "my-column", editable : false},
        {dataField : "sPrCount",            headerText : "Pr Count",            style : "my-column", editable : false},
        {dataField : "sPrSumCp",           headerText : "Pr Sum Cp",          style : "my-column", editable : false},
        {dataField : "sTotalPoint",         headerText : "Total Point",          style : "my-column", editable : false},
        {dataField : "sProPercent",        headerText : "Pro Percent",         style : "my-column", editable : false},
        {dataField : "sPerPercent",        headerText : "Per Percent",         style : "my-column", editable : false},
        {dataField : "sProFactor30",       headerText : "Pro Factor(30%)",  style : "my-column", editable : false},
        {dataField : "sPerFactor70",       headerText : "Per Factor(70%)",  style : "my-column", editable : false},
        {dataField : "sSumFactor",         headerText : "Sum Factor",         style : "my-column", editable : false},
        {dataField : "sGrossComm",        headerText : "Gross Comm",        style : "my-column", editable : false},
        {dataField : "sRentalComm",       headerText : "Rental Comm",       style : "my-column", editable : false},
        {dataField : "sSrvMemComm",     headerText : "Srv Mem Comm",    style : "my-column", editable : false},
        {dataField : "sBasicAndAllowance",       headerText : "Basic And Allowance",     style : "my-column", editable : false},
        {dataField : "sPerformanceIncentive",   headerText : "Performance Incentive",  style : "my-column", editable : false},
        {dataField : "sAdjustment",                 headerText : "Adjustment",                 style : "my-column", editable : false},
        {dataField : "sCffReward",                   headerText : "CFF REWARD",               style : "my-column", editable : false},
        {dataField : "sSeniority",                     headerText : "Seniority",                    style : "my-column", editable : false},
        {dataField : "sGrandTotal",                  headerText : "Grand Total",                 style : "my-column", editable : false}
    ];
    
    var columnCTLSimulLayout = [
         {dataField : "mCode",              headerText : "Member Code",     style : "my-column", editable : false, width : 80 },
         {dataField : "ctName",             headerText : "CT Name",           style : "my-column", editable : false, width : 260 },
         {dataField : "ctRank",              headerText : "CT Rank",             style : "my-column", editable : false },
         {dataField : "nric",                  headerText : "Nric",                  style : "my-column", editable : false, width : 110 },
         {dataField : "joinDate",            headerText : "Join Date",           style : "my-column", editable : false },
         {dataField : "serviceMonths",    headerText : "Service Months",   style : "my-column", editable : false },
         {dataField : "status",               headerText : "Status",               style : "my-column", editable : false },
         {dataField : "brnch",                headerText : "Branch",              style : "my-column", editable : false},
         
         {dataField : "sAsCount",           headerText : "AS Count",           style : "my-column", editable : false},
         {dataField : "sAsSumCp",          headerText : "AS Sum Cp",         style : "my-column", editable : false},
         {dataField : "sBsCount",           headerText : "BS Count",           style : "my-column", editable : false},
         {dataField : "sBsSumCp",          headerText : "BS Sum Cp",         style : "my-column", editable : false},
         {dataField : "sInsCount",          headerText : "Ins Count",           style : "my-column", editable : false},
         {dataField : "sInsSumCp",         headerText : "Ins Sum Cp",         style : "my-column", editable : false},
         {dataField : "sPrCount",            headerText : "Pr Count",            style : "my-column", editable : false},
         {dataField : "sPrSumCp",           headerText : "Pr Sum Cp",          style : "my-column", editable : false},
         {dataField : "sTotalPoint",         headerText : "Total Point",          style : "my-column", editable : false},
         {dataField : "sProPercent",        headerText : "Pro Percent",         style : "my-column", editable : false},
         {dataField : "sPerPercent",        headerText : "Per Percent",         style : "my-column", editable : false},
         {dataField : "sProFactor30",       headerText : "Pro Factor(30%)",  style : "my-column", editable : false},
         {dataField : "sPerFactor70",       headerText : "Per Factor(70%)",  style : "my-column", editable : false},
         {dataField : "sSumFactor",         headerText : "Sum Factor",         style : "my-column", editable : false},
         {dataField : "sGrossComm",        headerText : "Gross Comm",        style : "my-column", editable : false},
         {dataField : "sRentalComm",       headerText : "Rental Comm",       style : "my-column", editable : false},
         {dataField : "sSrvMemComm",     headerText : "Srv Mem Comm",    style : "my-column", editable : false},
         {dataField : "sBasicAndAllowance",       headerText : "Basic And Allowance",     style : "my-column", editable : false},
         {dataField : "sPerformanceIncentive",   headerText : "Performance Incentive",  style : "my-column", editable : false},
         {dataField : "sAdjustment",                 headerText : "Adjustment",                 style : "my-column", editable : false},
         {dataField : "sCffReward",                   headerText : "CFF REWARD",               style : "my-column", editable : false},
         {dataField : "sSeniority",                     headerText : "Seniority",                    style : "my-column", editable : false},
         {dataField : "sGrandTotal",                  headerText : "Grand Total",                 style : "my-column", editable : false}
     ];
    
    var columnCTMSimulLayout = [
         {dataField : "mCode",              headerText : "Member Code",     style : "my-column", editable : false, width : 80 },
         {dataField : "ctName",             headerText : "CT Name",           style : "my-column", editable : false, width : 260 },
         {dataField : "ctRank",              headerText : "CT Rank",             style : "my-column", editable : false },
         {dataField : "nric",                  headerText : "Nric",                  style : "my-column", editable : false, width : 110 },
         {dataField : "joinDate",            headerText : "Join Date",           style : "my-column", editable : false },
         {dataField : "serviceMonths",    headerText : "Service Months",   style : "my-column", editable : false },
         {dataField : "status",               headerText : "Status",               style : "my-column", editable : false },
         {dataField : "brnch",                headerText : "Branch",              style : "my-column", editable : false},
         
         {dataField : "sAsCount",           headerText : "AS Count",           style : "my-column", editable : false},
         {dataField : "sAsSumCp",          headerText : "AS Sum Cp",         style : "my-column", editable : false},
         {dataField : "sBsCount",           headerText : "BS Count",           style : "my-column", editable : false},
         {dataField : "sBsSumCp",          headerText : "BS Sum Cp",         style : "my-column", editable : false},
         {dataField : "sInsCount",          headerText : "Ins Count",           style : "my-column", editable : false},
         {dataField : "sInsSumCp",         headerText : "Ins Sum Cp",         style : "my-column", editable : false},
         {dataField : "sPrCount",            headerText : "Pr Count",            style : "my-column", editable : false},
         {dataField : "sPrSumCp",           headerText : "Pr Sum Cp",          style : "my-column", editable : false},
         {dataField : "sTotalPoint",         headerText : "Total Point",          style : "my-column", editable : false},
         {dataField : "sProPercent",        headerText : "Pro Percent",         style : "my-column", editable : false},
         {dataField : "sPerPercent",        headerText : "Per Percent",         style : "my-column", editable : false},
         {dataField : "sProFactor30",       headerText : "Pro Factor(30%)",  style : "my-column", editable : false},
         {dataField : "sPerFactor70",       headerText : "Per Factor(70%)",  style : "my-column", editable : false},
         {dataField : "sSumFactor",         headerText : "Sum Factor",         style : "my-column", editable : false},
         {dataField : "sGrossComm",        headerText : "Gross Comm",        style : "my-column", editable : false},
         {dataField : "sRentalComm",       headerText : "Rental Comm",       style : "my-column", editable : false},
         {dataField : "sSrvMemComm",     headerText : "Srv Mem Comm",    style : "my-column", editable : false},
         {dataField : "sBasicAndAllowance",       headerText : "Basic And Allowance",     style : "my-column", editable : false},
         {dataField : "sPerformanceIncentive",   headerText : "Performance Incentive",  style : "my-column", editable : false},
         {dataField : "sAdjustment",                 headerText : "Adjustment",                 style : "my-column", editable : false},
         {dataField : "sCffReward",                   headerText : "CFF REWARD",               style : "my-column", editable : false},
         {dataField : "sSeniority",                     headerText : "Seniority",                    style : "my-column", editable : false},
         {dataField : "sGrandTotal",                  headerText : "Grand Total",                 style : "my-column", editable : false}
     ];
    
/** ****************************************************************
    COMPARE GRID
**************************************************************** **/

    var columnCTCompareLayout = [
        {dataField : "mCode",              headerText : "Member Code",     style : "my-column", editable : false, width : 80 },
        {dataField : "ctName",             headerText : "CT Name",           style : "my-column", editable : false, width : 260 },
        {dataField : "ctRank",              headerText : "CT Rank",             style : "my-column", editable : false },
        {dataField : "nric",                  headerText : "Nric",                  style : "my-column", editable : false, width : 110 },
        {dataField : "joinDate",            headerText : "Join Date",           style : "my-column", editable : false },
        {dataField : "serviceMonths",    headerText : "Service Months",   style : "my-column", editable : false },
        {dataField : "status",               headerText : "Status",               style : "my-column", editable : false },
        {dataField : "brnch",                headerText : "Branch",              style : "my-column", editable : false},
        
        {headerText : "AS Count",            children: [{dataField: "aAsCount", headerText: "A", editable : false}, {dataField: "sAsCount", headerText: "S", editable : false}]},
        {headerText : "AS Sum Cp",          children: [{dataField: "aAsSumCp", headerText: "A", editable : false}, {dataField: "sAsSumCp", headerText: "S", editable : false}]},
        {headerText : "BS Count",            children: [{dataField: "aBsCount", headerText: "A", editable : false}, {dataField: "sBsCount", headerText: "S", editable : false}]},
        {headerText : "BS Sum Cp",          children: [{dataField: "aBsSumCp", headerText: "A", editable : false}, {dataField: "sBsSumCp", headerText: "S", editable : false}]},
        {headerText : "Ins Count",            children: [{dataField: "aInsCount", headerText: "A", editable : false}, {dataField: "sInsCount", headerText: "S", editable : false}]},
        
        {headerText : "Ins Sum Cp",         children: [{dataField: "aInsSumCp", headerText: "A", editable : false}, {dataField: "sInsSumCp", headerText: "S", editable : false}]},
        {headerText : "Pr Count",             children: [{dataField: "aPrCount", headerText: "A", editable : false}, {dataField: "sPrCount", headerText: "S", editable : false}]},
        {headerText : "Pr Sum Cp",           children: [{dataField: "aPrSumCp", headerText: "A", editable : false}, {dataField: "sPrSumCp", headerText: "S", editable : false}]},
        {headerText : "Total Point",          children: [{dataField: "aTotalPoint", headerText: "A", editable : false}, {dataField: "sTotalPoint", headerText: "S", editable : false}]},
        {headerText : "Pro Percent",         children: [{dataField: "aProPercent", headerText: "A", editable : false}, {dataField: "sProPercent", headerText: "S", editable : false}]},
        
        {headerText : "Per Percent",          children: [{dataField: "aPerPercent", headerText: "A", editable : false}, {dataField: "sPerPercent", headerText: "S", editable : false}]},
        {headerText : "Pro Factor(30%)",    children: [{dataField: "aProFactor30", headerText: "A", editable : false}, {dataField: "sProFactor30", headerText: "S", editable : false}]},
        {headerText : "Per Factor(70%)",    children: [{dataField: "aPerFactor70", headerText: "A", editable : false}, {dataField: "sPerFactor70", headerText: "S", editable : false}]},
        {headerText : "Sum Factor",           children: [{dataField: "aSumFactor", headerText: "A", editable : false}, {dataField: "sSumFactor", headerText: "S", editable : false}]},
        {headerText : "Gross Comm",          children: [{dataField: "aGrossComm", headerText: "A", editable : false}, {dataField: "sGrossComm", headerText: "S", editable : false}]},
        
        {headerText : "Rental Comm",                children: [{dataField: "aRentalComm", headerText: "A", editable : false}, {dataField: "sRentalComm", headerText: "S", editable : false}]},
        {headerText : "Srv Mem Comm",             children: [{dataField: "aSrvMemComm", headerText: "A", editable : false}, {dataField: "sSrvMemComm", headerText: "S", editable : false}]},
        {headerText : "Basic And Allowance",      children: [{dataField: "aBasicAndAllowance", headerText: "A", editable : false}, {dataField: "sBasicAndAllowance", headerText: "S", editable : false}]},
        {headerText : "Performance Incentive",   children: [{dataField: "aPerformanceIncentive", headerText: "A", editable : false}, {dataField: "sPerformanceIncentive", headerText: "S", editable : false}]},
        {headerText : "Adjustment",                  children: [{dataField: "aAdjustment", headerText: "A", editable : false}, {dataField: "sAdjustment", headerText: "S", editable : false}]},
        
        {headerText : "CFF REWARD",       children: [{dataField: "aCffReward", headerText: "A", editable : false}, {dataField: "sCffReward", headerText: "S", editable : false}]},
        {headerText : "Seniority",            children: [{dataField: "aSeniority", headerText: "A", editable : false}, {dataField: "sSeniority", headerText: "S", editable : false}]},
        {headerText : "Grand Total",        children: [{dataField: "aGrandTotal", headerText: "A", editable : false}, {dataField: "sGrandTotal", headerText: "S", editable : false}]}
    ];
    
    var columnCTLCompareLayout = [
        {dataField : "mCode",              headerText : "Member Code",     style : "my-column", editable : false, width : 80 },
        {dataField : "ctName",             headerText : "CT Name",           style : "my-column", editable : false, width : 260 },
        {dataField : "ctRank",              headerText : "CT Rank",             style : "my-column", editable : false },
        {dataField : "nric",                  headerText : "Nric",                  style : "my-column", editable : false, width : 110 },
        {dataField : "joinDate",            headerText : "Join Date",           style : "my-column", editable : false },
        {dataField : "serviceMonths",    headerText : "Service Months",   style : "my-column", editable : false },
        {dataField : "status",               headerText : "Status",               style : "my-column", editable : false },
        {dataField : "brnch",                headerText : "Branch",              style : "my-column", editable : false},
        
        {headerText : "AS Count",            children: [{dataField: "aAsCount", headerText: "A", editable : false}, {dataField: "sAsCount", headerText: "S", editable : false}]},
        {headerText : "AS Sum Cp",          children: [{dataField: "aAsSumCp", headerText: "A", editable : false}, {dataField: "sAsSumCp", headerText: "S", editable : false}]},
        {headerText : "BS Count",            children: [{dataField: "aBsCount", headerText: "A", editable : false}, {dataField: "sBsCount", headerText: "S", editable : false}]},
        {headerText : "BS Sum Cp",          children: [{dataField: "aBsSumCp", headerText: "A", editable : false}, {dataField: "sBsSumCp", headerText: "S", editable : false}]},
        {headerText : "Ins Count",            children: [{dataField: "aInsCount", headerText: "A", editable : false}, {dataField: "sInsCount", headerText: "S", editable : false}]},
        
        {headerText : "Ins Sum Cp",         children: [{dataField: "aInsSumCp", headerText: "A", editable : false}, {dataField: "sInsSumCp", headerText: "S", editable : false}]},
        {headerText : "Pr Count",             children: [{dataField: "aPrCount", headerText: "A", editable : false}, {dataField: "sPrCount", headerText: "S", editable : false}]},
        {headerText : "Pr Sum Cp",           children: [{dataField: "aPrSumCp", headerText: "A", editable : false}, {dataField: "sPrSumCp", headerText: "S", editable : false}]},
        {headerText : "Total Point",          children: [{dataField: "aTotalPoint", headerText: "A", editable : false}, {dataField: "sTotalPoint", headerText: "S", editable : false}]},
        {headerText : "Pro Percent",         children: [{dataField: "aProPercent", headerText: "A", editable : false}, {dataField: "sProPercent", headerText: "S", editable : false}]},
        
        {headerText : "Per Percent",          children: [{dataField: "aPerPercent", headerText: "A", editable : false}, {dataField: "sPerPercent", headerText: "S", editable : false}]},
        {headerText : "Pro Factor(30%)",    children: [{dataField: "aProFactor30", headerText: "A", editable : false}, {dataField: "sProFactor30", headerText: "S", editable : false}]},
        {headerText : "Per Factor(70%)",    children: [{dataField: "aPerFactor70", headerText: "A", editable : false}, {dataField: "sPerFactor70", headerText: "S", editable : false}]},
        {headerText : "Sum Factor",           children: [{dataField: "aSumFactor", headerText: "A", editable : false}, {dataField: "sSumFactor", headerText: "S", editable : false}]},
        {headerText : "Gross Comm",          children: [{dataField: "aGrossComm", headerText: "A", editable : false}, {dataField: "sGrossComm", headerText: "S", editable : false}]},
        
        {headerText : "Rental Comm",                children: [{dataField: "aRentalComm", headerText: "A", editable : false}, {dataField: "sRentalComm", headerText: "S", editable : false}]},
        {headerText : "Srv Mem Comm",             children: [{dataField: "aSrvMemComm", headerText: "A", editable : false}, {dataField: "sSrvMemComm", headerText: "S", editable : false}]},
        {headerText : "Basic And Allowance",      children: [{dataField: "aBasicAndAllowance", headerText: "A", editable : false}, {dataField: "sBasicAndAllowance", headerText: "S", editable : false}]},
        {headerText : "Performance Incentive",   children: [{dataField: "aPerformanceIncentive", headerText: "A", editable : false}, {dataField: "sPerformanceIncentive", headerText: "S", editable : false}]},
        {headerText : "Adjustment",                  children: [{dataField: "aAdjustment", headerText: "A", editable : false}, {dataField: "sAdjustment", headerText: "S", editable : false}]},
        
        {headerText : "CFF REWARD",       children: [{dataField: "aCffReward", headerText: "A", editable : false}, {dataField: "sCffReward", headerText: "S", editable : false}]},
        {headerText : "Seniority",            children: [{dataField: "aSeniority", headerText: "A", editable : false}, {dataField: "sSeniority", headerText: "S", editable : false}]},
        {headerText : "Grand Total",        children: [{dataField: "aGrandTotal", headerText: "A", editable : false}, {dataField: "sGrandTotal", headerText: "S", editable : false}]}
    ];

    var columnCTMCompareLayout = [
        {dataField : "mCode",              headerText : "Member Code",     style : "my-column", editable : false, width : 80 },
        {dataField : "ctName",             headerText : "CT Name",           style : "my-column", editable : false, width : 260 },
        {dataField : "ctRank",              headerText : "CT Rank",             style : "my-column", editable : false },
        {dataField : "nric",                  headerText : "Nric",                  style : "my-column", editable : false, width : 110 },
        {dataField : "joinDate",            headerText : "Join Date",           style : "my-column", editable : false },
        {dataField : "serviceMonths",    headerText : "Service Months",   style : "my-column", editable : false },
        {dataField : "status",               headerText : "Status",               style : "my-column", editable : false },
        {dataField : "brnch",                headerText : "Branch",              style : "my-column", editable : false},
        
        {headerText : "AS Count",            children: [{dataField: "aAsCount", headerText: "A", editable : false}, {dataField: "sAsCount", headerText: "S", editable : false}]},
        {headerText : "AS Sum Cp",          children: [{dataField: "aAsSumCp", headerText: "A", editable : false}, {dataField: "sAsSumCp", headerText: "S", editable : false}]},
        {headerText : "BS Count",            children: [{dataField: "aBsCount", headerText: "A", editable : false}, {dataField: "sBsCount", headerText: "S", editable : false}]},
        {headerText : "BS Sum Cp",          children: [{dataField: "aBsSumCp", headerText: "A", editable : false}, {dataField: "sBsSumCp", headerText: "S", editable : false}]},
        {headerText : "Ins Count",            children: [{dataField: "aInsCount", headerText: "A", editable : false}, {dataField: "sInsCount", headerText: "S", editable : false}]},
        
        {headerText : "Ins Sum Cp",         children: [{dataField: "aInsSumCp", headerText: "A", editable : false}, {dataField: "sInsSumCp", headerText: "S", editable : false}]},
        {headerText : "Pr Count",             children: [{dataField: "aPrCount", headerText: "A", editable : false}, {dataField: "sPrCount", headerText: "S", editable : false}]},
        {headerText : "Pr Sum Cp",           children: [{dataField: "aPrSumCp", headerText: "A", editable : false}, {dataField: "sPrSumCp", headerText: "S", editable : false}]},
        {headerText : "Total Point",          children: [{dataField: "aTotalPoint", headerText: "A", editable : false}, {dataField: "sTotalPoint", headerText: "S", editable : false}]},
        {headerText : "Pro Percent",         children: [{dataField: "aProPercent", headerText: "A", editable : false}, {dataField: "sProPercent", headerText: "S", editable : false}]},
        
        {headerText : "Per Percent",          children: [{dataField: "aPerPercent", headerText: "A", editable : false}, {dataField: "sPerPercent", headerText: "S", editable : false}]},
        {headerText : "Pro Factor(30%)",    children: [{dataField: "aProFactor30", headerText: "A", editable : false}, {dataField: "sProFactor30", headerText: "S", editable : false}]},
        {headerText : "Per Factor(70%)",    children: [{dataField: "aPerFactor70", headerText: "A", editable : false}, {dataField: "sPerFactor70", headerText: "S", editable : false}]},
        {headerText : "Sum Factor",           children: [{dataField: "aSumFactor", headerText: "A", editable : false}, {dataField: "sSumFactor", headerText: "S", editable : false}]},
        {headerText : "Gross Comm",          children: [{dataField: "aGrossComm", headerText: "A", editable : false}, {dataField: "sGrossComm", headerText: "S", editable : false}]},
        
        {headerText : "Rental Comm",                children: [{dataField: "aRentalComm", headerText: "A", editable : false}, {dataField: "sRentalComm", headerText: "S", editable : false}]},
        {headerText : "Srv Mem Comm",             children: [{dataField: "aSrvMemComm", headerText: "A", editable : false}, {dataField: "sSrvMemComm", headerText: "S", editable : false}]},
        {headerText : "Basic And Allowance",      children: [{dataField: "aBasicAndAllowance", headerText: "A", editable : false}, {dataField: "sBasicAndAllowance", headerText: "S", editable : false}]},
        {headerText : "Performance Incentive",   children: [{dataField: "aPerformanceIncentive", headerText: "A", editable : false}, {dataField: "sPerformanceIncentive", headerText: "S", editable : false}]},
        {headerText : "Adjustment",                  children: [{dataField: "aAdjustment", headerText: "A", editable : false}, {dataField: "sAdjustment", headerText: "S", editable : false}]},
        
        {headerText : "CFF REWARD",       children: [{dataField: "aCffReward", headerText: "A", editable : false}, {dataField: "sCffReward", headerText: "S", editable : false}]},
        {headerText : "Seniority",            children: [{dataField: "aSeniority", headerText: "A", editable : false}, {dataField: "sSeniority", headerText: "S", editable : false}]},
        {headerText : "Grand Total",        children: [{dataField: "aGrandTotal", headerText: "A", editable : false}, {dataField: "sGrandTotal", headerText: "S", editable : false}]}
    ];
    

    
	
</script>

<section id="content"><!-- content start -->
	<ul class="path">
        <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
        <li><spring:message code='commission.text.head.commission'/></li>
                <li><spring:message code='commission.text.head.report'/></li>
        <li><spring:message code='commission.text.head.ctReport'/></li>
        <li><spring:message code='commission.text.head.ctCommissionResult'/></li>
    </ul>
	
	<aside class="title_line"><!-- title_line start -->
		<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
		<h2><spring:message code='commission.title.resultCT'/></h2>
		<ul class="right_btns">
			<li><p class="btn_blue"><a href="#" id="search"><spring:message code='sys.btn.search'/></a></p></li>
			<li><p class="btn_blue"><a href="#" id="clear"><span class="clear"></span><spring:message code='sys.btn.clear'/></a></p></li>
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
						<th scope="row"><spring:message code='commission.text.search.monthYear'/></th>
						<td>
						  <input type="text" title="기준년월" class="j_date2 w50p" id="searchDt" name="searchDt" value="${searchDt }" />
						</td>
						<th scope="row"><spring:message code='commission.text.search.orgGroup'/></th>
						<td>
							<select class="w50p" id="orgGrCombo" name="orgGrCombo" disabled="disabled">
								<c:forEach var="list" items="${orgGrList }">
								    <option value="${list.cdid}">${list.cdnm} (${list.cd})</option>
								</c:forEach>
                            </select>
						</td>
						<th scope="row"><spring:message code='commission.text.search.orgType'/></th>
						<td>
                            <select class="w50p" id="orgCombo" name="orgCombo">
                                <c:forEach var="list" items="${orgList }">
                                    <option value="${list.cd}">${list.cdnm}</option>
                                </c:forEach>
                            </select>
                        </td>
					</tr>
					<tr>
						<th scope="row"><spring:message code='commission.text.search.memCode'/></th>
						<td>
						  <input type="text" style="width: 100px;" id="memCode" name="memCode" maxlength="20"/>
						  <a id="memBtn" href="#" class="search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
						</td>
						<th scope="row"><spring:message code='commission.text.search.mode'/></th>
                        <td colspan=3>
                            <label><input type="radio" name="actionType" id="actionTypeA" value="A"checked/><span><spring:message code='commission.text.search.actual'/></span></label>
	                        <label><input type="radio" name="actionType" id="actionTypeS" value="S"/><span><spring:message code='commission.text.search.simulation'/></span></label>
	                        <label><input type="radio" name="actionType" id="actionTypeC" value="C"/><span><spring:message code='commission.text.search.compare'/></span></label>
                        </td>
					</tr>
				</tbody>
			</table><!-- table end -->
		</form>
	</section><!-- search_table end -->
	
	<section class="search_result"><!-- search_result start -->
	
		<ul class="right_btns">
			<li><p class="btn_grid"><a href="javascript:fn_excelDown();"><spring:message code='commission.button.generate'/></a></p></li>
		</ul>
	
		<article class="grid_wrap"><!-- grid_wrap start -->
		    <div id="grid_wrap" style="width: 100%; height: 334px; margin: 0 auto;"></div>
			
		</article><!-- grid_wrap end -->
	
	</section><!-- search_result end -->

</section><!-- content end -->

		
<hr />

</body>
</html>