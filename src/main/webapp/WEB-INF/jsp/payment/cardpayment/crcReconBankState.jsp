<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<script type="text/javaScript">
    //AUIGrid 그리드 객체
    var mappedGridID;
    var crcStatementGridID;
    var bankStatementGridID;
    
    //Grid Properties 설정
    var gridPros = {
            // 편집 가능 여부 (기본값 : false)
            editable : false,        
            // 상태 칼럼 사용
            showStateColumn : false,
            // 기본 헤더 높이 지정
            headerHeight : 45,

            softRemoveRowMode:false
    };
    
  //Grid Properties 설정
    var gridPros2 = {
    		// 편집 가능 여부 (기본값 : false)
            editable : false,
            // 상태 칼럼 사용
            showStateColumn : false,
            // 기본 헤더 높이 지정
            headerHeight : 45,
            //체크박스컬럼
            showRowCheckColumn : true,
            showRowAllCheckBox : false,
            rowCheckToRadio : true
    }
    
    // AUIGrid 칼럼 설정
    var columnMappedLayout = [ 
        {dataField : "codeId", headerText : "<spring:message code='pay.head.codeId'/>", editable : false, visible:false}, 
		{dataField : "crcStateId", headerText : "<spring:message code='pay.head.crcId'/>", editable : false, visible:false}, 
        {dataField : "fTrnscDt",headerText : "<spring:message code='pay.head.transactionDate'/>",width : 240 , editable : false},
        {dataField : "crcTrnscMid",headerText : "<spring:message code='pay.head.midNo'/>",width : 200, editable : false},
        //{dataField : "bnkAcc",headerText : "<spring:message code='pay.head.bankAccount'/>",width : 100 , editable : false},  
        {dataField : "netAmt",headerText : "<spring:message code='pay.head.crcNetAmount'/>",width : 180 , editable : false, dataType:"numeric", formatString:"#,##0.00"},        
        
        {dataField : "fTrnscId",headerText : "<spring:message code='pay.head.bankStatementId'/>",width : 200 , editable : false},        
        {dataField : "debtAmt",headerText : "Debit <br>Amount",width : 180 , editable : false, dataType:"numeric", formatString:"#,##0.00"}, 
        
        {dataField : "creditAmt",headerText : "<spring:message code='pay.head.creditAmount'/>",width : 180 , editable : false, dataType:"numeric", formatString:"#,##0.00"},
        {dataField : "mappingDate",headerText : "<spring:message code='pay.head.mappingDate'/>",width : 240 , editable : false},
        
        {dataField : "variance",headerText : "Variance",width : 150 , editable : false ,dataType:"numeric", formatString:"#,##0.00"},
        {dataField : "accountCode",headerText : "AccountCode",width : 150 , editable : false},
        {dataField : "remark",headerText : "Remark",width : 150 , editable : false},
        {dataField : "isAmtSame",headerText : "isAmtSame",width : 150 , editable : false ,visible:false}
        
        
   ];
    
    var columnUnMappedCrcLayout = [
        {dataField : "crcStateId", headerText : "<spring:message code='pay.head.id'/>", editable : false, visible:false}, 
        {dataField : "crcTrnscDt", headerText : "<spring:message code='pay.head.transactionDate'/>", editable : false},    
        {dataField : "crcTrnscMid", headerText : "<spring:message code='pay.head.midNo'/>", editable : false},    
        {dataField : "accDesc", headerText : "<spring:message code='pay.head.bankAccount'/>", editable : false},   
        {dataField : "netAmt", headerText : "<spring:message code='pay.head.totalNetAmount'/>", editable : false, dataType:"numeric", formatString:"#,##0.00"}
        /*{
            dataField : "btnCheck",
            headerText : "CH.",
            width: 80,
            renderer : { 
                type : "CheckBoxEditRenderer",            
                editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
                checkValue : "1", // true, false 인 경우가 기본
                unCheckValue : "0"            
            }
        }*/
    ];
    
    var columnUnMappedBankLayout = [
         {dataField : "codeId", headerText : "<spring:message code='pay.head.codeId'/>", editable : false, visible:false},                  
         {dataField : "fTrnscId", headerText : "<spring:message code='pay.head.id'/>", editable : false, visible:false},                             
         {dataField : "fTrnscDt", headerText : "<spring:message code='pay.head.transactionDate'/>", editable : false},    
         {dataField : "mid", headerText : "<spring:message code='pay.head.midNo'/>", editable : false},    
         {dataField : "accDesc", headerText : "<spring:message code='pay.head.bankAccount'/>", editable : false},   
         {dataField : "debtAmt", headerText :  "Debit Amount", editable : false, dataType:"numeric", formatString:"#,##0.00"},
         {dataField : "creditAmt", headerText : "<spring:message code='pay.head.totalNetAmount'/>", editable : false, dataType:"numeric", formatString:"#,##0.00"}
         /*{
             dataField : "btnCheck",
             headerText : "CH.",
             width: 80,
             renderer : {
                 type : "CheckBoxEditRenderer",            
                 editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
                 checkValue : "1", // true, false 인 경우가 기본
                 unCheckValue : "0",
                 checkableFunction :  function(rowIndex, columnIndex, value, isChecked, item, dataField ) {
                	 AUIGrid.updateAllToValue(bankStatementGridID, "btnCheck", "0");
                	 //alert(isChecked);
                	 return true;
                 }
             }
         }*/
    ];

    $(document).ready(function(){
    	mappedGridID = GridCommon.createAUIGrid("grid_wrap_mapped_list", columnMappedLayout, null, gridPros);
    	crcStatementGridID = GridCommon.createAUIGrid("grid_wrap_crc_statement", columnUnMappedCrcLayout, null, gridPros2);
    	bankStatementGridID = GridCommon.createAUIGrid("grid_wrap_bank_statement", columnUnMappedBankLayout, null, gridPros2);
    	
    	doGetCombo('/common/getBankAccountList.do', '', '', 'bankAccount', 'S', '');
    	doGetCombo('/common/selectCodeList.do', '393' , ''   , 'accCode' , 'S', '');
    	
    });
    
    function fn_searchList(){
    	 Common.ajax("GET","/payment/selectCrcBnkMappingList.do", $("#searchForm").serialize(), function(result){
    		 AUIGrid.setGridData(mappedGridID, result.mappingList);
    		 AUIGrid.setGridData(crcStatementGridID, result.crcUnMappingList);
    		 
    		 console.log(result.crcUnMappingList);
    		 AUIGrid.setGridData(bankStatementGridID, result.bankUnMappingList);
    	 });
    }
    
    
    var item ; 
    
    function fn_mapping(){
        
    	var crcCheckedItem    = AUIGrid.getCheckedRowItems(crcStatementGridID);
    	
		//var bankCheckedItem  = AUIGrid.getCheckedRowItems(crcStatementGridID);  editing by hgham 20180130
        var bankCheckedItem  = AUIGrid.getCheckedRowItems(bankStatementGridID);
		
		
        item = new Object();
    	var curDate = new Date();
    	
    	
		item.crcStateId = AUIGrid.getCellValue(crcStatementGridID, crcCheckedItem[0].rowIndex , "crcStateId");
		item.fTrnscId = AUIGrid.getCellValue(bankStatementGridID, bankCheckedItem[0].rowIndex, "fTrnscId");
		
		item.fTrnscDt = AUIGrid.getCellValue(bankStatementGridID, bankCheckedItem[0].rowIndex, "fTrnscDt");
		item.crcTrnscMid = AUIGrid.getCellValue(bankStatementGridID, bankCheckedItem[0].rowIndex, "mid");
		
		item.netAmt = AUIGrid.getCellValue(crcStatementGridID, crcCheckedItem[0].rowIndex, "netAmt");
		item.creditAmt = AUIGrid.getCellValue(bankStatementGridID, bankCheckedItem[0].rowIndex, "creditAmt");
		
	    item.debtAmt = AUIGrid.getCellValue(bankStatementGridID, bankCheckedItem[0].rowIndex, "debtAmt");
		item.codeId = AUIGrid.getCellValue(bankStatementGridID, bankCheckedItem[0].rowIndex, "codeId");
		
		item.mappingDate = curDate.getDate() + "/" + (curDate.getMonth() +1) +"/" + curDate.getFullYear();
		
		console.log(item);
	
		AUIGrid.removeRow(crcStatementGridID, crcCheckedItem[0].rowIndex);
		AUIGrid.removeRow(bankStatementGridID, bankCheckedItem[0].rowIndex);
		
		AUIGrid.removeSoftRows(crcStatementGridID);
		AUIGrid.removeSoftRows(bankStatementGridID);
		
		
		var  keyInAmount =item.netAmt; 
		var  stmtAmount  =item.creditAmt;
		
		
		if(keyInAmount != stmtAmount){
            Common.alert("<spring:message code='pay.alert.transAmtNotSame'/>",
                function (){
                    
                    $("#journal_entry_wrap").show();                    
                    $("#fTrnscId").val(item.fTrnscId);  
                    $("#preKeyInAmt").val(keyInAmount);
                    $("#bankStmtAmt").val(stmtAmount);
                    $("#variance").val($.number(keyInAmount-stmtAmount,2,'.',''));
                    $("#accCode").val('');
                    $("#remark").val('');
                    $("#isAmtSame").val('false');
                }
            );
            
        }else{
        	
               
        	item.variance = $("#variance").val();
	        item.accountCode =  $("#accCode").val();
	        item.remark =  $("#remark").val();
	        item.isAmtSame ="true";
	        AUIGrid.addRow(mappedGridID, item, "last");
            
        }
    }
    
    
    
    function fn_saveMapping(){
    	
    	item.variance = $("#variance").val();
        item.accountCode =  $("#accCode").val();
        item.remark =  $("#remark").val();
        item.isAmtSame ="false";
        
        AUIGrid.addRow(mappedGridID, item, "last");
        
        $("#journal_entry_wrap").remove();   
    }
    
    
    
    function fn_knockOff(){
    	Common.confirm("Are you sure you want to match this Payment & CRC items?",fn_updateMappingData);
    }
    
    function fn_updateMappingData(){
    	var data = {};
    	var gridList = AUIGrid.getGridData(mappedGridID);
    	data.all = gridList;
    	
    	if(gridList.length > 0) {
    		
    		Common.ajax("POST", "/payment/updateMappingData.do", data, function(result){
                Common.alert(result.message);
                fn_searchList();
            });
    		
    	}else{
    		Common.alert("<spring:message code='pay.alert.noMapping'/>");
    	}
    }
    
    function fn_clear(){
    	$("#searchForm")[0].reset();
    }
