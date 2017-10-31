<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<style type="text/css">
.my-custom-up div{
    color:#FF0000;
}
</style>
<script type="text/javaScript">
//AUIGrid 그리드 객체
var masterListGridID;
var statementdetailPopGridID;
var journalEntryPopGridID;
//Grid에서 선택된 RowID
var selectedGridValue;

var gridPros = {
        // 편집 가능 여부 (기본값 : false)
        editable : false,
        
        // 상태 칼럼 사용
        showStateColumn : false
        
};

var keyValueList = [{"code":"59", "value":"Other Debtor"}, {"code":"203", "value":"Other Income"}, {"code":"342", "value":"Bank Charges"}];

$(document).ready(function(){
	
	doGetCombo('/common/getAccountList.do', 'CASH' , ''   , 'accountId' , 'S', '');
	
	masterListGridID = GridCommon.createAUIGrid("master_grid_wrap", masterColumnLayout, null, gridPros);
	
	//Grid 셀 클릭시 이벤트
    AUIGrid.bind(masterListGridID, "cellClick", function( event ){
        selectedGridValue = event.rowIndex;
    });
	
});

// AUIGrid 칼럼 설정
var masterColumnLayout = [ 
	{
		   dataField : "fBankJrnlRefNo",
		   headerText : "Reference No",
		   editable : false
	},
    {
        dataField : "accDesc",
        headerText : "Account",
        editable : false
    }, 
    {
        dataField : "name",
        headerText : "Status",
        editable : false
    }, {
        dataField : "fBankJrnlRem",
        headerText : "Remark",
        editable : false
    }, {
        dataField : "crtDt",
        headerText : "Created",
        editable : false
    }, {
        dataField : "userName",
        headerText : "Creator",
        editable : false
    },{
        dataField : "fBankJrnlId",
        headerText : "",
        visible : false
    }];

var statementdetailPopLayout = [ 
	{
	    dataField : "fTrnscDt",
	    headerText : "Date",
	    editable : false
	}, {
	    dataField : "fTrnscRef1",
	    headerText : "Ref 1",
	    editable : false
	}, {
	    dataField : "fTrnscRef2",
	    headerText : "Ref 2",
	    editable : false
	}, {
	    dataField : "fTrnscRef3",
	    headerText : "Ref 3",
	    editable : false
	}, {
	    dataField : "fTrnscRef4",
	    headerText : "Ref 4",
	    editable : false
	}, {
	    dataField : "fTrnscRef5",
	    headerText : "Ref 5",
	    editable : false
	}, {
	    dataField : "fTrnscRef6",
	    headerText : "Ref 6",
	    editable : false
	}, {
	    dataField : "fTrnscRem",
	    headerText : "Mode",
	    editable : false
	}, {
	    dataField : "fTrnscRefRunngNo",
	    headerText : "Running",
	    editable : false
	},{
	    dataField : "fTrnscRefEft",
	    headerText : "EFT",
	    editable : false
	},{
	    dataField : "fTrnscRefChqNo",
	    headerText : "Chq No",
	    editable : false
	},{
	    dataField : "fTrnscRefVaNo",
	    headerText : "VA No",
	    editable : false
	},{
        dataField : "fTrnscDebtAmt",
        headerText : "Debit",
        editable : false
    },{
        dataField : "fTrnscCrditAmt",
        headerText : "Credit",
        editable : false
    },{
        dataField : "isMatch",
        headerText : "Match",
        editable : false
    }];

