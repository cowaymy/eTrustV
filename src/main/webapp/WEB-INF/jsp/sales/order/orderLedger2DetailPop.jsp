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
          ,{   dataField : "itmModeCode",  headerText : 'Paymode',         width : 150 }
          ,{   dataField : "payItmRefNo",  headerText : 'RefNo',         width : 150 }
          ,{   dataField : "itmCcTypeName",  headerText : 'CCType',         width : 150 }
          ,{   dataField : "payItmCcHolderName",  headerText : 'CCHolder',         width : 150 }
          ,{   dataField : "payItmCcExprDt",  headerText : 'CCExpiryDate',         width : 150 }
          ,{   dataField : "payItmChqNo",  headerText : 'ChequeNo',         width : 150 }
          ,{   dataField : "itmIssuBankName",  headerText : 'IssueBank',         width : 150 }
          ,{   dataField : "payItmAmt",  headerText : 'Amount',         width : 150 , dataType : "numeric", formatString : "#,##0.00" }
          ,{   dataField : "payItmIsOnline",  headerText : 'CRCMode',         width : 150 }
          ,{   dataField : "itmBankAccCode",  headerText : 'Account Code',         width : 150 }
          ,{   dataField : "payItmRefDt",  headerText : 'RefDate',         width : 150 }
          ,{   dataField : "payItmAppvNo",  headerText : 'ApprNo',         width : 150 }
          ,{   dataField : "payItmRem",  headerText : 'Remark',         width : 150 }
          ,{   dataField : "payItmBankChrgAmt",  headerText : 'BankCharge',         width : 150 ,dataType : "numeric", formatString : "#,##0.00" }
        	
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