</script>
<!-- content start -->
<section id="content">
    <ul class="path">
        <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    </ul>

    <!-- title_line start -->
    <aside class="title_line">
        <p class="fav"><a href="#" class="click_add_on"><spring:message code='pay.text.myMenu'/></a></p>
        <h2>Payment Matching Reconciliation</h2>
        <ul class="right_btns">           
        
        <c:if test="${PAGE_AUTH.funcView == 'Y'}">
            <li><p class="btn_blue"><a href="javascript:fn_searchList();"><span class="search"></span><spring:message code='sys.btn.search'/></a></p></li>
        </c:if>    
            <li><p class="btn_blue"><a href="javascript:fn_clear();"><span class="clear"></span><spring:message code='sys.btn.clear'/></a></p></li>
        </ul>
    </aside>
    <!-- title_line end -->

    <!-- search_table start -->
    <section class="search_table">
        <!-- search_table start -->
        <form id="searchForm" action="#" method="post">
            <table class="type1">
                <caption>table</caption>
                <colgroup>
                    <col style="width:180px" />
                    <col style="width:*" />
                    <col style="width:180px" />
                    <col style="width:*" />
                </colgroup>
                <tbody>
                    <tr>
                        <th scope="row">Transaction Date(BANK)</th>
                        <td>
                            <!-- date_set start -->
                            <div class="date_set w100p">
                            <p><input type="text" id="tranDateFr" name="tranDateFr" title="BANK Transaction Start Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
                            <span>To</span>
                            <p><input type="text" id="tranDateTo" name="tranDateTo" title="BANK Transaction End Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
                            </div>
                            <!-- date_set end -->
                        </td>
                        <th scope="row">Transaction Date<br>(Credit Card)</th>
                        <td>
                            <!-- date_set start -->
                            <div class="date_set w100p">
                            <p><input type="text" id="tranCrcDateFr" name="tranCrcDateFr" title="CRC Transaction Start Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
                            <span>To</span>
                            <p><input type="text" id="tranCrcDateTo" name="tranCrcDateTo" title="CRC Transaction End Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
                            </div>
                            <!-- date_set end -->
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">BANK Account</th>
                        <td>
                            <select id="bankAccount" name="bankAccount">
                                <!-- <option value="">Choose One</option>
                                <option value="2749">2720/008 - A</option>
                                <option value="2748">2720/007</option>
                                <option value="2747">2720/006</option>
                                <option value="2745">2720/002</option>
                                <option value="2752">2720/015</option>
                                <option value="2751">2720/014</option>
                                <option value="2750">2720/009</option> -->
                            </select>
                        </td>
                        <th></th>
                        <td></td>
                    </tr>
                </tbody>
            </table>
            <!-- table end -->
        </form>
    </section>
    <!-- search_table end -->

    <h2>Mapped List</h2>
    <!-- search_result start -->
    <section class="search_result">
        <!-- grid_wrap start -->
        <article id="grid_wrap_mapped_list" class="grid_wrap"></article>
        <!-- grid_wrap end -->
    </section>
    <!-- search_result end -->
    <h2>Un-Mapped List</h2>
    <div class="divine_auto"><!-- divine_auto start -->
	    <div style="width:50%;">
		    <aside class="title_line"><!-- title_line start -->
		      <h3>Credit Card List</h3>
		    </aside><!-- title_line end -->
		    <article id="grid_wrap_crc_statement" class="grid_wrap"></article>
	    </div>
	    <div style="width:50%;">
	        <aside class="title_line"><!-- title_line start -->
	          <h3>Bank Statement</h3>
	        </aside><!-- title_line end -->
	        <article id="grid_wrap_bank_statement" class="grid_wrap"></article>
	    </div>
    </div><!-- divine_auto end -->
    <ul class="right_btns">
        <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">        
        <li><p class="btn_blue2" id="mapping"><a href="javascript:fn_mapping();"><spring:message code='pay.btn.mapping'/></a></p></li>            
       </c:if>
     <c:if test="${PAGE_AUTH.funcChange == 'Y'}">
        <li><p class="btn_blue2" id="knockOff"><a href="javascript:fn_knockOff();"><spring:message code='pay.btn.knockOff'/></a></p></li>
      </c:if>
    </ul>

