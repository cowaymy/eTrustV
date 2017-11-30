<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>

<style type="text/css">
.my-custom-up{
    text-align: left;
}
</style>
<script type="text/javaScript">
var mappingGridId;
var crcKeyInGridId;
var crcStateGridId;
var selectedGridValue;

var gridPros = {
        // 편집 가능 여부 (기본값 : false)
        editable : false,
        
        // 상태 칼럼 사용
        showStateColumn : false
};

var gridPros2 = {
        // 편집 가능 여부 (기본값 : false)
        editable : false,
        
        // 체크박스 표시 설정
        showRowCheckColumn : true,
        
        // 체크박스 대신 라디오버튼 출력함
        rowCheckToRadio : true,
        
        softRemoveRowMode:false,

        
};

function test(rowIndex){
	
	
	var checkedItems = AUIGrid.getCheckedRowItemsAll(crcKeyInGridId);
	alert(checkedItems.length);
	if(checkedItems.length > 1){
		AUIGrid.addUncheckedRowsByIds(crcKeyInGridId, checkedItems[rowIndex].rnum);
	}
	
}
$(document).ready(function(){
	
	doGetCombo('/common/getAccountList.do', 'CRC' , ''   , 'bankAcc' , 'S', '');    
	
	mappingGridId = GridCommon.createAUIGrid("mapping_grid_wrap", mappingLayout,"",gridPros);
	crcKeyInGridId = GridCommon.createAUIGrid("crcKeyIn_grid_wrap", crcKeyInLayout,"",gridPros2);
	crcStateGridId = GridCommon.createAUIGrid("crcState_grid_wrap", crcStateLayout,"",gridPros2);
	
});


var mappingLayout = [ 
                       {
                           dataField : "crditCard",
                           headerText : "Credit Card",
                           editable : false
                       }, {
                           dataField : "crcMcName",
                           headerText : "Bank Account",
                           editable : false
                       }, {
                           dataField : "crcTrnscDt",
                           headerText : "Transaction Date",
                           editable : false,
                           dataType : "date", 
                           formatString : "yyyy-mm-dd"
                       },{
                           dataField : "crcTrnscNo",
                           headerText : "Card No",
                           editable : false
                       }, {
                           dataField : "cardModeName",
                           headerText : "Card Mode",
                           editable : false
                       }, {
                           dataField : "crcTrnscAppv",
                           headerText : "Approval No",
                           editable : false
                       }, {
                           dataField : "amount",
                           headerText : "Amount",
                           editable : false,
                           dataType:"numeric", 
                           formatString:"#,##0.00"
                       },{
                           dataField : "groupSeq",
                           headerText : "groupSeq",
                           visible : false
                       },{
                           dataField : "crcTrnscId",
                           headerText : "crcTrnscId",
                           visible : false
                       }];

var crcKeyInLayout = [ 
                       {
                           dataField : "crcMcName",
                           headerText : "M/C Bank",
                           editable : false
                       }, {
                           dataField : "payItmRefDt",
                           headerText : "TR Date",
                           editable : false,
                           dataType : "date", 
                           formatString : "yyyy-mm-dd"
                       }, {
                           dataField : "payItmCcNo",
                           headerText : "Card No",
                           editable : false,
                       }, {
                           dataField : "cardModeName",
                           headerText : "Card Mode",
                           editable : false,
                       }, {
                           dataField : "payItmAppvNo",
                           headerText : "Approval No",
                           editable : false
                       }, {
                           dataField : "amount",
                           headerText : "Amount",
                           editable : false,
                           dataType:"numeric", 
                           formatString:"#,##0.00"
                       },{
                           dataField : "groupSeq",
                           headerText : "groupSeq",
                           visible : false
                       },{
                           dataField : "rnum",
                           headerText : "rnum",
                           visible : false
                       }];