var journalPopLayout = [ 
	{
	    dataField : "fTrnscDt",
	    headerText : "Date"
	}, {
	    dataField : "fTrnscRef1",
	    headerText : "Ref 1"
	}, {
	    dataField : "fTrnscRef2",
	    headerText : "Ref 2"
	}, {
	    dataField : "fTrnscRef3",
	    headerText : "Ref 3"
	}, {
	    dataField : "fTrnscRef4",
	    headerText : "Ref 4"
	}, {
	    dataField : "fTrnscRef5",
	    headerText : "Ref 5"
	}, {
	    dataField : "fTrnscRef6",
	    headerText : "Ref 6"
	}, {
	    dataField : "fTrnscRem",
	    headerText : "Mode"
	}, {
	    dataField : "fTrnscDebtAmt",
	    headerText : "Debit"
	},{
	    dataField : "fTrnscCrditAmt",
	    headerText : "Credit"
	},{
	    dataField : "isMatch",
	    headerText : "Match"
	},{
	    dataField : "remark",
	    headerText : "Remark",
	    editable : true
	},{
	    dataField : "journalAccount",
	    headerText : "Account",
	    labelFunction : function(  rowIndex, columnIndex, value, headerText, item ) { 
            var retStr = "";
            for(var i=0,len=keyValueList.length; i<len; i++) {
                if(keyValueList[i]["code"] == value) {
                    retStr = keyValueList[i]["value"];
                    break;
                }
            }
            return retStr;
        },
        renderer : {
            type : "DropDownListRenderer",
            list : keyValueList, //key-value Object 로 구성된 리스트
            keyField : "code", // key 에 해당되는 필드명
            valueField : "value" // value 에 해당되는 필드명
        }
	},{
	    dataField : "fTrnscCrditAmt",
	    headerText : "Journal Entry",
	    renderer : {
            type : "ButtonRenderer",
            labelText : "Pass",
            onclick : function(rowIndex, columnIndex, value, item) {
                //if(item.isMatch == "X"){
                    fn_updateJournalPassEntry(item.journalAccount, item.remark, item.fTrnscCrditAmt, item.fTrnscDebtAmt, item.fTrnscId);
                //}else{
                	
                //}
            }
        }
	},{
	    dataField : "",
	    headerText : "Exclude",
	    renderer : {
            type : "ButtonRenderer",
            labelText : "Exclude",
            onclick : function(rowIndex, columnIndex, value, item) {
            	//if(item.isMatch == "X"){
                	fn_updateJournalExclude(item.remark, item.fTrnscId);
                //}else{
                //}
            }
        }
	},{
        dataField : "fBankJrnlId",
        headerText : "",
        visible : false
    },{
        dataField : "fTrnscId",
        headerText : "",
        visible : false
    }];

    function searchList(){
    	
    	Common.ajax("GET","/payment/selectJournalMasterList.do", $("#searchForm").serialize(), function(result){
    		console.log(result);
    		AUIGrid.setGridData(masterListGridID, result);
    		
    	});
    }
    
    function fn_statementViewPop(){
    	
        var selectedItem = AUIGrid.getSelectedIndex(masterListGridID);
        
        if (selectedItem[0] > -1){
            
            var journalId = AUIGrid.getCellValue(masterListGridID, selectedGridValue, "fBankJrnlId");
    	
            Common.ajax("GET","/payment/selectJournalBasicInfo.do",{"journalId" : journalId}, function(result){
            	console.log(result);
            	
	            $('#statement_popup_wrap').show();
	            
	            $('#statementRefNo').text(result.data.masterView.fBankJrnlRefNo);
	            $('#statementStatus').text(result.data.masterView.name);
	            $('#statementAccount').text(result.data.masterView.accDesc);
	            $('#statementRemark').text(result.data.masterView.fBankJrnlRem);
	            $('#statementCreateBy').text(result.data.masterView.userName);
	            $('#statementCreateAt').text(result.data.masterView.fBankJrnlCrtDt);
	            $('#adjsutment').val(result.data.masterView.fBankJrnlAdj);
	            $('#grossTotal').text(result.data.grossTotal);
                $('#netTotal').text(result.data.grossTotal - result.data.masterView.fBankJrnlAdj);
	            
                AUIGrid.destroy(statementdetailPopGridID);
	    		statementdetailPopGridID = GridCommon.createAUIGrid("statement_pop_grid_wrap", statementdetailPopLayout,null,gridPros);
	            AUIGrid.setGridData(statementdetailPopGridID, result.data.detailList);
            
            });
        }else{
        	Common.alert('No Statement selected.');
        }
    }
    
    function fn_journalEntryPop(){
        
        var selectedItem = AUIGrid.getSelectedIndex(masterListGridID);
        
        if (selectedItem[0] > -1){
            
            var journalId = AUIGrid.getCellValue(masterListGridID, selectedGridValue, "fBankJrnlId");
        
            Common.ajax("GET","/payment/selectJournalBasicInfo.do",{"journalId" : journalId}, function(result){
                console.log(result);
                
                $('#journal_popup_wrap').show();
                
                $('#journalRefNo').text(result.data.masterView.fBankJrnlRefNo);
                $('#journalStatus').text(result.data.masterView.name);
                $('#journalAccount').text(result.data.masterView.accDesc);
                $('#journalRemark').text(result.data.masterView.fBankJrnlRem);
                $('#journalCreateBy').text(result.data.masterView.userName);
                $('#journalCreateAt').text(result.data.masterView.fBankJrnlCrtDt);
                $('#journalAdjsutment').val(result.data.masterView.fBankJrnlAdj);
                $('#journalGrossTotal').text(result.data.grossTotal);
                $('#journalNetTotal').text(result.data.grossTotal - result.data.masterView.fBankJrnlAdj);
                $('#fBankJrnlAccId').val(result.data.masterView.fBankJrnlAccId);
                
                AUIGrid.destroy(journalEntryPopGridID);
                journalEntryPopGridID = GridCommon.createAUIGrid("journal_pop_grid_wrap", journalPopLayout,null,gridPros);
                AUIGrid.setGridData(journalEntryPopGridID, result.data.detailList);
            
            });
        }else{
            Common.alert('No Statement selected.');
        }
    }
    
    function fn_updateJournalPassEntry(journalAccount, remark,  fTrnscCrditAmt, fTrnscDebtAmt, fTrnscId){
    	
    	//if(remark != ""){
    		
    		if(journalAccount != undefined){
    			
    			$('#journalEntryAccount').val(journalAccount);
                $('#remark').val(remark);
                $('#fTrnscCrditAmt').val(fTrnscCrditAmt);
                $('#fTrnscDebtAmt').val(fTrnscDebtAmt);
                $('#fTrnscId').val(fTrnscId);
                $('#lblRefNo').val($('#journalRefNo').text());
                
                Common.ajax("GET","/payment/updJournalPassEntry.do", $("#journalPassForm").serialize(), function(result){
                    Common.alert(result.message);
                });
    			
    		}else{
    			Common.alert('* Debtor Account are composulary field .');
    		}
    		
    	//}else{
    		//Common.alert('* Remark are composulary field .');
    	//}
    	
    }
    
    
    function fn_updateJournalExclude(remark, fTrnscId){
        
        //if(remark != ""){
        	
        	Common.ajax("GET","/payment/updJournalExclude.do", {"remark" : remark, "fTrnscId" : fTrnscId }, function(result){
                    Common.alert(result.message);
            });
            
        //}else{
            //Common.alert('* Remark are composulary field .');
        //}
        
    }
    
    function fn_viewPayPopClose(val){
        //$(val).hide();
        //AUIGrid.clearGridData(reviewPopGridID);  //grid data clear
        //AUIGrid.clearGridData(watingPopGridID);  //grid data clear
    }
   
