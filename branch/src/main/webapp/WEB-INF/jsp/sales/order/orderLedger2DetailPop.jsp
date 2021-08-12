<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>


<script type="text/javaScript" language="javascript">
    
    //AUIGrid 생성 후 반환 ID
    var  ordLedgerDetailGridID;
    
    var ordLdgDetailInfoList;
    
    $(document).ready(function(){
       	
       if('${ordLdgDetailInfoList}'=='' || '${ordLdgDetailInfoList}' == null){
       }else{
    	   ordLdgDetailInfoList  = JSON.parse('${ordLdgDetailInfoList}');           
       }   
        
        //AUIGrid 그리드를 생성합니다.
        createLdgDGrid();
        
    });
    
    function createLdgDGrid(){
        //AUIGrid 칼럼 설정
        var ordLdgDLayout = [
           {   dataField : "orNo",  headerText : 'Doc No',         width : 150, visible:false }
          ,{   dataField : "itmModeCode",  headerText : 'Paymode',         width : 70 }
          ,{   dataField : "payItmRefNo",  headerText : 'RefNo',         width : 110 }
          ,{   dataField : "itmCcTypeName",  headerText : 'CCType',         width : 100 }
          ,{   dataField : "payItmCcHolderName",  headerText : 'CCHolder',         width : 100 }
          ,{   dataField : "payItmCcExprDt",  headerText : 'CCExpiryDate',         width : 100 }
          ,{   dataField : "payItmChqNo",  headerText : 'ChequeNo',         width : 100 }
          ,{   dataField : "itmIssuBankName",  headerText : 'IssueBank',         width : 110 }
          ,{   dataField : "payItmAmt",  headerText : 'Amount',         width : 100 , dataType : "numeric", formatString : "#,##0.00" }
          ,{   dataField : "payItmIsOnline",  headerText : 'CRCMode',         width : 80 }
          ,{   dataField : "itmBankAccCode",  headerText : 'Account Code',         width : 110 }
          ,{   dataField : "payItmRefDt",  headerText : 'RefDate',         width : 100 }
          ,{   dataField : "payItmAppvNo",  headerText : 'ApprNo',         width : 100 }
          ,{   dataField : "payItmRem",  headerText : 'Remark',         width : 100 }
          ,{   dataField : "payItmBankChrgAmt",  headerText : 'BankCharge',         width : 100 ,dataType : "numeric", formatString : "#,##0.00" }
        	
        ];

     //그리드 속성 설정
     var ordLdgDGridPros = {
         usePaging           : false,             //페이징 사용
         pageRowCount        : 20,           //한 화면에 출력되는 행 개수 20(기본값:20)            
         editable                : false,        
         showStateColumn     : false,         
         showRowNumColumn    : false,  
         selectionMode       : "singleRow"  //"multipleCells",   
     };
     
     ordLedgerDetailGridID = GridCommon.createAUIGrid("ord_ledger_detail_grid", ordLdgDLayout, "", ordLdgDGridPros);
     
     if(ordLdgDetailInfoList  != '' ){
         AUIGrid.setGridData(ordLedgerDetailGridID, ordLdgDetailInfoList );
     } 
 }  
</script>    
<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Order Ledger Detail</h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="ord_ledger_detail_grid" style="width:100%; height:200px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->