var crcStateLayout = [ 
                      {
                          dataField : "bankAccName",
                          headerText : "Bank Account",
                          editable : false
                      }, {
                          dataField : "crcTrnscDt",
                          headerText : "TR Date",
                          editable : false,
                          dataType : "date", 
                          formatString : "yyyy-mm-dd"
                      }, {
                          dataField : "crcTrnscNo",
                          headerText : "Card No",
                          editable : false
                      }, {
                          dataField : "crcTrnscAppv",
                          headerText : "Approval No",
                          editable : false
                      }, {
                          dataField : "grosAmt",
                          headerText : "Gross Amount",
                          editable : false,
                          dataType:"numeric", 
                          formatString:"#,##0.00"
                      }, {
                          dataField : "crcTrnscId",
                          headerText : "crcTrnscId",
                          visible : false
                      }];

	
	function fn_getCrcReconStateList(ordNo, ordId){
	
	    Common.ajax("GET","/payment/selectCrcReconCRCStateInfo.do", $("#searchForm").serialize(), function(result){
	        console.log(result);

	        AUIGrid.setGridData(mappingGridId, result.mappingList);
	        AUIGrid.setGridData(crcKeyInGridId, result.keyInList);
	        AUIGrid.setGridData(crcStateGridId, result.stateList);
	        
	    });
	}
	
	function fn_clear(){
	    $("#searchForm")[0].reset();
	}
	
    function fn_mappingProc() {

    	var crcKeyInChkItem = AUIGrid.getCheckedRowItems(crcKeyInGridId);
    	var crcStateChkItem = AUIGrid.getCheckedRowItems(crcStateGridId);
    	var crcKeyInVal;
    	var keyInRowItem;
    	var stateRowItem;
    	var item = new Object();
    	
    	if(crcKeyInChkItem.length > 0 ){
    		keyInRowItem = crcKeyInChkItem[0];
            stateRowItem = crcStateChkItem[0];
            
            if(crcStateChkItem.length > 0){
                
                crcKeyInVal = keyInRowItem.item.groupSeq;
                item.crcMcName = stateRowItem.item.bankAccName;
                item.crcTrnscDt = stateRowItem.item.crcTrnscDt;
                item.crcTrnscNo = stateRowItem.item.crcTrnscNo;
                item.crcTrnscAppv = stateRowItem.item.crcTrnscAppv;
                item.amount = stateRowItem.item.grosAmt;
                item.groupSeq = crcKeyInVal;//hidden key
                item.crcTrnscId = stateRowItem.item.crcTrnscId;//hidden key    
                    
                console.log(item);
                AUIGrid.addRow(mappingGridId, item, "last");
                AUIGrid.removeCheckedRows(crcKeyInGridId);
                AUIGrid.removeCheckedRows(crcStateGridId);
            }else{
                Common.alert("Please select CRC Statement Data");
            }
            
    	}else{
    		Common.alert("Please select CRC KeyIn Data");
    	}
        
    }
    
    function fn_mappingListKnockOff() {
        
        var gridList = AUIGrid.getGridData(mappingGridId);
        var data = {};
        if(gridList.length > 0) {
            data.all = gridList;
            Common.ajax("POST","/payment/updCrcReconState.do", data , function(result){
                console.log(result);
                
                AUIGrid.clearGridData(mappingGridId);
                Common.alert(result.message);
            });
            
        }else{
        	Common.alert("No Mapping Data");
        }
    }
	