</script>
<!-- content start -->
<section id="content"><!-- content start -->
	<ul class="path">
	    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
	    <li>reconciliation</li>
	    <li>Bank Account Reconciliation</li>
	</ul>
	<aside class="title_line"><!-- title_line start -->
	<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
	<h2>Bank Account Reconciliation</h2>
	<ul class="right_btns">
	    <li><p class="btn_blue"><a href="javascript:searchList();"><span class="search"></span>Search</a></p></li>
	    <li><p class="btn_blue"><a href="#"><span class="clear"></span>Clear</a></p></li>
	</ul>
	</aside><!-- title_line end -->
	<section class="search_table"><!-- search_table start -->
		<form action="#" method="post" id="searchForm" name="searchForm">
			<table class="type1"><!-- table start -->
				<caption>table</caption>
				<colgroup>
				    <col style="width:150px" />
				    <col style="width:*" />
				    <col style="width:150px" />
				    <col style="width:*" />
				</colgroup>
				<tbody>
					<tr>
					    <th scope="row">Reference No</th>
					    <td>
					    <input type="text" title="" placeholder="Reference No" class="" name="refNo"/>
					    </td>
					    <th scope="row">Status</th>
					    <td>
					    <select class="multy_select" multiple="multiple" id="statusId" name="statusId">
					       <option value="1">Active</option>
					       <option value="36">Closed</option>
					    </select>
					    </td>
					</tr>
					<tr>
					    <th scope="row">Bank Account</th>
					    <td>
					    <select id="accountId" name="accountId">
					    </select>
					    </td>
					    <th scope="row">Remark</th>
					    <td>
					    <input type="text" title="" placeholder="Remark" class="" id="remark" name="remark"/>
					    </td>
					</tr>
					<tr>
					    <th scope="row">Uploaded By</th>
					    <td>
					    <input type="text" title="" placeholder="Uploaded By" class="" id="uploadBy" name="uploadBy"/>
					    </td>
					    <th scope="row">Uploaded Date</th>
					    <td>
					    <div class="date_set"><!-- date_set start -->
					    <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" name="fromUploadDate"/></p>
					    <span>To</span>
					    <p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" name="toUploadDate"/></p>
					    </div><!-- date_set end -->
					    </td>
					</tr>
			</tbody>
			</table><!-- table end -->
			<aside class="link_btns_wrap"><!-- link_btns_wrap start -->
				<p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
				<dl class="link_list">
				    <dt>Link</dt>
				    <dd>
				    <ul class="btns">
				        <li><p class="link_btn"><a href="/payment/initBankAccountReconciliation.do">Bank Account Reconciliation Report</a></p></li>
				        <li><p class="link_btn"><a href="/payment/initBranchesCollectionSummary.do">Branches Collection Summary Report</a></p></li>
				        <li><p class="link_btn"><a href="/payment/initReconciliationStatistic.do">Reconciliation Statistic Report</a></p></li>
				    </ul>
				    <ul class="btns">
				        <li><p class="link_btn type2"><a href="javascript:fn_statementViewPop();">Statement View</a></p></li>
				        <li><p class="link_btn type2"><a href="javascript:fn_journalEntryPop();">Journal Entry</a></p></li>
				    </ul>
				    <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
				    </dd>
				</dl>
			</aside><!-- link_btns_wrap end -->
		</form>
	</section><!-- search_table end -->
	
	<section class="search_result"><!-- search_result start -->
		<article class="grid_wrap" id="master_grid_wrap"><!-- grid_wrap start -->
		</article><!-- grid_wrap end -->
	</section><!-- search_result end -->
