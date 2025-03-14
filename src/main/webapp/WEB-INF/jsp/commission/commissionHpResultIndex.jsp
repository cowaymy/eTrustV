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
        
        $("#orgGrCombo option:eq(2)").attr("selected", "selected");
        
        //creat grid
        createGrid("HPP");
        
        $('#memBtn').click(function() {
            //Common.searchpopupWin("searchForm", "/common/memberPop.do","");
            Common.popupDiv("/common/memberPop.do", $("#myForm").serializeJSON(), null, true);
        });
        
        
        $('#search').click(function(){
        	//if($("#memCode").val() != null && $("#memCode").val() != ""){
	        	Common.ajax("GET", "/commission/report/selectHPRawData", $("#myForm").serializeJSON() , function(result) {
	        		
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
            createGrid("HPP");
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
        if(lvl == "HPP"){
            if(type == "A"){
                gridID = AUIGrid.create("#grid_wrap", columnHPPActualLayout,gridPros);
            }else if(type == "S"){
                gridID = AUIGrid.create("#grid_wrap", columnHPPSimulLayout,gridPros);
            }else if(type == "C"){
                gridID = AUIGrid.create("#grid_wrap", columnHPPCompareLayout,gridPros);
            }
        }else if(lvl == "HPF"){
            if(type == "A"){
             gridID = AUIGrid.create("#grid_wrap", columnHPFActualLayout,gridPros);
            }else if(type == "S"){
                gridID = AUIGrid.create("#grid_wrap", columnHPFSimulLayout,gridPros);
            }else if(type == "C"){
                gridID = AUIGrid.create("#grid_wrap", columnHPFCompareLayout,gridPros);
            }
        }else if(lvl == "HPM"){
            if(type == "A"){
                gridID = AUIGrid.create("#grid_wrap", columnHMActualLayout,gridPros);
            }else if(type == "S"){
                gridID = AUIGrid.create("#grid_wrap", columnHMSimulLayout,gridPros);
            }else if(type == "C"){
                gridID = AUIGrid.create("#grid_wrap", columnHMCompareLayout,gridPros);
            }
        }else if(lvl == "HPS"){
            if(type == "A"){
                gridID = AUIGrid.create("#grid_wrap", columnSMActualLayout,gridPros);
            }else if(type == "S"){
                gridID = AUIGrid.create("#grid_wrap", columnSMSimulLayout,gridPros);
            }else if(type == "C"){
                gridID = AUIGrid.create("#grid_wrap", columnSMCompareLayout,gridPros);
            }
        }else if(lvl == "HPG"){
            if(type == "A"){
                gridID = AUIGrid.create("#grid_wrap", columnGMActualLayout,gridPros);
            }else if(type == "S"){
                gridID = AUIGrid.create("#grid_wrap", columnGMSimulLayout,gridPros);
            }else if(type == "C"){
                gridID = AUIGrid.create("#grid_wrap", columnGMCompareLayout,gridPros);
            }
        }else if(lvl == "HPT"){
            if(type == "A"){
                gridID = AUIGrid.create("#grid_wrap", columnSGMActualLayout,gridPros);
            }else if(type == "S"){
                gridID = AUIGrid.create("#grid_wrap", columnSGMSimulLayout,gridPros);
            }else if(type == "C"){
                gridID = AUIGrid.create("#grid_wrap", columnSGMCompareLayout,gridPros);
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
            fileNm = "HPresultIndex_Actual_"+today;
        }else if(type == "S"){
            fileNm = "HPresultIndex_Simul_"+today;
        }else if(type == "C"){
            fileNm = "HPresultIndex_Actual_N_Simul_"+today;
        }
        fileNm=fileNm+".xlsx"
        /* grad download 
        if(Number(grdLength) > 0){
            GridCommon.exportTo("grid_wrap", "xlsx", fileNm);
        }else{
            Common.alert("No Data");
        } */
        
        var codeNm = "result_HP";
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
    var columnHPPActualLayout = [
	    {dataField : "mCode",             headerText : "<spring:message code='commissiom.text.excel.memCode'/>",          style : "my-column", editable : false, width : 80 },
	    {dataField : "memberName",     headerText : "<spring:message code='commissiom.text.excel.memNm'/>",         style : "my-column", editable : false, width : 260 },
	    {dataField : "rank",                headerText : "<spring:message code='commissiom.text.excel.rank'/>",                 style : "my-column", editable : false },
	    {dataField : "nric",                 headerText : "<spring:message code='commissiom.text.excel.nric'/>",                   style : "my-column", editable : false, width : 110 },
	    
	    {dataField : "aPi",                    headerText : "<spring:message code='commission.text.grid.piAmt'/>",               style : "my-column", editable : false },
	    {dataField : "aPa",                   headerText : "<spring:message code='commission.text.grid.paAmt'/>",              style : "my-column", editable : false },
	    {dataField : "aSgmAmt",            headerText : "<spring:message code='commissiom.text.excel.sgmAmt'/>",           style : "my-column", editable : false },
	    {dataField : "aMgrAmt",             headerText : "<spring:message code='commissiom.text.excel.mgrAmt'/>",           style : "my-column", editable : false }, 
	    {dataField : "aOutinsAmt",         headerText : "<spring:message code='commissiom.text.excel.outinsAmt'/>",        style : "my-column", editable : false},
	    {dataField : "aBonus",               headerText : "<spring:message code='commissiom.text.excel.bonus'/>",               style : "my-column", editable : false},
	    {dataField : "aRenmgrAmt",        headerText : "<spring:message code='commissiom.text.excel.renmgrAmt'/>",       style : "my-column", editable : false}, 
	    {dataField : "aRentalAmt",          headerText : "<spring:message code='commissiom.text.excel.mentalAmt'/>",        style : "my-column", editable : false},
	    {dataField : "aOutplsAmt",          headerText : "<spring:message code='commissiom.text.excel.outplaAmt'/>",       style : "my-column", editable : false},
	    {dataField : "aMembershipAmt",   headerText : "<spring:message code='commissiom.text.excel.membershipAmt'/>", style : "my-column", editable : false},
	    {dataField : "aTbbAmt",             headerText : "<spring:message code='commissiom.text.excel.tbbAmt'/>",           style : "my-column", editable : false},
	    {dataField : "aAdjustAmt",          headerText : "<spring:message code='commissiom.text.excel.adj'/>",             style : "my-column", editable : false},
	    {dataField : "aIncentive",           headerText : "<spring:message code='commissiom.text.excel.incentive'/>",          style : "my-column", editable : false},
	    {dataField : "aShiAmt",              headerText : "<spring:message code='commissiom.text.excel.shiAmt'/>",            style : "my-column", editable : false},
	    {dataField : "aRentalmembershipAmt",     headerText : "<spring:message code='commissiom.text.excel.rentalmembershipAmt'/>",       style : "my-column", editable : false},
	    {dataField : "aRentalmembershipShiAmt", headerText : "<spring:message code='commission.text.grid.shiRentalMemAmt'/>",   style : "my-column", editable : false},
	    {dataField : "aAmount",              headerText : "<spring:message code='commissiom.text.excel.grandTot'/>",            style : "my-column", editable : false}
	    /* {dataField : "aWsAward",              headerText : "WS AWARD",            style : "my-column", editable : false} */
	];
	
    var columnHPFActualLayout = [
	    {dataField : "mCode",             headerText : "<spring:message code='commissiom.text.excel.memCode'/>",          style : "my-column", editable : false, width : 80 },
	    {dataField : "memberName",     headerText : "<spring:message code='commissiom.text.excel.memNm'/>",         style : "my-column", editable : false, width : 260 },
	    {dataField : "rank",                headerText : "<spring:message code='commissiom.text.excel.rank'/>",                 style : "my-column", editable : false },
	    {dataField : "nric",                 headerText : "<spring:message code='commissiom.text.excel.nric'/>",                   style : "my-column", editable : false, width : 110 },
	    
	    {dataField : "aPi",                    headerText : "<spring:message code='commission.text.grid.piAmt'/>",               style : "my-column", editable : false },
	    {dataField : "aPa",                   headerText : "<spring:message code='commission.text.grid.paAmt'/>",              style : "my-column", editable : false },
	    {dataField : "aSgmAmt",            headerText : "<spring:message code='commissiom.text.excel.sgmAmt'/>",           style : "my-column", editable : false },
	    {dataField : "aMgrAmt",             headerText : "<spring:message code='commissiom.text.excel.mgrAmt'/>",           style : "my-column", editable : false },
	    {dataField : "aOutinsAmt",         headerText : "<spring:message code='commissiom.text.excel.outinsAmt'/>",        style : "my-column", editable : false},
	    {dataField : "aBonus",               headerText : "<spring:message code='commissiom.text.excel.bonus'/>",               style : "my-column", editable : false},
	    {dataField : "aRenmgrAmt",        headerText : "<spring:message code='commissiom.text.excel.renmgrAmt'/>",       style : "my-column", editable : false}, 
	    {dataField : "aRentalAmt",          headerText : "<spring:message code='commissiom.text.excel.mentalAmt'/>",        style : "my-column", editable : false},
	    {dataField : "aOutplsAmt",          headerText : "<spring:message code='commissiom.text.excel.outplaAmt'/>",       style : "my-column", editable : false},
	    {dataField : "aMembershipAmt",   headerText : "<spring:message code='commissiom.text.excel.membershipAmt'/>", style : "my-column", editable : false}, 
	    {dataField : "aTbbAmt",             headerText : "<spring:message code='commissiom.text.excel.tbbAmt'/>",           style : "my-column", editable : false},
	    {dataField : "aAdjustAmt",          headerText : "<spring:message code='commissiom.text.excel.adj'/>",             style : "my-column", editable : false},
	    {dataField : "aIncentive",           headerText : "<spring:message code='commissiom.text.excel.incentive'/>",          style : "my-column", editable : false},
	    {dataField : "aShiAmt",              headerText : "<spring:message code='commissiom.text.excel.shiAmt'/>",            style : "my-column", editable : false},
	    {dataField : "aRentalmembershipAmt",     headerText : "<spring:message code='commissiom.text.excel.rentalmembershipAmt'/>",       style : "my-column", editable : false},
	    {dataField : "aRentalmembershipShiAmt", headerText : "<spring:message code='commission.text.grid.shiRentalMemAmt'/>",   style : "my-column", editable : false},
	    {dataField : "aAmount",              headerText : "<spring:message code='commissiom.text.excel.grandTot'/>",            style : "my-column", editable : false}
	    /* {dataField : "aWsAward",              headerText : "WS AWARD",            style : "my-column", editable : false} */
	];
	
    var columnHMActualLayout = [
	    {dataField : "mCode",             headerText : "<spring:message code='commissiom.text.excel.memCode'/>",          style : "my-column", editable : false, width : 80 },
	    {dataField : "memberName",     headerText : "<spring:message code='commissiom.text.excel.memNm'/>",         style : "my-column", editable : false, width : 260 },
	    {dataField : "rank",                headerText : "<spring:message code='commissiom.text.excel.rank'/>",                 style : "my-column", editable : false },
	    {dataField : "nric",                 headerText : "<spring:message code='commissiom.text.excel.nric'/>",                   style : "my-column", editable : false, width : 110 },
	    
	    {dataField : "aPi",                    headerText : "<spring:message code='commission.text.grid.piAmt'/>",               style : "my-column", editable : false },
	    {dataField : "aPa",                   headerText : "<spring:message code='commission.text.grid.paAmt'/>",              style : "my-column", editable : false },
	    {dataField : "aSgmAmt",            headerText : "<spring:message code='commissiom.text.excel.sgmAmt'/>",           style : "my-column", editable : false }, 
	    {dataField : "aMgrAmt",             headerText : "<spring:message code='commissiom.text.excel.mgrAmt'/>",           style : "my-column", editable : false },
	    {dataField : "aOutinsAmt",         headerText : "<spring:message code='commissiom.text.excel.outinsAmt'/>",        style : "my-column", editable : false},
	    {dataField : "aBonus",               headerText : "<spring:message code='commissiom.text.excel.bonus'/>",               style : "my-column", editable : false}, 
	    {dataField : "aRenmgrAmt",        headerText : "<spring:message code='commissiom.text.excel.renmgrAmt'/>",       style : "my-column", editable : false},
	    {dataField : "aRentalAmt",          headerText : "<spring:message code='commissiom.text.excel.mentalAmt'/>",        style : "my-column", editable : false},
	    {dataField : "aOutplsAmt",          headerText : "<spring:message code='commissiom.text.excel.outplaAmt'/>",       style : "my-column", editable : false},
	    {dataField : "aMembershipAmt",   headerText : "<spring:message code='commissiom.text.excel.membershipAmt'/>", style : "my-column", editable : false},
	    {dataField : "aTbbAmt",             headerText : "<spring:message code='commissiom.text.excel.tbbAmt'/>",           style : "my-column", editable : false},
	    {dataField : "aAdjustAmt",          headerText : "<spring:message code='commissiom.text.excel.adj'/>",             style : "my-column", editable : false},
	    {dataField : "aIncentive",           headerText : "<spring:message code='commissiom.text.excel.incentive'/>",          style : "my-column", editable : false},
	    {dataField : "aShiAmt",              headerText : "<spring:message code='commissiom.text.excel.shiAmt'/>",            style : "my-column", editable : false},
	    {dataField : "aRentalmembershipAmt",     headerText : "<spring:message code='commissiom.text.excel.rentalmembershipAmt'/>",       style : "my-column", editable : false},
	    {dataField : "aRentalmembershipShiAmt", headerText : "<spring:message code='commission.text.grid.shiRentalMemAmt'/>",   style : "my-column", editable : false},
	    {dataField : "aAmount",              headerText : "<spring:message code='commissiom.text.excel.grandTot'/>",            style : "my-column", editable : false}
	    /* {dataField : "aWsAward",              headerText : "WS AWARD",            style : "my-column", editable : false} */
	];
    
    var columnSMActualLayout = [
	    {dataField : "mCode",             headerText : "<spring:message code='commissiom.text.excel.memCode'/>",          style : "my-column", editable : false, width : 80 },
	    {dataField : "memberName",     headerText : "<spring:message code='commissiom.text.excel.memNm'/>",         style : "my-column", editable : false, width : 260 },
	    {dataField : "rank",                headerText : "<spring:message code='commissiom.text.excel.rank'/>",                 style : "my-column", editable : false },
	    {dataField : "nric",                 headerText : "<spring:message code='commissiom.text.excel.nric'/>",                   style : "my-column", editable : false, width : 110 },
	    
	    {dataField : "aPi",                    headerText : "<spring:message code='commission.text.grid.piAmt'/>",               style : "my-column", editable : false },
	    {dataField : "aPa",                   headerText : "<spring:message code='commission.text.grid.paAmt'/>",              style : "my-column", editable : false },
	    {dataField : "aSgmAmt",            headerText : "<spring:message code='commissiom.text.excel.sgmAmt'/>",           style : "my-column", editable : false }, 
	    {dataField : "aMgrAmt",             headerText : "<spring:message code='commissiom.text.excel.mgrAmt'/>",           style : "my-column", editable : false },
	    {dataField : "aOutinsAmt",         headerText : "<spring:message code='commissiom.text.excel.outinsAmt'/>",        style : "my-column", editable : false},
	    {dataField : "aBonus",               headerText : "<spring:message code='commissiom.text.excel.bonus'/>",               style : "my-column", editable : false}, 
	    {dataField : "aRenmgrAmt",        headerText : "<spring:message code='commissiom.text.excel.renmgrAmt'/>",       style : "my-column", editable : false},
	    {dataField : "aRentalAmt",          headerText : "<spring:message code='commissiom.text.excel.mentalAmt'/>",        style : "my-column", editable : false}, 
	    {dataField : "aOutplsAmt",          headerText : "<spring:message code='commissiom.text.excel.outplaAmt'/>",       style : "my-column", editable : false},
	    {dataField : "aMembershipAmt",   headerText : "<spring:message code='commissiom.text.excel.membershipAmt'/>", style : "my-column", editable : false},
	    {dataField : "aTbbAmt",             headerText : "<spring:message code='commissiom.text.excel.tbbAmt'/>",           style : "my-column", editable : false},
	    {dataField : "aAdjustAmt",          headerText : "<spring:message code='commissiom.text.excel.adj'/>",             style : "my-column", editable : false}, 
	    {dataField : "aIncentive",           headerText : "<spring:message code='commissiom.text.excel.incentive'/>",          style : "my-column", editable : false},
	    {dataField : "aShiAmt",              headerText : "<spring:message code='commissiom.text.excel.shiAmt'/>",            style : "my-column", editable : false},
	    {dataField : "aRentalmembershipAmt",     headerText : "<spring:message code='commissiom.text.excel.rentalmembershipAmt'/>",       style : "my-column", editable : false},
	    {dataField : "aRentalmembershipShiAmt", headerText : "<spring:message code='commission.text.grid.shiRentalMemAmt'/>",   style : "my-column", editable : false},
	    {dataField : "aMeetingAllowances", headerText : "<spring:message code='commission.text.grid.meetingAllowances'/>",   style : "my-column", editable : false},
	    {dataField : "aAmount",              headerText : "<spring:message code='commissiom.text.excel.grandTot'/>",            style : "my-column", editable : false}
	    /* {dataField : "aWsAward",              headerText : "WS AWARD",            style : "my-column", editable : false} */
	];
    
    var columnGMActualLayout = [
	    {dataField : "mCode",             headerText : "<spring:message code='commissiom.text.excel.memCode'/>",          style : "my-column", editable : false, width : 80 },
	    {dataField : "memberName",     headerText : "<spring:message code='commissiom.text.excel.memNm'/>",         style : "my-column", editable : false, width : 260 },
	    {dataField : "rank",                headerText : "<spring:message code='commissiom.text.excel.rank'/>",                 style : "my-column", editable : false },
	    {dataField : "nric",                 headerText : "<spring:message code='commissiom.text.excel.nric'/>",                   style : "my-column", editable : false, width : 110 },
	    
	    {dataField : "aPi",                    headerText : "<spring:message code='commission.text.grid.piAmt'/>",               style : "my-column", editable : false },
	    {dataField : "aPa",                   headerText : "<spring:message code='commission.text.grid.paAmt'/>",              style : "my-column", editable : false },
	    {dataField : "aSgmAmt",            headerText : "<spring:message code='commissiom.text.excel.sgmAmt'/>",           style : "my-column", editable : false }, 
	    {dataField : "aMgrAmt",             headerText : "<spring:message code='commissiom.text.excel.mgrAmt'/>",           style : "my-column", editable : false },
	    {dataField : "aOutinsAmt",         headerText : "<spring:message code='commissiom.text.excel.outinsAmt'/>",        style : "my-column", editable : false},
	    {dataField : "aBonus",               headerText : "<spring:message code='commissiom.text.excel.bonus'/>",               style : "my-column", editable : false},
	    {dataField : "aRenmgrAmt",        headerText : "<spring:message code='commissiom.text.excel.renmgrAmt'/>",       style : "my-column", editable : false},
	    {dataField : "aRentalAmt",          headerText : "<spring:message code='commissiom.text.excel.mentalAmt'/>",        style : "my-column", editable : false},
	    {dataField : "aOutplsAmt",          headerText : "<spring:message code='commissiom.text.excel.outplaAmt'/>",       style : "my-column", editable : false},
	    {dataField : "aMembershipAmt",   headerText : "<spring:message code='commissiom.text.excel.membershipAmt'/>", style : "my-column", editable : false}, 
	    {dataField : "aTbbAmt",             headerText : "<spring:message code='commissiom.text.excel.tbbAmt'/>",           style : "my-column", editable : false},
	    {dataField : "aAdjustAmt",          headerText : "<spring:message code='commissiom.text.excel.adj'/>",             style : "my-column", editable : false}, 
	    {dataField : "aIncentive",           headerText : "<spring:message code='commissiom.text.excel.incentive'/>",          style : "my-column", editable : false},
	    {dataField : "aShiAmt",              headerText : "<spring:message code='commissiom.text.excel.shiAmt'/>",            style : "my-column", editable : false},
	    {dataField : "aRentalmembershipAmt",     headerText : "<spring:message code='commissiom.text.excel.rentalmembershipAmt'/>",       style : "my-column", editable : false},
	    {dataField : "aRentalmembershipShiAmt", headerText : "<spring:message code='commission.text.grid.shiRentalMemAmt'/>",   style : "my-column", editable : false},
	    {dataField : "aMeetingAllowances", headerText : "<spring:message code='commission.text.grid.meetingAllowances'/>",   style : "my-column", editable : false},
	    {dataField : "aAmount",              headerText : "<spring:message code='commissiom.text.excel.grandTot'/>",            style : "my-column", editable : false}
	    /* {dataField : "aWsAward",              headerText : "WS AWARD",            style : "my-column", editable : false} */
	];
    
    var columnSGMActualLayout = [
	    {dataField : "mCode",             headerText : "<spring:message code='commissiom.text.excel.memCode'/>",          style : "my-column", editable : false, width : 80 },
	    {dataField : "memberName",     headerText : "<spring:message code='commissiom.text.excel.memNm'/>",         style : "my-column", editable : false, width : 260 },
	    {dataField : "rank",                headerText : "<spring:message code='commissiom.text.excel.rank'/>",                 style : "my-column", editable : false, width : 60 },
	    {dataField : "nric",                 headerText : "<spring:message code='commissiom.text.excel.nric'/>",                   style : "my-column", editable : false, width : 110 },
	    
	    /* {dataField : "aPi",                    headerText : "<spring:message code='commission.text.grid.piAmt'/>",               style : "my-column", editable : false },
	    {dataField : "aPa",                   headerText : "<spring:message code='commission.text.grid.paAmt'/>",              style : "my-column", editable : false }, */
	    {dataField : "aSgmAmt",            headerText : "<spring:message code='commissiom.text.excel.sgmAmt'/>",           style : "my-column", editable : false , width : 200 }
	    /* {dataField : "aMgrAmt",             headerText : "<spring:message code='commissiom.text.excel.mgrAmt'/>",           style : "my-column", editable : false },
	    {dataField : "aOutinsAmt",         headerText : "<spring:message code='commissiom.text.excel.outinsAmt'/>",        style : "my-column", editable : false},
	    {dataField : "aBonus",               headerText : "<spring:message code='commissiom.text.excel.bonus'/>",               style : "my-column", editable : false},
	    {dataField : "aRenmgrAmt",        headerText : "<spring:message code='commissiom.text.excel.renmgrAmt'/>",       style : "my-column", editable : false},
	    {dataField : "aRentalAmt",          headerText : "<spring:message code='commissiom.text.excel.mentalAmt'/>",        style : "my-column", editable : false},
	    {dataField : "aOutplsAmt",          headerText : "<spring:message code='commissiom.text.excel.outplaAmt'/>",       style : "my-column", editable : false},
	    {dataField : "aMembershipAmt",   headerText : "<spring:message code='commissiom.text.excel.membershipAmt'/>", style : "my-column", editable : false},
	    {dataField : "aTbbAmt",             headerText : "<spring:message code='commissiom.text.excel.tbbAmt'/>",           style : "my-column", editable : false},
	    {dataField : "aAdjustAmt",          headerText : "<spring:message code='commissiom.text.excel.adj'/>",             style : "my-column", editable : false},
	    {dataField : "aIncentive",           headerText : "<spring:message code='commissiom.text.excel.incentive'/>",          style : "my-column", editable : false},
	    {dataField : "aShiAmt",              headerText : "<spring:message code='commissiom.text.excel.shiAmt'/>",            style : "my-column", editable : false},
	    {dataField : "aRentalmembershipAmt",     headerText : "<spring:message code='commissiom.text.excel.rentalmembershipAmt'/>",       style : "my-column", editable : false},
	    {dataField : "aRentalmembershipShiAmt", headerText : "<spring:message code='commission.text.grid.shiRentalMemAmt'/>",   style : "my-column", editable : false},
	    {dataField : "aWsAward",              headerText : "WS AWARD",            style : "my-column", editable : false} */
	];

/** ****************************************************************
    SIMULATION GRID
**************************************************************** **/
    var columnHPPSimulLayout = [
        {dataField : "mCode",             headerText : "<spring:message code='commissiom.text.excel.memCode'/>",          style : "my-column", editable : false, width : 80 },
        {dataField : "memberName",     headerText : "<spring:message code='commissiom.text.excel.memNm'/>",         style : "my-column", editable : false, width : 260 },
        {dataField : "rank",                headerText : "<spring:message code='commissiom.text.excel.rank'/>",                 style : "my-column", editable : false },
        {dataField : "nric",                 headerText : "<spring:message code='commissiom.text.excel.nric'/>",                   style : "my-column", editable : false, width : 110 },
        
         {dataField : "sPi",                    headerText : "<spring:message code='commission.text.grid.piAmt'/>",               style : "my-column", editable : false },
        {dataField : "sPa",                   headerText : "<spring:message code='commission.text.grid.paAmt'/>",              style : "my-column", editable : false },
        {dataField : "sSgmAmt",            headerText : "<spring:message code='commissiom.text.excel.sgmAmt'/>",           style : "my-column", editable : false },
        {dataField : "sMgrAmt",             headerText : "<spring:message code='commissiom.text.excel.mgrAmt'/>",           style : "my-column", editable : false },
        {dataField : "sOutinsAmt",         headerText : "<spring:message code='commissiom.text.excel.outinsAmt'/>",        style : "my-column", editable : false},
        {dataField : "sBonus",               headerText : "<spring:message code='commissiom.text.excel.bonus'/>",               style : "my-column", editable : false},
        {dataField : "sRenmgrAmt",        headerText : "<spring:message code='commissiom.text.excel.renmgrAmt'/>",       style : "my-column", editable : false}, 
        {dataField : "sRentalAmt",          headerText : "<spring:message code='commissiom.text.excel.mentalAmt'/>",        style : "my-column", editable : false},
        {dataField : "sOutplsAmt",          headerText : "<spring:message code='commissiom.text.excel.outplaAmt'/>",       style : "my-column", editable : false},
        {dataField : "sMembershipAmt",   headerText : "<spring:message code='commissiom.text.excel.membershipAmt'/>", style : "my-column", editable : false}, 
        {dataField : "sTbbAmt",             headerText : "<spring:message code='commissiom.text.excel.tbbAmt'/>",           style : "my-column", editable : false},
        {dataField : "sAdjustAmt",          headerText : "<spring:message code='commissiom.text.excel.adj'/>",             style : "my-column", editable : false},
        {dataField : "sIncentive",           headerText : "<spring:message code='commissiom.text.excel.incentive'/>",          style : "my-column", editable : false},
        {dataField : "sShiAmt",              headerText : "<spring:message code='commissiom.text.excel.shiAmt'/>",            style : "my-column", editable : false},
        {dataField : "sRentalmembershipAmt",     headerText : "<spring:message code='commissiom.text.excel.rentalmembershipAmt'/>",       style : "my-column", editable : false},
        {dataField : "sRentalmembershipShiAmt", headerText : "<spring:message code='commission.text.grid.shiRentalMemAmt'/>",   style : "my-column", editable : false},
        {dataField : "sAmount",              headerText : "<spring:message code='commissiom.text.excel.grandTot'/>",            style : "my-column", editable : false}
        /* {dataField : "sWsAward",              headerText : "WS AWARD",            style : "my-column", editable : false} */
    ];
    
    var columnHPFSimulLayout = [
        {dataField : "mCode",             headerText : "<spring:message code='commissiom.text.excel.memCode'/>",          style : "my-column", editable : false, width : 80 },
        {dataField : "memberName",     headerText : "<spring:message code='commissiom.text.excel.memNm'/>",         style : "my-column", editable : false, width : 260 },
        {dataField : "rank",                headerText : "<spring:message code='commissiom.text.excel.rank'/>",                 style : "my-column", editable : false },
        {dataField : "nric",                 headerText : "<spring:message code='commissiom.text.excel.nric'/>",                   style : "my-column", editable : false, width : 110 },
        
        {dataField : "sPi",                    headerText : "<spring:message code='commission.text.grid.piAmt'/>",               style : "my-column", editable : false },
        {dataField : "sPa",                   headerText : "<spring:message code='commission.text.grid.paAmt'/>",              style : "my-column", editable : false },
        {dataField : "sSgmAmt",            headerText : "<spring:message code='commissiom.text.excel.sgmAmt'/>",           style : "my-column", editable : false },
        {dataField : "sMgrAmt",             headerText : "<spring:message code='commissiom.text.excel.mgrAmt'/>",           style : "my-column", editable : false },
        {dataField : "sOutinsAmt",         headerText : "<spring:message code='commissiom.text.excel.outinsAmt'/>",        style : "my-column", editable : false},
        {dataField : "sBonus",               headerText : "<spring:message code='commissiom.text.excel.bonus'/>",               style : "my-column", editable : false},
        {dataField : "sRenmgrAmt",        headerText : "<spring:message code='commissiom.text.excel.renmgrAmt'/>",       style : "my-column", editable : false}, 
        {dataField : "sRentalAmt",          headerText : "<spring:message code='commissiom.text.excel.mentalAmt'/>",        style : "my-column", editable : false},
        {dataField : "sOutplsAmt",          headerText : "<spring:message code='commissiom.text.excel.outplaAmt'/>",       style : "my-column", editable : false},
        {dataField : "sMembershipAmt",   headerText : "<spring:message code='commissiom.text.excel.membershipAmt'/>", style : "my-column", editable : false}, 
        {dataField : "sTbbAmt",             headerText : "<spring:message code='commissiom.text.excel.tbbAmt'/>",           style : "my-column", editable : false},
        {dataField : "sAdjustAmt",          headerText : "<spring:message code='commissiom.text.excel.adj'/>",             style : "my-column", editable : false},
        {dataField : "sIncentive",           headerText : "<spring:message code='commissiom.text.excel.incentive'/>",          style : "my-column", editable : false},
        {dataField : "sShiAmt",              headerText : "<spring:message code='commissiom.text.excel.shiAmt'/>",            style : "my-column", editable : false},
        {dataField : "sRentalmembershipAmt",     headerText : "<spring:message code='commissiom.text.excel.rentalmembershipAmt'/>",       style : "my-column", editable : false},
        {dataField : "sRentalmembershipShiAmt", headerText : "<spring:message code='commission.text.grid.shiRentalMemAmt'/>",   style : "my-column", editable : false},
        {dataField : "sAmount",              headerText : "<spring:message code='commissiom.text.excel.grandTot'/>",            style : "my-column", editable : false}
        /* {dataField : "sWsAward",              headerText : "WS AWARD",            style : "my-column", editable : false} */
    ];
    
    var columnHMSimulLayout = [
        {dataField : "mCode",             headerText : "<spring:message code='commissiom.text.excel.memCode'/>",          style : "my-column", editable : false, width : 80 },
        {dataField : "memberName",     headerText : "<spring:message code='commissiom.text.excel.memNm'/>",         style : "my-column", editable : false, width : 260 },
        {dataField : "rank",                headerText : "<spring:message code='commissiom.text.excel.rank'/>",                 style : "my-column", editable : false },
        {dataField : "nric",                 headerText : "<spring:message code='commissiom.text.excel.nric'/>",                   style : "my-column", editable : false, width : 110 },
        
        {dataField : "sPi",                    headerText : "<spring:message code='commission.text.grid.piAmt'/>",               style : "my-column", editable : false },
        {dataField : "sPa",                   headerText : "<spring:message code='commission.text.grid.paAmt'/>",              style : "my-column", editable : false },
        {dataField : "sSgmAmt",            headerText : "<spring:message code='commissiom.text.excel.sgmAmt'/>",           style : "my-column", editable : false }, 
        {dataField : "sMgrAmt",             headerText : "<spring:message code='commissiom.text.excel.mgrAmt'/>",           style : "my-column", editable : false },
        {dataField : "sOutinsAmt",         headerText : "<spring:message code='commissiom.text.excel.outinsAmt'/>",        style : "my-column", editable : false},
        {dataField : "sBonus",               headerText : "<spring:message code='commissiom.text.excel.bonus'/>",               style : "my-column", editable : false}, 
        {dataField : "sRenmgrAmt",        headerText : "<spring:message code='commissiom.text.excel.renmgrAmt'/>",       style : "my-column", editable : false},
        {dataField : "sRentalAmt",          headerText : "<spring:message code='commissiom.text.excel.mentalAmt'/>",        style : "my-column", editable : false}, 
        {dataField : "sOutplsAmt",          headerText : "<spring:message code='commissiom.text.excel.outplaAmt'/>",       style : "my-column", editable : false},
        {dataField : "sMembershipAmt",   headerText : "<spring:message code='commissiom.text.excel.membershipAmt'/>", style : "my-column", editable : false},
        {dataField : "sTbbAmt",             headerText : "<spring:message code='commissiom.text.excel.tbbAmt'/>",           style : "my-column", editable : false},
        {dataField : "sAdjustAmt",          headerText : "<spring:message code='commissiom.text.excel.adj'/>",             style : "my-column", editable : false}, 
        {dataField : "sIncentive",           headerText : "<spring:message code='commissiom.text.excel.incentive'/>",          style : "my-column", editable : false},
        {dataField : "sShiAmt",              headerText : "<spring:message code='commissiom.text.excel.shiAmt'/>",            style : "my-column", editable : false},
        {dataField : "sRentalmembershipAmt",     headerText : "<spring:message code='commissiom.text.excel.rentalmembershipAmt'/>",       style : "my-column", editable : false},
        {dataField : "sRentalmembershipShiAmt", headerText : "<spring:message code='commission.text.grid.shiRentalMemAmt'/>",   style : "my-column", editable : false},
        {dataField : "sAmount",              headerText : "<spring:message code='commissiom.text.excel.grandTot'/>",            style : "my-column", editable : false}
        /* {dataField : "sWsAward",              headerText : "WS AWARD",            style : "my-column", editable : false} */
    ];
    
    var columnSMSimulLayout = [
        {dataField : "mCode",             headerText : "<spring:message code='commissiom.text.excel.memCode'/>",          style : "my-column", editable : false, width : 80 },
        {dataField : "memberName",     headerText : "<spring:message code='commissiom.text.excel.memNm'/>",         style : "my-column", editable : false, width : 260 },
        {dataField : "rank",                headerText : "<spring:message code='commissiom.text.excel.rank'/>",                 style : "my-column", editable : false },
        {dataField : "nric",                 headerText : "<spring:message code='commissiom.text.excel.nric'/>",                   style : "my-column", editable : false, width : 110 },
        
        {dataField : "sPi",                    headerText : "<spring:message code='commission.text.grid.piAmt'/>",               style : "my-column", editable : false },
        {dataField : "sPa",                   headerText : "<spring:message code='commission.text.grid.paAmt'/>",              style : "my-column", editable : false },
        {dataField : "sSgmAmt",            headerText : "<spring:message code='commissiom.text.excel.sgmAmt'/>",           style : "my-column", editable : false }, 
        {dataField : "sMgrAmt",             headerText : "<spring:message code='commissiom.text.excel.mgrAmt'/>",           style : "my-column", editable : false },
        {dataField : "sOutinsAmt",         headerText : "<spring:message code='commissiom.text.excel.outinsAmt'/>",        style : "my-column", editable : false},
        {dataField : "sBonus",               headerText : "<spring:message code='commissiom.text.excel.bonus'/>",               style : "my-column", editable : false},
        {dataField : "sRenmgrAmt",        headerText : "<spring:message code='commissiom.text.excel.renmgrAmt'/>",       style : "my-column", editable : false},
        {dataField : "sRentalAmt",          headerText : "<spring:message code='commissiom.text.excel.mentalAmt'/>",        style : "my-column", editable : false},
        {dataField : "sOutplsAmt",          headerText : "<spring:message code='commissiom.text.excel.outplaAmt'/>",       style : "my-column", editable : false},
        {dataField : "sMembershipAmt",   headerText : "<spring:message code='commissiom.text.excel.membershipAmt'/>", style : "my-column", editable : false}, 
        {dataField : "sTbbAmt",             headerText : "<spring:message code='commissiom.text.excel.tbbAmt'/>",           style : "my-column", editable : false},
        {dataField : "sAdjustAmt",          headerText : "<spring:message code='commissiom.text.excel.adj'/>",             style : "my-column", editable : false}, 
        {dataField : "sIncentive",           headerText : "<spring:message code='commissiom.text.excel.incentive'/>",          style : "my-column", editable : false},
        {dataField : "sShiAmt",              headerText : "<spring:message code='commissiom.text.excel.shiAmt'/>",            style : "my-column", editable : false},
        {dataField : "sRentalmembershipAmt",     headerText : "<spring:message code='commissiom.text.excel.rentalmembershipAmt'/>",       style : "my-column", editable : false},
        {dataField : "sRentalmembershipShiAmt", headerText : "<spring:message code='commission.text.grid.shiRentalMemAmt'/>",   style : "my-column", editable : false},
        {dataField : "sMeetingAllowances", headerText : "<spring:message code='commission.text.grid.meetingAllowances'/>",   style : "my-column", editable : false},
        {dataField : "sAmount",              headerText : "<spring:message code='commissiom.text.excel.grandTot'/>",            style : "my-column", editable : false}
        /* {dataField : "sWsAward",              headerText : "WS AWARD",            style : "my-column", editable : false} */
    ];
    
    var columnGMSimulLayout = [
        {dataField : "mCode",             headerText : "<spring:message code='commissiom.text.excel.memCode'/>",          style : "my-column", editable : false, width : 80 },
        {dataField : "memberName",     headerText : "<spring:message code='commissiom.text.excel.memNm'/>",         style : "my-column", editable : false, width : 260 },
        {dataField : "rank",                headerText : "<spring:message code='commissiom.text.excel.rank'/>",                 style : "my-column", editable : false },
        {dataField : "nric",                 headerText : "<spring:message code='commissiom.text.excel.nric'/>",                   style : "my-column", editable : false, width : 110 },
        
        {dataField : "sPi",                    headerText : "<spring:message code='commission.text.grid.piAmt'/>",               style : "my-column", editable : false },
        {dataField : "sPa",                   headerText : "<spring:message code='commission.text.grid.paAmt'/>",              style : "my-column", editable : false },
        {dataField : "sSgmAmt",            headerText : "<spring:message code='commissiom.text.excel.sgmAmt'/>",           style : "my-column", editable : false }, 
        {dataField : "sMgrAmt",             headerText : "<spring:message code='commissiom.text.excel.mgrAmt'/>",           style : "my-column", editable : false },
        {dataField : "sOutinsAmt",         headerText : "<spring:message code='commissiom.text.excel.outinsAmt'/>",        style : "my-column", editable : false},
        {dataField : "sBonus",               headerText : "<spring:message code='commissiom.text.excel.bonus'/>",               style : "my-column", editable : false}, 
        {dataField : "sRenmgrAmt",        headerText : "<spring:message code='commissiom.text.excel.renmgrAmt'/>",       style : "my-column", editable : false},
        {dataField : "sRentalAmt",          headerText : "<spring:message code='commissiom.text.excel.mentalAmt'/>",        style : "my-column", editable : false}, 
        {dataField : "sOutplsAmt",          headerText : "<spring:message code='commissiom.text.excel.outplaAmt'/>",       style : "my-column", editable : false},
        {dataField : "sMembershipAmt",   headerText : "<spring:message code='commissiom.text.excel.membershipAmt'/>", style : "my-column", editable : false}, 
        {dataField : "sTbbAmt",             headerText : "<spring:message code='commissiom.text.excel.tbbAmt'/>",           style : "my-column", editable : false},
        {dataField : "sAdjustAmt",          headerText : "<spring:message code='commissiom.text.excel.adj'/>",             style : "my-column", editable : false}, 
        {dataField : "sIncentive",           headerText : "<spring:message code='commissiom.text.excel.incentive'/>",          style : "my-column", editable : false},
        {dataField : "sShiAmt",              headerText : "<spring:message code='commissiom.text.excel.shiAmt'/>",            style : "my-column", editable : false},
        {dataField : "sRentalmembershipAmt",     headerText : "<spring:message code='commissiom.text.excel.rentalmembershipAmt'/>",       style : "my-column", editable : false},
        {dataField : "sRentalmembershipShiAmt", headerText : "<spring:message code='commission.text.grid.shiRentalMemAmt'/>",   style : "my-column", editable : false},
        {dataField : "sMeetingAllowances", headerText : "<spring:message code='commission.text.grid.meetingAllowances'/>",   style : "my-column", editable : false},
        {dataField : "sAmount",              headerText : "<spring:message code='commissiom.text.excel.grandTot'/>",            style : "my-column", editable : false}
        /* {dataField : "sWsAward",              headerText : "WS AWARD",            style : "my-column", editable : false} */
    ];
    
    var columnSGMSimulLayout = [
        {dataField : "mCode",             headerText : "<spring:message code='commissiom.text.excel.memCode'/>",          style : "my-column", editable : false, width : 80 },
        {dataField : "memberName",     headerText : "<spring:message code='commissiom.text.excel.memNm'/>",         style : "my-column", editable : false, width : 260 },
        {dataField : "rank",                headerText : "<spring:message code='commissiom.text.excel.rank'/>",                 style : "my-column", editable : false, width : 60 },
        {dataField : "nric",                 headerText : "<spring:message code='commissiom.text.excel.nric'/>",                   style : "my-column", editable : false, width : 110 },
        
        /* {dataField : "sPi",                    headerText : "<spring:message code='commission.text.grid.piAmt'/>",               style : "my-column", editable : false },
        {dataField : "sPa",                   headerText : "<spring:message code='commission.text.grid.paAmt'/>",              style : "my-column", editable : false }, */
        {dataField : "sSgmAmt",            headerText : "<spring:message code='commissiom.text.excel.sgmAmt'/>",           style : "my-column", editable : false , width : 200 }
        /* {dataField : "sMgrAmt",             headerText : "<spring:message code='commissiom.text.excel.mgrAmt'/>",           style : "my-column", editable : false },
        {dataField : "sOutinsAmt",         headerText : "<spring:message code='commissiom.text.excel.outinsAmt'/>",        style : "my-column", editable : false},
        {dataField : "sBonus",               headerText : "<spring:message code='commissiom.text.excel.bonus'/>",               style : "my-column", editable : false},
        {dataField : "sRenmgrAmt",        headerText : "<spring:message code='commissiom.text.excel.renmgrAmt'/>",       style : "my-column", editable : false},
        {dataField : "sRentalAmt",          headerText : "<spring:message code='commissiom.text.excel.mentalAmt'/>",        style : "my-column", editable : false},
        {dataField : "sOutplsAmt",          headerText : "<spring:message code='commissiom.text.excel.outplaAmt'/>",       style : "my-column", editable : false},
        {dataField : "sMembershipAmt",   headerText : "<spring:message code='commissiom.text.excel.membershipAmt'/>", style : "my-column", editable : false},
        {dataField : "sTbbAmt",             headerText : "<spring:message code='commissiom.text.excel.tbbAmt'/>",           style : "my-column", editable : false},
        {dataField : "sAdjustAmt",          headerText : "<spring:message code='commissiom.text.excel.adj'/>",             style : "my-column", editable : false},
        {dataField : "sIncentive",           headerText : "<spring:message code='commissiom.text.excel.incentive'/>",          style : "my-column", editable : false},
        {dataField : "sShiAmt",              headerText : "<spring:message code='commissiom.text.excel.shiAmt'/>",            style : "my-column", editable : false},
        {dataField : "sRentalmembershipAmt",     headerText : "<spring:message code='commissiom.text.excel.rentalmembershipAmt'/>",       style : "my-column", editable : false},
        {dataField : "sRentalmembershipShiAmt", headerText : "<spring:message code='commission.text.grid.shiRentalMemAmt'/>",   style : "my-column", editable : false},
        {dataField : "sWsAward",              headerText : "WS AWARD",            style : "my-column", editable : false} */
    ];

/** ****************************************************************
    COMPARE GRID
**************************************************************** **/
    var columnHPPCompareLayout = [
	    {dataField : "mCode",             headerText : "<spring:message code='commissiom.text.excel.memCode'/>",          style : "my-column", editable : false, width : 80 },
	    {dataField : "memberName",     headerText : "<spring:message code='commissiom.text.excel.memNm'/>",         style : "my-column", editable : false, width : 260 },
	    {dataField : "rank",                headerText : "<spring:message code='commissiom.text.excel.rank'/>",                 style : "my-column", editable : false },
	    {dataField : "nric",                 headerText : "<spring:message code='commissiom.text.excel.nric'/>",                   style : "my-column", editable : false, width : 110 },
	    
	    {headerText : "<spring:message code='commission.text.grid.piAmt'/>",            children: [{dataField: "aPi", headerText: "A", editable : false}, {dataField: "sPi", headerText: "S", editable : false}]},
	    {headerText : "<spring:message code='commission.text.grid.paAmt'/>",           children: [{dataField: "aPa", headerText: "A", editable : false}, {dataField: "sPa", headerText: "S", editable : false}]},
	    {headerText : "<spring:message code='commissiom.text.excel.sgmAmt'/>",         children: [{dataField: "aSgmAmt", headerText: "A", editable : false}, {dataField: "sSgmAmt", headerText: "S", editable : false }]},
	    {headerText : "<spring:message code='commissiom.text.excel.mgrAmt'/>",         children: [{dataField: "aMgrAmt", headerText: "A", editable : false}, {dataField: "sMgrAmt", headerText: "S", editable : false}]},
	    {headerText : "<spring:message code='commissiom.text.excel.outinsAmt'/>",      children: [{dataField: "aOutinsAmt", headerText: "A", editable : false}, {dataField: "sOutinsAmt", headerText: "S", editable : false}]},
	    
	    {headerText : "<spring:message code='commissiom.text.excel.bonus'/>",                children: [{dataField: "aBonus", headerText: "A", editable : false}, {dataField: "sBonus", headerText: "S", editable : false}]},
	    {headerText : "<spring:message code='commissiom.text.excel.renmgrAmt'/>",        children: [{dataField: "aRenmgrAmt", headerText: "A", editable : false}, {dataField: "sRenmgrAmt", headerText: "S", editable : false}]},
	    {headerText : "<spring:message code='commissiom.text.excel.mentalAmt'/>",         children: [{dataField: "aRentalAmt", headerText: "A", editable : false}, {dataField: "sRentalAmt", headerText: "S", editable : false}]},
	    {headerText : "<spring:message code='commissiom.text.excel.outplaAmt'/>",         children: [{dataField: "aOutplsAmt", headerText: "A", editable : false}, {dataField: "sOutplsAmt", headerText: "S", editable : false}]},
	    {headerText : "<spring:message code='commissiom.text.excel.membershipAmt'/>",  children: [{dataField: "aMembershipAmt", headerText: "A", editable : false}, {dataField: "sMembershipAmt", headerText: "S", editable : false}]},
	    
	    {headerText : "<spring:message code='commissiom.text.excel.tbbAmt'/>",                     children: [{dataField: "aTbbAmt", headerText: "A", editable : false}, {dataField: "sTbbAmt", headerText: "S", editable : false}]},
	    {headerText : "<spring:message code='commissiom.text.excel.adj'/>",                        children: [{dataField: "aAdjustAmt", headerText: "A", editable : false}, {dataField: "sAdjustAmt", headerText: "S", editable : false}]},
	    {headerText : "<spring:message code='commissiom.text.excel.incentive'/>",                    children: [{dataField: "aIncentive", headerText: "A", editable : false,}, {dataField: "sIncentive", headerText: "S", editable : false}]},
	    {headerText : "<spring:message code='commissiom.text.excel.shiAmt'/>",                      children: [{dataField: "aShiAmt", headerText: "A", editable : false}, {dataField: "sShiAmt", headerText: "S", editable : false}]},
	    {headerText : "<spring:message code='commissiom.text.excel.rentalmembershipAmt'/>",  children: [{dataField: "aRentalmembershipAmt", headerText: "A", editable : false}, {dataField: "sRentalmembershipAmt", headerText: "S", editable : false}]},
	    
	    {headerText : "<spring:message code='commission.text.grid.shiRentalMemAmt'/>",  children: [{dataField: "aRentalmembershipShiAmt", headerText: "A", editable : false}, {dataField: "sRentalmembershipShiAmt", headerText: "S", editable : false}]},
	    {headerText : "<spring:message code='commissiom.text.excel.grandTot'/>",  children: [{dataField: "aAmount", headerText: "A", editable : false}, {dataField: "sAmount", headerText: "S", editable : false}]}
	    /* {headerText : "WS Award",                      children: [{dataField: "aWsAward", headerText: "A", editable : false}, {dataField: "sWsAward", headerText: "S", editable : false}]} */
	];
	
    var columnHPFCompareLayout = [
	    {dataField : "mCode",             headerText : "<spring:message code='commissiom.text.excel.memCode'/>",          style : "my-column", editable : false, width : 80 },
	    {dataField : "memberName",     headerText : "<spring:message code='commissiom.text.excel.memNm'/>",         style : "my-column", editable : false, width : 260 },
	    {dataField : "rank",                headerText : "<spring:message code='commissiom.text.excel.rank'/>",                 style : "my-column", editable : false },
	    {dataField : "nric",                 headerText : "<spring:message code='commissiom.text.excel.nric'/>",                   style : "my-column", editable : false, width : 110 },
	    
	    {headerText : "<spring:message code='commission.text.grid.piAmt'/>",            children: [{dataField: "aPi", headerText: "A", editable : false}, {dataField: "sPi", headerText: "S", editable : false}]},
	    {headerText : "<spring:message code='commission.text.grid.paAmt'/>",           children: [{dataField: "aPa", headerText: "A", editable : false}, {dataField: "sPa", headerText: "S", editable : false}]},
	    {headerText : "<spring:message code='commissiom.text.excel.sgmAmt'/>",         children: [{dataField: "aSgmAmt", headerText: "A", editable : false}, {dataField: "sSgmAmt", headerText: "S", editable : false }]},
	    {headerText : "<spring:message code='commissiom.text.excel.mgrAmt'/>",         children: [{dataField: "aMgrAmt", headerText: "A", editable : false}, {dataField: "sMgrAmt", headerText: "S", editable : false}]},
	    {headerText : "<spring:message code='commissiom.text.excel.outinsAmt'/>",      children: [{dataField: "aOutinsAmt", headerText: "A", editable : false}, {dataField: "sOutinsAmt", headerText: "S", editable : false}]},
	    
	    {headerText : "<spring:message code='commissiom.text.excel.bonus'/>",                children: [{dataField: "aBonus", headerText: "A", editable : false}, {dataField: "sBonus", headerText: "S", editable : false}]},
	    {headerText : "<spring:message code='commissiom.text.excel.renmgrAmt'/>",        children: [{dataField: "aRenmgrAmt", headerText: "A", editable : false}, {dataField: "sRenmgrAmt", headerText: "S", editable : false}]},
	    {headerText : "<spring:message code='commissiom.text.excel.mentalAmt'/>",         children: [{dataField: "aRentalAmt", headerText: "A", editable : false}, {dataField: "sRentalAmt", headerText: "S", editable : false}]},
	    {headerText : "<spring:message code='commissiom.text.excel.outplaAmt'/>",         children: [{dataField: "aOutplsAmt", headerText: "A", editable : false}, {dataField: "sOutplsAmt", headerText: "S", editable : false}]},
	    {headerText : "<spring:message code='commissiom.text.excel.membershipAmt'/>",  children: [{dataField: "aMembershipAmt", headerText: "A", editable : false}, {dataField: "sMembershipAmt", headerText: "S", editable : false}]},
	    
	    {headerText : "<spring:message code='commissiom.text.excel.tbbAmt'/>",                     children: [{dataField: "aTbbAmt", headerText: "A", editable : false}, {dataField: "sTbbAmt", headerText: "S", editable : false}]},
	    {headerText : "<spring:message code='commissiom.text.excel.adj'/>",                        children: [{dataField: "aAdjustAmt", headerText: "A", editable : false}, {dataField: "sAdjustAmt", headerText: "S", editable : false}]},
	    {headerText : "<spring:message code='commissiom.text.excel.incentive'/>",                    children: [{dataField: "aIncentive", headerText: "A", editable : false,}, {dataField: "sIncentive", headerText: "S", editable : false}]},
	    {headerText : "<spring:message code='commissiom.text.excel.shiAmt'/>",                      children: [{dataField: "aShiAmt", headerText: "A", editable : false}, {dataField: "sShiAmt", headerText: "S", editable : false}]},
	    {headerText : "<spring:message code='commissiom.text.excel.rentalmembershipAmt'/>",  children: [{dataField: "aRentalmembershipAmt", headerText: "A", editable : false}, {dataField: "sRentalmembershipAmt", headerText: "S", editable : false}]},
	    
	    {headerText : "<spring:message code='commission.text.grid.shiRentalMemAmt'/>",  children: [{dataField: "aRentalmembershipShiAmt", headerText: "A", editable : false}, {dataField: "sRentalmembershipShiAmt", headerText: "S", editable : false}]},
	    {headerText : "<spring:message code='commissiom.text.excel.grandTot'/>",  children: [{dataField: "aAmount", headerText: "A", editable : false}, {dataField: "sAmount", headerText: "S", editable : false}]}
	    /* {headerText : "WS Award",                      children: [{dataField: "aWsAward", headerText: "A", editable : false}, {dataField: "sWsAward", headerText: "S", editable : false}]} */
	];
    var columnHMCompareLayout = [
	    {dataField : "mCode",             headerText : "<spring:message code='commissiom.text.excel.memCode'/>",          style : "my-column", editable : false, width : 80 },
	    {dataField : "memberName",     headerText : "<spring:message code='commissiom.text.excel.memNm'/>",         style : "my-column", editable : false, width : 260 },
	    {dataField : "rank",                headerText : "<spring:message code='commissiom.text.excel.rank'/>",                 style : "my-column", editable : false },
	    {dataField : "nric",                 headerText : "<spring:message code='commissiom.text.excel.nric'/>",                   style : "my-column", editable : false, width : 110 },
	    
	    {headerText : "<spring:message code='commission.text.grid.piAmt'/>",            children: [{dataField: "aPi", headerText: "A", editable : false}, {dataField: "sPi", headerText: "S", editable : false}]},
	    {headerText : "<spring:message code='commission.text.grid.paAmt'/>",           children: [{dataField: "aPa", headerText: "A", editable : false}, {dataField: "sPa", headerText: "S", editable : false}]},
	    {headerText : "<spring:message code='commissiom.text.excel.sgmAmt'/>",         children: [{dataField: "aSgmAmt", headerText: "A", editable : false}, {dataField: "sSgmAmt", headerText: "S", editable : false }]},
	    {headerText : "<spring:message code='commissiom.text.excel.mgrAmt'/>",         children: [{dataField: "aMgrAmt", headerText: "A", editable : false}, {dataField: "sMgrAmt", headerText: "S", editable : false}]},
	    {headerText : "<spring:message code='commissiom.text.excel.outinsAmt'/>",      children: [{dataField: "aOutinsAmt", headerText: "A", editable : false}, {dataField: "sOutinsAmt", headerText: "S", editable : false}]},
	    
	    {headerText : "<spring:message code='commissiom.text.excel.bonus'/>",                children: [{dataField: "aBonus", headerText: "A", editable : false}, {dataField: "sBonus", headerText: "S", editable : false}]},
	    {headerText : "<spring:message code='commissiom.text.excel.renmgrAmt'/>",        children: [{dataField: "aRenmgrAmt", headerText: "A", editable : false}, {dataField: "sRenmgrAmt", headerText: "S", editable : false}]},
	    {headerText : "<spring:message code='commissiom.text.excel.mentalAmt'/>",         children: [{dataField: "aRentalAmt", headerText: "A", editable : false}, {dataField: "sRentalAmt", headerText: "S", editable : false}]},
	    {headerText : "<spring:message code='commissiom.text.excel.outplaAmt'/>",         children: [{dataField: "aOutplsAmt", headerText: "A", editable : false}, {dataField: "sOutplsAmt", headerText: "S", editable : false}]},
	    {headerText : "<spring:message code='commissiom.text.excel.membershipAmt'/>",  children: [{dataField: "aMembershipAmt", headerText: "A", editable : false}, {dataField: "sMembershipAmt", headerText: "S", editable : false}]},
	    
	    {headerText : "<spring:message code='commissiom.text.excel.tbbAmt'/>",                     children: [{dataField: "aTbbAmt", headerText: "A", editable : false}, {dataField: "sTbbAmt", headerText: "S", editable : false}]},
	    {headerText : "<spring:message code='commissiom.text.excel.adj'/>",                        children: [{dataField: "aAdjustAmt", headerText: "A", editable : false}, {dataField: "sAdjustAmt", headerText: "S", editable : false}]},
	    {headerText : "<spring:message code='commissiom.text.excel.incentive'/>",                    children: [{dataField: "aIncentive", headerText: "A", editable : false,}, {dataField: "sIncentive", headerText: "S", editable : false}]},
	    {headerText : "<spring:message code='commissiom.text.excel.shiAmt'/>",                      children: [{dataField: "aShiAmt", headerText: "A", editable : false}, {dataField: "sShiAmt", headerText: "S", editable : false}]},
	    {headerText : "<spring:message code='commissiom.text.excel.rentalmembershipAmt'/>",  children: [{dataField: "aRentalmembershipAmt", headerText: "A", editable : false}, {dataField: "sRentalmembershipAmt", headerText: "S", editable : false}]},
	    
	    {headerText : "<spring:message code='commission.text.grid.shiRentalMemAmt'/>",  children: [{dataField: "aRentalmembershipShiAmt", headerText: "A", editable : false}, {dataField: "sRentalmembershipShiAmt", headerText: "S", editable : false}]},
	    {headerText : "<spring:message code='commissiom.text.excel.grandTot'/>",  children: [{dataField: "aAmount", headerText: "A", editable : false}, {dataField: "sAmount", headerText: "S", editable : false}]}
	    /* {headerText : "WS Award",                      children: [{dataField: "aWsAward", headerText: "A", editable : false}, {dataField: "sWsAward", headerText: "S", editable : false}]} */
	];
    var columnSMCompareLayout = [
	    {dataField : "mCode",             headerText : "<spring:message code='commissiom.text.excel.memCode'/>",          style : "my-column", editable : false, width : 80 },
	    {dataField : "memberName",     headerText : "<spring:message code='commissiom.text.excel.memNm'/>",         style : "my-column", editable : false, width : 260 },
	    {dataField : "rank",                headerText : "<spring:message code='commissiom.text.excel.rank'/>",                 style : "my-column", editable : false },
	    {dataField : "nric",                 headerText : "<spring:message code='commissiom.text.excel.nric'/>",                   style : "my-column", editable : false, width : 110 },
	    
	    {headerText : "<spring:message code='commission.text.grid.piAmt'/>",            children: [{dataField: "aPi", headerText: "A", editable : false}, {dataField: "sPi", headerText: "S", editable : false}]},
	    {headerText : "<spring:message code='commission.text.grid.paAmt'/>",           children: [{dataField: "aPa", headerText: "A", editable : false}, {dataField: "sPa", headerText: "S", editable : false}]},
	    {headerText : "<spring:message code='commissiom.text.excel.sgmAmt'/>",         children: [{dataField: "aSgmAmt", headerText: "A", editable : false}, {dataField: "sSgmAmt", headerText: "S", editable : false }]},
	    {headerText : "<spring:message code='commissiom.text.excel.mgrAmt'/>",         children: [{dataField: "aMgrAmt", headerText: "A", editable : false}, {dataField: "sMgrAmt", headerText: "S", editable : false}]},
	    {headerText : "<spring:message code='commissiom.text.excel.outinsAmt'/>",      children: [{dataField: "aOutinsAmt", headerText: "A", editable : false}, {dataField: "sOutinsAmt", headerText: "S", editable : false}]},
	    
	    {headerText : "<spring:message code='commissiom.text.excel.bonus'/>",                children: [{dataField: "aBonus", headerText: "A", editable : false}, {dataField: "sBonus", headerText: "S", editable : false}]},
	    {headerText : "<spring:message code='commissiom.text.excel.renmgrAmt'/>",        children: [{dataField: "aRenmgrAmt", headerText: "A", editable : false}, {dataField: "sRenmgrAmt", headerText: "S", editable : false}]},
	    {headerText : "<spring:message code='commissiom.text.excel.mentalAmt'/>",         children: [{dataField: "aRentalAmt", headerText: "A", editable : false}, {dataField: "sRentalAmt", headerText: "S", editable : false}]},
	    {headerText : "<spring:message code='commissiom.text.excel.outplaAmt'/>",         children: [{dataField: "aOutplsAmt", headerText: "A", editable : false}, {dataField: "sOutplsAmt", headerText: "S", editable : false}]},
	    {headerText : "<spring:message code='commissiom.text.excel.membershipAmt'/>",  children: [{dataField: "aMembershipAmt", headerText: "A", editable : false}, {dataField: "sMembershipAmt", headerText: "S", editable : false}]},
	    
	    {headerText : "<spring:message code='commissiom.text.excel.tbbAmt'/>",                     children: [{dataField: "aTbbAmt", headerText: "A", editable : false}, {dataField: "sTbbAmt", headerText: "S", editable : false}]},
	    {headerText : "<spring:message code='commissiom.text.excel.adj'/>",                        children: [{dataField: "aAdjustAmt", headerText: "A", editable : false}, {dataField: "sAdjustAmt", headerText: "S", editable : false}]},
	    {headerText : "<spring:message code='commissiom.text.excel.incentive'/>",                    children: [{dataField: "aIncentive", headerText: "A", editable : false,}, {dataField: "sIncentive", headerText: "S", editable : false}]},
	    {headerText : "<spring:message code='commissiom.text.excel.shiAmt'/>",                      children: [{dataField: "aShiAmt", headerText: "A", editable : false}, {dataField: "sShiAmt", headerText: "S", editable : false}]},
	    {headerText : "<spring:message code='commissiom.text.excel.rentalmembershipAmt'/>",  children: [{dataField: "aRentalmembershipAmt", headerText: "A", editable : false}, {dataField: "sRentalmembershipAmt", headerText: "S", editable : false}]},
	    
	    {headerText : "<spring:message code='commission.text.grid.shiRentalMemAmt'/>",  children: [{dataField: "aRentalmembershipShiAmt", headerText: "A", editable : false}, {dataField: "sRentalmembershipShiAmt", headerText: "S", editable : false}]},
	    {headerText : "<spring:message code='commission.text.grid.meetingAllowances'/>",  children: [{dataField: "aMeetingAllowances", headerText: "A", editable : false}, {dataField: "sMeetingAllowances", headerText: "S", editable : false}]},
	    {headerText : "<spring:message code='commissiom.text.excel.grandTot'/>",  children: [{dataField: "aAmount", headerText: "A", editable : false}, {dataField: "sAmount", headerText: "S", editable : false}]}
	    /* {headerText : "WS Award",                      children: [{dataField: "aWsAward", headerText: "A", editable : false}, {dataField: "sWsAward", headerText: "S", editable : false}]} */
	];
    var columnGMCompareLayout = [
	     {dataField : "mCode",             headerText : "<spring:message code='commissiom.text.excel.memCode'/>",          style : "my-column", editable : false, width : 80 },
	     {dataField : "memberName",     headerText : "<spring:message code='commissiom.text.excel.memNm'/>",         style : "my-column", editable : false, width : 260 },
	     {dataField : "rank",                headerText : "<spring:message code='commissiom.text.excel.rank'/>",                 style : "my-column", editable : false },
	     {dataField : "nric",                 headerText : "<spring:message code='commissiom.text.excel.nric'/>",                   style : "my-column", editable : false, width : 110 },
	     
	     {headerText : "<spring:message code='commission.text.grid.piAmt'/>",            children: [{dataField: "aPi", headerText: "A", editable : false}, {dataField: "sPi", headerText: "S", editable : false}]},
	     {headerText : "<spring:message code='commission.text.grid.paAmt'/>",           children: [{dataField: "aPa", headerText: "A", editable : false}, {dataField: "sPa", headerText: "S", editable : false}]},
	     {headerText : "<spring:message code='commissiom.text.excel.sgmAmt'/>",         children: [{dataField: "aSgmAmt", headerText: "A", editable : false}, {dataField: "sSgmAmt", headerText: "S", editable : false }]},
	     {headerText : "<spring:message code='commissiom.text.excel.mgrAmt'/>",         children: [{dataField: "aMgrAmt", headerText: "A", editable : false}, {dataField: "sMgrAmt", headerText: "S", editable : false}]},
	     {headerText : "<spring:message code='commissiom.text.excel.outinsAmt'/>",      children: [{dataField: "aOutinsAmt", headerText: "A", editable : false}, {dataField: "sOutinsAmt", headerText: "S", editable : false}]},
	     
	     {headerText : "<spring:message code='commissiom.text.excel.bonus'/>",                children: [{dataField: "aBonus", headerText: "A", editable : false}, {dataField: "sBonus", headerText: "S", editable : false}]},
	     {headerText : "<spring:message code='commissiom.text.excel.renmgrAmt'/>",        children: [{dataField: "aRenmgrAmt", headerText: "A", editable : false}, {dataField: "sRenmgrAmt", headerText: "S", editable : false}]},
	     {headerText : "<spring:message code='commissiom.text.excel.mentalAmt'/>",         children: [{dataField: "aRentalAmt", headerText: "A", editable : false}, {dataField: "sRentalAmt", headerText: "S", editable : false}]},
	     {headerText : "<spring:message code='commissiom.text.excel.outplaAmt'/>",         children: [{dataField: "aOutplsAmt", headerText: "A", editable : false}, {dataField: "sOutplsAmt", headerText: "S", editable : false}]},
	     {headerText : "<spring:message code='commissiom.text.excel.membershipAmt'/>",  children: [{dataField: "aMembershipAmt", headerText: "A", editable : false}, {dataField: "sMembershipAmt", headerText: "S", editable : false}]},
	     
	     {headerText : "<spring:message code='commissiom.text.excel.tbbAmt'/>",                     children: [{dataField: "aTbbAmt", headerText: "A", editable : false}, {dataField: "sTbbAmt", headerText: "S", editable : false}]},
	     {headerText : "<spring:message code='commissiom.text.excel.adj'/>",                        children: [{dataField: "aAdjustAmt", headerText: "A", editable : false}, {dataField: "sAdjustAmt", headerText: "S", editable : false}]},
	     {headerText : "<spring:message code='commissiom.text.excel.incentive'/>",                    children: [{dataField: "aIncentive", headerText: "A", editable : false,}, {dataField: "sIncentive", headerText: "S", editable : false}]},
	     {headerText : "<spring:message code='commissiom.text.excel.shiAmt'/>",                      children: [{dataField: "aShiAmt", headerText: "A", editable : false}, {dataField: "sShiAmt", headerText: "S", editable : false}]},
	     {headerText : "<spring:message code='commissiom.text.excel.rentalmembershipAmt'/>",  children: [{dataField: "aRentalmembershipAmt", headerText: "A", editable : false}, {dataField: "sRentalmembershipAmt", headerText: "S", editable : false}]},
	     
	     {headerText : "<spring:message code='commission.text.grid.shiRentalMemAmt'/>",  children: [{dataField: "aRentalmembershipShiAmt", headerText: "A", editable : false}, {dataField: "sRentalmembershipShiAmt", headerText: "S", editable : false}]},
	     {headerText : "<spring:message code='commission.text.grid.meetingAllowances'/>",  children: [{dataField: "aMeetingAllowances", headerText: "A", editable : false}, {dataField: "sMeetingAllowances", headerText: "S", editable : false}]},
	     {headerText : "<spring:message code='commissiom.text.excel.grandTot'/>",  children: [{dataField: "aAmount", headerText: "A", editable : false}, {dataField: "sAmount", headerText: "S", editable : false}]}
	     /* {headerText : "WS Award",                      children: [{dataField: "aWsAward", headerText: "A", editable : false}, {dataField: "sWsAward", headerText: "S", editable : false}]} */
	 ];
    var columnSGMCompareLayout = [
	    {dataField : "mCode",             headerText : "<spring:message code='commissiom.text.excel.memCode'/>",          style : "my-column", editable : false, width : 80 },
	    {dataField : "memberName",     headerText : "<spring:message code='commissiom.text.excel.memNm'/>",         style : "my-column", editable : false, width : 260 },
	    {dataField : "rank",                headerText : "<spring:message code='commissiom.text.excel.rank'/>",                 style : "my-column", editable : false, width : 60 },
	    {dataField : "nric",                 headerText : "<spring:message code='commissiom.text.excel.nric'/>",                   style : "my-column", editable : false, width : 110 },
	    
	    /* {headerText : "<spring:message code='commission.text.grid.piAmt'/>",            children: [{dataField: "aPi", headerText: "A", editable : false}, {dataField: "sPi", headerText: "S", editable : false}]},
	    {headerText : "<spring:message code='commission.text.grid.paAmt'/>",           children: [{dataField: "aPa", headerText: "A", editable : false}, {dataField: "sPa", headerText: "S", editable : false}]}, */
	    {headerText : "<spring:message code='commissiom.text.excel.sgmAmt'/>",         children: [{dataField: "aSgmAmt", headerText: "A", editable : false, width : 100 }, {dataField: "sSgmAmt", headerText: "S", editable : false, width : 100  }]}
	    /* {headerText : "<spring:message code='commissiom.text.excel.mgrAmt'/>",         children: [{dataField: "aMgrAmt", headerText: "A", editable : false}, {dataField: "sMgrAmt", headerText: "S", editable : false}]},
	    {headerText : "<spring:message code='commissiom.text.excel.outinsAmt'/>",      children: [{dataField: "aOutinsAmt", headerText: "A", editable : false}, {dataField: "sOutinsAmt", headerText: "S", editable : false}]},
	    
	    {headerText : "<spring:message code='commissiom.text.excel.bonus'/>",                children: [{dataField: "aBonus", headerText: "A", editable : false}, {dataField: "sBonus", headerText: "S", editable : false}]},
	    {headerText : "<spring:message code='commissiom.text.excel.renmgrAmt'/>",        children: [{dataField: "aRenmgrAmt", headerText: "A", editable : false}, {dataField: "sRenmgrAmt", headerText: "S", editable : false}]},
	    {headerText : "<spring:message code='commissiom.text.excel.mentalAmt'/>",         children: [{dataField: "aRentalAmt", headerText: "A", editable : false}, {dataField: "sRentalAmt", headerText: "S", editable : false}]},
	    {headerText : "<spring:message code='commissiom.text.excel.outplaAmt'/>",         children: [{dataField: "aOutplsAmt", headerText: "A", editable : false}, {dataField: "sOutplsAmt", headerText: "S", editable : false}]},
	    {headerText : "<spring:message code='commissiom.text.excel.membershipAmt'/>",  children: [{dataField: "aMembershipAmt", headerText: "A", editable : false}, {dataField: "sMembershipAmt", headerText: "S", editable : false}]},
	    
	    {headerText : "<spring:message code='commissiom.text.excel.tbbAmt'/>",                     children: [{dataField: "aTbbAmt", headerText: "A", editable : false}, {dataField: "sTbbAmt", headerText: "S", editable : false}]},
	    {headerText : "<spring:message code='commissiom.text.excel.adj'/>",                        children: [{dataField: "aAdjustAmt", headerText: "A", editable : false}, {dataField: "sAdjustAmt", headerText: "S", editable : false}]},
	    {headerText : "<spring:message code='commissiom.text.excel.incentive'/>",                    children: [{dataField: "aIncentive", headerText: "A", editable : false,}, {dataField: "sIncentive", headerText: "S", editable : false}]},
	    {headerText : "<spring:message code='commissiom.text.excel.shiAmt'/>",                      children: [{dataField: "aShiAmt", headerText: "A", editable : false}, {dataField: "sShiAmt", headerText: "S", editable : false}]},
	    {headerText : "<spring:message code='commissiom.text.excel.rentalmembershipAmt'/>",  children: [{dataField: "aRentalmembershipAmt", headerText: "A", editable : false}, {dataField: "sRentalmembershipAmt", headerText: "S", editable : false}]},
	    
	    {headerText : "<spring:message code='commission.text.grid.shiRentalMemAmt'/>",  children: [{dataField: "aRentalmembershipShiAmt", headerText: "A", editable : false}, {dataField: "sRentalmembershipShiAmt", headerText: "S", editable : false}]},
	    {headerText : "WS Award",                      children: [{dataField: "aWsAward", headerText: "A", editable : false}, {dataField: "sWsAward", headerText: "S", editable : false}]} */
	];
</script>

<section id="content"><!-- content start -->
	<ul class="path">
        <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
        <li><spring:message code='commission.text.head.commission'/></li>
                <li><spring:message code='commission.text.head.report'/></li>
        <li><spring:message code='commission.text.head.hpReport'/></li>
        <li><spring:message code='commission.text.head.hpCommissionResult'/></li>
    </ul>
	
	<aside class="title_line"><!-- title_line start -->
		<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
		<h2><spring:message code='commission.title.resultHP'/></h2>
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