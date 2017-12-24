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
        // 상태 칼럼 사용
        showStateColumn : false
        
};

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
                           editable : false
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
                       },{
                           dataField : "crcStateAccId",
                           headerText : "crcStateAccId",
                           visible : false
                       },{
                           dataField : "orNo",
                           headerText : "orNo",
                           visible : false
                       },{
                           dataField : "ordNo",
                           headerText : "ordNo",
                           visible : false
                       },{
                           dataField : "crcTrnscMid",
                           headerText : "crcTrnscMid",
                           visible : false
                       }, {
                           dataField : "codeId",
                           headerText : "codeId",
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
                           formatString : "dd/mm/yyyy"
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
                       },{
                           dataField : "orNo",
                           headerText : "orNo",
                           visible : false
                       },{
                           dataField : "ordNo",
                           headerText : "ordNo",
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
                          editable : false
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
                      }, {
                          dataField : "crcStateAccId",
                          headerText : "crcStateAccId",
                          visible : false
                      }, {
                          dataField : "crcTrnscMid",
                          headerText : "crcTrnscMid",
                          visible : false
                      }, {
                          dataField : "codeId",
                          headerText : "codeId",
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
                item.crcTrnscNo = stateRowItem.item.crcTrnscNo; // crcNo no check?
                item.crcTrnscAppv = stateRowItem.item.crcTrnscAppv;
                item.amount = stateRowItem.item.grosAmt;
                item.groupSeq = crcKeyInVal;//hidden field
                item.orNo = keyInRowItem.item.orNo;//hidden field
                item.ordNo = keyInRowItem.item.ordNo;//hidden field
                item.crcTrnscId = stateRowItem.item.crcTrnscId;//hidden field
                item.crcStateAccId = stateRowItem.item.crcStateAccId;//hidden field
                item.crcTrnscMid = stateRowItem.item.crcTrnscMid;//hidden field
                item.codeId = stateRowItem.item.codeId;//hidden field
                
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
            
            Common.confirm('<b>Are you sure you want to match this Payment & CRC items?</b>',function (){
            	
            	Common.ajax("POST","/payment/updCrcReconState.do", data , function(result){
                    console.log(result);
                    
                    AUIGrid.clearGridData(mappingGridId);
                    Common.alert(result.message);
                });
            	
            });
            
        }else{
        	Common.alert("No Mapping Data");
        }
    }
	
</script>
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
        </form> 
    </section><!-- search_table end -->
    
    <!-- search_result start -->
    <section class="search_result">
        <!-- grid_wrap start -->
            <article id="mapping_grid_wrap" class="grid_wrap"></article>
        <!-- grid_wrap end -->
    </section>
    <!-- search_result end -->


    <div class="divine_auto"><!-- divine_auto start -->
        <div style="width:50%;">
            <aside class="title_line"><!-- title_line start -->
                <h3>Credit Card Key-in List</h3>
            </aside><!-- title_line end -->
            <article id="crcKeyIn_grid_wrap" class="grid_wrap"></article>
        </div><!-- border_box end -->
        <div style="width:50%;">
            <aside class="title_line"><!-- title_line start -->
                <h3>Credit Card Statement</h3>
            </aside><!-- title_line end -->
            <article id="crcState_grid_wrap" class="grid_wrap"></article>
        </div>
    </div>

    
    <ul class="right_btns">
        <li><p class="btn_blue2"><a href="javascript:fn_mappingProc();" id="btnMapping">Mapping</a></p></li>
        <li><p class="btn_blue2"><a href="javascript:fn_mappingListKnockOff();" id="btnKnockOff">Knock-Off</a></p></li>
    </ul>
</section><!-- content end -->
    