</section><!-- content end -->

<div id="statement_popup_wrap" class="popup_wrap" style="display:none;"><!-- popup_wrap start -->
	<header class="pop_header"><!-- pop_header start -->
		<h1>Reconciliation Task</h1>
		<ul class="right_opt">
		  <li><p class="btn_blue2"><a href="#" onclick="fn_hideViewPop('#view_popup_wrap');">CLOSE</a></p></li>
		</ul>
	</header><!-- pop_header end -->
	<section class="pop_body"><!-- pop_body start -->
		<form action="#" method="post">
			<aside class="title_line"><!-- title_line start -->
			 <h3>Bank Statement Information</h3>
			</aside><!-- title_line end -->
			<table class="type1"><!-- table start -->
				<caption>table</caption>
				<colgroup>
				    <col style="width:130px" />
				    <col style="width:*" />
				    <col style="width:110px" />
				    <col style="width:*" />
				</colgroup>
				<tbody>
					<tr>
					    <th scope="row">Reference No</th>
					    <td id="statementRefNo">
					    </td>
					    <th scope="row">Status</th>
					    <td id="statementStatus">
					    </td>
					</tr>
					<tr>
					    <th scope="row">Account</th>
					    <td id="statementAccount">
					    </td>
					    <th scope="row">Remark</th>
					    <td id="statementRemark">
					    </td>
					</tr>
					<tr>
					    <th scope="row">Create By</th>
					    <td id="statementCreateBy">
					    </td>
					    <th scope="row">Create At</th>
					    <td id="statementCreateAt">
					    </td>
					</tr>
				</tbody>
			</table><!-- table end -->
			<aside class="title_line"><!-- title_line start -->
			 <h3>Bank Statement Adjustment</h3>
			</aside><!-- title_line end -->
			<table class="type1"><!-- table start -->
				<caption>table</caption>
				<colgroup>
				    <col style="width:150px" />
				    <col style="width:*" />
				    <col style="width:150px" />
				    <col style="width:*" />
				    <col style="width:150px" />
				    <col style="width:*" />
				</colgroup>
				<tbody>
					<tr>
					    <th scope="row">Gross Total(RM)</th>
					    <td id="grossTotal">
					    </td>
					    <th scope="row">Adjustment(RM)</th>
					    <td>
					    <input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="adjsutment" />
					    </td>
					    <th scope="row">Net Total(RM)</th>
					    <td id="netTotal">
					    </td>
					</tr>
				</tbody>
			</table><!-- table end -->
			<aside class="title_line"><!-- title_line start -->
			     <h3>Transaction In Statement</h3>
			</aside><!-- title_line end -->
			<article class="grid_wrap" id="statement_pop_grid_wrap"><!-- grid_wrap start -->
			</article><!-- grid_wrap end -->
	</form>
	</section><!-- search_table end -->
