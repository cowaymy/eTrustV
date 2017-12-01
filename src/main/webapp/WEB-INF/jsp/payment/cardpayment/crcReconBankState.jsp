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
        {dataField : "codeId", headerText : "codeId.", editable : false, visible:false}, 
		{dataField : "crcStateId", headerText : "crcId.", editable : false, visible:false}, 
        {dataField : "fTrnscDt",headerText : "Transaction<br>Date",width : 240 , editable : false, dataType:"date",formatString:"dd/mm/yyyy"},
        {dataField : "crcTrnscMid",headerText : "MID No",width : 200, editable : false},
        //{dataField : "bnkAcc",headerText : "Bank<br>Account",width : 100 , editable : false},  
        {dataField : "netAmt",headerText : "CRC Net<br>Amount",width : 180 , editable : false, dataType:"numeric", formatString:"#,##0.00"},        
        {dataField : "fTrnscId",headerText : "Bank<br>Statement<br>ID",width : 200 , editable : false},
        {dataField : "creditAmt",headerText : "Credit<br>Amount",width : 180 , editable : false, dataType:"numeric", formatString:"#,##0.00"},
        {dataField : "mappingDate",headerText : "Mapping<br>Date",width : 240 , editable : false, dataType:"date", formatString:"dd/mm/yyyy"},
   ];
    
    var columnUnMappedCrcLayout = [
        {dataField : "crcStateId", headerText : "id", editable : false, visible:false}, 
        {dataField : "crcTrnscDt", headerText : "Transaction<br>Date", editable : false, dataType:"date",formatString:"dd/mm/yyyy"},    
        {dataField : "crcTrnscMid", headerText : "MID No.", editable : false},    
        {dataField : "accDesc", headerText : "Bank Account", editable : false},   
        {dataField : "netAmt", headerText : "Total Net Amount", editable : false, dataType:"numeric", formatString:"#,##0.00"},
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
         {dataField : "codeId", headerText : "codeId", editable : false, visible:false},                  
         {dataField : "fTrnscId", headerText : "id", editable : false, visible:false},                             
         {dataField : "fTrnscDt", headerText : "Transaction<br>Date", editable : false, dataType:"date",formatString:"dd/mm/yyyy"},    
         {dataField : "mid", headerText : "MID No.", editable : false},    
         {dataField : "accDesc", headerText : "Bank Account", editable : false},   
         {dataField : "creditAmt", headerText : "Total Net Amount", editable : false, dataType:"numeric", formatString:"#,##0.00"}
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
    });
    
    function fn_searchList(){
    	 Common.ajax("GET","/payment/selectCrcBnkMappingList.do", $("#searchForm").serialize(), function(result){
    		 AUIGrid.setGridData(mappedGridID, result.mappingList);
    		 AUIGrid.setGridData(crcStatementGridID, result.crcUnMappingList);
    		 AUIGrid.setGridData(bankStatementGridID, result.bankUnMappingList);
    	 });
    }
    
    function fn_mapping(){
        
    	var crcCheckedItem = AUIGrid.getCheckedRowItems(crcStatementGridID);
		var bankCheckedItem = AUIGrid.getCheckedRowItems(crcStatementGridID);
		
    	var item = new Object();
		
    	var curDate = new Date();
    	
		item.crcStateId = AUIGrid.getCellValue(crcStatementGridID, crcCheckedItem[0].rowIndex , "crcStateId");
		item.fTrnscId = AUIGrid.getCellValue(bankStatementGridID, bankCheckedItem[0].rowIndex, "fTrnscId");
		
		item.fTrnscDt = AUIGrid.getCellValue(bankStatementGridID, bankCheckedItem[0].rowIndex, "fTrnscDt");
		item.crcTrnscMid = AUIGrid.getCellValue(bankStatementGridID, bankCheckedItem[0].rowIndex, "mid");
		item.netAmt = AUIGrid.getCellValue(crcStatementGridID, crcCheckedItem[0].rowIndex, "netAmt");
		item.creditAmt = AUIGrid.getCellValue(bankStatementGridID, bankCheckedItem[0].rowIndex, "creditAmt");
		
		item.codeId = AUIGrid.getCellValue(bankStatementGridID, bankCheckedItem[0].rowIndex, "codeId");
		
		item.mappingDate = curDate.getDate() + "/" + (curDate.getMonth() +1) +"/" + curDate.getFullYear();
		
		console.log(item);
		AUIGrid.addRow(mappedGridID, item, "last");

		AUIGrid.removeRow(crcStatementGridID, crcCheckedItem[0].rowIndex);
		AUIGrid.removeRow(bankStatementGridID, bankCheckedItem[0].rowIndex);
		
		AUIGrid.removeSoftRows(crcStatementGridID);
		AUIGrid.removeSoftRows(bankStatementGridID);
    	
    }
    
    function fn_knockOff(){
    	Common.confirm("Are you sure you want to match this Payment & CRC items?",fn_updateMappingData);
    }
    
    function fn_updateMappingData(){
    	var data = {};
    	var gridList = AUIGrid.getGridData(mappedGridID);
    	data.all = gridList;
    	
    	Common.ajax("POST", "/payment/updateMappingData.do", data, function(result){
    		Common.alert(result.message);
    		fn_searchList();
    	});
    }
    
    function fn_clear(){
    	$("#searchForm")[0].reset();
    }
</script>
<!-- content start -->
<section id="content">
    <ul class="path">
        <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
        <li>Billing & Collection</li>
        <li>Card Payment</li>
        <li>Payment Matching Reconciliation</li>
    </ul>

    <!-- title_line start -->
    <aside class="title_line">
        <p class="fav"><a href="#" class="click_add_on">My menu</a></p>
        <h2>Payment Matching Reconciliation</h2>
        <ul class="right_btns">           
            <li><p class="btn_blue"><a href="javascript:fn_searchList();"><span class="search"></span>Search</a></p></li>
            <li><p class="btn_blue"><a href="javascript:fn_clear();"><span class="clear"></span>Clear</a></p></li>
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
        <li><p class="btn_blue2" id="mapping"><a href="javascript:fn_mapping();">Mapping</a></p></li>            
        <li><p class="btn_blue2" id="knockOff"><a href="javascript:fn_knockOff();">Knock-Off</a></p></li>
    </ul>

</section>
<!-- content end -->