</section>



<!--------------------------------------------------------------- 
    POP-UP (JOURNAL ENTRY)
---------------------------------------------------------------->
<!-- popup_wrap start -->
<div class="popup_wrap" id="journal_entry_wrap" style="display:none;">
    <!-- pop_header start -->
    <header class="pop_header" id="pop_header">
        <h1>JOURNAL ENTRY</h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#" onclick="hideViewPopup('#journal_entry_wrap')"><spring:message code='sys.btn.close'/></a></p></li>
        </ul>
    </header>
    <!-- pop_header end -->
    
    <!-- pop_body start -->
    <form name="entryForm" id="entryForm"  method="post">
    
    <div  style='display:none'> 
         <input type="text" id="groupSeq" name="groupSeq" />
         <input type="text" id="fTrnscId" name="fTrnscId" />
         <input type="text" id="isAmtSame" name="isAmtSame" />
         <input type="text" id="accId" name="accId" />
         <input type="text" id="diffType" name="diffType" />
    </div>
    <section class="pop_body">
        <!-- search_table start -->
        <section class="search_table">
            <!-- table start -->
            <table class="type1">
                <caption>table</caption>
                 <colgroup>
                    <col style="width:200px" />
                    <col style="width:*" />                
                </colgroup>
                
                <tbody>
                    <tr>
                        <th scope="row">Pre Key In Amount (A)</th>
                        <td>
                            <input id="preKeyInAmt" name="preKeyInAmt" type="text" class="readonly" readonly />
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Bank Statement Amount (B)</th>
                        <td>
                            <input id="bankStmtAmt" name="bankStmtAmt" type="text" class="readonly" readonly />
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Variance (Variance = A - B)</th>
                        <td>
                            <input id="variance" name="variance" type="text" class="readonly" readonly />
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Account Code</th>
                        <td>
                            <select id="accCode" name="accCode" class="w100p"></select>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Remark</th>
                        <td>
                            <textarea id="remark" name="remark"  cols="10" rows="3" placeholder=""></textarea>
                        </td>
                    </tr>
                   </tbody>  
            </table>
        </section>
        <ul class="center_btns" >
            <li><p class="btn_blue2"><a href="javascript:fn_saveMapping('Y');"><spring:message code='sys.btn.save'/></a></p></li>
        </ul>
    </section>
    </form>       
    <!-- pop_body end -->
</div>
<!-- popup_wrap end -->


<!-- content end -->