</div><!-- content end -->

<div id="journal_popup_wrap" class="popup_wrap" style="display:none;"><!-- popup_wrap start -->
    <header class="pop_header"><!-- pop_header start -->
        <h1>Journal Entry</h1>
        <ul class="right_opt">
          <li><p class="btn_blue2"><a href="#" onclick="fn_hideViewPop('#view_popup_wrap');">CLOSE</a></p></li>
        </ul>
    </header><!-- pop_header end -->
    <section class="pop_body"><!-- pop_body start -->
        <form action="#" method="post">
            <aside class="title_line"><!-- title_line start -->
             <h3>Bank Statement Information</h3>
            </aside><!-- title_line end -->
            <table class="type1"><!-- table start -->
                <caption>table</caption>
                <colgroup>
                    <col style="width:130px" />
                    <col style="width:*" />
                    <col style="width:110px" />
                    <col style="width:*" />
                </colgroup>
                <tbody>
                    <tr>
                        <th scope="row">Reference No</th>
                        <td id="journalRefNo">
                        </td>
                        <th scope="row">Status</th>
                        <td id="journalStatus">
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Account</th>
                        <td id="journalAccount">
                        </td>
                        <th scope="row">Remark</th>
                        <td id="journalRemark">
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Create By</th>
                        <td id="journalCreateBy">
                        </td>
                        <th scope="row">Create At</th>
                        <td id="journalCreateAt">
                        </td>
                    </tr>
                </tbody>
            </table><!-- table end -->
            <aside class="title_line"><!-- title_line start -->
             <h3>Bank Statement Adjustment</h3>
            </aside><!-- title_line end -->
            <table class="type1"><!-- table start -->
                <caption>table</caption>
                <colgroup>
                    <col style="width:150px" />
                    <col style="width:*" />
                    <col style="width:150px" />
                    <col style="width:*" />
                    <col style="width:150px" />
                    <col style="width:*" />
                </colgroup>
                <tbody>
                    <tr>
                        <th scope="row">Gross Total(RM)</th>
                        <td id="journalGrossTotal">
                        </td>
                        <th scope="row">Adjustment(RM)</th>
                        <td>
                        <input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="journalAdjsutment" />
                        </td>
                        <th scope="row">Net Total(RM)</th>
                        <td id="journalNetTotal">
                        </td>
                    </tr>
                </tbody>
            </table><!-- table end -->
            <aside class="title_line"><!-- title_line start -->
                 <h3>Transaction In Statement</h3>
            </aside><!-- title_line end -->
            <article class="grid_wrap" id="journal_pop_grid_wrap"><!-- grid_wrap start -->
            </article><!-- grid_wrap end -->
    </form>
    </section><!-- search_table end -->
    <form action="#" method="post" id="journalPassForm" name="journalPassForm">
        <input type="hidden" name="journalEntryAccount" id="journalAccount">
        <input type="hidden" name="remark" id="remark">
        <input type="hidden" name="fTrnscCrditAmt" id="fTrnscCrditAmt">
        <input type="hidden" name="fTrnscDebtAmt" id="fTrnscDebtAmt">
        <input type="hidden" name="fTrnscId" id="fTrnscId">
        <input type="hidden" name="fBankJrnlAccId" id="fBankJrnlAccId">
        <input type="hidden" name="lblRefNo" id="lblRefNo">
    </form>
</div><!-- content end -->