</script>
<body>
    <div id="wrap"><!-- wrap start -->
        <section id="content"><!-- content start -->
                <ul class="path">
                    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
                    <li>Card Payment</li>
                    <li>Payment Key-In & Credit Card Statement</li>
                </ul>
                <aside class="title_line"><!-- title_line start -->
                    <p class="fav"><a href="#" class="click_add_on">My menu</a></p>
                    <h2>Payment Key-In & Credit Card Statement</h2>
                    <ul class="right_btns">
                        <li><p class="btn_blue"><a href="javascript:fn_getCrcReconStateList();"><span class="search"></span>Search</a></p></li>
                        <li><p class="btn_blue"><a href="javascript:fn_clear();"><span class="clear"></span>Clear</a></p></li>
                    </ul>
                </aside><!-- title_line end -->
                <section class="search_table"><!-- search_table start -->
                    <form action="#" method="post" id="searchForm">
	                    <table class="type1"><!-- table start -->
	                        <caption>table</caption>
	                        <colgroup>
	                            <col style="width:200px" />
	                            <col style="width:*" />
	                            <col style="width:200px" />
	                            <col style="width:*" />
	                        </colgroup>
	                        <tbody>
	                            <tr>
	                               <th>Transaction Date</th>
	                               <td>
	                                    <!-- date_set start -->
	                                    <div class="date_set w100p">
	                                        <p><input type="text" id="transDateFr" name="transDateFr" title="Transaction Start Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
	                                        <span>To</span>
	                                        <p><input type="text" id="transDateTo" name="transDateTo" title="Transaction End Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
	                                    </div>
	                                    <!-- date_set end -->
	                               </td>
	                               <th>Bank Account</th>
	                               <td>
	                                    <select id="bankAcc" name="bankAcc" class="w100p" ></select>
	                               </td>
	                             </tr>
	                        </tbody>
	                        </table><!-- table end -->
	                        <article id="mapping_grid_wrap" class="grid_wrap"></article>
                        </form>
                    </section><!-- search_table end -->
                    <div class="divine_auto"><!-- divine_auto start -->
                        <div style="width:50%;">
                            <aside class="title_line"><!-- title_line start -->
                            <h3>Credit Card Key-in List</h3>
                            </aside><!-- title_line end -->
                            
                            <div class="border_box" style="height:350px;"><!-- border_box start -->
                                <article id="crcKeyIn_grid_wrap" class="grid_wrap"></article>
                                <!-- <ul class="left_btns">
                                    <li><p class="btn_blue2"><a href="#" id="btnAddToBillTarget">Add to Billing Target</a></p></li>
                                </ul> -->
                            </div><!-- border_box end -->
                        </div>
                        <div style="width:50%;">
                            <aside class="title_line"><!-- title_line start -->
                              <h3>Credit Card Statement</h3>
                            </aside><!-- title_line end -->
                            <div class="border_box" style="height:350px;"><!-- border_box start -->
                                <article id="crcState_grid_wrap" class="grid_wrap"></article>
                                <ul class="right_btns">
                                    <li><p class="btn_blue2"><a href="javascript:fn_mappingProc();" id="btnMapping">Mapping</a></p></li>
                                    <li><p class="btn_blue2"><a href="javascript:fn_mappingListKnockOff();" id="btnKnockOff">Knock-Off</a></p></li>
                                </ul>
                                <!-- <ul class="left_btns">
                                    <li><p class="btn_blue2"><a href="javascript:void(0);" id="btnRemoveBillTarget">Remove From Billing Target</a></p></li>
                                    <li><p class="btn_blue2"><a href="javascript:void(0);" id="createBills">Create Bills</a></p></li>
                                </ul> -->
                            </div><!-- border_box end -->
                        </div>
                    </div><!-- divine_auto end -->
            </section><!-- content end -->
            <hr />
    </div><!-- wrap end -->
        <%-- <div id="createBillsPop" class="popup_wrap" style="display:none;"><!-- popup_wrap start -->
            <header class="pop_header"><!-- pop_header start -->
                <h1>Advance Bill Remark</h1>
                <ul class="right_opt">
                    <li><p class="btn_blue2"><a href="" onclick="fn_createBillsPopClose();">CLOSE</a></p></li>
                </ul>
            </header><!-- pop_header end -->
            <section class="pop_body"><!-- pop_body start -->
                <table class="type1"><!-- table start -->
                    <caption>table</caption>
                    <colgroup>
                        <col style="width:140px" />
                        <col style="width:*" />
                        <col style="width:180px" />
                        <col style="width:*" />
                    </colgroup>
                    <tbody>
                        <tr>
                            <th scope="row">Remark</th>
                            <td colspan="3">
                                <textarea cols="20" rows="5" placeholder="" id="remark"></textarea>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">Invoice Remark</th>
                            <td colspan="3">
                                <textarea cols="20" rows="5" placeholder="" id="invoiceRemark">
                                </textarea>
                            </td>
                        </tr>
                    </tbody>
                </table><!-- table end -->
                <ul class="center_btns">
                    <li><p class="btn_blue2 big"><a href="javascript:void(0);" id="btnSave" onclick="">SAVE</a></p></li>
                </ul>
            </section><!-- pop_body end -->
        </div><!-- popup_wrap end --> --%>
</body>