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
        
        $("#orgGrCombo option:eq(3)").attr("selected", "selected");
        
        //creat grid
        createGrid("CDN");
        
        
        $('#memBtn').click(function() {
            //Common.searchpopupWin("searchForm", "/common/memberPop.do","");
            Common.popupDiv("/common/memberPop.do", $("#myForm").serializeJSON(), null, true);
        });
        
        
        $('#search').click(function(){
        	//if($("#memCode").val() != null && $("#memCode").val() != ""){
	        	Common.ajax("GET", "/commission/report/selectCodyRawData", $("#myForm").serializeJSON() , function(result) {
	        		
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
            createGrid("CDN");
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
		if(lvl == "CDN" || lvl == "CDC"){
			if(type == "A"){
				gridID = AUIGrid.create("#grid_wrap", columnCDActualLayout,gridPros);
			}else if(type == "S"){
				gridID = AUIGrid.create("#grid_wrap", columnCDSimulLayout,gridPros);
			}else if(type == "C"){
				gridID = AUIGrid.create("#grid_wrap", columnCDCompareLayout,gridPros);
			}
		}else if(lvl == "CDM"){
			if(type == "A"){
			 gridID = AUIGrid.create("#grid_wrap", columnCMActualLayout,gridPros);
			}else if(type == "S"){
			    gridID = AUIGrid.create("#grid_wrap", columnCMSimulLayout,gridPros);
			}else if(type == "C"){
			    gridID = AUIGrid.create("#grid_wrap", columnCMCompareLayout,gridPros);
			}
		}else if(lvl == "CDS"){
			if(type == "A"){
			    gridID = AUIGrid.create("#grid_wrap", columnSCMActualLayout,gridPros);
			}else if(type == "S"){
			    gridID = AUIGrid.create("#grid_wrap", columnSCMSimulLayout,gridPros);
			}else if(type == "C"){
			    gridID = AUIGrid.create("#grid_wrap", columnSCMCompareLayout,gridPros);
			}
        }else if(lvl == "CDG"){
        	if(type == "A"){
        	    gridID = AUIGrid.create("#grid_wrap", columnGCMActualLayout,gridPros);
        	}else if(type == "S"){
        	    gridID = AUIGrid.create("#grid_wrap", columnGCMSimulLayout,gridPros);
        	}else if(type == "C"){
        	    gridID = AUIGrid.create("#grid_wrap", columnGCMCompareLayout,gridPros);
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
        	fileNm = "CDresultIndex_Actual_"+today;
        }else if(type == "S"){
        	fileNm = "CDresultIndex_Simul_"+today;
        }else if(type == "C"){
        	fileNm = "CDresultIndex_Actual_N_Simul_"+today;
        }
        fileNm=fileNm+".xlsx"
        
        /* if(Number(grdLength) > 0){
            GridCommon.exportTo("grid_wrap", "xlsx", fileNm);
        }else{
            Common.alert("No Data");
        } */
        
        var codeNm = "result_CD";
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
	
	var columnCDActualLayout = [
	    {dataField : "memCode",           headerText : "<spring:message code='commissiom.text.excel.memCode'/>",     style : "my-column", editable : false, width : 80 },
	    {dataField : "memName",          headerText : "<spring:message code='commissiom.text.excel.memNm'/>",     style : "my-column", editable : false, width : 260 },
	    {dataField : "rank",                 headerText : "<spring:message code='commissiom.text.excel.rank'/>",             style : "my-column", editable : false },
	    {dataField : "nric",                  headerText : "<spring:message code='commissiom.text.excel.nric'/>",              style : "my-column", editable : false, width : 110 },
	    {dataField : "stus",                  headerText : "<spring:message code='commissiom.text.excel.emplyStusCd'/>",              style : "my-column", editable : false, width : 110 },
	    
	    {dataField : "aCrdSumPoint",      headerText : "<spring:message code='commissiom.text.excel.crdSumPoint'/>",        style : "my-column", editable : false },
	    {dataField : "aHappycallRate",    headerText : "<spring:message code='commissiom.text.excel.happyCallRate'/>",        style : "my-column", editable : false },
	    {dataField : "aHappycallMark",    headerText : "<spring:message code='commissiom.text.excel.happyCallMarks'/>",        style : "my-column", editable : false },
	    {dataField : "aHsRate",              headerText : "<spring:message code='commissiom.text.excel.hsRate'/>",        style : "my-column", editable : false },
	    {dataField : "aHsMark",              headerText : "<spring:message code='commissiom.text.excel.hsMark'/>",        style : "my-column", editable : false },
	    
	    {dataField : "aRcRate",              headerText : "<spring:message code='commissiom.text.excel.rcRate'/>",        style : "my-column", editable : false },
	    {dataField : "aRcMark",              headerText : "<spring:message code='commissiom.text.excel.rcMark'/>",        style : "my-column", editable : false },
	    {dataField : "aNsRate",              headerText : "<spring:message code='commissiom.text.excel.nsRate'/>",        style : "my-column", editable : false },
	    {dataField : "aNsMark",              headerText : "<spring:message code='commissiom.text.excel.nsMark'/>",        style : "my-column", editable : false },
	    
	    {dataField : "aDropRate",                           headerText : "<spring:message code='commissiom.text.excel.dropRate'/>",        style : "my-column", editable : false },
	    {dataField : "aDropMark",                           headerText : "<spring:message code='commissiom.text.excel.dropMark'/>",        style : "my-column", editable : false },
	    
	    {dataField : "aPerAmt",              headerText : "<spring:message code='commissiom.text.excel.perAmt'/>",        style : "my-column", editable : false },
	    {dataField : "aSalesAmt",           headerText : "<spring:message code='commissiom.text.excel.salesAmt'/>",        style : "my-column", editable : false },
	    {dataField : "aOutplsAmt",         headerText : "<spring:message code='commissiom.text.excel.outplaAmt'/>",        style : "my-column", editable : false },
	    {dataField : "aBonusAmt",          headerText : "<spring:message code='commissiom.text.excel.bonusAmt'/>",        style : "my-column", editable : false },
	    {dataField : "aCollectAmt",         headerText : "<spring:message code='commissiom.text.excel.collectAmt'/>",        style : "my-column", editable : false },
	    {dataField : "aMembershipAmt",   headerText : "<spring:message code='commissiom.text.excel.membershipAmt'/>",        style : "my-column", editable : false },
	    
	    {dataField : "aPeAmt",               headerText : "<spring:message code='commission.text.grid.peAmt'/>",        style : "my-column", editable : false },
	    {dataField : "aPeMark",               headerText : "<spring:message code='commissiom.text.excel.peMark'/>",        style : "my-column", editable : false },
	    {dataField : "aHealthyFamilyAmt",headerText : "<spring:message code='commissiom.text.excel.healthFamAmt'/>",        style : "my-column", editable : false },
	    {dataField : "aNewcodyAmt",      headerText : "<spring:message code='commissiom.text.excel.newcodyAmt'/>",        style : "my-column", editable : false },
	    /* {dataField : "aMonthlyAllowance",headerText : "<spring:message code='commissiom.text.excel.monthlyAllowance'/>",        style : "my-column", editable : false }, */
	    {dataField : "aIntroductionFees", headerText : "<spring:message code='commissiom.text.excel.introducFees'/>",        style : "my-column", editable : false },
	    
	    {dataField : "aMobilePhone",       headerText : "<spring:message code='commissiom.text.excel.mobilePhone'/>",        style : "my-column", editable : false },
	    {dataField : "aStaffPurchase",     headerText : "<spring:message code='commissiom.text.excel.staffPurchase'/>",        style : "my-column", editable : false },
	    {dataField : "aTelephoneDeduct", headerText : "<spring:message code='commissiom.text.excel.telephoneDeduct'/>",        style : "my-column", editable : false }, 
	    {dataField : "aIncentive",           headerText : "<spring:message code='commissiom.text.excel.incentive'/>",        style : "my-column", editable : false },
	    {dataField : "aAdj",                   headerText : "<spring:message code='commissiom.text.excel.adj'/>",        style : "my-column", editable : false },
	    
	    {dataField : "aCodyRegistrationFees",                   headerText : "<spring:message code='commissiom.text.excel.codyRegistrationFees'/>",        style : "my-column", editable : false },
	    {dataField : "aShiAmt",                         headerText : "<spring:message code='commissiom.text.excel.shiAmt'/>",        style : "my-column", editable : false }, 
	    {dataField : "aRentalmembershipAmt",     headerText : "<spring:message code='commissiom.text.excel.rentalmembershipAmt'/>",        style : "my-column", editable : false },
	    {dataField : "aShiRentalmembershipAmt", headerText : "<spring:message code='commission.text.grid.shiRentalMemAmt'/>",        style : "my-column", editable : false } ,
	    {dataField : "aPosDeduction",                   headerText : "<spring:message code='commission.text.grid.posDeduction'/>",        style : "my-column", editable : false },
	    {dataField : "aAmount",                   headerText : "<spring:message code='commissiom.text.excel.grandTot'/>",        style : "my-column", editable : false }
	];
    
    var columnCMActualLayout = [
        {dataField : "memCode",           headerText : "<spring:message code='commissiom.text.excel.memCode'/>",     style : "my-column", editable : false, width : 80 },
        {dataField : "memName",          headerText : "<spring:message code='commissiom.text.excel.memNm'/>",     style : "my-column", editable : false, width : 260 },
        {dataField : "rank",                 headerText : "<spring:message code='commissiom.text.excel.rank'/>",             style : "my-column", editable : false },
        {dataField : "nric",                  headerText : "<spring:message code='commissiom.text.excel.nric'/>",              style : "my-column", editable : false, width : 110 },
        {dataField : "stus",                  headerText : "<spring:message code='commissiom.text.excel.emplyStusCd'/>",              style : "my-column", editable : false, width : 110 },
        
        {dataField : "lastDeptCode",                  headerText : "<spring:message code='commissiom.text.excel.deptCd'/>",              style : "my-column", editable : false, width : 110 },
        {dataField : "lastGrpCode",                  headerText : "<spring:message code='commissiom.text.excel.grpCd'/>",              style : "my-column", editable : false, width : 110 },
        {dataField : "lastOrgCode",                  headerText : "<spring:message code='commissiom.text.excel.orgCd'/>",              style : "my-column", editable : false, width : 110 },
        
        {dataField : "aHappycallRate",    headerText : "<spring:message code='commissiom.text.excel.happyCallRate'/>",        style : "my-column", editable : false },
        {dataField : "aHappycallMark",    headerText : "<spring:message code='commissiom.text.excel.happyCallMarks'/>",        style : "my-column", editable : false },
        {dataField : "aBsRate",              headerText : "<spring:message code='commissiom.text.excel.hsRate'/>",        style : "my-column", editable : false },
        {dataField : "aBsMark",              headerText : "<spring:message code='commissiom.text.excel.hsMark'/>",        style : "my-column", editable : false },
        {dataField : "aRcRate",              headerText : "<spring:message code='commissiom.text.excel.rcRate'/>",        style : "my-column", editable : false },
        
        {dataField : "aRcMark",              headerText : "<spring:message code='commissiom.text.excel.rcMark'/>",        style : "my-column", editable : false },
        {dataField : "aRejoinMark",         headerText : "<spring:message code='commissiom.text.excel.rejoinMark'/>",        style : "my-column", editable : false },
        {dataField : "aRejoinRate",         headerText : "<spring:message code='commissiom.text.excel.rejoinRate'/>",        style : "my-column", editable : false },
        {dataField : "aGroupSalesProduct",              headerText : "<spring:message code='commissiom.text.excel.grpSalesProductivity'/>",        style : "my-column", editable : false },
        {dataField : "aGroupSalesProductMark",        headerText : "<spring:message code='commissiom.text.excel.grpSalesProducMark'/>",        style : "my-column", editable : false },
        {dataField : "aBsProductivityRate",            headerText : "<spring:message code='commissiom.text.excel.bsProductivityRate'/>",        style : "my-column", editable : false },
        {dataField : "aBsProductivityMark",            headerText : "<spring:message code='commissiom.text.excel.bsProductivityMark'/>",        style : "my-column", editable : false },
 
        {dataField : "aDropRate",                           headerText : "<spring:message code='commissiom.text.excel.dropRate'/>",        style : "my-column", editable : false },
        {dataField : "aDropMark",                           headerText : "<spring:message code='commissiom.text.excel.dropMark'/>",        style : "my-column", editable : false },
        {dataField : "aPeMark",               headerText : "<spring:message code='commissiom.text.excel.peMark'/>",        style : "my-column", editable : false },
        
        {dataField : "aBasicSalary",              headerText : "<spring:message code='commissiom.text.excel.basicSalary'/>",        style : "my-column", editable : false },
        {dataField : "aSalesAmt",           headerText : "<spring:message code='commissiom.text.excel.salesAmt'/>",        style : "my-column", editable : false },
        {dataField : "aOutplsAmt", headerText : "<spring:message code='commissiom.text.excel.outplaAmt'/>",        style : "my-column", editable : false },
        {dataField : "aBonusAmt",          headerText : "<spring:message code='commissiom.text.excel.bonusAmt'/>",        style : "my-column", editable : false },
        {dataField : "aCollectAmt",         headerText : "<spring:message code='commissiom.text.excel.collectAmt'/>",        style : "my-column", editable : false },
        {dataField : "aMembershipAmt",   headerText : "<spring:message code='commissiom.text.excel.membershipAmt'/>",        style : "my-column", editable : false }, 
        
        {dataField : "aHpAmt",               headerText : "<spring:message code='commissiom.text.excel.hpAmt'/>",        style : "my-column", editable : false },
        {dataField : "aTransportAmt",headerText : "<spring:message code='commissiom.text.excel.transportAmt'/>",        style : "my-column", editable : false },
        {dataField : "aMonthlyAllowance",headerText : "<spring:message code='commissiom.text.excel.monthlyAllowance'/>",        style : "my-column", editable : false },
        {dataField : "aMobilePhone",      headerText : "<spring:message code='commissiom.text.excel.mobilePhone'/>",        style : "my-column", editable : false }, 
        {dataField : "aIntroductionFees", headerText : "<spring:message code='commissiom.text.excel.introducFees'/>",        style : "my-column", editable : false },
        
        {dataField : "aStaffPurchase",     headerText : "<spring:message code='commissiom.text.excel.staffPurchase'/>",        style : "my-column", editable : false },
        {dataField : "aTelephoneDeduct", headerText : "<spring:message code='commissiom.text.excel.telephoneDeduct'/>",        style : "my-column", editable : false },
        {dataField : "aIncentive",           headerText : "<spring:message code='commissiom.text.excel.incentive'/>",        style : "my-column", editable : false },
        {dataField : "aAdj",                   headerText : "<spring:message code='commissiom.text.excel.adj'/>",        style : "my-column", editable : false }, 
        {dataField : "aShiAmt",                         headerText : "<spring:message code='commissiom.text.excel.shiAmt'/>",        style : "my-column", editable : false },

        {dataField : "aRentalmembershipAmt",     headerText : "<spring:message code='commissiom.text.excel.rentalmembershipAmt'/>",        style : "my-column", editable : false },
        {dataField : "aPosDeduction",                   headerText : "<spring:message code='commission.text.grid.posDeduction'/>",        style : "my-column", editable : false },
        {dataField : "aAmount",                   headerText : "<spring:message code='commissiom.text.excel.grandTot'/>",        style : "my-column", editable : false }
    ];
	
    var columnSCMActualLayout = [
        {dataField : "memCode",           headerText : "<spring:message code='commissiom.text.excel.memCode'/>",     style : "my-column", editable : false, width : 80 },
        {dataField : "memName",          headerText : "<spring:message code='commissiom.text.excel.memNm'/>",     style : "my-column", editable : false, width : 260 },
        {dataField : "rank",                 headerText : "<spring:message code='commissiom.text.excel.rank'/>",             style : "my-column", editable : false },
        {dataField : "nric",                  headerText : "<spring:message code='commissiom.text.excel.nric'/>",              style : "my-column", editable : false, width : 110 },
        {dataField : "stus",                  headerText : "<spring:message code='commissiom.text.excel.emplyStusCd'/>",              style : "my-column", editable : false, width : 110 },
        
        {dataField : "lastDeptCode",                  headerText : "<spring:message code='commissiom.text.excel.deptCd'/>",              style : "my-column", editable : false, width : 110 },
        {dataField : "lastGrpCode",                  headerText : "<spring:message code='commissiom.text.excel.grpCd'/>",              style : "my-column", editable : false, width : 110 },
        {dataField : "lastOrgCode",                  headerText : "<spring:message code='commissiom.text.excel.orgCd'/>",              style : "my-column", editable : false, width : 110 },
        
        {dataField : "aHappycallRate",    headerText : "<spring:message code='commissiom.text.excel.happyCallRate'/>",        style : "my-column", editable : false },
        {dataField : "aHappycallMark",    headerText : "<spring:message code='commissiom.text.excel.happyCallMarks'/>",        style : "my-column", editable : false },
        {dataField : "aBsRate",              headerText : "<spring:message code='commissiom.text.excel.hsRate'/>",        style : "my-column", editable : false },
        {dataField : "aBsMark",              headerText : "<spring:message code='commissiom.text.excel.hsMark'/>",        style : "my-column", editable : false },
        {dataField : "aRcRate",              headerText : "<spring:message code='commissiom.text.excel.rcRate'/>",        style : "my-column", editable : false },
        
        {dataField : "aRcMark",              headerText : "<spring:message code='commissiom.text.excel.rcMark'/>",        style : "my-column", editable : false },
        {dataField : "aRejoinMark",         headerText : "<spring:message code='commissiom.text.excel.rejoinMark'/>",        style : "my-column", editable : false },
        {dataField : "aRejoinRate",         headerText : "<spring:message code='commissiom.text.excel.rejoinRate'/>",        style : "my-column", editable : false },
        {dataField : "aGroupSalesProduct",              headerText : "<spring:message code='commissiom.text.excel.grpSalesProductivity'/>",        style : "my-column", editable : false },
        {dataField : "aGroupSalesProductMark",        headerText : "<spring:message code='commissiom.text.excel.grpSalesProducMark'/>",        style : "my-column", editable : false },
        {dataField : "aBsProductivityRate",            headerText : "<spring:message code='commissiom.text.excel.bsProductivityRate'/>",        style : "my-column", editable : false },
        {dataField : "aBsProductivityMark",            headerText : "<spring:message code='commissiom.text.excel.bsProductivityMark'/>",        style : "my-column", editable : false },
 
        {dataField : "aDropRate",                           headerText : "<spring:message code='commissiom.text.excel.dropRate'/>",        style : "my-column", editable : false },
        {dataField : "aDropMark",                           headerText : "<spring:message code='commissiom.text.excel.dropMark'/>",        style : "my-column", editable : false },
        {dataField : "aPeMark",               headerText : "<spring:message code='commissiom.text.excel.peMark'/>",        style : "my-column", editable : false },
        
        {dataField : "aBasicSalary",              headerText : "<spring:message code='commissiom.text.excel.basicSalary'/>",        style : "my-column", editable : false },
        {dataField : "aSalesAmt",           headerText : "<spring:message code='commissiom.text.excel.salesAmt'/>",        style : "my-column", editable : false },
        {dataField : "aOutplsAmt", headerText : "<spring:message code='commissiom.text.excel.outplaAmt'/>",        style : "my-column", editable : false },
        {dataField : "aBonusAmt",          headerText : "<spring:message code='commissiom.text.excel.bonusAmt'/>",        style : "my-column", editable : false },
        {dataField : "aCollectAmt",         headerText : "<spring:message code='commissiom.text.excel.collectAmt'/>",        style : "my-column", editable : false },
        {dataField : "aMembershipAmt",   headerText : "<spring:message code='commissiom.text.excel.membershipAmt'/>",        style : "my-column", editable : false }, 
        
        {dataField : "aHpAmt",               headerText : "<spring:message code='commissiom.text.excel.hpAmt'/>",        style : "my-column", editable : false },
        {dataField : "aTransportAmt",headerText : "<spring:message code='commissiom.text.excel.transportAmt'/>",        style : "my-column", editable : false },
        {dataField : "aMonthlyAllowance",headerText : "<spring:message code='commissiom.text.excel.monthlyAllowance'/>",        style : "my-column", editable : false },
        {dataField : "aMobilePhone",      headerText : "<spring:message code='commissiom.text.excel.mobilePhone'/>",        style : "my-column", editable : false }, 
        {dataField : "aIntroductionFees", headerText : "<spring:message code='commissiom.text.excel.introducFees'/>",        style : "my-column", editable : false },
        
        {dataField : "aStaffPurchase",     headerText : "<spring:message code='commissiom.text.excel.staffPurchase'/>",        style : "my-column", editable : false },
        {dataField : "aTelephoneDeduct", headerText : "<spring:message code='commissiom.text.excel.telephoneDeduct'/>",        style : "my-column", editable : false },
        {dataField : "aIncentive",           headerText : "<spring:message code='commissiom.text.excel.incentive'/>",        style : "my-column", editable : false },
        {dataField : "aAdj",                   headerText : "<spring:message code='commissiom.text.excel.adj'/>",        style : "my-column", editable : false }, 
        {dataField : "aShiAmt",                         headerText : "<spring:message code='commissiom.text.excel.shiAmt'/>",        style : "my-column", editable : false },

        {dataField : "aRentalmembershipAmt",     headerText : "<spring:message code='commissiom.text.excel.rentalmembershipAmt'/>",        style : "my-column", editable : false },
        {dataField : "aPosDeduction",                   headerText : "<spring:message code='commission.text.grid.posDeduction'/>",        style : "my-column", editable : false },
        {dataField : "aAmount",                   headerText : "<spring:message code='commissiom.text.excel.grandTot'/>",        style : "my-column", editable : false }
    ];
	
    var columnGCMActualLayout = [
        {dataField : "memCode",           headerText : "<spring:message code='commissiom.text.excel.memCode'/>",     style : "my-column", editable : false, width : 80 },
        {dataField : "memName",          headerText : "<spring:message code='commissiom.text.excel.memNm'/>",     style : "my-column", editable : false, width : 260 },
        {dataField : "rank",                 headerText : "<spring:message code='commissiom.text.excel.rank'/>",             style : "my-column", editable : false },
        {dataField : "nric",                  headerText : "<spring:message code='commissiom.text.excel.nric'/>",              style : "my-column", editable : false, width : 110 },
        {dataField : "stus",                  headerText : "<spring:message code='commissiom.text.excel.emplyStusCd'/>",              style : "my-column", editable : false, width : 110 },
        
        {dataField : "lastDeptCode",                  headerText : "<spring:message code='commissiom.text.excel.deptCd'/>",              style : "my-column", editable : false, width : 110 },
        {dataField : "lastGrpCode",                  headerText : "<spring:message code='commissiom.text.excel.grpCd'/>",              style : "my-column", editable : false, width : 110 },
        {dataField : "lastOrgCode",                  headerText : "<spring:message code='commissiom.text.excel.orgCd'/>",              style : "my-column", editable : false, width : 110 },
        
        {dataField : "aHappycallRate",    headerText : "<spring:message code='commissiom.text.excel.happyCallRate'/>",        style : "my-column", editable : false },
        {dataField : "aHappycallMark",    headerText : "<spring:message code='commissiom.text.excel.happyCallMarks'/>",        style : "my-column", editable : false },
        {dataField : "aBsRate",              headerText : "<spring:message code='commissiom.text.excel.hsRate'/>",        style : "my-column", editable : false },
        {dataField : "aBsMark",              headerText : "<spring:message code='commissiom.text.excel.hsMark'/>",        style : "my-column", editable : false },
        {dataField : "aRcRate",              headerText : "<spring:message code='commissiom.text.excel.rcRate'/>",        style : "my-column", editable : false },
        
        {dataField : "aRcMark",              headerText : "<spring:message code='commissiom.text.excel.rcMark'/>",        style : "my-column", editable : false },
        {dataField : "aRejoinMark",         headerText : "<spring:message code='commissiom.text.excel.rejoinMark'/>",        style : "my-column", editable : false },
        {dataField : "aRejoinRate",         headerText : "<spring:message code='commissiom.text.excel.rejoinRate'/>",        style : "my-column", editable : false },
        {dataField : "aGroupSalesProduct",              headerText : "<spring:message code='commissiom.text.excel.grpSalesProductivity'/>",        style : "my-column", editable : false },
        {dataField : "aGroupSalesProductMark",        headerText : "<spring:message code='commissiom.text.excel.grpSalesProducMark'/>",        style : "my-column", editable : false },
        {dataField : "aBsProductivityRate",            headerText : "<spring:message code='commissiom.text.excel.bsProductivityRate'/>",        style : "my-column", editable : false },
        {dataField : "aBsProductivityMark",            headerText : "<spring:message code='commissiom.text.excel.bsProductivityMark'/>",        style : "my-column", editable : false },
 
        {dataField : "aDropRate",                           headerText : "<spring:message code='commissiom.text.excel.dropRate'/>",        style : "my-column", editable : false },
        {dataField : "aDropMark",                           headerText : "<spring:message code='commissiom.text.excel.dropMark'/>",        style : "my-column", editable : false },
        {dataField : "aPeMark",               headerText : "<spring:message code='commissiom.text.excel.peMark'/>",        style : "my-column", editable : false },
        
        {dataField : "aBasicSalary",              headerText : "<spring:message code='commissiom.text.excel.basicSalary'/>",        style : "my-column", editable : false },
        {dataField : "aSalesAmt",           headerText : "<spring:message code='commissiom.text.excel.salesAmt'/>",        style : "my-column", editable : false },
        {dataField : "aOutplsAmt", headerText : "<spring:message code='commissiom.text.excel.outplaAmt'/>",        style : "my-column", editable : false },
        {dataField : "aBonusAmt",          headerText : "<spring:message code='commissiom.text.excel.bonusAmt'/>",        style : "my-column", editable : false },
        {dataField : "aCollectAmt",         headerText : "<spring:message code='commissiom.text.excel.collectAmt'/>",        style : "my-column", editable : false },
        {dataField : "aMembershipAmt",   headerText : "<spring:message code='commissiom.text.excel.membershipAmt'/>",        style : "my-column", editable : false }, 
        
        {dataField : "aHpAmt",               headerText : "<spring:message code='commissiom.text.excel.hpAmt'/>",        style : "my-column", editable : false },
        {dataField : "aTransportAmt",headerText : "<spring:message code='commissiom.text.excel.transportAmt'/>",        style : "my-column", editable : false },
        {dataField : "aMonthlyAllowance",headerText : "<spring:message code='commissiom.text.excel.monthlyAllowance'/>",        style : "my-column", editable : false },
        {dataField : "aMobilePhone",      headerText : "<spring:message code='commissiom.text.excel.mobilePhone'/>",        style : "my-column", editable : false }, 
        {dataField : "aIntroductionFees", headerText : "<spring:message code='commissiom.text.excel.introducFees'/>",        style : "my-column", editable : false },
        
        {dataField : "aStaffPurchase",     headerText : "<spring:message code='commissiom.text.excel.staffPurchase'/>",        style : "my-column", editable : false },
        {dataField : "aTelephoneDeduct", headerText : "<spring:message code='commissiom.text.excel.telephoneDeduct'/>",        style : "my-column", editable : false },
        {dataField : "aIncentive",           headerText : "<spring:message code='commissiom.text.excel.incentive'/>",        style : "my-column", editable : false },
        {dataField : "aAdj",                   headerText : "<spring:message code='commissiom.text.excel.adj'/>",        style : "my-column", editable : false }, 
        {dataField : "aShiAmt",                         headerText : "<spring:message code='commissiom.text.excel.shiAmt'/>",        style : "my-column", editable : false },

        {dataField : "aRentalmembershipAmt",     headerText : "<spring:message code='commissiom.text.excel.rentalmembershipAmt'/>",        style : "my-column", editable : false },
        {dataField : "aPosDeduction",                   headerText : "<spring:message code='commission.text.grid.posDeduction'/>",        style : "my-column", editable : false },
        {dataField : "aAmount",                   headerText : "<spring:message code='commissiom.text.excel.grandTot'/>",        style : "my-column", editable : false }
    ];
	
/** ****************************************************************
    SIMULATION GRID
**************************************************************** **/

	var columnCDSimulLayout = [
		{dataField : "memCode",           headerText : "<spring:message code='commissiom.text.excel.memCode'/>",     style : "my-column", editable : false, width : 80 },
		{dataField : "memName",          headerText : "<spring:message code='commissiom.text.excel.memNm'/>",     style : "my-column", editable : false, width : 260 },
		{dataField : "rank",                 headerText : "<spring:message code='commissiom.text.excel.rank'/>",             style : "my-column", editable : false },
		{dataField : "nric",                  headerText : "<spring:message code='commissiom.text.excel.nric'/>",              style : "my-column", editable : false, width : 110 },
		{dataField : "stus",                  headerText : "<spring:message code='commissiom.text.excel.emplyStusCd'/>",              style : "my-column", editable : false, width : 110 },
		{dataField : "sCrdSumPoint",      headerText : "CRD Sum Point",        style : "my-column", editable : false },
        {dataField : "sHappycallRate",    headerText : "<spring:message code='commissiom.text.excel.happyCallRate'/>",        style : "my-column", editable : false },
        {dataField : "sHappycallMark",    headerText : "<spring:message code='commissiom.text.excel.happyCallMarks'/>",        style : "my-column", editable : false },
        {dataField : "sHsRate",              headerText : "<spring:message code='commissiom.text.excel.hsRate'/>",        style : "my-column", editable : false },
        {dataField : "sHsMark",              headerText : "<spring:message code='commissiom.text.excel.hsMark'/>",        style : "my-column", editable : false },
        
        {dataField : "sRcRate",              headerText : "<spring:message code='commissiom.text.excel.rcRate'/>",        style : "my-column", editable : false },
        {dataField : "sRcMark",              headerText : "<spring:message code='commissiom.text.excel.rcMark'/>",        style : "my-column", editable : false },
        {dataField : "sNsRate",              headerText : "<spring:message code='commissiom.text.excel.nsRate'/>",        style : "my-column", editable : false },
        {dataField : "sNsMark",              headerText : "<spring:message code='commissiom.text.excel.nsMark'/>",        style : "my-column", editable : false },
        
        /* {dataField : "sGroupSalesProduct",              headerText : "<spring:message code='commissiom.text.excel.grpSalesProductivity'/>",        style : "my-column", editable : false },
        {dataField : "sGroupSalesProductMark",        headerText : "<spring:message code='commissiom.text.excel.grpSalesProducMark'/>",        style : "my-column", editable : false },
        {dataField : "sBsProductivityMark",            headerText : "<spring:message code='commissiom.text.excel.bsProductivityMark'/>",        style : "my-column", editable : false }, */
        {dataField : "sDropRate",                           headerText : "<spring:message code='commissiom.text.excel.dropRate'/>",        style : "my-column", editable : false },
        {dataField : "sDropMark",                           headerText : "<spring:message code='commissiom.text.excel.dropMark'/>",        style : "my-column", editable : false },
        
        {dataField : "sPerAmt",              headerText : "Per AMT",        style : "my-column", editable : false },
        {dataField : "sSalesAmt",           headerText : "<spring:message code='commissiom.text.excel.salesAmt'/>",        style : "my-column", editable : false },
        {dataField : "sOutplsAmt",         headerText : "<spring:message code='commissiom.text.excel.outplaAmt'/>",        style : "my-column", editable : false },
        {dataField : "sBonusAmt",          headerText : "<spring:message code='commissiom.text.excel.bonusAmt'/>",        style : "my-column", editable : false },
        {dataField : "sCollectAmt",         headerText : "<spring:message code='commissiom.text.excel.collectAmt'/>",        style : "my-column", editable : false },
        {dataField : "sMembershipAmt",   headerText : "<spring:message code='commissiom.text.excel.membershipAmt'/>",        style : "my-column", editable : false },
        
        {dataField : "sPeAmt",               headerText : "<spring:message code='commission.text.grid.peAmt'/>",        style : "my-column", editable : false },
        {dataField : "sPeMark",               headerText : "<spring:message code='commissiom.text.excel.peMark'/>",        style : "my-column", editable : false },
        {dataField : "sHealthyFamilyAmt",headerText : "<spring:message code='commissiom.text.excel.healthFamAmt'/>",        style : "my-column", editable : false },
        {dataField : "sNewcodyAmt",      headerText : "<spring:message code='commissiom.text.excel.newcodyAmt'/>",        style : "my-column", editable : false },
        /* {dataField : "sMonthlyAllowance",headerText : "<spring:message code='commissiom.text.excel.monthlyAllowance'/>",        style : "my-column", editable : false }, */
        {dataField : "sIntroductionFees", headerText : "<spring:message code='commissiom.text.excel.introducFees'/>",        style : "my-column", editable : false },
        
        {dataField : "sMobilePhone",       headerText : "<spring:message code='commissiom.text.excel.mobilePhone'/>",        style : "my-column", editable : false },
        {dataField : "sStaffPurchase",     headerText : "<spring:message code='commissiom.text.excel.staffPurchase'/>",        style : "my-column", editable : false },
        {dataField : "sTelephoneDeduct", headerText : "<spring:message code='commissiom.text.excel.telephoneDeduct'/>",        style : "my-column", editable : false }, 
        {dataField : "sIncentive",           headerText : "<spring:message code='commissiom.text.excel.incentive'/>",        style : "my-column", editable : false },
        {dataField : "sAdj",                   headerText : "<spring:message code='commissiom.text.excel.adj'/>",        style : "my-column", editable : false },
        
        {dataField : "sCodyRegistrationFees",                   headerText : "<spring:message code='commissiom.text.excel.codyRegistrationFees'/>",        style : "my-column", editable : false },
        {dataField : "sShiAmt",                         headerText : "<spring:message code='commissiom.text.excel.shiAmt'/>",        style : "my-column", editable : false }, 
        {dataField : "sRentalmembershipAmt",     headerText : "<spring:message code='commissiom.text.excel.rentalmembershipAmt'/>",        style : "my-column", editable : false },
        {dataField : "sShiRentalmembershipAmt", headerText : "<spring:message code='commission.text.grid.shiRentalMemAmt'/>",        style : "my-column", editable : false } ,
        {dataField : "sPosDeduction",                   headerText : "<spring:message code='commission.text.grid.posDeduction'/>",        style : "my-column", editable : false },
        {dataField : "sAmount",                   headerText : "<spring:message code='commissiom.text.excel.grandTot'/>",        style : "my-column", editable : false }
	];
	
	var columnCMSimulLayout = [
		{dataField : "memCode",           headerText : "<spring:message code='commissiom.text.excel.memCode'/>",     style : "my-column", editable : false, width : 80 },
        {dataField : "memName",          headerText : "<spring:message code='commissiom.text.excel.memNm'/>",     style : "my-column", editable : false, width : 260 },
        {dataField : "rank",                 headerText : "<spring:message code='commissiom.text.excel.rank'/>",             style : "my-column", editable : false },
        {dataField : "nric",                  headerText : "<spring:message code='commissiom.text.excel.nric'/>",              style : "my-column", editable : false, width : 110 },
        {dataField : "stus",                  headerText : "<spring:message code='commissiom.text.excel.emplyStusCd'/>",              style : "my-column", editable : false, width : 110 },
        
        {dataField : "lastDeptCode",                  headerText : "<spring:message code='commissiom.text.excel.deptCd'/>",              style : "my-column", editable : false, width : 110 },
        {dataField : "lastGrpCode",                  headerText : "<spring:message code='commissiom.text.excel.grpCd'/>",              style : "my-column", editable : false, width : 110 },
        {dataField : "lastOrgCode",                  headerText : "<spring:message code='commissiom.text.excel.orgCd'/>",              style : "my-column", editable : false, width : 110 },
		
        {dataField : "sHappycallRate",    headerText : "<spring:message code='commissiom.text.excel.happyCallRate'/>",        style : "my-column", editable : false },
        {dataField : "sHappycallMark",    headerText : "<spring:message code='commissiom.text.excel.happyCallMarks'/>",        style : "my-column", editable : false },
        {dataField : "sBsRate",              headerText : "<spring:message code='commissiom.text.excel.hsRate'/>",        style : "my-column", editable : false },
        {dataField : "sBsMark",              headerText : "<spring:message code='commissiom.text.excel.hsMark'/>",        style : "my-column", editable : false },
        {dataField : "sRcRate",              headerText : "<spring:message code='commissiom.text.excel.rcRate'/>",        style : "my-column", editable : false },
        
        {dataField : "sRcMark",              headerText : "<spring:message code='commissiom.text.excel.rcMark'/>",        style : "my-column", editable : false },
        {dataField : "sRejoinMark",         headerText : "<spring:message code='commissiom.text.excel.rejoinMark'/>",        style : "my-column", editable : false },
        {dataField : "sRejoinRate",         headerText : "<spring:message code='commissiom.text.excel.rejoinRate'/>",        style : "my-column", editable : false },
        {dataField : "sGroupSalesProduct",              headerText : "<spring:message code='commissiom.text.excel.grpSalesProductivity'/>",        style : "my-column", editable : false },
        {dataField : "sGroupSalesProductMark",        headerText : "<spring:message code='commissiom.text.excel.grpSalesProducMark'/>",        style : "my-column", editable : false },
        {dataField : "sBsProductivityRate",            headerText : "<spring:message code='commissiom.text.excel.bsProductivityRate'/>",        style : "my-column", editable : false },
        {dataField : "sBsProductivityMark",            headerText : "<spring:message code='commissiom.text.excel.bsProductivityMark'/>",        style : "my-column", editable : false },
 
        {dataField : "sDropRate",                           headerText : "<spring:message code='commissiom.text.excel.dropRate'/>",        style : "my-column", editable : false },
        {dataField : "sDropMark",                           headerText : "<spring:message code='commissiom.text.excel.dropMark'/>",        style : "my-column", editable : false },
        {dataField : "sPeMark",               headerText : "<spring:message code='commissiom.text.excel.peMark'/>",        style : "my-column", editable : false },
        
        {dataField : "sBasicSalary",              headerText : "<spring:message code='commissiom.text.excel.basicSalary'/>",        style : "my-column", editable : false },
        {dataField : "sSalesAmt",           headerText : "<spring:message code='commissiom.text.excel.salesAmt'/>",        style : "my-column", editable : false },
        {dataField : "sOutplsAmt", headerText : "<spring:message code='commissiom.text.excel.outplaAmt'/>",        style : "my-column", editable : false },
        {dataField : "sBonusAmt",          headerText : "<spring:message code='commissiom.text.excel.bonusAmt'/>",        style : "my-column", editable : false },
        {dataField : "sCollectAmt",         headerText : "<spring:message code='commissiom.text.excel.collectAmt'/>",        style : "my-column", editable : false },
        {dataField : "sMembershipAmt",   headerText : "<spring:message code='commissiom.text.excel.membershipAmt'/>",        style : "my-column", editable : false }, 
        
        {dataField : "sHpAmt",               headerText : "<spring:message code='commissiom.text.excel.hpAmt'/>",        style : "my-column", editable : false },
        {dataField : "sTransportAmt",headerText : "<spring:message code='commissiom.text.excel.transportAmt'/>",        style : "my-column", editable : false },
        {dataField : "sMonthlyAllowance",headerText : "<spring:message code='commissiom.text.excel.monthlyAllowance'/>",        style : "my-column", editable : false },
        {dataField : "sMobilePhone",      headerText : "<spring:message code='commissiom.text.excel.mobilePhone'/>",        style : "my-column", editable : false }, 
        {dataField : "sIntroductionFees", headerText : "<spring:message code='commissiom.text.excel.introducFees'/>",        style : "my-column", editable : false },
        
        {dataField : "sStaffPurchase",     headerText : "<spring:message code='commissiom.text.excel.staffPurchase'/>",        style : "my-column", editable : false },
        {dataField : "sTelephoneDeduct", headerText : "<spring:message code='commissiom.text.excel.telephoneDeduct'/>",        style : "my-column", editable : false },
        {dataField : "sIncentive",           headerText : "<spring:message code='commissiom.text.excel.incentive'/>",        style : "my-column", editable : false },
        {dataField : "sAdj",                   headerText : "<spring:message code='commissiom.text.excel.adj'/>",        style : "my-column", editable : false }, 
        {dataField : "sShiAmt",                         headerText : "<spring:message code='commissiom.text.excel.shiAmt'/>",        style : "my-column", editable : false },

        {dataField : "sRentalmembershipAmt",     headerText : "<spring:message code='commissiom.text.excel.rentalmembershipAmt'/>",        style : "my-column", editable : false },
        {dataField : "sPosDeduction",                   headerText : "<spring:message code='commission.text.grid.posDeduction'/>",        style : "my-column", editable : false },
        {dataField : "sAmount",                   headerText : "<spring:message code='commissiom.text.excel.grandTot'/>",        style : "my-column", editable : false }
	];
	
	var columnSCMSimulLayout = [
		{dataField : "memCode",           headerText : "<spring:message code='commissiom.text.excel.memCode'/>",     style : "my-column", editable : false, width : 80 },
        {dataField : "memName",          headerText : "<spring:message code='commissiom.text.excel.memNm'/>",     style : "my-column", editable : false, width : 260 },
        {dataField : "rank",                 headerText : "<spring:message code='commissiom.text.excel.rank'/>",             style : "my-column", editable : false },
        {dataField : "nric",                  headerText : "<spring:message code='commissiom.text.excel.nric'/>",              style : "my-column", editable : false, width : 110 },
        {dataField : "stus",                  headerText : "<spring:message code='commissiom.text.excel.emplyStusCd'/>",              style : "my-column", editable : false, width : 110 },
        
        {dataField : "lastDeptCode",                  headerText : "<spring:message code='commissiom.text.excel.deptCd'/>",              style : "my-column", editable : false, width : 110 },
        {dataField : "lastGrpCode",                  headerText : "<spring:message code='commissiom.text.excel.grpCd'/>",              style : "my-column", editable : false, width : 110 },
        {dataField : "lastOrgCode",                  headerText : "<spring:message code='commissiom.text.excel.orgCd'/>",              style : "my-column", editable : false, width : 110 },
		
        {dataField : "sHappycallRate",    headerText : "<spring:message code='commissiom.text.excel.happyCallRate'/>",        style : "my-column", editable : false },
        {dataField : "sHappycallMark",    headerText : "<spring:message code='commissiom.text.excel.happyCallMarks'/>",        style : "my-column", editable : false },
        {dataField : "sBsRate",              headerText : "<spring:message code='commissiom.text.excel.hsRate'/>",        style : "my-column", editable : false },
        {dataField : "sBsMark",              headerText : "<spring:message code='commissiom.text.excel.hsMark'/>",        style : "my-column", editable : false },
        {dataField : "sRcRate",              headerText : "<spring:message code='commissiom.text.excel.rcRate'/>",        style : "my-column", editable : false },
        
        {dataField : "sRcMark",              headerText : "<spring:message code='commissiom.text.excel.rcMark'/>",        style : "my-column", editable : false },
        {dataField : "sRejoinMark",         headerText : "<spring:message code='commissiom.text.excel.rejoinMark'/>",        style : "my-column", editable : false },
        {dataField : "sRejoinRate",         headerText : "<spring:message code='commissiom.text.excel.rejoinRate'/>",        style : "my-column", editable : false },
        {dataField : "sGroupSalesProduct",              headerText : "<spring:message code='commissiom.text.excel.grpSalesProductivity'/>",        style : "my-column", editable : false },
        {dataField : "sGroupSalesProductMark",        headerText : "<spring:message code='commissiom.text.excel.grpSalesProducMark'/>",        style : "my-column", editable : false },
        {dataField : "sBsProductivityRate",            headerText : "<spring:message code='commissiom.text.excel.bsProductivityRate'/>",        style : "my-column", editable : false },
        {dataField : "sBsProductivityMark",            headerText : "<spring:message code='commissiom.text.excel.bsProductivityMark'/>",        style : "my-column", editable : false },
 
        {dataField : "sDropRate",                           headerText : "<spring:message code='commissiom.text.excel.dropRate'/>",        style : "my-column", editable : false },
        {dataField : "sDropMark",                           headerText : "<spring:message code='commissiom.text.excel.dropMark'/>",        style : "my-column", editable : false },
        {dataField : "sPeMark",               headerText : "<spring:message code='commissiom.text.excel.peMark'/>",        style : "my-column", editable : false },
        
        {dataField : "sBasicSalary",              headerText : "<spring:message code='commissiom.text.excel.basicSalary'/>",        style : "my-column", editable : false },
        {dataField : "sSalesAmt",           headerText : "<spring:message code='commissiom.text.excel.salesAmt'/>",        style : "my-column", editable : false },
        {dataField : "sOutplsAmt", headerText : "<spring:message code='commissiom.text.excel.outplaAmt'/>",        style : "my-column", editable : false },
        {dataField : "sBonusAmt",          headerText : "<spring:message code='commissiom.text.excel.bonusAmt'/>",        style : "my-column", editable : false },
        {dataField : "sCollectAmt",         headerText : "<spring:message code='commissiom.text.excel.collectAmt'/>",        style : "my-column", editable : false },
        {dataField : "sMembershipAmt",   headerText : "<spring:message code='commissiom.text.excel.membershipAmt'/>",        style : "my-column", editable : false }, 
        
        {dataField : "sHpAmt",               headerText : "<spring:message code='commissiom.text.excel.hpAmt'/>",        style : "my-column", editable : false },
        {dataField : "sTransportAmt",headerText : "<spring:message code='commissiom.text.excel.transportAmt'/>",        style : "my-column", editable : false },
        {dataField : "sMonthlyAllowance",headerText : "<spring:message code='commissiom.text.excel.monthlyAllowance'/>",        style : "my-column", editable : false },
        {dataField : "sMobilePhone",      headerText : "<spring:message code='commissiom.text.excel.mobilePhone'/>",        style : "my-column", editable : false }, 
        {dataField : "sIntroductionFees", headerText : "<spring:message code='commissiom.text.excel.introducFees'/>",        style : "my-column", editable : false },
        
        {dataField : "sStaffPurchase",     headerText : "<spring:message code='commissiom.text.excel.staffPurchase'/>",        style : "my-column", editable : false },
        {dataField : "sTelephoneDeduct", headerText : "<spring:message code='commissiom.text.excel.telephoneDeduct'/>",        style : "my-column", editable : false },
        {dataField : "sIncentive",           headerText : "<spring:message code='commissiom.text.excel.incentive'/>",        style : "my-column", editable : false },
        {dataField : "sAdj",                   headerText : "<spring:message code='commissiom.text.excel.adj'/>",        style : "my-column", editable : false }, 
        {dataField : "sShiAmt",                         headerText : "<spring:message code='commissiom.text.excel.shiAmt'/>",        style : "my-column", editable : false },

        {dataField : "sRentalmembershipAmt",     headerText : "<spring:message code='commissiom.text.excel.rentalmembershipAmt'/>",        style : "my-column", editable : false },
        {dataField : "sPosDeduction",                   headerText : "<spring:message code='commission.text.grid.posDeduction'/>",        style : "my-column", editable : false },
        {dataField : "sAmount",                   headerText : "<spring:message code='commissiom.text.excel.grandTot'/>",        style : "my-column", editable : false }
	];
	
	var columnGCMSimulLayout = [
		{dataField : "memCode",           headerText : "<spring:message code='commissiom.text.excel.memCode'/>",     style : "my-column", editable : false, width : 80 },
        {dataField : "memName",          headerText : "<spring:message code='commissiom.text.excel.memNm'/>",     style : "my-column", editable : false, width : 260 },
        {dataField : "rank",                 headerText : "<spring:message code='commissiom.text.excel.rank'/>",             style : "my-column", editable : false },
        {dataField : "nric",                  headerText : "<spring:message code='commissiom.text.excel.nric'/>",              style : "my-column", editable : false, width : 110 },
        {dataField : "stus",                  headerText : "<spring:message code='commissiom.text.excel.emplyStusCd'/>",              style : "my-column", editable : false, width : 110 },
        
        {dataField : "lastDeptCode",                  headerText : "<spring:message code='commissiom.text.excel.deptCd'/>",              style : "my-column", editable : false, width : 110 },
        {dataField : "lastGrpCode",                  headerText : "<spring:message code='commissiom.text.excel.grpCd'/>",              style : "my-column", editable : false, width : 110 },
        {dataField : "lastOrgCode",                  headerText : "<spring:message code='commissiom.text.excel.orgCd'/>",              style : "my-column", editable : false, width : 110 },
		
        {dataField : "sHappycallRate",    headerText : "<spring:message code='commissiom.text.excel.happyCallRate'/>",        style : "my-column", editable : false },
        {dataField : "sHappycallMark",    headerText : "<spring:message code='commissiom.text.excel.happyCallMarks'/>",        style : "my-column", editable : false },
        {dataField : "sBsRate",              headerText : "<spring:message code='commissiom.text.excel.hsRate'/>",        style : "my-column", editable : false },
        {dataField : "sBsMark",              headerText : "<spring:message code='commissiom.text.excel.hsMark'/>",        style : "my-column", editable : false },
        {dataField : "sRcRate",              headerText : "<spring:message code='commissiom.text.excel.rcRate'/>",        style : "my-column", editable : false },
        
        {dataField : "sRcMark",              headerText : "<spring:message code='commissiom.text.excel.rcMark'/>",        style : "my-column", editable : false },
        {dataField : "sRejoinMark",         headerText : "<spring:message code='commissiom.text.excel.rejoinMark'/>",        style : "my-column", editable : false },
        {dataField : "sRejoinRate",         headerText : "<spring:message code='commissiom.text.excel.rejoinRate'/>",        style : "my-column", editable : false },
        {dataField : "sGroupSalesProduct",              headerText : "<spring:message code='commissiom.text.excel.grpSalesProductivity'/>",        style : "my-column", editable : false },
        {dataField : "sGroupSalesProductMark",        headerText : "<spring:message code='commissiom.text.excel.grpSalesProducMark'/>",        style : "my-column", editable : false },
        {dataField : "sBsProductivityRate",            headerText : "<spring:message code='commissiom.text.excel.bsProductivityRate'/>",        style : "my-column", editable : false },
        {dataField : "sBsProductivityMark",            headerText : "<spring:message code='commissiom.text.excel.bsProductivityMark'/>",        style : "my-column", editable : false },
 
        {dataField : "sDropRate",                           headerText : "<spring:message code='commissiom.text.excel.dropRate'/>",        style : "my-column", editable : false },
        {dataField : "sDropMark",                           headerText : "<spring:message code='commissiom.text.excel.dropMark'/>",        style : "my-column", editable : false },
        {dataField : "sPeMark",               headerText : "<spring:message code='commissiom.text.excel.peMark'/>",        style : "my-column", editable : false },
        
        {dataField : "sBasicSalary",              headerText : "<spring:message code='commissiom.text.excel.basicSalary'/>",        style : "my-column", editable : false },
        {dataField : "sSalesAmt",           headerText : "<spring:message code='commissiom.text.excel.salesAmt'/>",        style : "my-column", editable : false },
        {dataField : "sOutplsAmt", headerText : "<spring:message code='commissiom.text.excel.outplaAmt'/>",        style : "my-column", editable : false },
        {dataField : "sBonusAmt",          headerText : "<spring:message code='commissiom.text.excel.bonusAmt'/>",        style : "my-column", editable : false },
        {dataField : "sCollectAmt",         headerText : "<spring:message code='commissiom.text.excel.collectAmt'/>",        style : "my-column", editable : false },
        {dataField : "sMembershipAmt",   headerText : "<spring:message code='commissiom.text.excel.membershipAmt'/>",        style : "my-column", editable : false }, 
        
        {dataField : "sHpAmt",               headerText : "<spring:message code='commissiom.text.excel.hpAmt'/>",        style : "my-column", editable : false },
        {dataField : "sTransportAmt",headerText : "<spring:message code='commissiom.text.excel.transportAmt'/>",        style : "my-column", editable : false },
        {dataField : "sMonthlyAllowance",headerText : "<spring:message code='commissiom.text.excel.monthlyAllowance'/>",        style : "my-column", editable : false },
        {dataField : "sMobilePhone",      headerText : "<spring:message code='commissiom.text.excel.mobilePhone'/>",        style : "my-column", editable : false }, 
        {dataField : "sIntroductionFees", headerText : "<spring:message code='commissiom.text.excel.introducFees'/>",        style : "my-column", editable : false },
        
        {dataField : "sStaffPurchase",     headerText : "<spring:message code='commissiom.text.excel.staffPurchase'/>",        style : "my-column", editable : false },
        {dataField : "sTelephoneDeduct", headerText : "<spring:message code='commissiom.text.excel.telephoneDeduct'/>",        style : "my-column", editable : false },
        {dataField : "sIncentive",           headerText : "<spring:message code='commissiom.text.excel.incentive'/>",        style : "my-column", editable : false },
        {dataField : "sAdj",                   headerText : "<spring:message code='commissiom.text.excel.adj'/>",        style : "my-column", editable : false }, 
        {dataField : "sShiAmt",                         headerText : "<spring:message code='commissiom.text.excel.shiAmt'/>",        style : "my-column", editable : false },

        {dataField : "sRentalmembershipAmt",     headerText : "<spring:message code='commissiom.text.excel.rentalmembershipAmt'/>",        style : "my-column", editable : false },
        {dataField : "sPosDeduction",                   headerText : "<spring:message code='commission.text.grid.posDeduction'/>",        style : "my-column", editable : false },
        {dataField : "sAmount",                   headerText : "<spring:message code='commissiom.text.excel.grandTot'/>",        style : "my-column", editable : false }
	];

/** ****************************************************************
    COMPARE GRID
**************************************************************** **/
	var columnCDCompareLayout = [
	    {dataField : "memCode",           headerText : "<spring:message code='commissiom.text.excel.memCode'/>",            style : "my-column", editable : false, width : 80},
	    {dataField : "memName",          headerText : "<spring:message code='commissiom.text.excel.memNm'/>",            style : "my-column", editable : false, width : 260 },
	    {dataField : "rank",                 headerText : "<spring:message code='commissiom.text.excel.rank'/>",                    style : "my-column", editable : false },
	    {dataField : "nric",                  headerText : "<spring:message code='commissiom.text.excel.nric'/>",             style : "my-column", editable : false, width : 110 },
	    {dataField : "stus",                  headerText : "<spring:message code='commissiom.text.excel.emplyStusCd'/>",              style : "my-column", editable : false, width : 110 },
	    
	    {headerText : "<spring:message code='commissiom.text.excel.crdSumPoint'/>",   children: [{dataField: "aCrdSumPoint", headerText: "A", editable : false}, {dataField: "sCrdSumPoint", headerText: "S", editable : false}]},
	    {headerText : "<spring:message code='commissiom.text.excel.happyCallRate'/>",  children: [{dataField: "aHappycallRate", headerText: "A", editable : false}, {dataField: "sHappycallRate", headerText: "S", editable : false}]},
	    {headerText : "<spring:message code='commissiom.text.excel.happyCallMarks'/>",   children: [{dataField: "aHappycallMark", headerText: "A", editable : false}, {dataField: "sHappycallMark", headerText: "S", editable : false}]},
	    {headerText : "<spring:message code='commissiom.text.excel.hsRate'/>",            children: [{dataField: "aHsRate", headerText: "A", editable : false}, {dataField: "sHsRate", headerText: "S", editable : false}]},
	    {headerText : "<spring:message code='commissiom.text.excel.hsMark'/>",            children: [{dataField: "aHsMark", headerText: "A", editable : false}, {dataField: "sHsMark", headerText: "S", editable : false}]},
	    
	    {headerText : "<spring:message code='commissiom.text.excel.rcRate'/>",            children: [{dataField: "aRcRate", headerText: "A", editable : false}, {dataField: "sRcRate", headerText: "S", editable : false}]},
	    {headerText : "<spring:message code='commissiom.text.excel.rcMark'/>",            children: [{dataField: "aRcMark", headerText: "A", editable : false}, {dataField: "sRcMark", headerText: "S", editable : false}]},
	    {headerText : "<spring:message code='commissiom.text.excel.nsRate'/>",            children: [{dataField: "aNsRate", headerText: "A", editable : false}, {dataField: "sNsRate", headerText: "S", editable : false}]},
	    {headerText : "<spring:message code='commissiom.text.excel.nsMark'/>",            children: [{dataField: "aNsMark", headerText: "A", editable : false}, {dataField: "sNsMark", headerText: "S", editable : false}]},
	    
	    /* {headerText : "<spring:message code='commissiom.text.excel.grpSalesProductivity'/>",          children: [{dataField: "aGroupSalesProduct", headerText: "A", editable : false}, {dataField: "sGroupSalesProduct", headerText: "S", editable : false}]},
	    {headerText : "<spring:message code='commissiom.text.excel.grpSalesProducMark'/>",   children: [{dataField: "aGroupSalesProductMark", headerText: "A", editable : false}, {dataField: "sGroupSalesProductMark", headerText: "S", editable : false}]},
	    {headerText : "<spring:message code='commissiom.text.excel.bsProductivityMark'/>",          children: [{dataField: "aBsProductivityMark", headerText: "A", editable : false}, {dataField: "sBsProductivityMark", headerText: "S", editable : false}]}, */ 
	    {headerText : "<spring:message code='commissiom.text.excel.dropRate'/>",                        children: [{dataField: "aDropRate", headerText: "A", editable : false}, {dataField: "sDropRate", headerText: "S", editable : false}]},
	    {headerText : "<spring:message code='commissiom.text.excel.dropMark'/>",                        children: [{dataField: "aDropMark", headerText: "A", editable : false}, {dataField: "sDropMark", headerText: "S", editable : false}]},
	    
	    {headerText : "<spring:message code='commissiom.text.excel.perAmt'/>",                children: [{dataField: "aPerAmt", headerText: "A", editable : false}, {dataField: "sPerAmt", headerText: "S", editable : false}]},
	    {headerText : "<spring:message code='commissiom.text.excel.salesAmt'/>",             children: [{dataField: "aSalesAmt", headerText: "A", editable : false}, {dataField: "sSalesAmt", headerText: "S", editable : false}]},
	    {headerText : "<spring:message code='commissiom.text.excel.outplaAmt'/>",        children: [{dataField: "aOutplsAmt", headerText: "A", editable : false}, {dataField: "sOutplsAmt", headerText: "S", editable : false}]}, 
	    {headerText : "<spring:message code='commissiom.text.excel.bonusAmt'/>",            children: [{dataField: "aBonusAmt", headerText: "A", editable : false}, {dataField: "sBonusAmt", headerText: "S", editable : false}]},
	    {headerText : "<spring:message code='commissiom.text.excel.collectAmt'/>",           children: [{dataField: "aCollectAmt", headerText: "A", editable : false}, {dataField: "sCollectAmt", headerText: "S", editable : false}]},
	    {headerText : "<spring:message code='commissiom.text.excel.membershipAmt'/>",     children: [{dataField: "aMembershipAmt", headerText: "A", editable : false}, {dataField: "sMembershipAmt", headerText: "S", editable : false}]},
	    
	    {headerText : "<spring:message code='commission.text.grid.peAmt'/>",                 children: [{dataField: "aPeAmt", headerText: "A", editable : false}, {dataField: "sPeAmt", headerText: "S", editable : false}]},
	    {headerText : "<spring:message code='commissiom.text.excel.peMark'/>",                 children: [{dataField: "aPeMark", headerText: "A", editable : false}, {dataField: "sPeMark", headerText: "S", editable : false}]},
	    {headerText : "<spring:message code='commissiom.text.excel.healthFamAmt'/>", children: [{dataField: "aHealthyFamilyAmt", headerText: "A", editable : false}, {dataField: "sHealthyFamilyAmt", headerText: "S", editable : false}]},
	    {headerText : "<spring:message code='commissiom.text.excel.newcodyAmt'/>",        children: [{dataField: "aNewcodyAmt", headerText: "A", editable : false}, {dataField: "sNewcodyAmt", headerText: "S", editable : false}]},
	    {headerText : "<spring:message code='commissiom.text.excel.introducFees'/>",   children: [{dataField: "aIntroductionFees", headerText: "A", editable : false}, {dataField: "sIntroductionFees", headerText: "S", editable : false}]},
	    
	    {headerText : "<spring:message code='commissiom.text.excel.mobilePhone'/>",        children: [{dataField: "aMobilePhone", headerText: "A", editable : false}, {dataField: "sMobilePhone", headerText: "S", editable : false}]},
	    {headerText : "<spring:message code='commissiom.text.excel.staffPurchase'/>",      children: [{dataField: "aStaffPurchase", headerText: "A", editable : false}, {dataField: "sStaffPurchase", headerText: "S", editable : false}]},
	    {headerText : "<spring:message code='commissiom.text.excel.telephoneDeduct'/>",  children: [{dataField: "aTelephoneDeduct", headerText: "A", editable : false}, {dataField: "sTelephoneDeduct", headerText: "S", editable : false}]},
	    {headerText : "<spring:message code='commissiom.text.excel.incentive'/>",             children: [{dataField: "aIncentive", headerText: "A", editable : false}, {dataField: "sIncentive", headerText: "S", editable : false}]},
	    {headerText : "<spring:message code='commissiom.text.excel.adj'/>",                     children: [{dataField: "aAdj", headerText: "A", editable : false}, {dataField: "sAdj", headerText: "S", editable : false}]}, 
	    
	    {headerText : "<spring:message code='commissiom.text.excel.codyRegistrationFees'/>",                     children: [{dataField: "aCodyRegistrationFees", headerText: "A", editable : false}, {dataField: "sCodyRegistrationFees", headerText: "S", editable : false}]},
	    {headerText : "<spring:message code='commissiom.text.excel.shiAmt'/>",                    children: [{dataField: "aShiAmt", headerText: "A", editable : false}, {dataField: "sShiAmt", headerText: "S", editable : false}]}, 
	    {headerText : "<spring:message code='commissiom.text.excel.rentalmembershipAmt'/>",       children: [{dataField: "aRentalmembershipAmt", headerText: "A", editable : false}, {dataField: "sRentalmembershipAmt", headerText: "S", editable : false}]},
	    {headerText : "<spring:message code='commission.text.grid.shiRentalMemAmt'/>",   children: [{dataField: "aShiRentalmembershipAmt", headerText: "A", editable : false}, {dataField: "sShiRentalmembershipAmt", headerText: "S", editable : false}]},
	    {headerText : "<spring:message code='commission.text.grid.posDeduction'/>",                     children: [{dataField: "aPosDeduction", headerText: "A", editable : false}, {dataField: "sPosDeduction", headerText: "S", editable : false}]}, 
	    {headerText : "<spring:message code='commissiom.text.excel.grandTot'/>",                     children: [{dataField: "aAmount", headerText: "A", editable : false}, {dataField: "sAmount", headerText: "S", editable : false}]}
	];
	
	var columnCMCompareLayout = [
	    {dataField : "memCode",           headerText : "<spring:message code='commissiom.text.excel.memCode'/>",            style : "my-column", editable : false, width : 80},
	    {dataField : "memName",          headerText : "<spring:message code='commissiom.text.excel.memNm'/>",            style : "my-column", editable : false, width : 260 },
	    {dataField : "rank",                 headerText : "<spring:message code='commissiom.text.excel.rank'/>",                    style : "my-column", editable : false },
	    {dataField : "nric",                  headerText : "<spring:message code='commissiom.text.excel.nric'/>",             style : "my-column", editable : false, width : 110 },
	    {dataField : "stus",                  headerText : "<spring:message code='commissiom.text.excel.emplyStusCd'/>",              style : "my-column", editable : false, width : 110 },
	    
	    {dataField : "lastDeptCode",                  headerText : "<spring:message code='commissiom.text.excel.deptCd'/>",              style : "my-column", editable : false, width : 110 },
        {dataField : "lastGrpCode",                  headerText : "<spring:message code='commissiom.text.excel.grpCd'/>",              style : "my-column", editable : false, width : 110 },
        {dataField : "lastOrgCode",                  headerText : "<spring:message code='commissiom.text.excel.orgCd'/>",              style : "my-column", editable : false, width : 110 },
	    
	    {headerText : "<spring:message code='commissiom.text.excel.happyCallRate'/>",  children: [{dataField: "aHappycallRate", headerText: "A", editable : false}, {dataField: "sHappycallRate", headerText: "S", editable : false}]},
	    {headerText : "<spring:message code='commissiom.text.excel.happyCallMarks'/>",   children: [{dataField: "aHappycallMark", headerText: "A", editable : false}, {dataField: "sHappycallMark", headerText: "S", editable : false}]},
	    {headerText : "<spring:message code='commissiom.text.excel.hsRate'/>",            children: [{dataField: "aBsRate", headerText: "A", editable : false}, {dataField: "sBsRate", headerText: "S", editable : false}]},
	    {headerText : "<spring:message code='commissiom.text.excel.hsMark'/>",            children: [{dataField: "aBsMark", headerText: "A", editable : false}, {dataField: "sBsMark", headerText: "S", editable : false}]},
	    {headerText : "<spring:message code='commissiom.text.excel.rcRate'/>",            children: [{dataField: "aRcRate", headerText: "A", editable : false}, {dataField: "sRcRate", headerText: "S", editable : false}]},
	    
	    {headerText : "<spring:message code='commissiom.text.excel.rcMark'/>",            children: [{dataField: "aRcMark", headerText: "A", editable : false}, {dataField: "sRcMark", headerText: "S", editable : false}]},
	    {headerText : "<spring:message code='commissiom.text.excel.rejoinMark'/>",        children: [{dataField: "aRejoinMark", headerText: "A", editable : false}, {dataField: "sRejoinMark", headerText: "S", editable : false}]},
	    {headerText : "<spring:message code='commissiom.text.excel.rejoinRate'/>",        children: [{dataField: "aRejoinRate", headerText: "A", editable : false}, {dataField: "sRejoinRate", headerText: "S", editable : false}]},
        {headerText : "<spring:message code='commissiom.text.excel.grpSalesProductivity'/>",          children: [{dataField: "aGroupSalesProduct", headerText: "A", editable : false}, {dataField: "sGroupSalesProduct", headerText: "S", editable : false}]},
        {headerText : "<spring:message code='commissiom.text.excel.grpSalesProducMark'/>",   children: [{dataField: "aGroupSalesProductMark", headerText: "A", editable : false}, {dataField: "sGroupSalesProductMark", headerText: "S", editable : false}]},
        {headerText : "<spring:message code='commissiom.text.excel.bsProductivityRate'/>",          children: [{dataField: "aBsProductivityRate", headerText: "A", editable : false}, {dataField: "sBsProductivityRate", headerText: "S", editable : false}]},
        {headerText : "<spring:message code='commissiom.text.excel.bsProductivityMark'/>",          children: [{dataField: "aBsProductivityMark", headerText: "A", editable : false}, {dataField: "sBsProductivityMark", headerText: "S", editable : false}]},
        
        {headerText : "<spring:message code='commissiom.text.excel.dropRate'/>",                        children: [{dataField: "aDropRate", headerText: "A", editable : false}, {dataField: "sDropRate", headerText: "S", editable : false}]},
        {headerText : "<spring:message code='commissiom.text.excel.dropMark'/>",                        children: [{dataField: "aDropMark", headerText: "A", editable : false}, {dataField: "sDropMark", headerText: "S", editable : false}]},
        {headerText : "<spring:message code='commissiom.text.excel.peMark'/>",                 children: [{dataField: "aPeMark", headerText: "A", editable : false}, {dataField: "sPeMark", headerText: "S", editable : false}]},
        
        {headerText : "<spring:message code='commissiom.text.excel.basicSalary'/>",                children: [{dataField: "aBasicSalary", headerText: "A", editable : false}, {dataField: "sBasicSalary", headerText: "S", editable : false}]},
        {headerText : "<spring:message code='commissiom.text.excel.salesAmt'/>",             children: [{dataField: "aSalesAmt", headerText: "A", editable : false}, {dataField: "sSalesAmt", headerText: "S", editable : false}]},
	    {headerText : "<spring:message code='commissiom.text.excel.outplaAmt'/>",   children: [{dataField: "aOutplsAmt", headerText: "A", editable : false}, {dataField: "sOutplsAmt", headerText: "S", editable : false}]},
        {headerText : "<spring:message code='commissiom.text.excel.bonusAmt'/>",            children: [{dataField: "aBonusAmt", headerText: "A", editable : false}, {dataField: "sBonusAmt", headerText: "S", editable : false}]},
        {headerText : "<spring:message code='commissiom.text.excel.collectAmt'/>",           children: [{dataField: "aCollectAmt", headerText: "A", editable : false}, {dataField: "sCollectAmt", headerText: "S", editable : false}]},
        {headerText : "<spring:message code='commissiom.text.excel.membershipAmt'/>",     children: [{dataField: "aMembershipAmt", headerText: "A", editable : false}, {dataField: "sMembershipAmt", headerText: "S", editable : false}]}, 
        
        {headerText : "<spring:message code='commissiom.text.excel.hpAmt'/>",                 children: [{dataField: "aHpAmt", headerText: "A", editable : false}, {dataField: "sHpAmt", headerText: "S", editable : false}]},
        {headerText : "<spring:message code='commissiom.text.excel.transportAmt'/>", children: [{dataField: "aTransportAmt", headerText: "A", editable : false}, {dataField: "sTransportAmt", headerText: "S", editable : false}]},
        {headerText : "<spring:message code='commissiom.text.excel.monthlyAllowance'/>",  children: [{dataField: "aMonthlyAllowance", headerText: "A", editable : false}, {dataField: "sMonthlyAllowance", headerText: "S", editable : false}]},
        {headerText : "<spring:message code='commissiom.text.excel.mobilePhone'/>",        children: [{dataField: "aMobilePhone", headerText: "A", editable : false}, {dataField: "sMobilePhone", headerText: "S", editable : false}]},
        {headerText : "<spring:message code='commissiom.text.excel.introducFees'/>",   children: [{dataField: "aIntroductionFees", headerText: "A", editable : false}, {dataField: "sIntroductionFees", headerText: "S", editable : false}]}, 
	    
	    {headerText : "<spring:message code='commissiom.text.excel.staffPurchase'/>",      children: [{dataField: "aStaffPurchase", headerText: "A", editable : false}, {dataField: "sStaffPurchase", headerText: "S", editable : false}]}, 
	    {headerText : "<spring:message code='commissiom.text.excel.telephoneDeduct'/>",  children: [{dataField: "aTelephoneDeduct", headerText: "A", editable : false}, {dataField: "sTelephoneDeduct", headerText: "S", editable : false}]},
	    {headerText : "<spring:message code='commissiom.text.excel.incentive'/>",             children: [{dataField: "aIncentive", headerText: "A", editable : false}, {dataField: "sIncentive", headerText: "S", editable : false}]},
	    {headerText : "<spring:message code='commissiom.text.excel.adj'/>",                     children: [{dataField: "aAdj", headerText: "A", editable : false}, {dataField: "sAdj", headerText: "S", editable : false}]}, 
	    {headerText : "<spring:message code='commissiom.text.excel.shiAmt'/>",                    children: [{dataField: "aShiAmt", headerText: "A", editable : false}, {dataField: "sShiAmt", headerText: "S", editable : false}]},
	    
	    {headerText : "<spring:message code='commissiom.text.excel.rentalmembershipAmt'/>",       children: [{dataField: "aRentalmembershipAmt", headerText: "A", editable : false}, {dataField: "sRentalmembershipAmt", headerText: "S", editable : false}]},
	    {headerText : "<spring:message code='commission.text.grid.posDeduction'/>",                     children: [{dataField: "aPosDeduction", headerText: "A", editable : false}, {dataField: "sPosDeduction", headerText: "S", editable : false}]},
	    {headerText : "<spring:message code='commissiom.text.excel.grandTot'/>",                     children: [{dataField: "aAmount", headerText: "A", editable : false}, {dataField: "sAmount", headerText: "S", editable : false}]}
	];
	
	var columnSCMCompareLayout = [
	    {dataField : "memCode",           headerText : "<spring:message code='commissiom.text.excel.memCode'/>",            style : "my-column", editable : false, width : 80},
	    {dataField : "memName",          headerText : "<spring:message code='commissiom.text.excel.memNm'/>",            style : "my-column", editable : false, width : 260 },
	    {dataField : "rank",                 headerText : "<spring:message code='commissiom.text.excel.rank'/>",                    style : "my-column", editable : false },
	    {dataField : "nric",                  headerText : "<spring:message code='commissiom.text.excel.nric'/>",             style : "my-column", editable : false, width : 110 },
	    {dataField : "stus",                  headerText : "<spring:message code='commissiom.text.excel.emplyStusCd'/>",              style : "my-column", editable : false, width : 110 },
	    
	    {dataField : "lastDeptCode",                  headerText : "<spring:message code='commissiom.text.excel.deptCd'/>",              style : "my-column", editable : false, width : 110 },
        {dataField : "lastGrpCode",                  headerText : "<spring:message code='commissiom.text.excel.grpCd'/>",              style : "my-column", editable : false, width : 110 },
        {dataField : "lastOrgCode",                  headerText : "<spring:message code='commissiom.text.excel.orgCd'/>",              style : "my-column", editable : false, width : 110 },
	    
	    {headerText : "<spring:message code='commissiom.text.excel.happyCallRate'/>",  children: [{dataField: "aHappycallRate", headerText: "A", editable : false}, {dataField: "sHappycallRate", headerText: "S", editable : false}]},
        {headerText : "<spring:message code='commissiom.text.excel.happyCallMarks'/>",   children: [{dataField: "aHappycallMark", headerText: "A", editable : false}, {dataField: "sHappycallMark", headerText: "S", editable : false}]},
        {headerText : "<spring:message code='commissiom.text.excel.hsRate'/>",            children: [{dataField: "aBsRate", headerText: "A", editable : false}, {dataField: "sBsRate", headerText: "S", editable : false}]},
        {headerText : "<spring:message code='commissiom.text.excel.hsMark'/>",            children: [{dataField: "aBsMark", headerText: "A", editable : false}, {dataField: "sBsMark", headerText: "S", editable : false}]},
        {headerText : "<spring:message code='commissiom.text.excel.rcRate'/>",            children: [{dataField: "aRcRate", headerText: "A", editable : false}, {dataField: "sRcRate", headerText: "S", editable : false}]},
        
        {headerText : "<spring:message code='commissiom.text.excel.rcMark'/>",            children: [{dataField: "aRcMark", headerText: "A", editable : false}, {dataField: "sRcMark", headerText: "S", editable : false}]},
        {headerText : "<spring:message code='commissiom.text.excel.rejoinMark'/>",        children: [{dataField: "aRejoinMark", headerText: "A", editable : false}, {dataField: "sRejoinMark", headerText: "S", editable : false}]},
        {headerText : "<spring:message code='commissiom.text.excel.rejoinRate'/>",        children: [{dataField: "aRejoinRate", headerText: "A", editable : false}, {dataField: "sRejoinRate", headerText: "S", editable : false}]},
        {headerText : "<spring:message code='commissiom.text.excel.grpSalesProductivity'/>",          children: [{dataField: "aGroupSalesProduct", headerText: "A", editable : false}, {dataField: "sGroupSalesProduct", headerText: "S", editable : false}]},
        {headerText : "<spring:message code='commissiom.text.excel.grpSalesProducMark'/>",   children: [{dataField: "aGroupSalesProductMark", headerText: "A", editable : false}, {dataField: "sGroupSalesProductMark", headerText: "S", editable : false}]},
        
        {headerText : "<spring:message code='commissiom.text.excel.bsProductivityRate'/>",          children: [{dataField: "aBsProductivityRate", headerText: "A", editable : false}, {dataField: "sBsProductivityRate", headerText: "S", editable : false}]},
        {headerText : "<spring:message code='commissiom.text.excel.bsProductivityMark'/>",          children: [{dataField: "aBsProductivityMark", headerText: "A", editable : false}, {dataField: "sBsProductivityMark", headerText: "S", editable : false}]},
        {headerText : "<spring:message code='commissiom.text.excel.dropRate'/>",                        children: [{dataField: "aDropRate", headerText: "A", editable : false}, {dataField: "sDropRate", headerText: "S", editable : false}]},
        {headerText : "<spring:message code='commissiom.text.excel.dropMark'/>",                        children: [{dataField: "aDropMark", headerText: "A", editable : false}, {dataField: "sDropMark", headerText: "S", editable : false}]},
        {headerText : "<spring:message code='commissiom.text.excel.peMark'/>",                 children: [{dataField: "aPeMark", headerText: "A", editable : false}, {dataField: "sPeMark", headerText: "S", editable : false}]},
        
        {headerText : "<spring:message code='commissiom.text.excel.basicSalary'/>",                children: [{dataField: "aBasicSalary", headerText: "A", editable : false}, {dataField: "sBasicSalary", headerText: "S", editable : false}]},
        {headerText : "<spring:message code='commissiom.text.excel.salesAmt'/>",             children: [{dataField: "aSalesAmt", headerText: "A", editable : false}, {dataField: "sSalesAmt", headerText: "S", editable : false}]},
        {headerText : "<spring:message code='commissiom.text.excel.outplaAmt'/>",   children: [{dataField: "aOutplsAmt", headerText: "A", editable : false}, {dataField: "sOutplsAmt", headerText: "S", editable : false}]},
        {headerText : "<spring:message code='commissiom.text.excel.bonusAmt'/>",            children: [{dataField: "aBonusAmt", headerText: "A", editable : false}, {dataField: "sBonusAmt", headerText: "S", editable : false}]},
        {headerText : "<spring:message code='commissiom.text.excel.collectAmt'/>",           children: [{dataField: "aCollectAmt", headerText: "A", editable : false}, {dataField: "sCollectAmt", headerText: "S", editable : false}]},
        {headerText : "<spring:message code='commissiom.text.excel.membershipAmt'/>",     children: [{dataField: "aMembershipAmt", headerText: "A", editable : false}, {dataField: "sMembershipAmt", headerText: "S", editable : false}]}, 
        
        {headerText : "<spring:message code='commissiom.text.excel.hpAmt'/>",                 children: [{dataField: "aHpAmt", headerText: "A", editable : false}, {dataField: "sHpAmt", headerText: "S", editable : false}]},
        {headerText : "<spring:message code='commissiom.text.excel.transportAmt'/>", children: [{dataField: "aTransportAmt", headerText: "A", editable : false}, {dataField: "sTransportAmt", headerText: "S", editable : false}]},
        {headerText : "<spring:message code='commissiom.text.excel.monthlyAllowance'/>",  children: [{dataField: "aMonthlyAllowance", headerText: "A", editable : false}, {dataField: "sMonthlyAllowance", headerText: "S", editable : false}]},
        {headerText : "<spring:message code='commissiom.text.excel.mobilePhone'/>",        children: [{dataField: "aMobilePhone", headerText: "A", editable : false}, {dataField: "sMobilePhone", headerText: "S", editable : false}]},
        {headerText : "<spring:message code='commissiom.text.excel.introducFees'/>",   children: [{dataField: "aIntroductionFees", headerText: "A", editable : false}, {dataField: "sIntroductionFees", headerText: "S", editable : false}]}, 
        
        {headerText : "<spring:message code='commissiom.text.excel.staffPurchase'/>",      children: [{dataField: "aStaffPurchase", headerText: "A", editable : false}, {dataField: "sStaffPurchase", headerText: "S", editable : false}]}, 
        {headerText : "<spring:message code='commissiom.text.excel.telephoneDeduct'/>",  children: [{dataField: "aTelephoneDeduct", headerText: "A", editable : false}, {dataField: "sTelephoneDeduct", headerText: "S", editable : false}]},
        {headerText : "<spring:message code='commissiom.text.excel.incentive'/>",             children: [{dataField: "aIncentive", headerText: "A", editable : false}, {dataField: "sIncentive", headerText: "S", editable : false}]},
        {headerText : "<spring:message code='commissiom.text.excel.adj'/>",                     children: [{dataField: "aAdj", headerText: "A", editable : false}, {dataField: "sAdj", headerText: "S", editable : false}]}, 
        {headerText : "<spring:message code='commissiom.text.excel.shiAmt'/>",                    children: [{dataField: "aShiAmt", headerText: "A", editable : false}, {dataField: "sShiAmt", headerText: "S", editable : false}]},
        
        {headerText : "<spring:message code='commissiom.text.excel.rentalmembershipAmt'/>",       children: [{dataField: "aRentalmembershipAmt", headerText: "A", editable : false}, {dataField: "sRentalmembershipAmt", headerText: "S", editable : false}]},
        {headerText : "<spring:message code='commission.text.grid.posDeduction'/>",                     children: [{dataField: "aPosDeduction", headerText: "A", editable : false}, {dataField: "sPosDeduction", headerText: "S", editable : false}]},
        {headerText : "<spring:message code='commissiom.text.excel.grandTot'/>",                     children: [{dataField: "aAmount", headerText: "A", editable : false}, {dataField: "sAmount", headerText: "S", editable : false}]}
	];
	
	var columnGCMCompareLayout = [
	    {dataField : "memCode",           headerText : "<spring:message code='commissiom.text.excel.memCode'/>",            style : "my-column", editable : false, width : 80},
	    {dataField : "memName",          headerText : "<spring:message code='commissiom.text.excel.memNm'/>",            style : "my-column", editable : false, width : 260 },
	    {dataField : "rank",                  headerText : "<spring:message code='commissiom.text.excel.rank'/>",                    style : "my-column", editable : false },
	    {dataField : "nric",                   headerText : "<spring:message code='commissiom.text.excel.nric'/>",             style : "my-column", editable : false, width : 110 },
	    {dataField : "stus",                  headerText : "<spring:message code='commissiom.text.excel.emplyStusCd'/>",              style : "my-column", editable : false, width : 110 },
	    
	    {dataField : "lastDeptCode",                  headerText : "<spring:message code='commissiom.text.excel.deptCd'/>",              style : "my-column", editable : false, width : 110 },
        {dataField : "lastGrpCode",                  headerText : "<spring:message code='commissiom.text.excel.grpCd'/>",              style : "my-column", editable : false, width : 110 },
        {dataField : "lastOrgCode",                  headerText : "<spring:message code='commissiom.text.excel.orgCd'/>",              style : "my-column", editable : false, width : 110 },
	    
	    {headerText : "<spring:message code='commissiom.text.excel.happyCallRate'/>",  children: [{dataField: "aHappycallRate", headerText: "A", editable : false}, {dataField: "sHappycallRate", headerText: "S", editable : false}]},
        {headerText : "<spring:message code='commissiom.text.excel.happyCallMarks'/>",   children: [{dataField: "aHappycallMark", headerText: "A", editable : false}, {dataField: "sHappycallMark", headerText: "S", editable : false}]},
        {headerText : "<spring:message code='commissiom.text.excel.hsRate'/>",            children: [{dataField: "aBsRate", headerText: "A", editable : false}, {dataField: "sBsRate", headerText: "S", editable : false}]},
        {headerText : "<spring:message code='commissiom.text.excel.hsMark'/>",            children: [{dataField: "aBsMark", headerText: "A", editable : false}, {dataField: "sBsMark", headerText: "S", editable : false}]},
        {headerText : "<spring:message code='commissiom.text.excel.rcRate'/>",            children: [{dataField: "aRcRate", headerText: "A", editable : false}, {dataField: "sRcRate", headerText: "S", editable : false}]},
        
        {headerText : "<spring:message code='commissiom.text.excel.rcMark'/>",            children: [{dataField: "aRcMark", headerText: "A", editable : false}, {dataField: "sRcMark", headerText: "S", editable : false}]},
        {headerText : "<spring:message code='commissiom.text.excel.rejoinMark'/>",        children: [{dataField: "aRejoinMark", headerText: "A", editable : false}, {dataField: "sRejoinMark", headerText: "S", editable : false}]},
        {headerText : "<spring:message code='commissiom.text.excel.rejoinRate'/>",        children: [{dataField: "aRejoinRate", headerText: "A", editable : false}, {dataField: "sRejoinRate", headerText: "S", editable : false}]},
        {headerText : "<spring:message code='commissiom.text.excel.grpSalesProductivity'/>",          children: [{dataField: "aGroupSalesProduct", headerText: "A", editable : false}, {dataField: "sGroupSalesProduct", headerText: "S", editable : false}]},
        {headerText : "<spring:message code='commissiom.text.excel.grpSalesProducMark'/>",   children: [{dataField: "aGroupSalesProductMark", headerText: "A", editable : false}, {dataField: "sGroupSalesProductMark", headerText: "S", editable : false}]},
        {headerText : "<spring:message code='commissiom.text.excel.bsProductivityRate'/>",          children: [{dataField: "aBsProductivityRate", headerText: "A", editable : false}, {dataField: "sBsProductivityRate", headerText: "S", editable : false}]},
        {headerText : "<spring:message code='commissiom.text.excel.bsProductivityMark'/>",          children: [{dataField: "aBsProductivityMark", headerText: "A", editable : false}, {dataField: "sBsProductivityMark", headerText: "S", editable : false}]},
        
        {headerText : "<spring:message code='commissiom.text.excel.dropRate'/>",                        children: [{dataField: "aDropRate", headerText: "A", editable : false}, {dataField: "sDropRate", headerText: "S", editable : false}]},
        {headerText : "<spring:message code='commissiom.text.excel.dropMark'/>",                        children: [{dataField: "aDropMark", headerText: "A", editable : false}, {dataField: "sDropMark", headerText: "S", editable : false}]},
        {headerText : "<spring:message code='commissiom.text.excel.peMark'/>",                 children: [{dataField: "aPeMark", headerText: "A", editable : false}, {dataField: "sPeMark", headerText: "S", editable : false}]},
        
        {headerText : "<spring:message code='commissiom.text.excel.basicSalary'/>",                children: [{dataField: "aBasicSalary", headerText: "A", editable : false}, {dataField: "sBasicSalary", headerText: "S", editable : false}]},
        {headerText : "<spring:message code='commissiom.text.excel.salesAmt'/>",             children: [{dataField: "aSalesAmt", headerText: "A", editable : false}, {dataField: "sSalesAmt", headerText: "S", editable : false}]},
        {headerText : "<spring:message code='commissiom.text.excel.outplaAmt'/>",   children: [{dataField: "aOutplsAmt", headerText: "A", editable : false}, {dataField: "sOutplsAmt", headerText: "S", editable : false}]},
        {headerText : "<spring:message code='commissiom.text.excel.bonusAmt'/>",            children: [{dataField: "aBonusAmt", headerText: "A", editable : false}, {dataField: "sBonusAmt", headerText: "S", editable : false}]},
        {headerText : "<spring:message code='commissiom.text.excel.collectAmt'/>",           children: [{dataField: "aCollectAmt", headerText: "A", editable : false}, {dataField: "sCollectAmt", headerText: "S", editable : false}]},
        {headerText : "<spring:message code='commissiom.text.excel.membershipAmt'/>",     children: [{dataField: "aMembershipAmt", headerText: "A", editable : false}, {dataField: "sMembershipAmt", headerText: "S", editable : false}]}, 
        
        {headerText : "<spring:message code='commissiom.text.excel.hpAmt'/>",                 children: [{dataField: "aHpAmt", headerText: "A", editable : false}, {dataField: "sHpAmt", headerText: "S", editable : false}]},
        {headerText : "<spring:message code='commissiom.text.excel.transportAmt'/>", children: [{dataField: "aTransportAmt", headerText: "A", editable : false}, {dataField: "sTransportAmt", headerText: "S", editable : false}]},
        {headerText : "<spring:message code='commissiom.text.excel.monthlyAllowance'/>",  children: [{dataField: "aMonthlyAllowance", headerText: "A", editable : false}, {dataField: "sMonthlyAllowance", headerText: "S", editable : false}]},
        {headerText : "<spring:message code='commissiom.text.excel.mobilePhone'/>",        children: [{dataField: "aMobilePhone", headerText: "A", editable : false}, {dataField: "sMobilePhone", headerText: "S", editable : false}]},
        {headerText : "<spring:message code='commissiom.text.excel.introducFees'/>",   children: [{dataField: "aIntroductionFees", headerText: "A", editable : false}, {dataField: "sIntroductionFees", headerText: "S", editable : false}]}, 
        
        {headerText : "<spring:message code='commissiom.text.excel.staffPurchase'/>",      children: [{dataField: "aStaffPurchase", headerText: "A", editable : false}, {dataField: "sStaffPurchase", headerText: "S", editable : false}]}, 
        {headerText : "<spring:message code='commissiom.text.excel.telephoneDeduct'/>",  children: [{dataField: "aTelephoneDeduct", headerText: "A", editable : false}, {dataField: "sTelephoneDeduct", headerText: "S", editable : false}]},
        {headerText : "<spring:message code='commissiom.text.excel.incentive'/>",             children: [{dataField: "aIncentive", headerText: "A", editable : false}, {dataField: "sIncentive", headerText: "S", editable : false}]},
        {headerText : "<spring:message code='commissiom.text.excel.adj'/>",                     children: [{dataField: "aAdj", headerText: "A", editable : false}, {dataField: "sAdj", headerText: "S", editable : false}]}, 
        {headerText : "<spring:message code='commissiom.text.excel.shiAmt'/>",                    children: [{dataField: "aShiAmt", headerText: "A", editable : false}, {dataField: "sShiAmt", headerText: "S", editable : false}]},
        
        {headerText : "<spring:message code='commissiom.text.excel.rentalmembershipAmt'/>",       children: [{dataField: "aRentalmembershipAmt", headerText: "A", editable : false}, {dataField: "sRentalmembershipAmt", headerText: "S", editable : false}]},
        {headerText : "<spring:message code='commission.text.grid.posDeduction'/>",                     children: [{dataField: "aPosDeduction", headerText: "A", editable : false}, {dataField: "sPosDeduction", headerText: "S", editable : false}]},
        {headerText : "<spring:message code='commissiom.text.excel.grandTot'/>",                     children: [{dataField: "aAmount", headerText: "A", editable : false}, {dataField: "sAmount", headerText: "S", editable : false}]}
	];
	

		
	
</script>

<section id="content"><!-- content start -->
	<ul class="path">
        <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
        <li><spring:message code='commission.text.head.commission'/></li>
                <li><spring:message code='commission.text.head.report'/></li>
        <li><spring:message code='commission.text.head.cdReport'/></li>
        <li><spring:message code='commission.text.head.cdCommissionResult'/></li>
    </ul>
	
	<aside class="title_line"><!-- title_line start -->
		<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
		<h2><spring:message code='commission.title.resultCD'/></h2>
		<ul class="right_btns">
			<c:if test="${PAGE_AUTH.funcView == 'Y'}"><li><p class="btn_blue"><a href="#" id="search"><spring:message code='sys.btn.search'/></a></p></li></c:if>
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
                            <c:if test="${PAGE_AUTH.funcView == 'Y'}"><label><input type="radio" name="actionType" id="actionTypeA" value="A"checked/><span><spring:message code='commission.text.search.actual'/></span></label></c:if>
	                        <c:if test="${PAGE_AUTH.funcView == 'Y'}"><label><input type="radio" name="actionType" id="actionTypeS" value="S"/><span><spring:message code='commission.text.search.simulation'/></span></label></c:if>
	                        <c:if test="${PAGE_AUTH.funcView == 'Y'}"><label><input type="radio" name="actionType" id="actionTypeC" value="C"/><span><spring:message code='commission.text.search.compare'/></span></label></c:if>
                        </td>
					</tr>
				</tbody>
			</table><!-- table end -->
		</form>
	</section><!-- search_table end -->
	
	<section class="search_result"><!-- search_result start -->
	
		<ul class="right_btns">
			<c:if test="${PAGE_AUTH.funcPrint == 'Y'}"><li><p class="btn_grid"><a href="javascript:fn_excelDown();"><spring:message code='commission.button.generate'/></a></p></li></c:if>
		</ul>
	
		<article class="grid_wrap"><!-- grid_wrap start -->
		    <div id="grid_wrap" style="width: 100%; height: 334px; margin: 0 auto;"></div>
			
		</article><!-- grid_wrap end -->
	
	</section><!-- search_result end -->

</section><!-- content end -->

		
<hr />

</body>
</html>