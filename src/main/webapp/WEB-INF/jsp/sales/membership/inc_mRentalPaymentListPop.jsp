
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">

var mRPayGrid;
var mRPayDetailGrid;

$(document).ready(function(){  
    
    createMRPayGridGrid();  
    AUIGrid.resize(mRPayGrid, 940,300);
    
    createMRPayDetailGridGrid();  
    AUIGrid.resize(mRPayDetailGrid, 940,250);
   
});


function createMRPayGridGrid(){
	    
    var cLayout = [
	                   
		{
			    dataField : " ",
			    headerText : " ",
			    width : 30 ,
			    renderer : {
			        type : "IconRenderer",
			        iconPosition : "aisleRight",  // 아이콘 위치 
			        iconTableRef :  { // icon 값 참조할 테이블 레퍼런스  
			            "default" :"${pageContext.request.contextPath}/resources/images/common/icon_grid_detail.png" // default
			        },
			        onclick : function(rowIndex, columnIndex, value, item) {
			        	fn_getmRPayDetailGridAjax(item);
			        }
			    }
		}, 

         {dataField : "orNo",headerText : "<spring:message code="sal.title.receiptNo" />", width : 100 ,editable : false},
         {dataField : "stkDesc", headerText : "<spring:message code="sal.title.reverseFor" />", width : 100 ,editable : false},
         {dataField : "payData", headerText : "<spring:message code="sal.title.payDate" />", width :100  ,dataType : "date", formatString : "dd-mm-yyyy" ,editable : false },
         {dataField : "codeDesc", headerText : "<spring:message code="sal.title.payType" />", width :240 ,editable : false},
         {dataField : "accCode", headerText : "<spring:message code="sal.title.debtorAcc" />", width :100 ,editable : false},
         {dataField : "code", headerText : "<spring:message code="sal.title.keyInBranchCode" />",width :100 ,editable : false},
         {dataField : "name1", headerText : "<spring:message code="sal.title.keyInBranchName" />",width :100 ,editable : false},
         {dataField : "totAmt", headerText : "<spring:message code="sal.title.totAmt" />",width :100  ,dataType : "number", formatString : "#,000.00" ,editable : false},
         {dataField : "userName", headerText : "<spring:message code="sal.title.creator" />",width :100, editable : false }
   ];
    
    var gridPros = { usePaging : true,  pageRowCount: 20, editable: false, fixedColumnCount :1,  showRowNumColumn : true};  
    mRPayGrid = GridCommon.createAUIGrid("#pay_grid_wrap", cLayout,'' ,gridPros); 
}




function createMRPayDetailGridGrid(){
        
    var cLayout = [
         
         {dataField : "codeName",headerText : "<spring:message code="sal.title.paymode" />", width : 100 ,editable : false},
         {dataField : "payItmAmt", headerText : "<spring:message code="sal.title.amount" />", width : 100 ,dataType : "number", formatString : "#,000.00" ,editable : false},
         {dataField : "name", headerText : "<spring:message code="sal.title.issueBank" />", width :100  },
         {dataField : "c2", headerText : "<spring:message code="sal.title.accCode" />", width :100 ,editable : false},
         {dataField : "accDesc", headerText : "<spring:message code="sal.title.accName" />", width :100 ,editable : false},
         {dataField : "payItmRefDt", headerText : "<spring:message code="sal.title.refDate" />",width :100 ,editable : false ,dataType : "date", formatString : "dd-mm-yyyy"  },
         {dataField : "payItmRem", headerText : "<spring:message code="sal.title.remark" />",width :250 ,editable : false}
   ];
    
    var gridPros = { usePaging : true,  pageRowCount: 20, editable: false, fixedColumnCount :1, showRowNumColumn : true};  
    mRPayDetailGrid = GridCommon.createAUIGrid("#pay_detail_grid_wrap", cLayout,'' ,gridPros); 
}


function fn_getmRPayGridAjax (o){
	
      Common.ajax("GET", "/sales/membershipRental/paymentList",{SVC_CNTRCT_ID:o.SRV_CNTRCT_ID}, function(result) {
         console.log(result);
         AUIGrid.setGridData(mRPayGrid, result);
      });
}


function fn_getmRPayDetailGridAjax (item){
    
    Common.ajax("GET", "/sales/membershipRental/paymenDetailtList",{PAY_ID:item.payId}, function(result) {
       console.log(result);
       AUIGrid.setGridData(mRPayDetailGrid, result);
    });
}


</script>





<article class="tap_area"><!-- tap_area start -->
    <article class="grid_wrap"><!-- grid_wrap start -->
        <div id="pay_grid_wrap" style="width:100%; height:300px; margin:0 auto;"></div>  
    </article><!-- grid_wrap end -->
    
    <article class="grid_wrap"><!-- grid_wrap start -->
        <div id="pay_detail_grid_wrap" style="width:100%; height:310px; margin:0 auto;"></div>  
    </article><!-- grid_wrap end -->
    
</article><!-- tap_area end -->

